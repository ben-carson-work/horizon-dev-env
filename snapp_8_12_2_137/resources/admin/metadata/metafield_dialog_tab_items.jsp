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

<style>
.metafield-button {
  margin: 5px;
  margin-bottom: 0;
  margin-right: 15px;
}
#metafielditem-detail .form-field-caption {
  width: 100px;
}
#metafielditem-detail .form-field-value {
  margin-left: 103px;
}
</style>

<% 
BLBO_MetaData bl = pageBase.getBL(BLBO_MetaData.class);
DOMetaField metaField = pageBase.isNewItem() ? bl.prepareNewMetaField() : bl.loadMetaField(pageBase.getId()); 
boolean isLangField = metaField.FieldType.isLookup(LkSNMetaFieldType.Language);
%>

<div class="tab-content">
  <v:widget id="metafielditem-widget" caption="@Common.Items">
    <v:widget-block>
      <table style="width:100%">
        <tr valign="top">
          <td width="30%">
            <select id="metafielditem-list" multiple size="10" style="width:100%"></select>
          </td>
          <td nowrap>
            <v:button id="new-btn" clazz="metafield-button" fa="plus" href="javascript:createItem({})" enabled="<%=!isLangField%>"/><br/>
            <v:button id="del-btn" clazz="metafield-button" fa="trash" href="javascript:doDelItems()" enabled="<%=!isLangField%>"/><br/>
            <v:button id="up-btn" clazz="metafield-button" fa="chevron-up" href="javascript:doMoveUp()" enabled="<%=!isLangField%>"/><br/>
            <v:button id="down-btn" clazz="metafield-button" fa="chevron-down" href="javascript:doMoveDown()" enabled="<%=!isLangField%>"/><br/>
            <v:button id="import-btn" clazz="metafield-button" fa="sign-in" href="javascript:doOpenImportDialog()" enabled="<%=!isLangField%>"/><br/>
          </td>
          <td width="70%">
            <div id="metafielditem-detail">
  	          <v:form-field caption="@Common.Code" mandatory="true"><input type="text" id="metafielditem-code" class="form-control" <%=isLangField?"readonly='readonly'":""%>/></v:form-field>
  	          <v:form-field caption="@Common.Name" mandatory="true">
  	            <div class="input-group">
  	              <input type="text" id="metafielditem-name" class="form-control" maxlength="50">
  	              <span class="input-group-btn"><button id="btn-configlang-name" class="btn btn-default multi-lang-edit-button" type="button">&nbsp;</button></span>
  	            </div>
              </v:form-field>
            </div>
          </td>
        </tr>
      </table>
    </v:widget-block>
  </v:widget>
</div>

<script>
	<% for (DOMetaField.DOMetaFieldItem item : metaField.MetaFieldItemList.getItems()) { %>
	  createItem(<%=item.getJSONString()%>);
	<% } %>
	 
  $("#metafielditem-name").closest(".input-group").find(".multi-lang-edit-button").click(function() {
    _showConfigLangDialog('ITL_Name');
  });
  
  function _showConfigLangDialog(fieldName) {
    var opt = getSelectedOption();
    if (opt != null) {
      var itemDO = opt.data("itemDO");
      showConfigLangDialog(itemDO[fieldName], function(list) {
        itemDO[fieldName] = list;
        opt.data("itemDO", itemDO);
      });
    }
  }

	refreshItemDetails();

function doOpenImportDialog() {
	doSaveMetaField();
	asyncDialogEasy("metadata/metafielditem_import_dialog", "id=<%=metaField.MetaFieldId.getString()%>");
}

function getSelectedOptions() {
	var result = [];
  var select = $("#metafielditem-list")[0];
  for(var i=0; i < select.options.length; i++)
    if (select.options[i].selected)
      result.push($(select.options[i]));
  return result;
}

function getSelectedOption() {
  var opts = getSelectedOptions();
  return (opts.length == 1) ? opts[0] : null;
}

function refreshItemDetails() {
  var fdt = $("#metafield\\.FieldDataType").val();
  $("#metafielditem-widget").setClass("v-hidden", !((fdt == <%=LkSNMetaFieldDataType.DropDown.getCode()%>) || (fdt == <%=LkSNMetaFieldDataType.SingleChoice.getCode()%>) || (fdt == <%=LkSNMetaFieldDataType.MultipleChoice.getCode()%>) || (fdt == <%=LkSNMetaFieldDataType.Random.getCode()%>)));
  $("#text-format-field").setClass("v-hidden", !(fdt == <%=LkSNMetaFieldDataType.Text.getCode()%>));
  $("#random-combine-field").setClass("v-hidden", !(fdt == <%=LkSNMetaFieldDataType.Random.getCode()%>));
  $("#max-length-field").setClass("v-hidden", !((fdt == <%=LkSNMetaFieldDataType.Text.getCode()%>) || (fdt == <%=LkSNMetaFieldDataType.Numeric.getCode()%>) || (fdt == <%=LkSNMetaFieldDataType.Telephone.getCode()%>) || (fdt == <%=LkSNMetaFieldDataType.Email.getCode()%>)));
  $("#btn-import").setClass("v-hidden", !((fdt == <%=LkSNMetaFieldDataType.DropDown.getCode()%>) || (fdt == <%=LkSNMetaFieldDataType.SingleChoice.getCode()%>) || (fdt == <%=LkSNMetaFieldDataType.MultipleChoice.getCode()%>) || (fdt == <%=LkSNMetaFieldDataType.Random.getCode()%>)));

  var opt = getSelectedOption();
  if (opt != null) {
    var data = opt.data("itemDO");
    $("#metafielditem-code").val(data.MetaFieldItemCode || "");
    $("#metafielditem-name").val(data.MetaFieldItemName || "");
  }
	
	$("#metafielditem-detail").setClass("v-hidden", opt == null);
}

function createItem(data) {
	var opt = $("<option/>").appendTo("#metafielditem-list");
  opt.data("itemDO", data);

  setItemValues(opt, data.MetaFieldItemCode, data.MetaFieldItemName);
	
	$("#metafielditem-list option").removeAttr("selected");
	opt.attr("selected", "selected");
	refreshItemDetails();
	
	return opt;
}

function setItemValues(opt, code, name) {
  var data = opt.data("itemDO");
  
  data.MetaFieldItemCode = code;
  data.MetaFieldItemName = name;
  opt.data("itemDO", data);
  
  code = (code) ? code : "";
	name = (name) ? name : "";
  opt.val(code);
  opt.text("[" + code + "] " + name);
}

$("#metafielditem-list").change(refreshItemDetails);
$("#metafield\\.FieldDataType").change(refreshItemDetails);

$("#metafielditem-detail").keyup(function() {
	  var opt = getSelectedOption();
	  if (opt != null) 
	    setItemValues(opt, $("#metafielditem-code").val(), $("#metafielditem-name").val());
});


function doDelItems() {
	var opts = getSelectedOptions();
	for (var i=0; i<opts.length; i++)
		opts[i].remove();
	refreshItemDetails();
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

</script>