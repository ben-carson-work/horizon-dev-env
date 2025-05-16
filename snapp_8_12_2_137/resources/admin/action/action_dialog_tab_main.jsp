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
<jsp:useBean id="action" class="com.vgs.snapp.dataobject.DOAction" scope="request"/>

<%
DOAction.DOActionLink assignee = null;
for (DOAction.DOActionLink link : action.LinkList.getItems()) {
  if (link.ActionLinkType.isLookup(LkSNActionLinkType.Assignee)) {
    assignee = link;
    break;
  }
}
%>


<div class="tab-content">

  <v:widget caption="@Performance.Schedule">
    <v:widget-block>
      <v:form-field caption="@Common.Name">
        <v:input-text field="action.ActionName" />
      </v:form-field>
      <v:form-field caption="@Common.Status">
        <v:lk-combobox lookup="<%=LkSN.ActionStatus%>" field="action.ActionStatus"/>
      </v:form-field>
      <v:form-field caption="@Performance.StartTime">
        <v:input-text type="datetimepicker" field="action.CreateDateTime" />
      </v:form-field>
      <v:form-field caption="@Performance.EndTime">
        <v:input-text type="datetimepicker" field="action.CloseDateTime" />
      </v:form-field>
      <v:form-field caption="@Action.Assignee">
        <div id="assignee">
      </v:form-field>
    </v:widget-block>
  </v:widget>

</div>


<script>

$(document).ready(function() {
  $("#assignee").vcombo({
    EntityType: <%=LkSNEntityType.Person.getCode()%>
  });
  <% if (assignee != null) { %>
    $("#assignee").vcombo_setSelItem({
      ItemId: <%=assignee.EntityId.getJsString()%>,
      ItemCode: <%=assignee.EntityCode.getJsString()%>,
      ItemName: <%=assignee.EntityName.getJsString()%>,
      IconName: <%=assignee.EntityIconName.getJsString()%>,
      ProfilePictureId: <%=assignee.EntityProfilePictureId.getJsString()%>
    });
  <% } %>
});

</script>
