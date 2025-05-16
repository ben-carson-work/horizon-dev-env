<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageDataSourceList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
  boolean canCreate = rights.SuperUser.getBoolean() || rights.DataSources.canCreate();
  boolean canDelete = rights.SuperUser.getBoolean() || rights.DataSources.canDelete();
%>

<%!
private String buildNewOnClick(LookupItem dataSourceType) {
  return "asyncDialogEasy('system/datasource_dialog', 'id=new&DataSourceType=" + dataSourceType.getCode() + "')";
}
%>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<script>
  function search() {
	setGridUrlParam("#datasource-grid", "FullText", $("#full-text-search").val());
	setGridUrlParam("#datasource-grid", "DataSourceType", $("[name='DataSourceType']").getCheckedValues());
	changeGridPage("#datasource-grid", 1);
  }
  
  function searchKeyPress() {
	if (event.keyCode == KEY_ENTER) {
	  search();
	  event.preventDefault(); 
	}
  }

  function deleteDataSources() {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteDataSource",
        DeleteDataSource: {
          DataSourceIDs: $("[name='DataSourceId']").getCheckedValues()
        }
      };

      showWaitGlass();
      vgsService("System", reqDO, false, function(ansDO) {
        hideWaitGlass();
        triggerEntityChange(<%=LkSNEntityType.DataSource.getCode()%>);
      });
    });
  }
</script>


<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <v:button caption="@Common.Search" fa="search" onclick="search()"/>

      <span class="divider"></span>

      <div class="btn-group">
	    <v:button caption="@Common.New" fa="plus" dropdown="true" enabled="<%=canCreate%>"/>
	    <v:popup-menu bootstrap="true">
	      <% for (LookupItem type : LkSN.DataSourceType.getItems()) { %>
               <v:popup-item caption="<%=type.getRawDescription()%>" onclick="<%=buildNewOnClick(type)%>"/>
	      <% } %>
	    </v:popup-menu>
      </div>

      <v:button caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" onclick="deleteDataSources()" enabled="<%=canDelete%>"/> 
      
      <v:pagebox gridId="datasource-grid"/>
    </div>

    <div class="tab-content">      
      <div class="profile-pic-div">
        <v:widget caption="@Common.Search">
          <v:widget-block>
            <input type="text" id="full-text-search" class="form-control default-focus" placeholder="<v:itl key="@Common.FullSearch"/>" value="<%=pageBase.getEmptyParameter("FullText")%>"/>
          </v:widget-block>
      </v:widget>        
      <v:widget caption="@Common.Type">
        <v:widget-block>
          <% for (LookupItem item : LkSN.DataSourceType.getItems()) { %>
            <v:db-checkbox field="DataSourceType" caption="<%=item.getDescription(pageBase.getLang())%>" value="<%=String.valueOf(item.getCode())%>"/><br/>
          <% } %>
        </v:widget-block>
      </v:widget>
      </div>
            
      <div class="profile-cont-div">
        <v:async-grid id="datasource-grid" jsp="system/datasource_grid.jsp"/>
      </div> 
    </div>
  </v:tab-item-embedded>
</v:tab-group>

 
<jsp:include page="/resources/common/footer.jsp"/>