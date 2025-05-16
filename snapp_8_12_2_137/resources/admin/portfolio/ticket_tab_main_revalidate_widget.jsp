<%@page import="com.vgs.snapp.web.search.*"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.web.servlet.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTicket" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="ticket" class="com.vgs.snapp.dataobject.DOTicket" scope="request"/>

<v:widget caption="@Product.Revalidation" include="<%=!ticket.RevalidateTransactionList.isEmpty()%>">
  <v:widget-block>
  <% for (DORevalidateTransactionRef item : ticket.RevalidateTransactionList) { %>
    <snp:entity-link entityId="<%=item.Transaction.TransactionId.getString()%>" entityType="<%=LkSNEntityType.Transaction%>"><%=item.Transaction.TransactionCode.getHtmlString()%></snp:entity-link>
    <span class="recap-value">
      <%=pageBase.format(item.OldExpirationDate, pageBase.getShortDateFormat())%> &rarr; <%=pageBase.format(item.NewExpirationDate, pageBase.getShortDateFormat())%>
    </span><br/>
  <% } %>
  </v:widget-block>
</v:widget>
