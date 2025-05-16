<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccountTabAcArea" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
JvDataSet ds = (JvDataSet)request.getAttribute("ds"); 
boolean canCreate = rights.SystemSetupAccessPoints.getOverallCRUD().canCreate(); 
boolean canDelete = rights.SystemSetupAccessPoints.getOverallCRUD().canDelete(); 
%>

<v:page-form page="account">
<div class="tab-toolbar">
  <% String hrefNew = "admin?page=account&id=new&ParentAccountId=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.AccessArea.getCode(); %>
  <v:button caption="@Common.New" fa="plus" href="<%=hrefNew%>" enabled="<%=canCreate%>"/>
  <v:button caption="@Common.Delete" fa="trash" href="javascript:deleteAcAreas()" enabled="<%=canDelete%>"/>
  
  <span class="divider"></span>
  <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.AccessArea.getCode() + ")";%>
  <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/> 
  
  <v:pagebox gridId="acarea-grid"/>
</div>

<div class="tab-content">
  <% String params = "LocationId=" + pageBase.getId(); %>
  <v:async-grid jsp="account/acarea_grid.jsp" id="acarea-grid" params="<%=params%>"/>
</div>

<script>
function deleteAcAreas() {
  var ids = $("[name='cbAccountId']").getCheckedValues();
  if (ids == "")
    showMessage(<v:itl key="@Common.NoElementWasSelected" encode="JS"/>);
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteAccount",
        DeleteAccount: {
          AccountIDs: ids
        }
      };
      
      vgsService("Account", reqDO, false, function(ansDO) {
        showAsyncProcessDialog(ansDO.Answer.DeleteAccount.AsyncProcessId);
      });
    });
  }
}
</script>

</v:page-form>