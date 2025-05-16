<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_DocTemplate.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_DocTemplate.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.DocTemplateId);
qdef.addSelect(Sel.DocTemplateNameITL);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Sort
qdef.addSort(Sel.DocTemplateNameITL);
// Where
qdef.addFilter(Fil.DocTemplateType, LkSNDocTemplateType.StatReport.getCode());
qdef.addFilter(Fil.ForWorkstationId, pageBase.getSession().getWorkstationTreeIDs());
qdef.addFilter(Fil.ForUserAccountId, pageBase.getSession().getUserTreeIDs());

if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getNullParameter("FullText"));

// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<script>
function showReportExecDialog(id) {
  asyncDialogEasy("report/reportexec_dialog", "lock_in_params=true&p_AccountId=<%=pageBase.getSession().getOrgAccountId()%>&id=" + id);
}
</script>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>">
  <v:grid-row dataset="ds">
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
    <td width="100%" nowrap>
      <a href="javascript:showReportExecDialog('<%=ds.getField(Sel.DocTemplateId).getHtmlString()%>')" class="list-title"><%=ds.getField(Sel.DocTemplateNameITL).getHtmlString()%></a>
    </td>
  </v:grid-row>
</v:grid>
