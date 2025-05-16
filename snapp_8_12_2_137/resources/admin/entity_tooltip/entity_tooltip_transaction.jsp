<%@page import="com.vgs.snapp.dataobject.transaction.*"%>
<%@page import="com.vgs.snapp.web.search.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTooltip" scope="request"/>

<% DOTransactionRef trn = pageBase.getBL(BLBO_QueryRef_Transaction.class).loadItem(pageBase.getParameter("EntityId")); %>

<style>
.entity-tooltip-baloon .recap-value {
  float: right;
  font-weight: bold;
}

</style>

<div class="entity-tooltip-baloon">

<div class="profile-pic-icon" style="background-image:url('<v:image-link name="<%=trn.IconName.getHtmlString()%>" size="48"/>')"></div>

<div class="content">

  <div class="entity-name"><snp:entity-link entityId="<%=trn.TransactionId%>" entityType="<%=LkSNEntityType.Transaction%>"><%=trn.TransactionCode.getHtmlString()%></snp:entity-link></div>
  
  <div class="entity-type">
    <%=trn.TransactionType.getHtmlLookupDesc(pageBase.getLang())%><br/>
    <%=trn.Flags.getHtmlString()%><br/>
    <snp:entity-link entityId="<%=trn.SaleId.getHtmlString()%>" entityType="<%=LkSNEntityType.Sale%>"><%=trn.SaleCode.getHtmlString()%></snp:entity-link>
  </div>

  <v:itl key="@Common.DateTime"/>
  <snp:datetime timestamp="<%=trn.TransactionDateTime%>" format="shortdatetime" timezone="local" clazz="recap-value"/><br/>
  <snp:datetime timestamp="<%=trn.TransactionDateTime%>" format="shortdatetime" timezone="location" location="<%=trn.LocationId%>" clazz="recap-value"/><br/>

  <%
  JvDateTime fiscalDateTime = trn.TransactionDateTime.getDateTime();
  JvDateTime serialDateTime = trn.SerialDateTime.getDateTime();
  %>
  <% if (!JvDateTime.isSameDate(trn.TransactionDateTime.getDateTime(), trn.SerialDateTime.getDateTime())) { %>
    <v:recap-item caption="Transaction real date/time" valueColor="red"><snp:datetime timestamp="<%=trn.SerialDateTime%>" format="shortdatetime" timezone="location" location="<%=trn.LocationId%>"/></v:recap-item>
  <% } %>

  <div class="recap-value-item">
  <v:recap-item caption="@Common.FiscalDate"><%=trn.TransactionFiscalDate.formatHtml(pageBase.getShortDateFormat())%></v:recap-item>

  <% for (DOTransaction.DOTransactionWarn warn : trn.TransactionWarnList) { %>
    <v:recap-item valueColor="red"><%=warn.TransactionWarnDesc.getHtmlString()%></v:recap-item>
  <% } %>

  <v:recap-item>&nbsp;</v:recap-item>

  <v:recap-item caption="@Account.Location">
    <snp:entity-link entityId="<%=trn.LocationId%>" entityType="<%=LkSNEntityType.Location%>"><%=trn.LocationName.getHtmlString()%></snp:entity-link>
  </v:recap-item>

  <v:recap-item caption="@Account.OpArea">
    <snp:entity-link entityId="<%=trn.OpAreaId%>" entityType="<%=LkSNEntityType.OperatingArea%>"><%=trn.OpAreaName.getHtmlString()%></snp:entity-link>
  </v:recap-item>

  <v:recap-item caption="@Common.Workstation">
    <snp:entity-link entityId="<%=trn.WorkstationId%>" entityType="<%=LkSNEntityType.Workstation%>"><%=trn.WorkstationName.getHtmlString()%></snp:entity-link>
  </v:recap-item>


  <v:recap-item caption="@Common.User">
    <snp:entity-link entityId="<%=trn.UserAccountId%>" entityType="<%=LkSNEntityType.Person%>"><%=trn.UserAccountName.getHtmlString()%></snp:entity-link>
  </v:recap-item>

  <v:recap-item>&nbsp;</v:recap-item>

  <v:recap-item caption="@Reservation.TotalAmount"><%=pageBase.formatCurrHtml(trn.TotalAmount)%></v:recap-item>
  <v:recap-item caption="@Reservation.PaidAmount"><%=pageBase.formatCurrHtml(trn.PaidAmount)%></v:recap-item>
  <v:recap-item caption="@Common.Quantity"><%=trn.ItemCount.getInt()%></v:recap-item>

</div>

</div>