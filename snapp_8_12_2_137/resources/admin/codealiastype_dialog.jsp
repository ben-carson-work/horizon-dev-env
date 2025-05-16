<%@page import="com.vgs.snapp.dataobject.DOCodeAliasType"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
String codeAliasTypeId = pageBase.getParameter("id");
BLBO_CodeAlias bl = pageBase.getBL(BLBO_CodeAlias.class);
DOCodeAliasType codeAliasType = pageBase.isNewItem() ? new DOCodeAliasType() : bl.loadCodeAliasType(codeAliasTypeId); 
request.setAttribute("codeAliasType", codeAliasType);

boolean isSystemCode = codeAliasType.CodeAliasTypeCode.getEmptyString().startsWith("#");
%>

<v:dialog id="codealiastype_dialog" title="@Common.CodeAliasTypes" tabsView="true" width="800" height="600">

<script>
  $(document).ready(function(){
    $("#codealiastype_dialog .tabs").tabs();
    var dlg = $("#codealiastype_dialog");
    dlg.on("snapp-dialog", function(event, params) {
      params.buttons = [
        {
          text: <v:itl key="@Common.Save" encode="JS"/>,
          click: doSave,
        }, 
        {
          text: <v:itl key="@Common.Cancel" encode="JS"/>,
          click: doCloseDialog
        }                     
      ];
    });
  });

  function doSave() {
    var reqDO = {
      Command: "SaveCodeAliasType",
      SaveCodeAliasType: {
        CodeAliasTypeId : <%=codeAliasType.CodeAliasTypeId.isNull() ? null : "\"" + codeAliasType.CodeAliasTypeId.getHtmlString() + "\""%>,
        CodeAliasTypeCode : $("#codeAliasType\\.CodeAliasTypeCode").val(),
        CodeAliasTypeName: $("#codeAliasType\\.CodeAliasTypeName").val(),
        UniquePerObject: $("[name='codeAliasType\\.UniquePerObject']").isChecked(),
        ReplaceExisting: $("[name='codeAliasType\\.ReplaceExisting']").isChecked()
      }
    };
   
    vgsService("CodeAlias", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.CodeAliasType.getCode()%>);
      $("#codealiastype_dialog").dialog("close");
    });
   }
</script>

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="codealiastype-tab-profile" caption="@Common.Profile" icon="profile.png" default="true">
    <div class="tab-content">
      <v:widget caption="@Common.General">
        <v:widget-block>
          <v:form-field caption="@Common.Code" mandatory="true">
            <v:input-text field="codeAliasType.CodeAliasTypeCode" enabled="<%=!isSystemCode%>" />
          </v:form-field>
          <v:form-field caption="@Common.Name" mandatory="true">
            <v:input-text field="codeAliasType.CodeAliasTypeName" enabled="<%=!isSystemCode%>" />
          </v:form-field>
        </v:widget-block>
        <v:widget-block>
          <v:form-field caption="@Common.Options" clazz="form-field-optionset">
            <div><v:db-checkbox field="codeAliasType.UniquePerObject" caption="@Common.UniquePerObject" hint="@Common.UniquePerObjectHint" value="true" enabled="<%=!isSystemCode%>"/></div>            
            <div><v:db-checkbox field="codeAliasType.ReplaceExisting" caption="@Common.ReplaceExisting" hint="@Common.ReplaceExistingHint" value="true" enabled="<%=!isSystemCode%>"/></div>            
          </v:form-field>
        </v:widget-block>          
      </v:widget>
    </div>
  </v:tab-item-embedded>

  <% if(!pageBase.isNewItem()) { %>
    <v:tab-item-embedded tab="codealiastype-tab-history" caption="@Common.History" fa="history">
      <jsp:include page="./common/page_tab_historydetail.jsp"/>
    </v:tab-item-embedded>
  <% } %>
</v:tab-group>

</v:dialog>
