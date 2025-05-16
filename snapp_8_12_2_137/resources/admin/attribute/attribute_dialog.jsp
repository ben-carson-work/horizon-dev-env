<%@page import="com.vgs.snapp.rest.library.ISnpRestCustomExceptionMapper"%>
<%@page import="com.vgs.snapp.library.FtCRUD"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
FtCRUD rightCRUD = null;
if (pageBase.isNewItem()) 
  rightCRUD = rights.ProductTypes.getOverallCRUD();  
else 
  rightCRUD = pageBase.getEntityRightCRUD(LkSNEntityType.Attribute, pageBase.getId(), pageBase.getBL(BLBO_Attribute.class).getAttributeLocationIDs(pageBase.getId()));
request.setAttribute("rightCRUD", rightCRUD);
boolean canEdit = rightCRUD.canUpdate();
boolean canDelete = rightCRUD.canDelete();
 
String sReadOnly = canEdit ? "" : " readonly=\"readonly\""; 
String parentEntityId = pageBase.getNullParameter("ParentEntityId");
LookupItem parentEntityType = LkSN.EntityType.findItemByCode(pageBase.getParameter("ParentEntityType"));
BLBO_Attribute bl = pageBase.getBL(BLBO_Attribute.class);
DOAttribute attribute = pageBase.isNewItem() ? bl.prepareNewAttribute(parentEntityType, parentEntityId) : bl.loadAttribute(pageBase.getId()); 
String title = pageBase.isNewItem() ? pageBase.getLang().Product.Attribute.getText() : attribute.AttributeName.getString();
request.setAttribute("attribute", attribute);
%>

<v:dialog id="attribute_dialog" icon="<%=attribute.IconName.getString()%>" tabsView="true" title="<%=title%>" width="1000" height="800">
<jsp:include page="../configlang_inline_dialog.jsp"/>

