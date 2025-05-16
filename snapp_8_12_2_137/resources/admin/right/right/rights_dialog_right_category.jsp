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

<rgt:menu-content id="rights-menu-category">
<% if (rightsEnt.EntityType.isLookup(rightsUI.UsrEntities.getLkArray())) { %>
  <rgt:section>
    <rgt:crud rightType="<%=LkSNRightType.CategoriesOrganization%>"/>
    <rgt:crud rightType="<%=LkSNRightType.CategoriesPeople%>"/>
    <rgt:crud rightType="<%=LkSNRightType.CategoriesLocation%>"/>
    <rgt:crud rightType="<%=LkSNRightType.CategoriesAssociation%>"/>
    <rgt:crud rightType="<%=LkSNRightType.CategoriesWorkstation%>"/>
    <rgt:crud rightType="<%=LkSNRightType.CategoriesAccessPoint%>"/>
    <rgt:crud rightType="<%=LkSNRightType.CategoriesEvents%>"/>
    <rgt:crud rightType="<%=LkSNRightType.CategoriesProductTypes%>"/>
    <rgt:crud rightType="<%=LkSNRightType.CategoriesDocTemplates%>"/>
    <rgt:crud rightType="<%=LkSNRightType.CategoriesMessages%>"/>
    <rgt:crud rightType="<%=LkSNRightType.CategoriesCalendars%>"/>
    <rgt:crud rightType="<%=LkSNRightType.CategoriesLedgerRuleTemplates%>"/>
  </rgt:section>
<% } %>  
</rgt:menu-content>
