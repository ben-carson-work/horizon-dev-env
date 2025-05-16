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

<rgt:menu-content id="rights-menu-localization">
  <% if (rightsEnt.EntityType.isLookup(rightsUI.WksEntities.getLkArray())) { %>
    <rgt:section>
      <rgt:combo rightType="<%=LkSNRightType.LangISO%>"/>
    </rgt:section>
  <% } %>

  <rgt:section caption="@Right.DateTimeSettings">
    <rgt:lookup-combo rightType="<%=LkSNRightType.ShortDateFormat%>" lookupTable="<%=LkSN.DateFormat%>"/>
    <rgt:lookup-combo rightType="<%=LkSNRightType.LongDateFormat%>" lookupTable="<%=LkSN.DateFormat%>"/>
    <rgt:lookup-combo rightType="<%=LkSNRightType.MonthDateFormat%>" lookupTable="<%=LkSN.DateFormat%>"/>
    <rgt:lookup-combo rightType="<%=LkSNRightType.ShortTimeFormat%>" lookupTable="<%=LkSN.TimeFormat%>"/>
    <rgt:lookup-combo rightType="<%=LkSNRightType.LongTimeFormat%>" lookupTable="<%=LkSN.TimeFormat%>"/>
    <rgt:lookup-combo rightType="<%=LkSNRightType.FirstDayOfWeek%>" lookupTable="<%=LkSN.DayOfWeek%>"/>
  </rgt:section>
  
  <% if (rightsEnt.EntityType.isLookup(rightsUI.WksEntities.getLkArray()) && rights.SuperUser.getBoolean() && !pageBase.isParameter("WksType", LkSNWorkstationType.APT.getCode())) { %>
    <rgt:section>
      <% if (rights.VGSSupport.getBoolean()) { %>
        <rgt:text rightType="<%=LkSNRightType.FiscalDateSwitchHour%>"/>
      <% } %>
      <rgt:lookup-combo rightType="<%=LkSNRightType.TimeZone%>" lookupTable="<%=LkSN.TimeZone%>"/>
    </rgt:section>
  <% } %>
  <% if(!pageBase.isParameter("WksType", LkSNWorkstationType.APT.getCode())) { %>
    <rgt:section caption="@Right.Formatting">
      <rgt:text rightType="<%=LkSNRightType.DecimalSeparator%>"/>
      <rgt:text rightType="<%=LkSNRightType.ThousandSeparator%>"/>
      <rgt:text rightType="<%=LkSNRightType.CSVSeparator%>"/>
      <rgt:lookup-combo rightType="<%=LkSNRightType.ExtDisplayCurrencyFormat%>" lookupTable="<%=LkSN.CurrencyFormat%>"/>
    </rgt:section>
 <% } %>
</rgt:menu-content>
