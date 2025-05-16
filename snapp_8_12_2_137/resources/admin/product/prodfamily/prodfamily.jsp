<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProductFamily" scope="request"/>
<jsp:useBean id="prodFamily" class="com.vgs.snapp.dataobject.DOProductFamily" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% boolean canEdit = pageBase.getRightCRUD().canUpdate(); %>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
<div id="main-container">
  <v:tab-group name="tab" main="true">
    <%-- PROFILE --%>
    <v:tab-item caption="@Common.Profile" icon="profile.png" jsp="prodfamily_tab_main.jsp" tab="main" default="true"/>
    <% if (!pageBase.isNewItem()) { %>
      <%-- RICHDESC --%>
      <v:tab-item caption="@Common.Description" icon="<%=BLBO_RichDesc.ICONNAME_RICHDESC%>" tab="description" jsp="prodfamily_tab_description.jsp"/>
      
      <%-- PRODUCT TYPE --%>
      <% if ((prodFamily.ProductCount.getInt() > 0) || pageBase.isTab("tab", "product")) { %>
      <% String jsp_product = "/admin?page=product_list&widget=true&ParentEntityId=" + pageBase.getId() + "&ParentEntityType=" + LkSNEntityType.ProductFamily.getCode(); %>
        <v:tab-item caption="@Product.ProductTypes" icon="<%=LkSNEntityType.ProductType.getIconName()%>" tab="product" jsp="<%=jsp_product%>" />
      <% } %>

      <%-- UPGRADE --%>
      <% if ((!prodFamily.TargetProductFamilyId.isNull()) || pageBase.isTab("tab", "target")) { %>
        <v:tab-item caption="@Product.Upgrades" fa="sort" tab="target" jsp="prodfamily_tab_target.jsp"/>
      <% } %>
      
      <%-- REPOSITORY --%>
      <% if ((prodFamily.RepositoryCount.getInt() > 0) || pageBase.isTab("tab", "repository")) { %>
        <% String jsp_repository = "/admin?page=repositorylist_widget&id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.ProductFamily.getCode() + "&readonly=" + !canEdit; %>
        <v:tab-item caption="@Common.Documents" icon="attachment.png" tab="repository" jsp="<%=jsp_repository%>" />
      <% } %>
      
      <%-- ADD --%>
      <% if (canEdit) { %>
        <v:tab-plus>
				  <%-- PRODUCT --%>
				  <% String hrefProduct = "javascript:asyncDialogEasy('product/product_create_dialog', 'ParentEntityType=" + LkSNEntityType.ProductFamily.getCode() + "&ParentEntityId=" + pageBase.getId() + "')"; %>
				  <v:popup-item caption="@Product.NewProductType" icon="<%=LkSNEntityType.ProductType.getIconName()%>" href="<%=hrefProduct%>"/>
				  
				  <%-- UPGRADE --%>  
				  <% if (!prodFamily.TargetProductFamilyId.isNull()) { %>
				    <% String hrefTarget = ConfigTag.getValue("site_url") + "/admin?page=prodfamily&tab=target&id=" + pageBase.getId();%>
				    <v:popup-item caption="@Product.Upgrades" fa="sort" href="<%=hrefTarget%>"/>
				  <% } %>
				  
				  <%-- ENTITY TAB --%>
				  <% String hrefEntityTab = "javascript:asyncDialogEasy('event/entity_tab_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.ProductFamily.getCode() + "')"; %>
				  <v:popup-item caption="Entity Tabs" icon="bkoact-tabs-black.png" href="<%=hrefEntityTab%>"/>
				    
				  <%-- NOTES --%>
				  <% String hrefNotes = "javascript:asyncDialogEasy('common/notes_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.ProductFamily.getCode() + "');"; %>
				  <v:popup-item caption="@Common.Notes" fa="comments" href="<%=hrefNotes%>"/>
				  
				  <%-- HISTORY --%>
          <% if (rights.History.getBoolean()) { %>
            <% String hrefHistory = "javascript:asyncDialogEasy('common/history_detail_dialog', 'id=" + pageBase.getId() + "');"; %>
            <v:popup-item caption="@Common.History" fa="history" href="<%=hrefHistory%>"/>
          <% } %>  
				  
				  <%-- UPLOAD --%>
				  <% String hrefUpload = "javascript:showUploadDialog(" + LkSNEntityType.ProductFamily.getCode() + ", '" + pageBase.getId() + "', " + (prodFamily.RepositoryCount.getInt() == 0) + ");"; %>
				  <v:popup-item caption="@Common.UploadFile" title="@Common.UploadFileHint" fa="upload" href="<%=hrefUpload%>"/>
        </v:tab-plus>
      <% } %>
    <% } %>
  </v:tab-group>
</div>

<jsp:include page="/resources/common/footer.jsp"/>
