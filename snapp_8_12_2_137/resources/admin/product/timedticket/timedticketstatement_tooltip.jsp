<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_SaleItem2TimedTicketStatement.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTooltip" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_SaleItem2TimedTicketStatement.class);
// Select
qdef.addSelect(Sel.TiemdTicketStatementId);
qdef.addSelect(Sel.TicketId);
qdef.addSelect(Sel.TicketCode);
qdef.addSelect(Sel.TiemdTicketStatementId);
qdef.addSelect(Sel.StatementAmount);
// Filter
qdef.addFilter(Fil.SaleItemId, pageBase.getNullParameter("SaleItemId"));
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<style>

.statement-ref-grid {
  width: 100%;
  border-collapse: collapse;
}

.statement-ref-grid td {
  padding: 3px;
}

.statement-ref-items td {
  border-bottom: 1px #efefef solid;
  font-weight: bold;
}

.statement-ref-items tr:last-child td {
  border-bottom: none;
}

.statement-ref-footer td {
  border-top: 1px #aaaaaa solid;
}

</style>

<div style="min-width:270px; max-height:200px; overflow-y:auto">

<table class="statement-ref-grid">
  <tbody class="statement-ref-items">
  <v:ds-loop dataset="<%=ds%>">
    <tr>
      <td nowrap><a href="<v:config key="site_url"/>/admin?page=ticket&id=<%=ds.getField(Sel.TicketId).getHtmlString()%>"><%=ds.getField(Sel.TicketCode).getHtmlString()%></a></td>
      <td nowrap align="right"><%=pageBase.formatCurrHtml(ds.getField(Sel.StatementAmount))%></td>
    </tr>
  </v:ds-loop>
  </tbody>
</table>

</div>