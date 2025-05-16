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

<rgt:menu-content id="rights-menu-doc">
<% if (rightsEnt.EntityType.isLookup(rightsUI.UsrEntities.getLkArray())) { %>
  <rgt:section>
    <rgt:crud rightType="<%=LkSNRightType.DocMedias%>"/>
    <rgt:crud rightType="<%=LkSNRightType.DocTrnReceipts%>"/>
    <rgt:crud rightType="<%=LkSNRightType.DocOrderConfirmations%>"/>
    <rgt:crud rightType="<%=LkSNRightType.DocBox%>"/>
    <rgt:crud rightType="<%=LkSNRightType.DocCreditCard%>"/>
  </rgt:section>
  
   <rgt:section caption= "@DocTemplate.Receipts">
    <rgt:crud rightType="<%=LkSNRightType.DocWalletReceipts%>"/>
    <rgt:crud rightType="<%=LkSNRightType.DocPaymentReceipts%>"/>
    <rgt:crud rightType="<%=LkSNRightType.DocPortfolioSlotLogReceipts%>"/>
    <rgt:crud rightType="<%=LkSNRightType.DocGiftCardLookupReceipts%>"/>
    <rgt:crud rightType="<%=LkSNRightType.DocVouchers%>"/>
    <rgt:crud rightType="<%=LkSNRightType.DocPrintableErrorReceipt%>"/>
  </rgt:section>
  
  <rgt:section caption = "@Common.Notifications">
    <rgt:crud rightType="<%=LkSNRightType.DocInstallmentNotifications%>"/>
    <rgt:crud rightType="<%=LkSNRightType.DocUserProfileNotifications%>"/>
    <rgt:crud rightType="<%=LkSNRightType.DocAccountNotifications%>"/>
    <rgt:crud rightType="<%=LkSNRightType.DocAdvancedNotifications%>"/>
  </rgt:section>
  
  <rgt:section caption = "@DocTemplate.Pages">
    <rgt:crud rightType="<%=LkSNRightType.DocInstallmentContracts%>"/>
    <rgt:crud rightType="<%=LkSNRightType.DocStatReports%>"/>
    <rgt:crud rightType="<%=LkSNRightType.DocWidgets%>"/>
    <rgt:crud rightType="<%=LkSNRightType.DocPayByLinks%>"/>
    <rgt:crud rightType="<%=LkSNRightType.DocTicket%>"/>
    <rgt:crud rightType="<%=LkSNRightType.DocAccountTempPage%>"/>
    <rgt:crud rightType="<%=LkSNRightType.DocEmailVerifSuccessLandingPage%>"/>
    <rgt:crud rightType="<%=LkSNRightType.DocEmailVerifFailureLandingPage%>"/>
    <rgt:crud rightType="<%=LkSNRightType.DocResetPwdSuccessLandingPage%>"/>
    <rgt:crud rightType="<%=LkSNRightType.DocResetPwdFailureLandingPage%>"/>
    <rgt:crud rightType="<%=LkSNRightType.DocOrderPages%>"/>
  </rgt:section>
  
  <rgt:section caption = "@Common.Documents">
    <rgt:crud rightType="<%=LkSNRightType.DocInvoices%>"/>
    <rgt:crud rightType="<%=LkSNRightType.DocWaiver%>"/>
    <rgt:crud rightType="<%=LkSNRightType.DocAutoGenDocs%>"/>
  </rgt:section>
<% } %>
</rgt:menu-content>
