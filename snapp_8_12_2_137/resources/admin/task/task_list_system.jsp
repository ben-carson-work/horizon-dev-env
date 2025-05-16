<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTaskList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<v:tab-toolbar>
  <v:button id="btn-task-search" caption="@Common.Search" fa="search"/>

  <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.Task.getCode() + ")";%>
  <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/>
  
  <v:pagebox gridId="task-grid"/>
</v:tab-toolbar>

<v:tab-content>
  <v:profile-recap>
    <div class="v-filter-container">
      <v:widget caption="@Common.Filters">
        <v:widget-block>
          <input type="text" id="full-text-search" class="form-control default-focus" placeholder="<v:itl key="@Common.FullSearch"/>" value="<%=pageBase.getEmptyParameter("FullText")%>"/>
        </v:widget-block>
        
        <v:widget-block>
          <v:lk-checkbox field="TaskStatus" lookup="<%=LkSN.TaskStatus%>" hideItems="<%=LookupManager.getArray(LkSNTaskStatus.Completed)%>" defaultValue="<%=LookupManager.getArray(LkSNTaskStatus.Active)%>"/>
        </v:widget-block>
        
        <v:widget-block>
          <div><v:itl key="@Plugin.ExtensionPackage"/></div>
          <snp:dyncombo id="ExtensionPackageId" entityType="<%=LkSNEntityType.ExtensionPackage%>" auditLocationFilter="true"/>        
        </v:widget-block>
        
      </v:widget>
    </div>
  </v:profile-recap>
  
  <v:profile-main>
    <% String params = "TaskType=" + LkSNTaskType.GenericSystemTask.getCode() + "&TaskStatus=" + LkSNTaskStatus.Active.getCode(); %>
    <v:async-grid id="task-grid" jsp="task/task_grid.jsp" params="<%=params%>"/>
  </v:profile-main>
</v:tab-content>

<script>
$(document).ready(function() {
  $("#btn-task-search").click(_search);
  $("#full-text-search").keypress(_searchOnEnter);
  
  function _search() {
    var $grid = $("#task-grid");
    setGridUrlParam($grid, "TaskType", <%=LkSNTaskType.GenericSystemTask.getCode()%>);
    setGridUrlParam($grid, "FullText", $("#full-text-search").val());
    setGridUrlParam($grid, "TaskStatus", $("[name='TaskStatus']").getCheckedValues());
    setGridUrlParam($grid, "ExtensionPackageId", $("#ExtensionPackageId").val());
    changeGridPage($grid, "first");
  }
  
  function _searchOnEnter() {
    if (event.keyCode == KEY_ENTER)
      _search();
  }
});
</script>