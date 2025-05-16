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

<rgt:menu-content id="rights-menu-advanced">
<% if (rightsEnt.EntityType.isLookup(rightsUI.WksEntities.getLkArray())) { %>
  <% if (BLBO_DBInfo.isSiae()) { %>
    <rgt:section caption="@Right.FiscalSystem">
      <rgt:combo rightType="<%=LkSNRightType.SiaeBox%>"/>
      <rgt:bool rightType="<%=LkSNRightType.FiscalSystemStation%>"/>
      <% if (rights.VGSSupport.getBoolean()) { %>
        <rgt:bool rightType="<%=LkSNRightType.FiscalSystemHybridStation%>"/>
        <rgt:bool rightType="<%=LkSNRightType.ShowFiscalVersion%>"/>
      <% } %>
    </rgt:section>
  <% } %>
  
  <rgt:section>
    <rgt:lookup-combo rightType="<%=LkSNRightType.QueueTransactionPriority%>" lookupTable="<%=LkSN.QueuePriority%>"/>
    <rgt:text rightType="<%=LkSNRightType.EntityChangeRefreshSecs%>"/>
    <rgt:text rightType="<%=LkSNRightType.SessionTimeout%>"/>
    <rgt:text rightType="<%=LkSNRightType.SessionCheckSecs%>"/>
    <rgt:bool rightType="<%=LkSNRightType.OfflineMode%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ForceOffline%>"/>
    <rgt:bool rightType="<%=LkSNRightType.SyncPostTransaction%>"/>
    <rgt:text rightType="<%=LkSNRightType.BulkOrderThreashold%>"/>
    <rgt:bool rightType="<%=LkSNRightType.WebSockets%>"/>
    <rgt:text rightType="<%=LkSNRightType.WebSocketsPingTimeout%>"/>
    <rgt:combo rightType="<%=LkSNRightType.WarehouseId%>"/>
    <rgt:text rightType="<%=LkSNRightType.ServerLocalCachePath%>"/>
    <rgt:text rightType="<%=LkSNRightType.CatalogTempFolder%>"/>
    <rgt:text rightType="<%=LkSNRightType.BackofficeURL%>"/>
    <rgt:text rightType="<%=LkSNRightType.UpgradeMaxTimes%>"/>
    <rgt:bool rightType="<%=LkSNRightType.EnableWhitelistSupportTable%>"/>
    <rgt:text rightType="<%=LkSNRightType.DeadlockRetry%>"/>
    <rgt:bool rightType="<%=LkSNRightType.EnableConsServer%>"/>
    <rgt:bool rightType="<%=LkSNRightType.XForwardedFor%>"/>
    <% if (rights.VGSSupport.getBoolean()) { %>
      <rgt:bool rightType="<%=LkSNRightType.IntegratedBackendSoftwareUpdate%>"/>
      <rgt:bool rightType="<%=LkSNRightType.MobileNG%>"/>
    <% } %>
    <rgt:text rightType="<%=LkSNRightType.MobileApk%>"/>
    <rgt:combo rightType="<%=LkSNRightType.CreateEmptyAccountCategoryId%>"/>
    <rgt:lookup-combo rightType="<%=LkSNRightType.OrderSequenceNumber%>" lookupTable="<%=LkSN.OrderSequenceNumber%>"/>
    <rgt:text rightType="<%=LkSNRightType.ExtLicenseIDs%>"/>
    <rgt:text rightType="<%=LkSNRightType.ProductUILogicRefreshPoolSize%>"/>
    <rgt:text rightType="<%=LkSNRightType.ProductUILogicRefreshPoolDelay%>"/>
    <rgt:text rightType="<%=LkSNRightType.ImportSerialRandomGap%>"/>
    <rgt:multi rightType="<%=LkSNRightType.RestrictedTransactionTypes%>" inline="false"/>
    <rgt:text rightType="<%=LkSNRightType.ThreadPoolMaxSize%>"/>
    <rgt:text rightType="<%=LkSNRightType.ResourceHoldExpireMins%>"/>
    <rgt:text rightType="<%=LkSNRightType.ResourceHandoverToleranceMins%>"/>
    <rgt:text rightType="<%=LkSNRightType.SeatHoldExpireMins%>"/>
    <rgt:combo rightType="<%=LkSNRightType.DefaultFulfilmentArea%>"/>
    <rgt:bool rightType="<%=LkSNRightType.AutomaticFulfilment%>"/>
    <rgt:plugin rightType="<%=LkSNRightType.OfflineClientCacheDBPlugin%>"/>
    <rgt:text rightType="<%=LkSNRightType.POSLogUploadFrequency%>"/>
    <rgt:lookup-combo rightType="<%=LkSNRightType.SaleCodeType%>" lookupTable="<%=LkSN.SaleCodeType%>"/>
    <rgt:multi rightType="<%=LkSNRightType.RecyclePortfolioMediaTemplateIDs%>" />
  </rgt:section>

  <rgt:section caption="@Right.ReadOnlyIntent">
    <rgt:bool rightType="<%=LkSNRightType.ReadOnlyIntentAPI%>"/>
    <rgt:bool rightType="<%=LkSNRightType.AllowForcePrimaryDB%>"/>
  </rgt:section>
  
  <rgt:section caption="@Common.Search">
    <rgt:multi rightType="<%=LkSNRightType.SearchableTicketMetaFieldIDs%>"/>
    <rgt:text rightType="<%=LkSNRightType.MaxRecordsReturnedByCodeSearch%>"/>
    <rgt:bool rightType="<%=LkSNRightType.MediaCodesFullMatch%>"/>
    <rgt:text rightType="<%=LkSNRightType.BlockoutDaysMaxRange%>"/>
    <rgt:bool rightType="<%=LkSNRightType.LoadPortfolioRecalcTicketVersion%>"/>
    <rgt:text rightType="<%=LkSNRightType.PaymentDataSearchParamNames%>"/>
  </rgt:section>

  <rgt:section caption="@Upload.FileUpload">
    <rgt:text rightType="<%=LkSNRightType.BannedFileExtensions%>"/>
    <rgt:text rightType="<%=LkSNRightType.FileSizeUploadLimit%>"/>
  </rgt:section>

  <rgt:section>
    <rgt:lookup-combo rightType="<%=LkSNRightType.VideoPriority%>" lookupTable="<%=LkSN.VideoPriority%>"/>
    <rgt:text rightType="<%=LkSNRightType.MediaServerURL%>"/>
  </rgt:section>

  <rgt:section caption="@Right.ProductPriorityLevel">
    <rgt:lookup-combo rightType="<%=LkSNRightType.ProductPriorityCheck%>" lookupTable="<%=LkSN.ProductPriorityCheck%>"/>
    <rgt:text rightType="<%=LkSNRightType.ProductPriorityTimeout%>"/>
  </rgt:section>
  
  <rgt:section caption="@Right.Sales">
    <rgt:text rightType="<%=LkSNRightType.SaleQuantityWarnLimit%>"/>
    <rgt:text rightType="<%=LkSNRightType.SaleQuantityLimit%>"/>
    <rgt:multi rightType="<%=LkSNRightType.SaleQuantityLimitProductTags%>"/>
    <rgt:bool rightType="<%=LkSNRightType.SellMoreThanOnePerfInATransaction%>"/>
    <rgt:bool rightType="<%=LkSNRightType.SaleCacellation%>"/>
  </rgt:section>

  <rgt:section caption="@Biometric.Biometric">
    <rgt:lookup-combo rightType="<%=LkSNRightType.BioEnrollmentEntity%>" lookupTable="<%=LkSN.BioEnrollEntity%>"/>
    <rgt:text rightType="<%=LkSNRightType.BioExpire_AfterExpiration%>"/>
  </rgt:section>
      
  <rgt:section caption="@Common.PayByLink">
    <rgt:text rightType="<%=LkSNRightType.PayByLinkResOwnerOrgExpMins%>"/>
    <rgt:text rightType="<%=LkSNRightType.PayByLinkResOwnerPersonExpMins%>"/>
  </rgt:section>

<% } %>
</rgt:menu-content>
