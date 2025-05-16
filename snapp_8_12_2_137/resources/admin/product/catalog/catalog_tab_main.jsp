<%@page import="com.vgs.snapp.dataobject.DODB.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageCatalog" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% 
boolean canEdit = rights.Catalogs.canUpdate(); 
tbCatalog catalog = (tbCatalog)request.getAttribute("catalog"); 
%>

<v:tab-container profileFixedView="true">
  <v:tab-toolbar id="catalog-toolbar">
    <v:button caption="@Catalog.ZipUpdate" title="@Catalog.ZipUpdateHint" fa="file-zipper" onclick="zipUpdate()" enabled="<%=canEdit%>"/>
    <snp:notes-btn entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.Catalog%>"/>
  
    <span class="divider"></span>
  
    <v:button-group>
      <v:button id="btn-info" caption="@Common.Properties" fa="info-circle" onclick="showPropertiesDialog()" enabled="<%=canEdit%>"/>
      <v:button id="btn-sync" caption="Sync Folder" fa="sync-alt" onclick="syncFolder()" enabled="<%=canEdit%>"/>
    </v:button-group>
  
    <v:button-group>
      <v:button-group>
        <v:button caption="@Common.Add" fa="plus" id="add-btn" dropdown="true" enabled="<%=canEdit%>"/>
        <v:popup-menu id="add-popup" bootstrap="true">
          <v:popup-item caption="@Lookup.CatalogType.Folder" fa="folder-plus" id="menu-add-folder" onclick="createNewFolder()" keyShortcut="CTRL+ALT+F"/>
          <% String onclickProdType = "showSearchDialog(" + LkSNEntityType.ProductType.getCode() + ")"; %>
          <v:popup-item caption="@Product.ProductType" fa="tag" id="menu-add-product" onclick="<%=onclickProdType%>" keyShortcut="CTRL+ALT+P"/>
          <% String onclickProdFamily = "showSearchDialog(" + LkSNEntityType.ProductFamily.getCode() + ")"; %>
          <v:popup-item caption="@Product.ProductFamily" fa="tags" id="menu-add-productFamily" onclick="<%=onclickProdFamily%>" keyShortcut="CTRL+ALT+A"/>
          <% String onclickEvent = "showSearchDialog(" + LkSNEntityType.Event.getCode() + ")"; %>
          <v:popup-item caption="@Event.Event" fa="masks-theater" id="menu-add-event" onclick="<%=onclickEvent%>" keyShortcut="CTRL+ALT+E"/>
          <% String onclickPromo = "showSearchDialog(" + LkSNEntityType.PromoRule.getCode() + ")"; %>
          <v:popup-item caption="@Product.PromoRule" fa="cut" id="menu-add-promo" onclick="<%=onclickPromo%>" keyShortcut="CTRL+ALT+R"/>
        </v:popup-menu>
      </v:button-group>
      
      <v:button id="btn-del" caption="@Common.Remove" fa="minus" onclick="removeDetails()" enabled="<%=canEdit%>"/>
      <v:button id="btn-edit" caption="@Common.Edit" fa="pencil" onclick="editDetails()" enabled="<%=canEdit%>"/>
    </v:button-group>
  </v:tab-toolbar>
  
  <v:tab-content>
  
  <v:profile-recap>
    <v:widget id="catalog-cache-status" caption="@Catalog.CacheUpdate">
      <v:widget-block>
        <div id="catalog-cache-progress" class="hidden">
          <div class="progress-container">
            <div class="cache-spinner">
              <i class="fa fa-cog fa-spin fa-2x"></i>
            </div>
            <div class="progress">
              <div class="progress-bar progress-bar-success"></div>
            </div>
          </div>
          <div class="recap-value-item progress-start">
            <v:itl key="@Common.Start"/>
            <span class="recap-value"></span>
          </div>
          <div class="recap-value-item progress-items">
            <v:itl key="@Common.Items"/>
            <span class="recap-value"></span>
          </div>
          <div class="recap-value-item progress-elapsed">
            <v:itl key="@Common.ElapsedTime"/>
            <span class="recap-value"></span>
          </div>
        </div>
        <div id="catalog-cache-info" class="hidden">
          <div class="recap-value-item info-lastupdate">
            <v:itl key="@Common.LastUpdate"/>
            <span class="recap-value tz-datetime"><i class="fas fa-user-circle"></i> <span class="tz-value"></span></span>
          </div>
          <div class="recap-value-item info-size">
            <v:itl key="@Common.Size"/>
            <span class="recap-value"></span>
          </div>
        </div>
      </v:widget-block>
    </v:widget>
    
    <v:widget caption="Structure">
      <v:widget-block><div id="catalog-tree"></div></v:widget-block>
    </v:widget>
  </v:profile-recap>
  
  <v:profile-main id="catalog-body-container" clazz="hidden">
    <v:widget id="folder-recap" caption="@Common.Recap">
      <v:widget-block>
        <div class="thumb"></div>
        <div class="info">
          <div class="CatalogName"></div>
          <div class="CatalogNameExt"></div>
        </div>
      </v:widget-block>
    </v:widget>
    
    <% String params="CatalogId=" + pageBase.getId(); %>
    <v:async-grid id="catalog-grid" jsp="product/catalog/catnode_grid.jsp" params="<%=params%>"/>
  </v:profile-main>
  
  <div id="templates" class="hidden">
    <div id="edit-dlg" title="<v:itl key="@Common.Edit"/>">
      <v:form-field caption="@Catalog.ButtonDisplayType">
        <v:lk-combobox field="ButtonDisplayType" lookup="<%=LkSN.ButtonDisplayType%>" allowNull="false"/>
      </v:form-field>
    </div>
  </div>
  
  </v:tab-content>
