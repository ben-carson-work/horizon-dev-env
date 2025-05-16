<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageDocTemplate" scope="request"/>
<jsp:useBean id="doc" class="com.vgs.web.dataobject.DOUI_DocTemplate" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
boolean canEdit = pageBase.getBLDef().getDocRightCRUD(doc).canUpdate();
%>


<div class="tab-toolbar">
  <v:button-group>
    <v:button-group>
      <v:button id="btn-new" caption="@Common.New" fa="file" dropdown="true" enabled="<%=canEdit%>"/>
      <v:popup-menu bootstrap="true">
      <% for (LookupItem item : LkSN.DataExportOption.getItems()) { %>
        <% String href = "javascript:showNewTaskDialog(" + item.getCode() + ")"; %>
        <v:popup-item fa="<%=BLBO_Task.getDataExportIconAlias(item)%>" caption="<%=item.getRawDescription()%>" href="<%=href%>"/>
      <% } %>
      </v:popup-menu>
    </v:button-group>
    <v:button id="btn-del" caption="@Common.Delete" fa="trash" href="javascript:doDeleteTasks()" enabled="<%=canEdit%>"/>
  </v:button-group>
  
  <v:pagebox gridId="task-dataexport-grid"/>
</div>

<div class="tab-content">
  <% String params = "DocTemplateId=" + pageBase.getId(); %>
  <v:async-grid id="task-dataexport-grid" jsp="doctemplate/task_dataexport_grid.jsp" params="<%=params%>"/>
</div>


<script>
function showNewTaskDialog(option) {
  asyncDialogEasy("doctemplate/task_dataexport_dialog", "DocTemplateId=<%=pageBase.getId()%>&DataExportOption=" + option);
}  

function doDeleteTasks() {
  var ids = $("[name='TaskId']").getCheckedValues();
  if (ids == "")
    showIconMessage("warning", <v:itl key="@Common.NoElementWasSelected" encode="JS"/>);
  else {
    confirmDialog(<v:itl key="@Common.ConfirmDelete" encode="JS"/>, function() {
      var reqDO = {
        Command: "DeleteTask",
        DeleteTask: {
          TaskIDs: ids
        }
      };
      
      vgsService("Task", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.Task.getCode()%>);
      });
    });
  }
}
</script>