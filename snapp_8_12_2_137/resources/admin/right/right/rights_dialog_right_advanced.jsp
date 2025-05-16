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

<rgt:menu-content id="rights-menu-advanced">
  <% if (rightsEnt.EntityType.isLookup(rightsUI.UsrEntities.getLkArray())) { %>
    <rgt:section>
      <% if (rights.VGSSupport.getBoolean()) { %>
        <rgt:bool rightType="<%=LkSNRightType.VGSSupport%>"/>
      <% } %>
      <rgt:bool rightType="<%=LkSNRightType.SuperUser%>"/>
    </rgt:section>
    
    <rgt:section>
      <rgt:bool rightType="<%=LkSNRightType.DashboardSales%>"/>
      <rgt:bool rightType="<%=LkSNRightType.DashboardAdm%>"/>
      <rgt:bool rightType="<%=LkSNRightType.ActivityAudit%>"/>
      <rgt:bool rightType="<%=LkSNRightType.RedemptionLog%>"/>
      <rgt:bool rightType="<%=LkSNRightType.MonitorIT%>"/>
      <rgt:crud rightType="<%=LkSNRightType.ResourceManagement%>"/>
    </rgt:section>
    
    <rgt:section caption="@Common.Help">
      <rgt:bool rightType="<%=LkSNRightType.HelpAPIs%>"/>
      <rgt:bool rightType="<%=LkSNRightType.HelpLookupTables%>"/>
      <rgt:bool rightType="<%=LkSNRightType.HelpTemplateVariables%>"/>
      <rgt:bool rightType="<%=LkSNRightType.HelpDBSchema%>"/>
    </rgt:section>

    <% if (BLBO_DBInfo.isSiae()) { %>
      <rgt:section caption="@Right.FiscalSystem">
        <rgt:bool rightType="<%=LkSNRightType.FiscalSystemView%>"/>
      </rgt:section>
    <% } %>
  <% } %>
  
  <rgt:section>
    <rgt:bool rightType="<%=LkSNRightType.ManualUnlock%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ManualUnlockPayByLink%>"/>
    <rgt:bool rightType="<%=LkSNRightType.OverrideEmailAddress%>"/>
  </rgt:section>
  
  <rgt:section caption="@Common.Topology">
    <rgt:crud rightType="<%=LkSNRightType.SystemSetupLicensee%>"/>
    <rgt:crud-group rightType="<%=LkSNRightType.SystemSetupLocations%>"/>
    <rgt:crud-group rightType="<%=LkSNRightType.SystemSetupWorkstations%>"/>
    <rgt:subset>
      <rgt:bool rightType="<%=LkSNRightType.SystemSetupWorkstationDevices%>"/>
      <rgt:bool rightType="<%=LkSNRightType.SystemSetupWorkstationActivationKey%>"/>
      <rgt:bool rightType="<%=LkSNRightType.SystemSetupWorkstationDemographic%>"/>
    </rgt:subset>
    <rgt:crud-group rightType="<%=LkSNRightType.SystemSetupAccessPoints%>"/>
    <rgt:crud rightType="<%=LkSNRightType.SystemSetupCrossPlatform%>"/>
    <rgt:bool rightType="<%=LkSNRightType.InstallPOS%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ResetWorkstationLicense%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ImportLicense%>"/>
    <rgt:bool rightType="<%=LkSNRightType.Encryption%>"/>
  </rgt:section>
    
  <rgt:section caption="@Common.Settings">
    <rgt:bool rightType="<%=LkSNRightType.GenericSetup%>"/>
    <rgt:crud rightType="<%=LkSNRightType.SettingsSecurityRoles%>"/>
    <rgt:bool rightType="<%=LkSNRightType.SettingsCustomForms%>"/>
    <rgt:bool rightType="<%=LkSNRightType.SettingsSaleChannels%>"/>
    <rgt:bool rightType="<%=LkSNRightType.SettingsCommissionRules%>"/>
    <rgt:bool rightType="<%=LkSNRightType.SettingsRedemptionCommissionRule%>"/>
    <rgt:bool rightType="<%=LkSNRightType.SettingsTaxes%>"/>
    <rgt:bool rightType="<%=LkSNRightType.SettingsCalendars%>"/>
    <rgt:bool rightType="<%=LkSNRightType.SettingsCurrencies%>"/>
    <rgt:bool rightType="<%=LkSNRightType.SettingsPayments%>"/>
    <rgt:bool rightType="<%=LkSNRightType.SettingsITSettings%>"/>
    <rgt:bool rightType="<%=LkSNRightType.SettingsTasks%>"/>
    <rgt:bool rightType="<%=LkSNRightType.SettingsDigitalSignage%>"/>
    <rgt:bool rightType="<%=LkSNRightType.SettingsMessages%>"/>
    <rgt:crud rightType="<%=LkSNRightType.ExtensionPackages%>"/>
    <rgt:crud rightType="<%=LkSNRightType.DataSources%>"/>
    <rgt:bool rightType="<%=LkSNRightType.SoftwareUpdates%>"/>
    <rgt:bool rightType="<%=LkSNRightType.SoftwareManualUpload%>"/>
    <rgt:bool rightType="<%=LkSNRightType.SettingsPluginDriver%>"/>
  </rgt:section>
  
  <% if (rightsEnt.EntityType.isLookup(rightsUI.WksEntities.getLkArray())) { %>
    <rgt:section caption="@Right.API">
      <rgt:bool rightType="<%=LkSNRightType.CustomWorkstation%>"/>
      <rgt:text rightType="<%=LkSNRightType.ApiMaxItems%>"/>
    </rgt:section>
  <% } %>

  <rgt:section caption="@Common.Other">
    <rgt:bool rightType="<%=LkSNRightType.POS_ShowOfflineStatus%>"/>
    <rgt:bool rightType="<%=LkSNRightType.POS_ShowUploadStatus%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ManualArchiving%>"/>
  </rgt:section>
</rgt:menu-content>
