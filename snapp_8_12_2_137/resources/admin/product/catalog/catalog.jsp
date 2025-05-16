<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageCatalog" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% boolean canEdit = rights.Catalogs.canUpdate(); %>
<% int repositoryCount = pageBase.getDB().getInt("select Count(*) from tbRepository where EntityId=" + JvString.sqlStr(pageBase.getId())); %>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<div id="main-container">
  <v:tab-group name="tab" main="true"> 

    <%-- MAIN --%>
    <v:tab-item caption="@Common.Profile" icon="profile.png" jsp="catalog_tab_main.jsp" tab="main" default="true"/>

    <%-- REPOSITORY --%>
    <% if ((repositoryCount > 0) || pageBase.isTab("tab", "repository")) { %>
    <% String jsp_repository = "/admin?page=repositorylist_widget&id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Catalog.getCode() + "&readonly=" + !canEdit; %>
      <v:tab-item caption="@Common.Documents" icon="attachment.png" tab="repository" jsp="<%=jsp_repository%>" />
    <% } %>

    <%-- ADD --%>
    <% if (!pageBase.isNewItem()) { %>
      <v:tab-plus>
        <%-- IMPORT --%>
        <% String clickImport = "vgsImportDialog('" + pageBase.getContextURL() + "?page=catalog&id=" + pageBase.getId() + "&action=import')";  %>
        <v:popup-item caption="@Common.Import" fa="sign-in" linkClass="no-ajax" onclick="<%=clickImport%>"/>

        <%-- EXPORT --%>
        <% String hrefExport = pageBase.getContextURL() + "?page=catalog&action=export&id=" + pageBase.getId(); %>
        <v:popup-item caption="@Common.Export" fa="sign-out" linkClass="no-ajax" href="<%=hrefExport%>"/>

			  <%-- NOTES --%>
			  <% String onclickNotes = "asyncDialogEasy('common/notes_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Catalog.getCode() + "');"; %>
			  <v:popup-item caption="@Common.Notes" fa="comments" onclick="<%=onclickNotes%>"/>
			
			  <%-- HISTORY --%>
			  <% if (rights.History.getBoolean()) {%>
			    <% String onclickHistory = "asyncDialogEasy('common/history_detail_dialog', 'id=" + pageBase.getId() + "');"; %>
			    <v:popup-item caption="@Common.History" fa="history" onclick="<%=onclickHistory%>"/>
			  <% } %>  
			  
			  <% if (canEdit) { %>
			    <%-- UPLOAD --%>
			    <% String onclickUpload = "showUploadDialog(" + LkSNEntityType.Event.getCode() + ", '" + pageBase.getId() + "', " + (true/*product.RepositoryCount.getInt() == 0*/) + ");"; %>
			    <v:popup-item caption="@Common.UploadFile" title="@Common.UploadFileHint" fa="upload" onclick="<%=onclickUpload%>"/>
			  <% } %>
      </v:tab-plus>
    <% } %>
    
  </v:tab-group>
</div>


<jsp:include page="/resources/common/footer.jsp"/>
