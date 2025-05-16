<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTagList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <v:tab-toolbar>
      <v:button-group>
        <v:button id="btn-tag-new" caption="@Common.New" fa="plus" onclick="showNewTagDialog()"/>
        <v:button id="btn-tag-delete" caption="@Common.Delete" title="@Common.DeleteSelectedItems" fa="trash" bindGrid="tag-grid"/>
      </v:button-group>

      <v:button-group> 
        <v:button id="btn-tag-import" caption="@Common.Import" fa="sign-in"/>
        <v:button id="btn-tag-export" caption="@Common.Export" fa="sign-out" clazz="no-ajax"/>    
      </v:button-group>
      
      <v:button id="btn-tag-history" caption="@Common.History" fa="history" enabled="<%=rights.History.getBoolean()%>"/>
      
      <v:pagebox gridId="tag-grid"/>
    </v:tab-toolbar>

    <v:tab-content>
      <v:profile-recap>
        <div class="grid-widget-container" id="entity-type-grid">
          <v:grid id="entity-type-grid-table">
            <thead>
              <td><v:grid-checkbox header="true"/></td>
              <td width="100%"><v:itl key="@Common.Type"/></td>
            </thead>
            
            <tbody>
              <% String lastGroupDesc = null; %>
              <% for (LookupItem entityType : pageBase.getAllEntityTypes()) { %>
                <% if (!JvString.isSameText(lastGroupDesc, pageBase.getEntityGroupDesc(entityType))) { %>
                  <% lastGroupDesc = JvString.htmlEncode(pageBase.getEntityGroupDesc(entityType)); %>
                  <tr class="group"><td colspan="100%"><%=lastGroupDesc%></td></tr>
                <% } %>
                <tr class="grid-row" data-EntityType="<%=entityType.getCode()%>">
                  <td><v:grid-checkbox name="EntityType"/></td>
                  <td><%=entityType.getHtmlDescription(pageBase.getLang())%></td>
                </tr>
              <% } %>
            </tbody>
          </v:grid>
        </div>
      </v:profile-recap>
      
      <v:profile-main>
        <% String params = "EntityType=" + pageBase.getAllEntityTypes().get(0).getCode(); %>
        <v:async-grid id="tag-grid" jsp="common/tag_grid.jsp" params="<%=params%>" />
      </v:profile-main>
      
    </v:tab-content>
  </v:tab-item-embedded>
</v:tab-group>

<script>

$(document).ready(function() {
  $("#btn-tag-new").click(_showNewTagDialog);
  $("#btn-tag-delete").click(_deleteTags);
  $("#btn-tag-import").click(_showImportDialog);
  $("#btn-tag-export").click(_exportTags);
  $("#btn-tag-history").click(_showHistoryLog);
  $("#entity-type-grid .grid-row .cblist").click(_entityTypeCheckBoxClick);
  $("#entity-type-grid .grid-row").click(_entityTypeRowClick);
  $("#entity-type-grid-table .grid-row:first .cblist").setChecked(true);

  function _showNewTagDialog() {
    var $cb = $("#entity-type-grid-table tbody .grid-row .cblist:checked");
    var entityType = strToIntDef($cb.closest("tr").attr("data-EntityType"), 0);
    asyncDialogEasy("common/tag_edit_dialog", "EntityType=" + entityType);
  }

  function _deleteTags() {
    confirmDialog(null, function() {
      snpAPI.cmd("Tag", "Delete", {TagIDs: $("[name='TagId']").getCheckedValues()}).then(() => triggerEntityChange(<%=LkSNEntityType.Tag.getCode()%>));
    });
  }

  function _showImportDialog(type) {
    asyncDialogEasy("common/tag_snapp_import_dialog", "");
  }

  function _exportTags() {
    var result = {ids: ""};
    var $grid = $("#entity-type-grid-table");
    var trs = $($grid.find("[name='EntityType']").filter(":checked")).closest("tr")
    $(trs).each(function() {
      result.ids = result.ids + $(this).attr("data-EntityType") + ",";  
    });

    if (result) 
      window.location = BASE_URL + "/admin?page=export&EntityIDs=" + result.ids + "&EntityType=<%=LkSNEntityType.Tag.getCode()%>";
  }

  function _showHistoryLog() {
    var $cb = $("#entity-type-grid-table tbody .grid-row .cblist:checked");
    var entityType = strToIntDef($cb.closest("tr").attr("data-EntityType"), 0);
    showHistoryLog(entityType);
  }

  function _entityTypeRowClick() {
    $("#entity-type-grid-table .cblist:checked").setChecked(false);
    $(this).find(".cblist").setChecked(true);
    _refreshGrid();
  }
  
  function _entityTypeCheckBoxClick() {
    event.stopPropagation();
    _refreshGrid();
  }

  function _refreshGrid() {
    var $cb = $("#entity-type-grid-table tbody .grid-row .cblist:checked");
    var single = ($cb.length == 1);
    $("#tag-grid").setClass("hidden", !single);
    $("#btn-tag-new").setClass("disabled", !single);
    $("#btn-tag-export").setClass("disabled", ($cb.length == 0));
    
    if (single) {
      var entityType = ($cb.length != 1) ? 0 : strToIntDef($cb.closest("tr").attr("data-EntityType"), 0);
      setGridUrlParam("#tag-grid", "EntityType", entityType, true);

      var disabled = entityType == 0 ? "disabled" : "";
      $("#btn-new").prop("disabled", disabled);
      $("#btn-delete").prop("disabled", disabled);
    }
  }
});

</script>

 
<jsp:include page="/resources/common/footer.jsp"/>
