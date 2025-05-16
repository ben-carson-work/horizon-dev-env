<%@page import="java.util.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_EntityRight.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<% 
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");

LookupItem docEntityType = (LookupItem)request.getAttribute("EntityRight_DocEntityType");
String docEntityId = (String)request.getAttribute("EntityRight_DocEntityId");

@SuppressWarnings("unchecked")
FtList<DOEntityRight> rightList = (FtList<DOEntityRight>)request.getAttribute("EntityRight_RightList"); 
if (rightList == null) {
  rightList = new FtList<>(null, DOEntityRight.class);
  pageBase.getBL(BLBO_Right.class).fillEntityRights(rightList, docEntityId);
}

LookupItem[] entityTypes = (LookupItem[])request.getAttribute("EntityRight_EntityTypes");
if (entityTypes == null)
  entityTypes = new LookupItem[0];
LookupItem historyField = (LookupItem)request.getAttribute("EntityRight_HistoryField");
boolean canEdit = (request.getAttribute("EntityRight_CanEdit") == Boolean.TRUE);
boolean showRightLevelCreate = (request.getAttribute("EntityRight_ShowRightLevelCreate") == Boolean.TRUE);
boolean showRightLevelEdit = (request.getAttribute("EntityRight_ShowRightLevelEdit") == Boolean.TRUE);
boolean showRightLevelDelete = (request.getAttribute("EntityRight_ShowRightLevelDelete") == Boolean.TRUE);
boolean showRightLevel = showRightLevelEdit || showRightLevelDelete;
boolean showSave = (docEntityType != null);
%>

<div class="tab-toolbar">
  <% if (showSave) { %>
    <v:button caption="@Common.Save" fa="save" onclick="doSave()" enabled="<%=canEdit%>"/>
    <span class="divider"></span>
  <% } %>
  
  <div class="btn-group">
    <div class="btn-group">
      <v:button caption="@Common.Add" fa="plus" id="add-entityright-btn" dropdown="true" enabled="<%=canEdit%>"/>
  		<v:popup-menu bootstrap="true">
      <% 
      boolean first = true;
      for (LookupItem entityType : LookupManager.getArray(LkSNEntityType.Workstation, LkSNEntityType.Person, LkSNEntityType.ProductType, LkSNEntityType.Organization)) { 
        if (entityType.isLookup(entityTypes)) {
          if (first)
            first = false;
          else {
            %><v:popup-divider/><%
          }

          for (EntityRightPopupItem item : EntityRightPopupItem.getList(entityType)) { 
            %><v:popup-item icon="<%=item.iconName%>" caption="<%=item.caption%>" onclick="<%=item.onclick%>"/><%
          }
        }
      } 
      %>
      </v:popup-menu>
    </div>
    
    <v:button caption="@Common.Remove" fa="minus" href="javascript:doRemoveEntityRights()" enabled="<%=canEdit%>"/>
  </div>
</div>


<div class="tab-content">
  <v:grid id="entityright-grid">
    <thead>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td></td>
        <td width="<%=!showRightLevel ? 100: 30 %>%"><v:itl key="@Common.Name"/></td>
        <%if (showRightLevel){ %>
        <td width="70%"><v:itl key="@Common.Rights"/></td>
        <% }%>
      </tr>
    </thead>
    <% if (LkSNEntityType.Workstation.isLookup(entityTypes)) { %>
      <tbody id="entityright-wks-tbody">
        <tr class="group"><td colspan="100%"><v:itl key="@Common.DistributionChannels"/> / <v:itl key="@Account.Locations"/> / <v:itl key="@Account.OpAreas"/> / <v:itl key="@Common.Workstations"/></td></tr>
      </tbody>
    <% } %>
    <% if (LkSNEntityType.Person.isLookup(entityTypes)) { %>
      <tbody id="entityright-usr-tbody">
        <tr class="group"><td colspan="100%"><v:itl key="@Common.SecurityRoles"/> / <v:itl key="@Account.Users"/></td></tr>
      </tbody>
    <% } %>
    <% if (LkSNEntityType.ProductType.isLookup(entityTypes)) { %>
      <tbody id="entityright-prd-tbody">
        <tr class="group"><td colspan="100%"><v:itl key="@Product.ProductTypes"/></td></tr>
      </tbody>
    <% } %>
    <% if (LkSNEntityType.Organization.isLookup(entityTypes)) { %>
      <tbody id="entityright-org-tbody">
        <tr class="group"><td colspan="100%"><v:itl key="@Common.Customers"/></td></tr>
      </tbody>
    <% } %>
  </v:grid>
</div>

<script>

function findItemRow(entityId) {
  var $tr = $("#entityright-grid [data-EntityId='" + entityId + "']");
  return ($tr.length > 0) ? $tr : null;
}

