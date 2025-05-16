<%@page import="com.vgs.web.library.product.BLBO_SaleCapacityAccount"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PagePromoRuleList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>


<v:tab-group name="tab" main="true">
  <v:tab-item tab="promo" caption="@Product.PromoRules" icon="promorule.png" jsp="promorule_list_tab_promo.jsp" include="<%=pageBase.getBL(BLBO_PromoRule.class).getPromoRuleRightController().getOverallCRUD().canRead()%>"/>
  <v:tab-item tab="sca" caption="@SaleCapacity.SaleCapacityAccounts" fa="battery-half" jsp="promorule_list_tab_salecapacityaccount.jsp" include="<%=pageBase.getBL(BLBO_SaleCapacityAccount.class).getSaleCapacityAccountRightController().getOverallCRUD().canRead()%>"/>
</v:tab-group>


<jsp:include page="/resources/common/footer.jsp"/>
