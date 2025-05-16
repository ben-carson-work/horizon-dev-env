<%@page import="java.util.List"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageWorkstationList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
boolean canCreate = rights.SystemSetupWorkstations.getOverallCRUD().canCreate() && 
                        rights.SystemSetupWorkstationDemographic.getBoolean() && 
                        rights.SystemSetupWorkstationActivationKey.getBoolean();
%>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<v:last-error/>

<script>
$(document).ready(function() {
  $("#btn-search").click(search);  
  $("#full-text-search").on("enterKeyPressed", search);  
  $(".menu-newwks").click(newWorkstation);

  function search() {
    setGridUrlParam("#workstation-grid", "WorkstationStatus", $("[name='WorkstationStatus']").getCheckedValues());
    setGridUrlParam("#workstation-grid", "WorkstationType", $("[name='WorkstationType']").getCheckedValues());
    setGridUrlParam("#workstation-grid", "FullText", $("#full-text-search").val(), true);
  }

  function newWorkstation() {
    var workstationType = $(this).closest(".menu-newwks").attr("data-workstationtype");
    var locationId = null;
    var opAreaId = null;
    var $sysnode = $("#system-tree li.selected");
    if ($sysnode.length > 0) {
      var id = $sysnode.attr("data-id");
      if ($sysnode.hasClass("loc"))
        locationId = id;
      else {
        opAreaId = id;
        locationId = $sysnode.parents("li").attr("data-id");
      }
    }

    var categoryId = $("#category-tree li.selected").attr("data-id");
    if (categoryId == "all")
      categoryId = null;

    createNewWorkstation(workstationType, locationId, opAreaId, categoryId);
  }
});

  function categorySelected(categoryId) {
    setGridUrlParam("#workstation-grid", "CategoryId", categoryId, true);
  }
   
  function systemTreeSelected(entityType, entityId) {
    setGridUrlParam("#workstation-grid", "LocationAccountId", (entityType == <%=LkSNEntityType.Location.getCode()%>) ? entityId : "");
    setGridUrlParam("#workstation-grid", "OpAreaAccountId", (entityType == <%=LkSNEntityType.OperatingArea.getCode()%>) ? entityId : "");
    changeGridPage("#workstation-grid", 1);
  }
</script>
  
<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <v:tab-toolbar>
      <v:button id="btn-search" caption="@Common.Search" fa="search"/>
      
      <span class="divider"></span>
      
      <v:button-group>
        <v:button-group>
          <v:button caption="@Common.New" fa="plus" dropdown="true" enabled="<%=canCreate%>"/>
          <v:popup-menu bootstrap="true" include="<%=canCreate%>">
            <% for (LookupItem item : LkSNWorkstationType.getCreateWorkstationTypes()) { %>
              <v:popup-item clazz="menu-newwks" caption="<%=item.getDescription(pageBase.getLang())%>" attributes="<%=TagAttributeBuilder.builder().put(\"data-workstationtype\", item.getCode())%>"/>
            <% } %> 
          </v:popup-menu>
        </v:button-group>
        <v:button caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" onclick="deleteWorkstations()" enabled="<%=rights.SystemSetupWorkstations.getOverallCRUD().canDelete()%>"/>
      </v:button-group>

      <% if (rights.SystemSetupWorkstations.getOverallCRUD().canDelete()) { %>
        <v:copy-paste-buttonset entityType="<%=LkSNEntityType.ProductType%>" />
      <% } %>

      <span class="divider"></span>
      <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.Workstation.getCode() + ")";%>
      <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/> 
      <v:pagebox gridId="workstation-grid"/>
    </v:tab-toolbar>
    
    <v:tab-content>
      <v:profile-recap> 
        <v:widget>
          <v:widget-block>
            <v:input-text field="full-text-search" clazz="default-focus" placeholder="@Common.FullSearch" defaultValue="<%=pageBase.getEmptyParameter(\"FullText\")%>"/>
          </v:widget-block>
        </v:widget>
        
        <v:widget caption="@Common.Status">
          <v:widget-block>
            <v:lk-checkbox lookup="<%=LkSN.WorkstationStatus%>" field="WorkstationStatus"/>
          </v:widget-block>
        </v:widget>
        
        <v:widget caption="@Common.DistributionChannel">
          <v:widget-block> 
            <v:lk-checkbox lookup="<%=LkSN.WorkstationType%>" field="WorkstationType"/>
          </v:widget-block>
        </v:widget>
    
        <v:widget caption="@Common.Topology">
          <v:widget-block>
            <div id="system-tree-widget"></div>
            <script>asyncLoad("#system-tree-widget", "admin?page=system_tree_widget&ForEntityType=<%=LkSNEntityType.Workstation.getCode()%>");</script>
          </v:widget-block>
        </v:widget>
        
        <v:widget caption="@Category.Categories" editHRef="<%=pageBase.getCategoryEditLink(LkSNEntityType.Workstation)%>">
          <v:widget-block>
            <snp:category-tree-widget entityType="<%=LkSNEntityType.Workstation%>"/>
          </v:widget-block>
        </v:widget>
      </v:profile-recap>
      
      <v:profile-main>
        <v:async-grid id="workstation-grid" jsp="workstation/workstation_grid.jsp" />
      </v:profile-main>
    </v:tab-content>
  </v:tab-item-embedded>
</v:tab-group>


<jsp:include page="/resources/common/footer.jsp"/>
