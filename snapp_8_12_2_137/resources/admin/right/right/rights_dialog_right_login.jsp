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

<rgt:menu-content id="rights-menu-login">
<% if (rightsEnt.EntityType.isLookup(rightsUI.UsrEntities.getLkArray())) { %>
  <rgt:section caption="@Common.Modules">
    <rgt:bool rightType="<%=LkSNRightType.ModuleAccess_POS%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ModuleAccess_BKO%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ModuleAccess_CLC%>"/>
  </rgt:section>

  <rgt:section>
    <rgt:bool rightType="<%=LkSNRightType.SimultaneousLoginBackofficeAndPOS%>"/>
  </rgt:section>

  <rgt:section>
    <rgt:multi rightType="<%=LkSNRightType.OpAreaIDs%>" inline="false"/>
    <rgt:multi rightType="<%=LkSNRightType.CLC_WorkstationIDs%>" inline="false"/>
  </rgt:section>

  <rgt:section>
    <rgt:multi rightType="<%=LkSNRightType.GroupLocationIDs%>" inline="false"/>
    <rgt:combo rightType="<%=LkSNRightType.MasterLocationId%>"/>
  </rgt:section>
  
  <rgt:section>
    <rgt:lookup-combo rightType="<%=LkSNRightType.ExternalAuthenticator%>" lookupTable="<%=LkSN.ExternalAuthenticatorLevel%>"/>
  </rgt:section>
<% } %>
</rgt:menu-content>
