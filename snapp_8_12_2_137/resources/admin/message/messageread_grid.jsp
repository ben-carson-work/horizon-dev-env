<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_MessageRead.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_MessageRead.class);
// Select
qdef.addSelect(Sel.UserAccountId);
qdef.addSelect(Sel.UserAccountEntityType);
qdef.addSelect(Sel.UserAccountIconName);
qdef.addSelect(Sel.UserAccountProfilePictureId);
qdef.addSelect(Sel.UserAccountName);
qdef.addSelect(Sel.ReadDateTime);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Filter
qdef.addFilter(Fil.MessageId, pageBase.getParameter("MessageId"));
// Sort
qdef.addSort(Sel.ReadDateTime);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Message%>">
  <thead>
    <tr>
      <td>&nbsp;</td>
      <td width="100%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.DateTime"/>
      </td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row dataset="ds">
      <td><v:grid-icon name="<%=ds.getField(Sel.UserAccountIconName).getString()%>" repositoryId="<%=ds.getField(Sel.UserAccountProfilePictureId).getString()%>"/></td>
      <td>
        <snp:entity-link entityId="<%=ds.getField(Sel.UserAccountId).getString()%>" entityType="<%=ds.getField(Sel.UserAccountEntityType)%>">
          <%=ds.getField(Sel.UserAccountName).getHtmlString()%>
        </snp:entity-link>
        <br/>
        <snp:datetime timestamp="<%=ds.getField(Sel.ReadDateTime)%>" format="shortdatetime" timezone="local"/>&nbsp;
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
    