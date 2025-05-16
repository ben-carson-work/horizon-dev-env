<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<% PageBase<?> pageBase = (PageBase<?>)request.getAttribute("pageBase"); %>

<v:page-form page="category_list">
<input type="hidden" name="EntityType" value="<%=pageBase.getParameter("EntityType")%>">
<input type="hidden" name="page-params" value="tab=masks&EntityType=<%=pageBase.getEmptyParameter("EntityType")%>"/>

<div class="tab-toolbar">
  <input type="text" id="search-text" class="form-control default-focus" placeholder="<v:itl key="@Common.Search" />" onkeypress="searchKeyPress()" style="width:200px"/>
  <v:button caption="@Common.Search" fa="search" href="javascript:search()"/>
  <span class="divider"></span>
  <% String hrefNew = pageBase.getContextURL() + "?page=mask&id=new"; %>  
  <v:button caption="@Common.New" fa="plus" href="<%=hrefNew%>"/>
  <v:button caption="@Common.Delete" fa="trash" onclick="doDelSelectedMasks()"/>
  <span class="divider"></span>
  <v:button caption="@Common.Import" fa="sign-in" onclick="showImportDialog()"/>
  <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" bindGrid="mask-grid"  onclick="exporMasks()"/>
  <v:pagebox gridId="mask-grid"/>
</div>

<div class="tab-content">
  <v:last-error/>
  
  <% String params = "EntityType=" + pageBase.getEmptyParameter("EntityType"); %>
  <v:async-grid id="mask-grid" jsp="metadata/mask_grid.jsp" params="<%=params%>" />
</div>

<script>
function search() {
  setGridUrlParam("#mask-grid", "FullText", $("#search-text").val(), true);
}

function searchKeyPress() {
  if (event.keyCode == KEY_ENTER) {
    search();
  }
}

function doDelSelectedMasks() {
	confirmDialog(null, function() {
	  var reqDO = {
	    Command: "DeleteMask",
	    DeleteMask: {
	      MaskIDs: $("[name='cbMaskId']").getCheckedValues()
	    }
	  };
	  
	  vgsService("MetaData", reqDO, false, function(ansDO) {
	    changeGridPage("#mask-grid", 1);
	  });
	});
}

function showImportDialog() {
  asyncDialogEasy("metadata/mask_snapp_import_dialog", "");
}
  
function exporMasks() {
  var bean = getGridSelectionBean("#mask-grid-table", "[name='cbMaskId']");
  if (bean) 
    window.location = BASE_URL + "/admin?page=export&EntityIDs=" + bean.ids + "&EntityType=<%=LkSNEntityType.Mask.getCode()%> + &QueryBase64=" + bean.queryBase64;
}
  
</script>

</v:page-form>