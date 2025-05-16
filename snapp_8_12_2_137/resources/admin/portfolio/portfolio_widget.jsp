<%@page import="com.vgs.web.servlet.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PagePortfolioWidget" scope="request"/>
<jsp:useBean id="dsMedia" class="com.vgs.cl.JvDataSet" scope="request"/>
<jsp:useBean id="dsTicket" class="com.vgs.cl.JvDataSet" scope="request"/>

<%-- MEDIA --%>
<v:widget-block clazz="group" include="<%=!dsMedia.isEmpty()%>"><v:itl key="@Common.Medias"/></v:widget-block>
<v:grid include="<%=!dsMedia.isEmpty()%>">
  <tbody>
    <v:grid-row dataset="<%=dsMedia%>">
      <td><v:grid-icon name="<%=dsMedia.getField(QryBO_Media.Sel.IconName)%>"/></td>
      <td width="50%">
        <div class="list-title">
          <% if (JvString.isSameText(dsMedia.getField(QryBO_Media.Sel.MediaId).getString(), pageBase.getParameter("MediaId"))) { %>
            <%=dsMedia.getField(QryBO_Media.Sel.MediaCalcCode).getHtmlString()%>
          <% } else { %>
            <snp:entity-link entityId="<%=dsMedia.getField(QryBO_Media.Sel.MediaId)%>" entityType="<%=LkSNEntityType.Media%>">
              <%=dsMedia.getField(QryBO_Media.Sel.MediaCalcCode).getHtmlString()%>
            </snp:entity-link>
          <% } %>
        </div>
        <div class="list-subtitle">
          <%=dsMedia.getField(QryBO_Media.Sel.MediaCodes).getHtmlString()%>
        </div>
      </td>
      <td width="50%" align="right">
        <div class="list-subtitle">
          <%=dsMedia.getField(QryBO_Media.Sel.DocTemplateName).getHtmlString()%>
        </div>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>



<%-- TICKET --%>

<% if (!dsTicket.isEmpty()) { %>
  <v:widget-block clazz="group"><v:itl key="@Ticket.Tickets"/></v:widget-block>
  <div class="ticket-list" data-portfolioid="<%=dsTicket.getField(QryBO_Ticket.Sel.PortfolioId).getHtmlString()%>">
    <v:ds-loop dataset="<%=dsTicket%>">
      <%
      LookupItem ticketStatus = LkSN.TicketStatus.getItemByCode(dsTicket.getField(QryBO_Ticket.Sel.TicketStatus));
      String blockClass = "pane-container " + (ticketStatus.isLookup(LkSNTicketStatus.Active) ? "item-status-active" : "item-status-inactive"); 
      %>
      <v:widget-block id="<%=dsTicket.getField(QryBO_Ticket.Sel.TicketId).getString()%>" clazz="<%=blockClass%>">
        <img class="pane-item pane-icon" src="<v:image-link name="<%=dsTicket.getField(QryBO_Ticket.Sel.IconName).getString()%>" size="32"/>"/>
        <div class="pane-item pane-detail">
          <% if (JvString.isSameText(dsTicket.getField(QryBO_Ticket.Sel.TicketId).getString(), pageBase.getParameter("TicketId"))) { %>
            <strong><%=dsTicket.getField(QryBO_Ticket.Sel.TicketCode).getHtmlString()%></strong>
          <% } else { %>
            <snp:entity-link entityId="<%=dsTicket.getField(QryBO_Ticket.Sel.TicketId)%>" entityType="<%=LkSNEntityType.Ticket%>" clazz="list-title">
              <%=dsTicket.getField(QryBO_Ticket.Sel.TicketCode).getHtmlString()%>
            </snp:entity-link>
          <% } %>
          <span class="recap-value">
            <% if (dsTicket.getField(QryBO_Ticket.Sel.BindWalletRewardToProduct).getBoolean()) { %>
            <%   String params = "PortfolioId=" + dsTicket.getField(QryBO_Ticket.Sel.MainPortfolioId).getHtmlString() + "&TicketId=" + dsTicket.getField(QryBO_Ticket.Sel.TicketId).getHtmlString();%>
                 <a href="javascript:asyncDialogEasy('portfolio/portfolio_binded_product_wallet_reward_dialog', '<%=params%>')">(<i class="fa-solid fa-wallet"></i>&nbsp;<%=pageBase.formatCurr(dsTicket.getMoney(QryBO_Ticket.Sel.PortfolioBindedBalance))%>)</a>&nbsp;<%=pageBase.formatCurr(dsTicket.getMoney(QryBO_Ticket.Sel.UnitAmount))%>
            <% } else { %>
                <%=pageBase.formatCurr(dsTicket.getMoney(QryBO_Ticket.Sel.UnitAmount))%>
            <% } %>
          </span><br/>
          
          <% if (!dsTicket.getField(QryBO_Ticket.Sel.ProductId).isNull()) { %>
            <snp:entity-link entityId="<%=dsTicket.getField(QryBO_Ticket.Sel.ProductId)%>" entityType="<%=LkSNEntityType.ProductType%>">
              <%=dsTicket.getField(QryBO_Ticket.Sel.ProductName).getHtmlString()%>
            </snp:entity-link>
            <br/>  
            <% if (dsTicket.getField(QryBO_Ticket.Sel.PerformanceCount).getInt() > 1) { %>
              <v:itl key="@Performance.MultiplePerformance"/>
            <% } else if (!dsTicket.getField(QryBO_Ticket.Sel.PerformanceId).isNull()) { %>
              <snp:entity-link entityId="<%=dsTicket.getField(QryBO_Ticket.Sel.EventId)%>" entityType="<%=LkSNEntityType.Event%>">
                <%=dsTicket.getField(QryBO_Ticket.Sel.EventName).getHtmlString()%>
              </snp:entity-link>
              &raquo;
              <snp:entity-link entityId="<%=dsTicket.getField(QryBO_Ticket.Sel.PerformanceId)%>" entityType="<%=LkSNEntityType.Performance%>">
                <snp:datetime timestamp="<%=dsTicket.getField(QryBO_Ticket.Sel.PerformanceDateTime)%>" format="shortdatetime" timezone="location" convert="false"/>
              </snp:entity-link>
            <% } %>
          <% } %>
        </div>
        <span class="pane-item pane-handle"><i class="fa fa-bars"></i></span>
      </v:widget-block>
    </v:ds-loop>
  </div>
<% } %>

