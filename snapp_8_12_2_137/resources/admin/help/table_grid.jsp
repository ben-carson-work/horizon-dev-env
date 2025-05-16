<%@page import="java.text.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
String filter = pageBase.getNullParameter("FullText");
LookupItem tableStatSort = LkSN.TableStatSort.getItemByCode(pageBase.getNullParameter("SortBy"), LkSNTableStatSort.Name);
String sorttype = JvString.coalesce(pageBase.getNullParameter("SortType"), "ASC");
List<DOSchemaTableRef> list = pageBase.getBL(BLBO_SchemaTable.class).getTableList(filter, tableStatSort, sorttype);
int count = 0;
long total = 0;
%>

<style>

.table-total {
  font-weight: bold; 
  background-color: #cecece;
}
</style>

<v:grid>
  <v:grid-title caption="Tables"/>
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td align="right"></td>
    <td width="55%">Name</td>
    <td width="25%" align="right">Records<br/>Per record occupation</td>
    <td width="20%" align="right">Occupation<br/>(Free)</td>
  </tr>
  <% for (DOSchemaTableRef table : list) { %>
    <tr class="grid-row">
      <% DecimalFormat fmt = new DecimalFormat("#,##0");%>
      <% count++; %>
      <% total += table.TotalSpace.getLong(); %>
      <td><v:grid-checkbox name="TableName" value="<%=table.TableName.getHtmlString()%>"/></td>
      <td align="right"><v:grid-icon name="fa-database"/></td>
      <td>
        <div class="list-title"><a href="<v:config key="site_url"/>/admin?page=schematable&table=<%=table.TableName.getHtmlString()%>"><%=table.TableName.getHtmlString()%></a></div>
        <div class="list-subtitle"><%=JvString.escapeHtml(JvString.truncSmart(table.TableDescription.getEmptyString().replaceAll("\n", " "), 100))%></div>
      </td>
      <td align="right">
        <%=fmt.format(table.RowCount.getLong())%>
        <br/>
        <span class="list-subtitle"><%=JvString.escapeHtml(JvString.getSmoothSize(table.SpacePerRec.getLong()))%></span>
      </td>
      <td align="right">
        <%=JvString.escapeHtml(JvString.getSmoothSize(table.TotalSpace.getLong()))%>
        <br/>
        <% if (table.UnusedSpace.getLong() > 0) { %>
          <span class="list-subtitle">(<%=JvString.escapeHtml(JvString.getSmoothSize(table.UnusedSpace.getLong()))%>)</span>
        <% } %>
      </td>
    </tr>
  <% } %>
  <tr>
    <td class="table-total" colspan="3">Total (count: <%=count%>)</td>
    <td class="table-total" colspan="3" align="right"><%=JvString.escapeHtml(JvString.getSmoothSize(total))%></td>
  </tr>
</v:grid>
  