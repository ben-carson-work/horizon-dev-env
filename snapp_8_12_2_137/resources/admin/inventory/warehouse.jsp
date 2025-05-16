<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageWarehouse" scope="request"/>
<jsp:useBean id="tax" class="com.vgs.snapp.dataobject.DOTax" scope="request"/>
<jsp:useBean id="warehouse" class="com.vgs.snapp.dataobject.DOWarehouse" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% boolean canEdit = true; %>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<div id="main-container">
  <v:tab-group name="tab" main="true">
    <%-- PROFILE --%>
    <v:tab-item caption="@Common.Profile" icon="profile.png" jsp="warehouse_tab_main.jsp" tab="main" default="true"/>
    <%-- STOCK --%>
    <v:tab-item caption="@Common.Inventory" icon="<%=LkSNEntityType.ProductType.getIconName()%>" jsp="warehouse_tab_stock.jsp" tab="stock"/>

    <%-- ADD --%>
    <% if (!pageBase.isNewItem()) { %>
      <v:tab-plus>
			  <%-- NOTES --%>
			  <% String hrefNotes = "javascript:asyncDialogEasy('common/notes_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Warehouse.getCode() + "');"; %>
			  <v:popup-item caption="@Common.Notes" fa="comments" href="<%=hrefNotes%>"/>
			
			  <%-- HISTORY --%>
			  <% if (rights.History.getBoolean()) {%>
			    <% String hrefHistory = "javascript:asyncDialogEasy('common/history_detail_dialog', 'id=" + pageBase.getId() + "');"; %>
			    <v:popup-item caption="@Common.History" fa="history" href="<%=hrefHistory%>"/>
			  <% } %>
			  <% if (canEdit) { %>
			    <%-- UPLOAD --%>
			    <% String hrefUpload = "javascript:showUploadDialog(" + LkSNEntityType.Warehouse.getCode() + ", '" + pageBase.getId() + "', " + (true/*product.RepositoryCount.getInt() == 0*/) + ");"; %>
			    <v:popup-item caption="@Common.UploadFile" title="@Common.UploadFileHint" fa="upload" href="<%=hrefUpload%>"/>
			  <% } %>
      </v:tab-plus>
    <% } %>
  </v:tab-group>
</div>

<jsp:include page="/resources/common/footer.jsp"/>
