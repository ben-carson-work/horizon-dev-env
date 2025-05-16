<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_PaymentProfile.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
QueryDef qdef = new QueryDef(QryBO_PaymentProfile.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.CommonStatus);
qdef.addSelect(Sel.PaymentProfileId);
qdef.addSelect(Sel.PaymentProfileCode);
qdef.addSelect(Sel.PaymentProfileName);
qdef.addSelect(Sel.Active);
// Sort
qdef.addSort(Sel.PaymentProfileName);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid id="paymentprofile-grid-table" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.PaymentProfile%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td width="100%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Code"/>
      </td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row dataset="ds">
      <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="PaymentProfileId" dataset="ds" fieldname="PaymentProfileId"/></td>
      <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
      <td>
        <a href="<v:config key="site_url"/>/admin?page=paymentprofile&id=<%=ds.getField(QryBO_PaymentProfile.Sel.PaymentProfileId).getEmptyString()%>" class="list-title"><%=ds.getField(QryBO_PaymentProfile.Sel.PaymentProfileName).getHtmlString()%></a><br/>
        <span class="list-subtitle"><%=ds.getField(Sel.PaymentProfileCode).getHtmlString()%></span>&nbsp;
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
