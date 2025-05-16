<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
DOCatalog node = pageBase.getBL(BLBO_Catalog.class).loadNode(pageBase.getId());
String rootCatalogId = node.RootCatalogId.getString();
request.setAttribute("node", node);
request.setAttribute("dsCategoryTree", pageBase.getBL(BLBO_Category.class).getCategoryAshedTreeDS(LkSNEntityType.Catalog));
%>    

<v:dialog id="catalog_node_dialog" tabsView="true" title="@Common.Properties" width="900" height="700" autofocus="false">
<script type="text/javascript" src="<v:config key="site_url"/>/libraries/ckeditor/ckeditor.js"></script>
<style>
.cke {
  margin: 0px;
  padding: 0px;
  border-width: 0px;
  border-radius: 0px;
}
.btn-close-tab {
  display: inline-block;
  margin-left: 5px;
  width: 10px;
  height: 10px;
  text-align: right;
  color: rgba(0,0,0,0.2);
}
.btn-close-tab:hover {
  color: var(--base-red-color);
}
</style>

<script>
var ckeopt = {
  readOnly: false,
  height: "280px"
};
</script>

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-main" caption="@Common.Profile" icon="profile.png" default="true">
    <jsp:include page="catnode_dialog_tab_main.jsp"/>
  </v:tab-item-embedded>

  <v:tab-item-embedded tab="tabs-description" caption="@Common.Description" icon="<%=BLBO_RichDesc.ICONNAME_RICHDESC%>">
    <jsp:include page="catnode_dialog_tab_richdesc.jsp"/>
  </v:tab-item-embedded>

  <% if (node.CatalogType.isLookup(LkSNCatalogType.Catalog, LkSNCatalogType.Folder)) { %>
    <v:tab-item-embedded tab="tabs-sync" caption="@Common.Synchronization" fa="sync-alt">
      <jsp:include page="catnode_dialog_tab_sync.jsp"/>
    </v:tab-item-embedded>
  <% } %>
</v:tab-group>


<script>
//# sourceURL=catnode_dialog.jsp
$(document).ready(function() {
  $("#tabs").tabs();
  
  var dlg = $("#catalog_node_dialog");
  dlg.dialog({
    modal: true,
    close: function() {
      dlg.remove();
    },
    buttons: {
      <v:itl key="@Common.Save" encode="JS"/>: function() {
    	    var metaDataList = prepareMetaDataArray(dlg.find("#maskedit-container"));
          if (!(metaDataList)) 
        	    showMessage(itl("@Common.CheckRequiredFields"));
        	else {
            var node = getSelNode();
            var picture = dlg.find(".profile-pic-container");
            var reqDO = {
              Command: "SetNode",
              SetNode: {
                Node: {
                  CatalogId: node.attr("data-id"),
                  RootCatalogId: <%=JvString.jsString(rootCatalogId)%>,
                  ProfilePictureId: picture.attr("data-ProfilePictureId"),
                  CatalogName: dlg.find("[name='CatalogName']").val(),
                  CatalogCode: dlg.find("[name='CatalogCode']").val(),
                  CatalogNameExt: dlg.find("[name='CatalogNameExt']").val(),
                  CategoryId: dlg.find("[name='node\\.CategoryId']").val(),
                  ShowNameExt: dlg.find("[name='ShowNameExt']").isChecked(),
                  ShowInFullMenu: dlg.find("[name='ShowInFullMenu']").isChecked(),
                  ShowInQuickMenu: dlg.find("[name='ShowInQuickMenu']").isChecked(),
                  ShowInMainContent: dlg.find("[name='ShowInMainContent']").isChecked(),
                  AuthNeeded: dlg.find("[name='AuthNeeded']").isChecked(),
                  AutoSynchronize: dlg.find("#node\\.AutoSynchronize").isChecked(),
                  TemplateCode: dlg.find("[name='TemplateCode']").val(),
                  FlowType: dlg.find("[name='FlowType']").val(),
                  PricePointProductId: dlg.find("[name='PricePointProductId']").val(),
                  PricePointProductId: dlg.find("[name='PricePointProductId']").val(),
                  ButtonDisplayType: dlg.find("[name='ButtonDisplayType']").val(),
                  BackgroundColor: dlg.find("[name='BackgroundColor']").val(),
                  ForegroundColor: dlg.find("[name='ForegroundColor']").val(),
                  RichDescList: convertRichDescWidgetList(dlg.find(".rich-desc-widget").richdesc_getTransList()),
                  SyncRuleList: functionExists("getSyncRuleList") ? getSyncRuleList() : null,
                  MetaDataList: metaDataList
                }
              }
            };
            
            vgsService("Catalog", reqDO, false, function(ansDO) {
              dlg.dialog("close");
              node.treeNodeCaption(reqDO.SetNode.Node.CatalogName);
              node.attr("data-ProfilePictureId", reqDO.SetNode.Node.ProfilePictureId);
              node.attr("data-CatalogCode", reqDO.SetNode.Node.CatalogCode);
              node.attr("data-CatalogNameExt", reqDO.SetNode.Node.CatalogNameExt);
              node.attr("data-ShowNameExt", reqDO.SetNode.Node.ShowNameExt);
              node.attr("data-ShowInFullMenu", reqDO.SetNode.Node.ShowInFullMenu);
              node.attr("data-ShowInQuickMenu", reqDO.SetNode.Node.ShowInQuickMenu);
              node.attr("data-ShowInMainContent", reqDO.SetNode.Node.ShowInMainContent);
              node.attr("data-AuthNeeded", reqDO.SetNode.Node.AuthNeeded);
              node.attr("data-AutoSynchronize", reqDO.SetNode.Node.AutoSynchronize);
              node.attr("data-TemplateCode", reqDO.SetNode.Node.TemplateCode);
              node.attr("data-FlowType", reqDO.SetNode.Node.FlowType);
              node.attr("data-PricePointProductId", reqDO.SetNode.Node.PricePointProductId);
              node.attr("data-ButtonDisplayType", reqDO.SetNode.Node.ButtonDisplayType);
              node.attr("data-BackgroundColor", reqDO.SetNode.Node.BackgroundColor);
              node.attr("data-ForegroundColor", reqDO.SetNode.Node.ForegroundColor);
              refreshInfo();
              refreshDetails();
            });
        	};
      },
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    }
  }); 
});

</script>
</v:dialog>
