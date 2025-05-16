<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="node" class="com.vgs.snapp.dataobject.DOCatalog" scope="request"/>

<% String maskEditURL = pageBase.getContextURL() + "?page=maskedit_widget&LoadData=true&id="+pageBase.getId()+"&EntityType=" + LkSNEntityType.Catalog.getCode(); %>
<div class="tab-content">
  <div class="profile-pic-div">
    <div class="profile-pic-container">
      <div class="profile-pic-inner">
        <div class="profile-pic-hint"><v:itl key="@Repository.ProfilePicture"/></div>
        <div class="choose-pic"><v:itl key="@Repository.EditProfilePicture"/></div>
      </div>
    </div>
  </div>
  
  <div class="profile-cont-div">
    <v:widget>
      <v:widget-block>
        <div id="catalog-code-container">
          <v:form-field caption="@Common.Code">
            <v:input-text field="CatalogCode"/>
          </v:form-field>
        </div>
        <v:form-field caption="@Common.Name">
          <snp:itl-edit field="CatalogName" entityType="<%=LkSNEntityType.Catalog%>" entityId="<%=pageBase.getId()%>" langField="<%=LkSNHistoryField.Catalog_CatalogName%>" maxLength="50"/>
        </v:form-field>
        <v:form-field caption="@Common.Description" checkBoxField="ShowNameExt">
          <snp:itl-edit field="CatalogNameExt" entityType="<%=LkSNEntityType.Catalog%>" entityId="<%=pageBase.getId()%>" langField="<%=LkSNHistoryField.Catalog_CatalogNameExt%>" maxLength="50"/>
        </v:form-field>
        <v:form-field caption="@Category.Category" id="field-category">
          <v:combobox field="node.CategoryId" lookupDataSetName="dsCategoryTree" idFieldName="CategoryId" captionFieldName="AshedCategoryName" linkEntityType="<%=LkSNEntityType.Category%>"/>
        </v:form-field>
        <v:form-field caption="@Catalog.ButtonDisplayType">
          <v:lk-combobox field="ButtonDisplayType" lookup="<%=LkSN.ButtonDisplayType%>" allowNull="true"/>
        </v:form-field>
        <v:form-field caption="@Catalog.FlowType">
          <v:lk-combobox field="FlowType" lookup="<%=LkSN.FlowType%>" allowNull="false"/>
        </v:form-field>
        <v:form-field caption="@Catalog.PricePointProduct" hint="@Catalog.PricePointProductHint" id="field-pricepoint">
          <snp:dyncombo field="PricePointProductId" entityType="<%=LkSNEntityType.ProductType%>"/>
        </v:form-field>
      </v:widget-block>
      <v:widget-block id="folder-options">
        <v:form-field caption="@Common.Colors">
          <v:color-picker field="ForegroundColor" caption="@Common.Foreground"/>
          <v:color-picker field="BackgroundColor" caption="@Common.Background"/> 
        </v:form-field>
        <v:form-field caption="@Catalog.TemplateCode">
          <v:input-text field="TemplateCode"/>
        </v:form-field>
        <v:form-field>
          <div><v:db-checkbox field="ShowInFullMenu" caption="@Catalog.ShowInFullMenu" value="false"/></div>
          <div><v:db-checkbox field="ShowInQuickMenu" caption="@Catalog.ShowInQuickMenu" value="false"/></div>
          <div><v:db-checkbox field="ShowInMainContent" caption="@Catalog.ShowInMainContent" value="true"/></div>
          <div><v:db-checkbox field="AuthNeeded" caption="@Catalog.AuthNeeded" value="false"/></div>
        </v:form-field>
      </v:widget-block>
    </v:widget>

    <v:widget id="catalog-cache" clazz="hidden" caption="@Catalog.CacheStatus">
      <v:widget-block>
        <v:form-field caption="@Common.LastUpdate">
          <v:input-text field="CacheLastUpdate" enabled="false"/>
        </v:form-field>
        <v:form-field caption="@Common.Size">
          <v:input-text field="CacheZipFileSize" enabled="false"/>
        </v:form-field>
        <v:form-field caption="Invalidated">
          <v:input-text field="CacheInvalid" enabled="false"/>
        </v:form-field>
      </v:widget-block>
    </v:widget>
    <div id="maskedit-container"></div>
  </div>
</div>

<script>

