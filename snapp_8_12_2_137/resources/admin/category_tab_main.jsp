<%@page import="com.vgs.web.library.BLBO_Category"%>
<%@page import="com.vgs.web.library.BLBO_Tag"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.entity.dataobject.DOCategoryNode"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageCategory" scope="request"/>
<jsp:useBean id="cat" class="com.vgs.entity.dataobject.DOCategoryNode" scope="request"/>
<% LookupItem entityType = LkSN.EntityType.getItemByCode(cat.EntityType.getInt());%>
<% boolean canEdit = pageBase.getCategoryRights(entityType).canUpdate(); %>

<div class="tab-toolbar">
  <v:button id="btn-save" caption="@Common.Save" fa="save" onclick="doSave()" enabled="<%=canEdit%>"/>
</div>

<div class="tab-content">
  <v:last-error/>

  <div class="profile-pic-div">
    <snp:profile-pic entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.Category.getCode()%>" field="cat.ProfilePictureId" enabled="<%=canEdit%>"/>
  </div>
  <div class="profile-cont-div">
    <v:widget caption="@Common.General">
      <v:widget-block>
        <v:form-field caption="@Common.Path">
          <v:input-text field="cat.RecoursiveName" enabled="false" />
        </v:form-field>
        <v:form-field caption="@Common.Code">
          <v:input-text field="cat.CategoryCode" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.Name">
          <% if (cat.ParentCategoryId.isNull()) { %>
            <input type="text" class="form-control" disabled="disabled" value="<v:itl key="<%=cat.CategoryName.getString()%>"/>"/>
          <% } else { %>
            <v:input-text field="cat.CategoryName" enabled="<%=canEdit%>" />
          <% } %>
        </v:form-field>
        <% String hrefTag = "javascript:showTagPickupDialog_OLD(" + LkSNEntityType.Category.getCode() + ",'cat.TagIDs')"; %>
        <v:form-field caption="@Common.Tags" href="<%=hrefTag%>">
          <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.Category); %>
          <v:multibox field="cat.TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName"/>
        </v:form-field>
        <% if (!cat.ParentCategoryId.isNull()) { %>
          <v:form-field caption="@Common.Description" checkBoxField="cat.ShowNameExt">
            <snp:itl-edit field="cat.CategoryNameExt" entityType="<%=LkSNEntityType.Category%>" entityId="<%=pageBase.getId()%>" langField="<%=LkSNHistoryField.Catalog_CatalogNameExt%>" enabled="<%=canEdit%>"/>
          </v:form-field>
        <% } %>
      </v:widget-block>

      <% if (cat.EntityType.isLookup(LkSNEntityType.Organization, LkSNEntityType.Person)) { %>
        <v:widget-block>
          <v:form-field caption="@Account.AccountContexts">
            <% JvDataSet dsAccountContext = pageBase.getBL(BLBO_Category.class).getCategoryAccountContextDS();%>
            <v:multibox field="cat.AccountContexts" lookupDataSet="<%=dsAccountContext%>" idFieldName="AccountContext" captionFieldName="AccountContextName" allowNull="true" />
          </v:form-field>
        </v:widget-block>
      <% } %>
      
      
      <v:widget-block>
	    <v:form-field caption="@Common.Colors">
	      <v:color-picker field="cat.ForegroundColor" caption="@Common.Foreground" enabled="<%=canEdit%>"/>
	      <v:color-picker field="cat.BackgroundColor" caption="@Common.Background" enabled="<%=canEdit%>"/> 
	    </v:form-field>
	  </v:widget-block>
	      
    </v:widget>

    <v:grid id="masks">
      <thead>
        <v:grid-title caption="@Common.Forms"/>
        <tr class="header">
          <td><v:grid-checkbox header="true"/></td>
          <td>&nbsp;</td>
          <td width="100%">
            <v:itl key="@Common.Name" /><br/>
            <v:itl key="@Common.Code" />
          </td>
        </tr>
      </thead>
      <tbody id="mask-item-tbody">
      </tbody>
      <tbody class="toolbar">
        <tr>
          <td colspan="100%">
            <v:button caption="@Common.Add" fa="plus" href="javascript:addMask()" enabled="<%=canEdit%>"/>
            <span class="divider"></span>
            <v:button caption="@Common.Remove" fa="minus" href="javascript:doRemoveMasks()" enabled="<%=canEdit%>"/>
          </td>
        </tr>
      </tbody>
    </v:grid>

    <v:grid id="locations" style="margin-top:10px">
      <thead>
        <v:grid-title caption="@Account.Locations"/>
        <tr class="header">
          <td><v:grid-checkbox header="true"/></td>
          <td>&nbsp;</td>
          <td width="100%">
            <v:itl key="@Common.Name" /><br/>
            <v:itl key="@Common.Code" /></td>
          <td></td>
        </tr>
      </thead>
      <tbody id="location-item-tbody">
      </tbody>
      <tbody class="toolbar">
        <tr>
          <td colspan="100%">
            <v:button caption="@Common.Add" fa="plus" href="javascript:addLocation()" enabled="<%=canEdit%>"/>
            <v:button caption="@Common.Remove" fa="minus" href="javascript:doRemoveLocations()" enabled="<%=canEdit%>"/>
          </td>
        </tr>
      </tbody>
    </v:grid>
  </div>
