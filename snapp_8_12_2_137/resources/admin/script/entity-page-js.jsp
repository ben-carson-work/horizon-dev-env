<%@page import="com.vgs.snapp.web.common.library.EntityLinkManager"%>
<%@page import="java.util.Map.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>
<% BOSessionBean boSession = (pageBase == null) ? null : (BOSessionBean)pageBase.getSession(); %>

<% // This IF-BLOCK is supposed to always fail. Just a workaround to have this page highlighted as javascript. %>
<% if (request.getAttribute("BB63A701FB6F4C04B70C44E3CB161795") != null) { %>
<script>
<% } %>

function getPageURL(entityType, entityId, params) {
  function _getPageURL(urlo) {
    urlo = urlo.replace("@ID", entityId) + ((params) ? "&" + params : "");
    if (urlo.indexOf("javascript:") != 0)
      urlo = <%=JvString.jsString(pageBase.getContextURL())%> + urlo.replace("@ID", entityId) + ((params) ? "&" + params : "");
    return urlo;
  }
  
  switch (entityType) {
    <% for (Entry<LookupItem, String> entry : EntityLinkManager.instance().getMapAll().entrySet()) { %>
    case <%=entry.getKey().getCode()%>: return _getPageURL(<%=JvString.jsString(entry.getValue())%>);
    <% } %>
  default: 
    throw "entitySaveNotification - EntityType not handled: " + entityType
  }
}



<% // This IF-BLOCK is supposed to always fail. Just a workaround to have this page highlighted as javascript. %>
<% if (request.getAttribute("BB63A701FB6F4C04B70C44E3CB161795") != null) { %>
</script>
<% } %>
