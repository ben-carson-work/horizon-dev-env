<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_RewardPoint.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_RewardPoint.class).addSelect(
    Sel.IconName, 
    Sel.CommonStatus,
    Sel.MembershipPointId,
    Sel.MembershipPointCode,
    Sel.MembershipPointName,
    Sel.ValidityTypeDesc);

qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
//Filter
if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getNullParameter("FullText"));
// Sort
qdef.addSort(Sel.SystemCode, false);
qdef.addSort(Sel.MembershipPointName);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.RewardPoint%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td width="80%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Code"/>
      </td>
      <td width="20%">
        <v:itl key="@Common.Type"/>
      </td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row dataset="ds">
      <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="MembershipPointId" dataset="ds" fieldname="MembershipPointId"/></td>
      <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
      <td>
        <a href="<v:config key="site_url"/>/admin?page=membershippoint&id=<%=ds.getField(QryBO_RewardPoint.Sel.MembershipPointId).getEmptyString()%>" class="list-title"><%=ds.getField(QryBO_RewardPoint.Sel.MembershipPointName).getHtmlString()%></a><br/>
        <span class="list-subtitle"><%=ds.getField(Sel.MembershipPointCode).getHtmlString()%></span>&nbsp;
      </td>
      <td>
        <%=ds.getString(Sel.ValidityTypeDesc)%>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
    