<style>
#attribute_dialog .ui-tabs-panel {
  height: 630px;
}
#attribute-tab-items .tab-content {
  position: relative;
  height: 600px;
}
#attributeitem-list {
  position: absolute;
  top: 10px;
  left: 10px;
  bottom: 10px;
  width: 190px;
  margin: 0;
}
#attributeitem-details {
  position: absolute;
  top: 10px;
  left: 210px;
  bottom: 10px;
  right: 10px;
  overflow-y: auto;
}
#attribute_dialog .profile-pic-div {
  width: 170px;
}
#attribute_dialog .profile-pic-container {
  height: 170px;
}
#attribute_dialog .profile-pic-hint {
  margin-top: 40px;
}
#attributeitem-profile-widget {
  margin-left: 180px;
}
#attributeitem-SeatCategoryColor {
  width: 80px;
  cursor: pointer;
}
</style>

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="attribute-tab-profile" caption="@Common.Profile" default="true">
    <div class="tab-content">
      <v:widget caption="@Common.General">
        <v:widget-block>
          <v:form-field caption="@Common.Code" mandatory="true">
            <v:input-text field="attribute.AttributeCode" clazz="default-focus" enabled="<%=canEdit%>"/>
          </v:form-field>
          <v:form-field caption="@Common.Name" mandatory="true">
            <v:input-text field="attribute.AttributeName" enabled="<%=canEdit%>"/>
          </v:form-field>
          <v:form-field caption="@Common.PriorityOrder">
            <v:input-text field="attribute.AttributeWeight" enabled="<%=canEdit%>"/>
          </v:form-field>
          <v:form-field caption="@Common.Parent" mandatory="false">
            <snp:parent-pickup 
            placeholder="@Common.NotAssigned" 
            field="attribute.ParentEntityId" id="<%=pageBase.getId()%>" 
            entityType="<%=LkSNEntityType.Attribute.getCode()%>" 
            parentEntityType="<%=attribute.ParentEntityType.getInt()%>" 
            enabled="<%=canEdit%>"/>
          </v:form-field>
        </v:widget-block>
        <v:widget-block>
          <v:form-field>
            <v:db-checkbox field="attribute.SeatCategory" caption="@Seat.LimitedCapacity" title="@Seat.SeatCategoryFlagHint" value="true" enabled="<%=canEdit%>"/>
          </v:form-field>
        </v:widget-block>
      </v:widget>
    </div>
  </v:tab-item-embedded>
  
  <% if (!attribute.AttributeId.isNull()) { %>
  <v:tab-item-embedded tab="attribute-tab-items" caption="@Common.Items">
    <div class="tab-toolbar">
      <v:button id="attributeitem-add-btn" caption="@Common.Add" fa="plus" href="javascript:addAttributeItem()" enabled="<%=canEdit%>"/>
      <v:button id="attributeitem-del-btn" caption="@Common.Delete" fa="trash" href="javascript:doDelItems()" enabled="<%=canEdit%>"/>
      <span class="divider"></span>
      <v:button id="attributeitem-up-btn" caption="@Common.MoveUp" fa="arrow-up" href="javascript:doMoveUp()" enabled="<%=canEdit%>"/>
      <v:button id="attributeitem-down-btn" caption="@Common.MoveDown" fa="arrow-down" href="javascript:doMoveDown()" enabled="<%=canEdit%>"/>
    </div>
    <div class="tab-content">
      <select id="attributeitem-list" multiple></select>
      <div id="attributeitem-details">
        <div class="profile-pic-div">
          <div class="profile-pic-container">
            <input type="hidden" id="attributeitem-ProfilePictureId"/>
            <div id="profile-pic" class="profile-pic-inner">
              <div class="profile-pic-hint"><v:itl key="@Repository.ProfilePicture"/></div>
              <% if (canEdit) { %>
                <div class="choose-pic"><v:itl key="@Repository.EditProfilePicture"/></div>
              <% } %>
            </div>
          </div>
        </div>
        <v:widget id="attributeitem-profile-widget" caption="@Common.Profile">
          <v:widget-block>
            <v:form-field caption="@Common.Code" mandatory="true"><input type="text" id="attributeitem-Code" class="form-control" maxlength="10" <%=sReadOnly%>/></v:form-field>
            <v:form-field caption="@Common.Name" mandatory="true">
              <table style="width:100%;border-spacing:0"><tr>
                <td width="100%"><input type="text" id="attributeitem-Name" class="form-control" maxlength="30" <%=sReadOnly%>/></td>
                <% if (canEdit && !pageBase.isNewItem()) { %>
                <td>&nbsp;&nbsp;<a href="javascript:showConfigLangDialog_AttributeItem('ITL_AttributeItemName')"><v:itl key="@Common.Translation"/></a></td>
                <% } %>
              </tr></table>
            </v:form-field>
            <v:form-field caption="@Product.StatProduct"><div id="attributeitem-StatProductId"></div></v:form-field>
            <v:form-field caption="@Product.OptionalPrice"><input type="text" id="attributeitem-OptionalPrice" class="form-control" <%=sReadOnly%>/></v:form-field>
            <v:form-field caption="@Common.Color">
            	<v:color-picker clazz="color-line-picker" enabled="<%=canEdit%>" field="attributeitem-SeatCategoryColor" />
            </v:form-field>
            <v:form-field><v:db-checkbox field="attributeitem-Active" caption="@Common.Active" value="true" enabled="<%=canEdit%>"/></v:form-field>
          </v:widget-block>
          <v:widget-block>
            <v:form-field><v:db-checkbox field="attributeitem-ShowNameExt" caption="@Common.ShowDescription" value="true" enabled="<%=canEdit%>"/></v:form-field>
            <v:form-field id="name-ext-container" caption="@Common.Description">
              <table><tr>
                <td width="100%"><input type="text" id="attributeitem-NameExt" class="form-control" maxlength="50"/></td>
                <% if (!pageBase.isNewItem()) { %>
                <td>&nbsp;</td>
                <td><a href="javascript:showConfigLangDialog_AttributeItem('ITL_AttributeItemNameExt')"><v:itl key="@Common.Translation"/></a></td>
                <% } %>
              </tr></table>
            </v:form-field>
          </v:widget-block>
        </v:widget>
        <% request.setAttribute("entitlement-widget-caption", "@Common.Entitlements"); %>
        <% request.setAttribute("entitlement", new DOEntitlement()); %>
        <% request.setAttribute("EntityType", LkSNEntityType.AttributeItem.getCode()); %>
        <jsp:include page="/resources/admin/entitlement/entitlement_widget.jsp"/>
      </div>
    </div>
  </v:tab-item-embedded>
  
<%-- 
  <v:tab-item-embedded tab="attribute-tab-repository" caption="@Common.Documents">
    items
  </v:tab-item-embedded>
--%>
  
  <% if (rights.History.getBoolean()) { %>
    <v:tab-item-embedded tab="tabs-history" caption="@Common.History">
      <jsp:include page="../common/page_tab_historydetail.jsp"/>
    </v:tab-item-embedded>
  <% } %>  
  
<% } %>
</v:tab-group>