</div>

<script>
  function refreshNameExt() {
    $("#cat\\.CategoryNameExt").attr("placeholder", $("#cat\\.CategoryName").val());
  }
  $(document).ready(refreshNameExt);
  $("#cat\\.CategoryName").keyup(refreshNameExt);
  
  function doRemoveMasks() {
    $("#mask-item-tbody [name='MaskId']:checked").parents("tr").remove();
  }
  
  function doRemoveLocations() {
    $("#location-item-tbody [name='LocationId']:checked").parents("tr").remove();
  }

  function addMask() {
    <%
    LookupItem targetEntityType = cat.EntityType.getLkValue();
    if (cat.EntityType.isLookup(LkSNEntityType.ProductFamily, LkSNEntityType.Event))
      targetEntityType = LkSNEntityType.ProductType;
    else if (cat.EntityType.isLookup(LkSNEntityType.AccessPoint))
      targetEntityType = LkSNEntityType.Workstation;
    %>
    
    showLookupDialog({
      EntityType: <%=LkSNEntityType.Mask.getCode()%>,
      MaskParams: {TargetEntityType: <%=targetEntityType.getCode()%>},
      onPickup: doAddMask
      
    });
  }

  function addLocation() {
    showLookupDialog({
      EntityType: <%=LkSNEntityType.Location.getCode()%>,
      onPickup: doAddLocation
    });
  }

  function doAddMask(item) {
    if (item) {
      if ($("#mask-item-tbody [name='MaskId'][value='" + item.ItemId + "']").length > 0) 
        showMessage(itl("@Common.DuplicatedItem"));
      else {
        var tr = $("<tr class='grid-row'/>").appendTo("#mask-item-tbody");
        var tdCB = $("<td><input type='checkbox' name='MaskId' class='cblist'/></td>").appendTo(tr);
        var tdIcon = $("<td><img class='list-icon'/></td>").appendTo(tr);
        var tdName = $("<td><a/><br/><span class='list-subtitle'/></td>").appendTo(tr);
        /* var tdMove = $("<td align='right'><img src='<v:image-link name="move_item.png" size="16"/>' class='sorthandle row-hover-visible'/></span></td>").appendTo(tr); */

        tdCB.find("input").val(item.ItemId);
        
        if (item.ProfilePictureId != null)
          tdIcon.find("img").attr("src", calcRepositoryURL(item.ProfilePictureId, "thumb"));
        else
          tdIcon.find("img").attr("src", calcIconName(item.IconName, 32));

        tdName.find("a").text(item.ItemName);
        tdName.find("a").attr("href", getPageURL(<%=LkSNEntityType.Mask.getCode()%>, item.ItemId));
        tdName.find(".list-subtitle").text(item.ItemCode);
      }
    }
  }
  
  function doAddLocation(item) {
    if (item) {
      if ($("#location-item-tbody [name='LocationId'][value='" + item.ItemId + "']").length > 0) 
        showMessage(itl("@Common.DuplicatedItem"));
      else {
        var tr = $("<tr class='grid-row'/>").appendTo("#location-item-tbody");
        var tdCB = $("<td><input type='checkbox' name='LocationId' class='cblist'/></td>").appendTo(tr);
        var tdIcon = $("<td><img class='list-icon'/></td>").appendTo(tr);
        var tdName = $("<td><a/><br/><span class='list-subtitle'/></td>").appendTo(tr);
        var tdMove = $("<td align='right'><span class='row-hover-visible'></span></td>").appendTo(tr);
        tdCB.find("input").val(item.ItemId);
        
        if (item.ProfilePictureId != null)
          tdIcon.find("img").attr("src", calcRepositoryURL(item.ProfilePictureId, "thumb"));
        else
          tdIcon.find("img").attr("src", calcIconName(item.IconName, 32));
        
        tdName.find("a").text(item.ItemName);
        tdName.find("a").attr("href", "<v:config key="site_url"/>/admin?page=account&id=" + item.ItemId);
        tdName.find(".list-subtitle").text(item.ItemCode);
      }
    }
  }

  function doSave() {
	  var categoryName = <% if (!cat.ParentCategoryId.isNull()) { %>$("#cat\\.CategoryName").val()<% } else { %><%=cat.CategoryName.getJsString()%><% } %>;
	  var entityType = <%=LkSNEntityType.Category.getCode()%>;
	  
	  var reqDO = {
      Command: "SaveCategory",
      SaveCategory: {
        Category: {
          CategoryId: <%=cat.CategoryId.getJsString()%>,
          ParentCategoryId: <%=cat.ParentCategoryId.getJsString()%>,
          CategoryCode: $("#cat\\.CategoryCode").val(),
          CategoryName: categoryName,
          EntityType: entityType,
          ProfilePictureId: $("#cat\\.ProfilePictureId").val(),
          ShowNameExt: $("[name='cat\\.ShowNameExt']").isChecked(),
          CategoryNameExt: $("#cat\\.CategoryNameExt").val(),
          TagIDs: $("#cat\\.TagIDs").val(),
          BackgroundColor: $("[name='cat\\.BackgroundColor']").val(), 
          ForegroundColor: $("[name='cat\\.ForegroundColor']").val(),
          PortfolioOwner: $("[name='cat\\.PortfolioOwner']").isChecked(), 
          OrderOwner: $("[name='cat\\.OrderOwner']").isChecked(),
          InstallmentContractOwner: $("[name='cat\\.InstallmentContractOwner']").isChecked(),
          OrderGuest: $("[name='cat\\.OrderGuest']").isChecked(),
          AccountContexts: $("#cat\\.AccountContexts").val(),
          MaskList: [],
          LocationList: []
        }
      }
    };
    
    var cbMasks = $("#mask-item-tbody [name='MaskId']");
    for (var i=0; i<cbMasks.length; i++) 
      reqDO.SaveCategory.Category.MaskList.push({MaskId:$(cbMasks[i]).val()});    
    
    var cbLocations = $("#location-item-tbody [name='LocationId']");
    for (var i=0; i<cbLocations.length; i++) { 
      reqDO.SaveCategory.Category.LocationList.push({LocationId:$(cbLocations[i]).val()});
    }

    showWaitGlass();
    vgsService("Category", reqDO, false, function(ansDO) {
      hideWaitGlass();
      entitySaveNotification(<%=LkSNEntityType.Category.getCode()%>, ansDO.Answer.SaveCategory.CategoryId);
    });
  }

  <% for (DOCategoryNode.DOCategoryMask mask : cat.MaskList) { %>
    doAddMask({
      IconName: <%=mask.IconName.getJsString()%>,
      ItemId: <%=mask.MaskId.getJsString()%>, 
      ItemCode: <%=mask.MaskCode.getJsString()%>, 
      ItemName: <%=mask.MaskName.getJsString()%>
    });
  <% } %>

  <% for (DOCategoryNode.DOCategoryLocation loc : cat.LocationList) { %>
    doAddLocation({
      IconName: <%=loc.IconName.getJsString()%>,
      ProfilePictureId: <%=loc.ProfilePictureId.getJsString()%>, 
      ItemId: <%=loc.LocationId.getJsString()%>, 
      ItemCode: <%=loc.LocationCode.getJsString()%>, 
      ItemName: <%=loc.LocationName.getJsString()%>
    });
  <% } %>

</script>