<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
	QueryDef qdef = new QueryDef(QryBO_LedgerAccount.class);
	qdef.addSelect(QryBO_LedgerAccount.Sel.LedgerAccountId);
	qdef.addSelect(QryBO_LedgerAccount.Sel.LedgerAccountCode);
	qdef.addSelect(QryBO_LedgerAccount.Sel.LedgerAccountName);
	qdef.addSort(QryBO_LedgerAccount.Sel.LedgerAccountCode);
	qdef.addFilter(QryBO_LedgerAccount.Fil.LedgerAccountLevel, LkSNLedgerAccountLevel.SubAccount.getCode());
	JvDataSet dsLedgerAccount = pageBase.execQuery(qdef);
	
	JvDataSet dsLocations = pageBase.getBL(BLBO_Account.class).getLocationDS();
	
%>

<v:widget caption="@Common.Settings">
  <v:widget-block>
    TBI
  </v:widget-block>
</v:widget>

<script>

function getPluginSettings() {
 
  return {
	};
}
</script>