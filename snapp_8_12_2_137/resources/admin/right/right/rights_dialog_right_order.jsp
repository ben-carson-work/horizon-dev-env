<%@page import="com.vgs.snapp.exception.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="rgt-tags" prefix="rgt" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rightsEnt" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="rightsDef" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="rightsUI" class="com.vgs.snapp.dataobject.DORightDialogUI" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<rgt:menu-content id="rights-menu-order">
  <rgt:section caption="@Common.StraightSales">
    <rgt:bool rightType="<%=LkSNRightType.POS_Sales%>"/>
    <rgt:subset>
      <rgt:bool rightType="<%=LkSNRightType.POS_Payment%>"/>
      <rgt:bool rightType="<%=LkSNRightType.POS_Print%>"/>
      <rgt:text rightType="<%=LkSNRightType.MaxSaleAmount%>"/>
      <rgt:text rightType="<%=LkSNRightType.MaxOverAllDiscAmount%>"/>
    </rgt:subset>
  </rgt:section>

  <rgt:section caption="@Reservation.Reservations">
    <rgt:crud-group rightType="<%=LkSNRightType.Reservations%>"/>
    <rgt:subset>
      <rgt:bool rightType="<%=LkSNRightType.ReservationApprove%>"/>
      <rgt:bool rightType="<%=LkSNRightType.ReservationPay%>"/>
      <rgt:bool rightType="<%=LkSNRightType.DepositOnOrder%>"/>
      <rgt:bool rightType="<%=LkSNRightType.RestrictDepositAmount%>"/>
      <rgt:bool rightType="<%=LkSNRightType.ReservationConsignment%>"/>
      <rgt:bool rightType="<%=LkSNRightType.ReservationPrint%>"/>
      <rgt:bool rightType="<%=LkSNRightType.ReservationPrintNotPaid%>"/>
      <rgt:bool rightType="<%=LkSNRightType.ReservationValidate%>"/>
      <rgt:bool rightType="<%=LkSNRightType.ReservationValidateRestricted%>"/>
      <rgt:bool rightType="<%=LkSNRightType.ChangeResOwnerOnPaidOrders%>"/>
      <rgt:bool rightType="<%=LkSNRightType.SaleBulkPay%>"/>
      <rgt:bool rightType="<%=LkSNRightType.ReservationSplit%>"/>
      <rgt:bool rightType="<%=LkSNRightType.ModifyApprovedReservation%>"/>
      <rgt:bool rightType="<%=LkSNRightType.ModifyPaidReservation%>"/>
      <rgt:text rightType="<%=LkSNRightType.OrderApprovalAmount%>"/>
      <rgt:bool rightType="<%=LkSNRightType.ShowSequenceNumber%>"/>
      <rgt:bool rightType="<%=LkSNRightType.VoidOrderPaidByInstallment%>"/>
      <rgt:bool rightType="<%=LkSNRightType.OrderBlockUnblock%>"/>
      <rgt:bool rightType="<%=LkSNRightType.RefundOverPayment%>"/>
      <rgt:bool rightType="<%=LkSNRightType.CompleteOrderWithExpiredPerformances%>"/>
    </rgt:subset>
  </rgt:section>

  <rgt:section caption="@Right.OpenTab">
    <rgt:crud rightType="<%=LkSNRightType.OpenTab%>"/>
    <rgt:bool rightType="<%=LkSNRightType.AllowRemoveTabItems%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ManageOtherWaiterOpenTab%>"/>
  </rgt:section>

  <rgt:section>
    <rgt:bool rightType="<%=LkSNRightType.ResBatch_Print%>"/>
    <rgt:lookup-combo rightType="<%=LkSNRightType.PahDownloadOption%>" lookupTable="<%=LkSN.PahDownloadOption%>"/>
    <rgt:bool rightType="<%=LkSNRightType.BKO_ImportOrders%>"/>
    <rgt:text rightType="<%=LkSNRightType.MaxRefundAmount%>"/>
  </rgt:section>

  <% if (rightsEnt.EntityType.isLookup(rightsUI.WksEntities.getLkArray())) { %>
    <rgt:section caption="@Reservation.Reservations">
      <rgt:bool rightType="<%=LkSNRightType.ReservationFilterOnLocation%>"/>
      <rgt:bool rightType="<%=LkSNRightType.ResBatch_Create%>"/>
    </rgt:section>
<% } %>
</rgt:menu-content>