$(document).ready(function(){
	asyncLoad("#maskedit-container", <%=JvString.jsString(maskEditURL)%>);
  var dlg = $("#catalog_node_dialog");

  dlg.find(".profile-pic-container").click(function() {
    showRepositoryPickup(<%=LkSNEntityType.Catalog.getCode()%>, <%=JvString.jsString(pageBase.getNullParameter("RootCatalogId"))%>);
  });

  initMainTab();
  refreshNameExt();  

  function refreshNameExt() {
    $("#CatalogNameExt").attr("placeholder", $("#CatalogName").val());
  }
  $("#CatalogName").keyup(refreshNameExt);

  function repositoryPickupCallback(id) {
    var picture = dlg.find(".profile-pic-container");
    
    if (id == "")
      id == null;
    
    var imgURL = (id) ? "url('<v:config key="site_url"/>/repository?type=small&id=" + id + "')" : "";
    
    picture.find(".profile-pic-hint").setClass("v-hidden", (id));
    picture.find(".profile-pic-inner").css("background-image", imgURL);
    
    picture.attr("data-ProfilePictureId", id);
  }

  function initMainTab() {
    var node = getSelNode();
    
    if (node != null) {
      var entityId = node.attr("data-Id");
      var entityType = parseInt(node.attr("data-EntityType"));
      
      repositoryPickupCallback(node.attr("data-ProfilePictureId"));
      var $picInner = dlg.find(".profile-pic-inner");
      $picInner.on("dragover", function(e) {
        e.stopPropagation();
        e.preventDefault();
        $(this).addClass("drag-over");
      });
      $picInner.on("dragenter", function(e) {
        e.stopPropagation();
        e.preventDefault();
      });
      $picInner.on("dragleave", function(e) {
        e.stopPropagation();
        e.preventDefault();
        $(this).removeClass("drag-over");
      });
      $picInner.on("drop", function(e) {
        e.stopPropagation();
        e.preventDefault();
        _handleFileUpload(e.originalEvent.dataTransfer.files[0], this);
      });

      dlg.find("[name='CatalogName']").val(node.attr("data-Caption"));
      dlg.find("[name='CatalogCode']").val(node.attr("data-CatalogCode"));
      dlg.find("[name='CatalogNameExt']").val(node.attr("data-CatalogNameExt"));
      dlg.find("[name='ShowNameExt']").setChecked(node.attr("data-ShowNameExt") == "true");
      dlg.find("[name='ShowInFullMenu']").setChecked(node.attr("data-ShowInFullMenu") == "true");
      dlg.find("[name='ShowInQuickMenu']").setChecked(node.attr("data-ShowInQuickMenu") == "true");
      dlg.find("[name='ShowInMainContent']").setChecked(node.attr("data-ShowInMainContent") == "true");
      dlg.find("[name='AuthNeeded']").setChecked(node.attr("data-AuthNeeded") == "true");
      dlg.find("[name='TemplateCode']").val(node.attr("data-TemplateCode"));
      dlg.find("[name='FlowType']").val(node.attr("data-FlowType"));
      dlg.find("[name='ButtonDisplayType']").val(node.attr("data-ButtonDisplayType"));
      dlg.find("[name='PricePointProductId']").val(node.attr("data-PricePointProductId"));
      dlg.find("#BackgroundColor").ColorPicker_SetColor(node.attr("data-BackgroundColor"));
      dlg.find("#ForegroundColor").ColorPicker_SetColor(node.attr("data-ForegroundColor"));
      
      var catalogType = node.attr("data-CatalogType") || <%=LkSNCatalogType.Catalog.getCode()%>;
      var isTypeCatalog = (catalogType == <%=LkSNCatalogType.Catalog.getCode()%>);
      var isTypeFolder = (catalogType == <%=LkSNCatalogType.Folder.getCode()%>);
      
      dlg.find("#folder-options").setClass("hidden", !isTypeFolder);
      dlg.find("[name='CatalogName']").prop('readonly', !isTypeCatalog && !isTypeFolder);
      dlg.find("#field-category").setClass("hidden", !isTypeCatalog);
      dlg.find("#field-pricepoint").setClass("hidden", !isTypeFolder);

      formFieldCheckBoxClick(dlg.find("[name='ShowNameExt']"));

      function _handleFileUpload(file, obj) {
        var cont = $(obj).parent();

        var good = (file) && (file.type) && (file.type.indexOf("image/") == 0);
        if (!good)
          showMessage("Invalid file type");
        else {
          showWaitGlass();
          
          var reader = new FileReader();
          reader.onload = function(e) {
            var reqDO = {
              Command: "Save",
              Save: {
                EntityType: <%=LkSNEntityType.Catalog.getCode()%>,
                EntityId: $("#catalog-tree li").first().attr("data-id"),
                FileName: file.name,
                DocData: reader.result.substring(reader.result.indexOf(",") + 1)
              }
            };
            
            vgsService("Repository", reqDO, false, function(ansDO) {
              hideWaitGlass();
              if (functionExists("repositoryPickupCallback"))
                repositoryPickupCallback(ansDO.Answer.Save.RepositoryId);
              
              $(obj).removeClass("drag-over");
            });
          };
          reader.readAsDataURL(file);
        }
      }
    }
  }
});


</script>