<%@page import="com.vgs.web.library.BLBO_Calendar"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.snapp.web.bko.library.BLBO_Installment"%>
<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProduct" scope="request"/>
<jsp:useBean id="product" class="com.vgs.snapp.dataobject.DOProduct" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% 
boolean canEdit = pageBase.getRightCRUD().canUpdate(); 
request.setAttribute("EntityRight_DocEntityType", LkSNEntityType.ProductType);
request.setAttribute("EntityRight_DocEntityId", pageBase.getId());
request.setAttribute("EntityRight_EntityTypes", new LookupItem[] {LkSNEntityType.Person, LkSNEntityType.Organization, LkSNEntityType.SaleChannel});
request.setAttribute("EntityRight_HistoryField", LkSNHistoryField.ProductType_EntityRights);
request.setAttribute("EntityRight_ShowRightLevelEdit", false);
request.setAttribute("EntityRight_ShowRightLevelDelete", false);
request.setAttribute("EntityRight_CanEdit", canEdit);
%>

<jsp:include page="../common/page_tab_rights.jsp"></jsp:include>
