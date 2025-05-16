<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>

<%
int[] defaultStatusFilter = LookupManager.getIntArray(LkSNInstallmentContractStatus.Active, LkSNInstallmentContractStatus.ManuallyBlocked, LkSNInstallmentContractStatus.AutomaticallyBlocked); 
%>

<script>
  function search() {
    setGridUrlParam("#instcontr-grid", "InstallmentContractStatus", $("[name='InstallmentContractStatus']").getCheckedValues());
    changeGridPage("#instcontr-grid", "first");
  }
</script>

<div class="tab-toolbar">
  <v:button caption="@Common.Search" fa="search" href="javascript:search()" />
  <v:pagebox gridId="instcontr-grid"/>
</div>

<div class="tab-content">
  <v:last-error/>
  <div class="profile-pic-div">
    <v:widget caption="@Common.Status">
      <v:widget-block>
      <% for (LookupItem status : LkSN.InstallmentContractStatus.getItems()) { %>
        <v:db-checkbox field="InstallmentContractStatus" caption="<%=status.getDescription(pageBase.getLang())%>" value="<%=String.valueOf(status.getCode())%>" checked="<%=JvArray.contains(status.getCode(), defaultStatusFilter)%>" /><br/>
      <% } %>
      </v:widget-block>
    </v:widget>
  </div>
  <div class="profile-cont-div">
    <% String params = "AccountId=" + pageBase.getId() + "&InstallmentContractStatus=" + JvArray.arrayToString(defaultStatusFilter, ",");%>
    <v:async-grid id="instcontr-grid" jsp="installment/contract_grid.jsp" params="<%=params%>"/>
  </div>
</div>
