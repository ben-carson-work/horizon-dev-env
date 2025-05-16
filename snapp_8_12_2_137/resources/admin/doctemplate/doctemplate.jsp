<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageDocTemplate" scope="request"/>
<jsp:useBean id="doc" class="com.vgs.web.dataobject.DOUI_DocTemplate" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
<%
boolean canEdit = pageBase.getBLDef().getDocRightCRUD(doc).canUpdate(); 
request.setAttribute("EntityRight_CanEdit", canEdit);
request.setAttribute("EntityRight_DocEntityType", LkSNEntityType.DocTemplate);
request.setAttribute("EntityRight_DocEntityId", pageBase.getId());
request.setAttribute("EntityRight_EntityTypes", new LookupItem[] {LkSNEntityType.Workstation, LkSNEntityType.Person});
request.setAttribute("EntityRight_ShowRightLevelEdit", true);
request.setAttribute("EntityRight_ShowRightLevelDelete", true);
request.setAttribute("EntityRight_HistoryField", LkSNHistoryField.DocTemplate_EntityRights);
boolean showGraphicEditor = pageBase.getBLDef().hasGraphicEditor(doc);
%>

<script>

function showImportDialog() {
  vgsImportDialog(BASE_URL + "/admin?page=doctemplate&action=import&id=<%=pageBase.getId()%>");
}

function showExecutorDialog() {
  asyncDialogEasy("doctemplate/reportexec_dialog", "id=<%=pageBase.getId()%>");
}

</script>


<div id="main-container">
  <v:tab-group name="tab" main="true">
    <%-- MAIN --%>
    <v:tab-item caption="@Common.Profile" icon="profile.png" jsp="doctemplate_tab_main.jsp" tab="main" default="true"/>

    <% if (!pageBase.isNewItem()) { %>
      <%-- DESCRIPTION --%>    
     	<v:tab-item caption="@Common.Description" icon="<%=BLBO_RichDesc.ICONNAME_RICHDESC%>" tab="description" jsp="doctemplate_tab_description.jsp" />
     	
      <%-- TEMPLATE --%>
      <% if (doc.DocEditorType.isLookup(LkSNDocEditorType.Receipt, LkSNDocEditorType.MediaFGL, LkSNDocEditorType.VoucherFGL, LkSNDocEditorType.Phone)) { %>
        <v:tab-item caption="@Common.Layout" fa="ruler-triangle" jsp="doctemplate_tab_template_text.jsp" tab="template" linkClazz="no-ajax"/>
      <% } else if (!showGraphicEditor && doc.DocEditorType.isLookup(LkSNDocEditorType.Report, LkSNDocEditorType.MediaSNP, LkSNDocEditorType.VoucherSNP)) { %>
        <v:tab-item caption="@Common.Layout" fa="ruler-triangle" jsp="doctemplate_tab_template_json.jsp" tab="template" linkClazz="no-ajax"/>
      <% } else if (doc.DocEditorType.isLookup(LkSNDocEditorType.Html)) { %>
        <v:tab-item caption="@Common.Layout" fa="ruler-triangle" jsp="doctemplate_tab_template_html.jsp" tab="template" linkClazz="no-ajax"/>
      <% } else if (doc.DocEditorType.isLookup(LkSNDocEditorType.Email)) { %>
        <v:tab-item caption="@Common.Layout" fa="ruler-triangle" jsp="doctemplate_tab_template_email.jsp" tab="template" linkClazz="no-ajax"/>
      <%
      } else if (doc.DocEditorType.isLookup(LkSNDocEditorType.MobileWallet)) {
      %>
      	<v:tab-item caption="@Common.Layout" fa="ruler-triangle" jsp="doctemplate_tab_template_eticket.jsp" tab="template" linkClazz="no-ajax"/>
	  <% } %>
	  
      <%-- DATASOURCE --%>
      <% if ((doc.DocTemplateType.isLookup(LkSNDocTemplateType.StatReport, LkSNDocTemplateType.AdvancedNotification) || doc.DocEditorType.isLookup(LkSNDocEditorType.Report)) && !doc.DocTemplateType.isLookup(LkSNDocTemplateType.Invoice)) { %>
        <v:tab-item caption="@DocTemplate.DataSources" fa="database" jsp="doctemplate_tab_datasource.jsp" linkClazz="no-ajax" tab="datasource"/>
      <% } %>

      <%-- SCHEDULE --%>
      <% if (doc.DocTemplateType.isLookup(LkSNDocTemplateType.StatReport, LkSNDocTemplateType.AdvancedNotification)) { %>
        <v:tab-item caption="@Common.Schedule" fa="clock" jsp="doctemplate_tab_task.jsp" tab="task"/>
      <% } %>

      <%-- RIGHTS --%>
      <% if (doc.DocTemplateType.isLookup(LkSNDocTemplateType.StatReport, LkSNDocTemplateType.OrderConfirmation)) { %>
        <v:tab-item caption="@Common.Rights" icon="<%=LkSNEntityType.Login.getIconName()%>" jsp="../common/page_tab_rights.jsp" tab="rights"/>
      <% } %>

      <%-- REPOSITORY --%>
      <% String jsp_repository = "/admin?page=repositorylist_widget&id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.DocTemplate.getCode() + "&readonly=" + !canEdit; %>
      <v:tab-item caption="@Common.Documents" icon="attachment.png" tab="repository" jsp="<%=jsp_repository%>" />
              
      <%-- ACTION --%>
      <% if ((doc.ActionCount.getInt() > 0) || pageBase.isTab("tab", "action")) { %>
        <v:tab-item caption="@Common.Email" fa="envelope" tab="action" jsp="../common/page_tab_actions.jsp" />
      <% } %>

      <%-- LOG --%>
      <% if (doc.LogCount.getInt() > 0) { %>
        <v:tab-item caption="@Common.Logs" icon="<%=LkSNEntityType.Log.getIconName()%>" tab="log" jsp="../common/page_tab_logs.jsp"/>
      <% } %>

      <%-- ADD --%>
      <% if (!pageBase.isNewItem()) { %>
        <v:tab-plus>
				  <%-- NOTES --%>
				  <% String hrefNotes = "javascript:asyncDialogEasy('common/notes_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.DocTemplate.getCode() + "');"; %>
				  <v:popup-item caption="@Common.Notes" fa="comments" href="<%=hrefNotes%>"/>
				  
				  <%-- HISTORY --%>
				  <% if (rights.History.getBoolean()) { %>
				    <% String hrefHistory = "javascript:asyncDialogEasy('common/history_detail_dialog', 'id=" + pageBase.getId() + "');"; %>
				    <v:popup-item caption="@Common.History" fa="history" href="<%=hrefHistory%>"/>
				  <% } %>  
				  <% if (canEdit) { %>
				    <%-- UPLOAD --%>
				    <% String hrefUpload = "javascript:showUploadDialog(" + LkSNEntityType.DocTemplate.getCode() + ", '" + pageBase.getId() + "', " + (true/*product.RepositoryCount.getInt() == 0*/) + ");"; %>
				    <v:popup-item caption="@Common.UploadFile" title="@Common.UploadFileHint" fa="upload" href="<%=hrefUpload%>"/>
				  <% } %>
        </v:tab-plus>
      <% } %>
    <% } %>
  </v:tab-group>
</div>

<jsp:include page="/resources/common/footer.jsp"/>
