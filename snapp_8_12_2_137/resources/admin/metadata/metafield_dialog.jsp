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
DOMetaField metaField = pageBase.isNewItem() ? bl.prepareNewMetaField() : bl.loadMetaField(pageBase.getId()); 
request.setAttribute("metafield", metaField);
String title = pageBase.isNewItem() ? pageBase.getLang().Common.FormField.getText() : metaField.MetaFieldName.getString();
boolean canEdit = true;

request.setAttribute("EntityRight_CanEdit", canEdit);
request.setAttribute("EntityRight_RightList", metaField.RightList);
request.setAttribute("EntityRight_EntityTypes", new LookupItem[] {LkSNEntityType.Workstation, LkSNEntityType.Person});
request.setAttribute("EntityRight_ShowRightLevelCreate", true);
request.setAttribute("EntityRight_ShowRightLevelAutofill", true);
request.setAttribute("EntityRight_ShowRightLevelEdit", true);
request.setAttribute("EntityRight_ShowRightLevelDelete", false);
request.setAttribute("FieldDataType", pageBase.isNewItem() ? 0 : metaField.FieldDataType.getLkValue().getCode());
%>

<v:dialog id="metafield_dialog" tabsView="true" title="<%=JvString.escapeHtml(title)%>" width="800" height="800" autofocus="false">
  <jsp:include page="../configlang_inline_dialog.jsp"/>
  
  <v:tab-group name="tab" main="true">
    <v:tab-item-embedded tab="tabs-main" caption="@Common.Profile" default="true">
      <jsp:include page="metafield_dialog_tab_main.jsp"/>
    </v:tab-item-embedded>
   
    <v:tab-item-embedded tab="tabs-items" caption="@Common.Items">
      <jsp:include page="metafield_dialog_tab_items.jsp"/>
    </v:tab-item-embedded>
  
    <v:tab-item-embedded tab="tabs-right" caption="@Common.Rights">
      <jsp:include page="../common/page_tab_rights.jsp"/>
    </v:tab-item-embedded>
  </v:tab-group>

<script>
//# sourceURL=metafield_dialog.jsp
$(document).ready(function() {
	var dlg = $("#metafield_dialog");
	dlg.on("snapp-dialog", function(event, params) {
	  params.buttons = {
      <v:itl key="@Common.Save" encode="JS"/>: saveMetaField,
	    <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
	  };
	});
});
	
	
function saveMetaField() {
	var oldFieldDataType = <%=request.getAttribute("FieldDataType")%>;
	var newFieldDataType = $("#metafield\\.FieldDataType").val();
	var fieldDataTypeChanged = <%=!metaField.MetaFieldId.isNull()%> && (oldFieldDataType != newFieldDataType);
	if (fieldDataTypeChanged) {
		 var reqDO = {
	      Command: "CountMetaFieldOccurrences",
 		      CountMetaFieldOccurrences: {
  	    	  LocateMetaField: {
	      	    MetaFieldId: <%=metaField.MetaFieldId.getJsString()%>
		    	  }
		      }
			  };
			    
		    vgsService("MetaData", reqDO, false, function(ansDO) {
		    	var affectedRecords = ansDO.Answer.CountMetaFieldOccurrences.MetaFieldCount;
	        if (affectedRecords != 0) {
             var dlgMessage = itl("@Common.MetaFieldDataTypeChangeConfirm", affectedRecords);
	          confirmDialog(dlgMessage, doSaveMetaField);
	        }
	        else
	        	doSaveMetaField();
			  });
	}
	else 
     doSaveMetaField();
}

function doSaveMetaField() {
   var reqDO = {
     Command: "SaveMetaField",
     SaveMetaField: {
       MetaField: {
         MetaFieldId: <%=metaField.MetaFieldId.isNull() ? null : "\"" + metaField.MetaFieldId.getEmptyString() + "\""%>,
         MetaFieldCode: $("#metafield\\.MetaFieldCode").val(),
         MetaFieldName: $("#metafield\\.MetaFieldName").val(),
         FieldType: <%=metaField.FieldType.isNull() ? null : metaField.FieldType.getInt()%>,
         FieldDataType: $("#metafield\\.FieldDataType").val(),
         FieldDataFormat: $("#metafield\\.FieldDataFormat").val(),
         FullTextIndex: $("#metafield\\.FullTextIndex").isChecked(),
         UniqueIndex: $("#metafield\\.UniqueIndex").isChecked(),
         Encrypted: $("#metafield\\.Encrypted").isChecked(),
         Engravable: $("#metafield\\.Engravable").isChecked(),
         AutoPopulate: $("#metafield\\.AutoPopulate").isChecked(),
         PurgeOption: $("[name='metafield\\.PurgeOption']:checked").val(),
         RandomCombine: $("#metafield\\.RandomCombine").val(),
         MaxLength: $("#metafield\\.MaxLength").val()=="" ? null : $("#metafield\\.MaxLength").val(),
         MetaFieldItemList: [],
         RightList: [],
         Masking: {
           MaskingRule: $("#masking\\.MaskingRule").val(),
           UnmaskedStartChars: $("#masking\\.UnmaskedStartChars").val(),
           UnmaskedEndChars: $("#masking\\.UnmaskedEndChars").val(),
           SplitWords: $("#masking\\.SplitWords").isChecked(),
           MaskedMinChars: $("#masking\\.MaskedMinChars").val(),
           MaskedMinCharsAlign: $("#masking\\.MaskedMinCharsAlign").val()
         }
       }
     }
   };

  var select = $("#metafielditem-list")[0];
  for(var i=0; i < select.options.length; i++) {
	  var opt = $(select.options[i]);
	  reqDO.SaveMetaField.MetaField.MetaFieldItemList.push($(select.options[i]).data("itemDO"));
  }

  var rows = $("#entityright-grid tbody tr").not(".group");
  for (var i=0; i<rows.length;  i++) {
    reqDO.SaveMetaField.MetaField.RightList.push({
      UsrEntityType: $(rows[i]).attr("data-EntityType"),  
      UsrEntityId: $(rows[i]).attr("data-EntityId"),
      RightLevel: $(rows[i]).find("[name='RightLevel']").val()
    });
  }
  
	vgsService("MetaData", reqDO, false, function(ansDO) {
		triggerEntityChange(<%=LkSNEntityType.MetaField.getCode()%>);
    $("#metafield_dialog").dialog("close");
	});
}


</script>

</v:dialog>