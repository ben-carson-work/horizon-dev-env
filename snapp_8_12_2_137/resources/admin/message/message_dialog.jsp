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
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
BLBO_Message bl = pageBase.getBL(BLBO_Message.class);
DOMessage msg = pageBase.isNewItem() ? bl.prepareNewMessage() : bl.loadMessage(pageBase.getId());
request.setAttribute("msg", msg);
boolean canEdit = rights.SettingsMessages.getBoolean();

request.setAttribute("EntityRight_CanEdit", canEdit);
request.setAttribute("EntityRight_RightList", msg.RightList);
request.setAttribute("EntityRight_EntityTypes", new LookupItem[] {LkSNEntityType.Workstation, LkSNEntityType.Person});
request.setAttribute("EntityRight_ShowRightLevelAutofill", false);
request.setAttribute("EntityRight_ShowRightLevelEdit", false);
request.setAttribute("EntityRight_ShowRightLevelDelete", false);
%>

<v:dialog id="message_dialog" tabsView="true" title="@Common.Message" width="800" height="600" autofocus="false">

  <v:tab-group name="tab" main="true">
    <v:tab-item-embedded tab="tabs-main" caption="@Common.Profile" default="true">
      <jsp:include page="message_dialog_tab_main.jsp"/>
    </v:tab-item-embedded>
  
    <v:tab-item-embedded tab="tabs-msg" caption="@Common.Message">
      <jsp:include page="message_dialog_tab_msg.jsp"/>
    </v:tab-item-embedded>
  
    <v:tab-item-embedded tab="tabs-right" caption="@Common.Rights">
      <jsp:include page="../common/page_tab_rights.jsp"/>
    </v:tab-item-embedded>
    
    <% if (!pageBase.isNewItem()) { %>
      <v:tab-item-embedded tab="tabs-read" caption="@Common.Reads">
        <jsp:include page="message_dialog_tab_read.jsp"/>
      </v:tab-item-embedded>
      
      <% if (rights.History.getBoolean()) { %>
        <v:tab-item-embedded tab="tabs-history" caption="@Common.History">
          <jsp:include page="../common/page_tab_historydetail.jsp"/>
        </v:tab-item-embedded>
      <% } %>  
    <% } %>
  </v:tab-group>


<script>
$(document).ready(function() {
  var dlg = $("#message_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
      <% if (canEdit) { %>
      <v:itl key="@Common.Save" encode="JS"/>: doSave,
      <% } %>
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    };
  });
});

function doSaveMessage() {
  var reqDO = {
    Command: "SaveMessage",
    SaveMessage: {
      Message: {
        MessageId: <%=msg.MessageId.getJsString()%>,
        MessageName: $("#msg\\.MessageName").val(),
        CategoryId: $("#msg\\.CategoryId").val(),
        Enabled: $("#msg\\.Enabled").isChecked(),
        ForcePopupDialog: $("#msg\\.ForcePopupDialog").isChecked(),
        DateTimeFrom: $("#msg\\.DateTimeFrom-picker").getXMLDateTime(),
        DateTimeTo: $("#msg\\.DateTimeTo-picker").getXMLDateTime(),
        Message: $("#msg\\.Message").val(),
        RightList: []
      }
    }
  };
  
  var rows = $("#entityright-grid tbody tr").not(".group");
  for (var i=0; i<rows.length;  i++) {
    reqDO.SaveMessage.Message.RightList.push({
      UsrEntityType: $(rows[i]).attr("data-EntityType"),  
      UsrEntityId: $(rows[i]).attr("data-EntityId"),
      RightLevel: <%=LkSNRightLevel.Read.getCode()%>
    });
  }

  vgsService("Message", reqDO, false, function(ansDO) {
    triggerEntityChange(<%=LkSNEntityType.Message.getCode()%>);
    $("#message_dialog").dialog("close");
  });
}

function doSave() {
  checkRequired("#message_dialog", function() {
    doSaveMessage();
  })
}

//Data Masks
function reloadMaskEdit(categoryId) {
  asyncLoad("#maskedit-container", "admin?page=maskedit_widget&id=<%=pageBase.getId()%>&EntityType=<%=LkSNEntityType.ProductType.getCode()%>&CategoryId=" + categoryId + "&readonly=<%=!canEdit%>");
}

reloadMaskEdit(document.getElementById("msg.CategoryId").value);
$("#msg\\.CategoryId").change(function() {
  reloadMaskEdit(this.value);
});
</script>

</v:dialog>