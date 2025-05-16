<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" scope="request" class="com.vgs.snapp.web.b2b.page.PageB2B_User"/>
<jsp:useBean id="account" scope="request" class="com.vgs.snapp.dataobject.DOAccount"/>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<v:tab-group name="tab" main="true">
  <v:tab-item caption="@Common.Profile" tab="main" jsp="user_tab_main.jsp" default="true" />
  <v:tab-item caption="@Account.Security" tab="security" jsp="user_tab_security.jsp" include="<%=!pageBase.isNewItem()%>"/>
  <v:tab-item caption="@Common.Email" fa="envelope" tab="action" jsp="user_tab_action.jsp" include="<%=(account.ActionCount.getInt() > 0) || pageBase.isTab(\"tab\", \"action\")%>"/>
</v:tab-group>

<jsp:include page="/resources/common/footer.jsp"/>
