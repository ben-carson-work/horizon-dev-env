<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% 
BLBO_MetaData bl = pageBase.getBL(BLBO_MetaData.class);
DOMetaFieldGroup metaFieldGroup = pageBase.isNewItem() ? bl.prepareNewMetaFieldGroup() : bl.loadMetaFieldGroup(pageBase.getId()); 
String title = pageBase.isNewItem() ? pageBase.getLang().Common.MetaFieldGroup.getText() : metaFieldGroup.MetaFieldGroupName.getString();
%>

<v:dialog id="metafieldgroup_dialog" tabsView="true" title="<%=JvString.escapeHtml(title)%>" width="800" height="660" autofocus="false">
  <jsp:include page="../configlang_inline_dialog.jsp"/>
  
  <v:tab-group name="tab" main="true">
    <v:tab-item-embedded tab="tabs-main" caption="@Common.Profile" default="true">
      <jsp:include page="metafieldgroup_dialog_tab_main.jsp"/>
    </v:tab-item-embedded>
  
  </v:tab-group>

<script>
$(document).ready(function() {
	var dlg = $("#metafieldgroup_dialog");
	dlg.on("snapp-dialog", function(event, params) {
	  params.buttons = {
      <v:itl key="@Common.Save" encode="JS"/>: doSaveMetaFieldGroup,
	    <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
	  };
	});
	
	function doSaveMetaFieldGroup() {
		var reqDO = {
		    Command: "SaveMetaFieldGroup",
        SaveMetaFieldGroup: {
			    MetaFieldGroupId: <%=metaFieldGroup.MetaFieldGroupId.isNull() ? null : "\"" + metaFieldGroup.MetaFieldGroupId.getEmptyString() + "\""%>,
		 	    MetaFieldGroupCode: $("#metafieldgroup\\.MetaFieldGroupCode").val(),
		 	    MetaFieldGroupName: $("#metafieldgroup\\.MetaFieldGroupName").val(),
		 	    SearchMatchType: parseInt($("[name='metafieldgroup.SearchMatchType']:checked").val()),
		 	    MetaFieldList: []
	    	}
	  };

	  var metaFieldIDs = $("#metafieldgroup\\.MetaFieldIDs").getStringArray();
	  for(var i=0; i < metaFieldIDs.length; i++) {
		  reqDO.SaveMetaFieldGroup.MetaFieldList.push({
				    MetaFieldId: metaFieldIDs[i]
		  });
	  }

		vgsService("MetaData", reqDO, false, function(ansDO) {
			triggerEntityChange(<%=LkSNEntityType.MetaFieldGroup.getCode()%>);
	    $("#metafieldgroup_dialog").dialog("close");
		});
	}
});	

</script>

</v:dialog>