<script>
//# sourceURL=attribute_dialog.jsp

 function addAttributeItem(aiDO) {
  var newItem = (aiDO == null);
  if (aiDO == null) {
    aiDO = {
      Active: true
    };
  }
  aiDO.EntitlementData = aiDO.EntitlementData || {};
  
  var opt = $("<option/>").appendTo("#attributeitem-list");
  opt.data("aiDO", aiDO);
  
  $("#attributeitem-list option").removeAttr("selected"); 
  
  var select = $("#attributeitem-list")[0];
  for(var x=0; x < select.options.length; x++) 
    (select.options[x]).selected = false;
  
  opt.attr("selected", "selected");
  updateOptionText(opt);
  
  if (newItem) 
    dataToForm();
}

var attribute_item_refreshing = false;

function dataToForm() {
  if (!attribute_item_refreshing) {
    attribute_item_refreshing = true;
    try {
      var opt = getSelectedOption();
      $("#attributeitem-details").setClass("v-hidden", opt == null);
      $("#attributeitem-del-btn").setClass("v-hidden", getSelectedOptions().length == 0);
      $("#attributeitem-up-btn").setClass("v-hidden", opt == null);
      $("#attributeitem-down-btn").setClass("v-hidden", opt == null);
      if (opt != null) {
        var aiDO = opt.data("aiDO");
        $("#attributeitem-Code").val((aiDO.AttributeItemCode == null) ? "<new item>" : aiDO.AttributeItemCode);
        $("#attributeitem-Name").val((aiDO.AttributeItemName == null) ? "<new item>" : aiDO.AttributeItemName);
        $("#attributeitem-OptionalPrice").val(aiDO.OptionalPrice);
        $("#attributeitem-Active").setChecked(aiDO.Active);
        $("#attributeitem-ShowNameExt").setChecked(aiDO.ShowNameExt);
        if (aiDO.AttributeItemNameExt)
          $("#attributeitem-NameExt").val(aiDO.AttributeItemNameExt);
        
     	// Sets SeatCategoryColor color on load.
        const colorPickers = $("#attributeitem-SeatCategoryColor .v-color-preview");
        if(colorPickers.length > 0)
			colorPickers[0].style.backgroundColor = aiDO.SeatCategoryColor;
        
        $("#attributeitem-StatProductId").vcombo_setSelItemId(aiDO.StatProductId);
        var profilePicCont = $("#attribute_dialog .profile-pic-container");
        profilePicCont.attr("data-RepoEntityType", <%=LkSNEntityType.Attribute.getCode()%>);
        profilePicCont.attr("data-RepoEntityId", "<%=attribute.AttributeId.getHtmlString()%>");
        profilePicCont.attr("data-EntityType", <%=LkSNEntityType.AttributeItem.getCode()%>);
        profilePicCont.attr("data-EntityId", aiDO.AttributeItemId);
        setAttributeItemProfilePictureId(aiDO.ProfilePictureId);

        refreshEntitlements(aiDO);
        refreshNameExt();
	   }
    } 
    finally {
      attribute_item_refreshing = false;
    }
  }
}

