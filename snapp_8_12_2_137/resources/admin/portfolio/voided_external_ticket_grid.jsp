<%@page import="com.vgs.web.library.BLBO_Plugin"%>
<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.web.library.BLBO_DBInfo"%>
<%@page import="com.vgs.web.library.BLBO_Ticket"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Ticket.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_Ticket.class);
// Select
qdef.addSelect(
    Sel.IconName,
    Sel.CommonStatus,
    Sel.TicketId,
    Sel.TicketCode,
    Sel.TicketStatus,
    Sel.ProductId,
    Sel.ProductCode,
    Sel.ProductName,
    Sel.GiftCardNumber,
    Sel.PerformanceCount,
    Sel.PerformanceId,
    Sel.PerformanceDateTime,
    Sel.EventId,
    Sel.EventCode,
    Sel.EventName,
    Sel.AdmLocationId,
    Sel.AdmLocationCode,
    Sel.AdmLocationName,
    Sel.SeatName,
    Sel.ExtCode,
    Sel.ExtSystemPluginId,
    Sel.ExtSystemType);

if (pageBase.hasParameter("TransactionId"))
  qdef.addFilter(Fil.ExtVoidTransactionId, pageBase.getNullParameter("TransactionId"));

//Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid id="ticket-grid-inner" dataset="<%=ds%>" qdef="<%=qdef%>">
  <tr class="header">
    <td ><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="35%" nowrap>
      <v:itl key="@Ticket.Ticket"/><br/>
      <v:itl key="@Ticket.ExternalCode"/>
    </td>
    <td width="50%">
      <v:itl key="@Product.ProductType"/><br/>
      <v:itl key="@Performance.Performance"/> (<v:itl key="@Seat.Seat"/>)
    </td>
    
    <td width="15%" nowrap>
      <v:itl key="@Common.ExtSystemType"/><br/>
      <v:itl key="@Ticket.ExternalEncoderPlugin"/>
    </td>
  </tr>
	<tbody>
    <v:grid-row dataset="ds" >
      <% LookupItem ticketStatus = LkSN.TicketStatus.getItemByCode(ds.getField(Sel.TicketStatus)); %>
      <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>" data-ticketactive="<%=ds.getField(Sel.TicketStatus).getInt() == LkSNTicketStatus.Active.getCode()%>">
        <v:grid-checkbox name="TicketId" dataset="ds" fieldname="TicketId"/>
      </td>
      <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
      <td>
        <snp:entity-link entityId="<%=ds.getField(Sel.TicketId).getString()%>" entityType="<%=LkSNEntityType.Ticket%>" clazz="list-title" entityTooltip="false">
          <%=ds.getField(Sel.TicketCode).getHtmlString()%>
        </snp:entity-link><br/>
        <span class="list-subtitle"><%=ds.getField(Sel.ExtCode).getString()%></span>
			</td>
			<td>
        <% if (ds.getField(Sel.ProductId).isNull()) { %>
          &nbsp;
        <% } else { %>
          <snp:entity-link entityId="<%=ds.getField(Sel.ProductId)%>" entityType="<%=LkSNEntityType.ProductType%>">
            [<%=ds.getField(Sel.ProductCode).getHtmlString()%>] <%=ds.getField(Sel.ProductName).getHtmlString()%>
          </snp:entity-link>
          <% if (ds.getField(Sel.GiftCardNumber).getEmptyString().length() > 0) { %>
            &mdash; <%=ds.getField(Sel.GiftCardNumber).getHtmlString()%>
          <% } %>
        <% } %>
        <br/>
        <span class="list-subtitle">
        <% if (ds.getField(Sel.PerformanceCount).getInt() == 0) { %>
          <v:itl key="@Common.None"/>
        <% } else if (ds.getField(Sel.PerformanceCount).getInt() > 1) { %>
          <v:itl key="@Performance.MultiplePerformance"/>
        <% } else { %>
          <snp:entity-link entityId="<%=ds.getField(Sel.EventId).getString()%>" entityType="<%=LkSNEntityType.Event%>">
            <%=ds.getField(Sel.EventName).getHtmlString()%>
          </snp:entity-link>
          &raquo;
          <% if (!ds.getField(Sel.AdmLocationId).isNull()) { %>
            <snp:entity-link entityId="<%=ds.getField(Sel.AdmLocationId).getString()%>" entityType="<%=LkSNEntityType.Location%>">
              <%=ds.getField(Sel.AdmLocationName).getHtmlString()%>
            </snp:entity-link>
            &raquo;
          <% } %>
          <% ds.getField(Sel.PerformanceDateTime).setDisplayFormat(pageBase.getShortDateTimeFormat()); %>
          <snp:entity-link entityId="<%=ds.getField(Sel.PerformanceId).getString()%>" entityType="<%=LkSNEntityType.Performance%>">
            <%=ds.getField(Sel.PerformanceDateTime).getHtmlString()%>
          </snp:entity-link>
          <% if (!ds.getField(Sel.SeatName).isNull()) { %>
            (<%=ds.getField(Sel.SeatName).getHtmlString()%>)
          <% } %>
        <% } %>
        </span>
      </td>
			<td>
				<% LookupItem extSystemType = LkSN.ExtSystemType.getItemByCode(ds.getField(Sel.ExtSystemType)); %>
				<span class="list-title"><%=extSystemType.getDescription(pageBase.getLang()) %></span><br/>
				<% if (ds.getField(Sel.ExtSystemPluginId).isNull()) { %>
            &mdash;
          <% } else { %>
          	<span class="list-subtitle"><%=pageBase.getBL(BLBO_Plugin.class).findPluginName(ds.getField(Sel.ExtSystemPluginId).getString()) %></span>
          <% } %>
			</td>
    </v:grid-row>
  </tbody>
</v:grid>