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

<rgt:menu-content id="rights-menu-ui">
  <% LookupItem workstationType = LkSN.WorkstationType.findItemByCode(pageBase.getParameter("WksType")); %>
  <% if (rightsEnt.EntityType.isLookup(rightsUI.WksEntities.getLkArray()) && ((workstationType == null) || !workstationType.isLookup(LkSNWorkstationType.APT))) { %>
    <% if ((workstationType == null) || !workstationType.isLookup(LkSNWorkstationType.POS)) { %>
      <rgt:section caption="@Right.LoginCategory">
        <rgt:color rightType="<%=LkSNRightType.LoginBkgColor%>"/>
        <rgt:combo rightType="<%=LkSNRightType.LoginBkgRepositoryId%>"/>
        <rgt:lookup-combo rightType="<%=LkSNRightType.LoginBkgStyle%>" lookupTable="<%=LkSN.BackgroundStyle%>"/>
        <rgt:bool rightType="<%=LkSNRightType.Captcha%>"/>
      </rgt:section>
    <% } %>
    <% if (rightsEnt.EntityType.isLookup(LkSNEntityType.Licensee)) { %>
      <rgt:section caption="@Right.PahLandingPage">
        <rgt:color rightType="<%=LkSNRightType.PahBkgColor%>"/>
        <rgt:combo rightType="<%=LkSNRightType.PahBkgRepositoryId%>"/>
        <rgt:lookup-combo rightType="<%=LkSNRightType.PahBkgStyle%>" lookupTable="<%=LkSN.BackgroundStyle%>"/>
      </rgt:section>
    <% } %>
    
    <rgt:section caption="@Product.Catalogs">
      <rgt:combo rightType="<%=LkSNRightType.MainCatalogId%>"/>
      <rgt:multi rightType="<%=LkSNRightType.CatalogIDs%>"/>
    </rgt:section>
    
    <rgt:section caption="@Account.Accounts">
      <rgt:combo rightType="<%=LkSNRightType.AccountORG_DefaultCategoryId%>"/>
      <rgt:combo rightType="<%=LkSNRightType.AccountPRS_DefaultCategoryId%>"/>
      <rgt:combo rightType="<%=LkSNRightType.AccountInstallment_DefaultCategoryId%>"/>
      <% if (rightsEnt.EntityType.isLookup(LkSNEntityType.Workstation) /*&& rightsUI.B2BStation.getBoolean()*/) { %>
        <rgt:combo rightType="<%=LkSNRightType.AccountUSR_DefaultCategoryId%>"/>
      <% } %>
      <% if (rightsEnt.EntityType.isLookup(LkSNEntityType.Licensee)) { %>
        <rgt:lookup-combo rightType="<%=LkSNRightType.DisplayNameFormat%>" lookupTable="<%=LkSN.DisplayNameFormat%>"/>
      <% } %>
      <rgt:bool rightType="<%=LkSNRightType.AccountDeduplicationSearch%>"/>
    </rgt:section>
    
    <rgt:section caption="@Common.ShopCart">
      <rgt:bool rightType="<%=LkSNRightType.ShowNetPrices%>"/>
    </rgt:section>
    
    <rgt:section caption="@Lookup.WorkstationType.POS">
      <rgt:color rightType="<%=LkSNRightType.POS_BackgroundColor%>"/>
      <rgt:lookup-combo rightType="<%=LkSNRightType.BoardType%>" lookupTable="<%=LkSN.BoardType%>"/>
      <rgt:combo rightType="<%=LkSNRightType.KioskPluginId%>"/>
      <div class="rights-item row checkbox-label">
        <v:itl key="Price"/>
      </div>
      <rgt:subset>
        <rgt:lookup-combo rightType="<%=LkSNRightType.PriceDisplayType%>" lookupTable="<%=LkSN.PriceDisplayType%>"/>
        <rgt:bool rightType="<%=LkSNRightType.ShowCurrencySymbol%>"/>
        <rgt:bool rightType="<%=LkSNRightType.ShowPriceDifferenceOnUpgrade%>"/>
      </rgt:subset>
      <rgt:text rightType="<%=LkSNRightType.AutoLoginName%>"/>
      <rgt:text rightType="<%=LkSNRightType.InactivityResetTime%>"/>
      <rgt:text rightType="<%=LkSNRightType.StationLockTimeoutMins%>"/>
      <rgt:bool rightType="<%=LkSNRightType.PosDemoMode%>"/>
      <rgt:bool rightType="<%=LkSNRightType.AutoShowKeyboard%>"/>
      <rgt:bool rightType="<%=LkSNRightType.POS_ShowAnimations%>"/>
      <% if (pageBase.getRights().VGSSupport.getBoolean()) { %>
        <rgt:bool rightType="<%=LkSNRightType.POS_ShowMemoryUsage%>"/>
      <% } %>
      <rgt:bool rightType="<%=LkSNRightType.PresaleDefault%>"/>
      <% if (rightsEnt.EntityType.isLookup(rightsUI.WksEntities.getLkArray())) { %>
        <rgt:lookup-combo rightType="<%=LkSNRightType.AutomaticCheckOut%>" lookupTable="<%=LkSN.AutomaticCheckoutType%>"/>
        <rgt:bool rightType="<%=LkSNRightType.ShowPaymnetCutsTab%>"/>
        <rgt:bool rightType="<%=LkSNRightType.EnableEnterOnPayment%>"/>
        <rgt:lookup-combo rightType="<%=LkSNRightType.MainPaymentFunction%>" lookupTable="<%=LkSN.PaymentFunction%>"/>
        <rgt:text rightType="<%=LkSNRightType.BackHomeScreenAfterScanTimeoutSec%>"/>
        <rgt:bool rightType="<%=LkSNRightType.AutomaticPaymConfirmation%>"/>
        <rgt:bool rightType="<%=LkSNRightType.ApplyDefaultPayment%>"/>
      <% } %>
      <rgt:bool rightType="<%=LkSNRightType.POS_AutoFillUserName%>"/>
      <rgt:lookup-combo rightType="<%=LkSNRightType.PerformanceSearchFilter%>" lookupTable="<%=LkSN.PerformanceSearchFilter%>"/>
      <rgt:bool rightType="<%=LkSNRightType.SeatFlowDefault%>"/>
      <rgt:bool rightType="<%=LkSNRightType.POS_ShowQuickRenewalScreen%>"/>
      <rgt:bool rightType="<%=LkSNRightType.POS_NewChangePerformanceScreen%>"/>
      <rgt:bool rightType="<%=LkSNRightType.UseSecondLanguageOnDisplay%>"/>
      <rgt:bool rightType="<%=LkSNRightType.WarnOnUsedProduct%>"/>
      <rgt:bool rightType="<%=LkSNRightType.WarnOnWrongDatePortfolio%>"/>
    </rgt:section>
  
    <rgt:section caption="@Common.PlatformB2B">
      <rgt:bool rightType="<%=LkSNRightType.B2B_RequireGuestAccount%>"/>
      <rgt:text rightType="<%=LkSNRightType.ShopCartTimeoutMins%>"/>
      <rgt:area rightType="<%=LkSNRightType.PaymentCommitText%>"/>
    </rgt:section>
    
    <rgt:section caption="@Common.Notes">
      <rgt:lookup-combo rightType="<%=LkSNRightType.POS_OrderNotesPopup%>" lookupTable="<%=LkSN.OrderNotesPopup%>"/>
      <rgt:bool rightType="<%=LkSNRightType.ShowOnlyHighlightedNotesByDefault%>"/>
    </rgt:section>
    
    <rgt:section caption="@Right.OpenTab">
      <rgt:lookup-combo rightType="<%=LkSNRightType.OpenTabUI%>" lookupTable="<%=LkSN.RightOpenTabUI%>"/>
    </rgt:section>
    
    <rgt:section caption="@Right.Organize">
      <rgt:lookup-combo rightType="<%=LkSNRightType.OrganizeStep%>" lookupTable="<%=LkSN.RightOrganizeStep%>"/>
      <rgt:subset>
        <rgt:bool rightType="<%=LkSNRightType.SkipMediaGenerationOrganizeStep%>"/>
        <rgt:bool rightType="<%=LkSNRightType.ShowOnlyOnEncodingOrganizeStep%>"/>
        <rgt:bool rightType="<%=LkSNRightType.WarnOnUnassignedMedia%>"/>
        <rgt:bool rightType="<%=LkSNRightType.WarnOnDifferentDateOrganizeStep%>"/>
      </rgt:subset>
    </rgt:section>

    <rgt:section caption="@Common.DatedProducts">
      <div class="rights-item row checkbox-label">
        <v:itl key="@Right.DatedProductDefaultDateTitle"/>
      </div>
      <rgt:subset>
        <rgt:bool rightType="<%=LkSNRightType.DatedProdUpgradeValidFrom%>"/>
        <rgt:bool rightType="<%=LkSNRightType.DatedProdUpgradeFirstUsage%>"/>
      </rgt:subset>
    </rgt:section>
    
    <% if (rightsEnt.EntityType.isLookup(LkSNEntityType.Licensee, LkSNEntityType.Location, LkSNEntityType.OperatingArea, LkSNEntityType.AccessArea)) { %>
      <rgt:section caption="@Common.Forms">
      <% if (rightsEnt.EntityType.isLookup(LkSNEntityType.Licensee)) { %>
        <rgt:multi rightType="<%=LkSNRightType.MasksLicensee%>"/>
        <rgt:multi rightType="<%=LkSNRightType.LedgerAccountMaskIDs%>"/>
        <rgt:multi rightType="<%=LkSNRightType.MaskManualLedger%>"/>
        <rgt:multi rightType="<%=LkSNRightType.MasksTicket%>"/>
      <% } %>
      <% if (!rightsEnt.EntityType.isLookup(LkSNEntityType.AccessArea)) { %>
        <rgt:multi rightType="<%=LkSNRightType.MasksOpArea%>"/>
      <% } %>
      <% if (!rightsEnt.EntityType.isLookup(LkSNEntityType.OperatingArea)) { %>
        <rgt:multi rightType="<%=LkSNRightType.MasksAcArea%>"/>
      <% } %>
      <% if (rightsEnt.EntityType.isLookup(LkSNEntityType.Licensee)) { %>
        <rgt:multi rightType="<%=LkSNRightType.MaskMerchants%>"/>
        <rgt:multi rightType="<%=LkSNRightType.MasksResourceType%>"/>
        <rgt:multi rightType="<%=LkSNRightType.MasksCatalog%>"/>
      <% } %>
      </rgt:section>
      
      <rgt:section caption="@Common.SearchGroups">
        <rgt:multi rightType="<%=LkSNRightType.AccountSearchFieldGroups%>"/>
        <rgt:multi rightType="<%=LkSNRightType.OrderSearchFieldGroups%>"/>
        <rgt:multi rightType="<%=LkSNRightType.TransactionSearchFieldGroups%>"/>
      </rgt:section>
      
    <% } %>
  <% } %>
  
  <% if (rightsEnt.EntityType.isLookup(LkSNEntityType.Licensee)) { %>
    <rgt:section caption="@Common.Grids">
      <rgt:combo rightType="<%=LkSNRightType.PersonGrid%>"/>
      <rgt:combo rightType="<%=LkSNRightType.OrganizationGrid%>"/>
      <rgt:combo rightType="<%=LkSNRightType.OrganizationAccountGrid%>"/>
      <rgt:combo rightType="<%=LkSNRightType.AssociationGrid%>"/>
      <rgt:combo rightType="<%=LkSNRightType.MemberGrid%>"/>
    </rgt:section>
  <% } %>
  
  <% if (rightsEnt.EntityType.isLookup(rightsUI.AptEntities.getLkArray())) { %>
    <rgt:section caption="@Right.AdmSoundCategory">
      <rgt:combo rightType="<%=LkSNRightType.AdmSoundGoodRepositoryId%>"/>
      <rgt:combo rightType="<%=LkSNRightType.AdmSoundFlashRepositoryId%>"/>
      <rgt:combo rightType="<%=LkSNRightType.AdmSoundBadRepositoryId%>"/>
      <rgt:combo rightType="<%=LkSNRightType.AdmSoundBirthdayRepositoryId%>"/>
    </rgt:section>
    
    <rgt:section caption="@Right.AptDisplaySetting">
      <rgt:lookup-combo rightType="<%=LkSNRightType.AccessPointDisplay1%>" lookupTable="<%=LkSN.AccessPointDisplayMessageType%>"/>
      <rgt:lookup-combo rightType="<%=LkSNRightType.AccessPointDisplay2%>" lookupTable="<%=LkSN.AccessPointDisplayMessageType%>"/>
      <rgt:text rightType="<%=LkSNRightType.AccessPointGuestMsgDelay%>"/>
      <rgt:text rightType="<%=LkSNRightType.AccessPointOperatorMsgDelay%>"/>
    </rgt:section>
  <% } %>
  
  <% if (rightsEnt.EntityType.isLookup(rightsUI.WksEntities.getLkArray())) { %>
    <rgt:section caption="@Reservation.Reservations">
      <rgt:bool rightType="<%=LkSNRightType.WarnOnFutureReservation%>"/>
    </rgt:section>
        
    <rgt:section caption="@Right.ConfirmEmail_Title">
      <rgt:bool rightType="<%=LkSNRightType.ConfirmEmail_StraightSale%>"/>
      <rgt:bool rightType="<%=LkSNRightType.ConfirmEmail_ResCreation%>"/>
      <rgt:bool rightType="<%=LkSNRightType.ConfirmEmail_ResEdit%>"/>
      <rgt:bool rightType="<%=LkSNRightType.ConfirmEmail_ResApprove%>"/>
      <rgt:bool rightType="<%=LkSNRightType.ConfirmEmail_ResPay%>"/>
      <rgt:bool rightType="<%=LkSNRightType.ConfirmEmail_ResPrint%>"/>
      <rgt:bool rightType="<%=LkSNRightType.ConfirmEmail_ResValidate%>"/>
      <rgt:bool rightType="<%=LkSNRightType.ConfirmEmail_ResManual%>"/>
      <rgt:text rightType="<%=LkSNRightType.PdfAttachMaxTickets%>"/>
      <rgt:bool rightType="<%=LkSNRightType.SaveMediaToPDF%>"/>
      <rgt:text rightType="<%=LkSNRightType.PDFMediaLocalPath%>"/>
      <rgt:bool rightType="<%=LkSNRightType.PromptOrderConfirmationDialog%>"/>
      <rgt:bool rightType="<%=LkSNRightType.EmptyOrderConfirmationEmailRecipient%>"/>
    </rgt:section>

    <rgt:section>
      <rgt:text rightType="<%=LkSNRightType.PreventEventSale%>"/>
    </rgt:section>    
  <% } %>
  
</rgt:menu-content>
