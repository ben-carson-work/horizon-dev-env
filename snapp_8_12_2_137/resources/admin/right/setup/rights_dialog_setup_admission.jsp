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

<rgt:menu-content id="rights-menu-admission">
  <rgt:section caption="@AccessPoint.Redemption">
    
    <rgt:bool rightType="<%=LkSNRightType.LogRedemptionUser%>"/>
    <rgt:text rightType="<%=LkSNRightType.GroupReentryDelayMins%>"/>
    <rgt:lookup-combo rightType="<%=LkSNRightType.GroupBiometricComparisonType%>" lookupTable="<%=LkSN.BiometricGroupComparisonType%>"/>
    <rgt:text rightType="<%=LkSNRightType.GroupBiometricComparisonLimit%>"/>
    <rgt:text rightType="<%=LkSNRightType.GroupBiometricComparisonBulkOrders%>"/>
    <rgt:bool rightType="<%=LkSNRightType.TraceRedemptionChanges%>"/>
    <rgt:lookup-combo rightType="<%=LkSNRightType.RedemptionInputTypeDefault%>" lookupTable="<%=LkSN.RedemptionInputType%>"/>
    <rgt:bool rightType="<%=LkSNRightType.RedemptionInputTypeSwitch%>"/>
  </rgt:section>
  
  <rgt:section caption="@Common.Validation">
    <rgt:lookup-combo rightType="<%=LkSNRightType.OnlineValidationLevel%>" lookupTable="<%=LkSN.OnlineValidationLevel%>"/>
    <rgt:lookup-combo rightType="<%=LkSNRightType.OfflineValidationLevel%>" lookupTable="<%=LkSN.OfflineValidationLevel%>"/>
    <rgt:text rightType="<%=LkSNRightType.OverrideAllowedTimeout%>"/>
    <rgt:bool rightType="<%=LkSNRightType.AdmissionIncludeHighlightedNotes%>"/>
  </rgt:section>
  
  <rgt:section caption="@Common.OffLine">
    <rgt:bool rightType="<%=LkSNRightType.OfflineSameSite%>"/>
    <rgt:text rightType="<%=LkSNRightType.OfflineOtherSite%>"/>
    <rgt:text rightType="<%=LkSNRightType.OfflineAcceptDays%>"/>
    <rgt:text rightType="<%=LkSNRightType.OfflineReconcileMins%>"/>
    <rgt:text rightType="<%=LkSNRightType.OfflineProductCode%>"/>
    <rgt:text rightType="<%=LkSNRightType.OfflineTransactionMaxItems%>"/>
    <rgt:text rightType="<%=LkSNRightType.OfflineWhitelistMins%>"/>
  </rgt:section>
  
  <rgt:section caption="@Right.TicketUsageNotification">
    <rgt:bool rightType="<%=LkSNRightType.NotifyTicketUsageExtSys%>"/>
    <rgt:text rightType="<%=LkSNRightType.TicketUsageExtSysURL%>"/>
  </rgt:section>

  <rgt:section caption="@Common.IdentityCheck">
    <rgt:lookup-combo rightType="<%=LkSNRightType.BiometricCheckLevel%>" lookupTable="<%=LkSN.BiometricCheckLevel%>"/>
    <rgt:lookup-combo rightType="<%=LkSNRightType.BiometricRedemptionTrigger%>" lookupTable="<%=LkSN.BiometricRedemptionTrigger%>"/>
    <rgt:bool rightType="<%=LkSNRightType.BioUseDocumentPicture%>"/>
    <rgt:bool rightType="<%=LkSNRightType.AskProductConfiguredIDVerification%>"/>
    <rgt:text rightType="<%=LkSNRightType.ManualVerificationDefaultText%>"/>
    <rgt:text rightType="<%=LkSNRightType.ManVerProbability%>"/>
  </rgt:section>
  
  <rgt:section caption="@Common.Other">
    <rgt:text rightType="<%=LkSNRightType.SameMediaReadDelay%>"/>
    <rgt:bool rightType="<%=LkSNRightType.PortfolioLockOnValidate%>"/>
    <rgt:bool rightType="<%=LkSNRightType.PreventAnonymousPortfolioRedemption%>"/>
    <rgt:bool rightType="<%=LkSNRightType.LogSimulatedRedemptions%>"/>
    <rgt:bool rightType="<%=LkSNRightType.SimulateRotationsForAutoRedeemables%>"/>
    <rgt:bool rightType="<%=LkSNRightType.AskConfirmationOnOverride%>"/>
    <rgt:bool rightType="<%=LkSNRightType.CheckBeforeUsagePerformances%>"/>
    <rgt:bool rightType="<%=LkSNRightType.CheckCrossoverTimeRange%>"/>
    <rgt:bool rightType="<%=LkSNRightType.CheckProductPriorityLevel%>"/>
    <rgt:multi rightType="<%=LkSNRightType.AdmIncludeProductTypes%>"/>
    <rgt:multi rightType="<%=LkSNRightType.AdmExcludeProductTypes%>"/>
    <rgt:text rightType="<%=LkSNRightType.FutureOfflineTolerance%>"/>
  </rgt:section>
</rgt:menu-content>
