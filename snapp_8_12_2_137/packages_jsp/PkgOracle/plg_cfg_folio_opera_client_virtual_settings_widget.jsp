<%@page import="com.vgs.vcl.JvImageCache"%>
<%@page import="com.vgs.snapp.lookup.LkSN"%>
<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@page import="com.vgs.web.library.BLBO_Tag"%>
<%@page import="com.vgs.cl.document.JvDocument"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget id="opera-settings-virtual-client" caption="Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
	<v:widget-block>
		<v:form-field caption="Guest list file" hint="Drag & drop or select the file with the list of guest for the virtual plugin">
			<v:input-upload-item field="GuestListFile"/>
   	</v:form-field>
	</v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  var $cfg = $("#opera-settings-virtual-client");
  
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    if (params.settings.GuestListFile)
    	$cfg.find("#GuestListFile").valObject(JSON.stringify(params.settings.GuestListFile));
    
  });
  
  function setMultibxoVal($sel, value){
    $sel.attr('data-html', $sel.html());
    $sel.selectize({
      dropdownParent:"body",
      plugins: ['remove_button','drag_drop']
    })[0].selectize.setValue(value, true);
  }
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
        GuestListFile:				$("#GuestListFile").valObject()
    };
  });
  
  function _parseInt($field) {
    var value = getNull($field.val());
    if (value == null)
      return null;
    else {
      var result = parseInt(value);
      if (isNaN(result)) {
        var fieldName = $field.closest(".form-field").find(".form-field-caption").text();
        throw "Invalid value \"" + value + "\" for field \"" + fieldName + "\""
      }
      return result;
    }
  }
});
</script>
