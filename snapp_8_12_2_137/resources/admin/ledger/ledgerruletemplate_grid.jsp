<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.cl.lookup.LookupItem"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_LedgerRuleTemplate.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_LedgerRuleTemplate.class);
// Select
qdef.addSelect(QryBO_LedgerRuleTemplate.Sel.IconName);
qdef.addSelect(QryBO_LedgerRuleTemplate.Sel.CommonStatus);
qdef.addSelect(QryBO_LedgerRuleTemplate.Sel.LedgerRuleTemplateId);
qdef.addSelect(QryBO_LedgerRuleTemplate.Sel.LedgerRuleTemplateCode);
qdef.addSelect(QryBO_LedgerRuleTemplate.Sel.LedgerRuleTemplateName);
qdef.addSelect(QryBO_LedgerRuleTemplate.Sel.Enabled);
qdef.addSelect(QryBO_LedgerRuleTemplate.Sel.TagNames);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
//Filter
if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getNullParameter("FullText"));
if ((pageBase.getNullParameter("CategoryId") != null) && !pageBase.isParameter("CategoryId", "all"))
  qdef.addFilter(Fil.CategoryId, pageBase.getNullParameter("CategoryId"));
// Sort
qdef.addSort(QryBO_LedgerRuleTemplate.Sel.LedgerRuleTemplateName);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid id="ledger-profile-grid-table" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.LedgerRuleTemplate%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="50%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Code"/>
    </td>
    <td width="50%" align="right">
      <v:itl key="@Common.Tags"/>
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="cbLedgerRuleTemplateId" dataset="ds" fieldname="LedgerRuleTemplateId"/></td>
    <td><v:grid-icon name="<%=ds.getField(QryBO_LedgerRuleTemplate.Sel.IconName).getString()%>"/></td>
    <td>
      <a href="<v:config key="site_url"/>/admin?page=ledgerruletemplate&id=<%=ds.getField(QryBO_LedgerRuleTemplate.Sel.LedgerRuleTemplateId).getEmptyString()%>" class="list-title"><%=ds.getField(QryBO_LedgerRuleTemplate.Sel.LedgerRuleTemplateName).getHtmlString()%></a><br/>
      <span class="list-subtitle"><%=ds.getField(QryBO_LedgerRuleTemplate.Sel.LedgerRuleTemplateCode).getHtmlString()%></span>
    </td>
    <td align="right"><span class="list-subtitle"><%=ds.getField(QryBO_LedgerRuleTemplate.Sel.TagNames).getHtmlString()%></span></td>
  </v:grid-row>
</v:grid>
