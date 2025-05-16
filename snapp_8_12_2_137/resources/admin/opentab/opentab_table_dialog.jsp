<%@page import="com.vgs.snapp.dataobject.DOOpentabTable"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
  String opAreaAccountId = pageBase.getNullParameter("OpAreaId");
  DOOpentabTable table = new DOOpentabTable();

  if (!pageBase.isNewItem()) 
    table = pageBase.getBL(BLBO_Opentab.class).loadTable(pageBase.getId());
  else
    table.TableStatus.setLkValue(LkSNTableStatus.Available);
  
  request.setAttribute("table", table);
%>

<v:dialog id="table-dialog" width="600" height="350" title="@OpenTab.Table">
  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="@Common.Code" mandatory="true">
        <v:input-text field="table.TableCode"/>
      </v:form-field>
      <v:form-field caption="@Common.Name" mandatory="true">
        <v:input-text field="table.TableName"/>
      </v:form-field>
      <v:form-field caption="@Common.Status" mandatory="true">
        <v:lk-combobox lookup="<%=LkSN.TableStatus%>" field="table.TableStatus" allowNull="false"/>
      </v:form-field>
      <v:form-field caption="@OpenTab.Seats" hint="@OpenTab.SeatsHint" mandatory="true">
        <v:input-text field="table.Quantity"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
    
<script>
  var dlg = $("#table-dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
      <v:itl key="@Common.Save" encode="JS"/>: doSaveTable,
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    };
  });
  
function doSaveTable() {
	checkRequired("#table-dialog", function() {
		var value = parseInt($("#table\\.Quantity").val());
		if (isNaN(value) || (value <= 0))
      showMessage(<v:itl key="@OpenTab.SeatsError" encode="JS"/>);
	  else {
	  	showWaitGlass();
		  var tableId = null;
	    <% if (!pageBase.isNewItem()) { %>
	      tableId = <%=JvString.jsString(pageBase.getId())%>;
	    <% } %>

		  var reqDO = {
			    Command: "SaveTable",
			    SaveTable: {
			    	Table: {
			    		TableId: tableId,
			    		TableCode: $("#table\\.TableCode").val(),
			    		TableName: $("#table\\.TableName").val(),
			    		TableStatus: $("#table\\.TableStatus").val(),
	            OpAreaAccountId: <%=JvString.jsString(opAreaAccountId)%>,
	            Quantity: $("#table\\.Quantity").val()
	          }
	        }
	    }
			
	    vgsService("Opentab", reqDO, false, function(ansDO) {
	    	hideWaitGlass();
     	  triggerEntityChange(<%=LkSNEntityType.OpentabTable.getCode()%>);
        dlg.dialog("close");
	    });
	  }
  }) ;
}  

$(document).ready(function() {
	  var sel = $("#table\\.TableStatus");
	  <% if (!table.TableStatus.isLookup(LkSNTableStatus.Available, LkSNTableStatus.OutOfOrder)) { %>
      $("#table\\.TableStatus").attr('disabled', true);
    <% } %>
	  
	  $(sel).find("option").each(function(i){
	    if ($(this).val() == <%=table.TableStatus.getSqlString()%>)
	      $(this).attr("selected", true);
      <% if (table.TableStatus.isLookup(LkSNTableStatus.Available, LkSNTableStatus.OutOfOrder)) { %>
        if (($(this).val() != <%=LkSNTableStatus.Available.getCode()%>) && ($(this).val() != <%=LkSNTableStatus.OutOfOrder.getCode()%>)) 
	        $(this).attr("disabled", true);
	    <% } %>
	  });
	});

</script>

</v:dialog>