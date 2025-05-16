<%@page import="com.vgs.snapp.dataobject.ticket.*"%>
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

<v:tab-toolbar>
  <v:pagebox gridId="ticket-grid" />
</v:tab-toolbar>

<v:tab-content>
  <v:profile-recap>
    <v:widget caption="@Product.ProductTypes">
      <v:widget-block>
        <% for (DOTicketGuestProductBalance balance : ticket.GuestProductBalanceList) { %>
          <div>
            <snp:entity-link entityId="<%=balance.ProductId%>" entityType="<%=LkSNEntityType.ProductType%>">
              <%=balance.ProductName.getHtmlString()%>
            </snp:entity-link>
            <span class="recap-value"><%=balance.QtyEncoded.getInt()%>/<%=balance.QtyTotal.getInt()%></span>
          </div>
        <% } %>
      </v:widget-block>
    </v:widget>
  </v:profile-recap>
    
  <v:profile-main>
    <% String params = "HostTicketId=" + pageBase.getId(); %>
    <v:async-grid id="ticket-grid" jsp="portfolio/ticket_grid.jsp" params="<%=params%>" />
  </v:profile-main>
</v:tab-content>

