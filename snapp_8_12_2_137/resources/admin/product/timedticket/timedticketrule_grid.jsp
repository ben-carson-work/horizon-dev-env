<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_TimedTicketRule.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
QueryDef qdef = new QueryDef(QryBO_TimedTicketRule.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.TimedTicketRuleId);
qdef.addSelect(Sel.RuleName);
qdef.addSelect(Sel.ValidFromDate);
qdef.addSelect(Sel.ValidToDate);
// Filter
if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getParameter("FullText"));
if (pageBase.getNullParameter("TimedTicketRuleId") != null)
  qdef.addFilter(Fil.TimedTicketRuleId, pageBase.getNullParameter("TimedTicketRuleId"));

// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.TimedTicketRule%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="30%">
      <v:itl key="@Common.Name"/><br/>
    </td>
    <td>
      <v:itl key="@Common.FromDate"/><br/>
    </td>
    <td>
      <v:itl key="@Common.ToDate"/>
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <td width="20px"><v:grid-checkbox name="TimedTicketRuleId" dataset="ds" fieldname="TimedTicketRuleId"/></td>
    <td width="40px"><v:grid-icon name="<%=ds.getField(QryBO_TimedTicketRule.Sel.IconName).getString()%>"/></td>
    <td>
      <a href="javascript:asyncDialogEasy('product/timedticket/timedticketrule_dialog', 'id=<%=ds.getField(Sel.TimedTicketRuleId).getEmptyString()%>')" class="list-title"><%=ds.getField(Sel.RuleName).getHtmlString()%></a>
    </td>
    <td>
      <% ds.getField(QryBO_TimedTicketRule.Sel.ValidFromDate).setDisplayFormat(pageBase.getShortDateFormat()); %>
      <span class="list-title"><%=ds.getField(QryBO_TimedTicketRule.Sel.ValidFromDate).getHtmlString()%></span>
    </td>
    <td>
      <% ds.getField(QryBO_TimedTicketRule.Sel.ValidToDate).setDisplayFormat(pageBase.getShortDateFormat()); %>
      <span class="list-title"><%=ds.getField(QryBO_TimedTicketRule.Sel.ValidToDate).getHtmlString()%></span>
    </td>
  </v:grid-row>
</v:grid>
