<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PagePaymentSetup" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<div class="tab-toolbar">
  <% String hrefNew = ConfigTag.getValue("site_url") + "/admin?page=currency&id=new"; %>
  <v:button caption="@Common.New" fa="plus" href="<%=hrefNew%>" enabled="<%=rights.SettingsPayments.getBoolean()%>"  />
  <span class="divider"></span>
  <v:button caption="@Common.Import" fa="sign-in" onclick="showImportDialog()"/>
  <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" bindGrid="taxprofile-grid"  onclick="exportCurrency()"/>
  <span class="divider"></span>
  <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.Currency.getCode() + ")";%>
  <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/>
  <v:pagebox gridId="currency-grid"/>
</div>
    
<div class="tab-content">
  <v:async-grid id="currency-grid" jsp="payment/currency_grid.jsp" />
</div>

<script>
function showImportDialog() {
  asyncDialogEasy("payment/currency_snapp_import_dialog", "");
}
            
function exportCurrency() {
  var bean = getGridSelectionBean("#currency-grid-table", "[name='CurrencyId']");
  if (bean) 
    window.location = BASE_URL + "/admin?page=export&EntityIDs=" + bean.ids + "&EntityType=<%=LkSNEntityType.Currency.getCode()%> + &QueryBase64=" + bean.queryBase64;
}
</script>
