<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<%
@SuppressWarnings("unchecked")
List<DOResourceSerialRef> resourceList = (List<DOResourceSerialRef>)request.getAttribute("ResourceList");
LookupItem parentEntityType = LkSN.EntityType.getItemByCode(JvString.strToIntDef(request.getParameter("ParentEntityType"), 0));
%>

<% for (DOResourceSerialRef serialDO : resourceList) { %>
  <v:widget-block>
    <v:icon-pane iconName="<%=serialDO.EntityIconName.getString()%>" repositoryId="<%=serialDO.EntityProfilePictureId.getString()%>">
      <% if (!parentEntityType.isLookup(LkSNEntityType.Ticket)) { %>
      <snp:entity-link entityId="<%=serialDO.TicketId%>" entityType="<%=LkSNEntityType.Ticket%>" clazz="list-title" entityTooltip="false"><%=serialDO.TicketCode.getHtmlString()%></snp:entity-link><br/>
      <% } %>
      <snp:entity-link entityId="<%=serialDO.EntityId%>" entityType="<%=serialDO.EntityType%>"><%=serialDO.EntityName.getHtmlString()%></snp:entity-link>
      <span class="list-subtitle">
        (<%=serialDO.ResourceTypeName.getHtmlString()%>)
        <% String ref = serialDO.ResourceSerialCode.isNull(serialDO.ExtResourceHold.getString()); %>
        <% if (ref != null) { %>
          &mdash; <%=JvString.htmlEncode(ref)%>
        <% } %>
      </span>
      <div>
        <snp:datetime timestamp="<%=serialDO.DateTimeFrom%>" timezone="local" format="shortdatetime"/> &rarr; 
        <snp:datetime timestamp="<%=serialDO.DateTimeTo%>" timezone="local" format="shorttime"/>
      </div>
    </v:icon-pane>
  </v:widget-block>
<% } %>