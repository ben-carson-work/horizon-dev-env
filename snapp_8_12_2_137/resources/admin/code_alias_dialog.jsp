<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
boolean canEdit = true;
if (pageBase.getNullParameter("ReadOnly") != null)
  canEdit = pageBase.getNullParameter("ReadOnly").equals("false");

canEdit = canEdit && pageBase.getRights().CodeAliasEdit.getBoolean();

int entityType = JvString.strToIntDef(pageBase.getNullParameter("EntityType"), 0);

JvDataSet ds = pageBase.getBL(BLBO_CodeAlias.class).getCodeAliasListDS(pageBase.getId());
%>

<v:dialog id="code-alias-dialog" width="600" height="400" title="@Common.CodeAliases">

  <v:grid>
    <thead>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="50%"><v:itl key="@Common.Alias"/></td>
        <td width="50%"><v:itl key="@Common.AliasType"/></td>
      </tr>
    </thead>
    <tbody id="code-alias-body">
    </tbody>
    <tbody>
      <tr>
        <td colspan="100%">
          <v:button id="btn-add" caption="@Common.Add" fa="plus"  enabled="<%=canEdit%>"/>
          <v:button id="btn-remove" caption="@Common.Remove" fa="minus" enabled="<%=canEdit%>"/>
        </td>
      </tr>
    </tbody>
  </v:grid>

<div id="CodeAliasTypeIDs" class="hidden">
  <v:combobox field="CodeAliasTypeId" 
    lookupDataSet="<%=pageBase.getBL(BLBO_CodeAlias.class).getCodeAliasTypeDS()%>" 
    idFieldName="CodeAliasTypeId" 
    captionFieldName="CodeAliasTypeName"
    enabledFieldName="Enabled"
    allowNull="false"/>
</div>

<script>

$(document).ready(function() {

  var dlg = $("#code-alias-dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
   		Save : {
   			text: <v:itl key="@Common.Save" encode="JS"/>,
   			click: doSaveCodeAlias,
   			disabled: <%=!canEdit%>
   		},
   		Cancel : {
   			text: <v:itl key="@Common.Cancel" encode="JS"/>,
   			click: doCloseDialog
   		}
    };
  });
  
  dlg.find("#btn-add").click(function() {
    addAlias();
  });
  dlg.find("#btn-remove").click(function() {
    dlg.find(".cblist:checked").not(".header").closest("tr").remove();
  });

  <v:ds-loop dataset="<%=ds%>">
    addAlias(<%=ds.getField("CodeAlias").getSqlString()%>, <%=ds.getField("CodeAliasTypeId").getSqlString()%>);
  </v:ds-loop>
  
  function addAlias(code, codeId) {
    code = (code) ? code : "";
    var tr = $("<tr name='alias-tr' class='grid-row'/>").appendTo(dlg.find("#code-alias-body"));
    var tdCB = $("<td><input type='checkbox' class='cblist'></td>").appendTo(tr);
    var tdExtCode = $("<td><input type='text' name='code-alias' class='form-control'/></td>").appendTo(tr);
    var tdTypeId = $("<td></td>").appendTo(tr);
    var cbTypeId = $("#CodeAliasTypeIDs #CodeAliasTypeId").clone().appendTo(tdTypeId);
    cbTypeId.find("option[value="+codeId+"]").prop("selected", true);
    tdExtCode.find("input")
      .attr("placeholder", <v:itl key="@Common.Code" encode="JS"/>)
      .val(code)
      .focus();
  }
  
  function doSaveCodeAlias() {
    var doCodeAliasList = [];
    var codeAliasesUppercase = [[]];
    var doSave = true;
    
    dlg.find("[name='alias-tr']").each(function(i, input) {
      var codeAlias = $(input).find("[name='code-alias']").val();
      var codeAliasTypeId = $(input).find("#CodeAliasTypeId").val();
      var doCodeAlias = {};
      
      if (codeAlias) {
        if (codeAliasesUppercase.indexOf(codeAlias.toUpperCase() + '|' + codeAliasTypeId.toUpperCase()) == -1) {
          doCodeAlias["CodeAlias"] = codeAlias;
          doCodeAlias["CodeAliasTypeId"] = codeAliasTypeId;
          
          doCodeAliasList.push(doCodeAlias);
          codeAliasesUppercase.push(codeAlias.toUpperCase() + '|' + codeAliasTypeId.toUpperCase());
        }
        else {
          doSave = false;
          showMessage(<v:itl key="@Common.DuplicatedItem" encode="JS"/> + ": " + codeAlias, function() {
            $(input).focus();
          });
        }
      }
    });
    
    if (doSave) {
      var reqDO = {
        Command: "SaveCodeAliases",
        SaveCodeAliases: {
          EntityId: <%=JvString.jsString(pageBase.getId())%>,
          EntityType: <%=entityType%>,
          CodeAliasList: doCodeAliasList
        }
      }
      showWaitGlass();
      vgsService("CodeAlias", reqDO, false, function(ansDO) {
        hideWaitGlass();
        triggerEntityChange(<%=entityType%>);
        dlg.dialog("close");
      });
    }
  }  

});

</script>  

</v:dialog>