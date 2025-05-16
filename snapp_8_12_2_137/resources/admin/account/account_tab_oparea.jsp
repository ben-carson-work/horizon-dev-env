<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccountTabOpArea" scope="request"/>
<jsp:useBean id="ds" class="com.vgs.cl.JvDataSet" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
  boolean canCreate = rights.SystemSetupWorkstations.getOverallCRUD().canCreate() &&  rights.SystemSetupWorkstationDemographic.getBoolean();
  boolean canDelete = rights.SystemSetupWorkstations.getOverallCRUD().canDelete(); 
%>

<div class="tab-toolbar">
  <% String hrefNew = "admin?page=account&id=new&ParentAccountId=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.OperatingArea.getCode(); %>
  <v:button caption="@Common.New" fa="plus" href="<%=hrefNew%>" enabled="<%=canCreate%>"/>
  <v:button caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" href="javascript:deleteOpAreas()" enabled="<%=canDelete%>"/>
  
  <span class="divider"></span>
  <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.OperatingArea.getCode() + ")";%>
  <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/>
</div>

<div class="tab-content">
  <v:grid id="oparea-grid">
    <thead>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td>&nbsp;</td>
        <td width="100%">
          <v:itl key="@Common.Name"/><br/>
          <v:itl key="@Common.Code"/>
        </td>
      </tr>
    </thead>
     
    <tbody>
      <v:grid-row dataset="<%=ds%>">
      <tr>
        <td><v:grid-checkbox dataset="ds" name="cbAccountId" value="<%=ds.getField(QryBO_Account.Sel.AccountId).getString()%>"/></td>
        <td><img src="<v:image-link name="<%=ds.getField(QryBO_Account.Sel.IconName).getEmptyString()%>" size="32"/>"></td>
        <td>
          <snp:entity-link entityId="<%=ds.getField(QryBO_Account.Sel.AccountId)%>" entityType="<%=LkSNEntityType.OperatingArea%>" clazz="list-title">
            <%=ds.getField(QryBO_Account.Sel.DisplayName).getHtmlString()%>
          </snp:entity-link>
          <br/>
          <span class="list-subtitle"><%=ds.getField(QryBO_Account.Sel.AccountCode).getHtmlString()%></span>&nbsp;
        </td>
      </tr>
      </v:grid-row>
    </tbody>
  </v:grid>
</div>

<script>
function deleteOpAreas() {
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
        showAsyncProcessDialog(ansDO.Answer.DeleteAccount.AsyncProcessId, function() {
          window.location.reload();    
        });
      });
    });
  }
}

</script>
