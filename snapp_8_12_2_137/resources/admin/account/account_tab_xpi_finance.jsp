<%@page import="com.vgs.snapp.lookup.LkSNRightLevel"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" scope="request" class="com.vgs.web.page.PageAccount"/>
<jsp:useBean id="rights" scope="request" class="com.vgs.snapp.dataobject.DORightRoot"/>
<jsp:useBean id="account" scope="request" class="com.vgs.snapp.dataobject.DOAccount"/>

<div class="tab-content">

<%
boolean canReadFinance = rights.CreditLine.canRead();
%>
<% if (!canReadFinance) { %>
  <div class="warning-box">
    <strong><v:itl key="@Common.Warning"/></strong>
    <br/>&nbsp;<br/>
    <v:itl key="@Common.PermissionDenied"/>
  </div>
<% } else { %>
  <v:tab-group name="tab_xpi_finance">
    <%-- Recap --%>
    <v:tab-item caption="@Common.Recap" icon="coins.png" tab="xpirecap" default="true" jsp="account_tab_xpi_finance_recap.jsp" />
    
    <% if (canReadFinance) { %>
      <%-- Credit --%>
      <v:tab-item caption="@Account.Credit.Credit" icon="credit.png" tab="xpicredit" jsp="account_tab_xpi_finance_credit.jsp" />
      
      <%-- AccountDepositLog --%>
      <v:tab-item caption="@Account.Credit.DepositLog" icon="calendar.png" tab="xpidepositlog" jsp="account_tab_xpi_finance_depositlog.jsp" />
    <% } %>
  </v:tab-group>
<% } %>
</div>
