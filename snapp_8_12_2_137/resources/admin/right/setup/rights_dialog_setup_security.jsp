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

<rgt:menu-content id="rights-menu-security">
  <rgt:section caption="@Common.Password">
    <rgt:text rightType="<%=LkSNRightType.PwdMinLength%>"/>
    <rgt:text rightType="<%=LkSNRightType.PwdUpcChars%>"/>
    <rgt:text rightType="<%=LkSNRightType.PwdLocChars%>"/>
    <rgt:text rightType="<%=LkSNRightType.PwdNumChars%>"/>
    <rgt:text rightType="<%=LkSNRightType.PwdSymChars%>"/>
    <rgt:text rightType="<%=LkSNRightType.PwdMaxAttempts%>"/>
    <rgt:text rightType="<%=LkSNRightType.PwdBlockTime%>"/>
    <rgt:text rightType="<%=LkSNRightType.PwdExpirationDays%>"/>
    <rgt:text rightType="<%=LkSNRightType.PwdHistoryLength%>"/>
    <rgt:text rightType="<%=LkSNRightType.ResetPassword%>"/>
    <rgt:area rightType="<%=LkSNRightType.PwdRulesInfo%>"/>
  </rgt:section>

<% if (rightsEnt.EntityType.isLookup(rightsUI.WksEntities.getLkArray())) { %>
  <rgt:section caption="APIs">
    <rgt:bool rightType="<%=LkSNRightType.StoreRepositoryProxyAuthentication%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ApiTokenCookieSecure%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ApiTokenCookieSameSite%>"/>
    <rgt:text rightType="<%=LkSNRightType.ApiTokenPOSAgeMins%>"/>
    <rgt:text rightType="<%=LkSNRightType.ApiTokenMaxExpirationMins%>"/>
    <rgt:text rightType="<%=LkSNRightType.ApiAccessControlAllowOrigin%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ApplyWorkstationRightsOnly%>"/>
  </rgt:section>

  <rgt:section caption="@Common.Login">
    <rgt:bool rightType="<%=LkSNRightType.SnAppLoginEnabled%>"/>
    <rgt:multi rightType="<%=LkSNRightType.ExternalLoginWeb_PluginId%>"/>
    <rgt:combo rightType="<%=LkSNRightType.ExternalLoginPos_PluginId%>"/>
    <rgt:text rightType="<%=LkSNRightType.SnpLoginMaxInactivityDays%>"/>
    <rgt:text rightType="<%=LkSNRightType.B2BLoginMaxInactivityDays%>"/>
    <rgt:text rightType="<%=LkSNRightType.B2CLoginMaxInactivityDays%>"/>
  </rgt:section>
  
  <%-- USER SECURITY --%>
  <% if (rightsEnt.EntityType.isLookup(LkSNEntityType.Licensee)) { %>
  <rgt:section caption="@Common.UserSecurity">
    <rgt:combo rightType="<%=LkSNRightType.UserSecurityValidator_PluginId%>"/>
  </rgt:section>
  <% } %>
<% } %>
</rgt:menu-content>
