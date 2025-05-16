<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTicket" scope="request"/>
<jsp:useBean id="ticket" class="com.vgs.snapp.dataobject.DOTicket" scope="request"/>

<style>
  #grid-entry-recap .event-cell {
    max-width: 0; 
    white-space: wrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
</style>

<v:tab-content>
  <v:profile-recap>
    <v:grid id="grid-entry-recap">
      <thead>
        <v:grid-title caption="@Ticket.EntryRecap"/>
        <tr>
          <td width="100%"><v:itl key="@Event.Event"/></td>
          <td align="center"><v:itl key="@Entitlement.EntryRecapMax"/></td>
          <td align="center"><v:itl key="@Entitlement.EntryRecapUsed"/></td>
          <td align="center"><v:itl key="@Entitlement.EntryRecapAvail"/></td>
        </tr>
      </thead>
      <tbody>
      <% String unlimited = JvString.escapeHtml(pageBase.getLang().Common.Unlimited.getText()); %>
      <% for (DOEntryRecapEventItem event : ticket.EntryRecapEventList) { %>
        <tr class="grid-row"> 
          <td class="event-cell v-tooltip-overflow hint-tooltip"><snp:entity-link entityId="<%=event.EventId%>" entityType="<%=LkSNEntityType.Event%>"><%=event.EventName.getString()%></snp:entity-link></td>
          <td align="center"><%=event.EntryMax.isNull(unlimited)%></td>
          <td align="center"><%=event.EntryUsed.getInt()%></td>
          <td align="center"><%=event.EntryAvail.isNull(unlimited)%></td>
        </tr>
      <% } %>
      </tbody>
    </v:grid>
  </v:profile-recap>
  
  <v:profile-main>
    <% 
    request.setAttribute("entitlement", ticket.Entitlement);
    request.setAttribute("entitlement-readonly", "true"); 
    request.setAttribute("entitlement-widget-caption", "@Common.Entitlements"); 
    request.setAttribute("EntityType", LkSNEntityType.Ticket.getCode()); 
    request.setAttribute("EntityId", pageBase.getId()); 
    %>
    <div id="entitlement-container"><jsp:include page="../entitlement/entitlement_widget.jsp"/></div>
  </v:profile-main>
</v:tab-content>
