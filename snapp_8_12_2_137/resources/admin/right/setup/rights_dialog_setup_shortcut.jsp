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

<% if (rightsEnt.EntityType.isLookup(rightsUI.WksEntities.getLkArray())) { %>
<rgt:menu-content id="rights-menu-shortcuts">
  <v:alert-box type="info"><v:itl key="@Right.FunctionShortcutsHint" /></v:alert-box>
  
  <rgt:section caption="@Common.Tools_Shopcart">
    <rgt:text rightType="<%=LkSNRightType.Shortcut_SaleSearch%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_SaleRecent%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_ReservationRecent%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_ReservationAccount%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_OpentabSelect%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_SaleBulkPay%>"/>
  </rgt:section>

  <rgt:section>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_TransactionSearch%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_LastTransaction%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_OrganizationInventory%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_OrganizationInventoryHandover%>"/>
  </rgt:section>
  
  <rgt:section>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_AccountSearch%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_AccountAdd%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_AccountRecent%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_AssociationPickup%>"/>
  </rgt:section>
  
  <rgt:section>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_MediaLookup%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_MediaAdd%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_MediaTopup%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_MediaRecycle%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_MediaReissue%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_MediaOrganize%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_PortfolioRecent%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_PortfolioLookupByMedia%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_PortfolioLookupByTicket%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_PortfolioMerge%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_PortfolioSettlement%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_ManualRewardPoint%>"/>
  </rgt:section>

  <rgt:section>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_GiftCardLookup%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_GiftCardActivate%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_GiftCardReload%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_GiftCardCashout%>"/>
  </rgt:section>
  
  <rgt:section>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_ProductLookup%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_TicketVoid%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_TicketPerformance%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_ProductUpgrade%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_ProductRenew%>"/>
  </rgt:section>
  
  <rgt:section>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_VoucherRedeem%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_AddMember%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_AddCoupon%>"/>
  </rgt:section>

  <rgt:section>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_VirtualAptEntry%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_VirtualAptExit%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_TicketManualRedemptionAction%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_AccessControlMonitor%>"/>
    <%-- 
    <rgt:text rightType="<%=LkSNRightType.Shortcut_ResourceHandOver%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_ResourceReturn%>"/>
    --%>
  </rgt:section>

  <rgt:section>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_ProductTypeSearch%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_ManualInput%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_InstallmentContractLookup%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_InstallmentContractSetup%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_ProductInventory%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_ProductInfo%>"/>
  </rgt:section>
  
  <rgt:section>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_TrainingMode%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_ChangePassword%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_ChangeOwnLanguage%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_SupervisorLogin%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_DrawerOpen%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_Boxmaintenance%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_Presale%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_TaxExempt%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_GoodsReturn%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_SeatEnvelopeExtra%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_SeatFlow%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_PricingSimulation%>"/>
  </rgt:section>
  
  <rgt:section>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_ForeignCurrencyExchange%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_VoucherPrint%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_ResBatchPrinting%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_LastResEmail%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_PrintLastTrnReceipt%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_PrintLastGiftReceipt%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_ReportPDF%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_UpSell%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_DatedProducts%>"/>
  </rgt:section>

  <rgt:section caption="@Common.Tools_System">
    <rgt:text rightType="<%=LkSNRightType.Shortcut_SystemFunctions%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_SystemScreen%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_SystemMinimize%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_PluginStatus%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_StressTest%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_AptStressTest%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_ToggleHiddenProducts%>"/>
  </rgt:section>

  <rgt:section>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_ClearCache%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_Syncronize%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_ForceUserDownload%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_GarbageCollect%>"/>
  </rgt:section>
  
  <rgt:section>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_OpenBackOffice%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_OpenBrowser%>"/>
    <rgt:text rightType="<%=LkSNRightType.Shortcut_AddFavourite%>"/>
  </rgt:section>
</rgt:menu-content>
<% } %>
