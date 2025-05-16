<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSaleChannel" scope="request"/>
<jsp:useBean id="saleChannel" class="com.vgs.snapp.dataobject.DOSaleChannel" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<v:page-form id="salechannel-form">
	<div id="main-container"> 
	  <v:tab-group name="tab" main="true">
	    <%-- PROFILE --%>
	    <v:tab-item caption="@Common.Profile" icon="profile.png" jsp="salechannel_tab_main.jsp" tab="main" default="true"/>
	    <%-- ADD --%>
	    <% if (!pageBase.isNewItem()) { %>
	      <v:tab-plus>
	        <%-- NOTES --%>
	        <% String hrefNotes = "javascript:asyncDialogEasy('common/notes_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.SaleChannel.getCode() + "');"; %>
	        <v:popup-item caption="@Common.Notes" fa="comments" href="<%=hrefNotes%>"/>
	
				  <%-- HISTORY --%>
				  <% if (rights.History.getBoolean()) { %>
				    <% String hrefHistory = "javascript:asyncDialogEasy('common/history_detail_dialog', 'id=" + pageBase.getId() + "');"; %>
				    <v:popup-item caption="@Common.History" fa="history" href="<%=hrefHistory%>"/>
				  <% } %>  
				  
	      </v:tab-plus>
	    <% } %>
	  </v:tab-group>
	</div>
</v:page-form>

<jsp:include page="/resources/common/footer.jsp"/>
