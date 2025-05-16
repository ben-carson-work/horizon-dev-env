<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageGrid" scope="request"/>
<jsp:useBean id="grid" class="com.vgs.snapp.dataobject.DOGrid" scope="request"/>

<div class="tab-toolbar">
  <v:button caption="@Common.Save" fa="save" onclick="doSaveGrid()"/>
</div>

<div class="tab-content">  
  <v:widget caption="@Common.Profile">
    <v:widget-block>
      <v:form-field caption="@Common.Type" mandatory="true">
        <select id="grid.EntityType" class="form-control">
          <%
          for (LookupItem entityType : BLBO_Grid.getGridEntityTypes()) {
            String selected = entityType.equals(grid.EntityType.getLkValue()) ? "selected" : "";
          %>
            <option value="<%=entityType.getCode()%>" <%=selected%>><%=entityType.getHtmlDescription(pageBase.getLang())%></option>
          <% } %>
        </select>
      </v:form-field>
      <v:form-field caption="@Common.Code" mandatory="true">
        <v:input-text field="grid.GridCode" />
      </v:form-field>
      <v:form-field caption="@Common.Name" mandatory="true">
        <v:input-text field="grid.GridName" />
      </v:form-field>
      <v:form-field caption="@Common.Data">
        <v:input-txtarea field="grid.GridData" rows="25" />
      </v:form-field>
    </v:widget-block>
  </v:widget>
</div>

<script>

function doSaveGrid() {
  checkRequired("#grid-form", function (){
	showWaitGlass();
	
	var gridData = $("#grid\\.GridData").val()=="" ? "{}" : $("#grid\\.GridData").val();
	var reqDO = {
	  Command: "SaveGrid",
	  SaveGrid: {
	    Grid: {
	      GridId: <%=grid.GridId.isNull() ? null : "\"" + grid.GridId.getEmptyString() + "\""%>,
          GridCode: $("#grid\\.GridCode").val(),
          GridName: $("#grid\\.GridName").val(),
		  EntityType: $("#grid\\.EntityType").val(),
		  GridData: gridData,
	    }
	  }
	};
		
    vgsService("Grid", reqDO, false, function(ansDO) {
      hideWaitGlass();
      entitySaveNotification(<%=LkSNEntityType.Grid.getCode()%>, ansDO.Answer.SaveGrid.Grid.GridId);
    });
  });
}

function doBuildGrid() {
  asyncDialogEasy('grid/grid_builder_dialog', 'id=<%=pageBase.getId()%>');
}

</script> 
