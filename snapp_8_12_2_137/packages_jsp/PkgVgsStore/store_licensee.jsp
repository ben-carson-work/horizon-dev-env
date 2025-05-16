<%@page import="com.vgs.web.page.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<jsp:include page="/resources/common/header.jsp"/>
<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<v:page-title-box/>

<v:tab-group name="tab" main="true">
  <v:tab-item tab="main" caption="@Common.Profile" icon="profile.png" jsp="store_licensee_tab_main.jsp" default="true"/>
  <v:tab-item tab="actkey" caption="Activation keys" icon="station.png" jsp="store_licensee_tab_actkey.jsp" include="<%=!pageBase.isNewItem()%>"/>
  <v:tab-item tab="history" caption="History" fa="clock-rotate-left" jsp="store_licensee_tab_history.jsp" include="<%=!pageBase.isNewItem()%>"/>
</v:tab-group>

<jsp:include page="/resources/common/footer.jsp"/>