function doAddEntityRight(iconName, entityId, entityType, entityCode, entityName, rightLevel) {
  if (findItemRow(entityId) == null) {
    var usrEntityTypes = [
      <%=LkSNEntityType.Role.getCode()%>,
      <%=LkSNEntityType.Person.getCode()%>
    ];
    var orgEntityTypes = [
      <%=LkSNEntityType.Account_All.getCode()%>,
      <%=LkSNEntityType.ResOwnerNone.getCode()%>,
      <%=LkSNEntityType.ResOwnerPerson.getCode()%>,
      <%=LkSNEntityType.Organization.getCode()%>,
      <%=LkSNEntityType.Category_Organization.getCode()%>,
      <%=LkSNEntityType.SaleChannel.getCode()%>
    ];
    var prdEntityTypes = [
      <%=LkSNEntityType.ProductType.getCode()%>,
      <%=LkSNEntityType.PromoRule.getCode()%>,
      <%=LkSNEntityType.Tag_ProductType.getCode()%>
    ];
    
    var container = $("#entityright-wks-tbody");
    if (usrEntityTypes.indexOf(entityType) >= 0)
      container = $("#entityright-usr-tbody");
    else if (orgEntityTypes.indexOf(entityType) >= 0)
      container = $("#entityright-org-tbody");
    else if (prdEntityTypes.indexOf(entityType) >= 0)
      container = $("#entityright-prd-tbody");
    
    var tr = $("<tr/>").appendTo(container);
    tr.attr("data-EntityId", entityId);
    tr.attr("data-EntityType", entityType);
    $("<td><input name='UsrEntityId' value='" + entityId + "' type='checkbox' class='cblist'></td>").appendTo(tr);
    $("<td><img src='" + getIconURL(iconName, 32) + "'/></td>").appendTo(tr);
    var tdName = $("<td><span class='list-title'/><br/><span class='list-subtitle'/></td>").appendTo(tr);
    
    var entityDesc = itl(entityName);
    if (getNull(entityCode) != null)
      entityDesc = "[" + itl(entityCode) + "] " + entityDesc;
    
    tdName.find(".list-title").text(entityDesc);
    tdName.find(".list-subtitle").text(calcEntityRightDesc(entityType));
    
    <% if (showRightLevel) { %>
      var tdLevel = $("<td/>").appendTo(tr);
      var combo = $("<select name='RightLevel' class='form-control'/>").appendTo(tdLevel);
      $("<option value='<%=LkSNRightLevel.Read.getCode()%>'/>").appendTo(combo).html("<%=LkSNRightLevel.Read.getHtmlDescription(pageBase.getLang())%>");
      <% if (showRightLevelCreate) { %>
        $("<option value='<%=LkSNRightLevel.Create.getCode()%>'/>").appendTo(combo).html("<%=LkSNRightLevel.Create.getHtmlDescription(pageBase.getLang())%>");
      <% } %>
      <% if (showRightLevelEdit || showRightLevelDelete) { %>
      	$("<option value='<%=LkSNRightLevel.Edit.getCode()%>'/>").appendTo(combo).html("<%=LkSNRightLevel.Edit.getHtmlDescription(pageBase.getLang())%>");
      <% } %>
      <% if (showRightLevelDelete) { %>
      	$("<option value='<%=LkSNRightLevel.Delete.getCode()%>'/>").appendTo(combo).html("<%=LkSNRightLevel.Delete.getHtmlDescription(pageBase.getLang())%>");
      <% } %>
      combo.val(rightLevel);
      
      <% if (!canEdit) { %>
        combo.attr("disabled", "disabled");
      <% } %>
    <% } %>
  }
}

<% for (DOEntityRight right : rightList) { %>
doAddEntityRight(
    <%=right.IconName.getJsString()%>, 
    <%=right.UsrEntityId.getJsString()%>, 
    <%=right.UsrEntityType.getInt()%>, 
    <%=right.UsrEntityCode.getJsString()%>,
    <%=right.UsrEntityName.getJsString()%>,
    <%=right.RightLevel.getJsString()%>);
<% } %>

function showSearchDialog(entityType) {
  var params = {
    EntityType: entityType,
    ShowCheckbox: true,
    isItemChecked: function(item) {
      return (findItemRow(item.ItemId) != null);
    },
    onPickup: function(item, add) {
      if (add)
        doAddEntityRight(item.IconName, item.ItemId, entityType, item.ItemCode, item.ItemName, <%=LkSNRightLevel.Read.getCode()%>);
      else {
        var $tr = findItemRow(item.ItemId);
        if ($tr != null)
          $tr.remove();
      }
    }
  };
  
  <% if (LkSNEntityType.PromoRule.isLookup(entityTypes)) { %>
    if (entityType == <%=LkSNEntityType.ProductType.getCode()%>) {
      params.EntityTypes = [<%=LkSNEntityType.ProductType.getCode()%>, <%=LkSNEntityType.PromoRule.getCode()%>];
    }  
  <% } %>

  if (entityType == <%=LkSNEntityType.Person.getCode()%>) {
    params.AccountParams = {
      HasLogin: true
    }  
  }

  if (entityType == <%=LkSNEntityType.SaleChannel.getCode()%>) {
    params.SaleChannelParams = {
      SaleChannelType: <%=LkSNSaleChannelType.External.getCode()%>
    }  
  }
  
  showLookupDialog(params);
}

<% if (showSave) { %>
  function doSave() {
  	var entityId = <%=JvString.jsString(docEntityId)%>;
  	var entityType = <%=docEntityType.getCode()%>;
  	var historyField = <%=historyField.getCode()%>;
  	
    var reqDO = {
      Command: "SaveEntityRights",
      SaveEntityRights: {
        EntityType: entityType,
        EntityId: entityId,
        HistoryField: historyField,
        RightList: []
      }
    };
    
    var rows = $("#entityright-grid tbody tr").not(".group");
    for (var i=0; i<rows.length;  i++) {
      reqDO.SaveEntityRights.RightList.push({
        UsrEntityType: $(rows[i]).attr("data-EntityType"),  
        UsrEntityId: $(rows[i]).attr("data-EntityId"),
        RightLevel: $(rows[i]).find("[name='RightLevel']").val()
      });
    }
    
    showWaitGlass();
    vgsService("Right", reqDO, false, function(ansDO) {
      hideWaitGlass();
      entitySaveNotification(entityType, entityId, "tab=rights");
    });
  }
<% } %>

function doRemoveEntityRights() {
  $("#entityright-grid [name='UsrEntityId']:checked").parents("tr").remove();
}

</script>