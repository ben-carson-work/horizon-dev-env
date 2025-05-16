<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccessPointList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<v:last-error/>

<input type="hidden" id="CategoryId" name="CategoryId" value="<%=pageBase.getEmptyParameter("CategoryId")%>"/>

<script>
  function search() {
    setGridUrlParam("#apt-grid", "FullText", $("#full-text-search").val());
    setGridUrlParam("#apt-grid", "TagId", ($("#TagIDs").val() || ""), true);
  }

  function categorySelected(categoryId) {
    setGridUrlParam("#apt-grid", "CategoryId", categoryId, true);
  }
  
  function systemTreeSelected(entityType, entityId) {
    setGridUrlParam("#apt-grid", "LocationAccountId", (entityType == <%=LkSNEntityType.Location.getCode()%>) ? entityId : "");
    setGridUrlParam("#apt-grid", "OpAreaAccountId", (entityType == <%=LkSNEntityType.OperatingArea.getCode()%>) ? entityId : "");
    changeGridPage("#apt-grid", 1);
  }
</script>


<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <v:button caption="@Common.Search" fa="search" href="javascript:search()"/>
      <span class="divider"></span>
      <v:button caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" bindGrid="apt-grid" onclick="deleteWorkstations()" enabled="<%=rights.SystemSetupAccessPoints.getOverallCRUD().canDelete()%>"/>
      <v:button caption="@Common.Edit" fa="pencil" title="@AccessPoint.AptMultiEdit" bindGrid="apt-grid" onclick="showAptMultiEditDialog()" enabled="<%=rights.SystemSetupAccessPoints.getOverallCRUD().canUpdate()%>"/>
      <% if (rights.SystemSetupAccessPoints.getOverallCRUD().canDelete()) { %>
        <v:copy-paste-buttonset entityType="<%=LkSNEntityType.ProductType%>" />
      <% } %>
      
      <span class="divider"></span>
      <% String hrefACM = pageBase.getContextURL() + "?page=acm"; %>
      <v:button caption="@AccessPoint.AccessControlMonitor" fa="monitor-heart-rate" href="<%=hrefACM%>" target="_new"/>
      
      <span class="divider"></span>
      <% String onClickHistory="showHistoryLog(" + LkSNEntityType.Workstation.getCode() + ")";%>
      <v:button caption="@Common.History" fa="history" onclick="<%=onClickHistory%>" enabled="<%=rights.History.getBoolean()%>"/>
      <v:pagebox gridId="apt-grid" />
    </div>
    
    <div class="tab-content">
      <div class="profile-pic-div">
        <div class="form-toolbar">
          <input type="text" id="full-text-search" class="form-control default-focus" placeholder="<v:itl key="@Common.FullSearch"/>" style="width:97%" value="<%=pageBase.getEmptyParameter("FullText")%>"/>
          <script>
            $("#full-text-search").keypress(function(e) {
              if (e.keyCode == KEY_ENTER) {
                search();
                return false;
              }
            });
          </script>
          <div class="filter-divider"></div>
 
          <div><v:itl key="@Common.Tags"/></div>
          <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.AccessPoint); %>
          <v:multibox field="TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName"/>
        </div>
        
        <v:widget caption="@Common.System" icon="account_tree.png">
          <v:widget-block>
            <div id="system-tree-widget"></div>
            <script>asyncLoad("#system-tree-widget", "admin?page=system_tree_widget&ForEntityType=<%=LkSNEntityType.AccessPoint.getCode()%>");</script>
          </v:widget-block>
        </v:widget>
        
        <v:widget caption="@Category.Categories" editHRef="<%=pageBase.getCategoryEditLink(LkSNEntityType.AccessPoint)%>">
          <v:widget-block>
            <snp:category-tree-widget entityType="<%=LkSNEntityType.AccessPoint%>"/>
          </v:widget-block>
        </v:widget>
      </div>
      
      <div class="profile-cont-div">
        <v:async-grid id="apt-grid" jsp="workstation/accesspoint_grid.jsp" />
      </div>
    </div>
  </v:tab-item-embedded>
</v:tab-group>


<jsp:include page="/resources/common/footer.jsp"/>
