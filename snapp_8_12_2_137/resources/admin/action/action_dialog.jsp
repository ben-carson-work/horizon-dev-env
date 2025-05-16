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
  DOAction action;
if (pageBase.isNewItem()) {
  LookupItem entityType = pageBase.getLkParameter(LkSN.EntityType, "entityType");
  JvDateTime dateTimeFrom = (pageBase.getNullParameter("DateTimeFrom") == null) ? JvDateTime.now() : JvDateTime.createByXML(pageBase.getNullParameter("DateTimeFrom"));
  action = pageBase.getBL(BLBO_Action.class).prepareNewAction(entityType, dateTimeFrom, pageBase.getNullParameter("AssigneeAccountId"));
}
else
  action = pageBase.getBL(BLBO_Action.class).loadAction(pageBase.getId());

action.CreateDateTime.setDisplayFormat(pageBase.getShortDateTimeFormat());
action.CloseDateTime.setDisplayFormat(pageBase.getShortDateTimeFormat());

request.setAttribute("action", action); 

String title = pageBase.isNewItem() ? pageBase.getLang().Common.New.getText() : action.ActionName.getHtmlString();
%>

<v:dialog id="action_dialog" title="<%=title%>" width="600">
  <!-- prevent default focusing --><span class="ui-helper-hidden-accessible"><input type="text"/></span>
   
  <div id="tabs">
    <ul>
      <li><a href="#tabs-main"><span class="ab-icon" style="background-image: url('<v:image-link name="profile.png" size="16"/>')"></span>&nbsp;<v:itl key="@Common.Profile"/></a></li>
    </ul>
    <div id="tabs-main"><jsp:include page="action_dialog_tab_main.jsp"/></div>
  </div>


<script>

$(document).ready(function() {
  $("#tabs").tabs();
  
  var dlg = $("#action_dialog");
  dlg.dialog({
    buttons: {
      <v:itl key="@Common.Save" encode="JS"/>: doSaveAction,
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    }
  });

  function doSaveAction() {
    var reqDO = {
      Command: "Save",
      Save: {
        Action: {
          ActionId: <%=action.ActionId.getJsString()%>,
          EntityType: <%=action.EntityType.getInt()%>,
          ActionStatus: $("#action\\.ActionStatus").val(),
          ActionName: $("#action\\.ActionName").val(),
          CreateDateTime: $("#action\\.CreateDateTime-picker").getXMLDateTime(),
          CloseDateTime: $("#action\\.CloseDateTime-picker").getXMLDateTime(),
          LinkList: []
        }
      }
    };
    
    var assignee = $("#assignee").vcombo_getSelItem();
    if (assignee) {
      reqDO.Save.Action.LinkList.push({
        ActionLinkType: <%=LkSNActionLinkType.Assignee.getCode()%>,
        EntityType: <%=LkSNEntityType.Person.getCode()%>,
        EntityId: assignee.ItemId
      });
    }
    
    vgsService("Action", reqDO, false, function(ansDO) {
      $(document).trigger("OnSchedulerChange");
      dlg.dialog("close");
    });
  }
});

</script>
</v:dialog>


