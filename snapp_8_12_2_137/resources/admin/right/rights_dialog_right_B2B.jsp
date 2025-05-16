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

<rgt:menu>
  <rgt:menu-divider/>
  <rgt:menu-item contentId="rights-menu-tools"     fa="tools"       color="gray"  caption="@System.Functions"/>

  <rgt:menu-divider/>
  <rgt:menu-item contentId="rights-menu-finance" fa="dollar-sign" color="blue"  caption="@Right.Finance"/>
</rgt:menu>

<rgt:menu-body>
  <rgt:menu-content id="rights-menu-tools">
    <rgt:section>
      <rgt:bool rightType="<%=LkSNRightType.B2BAgent_Admin%>"/>
      <rgt:bool rightType="<%=LkSNRightType.B2BAgent_ManageUsers%>"/>
      <rgt:bool rightType="<%=LkSNRightType.B2BAgent_ManageOrders%>"/>
      <rgt:bool rightType="<%=LkSNRightType.B2BAgent_ViewFinance%>"/>
      <rgt:bool rightType="<%=LkSNRightType.B2BAgent_ManageFinance%>"/>
      <rgt:bool rightType="<%=LkSNRightType.B2BAgent_Reports%>"/>
      <rgt:bool rightType="<%=LkSNRightType.B2BAgent_EditPersonalData%>"/>
      <rgt:lookup-combo rightType="<%=LkSNRightType.B2BAgent_PahDownloadOption%>" lookupTable="<%=LkSN.PahDownloadOption%>"/>
	  </rgt:section>
  </rgt:menu-content>
  
  <rgt:menu-content id="rights-menu-finance">
    <rgt:section>
      <rgt:multi rightType="<%=LkSNRightType.PaymentMethodsIDs%>"/>
    </rgt:section>
  </rgt:menu-content>
</rgt:menu-body>