function formToData() {
  if (!attribute_item_refreshing) {
    attribute_item_refreshing = true;
    try {
      var opt = getSelectedOption();
      if (opt != null) {
        var price = parseFloat($("#attributeitem-OptionalPrice").val().replace(",", "."));
        
        var aiDO = opt.data("aiDO");
        aiDO.AttributeItemCode = $("#attributeitem-Code").val();
        aiDO.AttributeItemName = $("#attributeitem-Name").val();
        aiDO.OptionalPrice = isNaN(price) ? null : price;
        aiDO.Active = $("#attributeitem-Active").isChecked();
        aiDO.ShowNameExt = $("#attributeitem-ShowNameExt").isChecked();
        if ($("#attributeitem-NameExt").val() == '')
        	aiDO.AttributeItemNameExt = null;
        else	
          aiDO.AttributeItemNameExt = $("#attributeitem-NameExt").val();
        
        aiDO.ProfilePictureId = $("#attributeitem-ProfilePictureId").val();
        aiDO.Entitlement = $("#attribute_dialog .entitlement-widget").data("entitlement");
        
        statProduct = $("#attributeitem-StatProductId").vcombo_getSelItem();
        aiDO.StatProductId = (statProduct == null) ? null : statProduct.ItemId;
        aiDO.StatProductCode = (statProduct == null) ? null : statProduct.ItemCode;
        aiDO.StatProductName = (statProduct == null) ? null : statProduct.ItemName;
        
        opt.data("aiDO", aiDO);
        updateOptionText(opt);
      }
    }
    finally {
      attribute_item_refreshing = false;
    }
  }
}

function refreshEntitlements(aiDO) {
  snpAPI.cmd("Entitlement", "GetLookupData", {
    "Entitlement": aiDO.Entitlement
  }).then(ansDO => {
    $("#attribute_dialog .entitlement-widget").trigger("update-entitlement", {
      "Entitlement": aiDO.Entitlement,
      "EventCache": ((ansDO) && (ansDO.EventList)) ? ansDO.EventList : [],
      "ProductCache": ((ansDO) && (ansDO.ProductList)) ? ansDO.ProductList : []
    });
  });
}

function refreshNameExt() {
  $("#name-ext-container").setClass("v-hidden", !$("#attributeitem-ShowNameExt").isChecked());
  $("#attributeitem-NameExt").attr("placeholder", $("#attributeitem-Name").val());
}

<% if (canEdit) { %>
$("#profile-pic").parent(".profile-pic-container").click(function() {  
  showRepositoryPickup(<%=LkSNEntityType.Attribute.getCode()%>, '<%=attribute.AttributeId.getHtmlString()%>');
});
<% } %>

function setAttributeItemProfilePictureId(id) {
  id = (id) ? id : "";
  var imageCSS = (id == "") ? "none" : "url('" + BASE_URL + "/repository?id=" + id + "&type=small')";
  $("#attributeitem-ProfilePictureId").val(id);  
  $("#profile-pic").css("background-image", imageCSS);  
  $(".profile-pic-hint").setClass("v-hidden", id != "");
}

function repositoryPickupCallback(id) {  
  setAttributeItemProfilePictureId(id);
  formToData();
}

$("#attributeitem-list").change(dataToForm);
$("#attributeitem-details input").keyup(formToData);
$("#attributeitem-details input").change(formToData);
$(document).on("entitlement-change", formToData);

$("#attributeitem-ShowNameExt").change(refreshNameExt);
$("#attributeitem-Name").keyup(refreshNameExt);
$("#attribute\\.SeatCategory").change(dataToForm);

// Updates SeatCategoryColor property whenever the user changes color.
$("#attributeitem-SeatCategoryColor").change(function(event, params) {
	var aiDO = getSelectedOption().data("aiDO");
	aiDO.SeatCategoryColor = params['selectedColor'];
});

function updateOptionText(opt) {
  var aiDO = opt.data("aiDO");
  opt.text(aiDO.AttributeItemName);
}

function getSelectedOptions() {
  var result = [];
  var select = $("#attributeitem-list")[0];
  if ((select) && (select.options))
    for(var i=0; i < select.options.length; i++)
      if (select.options[i].selected)
        result.push($(select.options[i]));
  return result;
}

function getSelectedOption() {
  var opts = getSelectedOptions();
  return (opts.length == 1) ? opts[0] : null;
}

function doDelItems() {
  var opts = getSelectedOptions();
  for (var i=0; i<opts.length; i++) 
    opts[i].remove();
  
  dataToForm();
}

function doMoveUp() {
  var opt = getSelectedOption();
  if (opt != null) 
    opt.insertBefore(opt.prev());
}

