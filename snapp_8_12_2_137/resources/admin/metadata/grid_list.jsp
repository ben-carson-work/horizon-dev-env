<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<% PageBase<?> pageBase = (PageBase<?>)request.getAttribute("pageBase"); %>

<div class="tab-toolbar">
  <v:button caption="@Common.New" fa="plus" title="@Common.Grid" href="admin?page=grid&id=new"/>
  <v:button caption="@Common.Delete" fa="trash" href="javascript:doDelSelectedGrids()"/>
  <v:pagebox gridId="grid-grid"/>
</div>

<div class="tab-content">
  <v:last-error/>
  <v:async-grid id="grid-grid" jsp="metadata/grid_grid.jsp"/>
</div>

<script>
function doDelSelectedGrids() {
	confirmDialog(null, function() {
	  var reqDO = {
	    Command: "DeleteGrid",
	    DeleteGrid: {
	      GridIDs: $("[name='cbGridId']").getCheckedValues()
	    }
	  };
	  
	  vgsService("Grid", reqDO, false, function(ansDO) {
	    changeGridPage("#grid-grid", 1);
	  });
	});
}
</script>