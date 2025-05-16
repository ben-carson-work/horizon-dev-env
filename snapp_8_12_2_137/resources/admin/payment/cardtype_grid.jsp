<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_CardType.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
QueryDef qdef = new QueryDef(QryBO_CardType.class);
// Select
qdef.addSelect(Sel.CommonStatus);
qdef.addSelect(Sel.CardTypeId);
qdef.addSelect(Sel.CardTypeCode);
qdef.addSelect(Sel.CardTypeName);
qdef.addSelect(Sel.CardTypeStatus);
// Sort
qdef.addSort(Sel.CardTypeName);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.CardType%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td width="100%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Code"/>
      </td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row dataset="ds">
      <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="CardTypeId" dataset="ds" fieldname="CardTypeId"/></td>
      <td>
        <% String hrefNew = "javascript:asyncDialogEasy('payment/cardtype_dialog', 'id=" + ds.getField(Sel.CardTypeId).getEmptyString() + "')";%>
        <a href="<%=hrefNew%>" class="list-title"><%=ds.getField(Sel.CardTypeName).getHtmlString()%></a><br/>
        <span class="list-subtitle"><%=ds.getField(Sel.CardTypeCode).getHtmlString()%></span>&nbsp;
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
