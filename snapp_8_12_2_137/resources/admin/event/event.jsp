<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageEvent" scope="request"/>
<jsp:useBean id="event" class="com.vgs.snapp.dataobject.DOEvent" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
boolean xpiEvent = !event.CrossPlatformId.isNull(); 
boolean canEdit = pageBase.getRightCRUD().canUpdate();
%>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<div id="main-container">
  <v:tab-group name="tab" main="true">
    <%-- PROFILE --%>
    <v:tab-item caption="@Common.Profile" icon="profile.png" jsp="event_tab_main.jsp" tab="main" default="true"/>
    <% if (!pageBase.isNewItem()) { %>
      <%-- RICHDESC --%>
      <v:tab-item caption="@Common.Description" icon="<%=BLBO_RichDesc.ICONNAME_RICHDESC%>" tab="description" jsp="event_tab_description.jsp" />
      
      <%-- PERFORMANCE --%>
      <% String jsp_perf = "/admin?page=performance_list_widget&EventId=" + pageBase.getId();
         if (xpiEvent)
           jsp_perf = jsp_perf + "&XPI=true";
      %>
      <v:tab-item caption="@Performance.Performances" icon="performance.png" tab="perf" jsp="<%=jsp_perf%>" />

      <v:tab-item caption="@Event.Events" icon="<%=LkSNEntityType.Event.getIconName()%>" tab="eventlink" jsp="event_tab_eventlink.jsp" include="<%=event.EventType.isLookup(LkSNEventType.Itinerary)%>"/>

      <%-- PRODUCT TYPE --%>
      <% if ((event.ProductCount.getInt() > 0) || pageBase.isTab("tab", "product")) { %>
      <% String jsp_product = "/admin?page=product_list&widget=true&ParentEntityId=" + pageBase.getId() + "&ParentEntityType=" + LkSNEntityType.Event.getCode(); %>
        <v:tab-item caption="@Product.ProductTypes" icon="<%=LkSNEntityType.ProductType.getIconName()%>" tab="product" jsp="<%=jsp_product%>" />
      <% } %>
      
      <%-- PRODUCT FAMILY --%>
      <% if ((event.ProductFamilyCount.getInt() > 0) || pageBase.isTab("tab", "productfamily")) { %>
        <% String jsp_productfamily = "/admin?page=prodfamily_list&widget=true&ParentEntityId=" + pageBase.getId() + "&ParentEntityType=" + LkSNEntityType.Event.getCode(); %>
        <v:tab-item caption="@Product.ProductFamilies" icon="<%=LkSNEntityType.ProductFamily.getIconName()%>" tab="productfamily" jsp="<%=jsp_productfamily%>" />
      <% } %>

      <%-- ATTRIBUTE --%>
      <% if ((event.AttributeCount.getInt() > 0) || pageBase.isTab("tab", "attribute")) { %>
      <% String jsp_attribute = "/admin?page=attribute_list&widget=true&ParentEntityId=" + pageBase.getId() + "&ParentEntityType=" + LkSNEntityType.Event.getCode(); %>
        <v:tab-item caption="@Product.Attributes" icon="attribute.png" tab="attribute" jsp="<%=jsp_attribute%>" />
      <% } %>

      <%-- PERF.TYPE --%>
      <% if ((event.PerformanceTypeCount.getInt() > 0) || pageBase.isTab("tab", "perftype")) { %>
        <% String jsp_perftype = pageBase.getContextURI() + "?page=widget&jsp=dynprice/dynprice_tab_perftype&ParentEntityType=" + LkSNEntityType.Event.getCode() + "&ParentEntityId=" + pageBase.getId(); %>
        <v:tab-item caption="@Performance.PerformanceTypes" icon="pricetable.png" title="@Performance.PerformanceTypes" tab="perftype" jsp="<%=jsp_perftype%>" />
      <% } %>

      <v:tab-item caption="@Event.DynRateCode" icon="coins.png" tab="dynratecode" jsp="event_tab_dynratecode.jsp" />
      <v:tab-item caption="@Event.CapacityReallocation" icon="<%=LkSNEntityType.SeatMap.getIconName()%>" tab="caprealloc" jsp="event_tab_caprealloc.jsp" include="<%=!event.CapacityThresholdList.isEmpty() || pageBase.isTab(\"tab\", \"caprealloc\")%>"/>
      <v:tab-item caption="@Resource.ResourceManagement" icon="<%=LkSNEntityType.ResourceType.getIconName()%>" tab="resconfig" jsp="event_tab_resconfig.jsp" include="<%=((event.ResourceTypeCount.getInt() > 0) || pageBase.isTab(\"tab\", \"resconfig\")) && rights.ResourceManagement.canRead()%>"/>
      <v:tab-item caption="@Event.QueueControl" fa="users" tab="queue" jsp="event_tab_queue.jsp" include="<%=event.QueueControl.getBoolean()%>"/>

      <%-- REPOSITORY --%>
      <% if ((event.RepositoryCount.getInt() > 0) || pageBase.isTab("tab", "repository")) { %>
      <% String jsp_repository = "/admin?page=repositorylist_widget&id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Event.getCode() + "&readonly=" + !canEdit; %>
        <v:tab-item caption="@Common.Documents" icon="attachment.png" tab="repository" jsp="<%=jsp_repository%>" />
      <% } %>

      <%-- ADD --%>
      <% if (!pageBase.isNewItem() && canEdit) { %>
        <v:tab-plus>
          <%-- PRODUCT --%>
          <% String hrefProduct = "javascript:asyncDialogEasy('product/product_create_dialog', 'ParentEntityType=" + LkSNEntityType.Event.getCode() + "&ParentEntityId=" + pageBase.getId() + "')"; %>
          <v:popup-item caption="@Product.NewProductType" icon="<%=LkSNEntityType.ProductType.getIconName()%>" href="<%=hrefProduct%>"/>
          <%-- PRODUCT FAMILY --%>
          <% String hrefProductFamily = ConfigTag.getValue("site_url") + "/admin?page=prodfamily&id=new&ParentEntityType=" + LkSNEntityType.Event.getCode() + "&ParentEntityId=" + pageBase.getId(); %>
          <v:popup-item caption="@Product.NewProductFamily" icon="<%=LkSNEntityType.ProductFamily.getIconName()%>" href="<%=hrefProductFamily%>"/>
          <%-- ATTRIBUTE --%>
          <% String hrefAttribute = "javascript:asyncDialogEasy('attribute/attribute_dialog', 'id=new&ParentEntityType=" + LkSNEntityType.Event.getCode() + "&ParentEntityId=" + pageBase.getId() + "')"; %>
          <v:popup-item caption="@Product.NewAttribute" icon="attribute.png" href="<%=hrefAttribute%>"/>
          <%-- PERF.TYPE --%>
          <% String hrefPerfType = ConfigTag.getValue("site_url") + "/admin?page=performancetype&id=new&ParentEntityType=" + LkSNEntityType.Event.getCode() + "&ParentEntityId=" + pageBase.getId(); %>
          <v:popup-item caption="@Performance.NewPerformanceType" icon="pricetable.png" href="<%=hrefPerfType%>"/>
          <%-- CAPACITY REALLOCATION --%>
          <% String hrefRealloaction = ConfigTag.getValue("site_url") + "/admin?page=event&tab=caprealloc&id=" + pageBase.getId(); %>
          <v:popup-item caption="@Event.CapacityReallocation" icon="<%=LkSNEntityType.SeatMap.getIconName()%>" href="<%=hrefRealloaction%>"/>
          <%-- RESOURCE CONFIG --%>
          <% String hrefResourceType = ConfigTag.getValue("site_url") + "/admin?page=event&tab=resconfig&id=" + pageBase.getId(); %>
          <v:popup-item caption="@Resource.ResourceManagement" icon="<%=LkSNEntityType.ResourceType.getIconName()%>" href="<%=hrefResourceType%>"/>
          <%-- ENTITY TAB --%>
          <% String hrefEntityTab = "javascript:asyncDialogEasy('event/entity_tab_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Event.getCode() + "')"; %>
          <v:popup-item caption="@Common.EntityTab" icon="bkoact-tabs-black.png" href="<%=hrefEntityTab%>"/>
        
          <%-- RELATED LOCATIONS --%>
          <% String hrefLocationTab = "javascript:asyncDialogEasy('common/location_list_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Event.getCode() + "')"; %>
          <v:popup-item caption="@Common.RelatedLocations" fa="map-marker" href="<%=hrefLocationTab%>"/>
            
          <%-- NOTES --%>
          <% String hrefNotes = "javascript:asyncDialogEasy('common/notes_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Event.getCode() + "');"; %>
          <v:popup-item caption="@Common.Notes" fa="comments" href="<%=hrefNotes%>"/>
          
          <%-- HISTORY --%>
          <% if (rights.History.getBoolean()) {%>
            <% String hrefHistory = "javascript:asyncDialogEasy('common/history_detail_dialog', 'id=" + pageBase.getId() + "');"; %>
            <v:popup-item caption="@Common.History" fa="history" href="<%=hrefHistory%>"/>
          <% } %>  
          
          <%-- SIAE --%>
          <% if (BLBO_DBInfo.isSiae() && rights.FiscalSystemView.getBoolean() && !pageBase.isNewItem()) { %>
            <% String hrefSIAE = "javascript:asyncDialogEasy('siae/siae_event_dialog', 'id=" + pageBase.getId() + "')"; %>
            <v:popup-item caption="SIAE" icon="siae.png" href="<%=hrefSIAE%>"/>
          <% } %>
          
          <v:popup-divider/>
          <%-- UPLOAD --%>
          <% String hrefUpload = "javascript:showUploadDialog(" + LkSNEntityType.Event.getCode() + ", '" + pageBase.getId() + "', " + (event.RepositoryCount.getInt() == 0) + ");"; %>
          <v:popup-item caption="@Common.UploadFile" title="@Common.UploadFileHint" fa="upload" href="<%=hrefUpload%>"/>
        </v:tab-plus>
      <% } %>
    <% } %>
  </v:tab-group>
</div>


<script>
 <% if (event.ProductCount.getInt() == 0) { %>
  $(document).on('OnEntityChange', function(event, bean) {
    if (bean.EntityType == <%=LkSNEntityType.ProductType.getCode()%>)
      window.location.reload();
  });
<% } %>
</script>

<jsp:include page="/resources/common/footer.jsp"/>
