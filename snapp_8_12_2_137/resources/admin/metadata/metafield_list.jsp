<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<script>
function search() {
  setGridUrlParam("#metafield-grid", "FullText", $("#search-text").val(), true);
}

function searchKeyPress() {
  if (event.keyCode == KEY_ENTER) {
    search();
  }
}
</script>

<div class="tab-toolbar">
  <input type="text" id="search-text" class="form-control default-focus" placeholder="<v:itl key="@Common.Search" />" onkeypress="searchKeyPress()" style="width:200px"/>
  <v:button caption="@Common.Search" fa="search" href="javascript:search()"/>
  <span class="divider"></span>
  <v:button caption="@Common.New" fa="plus" href="javascript:asyncDialogEasy('metadata/metafield_dialog', 'id=new')"/>
  <v:button caption="@Common.Delete" fa="trash" href="javascript:doDeleteMetaFields()"/>
  <span class="divider"></span>
  <v:button caption="@Common.Import" fa="sign-in" onclick="showImportDialog()"/>
  <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" bindGrid="metafield-grid"  onclick="exporMetafields()"/>
  <v:pagebox gridId="metafield-grid"/>
</div>

<div class="tab-content">
  <v:last-error/>
  <v:async-grid id="metafield-grid" jsp="metadata/metafield_grid.jsp" />
</div>

<script>

function doDeleteMetaFields() {
  confirmDialog(null, function() {
    var reqDO = {
      Command: "DeleteMetaField",
      DeleteMetaField: {
        MetaFieldIDs: $("[name='MetaFieldId']").getCheckedValues()
      }
    };
    
    vgsService("MetaData", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.MetaField.getCode()%>);
    });
  });
}

function showImportDialog() {
  asyncDialogEasy("metadata/metafield_snapp_import_dialog", "");
}
	  
function exporMetafields() {
  var bean = getGridSelectionBean("#metafield-grid-table", "[name='MetaFieldId']");
  if (bean) 
    window.location = BASE_URL + "/admin?page=export&EntityIDs=" + bean.ids + "&EntityType=<%=LkSNEntityType.MetaField.getCode()%> + &QueryBase64=" + bean.queryBase64;
}

</script>

