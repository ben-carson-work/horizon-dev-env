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
String rowUUID = pageBase.getNullParameter("RowUUID");
LookupItem entityType = LkSN.EntityType.getItemByCode(pageBase.getParameter("EntityType"));
JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(entityType);
JvDataSet dsUser = pageBase.getBL(BLBO_Account.class).getUserDS();
%> 

<v:dialog id="notify_dialog" title="@Common.Notifications" autofocus="false" width="600">

  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="@Common.Entity">
        <input type="text" class="form-control" name="EntityType" disabled="disabled" />
      </v:form-field>
      <v:form-field caption="@Common.Tags">
        <v:multibox name="TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName"/>
      </v:form-field>
      <v:form-field caption="@Common.SecurityRoles">
        <v:multibox name="RoleIDs" linkEntityType="<%=LkSNEntityType.Role%>" filtersJSON="{\"Role\":{\"RoleType\":0,\"ActiveOnly\":true}}"/>
      </v:form-field>
      <v:form-field caption="@Account.Users">
        <v:multibox name="UserIDs" lookupDataSet="<%=dsUser%>" idFieldName="AccountId" captionFieldName="DisplayName"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
   
<script>

$(document).ready(function() {
  var dlg = $("#notify_dialog");
  var rowuuid = <%=JvString.jsString(rowUUID)%>;
  var entityType = <%=entityType.getCode()%>;

  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
      <v:itl key="@Common.Ok" encode="JS"/>: doOk,
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    };
  });
  
  var $tr = $("#notify-grid tr[data-rowuuid='" + rowuuid + "']");
  dlg.find("[name='EntityType']").val($tr.find(".td-entity a").text());
  dlg.find("[name='TagIDs']")[0].selectize.setValue($tr.attr("data-tags").split(","));
  dlg.find("[name='RoleIDs']")[0].selectize.setValue($tr.attr("data-roles").split(","));
  dlg.find("[name='UserIDs']")[0].selectize.setValue($tr.attr("data-users").split(","));
  
  dlg.keypress(function() {
    if (event.keyCode == KEY_ENTER)
      doOk();
  });
  
  function getSelectizeText(elem) {
    var sel = $(elem)[0].selectize;
    var values = sel.getValue();
    var result = [];
    if (values) {
      for (var i=0; i<values.length; i++) {
        var item = sel.getItem(values[i]).clone();
        item.children().remove();
        result.push(item.text());
      }
    }
    return result;
  }

  function doOk() {
    addNotifyRule({
      RowUUID: rowuuid,
      EntityType: entityType,
      EntityTypeDesc: dlg.find("[name='EntityType']").val(),
      TagIDs: dlg.find("[name='TagIDs']").val(),
      TagNames: getSelectizeText(dlg.find("[name='TagIDs']")),
      RoleIDs: dlg.find("[name='RoleIDs']").val(),
      RoleNames: getSelectizeText(dlg.find("[name='RoleIDs']")),
      UserIDs: dlg.find("[name='UserIDs']").val(),
      UserNames: getSelectizeText(dlg.find("[name='UserIDs']"))
    });
    dlg.dialog("close");
  }
});

</script>

</v:dialog>
