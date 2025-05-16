<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.servlet.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% 
%> 

<v:dialog id="notify_add_dialog" title="@Common.Notifications" width="600">

  <v:form-field caption="@Common.Entity">
    <v:lk-combobox field="EntityType" lookup="<%=LkSN.EntityType%>" alphaSort="true" allowNull="false"/>
  </v:form-field>
   
<script>

$(document).ready(function() {
  var dlg = $("#notify_add_dialog");

  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
      <v:itl key="@Common.Ok" encode="JS"/>: doAdd,
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    };
  });
  
  dlg.keypress(function() {
    if (event.keyCode == KEY_ENTER)
      doAdd();
  });

  function doAdd() {
    var rowuuid = newStrUUID();
    var entityType = parseInt(dlg.find("[name='EntityType']").val());
    addNotifyRule({
      RowUUID: rowuuid,
      EntityType: entityType,
      EntityTypeDesc: dlg.find("[name='EntityType'] option:selected").text()
    });
    asyncDialogEasy("log/notify_dialog", "RowUUID=" + rowuuid + "&EntityType=" + entityType);
    dlg.dialog("close");
  }
});

</script>

</v:dialog>
