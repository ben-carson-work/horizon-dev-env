<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Account.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.b2b.page.PageB2B_Dashboard" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_Account.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.ProfilePictureId);
qdef.addSelect(Sel.DisplayName);
// Filter
qdef.addFilter(Fil.AccountId, pageBase.getSession().getOrgAccountId());
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
%>

<style>
#account-name {
  font-size: 30px;
  line-height: 50px;
  text-align: center;
  color: black;
}
#account-logo {
  width: 150px;
  height: 150px;
  margin: auto;
  margin-top: 10px;
  background-repeat: no-repeat;
  background-position: center center;
  background-size: cover;
}
</style>

<v:widget caption="@Common.Profile">
<% if (ds.isEmpty()) { %>
  <v:widget-block>
    <v:itl key="@Common.NoMatchFound"/>
  </v:widget-block>
<% } else { %>
  <v:widget-block>
    <div id="account-name"><%=ds.getField(Sel.DisplayName).getHtmlString()%></div>
  <% if (!ds.getField(Sel.ProfilePictureId).isNull()) { %>
    <div id="account-logo" style="background-image:url('<v:config key="site_url"/>/repository?type?small&id=<%=ds.getField(Sel.ProfilePictureId).getHtmlString()%>')"></div>
  <% } %>
  </v:widget-block>
<% } %>
</v:widget>
