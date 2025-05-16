<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMask" scope="request"/>
<jsp:useBean id="mask" class="com.vgs.snapp.dataobject.DOMask" scope="request"/>
 
<v:page-form id="mask-form" trackChanges="true">

<div class="tab-toolbar">
  <v:button id="btn-save-mask" caption="@Common.Save" fa="save" bindSave="true"/>
  <snp:notes-btn entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.Mask%>"/>
  <span class="divider"></span>
  <% String hrefExport = ConfigTag.getValue("site_url") + "/admin?page=export&EntityIDs=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Mask.getCode(); %> 
  <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" href="<%=hrefExport%>"/>
</div>
 
<div class="tab-content">
  <v:last-error/>

  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="@Common.Type" mandatory="true">
        <select id="mask.EntityType" class="form-control">
          <%
          for (LookupItem entityType : BLBO_Mask.getMaskEntityTypes()) {
            String entity_desc = BLBO_Mask.getMaskEntityTypeDescription(entityType, pageBase.getLang());
            String selected = entityType.equals(mask.EntityType.getLkValue()) ? "selected" : "";
            %><option value="<%=entityType.getCode()%>" <%=selected%>><%=entity_desc%></option><%
          } 
          %>
        </select>
      </v:form-field>
      <v:form-field caption="@Common.Code" mandatory="true">
        <v:input-text field="mask.MaskCode"/>
      </v:form-field>
      <v:form-field caption="@Common.Name" mandatory="true">
        <v:input-text field="mask.MaskName"/>
      </v:form-field>
      <v:form-field caption="@Common.PriorityOrder">
        <v:input-text type="number" field="mask.PriorityOrder" />
      </v:form-field>
    </v:widget-block>
  </v:widget>

  <v:grid>
    <thead>
      <v:grid-title caption="@Common.Fields"/>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="25%">
          <div><v:itl key="@Common.Field"/> (<v:itl key="@Common.Caption"/>)</div>
          <div><v:itl key="@Common.Code"/></div>
        </td>
        <td width="75%">
          <div><v:itl key="@Common.Options"/></div>
        </td>
        <td width="32px"></td>
      </tr>
    </thead>
    <tbody id="mask-item-tbody"></tbody>
    <tbody>
      <tr>
        <td colspan="100%">
          <v:button id="btn-add-item" caption="@Common.New" fa="plus"/>
          <v:button id="btn-del-item" caption="@Common.Delete" fa="trash"/>
        </td>
      </tr>
    </tbody>
  </v:grid>
</div>

<div id="mask-templates" class="hidden">
  <table>
    <tr class="grid-row mask-item-row">
      <td>
        <v:grid-checkbox/>
      </td>
      <td>
        <div><a class="list-title field-MetaFieldName"></a><span class="list-subtitle field-Caption"></span></div>
        <div class="list-subtitle field-MetaFieldCode"></div>
      </td>
      <td>
        <div class="list-subtitle field-Options"></div>
      </td>
      <td>
        <span class="row-hover-visible"><i class="fa fa-bars drag-handle"></i>
      </td>
    </tr>
  </table>
</div>

</v:page-form>


<script>

$(document).ready(function() {
  var $maskForm = $("#mask-form");
  var items = <%=mask.MaskItemList.getJSONString()%>;
  if (items == null)
    items = [];
  
  for (var i=0; i<items.length; i++)
    _addItem(items[i]);
  
  $("#btn-add-item").click(_onClick_itemAdd);
  $("#btn-del-item").click(_onClick_itemDel);
  $("#btn-save-mask").click(_saveMask);
  
  $("#mask-item-tbody").sortable({
    handle: ".drag-handle",
    helper: fixHelper,
    stop: function(event, ui) {
      onFieldChanged(null, $maskForm);
    }
  });
  
  function _addItem(maskItem) {
    var $tr = $("#mask-templates .mask-item-row").clone().appendTo("#mask-item-tbody");
    $tr.on("data-changed", _onItemDataChanged);
    _updateRowData($tr, maskItem);
  }
  
  function _updateRowData($tr, maskItem) {
    var options = [];
    if (maskItem.Required === true)
      options.push(itl("@Common.Required"));
    if ((maskItem.ConditionList || []).length > 0)
      options.push(itl("@Common.MaskItemConditional"));
    
    $tr.find(".field-MetaFieldName").text(maskItem.MetaFieldName);
    $tr.find(".field-MetaFieldCode").text(maskItem.MetaFieldCode);
    $tr.find(".field-Caption").text((maskItem.Caption) ? " (" + maskItem.Caption + ")" : "");
    $tr.find(".field-Options").text(options.join(", "));
    $tr.find("a.list-title").attr("href", "javascript:asyncDialogEasy('metadata/maskitem_dialog', 'id=" + maskItem.MetaFieldId + "')")
    $tr.attr("data-metafieldid", maskItem.MetaFieldId);
    $tr.data("maskItem", maskItem);
  }
  
  function _onClick_itemDel() {
    $("#mask-item-tbody .cblist:checked").closest("tr").remove();
    onFieldChanged(null, $maskForm);
  }
  
  function _onClick_itemAdd() {
    showLookupDialog({
      "EntityType": <%=LkSNEntityType.MetaField.getCode()%>,
      "ShowCheckbox": true,
      "isItemChecked": function(item) {
        return (_findItemRow(item.ItemId) != null);
      },
      "onPickup": function(item, add) {
        if (add) {
          _addItem({
            "MetaFieldId": item.ItemId,
            "MetaFieldCode": item.ItemCode,
            "MetaFieldName": item.ItemName
          });
          onFieldChanged(null, $maskForm);
        }
        else {
          var $tr = _findItemRow(item.ItemId);
          if ($tr != null)
            $tr.remove();
        }
      }
    });
  }
  
  function _onItemDataChanged(event, maskItem) {
    _updateRowData($(this), maskItem);
    onFieldChanged(null, $maskForm);
  }
  
  function _findItemRow(metaFieldId) {
    var $tr = $("#mask-item-tbody tr[data-metafieldid='" + metaFieldId + "']");
    return ($tr.length > 0) ? $tr : null;
  }
	
  function _saveMask() {
    var reqDO = {
      Command: "SaveMask",
      SaveMask: {
        Mask: {
          MaskId: <%=mask.MaskId.getJsString()%>,
          EntityType: $("#mask\\.EntityType").val(), 
          MaskCode: $("#mask\\.MaskCode").val(), 
          MaskName: $("#mask\\.MaskName").val(), 
          PriorityOrder: $("#mask\\.PriorityOrder").val(),
          MaskItemList: []
        }
      }
    };
    
    $("#mask-item-tbody .mask-item-row").each(function(index, elem) {
      reqDO.SaveMask.Mask.MaskItemList.push($(elem).data("maskItem"));
    });
    
    showWaitGlass();
    vgsService("MetaData", reqDO, false, function(ansDO) {
      hideWaitGlass();
      entitySaveNotification(<%=LkSNEntityType.Mask.getCode()%>, ansDO.Answer.SaveMask.MaskId);
    });
  }
});

</script>