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

<v:widget caption="@Biometric.Biometric" include="<%=!ticket.BiometricCheckLevel.isLookup(LkSNBiometricCheckLevel.None)%>">
  <% if (!ticket.BiometricTicketOverride.isLookup(LkSNBiometricTicketOverrideType.AsPerConfiguration)) { %>
    <v:widget-block>
      <v:recap-item caption="@Ticket.BiometricOverrideLevel"><%=ticket.BiometricTicketOverride.getHtmlLookupDesc(pageBase.getLang())%></v:recap-item>
    </v:widget-block>
  <% } %>
  <v:widget-block>
    <% if (ticket.BiometricTemplateList.isEmpty()) { %>
      <div style="text-align:center"><v:itl key="@Lookup.ValidateResult.BiometricNotEnrolled"/></div>
    <% } else { %>
      <% DOTicket.DOTicketBiometric bio = ticket.BiometricTemplateList.getItem(0); %>
      <v:recap-item caption="@Biometric.BiometricType"><%=bio.BiometricType.getHtmlLookupDesc(pageBase.getLang())%></v:recap-item>
      <v:recap-item caption="@Biometric.EnrollmentDateTime"><snp:datetime timestamp="<%=bio.EnrollmentDateTime%>" timezone="local" format="shortdatetime"/></v:recap-item>
      <v:recap-item caption="@Biometric.ExpirationDate">
        <% if (bio.ExpirationDate.isNull()) { %>
          &mdash;
        <% } else { %>
          <%=bio.ExpirationDate.formatHtml(pageBase.getShortDateFormat())%>
        <% } %>
      </v:recap-item>
    <% } %>
  </v:widget-block> 
</v:widget>
