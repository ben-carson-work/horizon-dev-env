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

<rgt:menu-content id="rights-menu-custdisplay">
 <% if (rightsEnt.EntityType.isLookup(rightsUI.WksEntities.getLkArray())) { %>
  <rgt:section caption="@Common.CustDisplay">
    <rgt:text rightType="<%=LkSNRightType.CustDisplay_IdleURL%>"/>
    <rgt:text rightType="<%=LkSNRightType.CustDisplay_TrnURL%>"/>
  </rgt:section>
  
  <rgt:section caption="@Right.UpSelling">
    <rgt:text rightType="<%=LkSNRightType.BrowserURL%>"/>
    <rgt:text rightType="<%=LkSNRightType.UpsellURL%>"/>
  </rgt:section>
  
  <rgt:section caption="@Right.ScreenSaver">
    <rgt:text rightType="<%=LkSNRightType.PromoURL%>"/>
    <rgt:text rightType="<%=LkSNRightType.PromoTimer%>"/>
  </rgt:section>
<% } %>
</rgt:menu-content>