function doMoveDown() {
  var opt = getSelectedOption();
  if (opt != null)  
    opt.insertAfter(opt.next());
}

function doSaveAttribute() {
  var reqDO = {
    Command: "SaveAttribute",
    SaveAttribute: {
      Attribute: {
        AttributeId: <%=attribute.AttributeId.isNull() ? null : "\"" + attribute.AttributeId.getHtmlString() + "\""%>,
        ParentEntityType: $("#attribute\\.ParentEntityType").val(),
        ParentEntityId: $("#attribute\\.ParentEntityId").val(), 
        AttributeCode: $("#attribute\\.AttributeCode").val(),
        AttributeName: $("#attribute\\.AttributeName").val(),
        AttributeWeight: $("#attribute\\.AttributeWeight").val(),
        SeatCategory: $("#attribute\\.SeatCategory").isChecked(),
        AttributeItemList: []
      }
    }
  };

  var newItemFound = false;
  var select = $("#attributeitem-list")[0];
  
  if ((select) && (select.options)) {
    for (var i=0; i < select.options.length; i++) {
      if (!newItemFound){
        newItemFound = ($(select.options[i]).data("aiDO").AttributeItemCode == "<new item>" || $(select.options[i]).data("aiDO").AttributeItemName == "<new item>");
        var idxItemFound = i;
      }
      reqDO.SaveAttribute.Attribute.AttributeItemList.push($(select.options[i]).data("aiDO"));
    }
  }
    
  if (newItemFound) {
    for(var x=0; x < select.options.length; x++) 
      (select.options[x]).selected = false;
    (select.options[idxItemFound]).selected = true;
    
    showMessage(itl("@Common.InvalidItemValue"), function () {
      dataToForm();
      if ($("#attributeitem-Code").val() == "<new item>") 
        $("#attributeitem-Code").focus();
      else
        if ($("#attributeitem-Name").val() == "<new item>") 
          $("#attributeitem-Name").focus();
    });
  }  
  else {
    showWaitGlass();
    vgsService("Product", reqDO, false, function(ansDO) {
      hideWaitGlass();
      var attributeId = ansDO.Answer.SaveAttribute.AttributeId;
      triggerEntityChange(<%=LkSNEntityType.Attribute.getCode()%>, attributeId);
      $("#attribute_dialog").dialog("close");
      
      var notDeleted = ansDO.Answer.SaveAttribute.NotDeletedItemIDs;
      if ((notDeleted) && (notDeleted.length > 0))
        showMessage(itl("@Common.SomeItemsWereNotDeleted"));
      
      <% if (attribute.AttributeId.isNull()) { %>
        asyncDialogEasy("attribute/attribute_dialog", "id=" + attributeId);
      <% } %>
    });
  }  
}

function showConfigLangDialog_AttributeItem(fieldName) {
  var opt = getSelectedOption();
  if (opt != null) {
    var aiDO = opt.data("aiDO");
    showConfigLangDialog(aiDO[fieldName], function(list) {
      aiDO[fieldName] = list;
      opt.data("aiDO", aiDO);
    });
  }
}

$(document).ready(function() {
  $("#attribute_dialog .tabs").tabs();
  initProfilePic("#profile-pic");
  
  var dlg = $("#attribute_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      <% if (canEdit) { %>
        dialogButton("@Common.Save", doSaveAttribute),
      <% } %>
      dialogButton("@Common.Cancel", doCloseDialog)                     
    ];
  });
  
  $("#attributeitem-StatProductId").vcombo({
    EntityType: <%=LkSNEntityType.ProductType.getCode()%>,
    onPickup: function(item) {
      formToData();
    }
  });

  
  <% for (DOAttribute.DOAttributeItem aiDO : attribute.AttributeItemList.getItems()) { %>
    addAttributeItem(<%=aiDO.getJSONString()%>);
  <% } %>

  <% if (!attribute.AttributeId.isNull()) { %>
    asyncLoad("#attribute-tab-repository", "<v:config key="site_url"/>/admin?page=repositorylist_widget&id=<%=attribute.AttributeId.getHtmlString()%>&EntityType=<%=LkSNEntityType.Attribute.getCode()%>&readonly=<%=!canEdit%>");
  <% } %>
  
  dataToForm();
});

</script>

</v:dialog>