</v:tab-container>

<style>
  #prop-dlg .form-caption {
    display: block;
  }
  
  #prop-dlg input[type='text'] {
    width: 95%;
  }
  
  #folder-recap {
    cursor: pointer;
  }
  
  #folder-recap .thumb {
    float: left;
    width: 50px;
    height: 50px;
    background-size: contain;
  }
  
  #folder-recap .widget-block {
    min-height: 70px;
  }
  
  #folder-recap .info {
    margin-left: 60px;
  }
  
  #folder-recap .CatalogName {
    font-weight: bold;
  }
  
  #folder-recap .CatalogNameExt {
    color: #464646;
  }
  
  #catalog-cache-progress .progress-container {
    display: flex;
    justify-content: space-between;
  }
  
  #catalog-cache-progress .progress {
    flex-grow: 1;
    margin-left: 10px;
    margin-top: 4px;
  } 
  
</style>

<script>
  $("#catalog-tree").tree({
    data: <%=pageBase.getTree().getJSONString()%>,
    nodeSelected: function(node) {
      refreshVisibility();
      refreshInfo();
      refreshDetails();
    }
  });
  
  $($("#catalog-tree li")[0]).treeNodeSelect();
  
  $(document).on("click", ".cblist", refreshVisibility);
  $("#catalog-toolbar").on("remove", function() {
    $(document).off("click", ".cblist", refreshVisibility);
  });
  
  function getSelNode() {
    return $("#catalog-tree li.selected");
  }

  <%-- CREATE NEW FOLDER --%>
  function createNewFolder() {
    var node = getSelNode();
    if (node != null) {
      var reqDO = {
        Command: "AddNode",
        AddNode: {
          ParentCatalogId: node.attr("data-id"),
          RootCatalogId: <%=JvString.jsString(pageBase.getId())%>,
          CatalogName: itl("@Common.New"),
          CatalogType: <%=LkSNCatalogType.Folder.getCode()%>,
          FlowType: <%=LkSNFlowType.Default.getCode()%>,
        }
      };
      vgsService("Catalog", reqDO, false, function(ansDO) {
        var child = node.treeAddChild({
          id: ansDO.Answer.AddNode.CatalogId,
          caption: reqDO.AddNode.CatalogName,
          icon: "<v:image-link name="<%=JvImageCache.ICON_FOLDER%>" size="16" />"
        });
        child.attr("data-CatalogType", <%=LkSNCatalogType.Folder.getCode()%>);
        child.attr("data-ShowInMainContent", "true");
        child.attr("data-FlowType", <%=LkSNFlowType.Default.getCode()%>);
        child.treeNodeSelect();
        showPropertiesDialog();
      });
    }
  }
  
  <%-- REFRESH DETAILS --%>
  function refreshDetails() {
    setGridUrlParam("#catalog-grid", "CatalogId", getSelNode().attr("data-id"), true);
  }
  
  <%-- REFRESH INFO --%>
  function refreshInfo() {
    var node = getSelNode();
    if (node != null) {
      var profilePictureId = node.attr("data-ProfilePictureId");
      var thumbURL = (profilePictureId) ? "<v:config key="site_url"/>/repository?id=" + profilePictureId + "&type=thumb" : getIconURL(node.attr("data-iconname") || "<%=JvImageCache.ICON_FOLDER%>", 50);
      var $folder = $("#folder-recap"); 
      $folder.find(".thumb").css("background-image", "url('" + thumbURL + "')");
      $folder.find(".CatalogName").html(node.treeNodeCaption());
      $folder.find(".CatalogNameExt").html(node.attr("data-CatalogNameExt"));
    }
  }
  
  function zipUpdate() {
    confirmDialog(null, function() {
      snpAPI.cmd("Catalog", "ZipUpdate", {Catalog:{CatalogId:<%=JvString.jsString(pageBase.getId())%>}});
    });
  }
  
  $("#folder-recap").click(function() {
    if ($("#btn-info").isEnabled())
      showPropertiesDialog();
  });

  <%-- REFRESH VISIBILITY --%>
  function refreshVisibility() {
    var $li = getSelNode();
    var catalogType = parseInt($li.attr("data-CatalogType"));
    var selCatalogIDs = $("#catalog-grid .cblist").not(".header").getCheckedValues();
    var selCatalog = (catalogType == <%=LkSNCatalogType.Catalog.getCode()%>);
    var selFolder = (catalogType == <%=LkSNCatalogType.Folder.getCode()%>);
    
    $("#btn-info").attr("disabled", !selCatalog && !selFolder);
    $("#btn-sync").attr("disabled", !selCatalog && !selFolder);
    $("#btn-del").attr("disabled", (selCatalog && (selCatalogIDs.length == 0)) || <%=!canEdit%>);
    $("#btn-edit").attr("disabled", (selCatalogIDs.length == 0) || <%=!canEdit%>);
   
    $("#catalog-body-container").setClass("hidden", $li.length == 0);
  }
  
  <%-- SELECT FOLDER --%>
  function selectFolder(folderId) {
    $("#catalog-tree [data-id='" + folderId + "']").treeNodeSelect();
  }
  
  function doAddNode(entityType, entityId, entityName) {
    var $selNode = getSelNode();
    if (entityType == parseInt($selNode.attr("data-entitytype")))
      $selNode = $selNode.closest("ul").closest("li");
    
    var reqDO = {
      Command: "AddNode",
      AddNode: {
        ParentCatalogId: $selNode.attr("data-id"),
        RootCatalogId: <%=JvString.jsString(pageBase.getId())%>,
        CatalogType: <%=LkSNCatalogType.Entity.getCode()%>,
        EntityType: entityType,
        EntityId: entityId
      }
    };
    
    vgsService("Catalog", reqDO, false, function(ansDO) {
      var iconName = (entityType == <%=LkSNEntityType.Event.getCode()%>) ? "<v:image-link name='<%=LkSNEntityType.Event.getIconName()%>' size='16' />" : "<v:image-link name='<%=LkSNEntityType.ProductFamily.getIconName()%>' size='16' />";
      if ((entityType != <%=LkSNEntityType.ProductType.getCode()%>) && (entityType != <%=LkSNEntityType.PromoRule.getCode()%>)) {
        var child = $selNode.treeAddChild({
          id: ansDO.Answer.AddNode.CatalogId,
          caption: entityName,
          icon: iconName
        });
        child.attr("data-CatalogType", <%=LkSNCatalogType.Entity.getCode()%>);
        child.attr("data-EntityType", entityType);
        child.treeNodeSelect();
      }
      refreshDetails();
    });
  }
  
  function doDelNodes(catalogIDs) {
    var reqDO = {
      Command: "DelNode",
      DelNode: {
        CatalogIDs: catalogIDs
      }
    };
    
    vgsService("Catalog", reqDO, false, function(ansDO) {
      var arr = catalogIDs.split(",");
      for (var i=0; i<arr.length; i++) 
        $("#catalog-tree li[data-id='" + arr[i] + "']").treeNodeDelete();
      refreshDetails();
    });
  }

  <%-- SEARCH --%>
  function showSearchDialog(entityType) {
    showLookupDialog({
      EntityType: entityType,
      ShowCheckbox: true,
      isItemChecked: function(item) {
        return _getTR(item.ItemId).length > 0;
      },
      onPickup: function(item, add) {
        var $tr = _getTR(item.ItemId);
        if (add !== ($tr.length > 0)) {
          if (add === true)
            doAddNode(entityType, item.ItemId, item.ItemName);
          else 
            doDelNodes($tr.attr("data-id"));
        }
      }
    });
    
    function _getTR(entityId) {
      return $(".grid-row[data-entityid='" + entityId + "']");
    }
  }
  
  <%-- REMOVE DETAILS --%>
  function removeDetails() {
    var catalogIDs = $("#catalog-grid .cblist").not(".header").getCheckedValues();
    var confirmMsg = null;
    
    if (catalogIDs.length == 0) {
      $li = getSelNode();
      if ($li.attr("data-CatalogType") != "<%=LkSNCatalogType.Catalog.getCode()%>") {
        catalogIDs = $li.attr("data-id");
        confirmMsg = itl("@Catalog.FolderRemoveWarn", $li.attr("data-Caption"));
      }
    } 
    
    if (catalogIDs.length > 0) { 
      confirmDialog(confirmMsg, function() {
        doDelNodes(catalogIDs);
      });
    }
  }
  
  <%-- EDIT DETAILS --%>
  function editDetails() {
    var catalogIDs = $("#catalog-grid .cblist").not(".header").getCheckedValues();
    if (catalogIDs.length == 0)
      showMessage(itl("@Common.NoElementWasSelected"));
    else {
      var $dlg = $("#edit-dlg");
      $dlg.dialog({
        modal: true,
        buttons: [
          {
            text: itl("@Common.Ok"),
            click: _doEditDetails
          },
          {
            text: itl("@Common.Cancel"),
            click: doCloseDialog
          }
        ] 
      });
    }
    
    function _doEditDetails() {
      var reqDO = {
        Command: "NodeMultiEdit",
        NodeMultiEdit: {
          CatalogIDs: catalogIDs,
          ButtonDisplayType: $dlg.find("#ButtonDisplayType").val()
        }
      };

      $dlg.dialog("close");

      showWaitGlass();
      vgsService("Catalog", reqDO, false, function(ansDO) {
        hideWaitGlass();
        refreshDetails();
      });
    }
  }
  
  <%-- PROPERTIES --%>
  var dlgProp = $("#catalog_node_dialog");
  
  dlgProp.find(".profile-pic-container").click(function() {
    showRepositoryPickup(<%=LkSNEntityType.Catalog.getCode()%>, "<%=catalog.CatalogId.getString()%>");
  });
  
  function repositoryPickupCallback(id) {
    var dlgProp = $("#catalog_node_dialog");
    var picture = dlgProp.find(".profile-pic-container");
    
    if (id == "")
      id == null;
    
    var imgURL = (id) ? "url('<v:config key="site_url"/>/repository?type=small&id=" + id + "')" : "";
    
    picture.find(".profile-pic-hint").setClass("v-hidden", (id));
    picture.find(".profile-pic-inner").css("background-image", imgURL);
    
    picture.attr("data-ProfilePictureId", id);
  }
  
  function showPropertiesDialog() {
    <% if (canEdit) { %>
      var params = "id=" + getSelNode().attr("data-id") + "&RootCatalogId=<%=pageBase.getId()%>";
      asyncDialogEasy('product/catalog/catnode_dialog', params);
    <% } %>
  }
  
  function syncFolder() {
    var reqDO = {
      Command: "SyncFolder",
      SyncFolder: {
        CatalogId: getSelNode().attr("data-id")
      }
    };
    
    vgsService("Catalog", reqDO, false, function(ansDO) {
      refreshDetails();
      var delCount = 0;
      var insCount = 0;
      if ((ansDO.Answer) && (ansDO.Answer.SyncFolder)) {
        delCount = ansDO.Answer.SyncFolder.DelCount;
        insCount = ansDO.Answer.SyncFolder.InsCount;
      }
      if (delCount + insCount == 0)
        showMessage(itl("@Catalog.SyncResultMsgEmpty"));
      else 
        showMessage(itl("@Catalog.SyncResultMsg", delCount, incCount));
    });
  }
  
  $(document).ready(function() {
    refreshCacheStatus();

    function refreshCacheStatus() {
      var $widget = $("#catalog-cache-status");
      
      if ($widget.length > 0) {
        var reqDO = {
          Command: "GetCatalogCacheStatus",
          GetCatalogCacheStatus: {
            CatalogIDs: <%=JvString.jsString(pageBase.getId())%>
          }
        };
        
        vgsService("Catalog", reqDO, true, function(ans) {
          var errorMsg = getVgsServiceError(ans);
          if (errorMsg != null)
            console.err(errorMsg);
          else {
            var ansDO = (ans.Answer || {}).GetCatalogCacheStatus || {};
            var list = ansDO.CatalogCacheStatusList || {};
            var status = (list.length > 0) ? list[0] : {};

            var inProgress = (status.AsyncProcessId != null);
            if (inProgress) {
              var perc = (status.AsyncProcessPos / status.AsyncProcessTot) * 100;
              $widget.find(".progress-bar").css("width", perc + "%");
              $widget.find(".progress-start .recap-value").text(formatDate(xmlToUserDate(status.AsyncProcessStartDateTime)) + " " + formatTime(xmlToUserDate(status.AsyncProcessStartDateTime), <%=rights.LongTimeFormat.getInt()%>));
              $widget.find(".progress-items .recap-value").text(status.AsyncProcessPos + " / " + status.AsyncProcessTot);
              
              var msElapsed = (new Date()).getTime() - xmlToDate(status.AsyncProcessStartDateTime).getTime();
              $widget.find(".progress-elapsed .recap-value").text(getSmoothTime(msElapsed));
            }
            else {
              var userDateTime = xmlToUserDate(status.LastUpdate);
              $widget.find(".info-lastupdate .tz-value").text(formatDate(userDateTime) + " " + formatTime(userDateTime, <%=rights.LongTimeFormat.getInt()%>));
              $widget.find(".info-size .recap-value").text(getSmoothSize(status.ZipFileSize));
            }

            $widget.find("#catalog-cache-progress").setClass("hidden", !inProgress);
            $widget.find("#catalog-cache-info").setClass("hidden", inProgress);
          }
        });
        
        setTimeout(refreshCacheStatus, 1000);
      }
    }
  });
</script>