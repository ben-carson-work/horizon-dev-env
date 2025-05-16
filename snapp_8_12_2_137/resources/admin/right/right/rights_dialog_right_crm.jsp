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

<rgt:menu-content id="rights-menu-crm">
  <rgt:section caption="@Account.Organizations">
    <rgt:crud-group rightType="<%=LkSNRightType.AccountORGs%>"/>
    <rgt:multi rightType="<%=LkSNRightType.OrgCategoryReadIDs%>"/>
    <rgt:multi rightType="<%=LkSNRightType.OrgCategoryEditIDs%>"/>
    <rgt:multi rightType="<%=LkSNRightType.OrgCategoryCreateIDs%>"/>
    <rgt:multi rightType="<%=LkSNRightType.OrgCategoryDeleteIDs%>"/>
  </rgt:section>
  
  <rgt:section caption="@Account.Persons">
    <rgt:crud-group rightType="<%=LkSNRightType.AccountPRSs%>"/>
    <rgt:multi rightType="<%=LkSNRightType.PeopleCategoryReadIDs%>"/>
    <rgt:multi rightType="<%=LkSNRightType.PeopleCategoryEditIDs%>"/>
    <rgt:multi rightType="<%=LkSNRightType.PeopleCategoryCreateIDs%>"/>
    <rgt:multi rightType="<%=LkSNRightType.PeopleCategoryDeleteIDs%>"/>
  </rgt:section>
  
  <rgt:section caption="@Account.Associations">
    <rgt:crud-group rightType="<%=LkSNRightType.AccountASCs%>"/>
    <rgt:multi rightType="<%=LkSNRightType.AscCategoryReadIDs%>"/>
    <rgt:multi rightType="<%=LkSNRightType.AscCategoryEditIDs%>"/>
    <rgt:multi rightType="<%=LkSNRightType.AscCategoryCreateIDs%>"/>
    <rgt:multi rightType="<%=LkSNRightType.AscCategoryDeleteIDs%>"/>
  </rgt:section>

  <rgt:section caption="@Account.Accounts">
    <rgt:bool rightType="<%=LkSNRightType.LoadRecentAccount%>"/>
    <rgt:text rightType="<%=LkSNRightType.AllowAccountUpdateAfterCreateMins%>"/>
  </rgt:section>

  <rgt:section caption="@Right.SecurityEdit">
    <rgt:bool rightType="<%=LkSNRightType.EditOwnProfile%>"/>
    <rgt:crud-group rightType="<%=LkSNRightType.SecurityEdit%>"/>
    <rgt:multi rightType="<%=LkSNRightType.SecurityProfileCategoryReadIDs%>"/>
    <rgt:multi rightType="<%=LkSNRightType.SecurityProfileCategoryEditIDs%>"/>
    <rgt:multi rightType="<%=LkSNRightType.SecurityProfileCategoryCreateIDs%>"/>
    <rgt:multi rightType="<%=LkSNRightType.SecurityProfileCategoryDeleteIDs%>"/>
  </rgt:section>

  <rgt:section>
    <rgt:bool rightType="<%=LkSNRightType.AccountCategorySelection%>"/>
    <rgt:bool rightType="<%=LkSNRightType.RightsEdit%>"/>
    <rgt:bool rightType="<%=LkSNRightType.AccountBlock%>"/>
    <rgt:bool rightType="<%=LkSNRightType.EditAccountCode%>"/>
    <rgt:bool rightType="<%=LkSNRightType.CreateTourOperator%>"/>
    <rgt:bool rightType="<%=LkSNRightType.CreateTourGuide%>"/>
  </rgt:section>  
    
  <rgt:section caption="@Account.Credit.Finance">
    <rgt:crud rightType="<%=LkSNRightType.SalesTerms%>"/>
    <rgt:crud rightType="<%=LkSNRightType.CreditLine%>"/>
    <rgt:bool rightType="<%=LkSNRightType.CreditSettle%>"/>
  </rgt:section>

  <rgt:section caption="@Common.Various">
    <rgt:bool rightType="<%=LkSNRightType.DraftEmailEdit%>"/>
  </rgt:section>
</rgt:menu-content>
