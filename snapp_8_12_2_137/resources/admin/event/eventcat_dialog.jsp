<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% 
DOEventCategory eventcat;
if (pageBase.isNewItem()) {
  eventcat = pageBase.getBL(BLBO_Event.class).prepareNewEventCategory();
}
else
  eventcat = pageBase.getBL(BLBO_Event.class).getEventCategory(pageBase.getId());

request.setAttribute("eventcat", eventcat); 
%>

<v:dialog id="eventcat_dialog" tabsView="true" title="@Common.Survey" width="600" height="400" autofocus="false">
   
<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-main" caption="@Common.Profile" icon="profile.png" default="true">
    <jsp:include page="eventcat_dialog_tab_main.jsp"/>
  </v:tab-item-embedded>
</v:tab-group>


<script>

var eventcat = <%=eventcat.getJSONString()%>;

$(document).ready(function() {
  var dlg = $("#eventcat_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
      <v:itl key="@Common.Save" encode="JS"/>: doSaveEventCat,
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    };
  });

  function doSaveEventCat() {
    var reqDO = {
      Command: "SaveEventCategory",
      SaveEventCategory: {
        EventCategory: {
          EventCategoryId: eventcat.EventCategoryId,
          EventCategoryCode: $("#eventcat\\.EventCategoryCode").val(),
          EventCategoryName: $("#eventcat\\.EventCategoryName").val(),
          EventCategoryType: $("#eventcat\\.EventCategoryType").val(),
          Enabled: $("#eventcat\\.Enabled").val()
        }
      }
    };
    
    vgsService("Event", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.EventCategory.getCode()%>, ansDO.Answer.SaveEventCategory.EventCategoryId);
      $("#eventcat_dialog").dialog("close");
    });
  }
});

</script>

</v:dialog>


