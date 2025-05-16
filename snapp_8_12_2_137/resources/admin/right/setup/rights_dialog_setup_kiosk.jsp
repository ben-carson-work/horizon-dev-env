<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%> 
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="rgt-tags" prefix="rgt" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rightsEnt" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="rightsDef" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="rightsUI" class="com.vgs.snapp.dataobject.DORightDialogUI" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<rgt:menu-content id="rights-menu-kiosk">
<% if (rightsEnt.EntityType.isLookup(rightsUI.WksEntities.getLkArray()) && rightsUI.WksType.isLookup(LkSNWorkstationType.KSK)) { %>
  <rgt:section caption="@Common.General">
    <rgt:text rightType="<%=LkSNRightType.KSK_PIN%>"/>
    <rgt:multi rightType="<%=LkSNRightType.KSK_LangISOs%>"/>
    <rgt:multi rightType="<%=LkSNRightType.KSK_Services%>"/>
    <rgt:multi rightType="<%=LkSNRightType.KSK_PrintMediaMethod%>"/>
    <rgt:combo rightType="<%=LkSNRightType.KSK_OrderConfirmationDocTemplateId%>"/>
    <rgt:combo rightType="<%=LkSNRightType.KSK_BackgroundImage%>"/>
    <rgt:combo rightType="<%=LkSNRightType.KSK_Video%>"/>
    <rgt:multi rightType="<%=LkSNRightType.KSK_CarouselImages%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Header%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Common_ShopCartEmpty%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Common_Items%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Common_Tax%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Common_Total%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Common_Yes%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Common_No%>"/>
  </rgt:section>

  <rgt:section caption="@Kiosk.StepIdle">
    <rgt:itl rightType="<%=LkSNRightType.KSK_Idle_Title%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Idle_Subtitle%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Idle_Footer1%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Idle_Footer2%>"/>
  </rgt:section>

  <rgt:section caption="@Kiosk.StepHome">
    <rgt:itl rightType="<%=LkSNRightType.KSK_Home_Title%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Home_Subtitle%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Home_TrnPurchaseTicket%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Home_TrnOrderPickup%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Home_TrnWalletTopup%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Home_TrnHint%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Home_TrnChangePerformance%>"/>
  </rgt:section>

  <rgt:section caption="@Kiosk.OrderPickup">
    <rgt:itl rightType="<%=LkSNRightType.KSK_OrderPickup_LookupTitle%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_OrderPickup_LookupCaption%>"/>
  </rgt:section>

	<rgt:section caption="@Kiosk.StepOrderInfo">
    <rgt:itl rightType="<%=LkSNRightType.KSK_OrderInfo_Title%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_OrderInfo_Subtitle%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_OrderInfo_BackButtonCaption%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_OrderInfo_ReissueTickets%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_OrderInfo_CompleteOrder%>"/>
  </rgt:section>
  
  <rgt:section caption="@Kiosk.StepCatalog">
    <rgt:itl rightType="<%=LkSNRightType.KSK_Catalog_BackButtonCaption%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Catalog_NextButtonCaption%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Catalog_ClearButtonCaption%>"/>
  </rgt:section>

  <rgt:section caption="@Kiosk.StepUpsellSwap">
    <rgt:itl rightType="<%=LkSNRightType.KSK_UpsellSwap_Title%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_UpsellSwap_Subtitle%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_UpsellSwap_BackButtonCaption%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_UpsellSwap_NextButtonCaption%>"/>
  </rgt:section>

  <rgt:section caption="@Kiosk.StepUpsellAddon">
    <rgt:itl rightType="<%=LkSNRightType.KSK_UpsellAddon_Title%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_UpsellAddon_Subtitle%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_UpsellAddon_BackButtonCaption%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_UpsellAddon_NextButtonCaption%>"/>
  </rgt:section>

  <rgt:section caption="@Kiosk.StepRecap">
    <rgt:itl rightType="<%=LkSNRightType.KSK_Recap_Title%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Recap_Subtitle%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Recap_BackButtonCaption%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Recap_BackButtonPerfCaption%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Recap_NextButtonCaption%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Recap_AddonHint%>"/>
  </rgt:section>

  <rgt:section caption="@Kiosk.StepPaysel">
    <rgt:itl rightType="<%=LkSNRightType.KSK_Paysel_Title%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Paysel_Subtitle%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Paysel_BackButtonCaption%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Paysel_PayselHint%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Paysel_PayCash%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Paysel_PayCreditCard%>"/>
  </rgt:section>
  
  <rgt:section caption="@Kiosk.StepChangePerformance">
    <rgt:itl rightType="<%=LkSNRightType.KSK_ChangePerformance_Title%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_ChangePerformance_Subtitle%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_ChangePerformance_BackButtonCaption%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_ChangePerformance_NextButtonCaption%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_ChangePerformance_EmptyTargetCaption%>"/>
  </rgt:section>

  <rgt:section caption="@Kiosk.StepPrintsel">
    <rgt:itl rightType="<%=LkSNRightType.KSK_Printsel_InputEmailTitle%>"/>
    <rgt:itl rightType="<%=LkSNRightType.KSK_Printsel_InputEmailCaption%>"/>
  </rgt:section>
  
<% } %>
</rgt:menu-content>

