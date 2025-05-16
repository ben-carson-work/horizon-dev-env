<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
  
<v:tab-group name="tab" main="true">
  <% boolean first = true; %>
  <% if (rights.SettingsSaleChannels.getBoolean()) { %>
    <v:tab-item caption="@SaleChannel.SaleChannels" icon="salechannel.png" tab="salechannel" jsp="dynprice_tab_salechannel.jsp" default="<%=first%>"/>
    <% first = false; %>
  <% } %>
  <% if (rights.GenericSetup.getBoolean()) { %>
    <v:tab-item caption="@Performance.PerformanceTypes" icon="pricetable.png" tab="perftype" jsp="dynprice_tab_perftype.jsp" default="<%=first%>"/>
    <% first = false; %>
  <% } %>
  <% if (rights.GenericSetup.getBoolean()) { %>
    <v:tab-item caption="@Common.RateCodes" icon="ratecode.png" tab="ratecode" jsp="dynprice_tab_ratecode.jsp" default="<%=first%>"/>
    <% first = false; %>
  <% } %>
  <% if (rights.SettingsCommissionRules.getBoolean()) { %>
    <v:tab-item caption="@Commission.CommissionRules" icon="fee.png" tab="commission" jsp="dynprice_tab_commission.jsp" default="<%=first%>"/>
    <% first = false; %>
  <% } %>
  <% if (rights.SettingsRedemptionCommissionRule.getBoolean()) { %>
    <v:tab-item caption="@RedemptionCommissionRule.RedemptionCommissionRules" icon="fee.png" tab="redemptioncommissionrule" jsp="dynprice_tab_redemptioncommissionrule.jsp" default="<%=first%>"/>
    <% first = false; %>
  <% } %>
  <% if (rights.GenericSetup.getBoolean()) { %>
    <v:tab-item caption="@Seat.Envelopes" icon="seat_envelope.png" tab="envelope" jsp="dynprice_tab_envelope.jsp" default="<%=first%>"/>
    <% first = false; %>
  <% } %>
  
</v:tab-group>
 
<jsp:include page="/resources/common/footer.jsp"/>
