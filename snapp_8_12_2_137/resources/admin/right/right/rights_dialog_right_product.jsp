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

<rgt:menu-content id="rights-menu-product">
<% if (rightsEnt.EntityType.isLookup(rightsUI.WksEntities.getLkArray())) { %>
  <rgt:section caption="@Right.TagFiltersINC">
    <rgt:bool rightType="<%=LkSNRightType.TagFilters%>"/>
    <rgt:subset>
      <rgt:multi rightType="<%=LkSNRightType.ProductTags%>"/>
      <rgt:multi rightType="<%=LkSNRightType.EventTags%>"/>
      <rgt:multi rightType="<%=LkSNRightType.CategoryTags%>"/>
    </rgt:subset>
  </rgt:section>
<% } %>

<rgt:section caption="@Product.ProductTypes">
  <rgt:crud-group rightType="<%=LkSNRightType.ProductTypes%>"/>
  <rgt:bool rightType="<%=LkSNRightType.EditStopSaleDates%>"/>
  <rgt:multi rightType="<%=LkSNRightType.ProductTypeCategories%>"/>
</rgt:section>

<rgt:section>
  <rgt:crud rightType="<%=LkSNRightType.Catalogs%>"/>
  <rgt:crud rightType="<%=LkSNRightType.PromotionRules%>"/>
</rgt:section>

<rgt:section caption="@Event.Events">
  <rgt:bool rightType="<%=LkSNRightType.EventView_All%>"/>
  <rgt:multi rightType="<%=LkSNRightType.EventView_Tags%>"/>
  <rgt:bool rightType="<%=LkSNRightType.EventEdit_All%>"/>
  <rgt:multi rightType="<%=LkSNRightType.EventEdit_Tags%>"/>
  <rgt:bool rightType="<%=LkSNRightType.EventAdd_All%>"/>
  <rgt:multi rightType="<%=LkSNRightType.EventAdd_Tags%>"/>
  <rgt:bool rightType="<%=LkSNRightType.EventDelete_All%>"/>
  <rgt:multi rightType="<%=LkSNRightType.EventDelete_Tags%>"/>
  <rgt:bool rightType="<%=LkSNRightType.PerformanceEdit_All%>"/>
  <rgt:multi rightType="<%=LkSNRightType.PerformanceEdit_Tags%>"/>
  <rgt:bool rightType="<%=LkSNRightType.EnvelopeConfEdit_All%>"/>
  <rgt:multi rightType="<%=LkSNRightType.EnvelopeConfEdit_Tags%>"/>
  <rgt:bool rightType="<%=LkSNRightType.EnvelopeQtysEdit_All%>"/>
  <rgt:multi rightType="<%=LkSNRightType.EnvelopeQtysEdit_Tags%>"/>
</rgt:section>    
  
<rgt:section>
  <rgt:bool rightType="<%=LkSNRightType.BulkEntitlementReplace%>"/>
</rgt:section>
  
<% if (rightsEnt.EntityType.isLookup(rightsUI.UsrEntities.getLkArray())) { %>
  <rgt:section caption="@Right.TagFiltersNOT">
    <rgt:multi rightType="<%=LkSNRightType.ProductNotTags%>"/>
    <rgt:multi rightType="<%=LkSNRightType.EventNotTags%>"/>
    <rgt:multi rightType="<%=LkSNRightType.CategoryNotTags%>"/>
  </rgt:section>    
<% } %>
</rgt:menu-content>
