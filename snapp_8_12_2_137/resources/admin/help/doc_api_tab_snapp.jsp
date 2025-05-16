<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.dataobject.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageDocAPI" scope="request"/>

<div class="tab-content">
  <v:grid>
    <thead>
      <tr>
        <td nowrap>CMD</td>
        <td nowrap>XSD</td>
        <td width="100%"><v:itl key="@Common.Description"/></td>
      </tr>
    </thead>
    <tbody>
      <% for (String cmd : Service2Manager.getCmdList(null)) { %>
        <tr class="grid-row">
          <td nowrap>
            <a href="<v:config key="site_url"/>/admin?page=doc_service_easy&cmd=<%=cmd%>" class="list-title"><%=cmd%></a>
          </td>
          <td nowrap>
            <a href="<v:config key="site_url"/>/admin?page=doc_service&cmd=<%=cmd%>" class="list-title">XSD</a>
          </td>
          <td>
            <%=JvString.escapeHtml(JvUtils.getVgsComment(Service2Manager.getCmdClass(null, cmd)))%>
          </td>
        </tr>
      <% } %>
    </tbody>
  </v:grid>
</div>