<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageCategory" scope="request"/>
<jsp:useBean id="cat" class="com.vgs.entity.dataobject.DOCategoryNode" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% LookupItem entityType = LkSN.EntityType.getItemByCode(cat.EntityType.getInt());%>
<% boolean canEdit = pageBase.getCategoryRights(entityType).canUpdate(); %>

<jsp:include page="../common/header.jsp"/>

<v:page-title-box/>

<v:tab-group name="tab" id="main-tab-group" main="true">
  <% //--- MAIN ---// %>
  <v:tab-item caption="@Common.Profile" icon="profile.png" jsp="category_tab_main.jsp" tab="main" default="true"/>
  <%-- REPOSITORY --%>
  <% if ((cat.RepositoryCount.getInt() > 0) || pageBase.isTab("tab", "repository")) { %>
    <% String jsp_repository = "/admin?page=repositorylist_widget&id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Category.getCode(); %>
    <v:tab-item caption="@Common.Documents" icon="attachment.png" tab="repository" jsp="<%=jsp_repository%>" />  
  <% } %>  
    
  <% if (canEdit) { %>
  <%-- ADD --%>
  <v:tab-plus>
	  <%-- UPLOAD --%>
	  <% String hrefUpload = "javascript:showUploadDialog(" + LkSNEntityType.Category.getCode() + ", '" + pageBase.getId() + "', " + (cat.RepositoryCount.getInt() == 0) + ");"; %>
	  <v:popup-item caption="@Common.UploadFile" title="@Common.UploadFileHint" fa="upload" href="<%=hrefUpload%>"/>
	  
	  <%-- HISTORY --%>
    <% if (rights.History.getBoolean()) { %>
      <% String hrefHistory = "javascript:asyncDialogEasy('common/history_detail_dialog', 'id=" + pageBase.getId() + "');"; %>
      <v:popup-item caption="@Common.History" fa="history" href="<%=hrefHistory%>"/>
    <% } %>  	  
  </v:tab-plus>
  <% } %>
</v:tab-group>

<jsp:include page="../common/footer.jsp"/>
