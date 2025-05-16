<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<div class="tab-toolbar">
  <% String hRef = "asyncDialogEasy('opentab/opentab_table_dialog', 'id=new&OpAreaId=" + pageBase.getId() + "')";%>
  <v:button fa="plus" caption="@Common.New" onclick="<%=hRef%>"/>
  <v:button fa="trash" caption="@Common.Delete" onclick="doDeleteTables()"/>
  <v:pagebox gridId="opentab-saletable-grid"/>
</div>

<div class="tab-content">
  <% String params = "OpAreaId=" + pageBase.getId(); %>
  <v:async-grid id="opentab-saletable-grid" jsp="opentab/opentab_table_grid.jsp" params="<%=params%>"/>
</div>

<script>
function doDeleteTables() {
	var ids = $("[name='TableId']").getCheckedValues();
  if (ids == "")
    showMessage("<v:itl key="@Common.NoElementWasSelected" encode="UTF-8"/>");
  else {
    confirmDialog(null, function() {
    	reqDO = {
    		  Command: "DeleteTables",
    		  DeleteTables: {
	          TableIDs: ids
 		      }
    	};
    		    
    	vgsService("Opentab", reqDO, false, function(ansDO) {
    	  triggerEntityChange(<%=LkSNEntityType.OpentabTable.getCode()%>, null);
    	});
    	
    });  
  }
}
</script>
