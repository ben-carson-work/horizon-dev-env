<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="action" class="com.vgs.snapp.dataobject.DOAction" scope="request"/>

<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<v:grid include="<%=!action.LinkList.isEmpty()%>">
  <thead>
    <v:grid-title caption="Relations"/>
  </thead>
  <tbody>
  <% for (DOAction.DOActionLink link : action.LinkList) { %>
    <tr class="grid-row">
      <td>
        <v:grid-icon name="<%=link.EntityIconName.getString()%>"/>
      </td>
      <td width="100%">
        <div class="list-title"><snp:entity-link entityId="<%=link.EntityId%>" entityType="<%=link.EntityType%>" openOnNewTab="true"><v:itl key="<%=link.EntityName.getString()%>"/></snp:entity-link></div>
        <div class="list-subtitle"><%=link.EntityType.getHtmlLookupDesc(pageBase.getLang())%></div>
      </td>
    </tr>
  <% } %>
  </tbody>
</v:grid>
