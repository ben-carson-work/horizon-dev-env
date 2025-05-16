<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% boolean canEdit = rights.SettingsITSettings.getBoolean(); %>

<%
BLBO_Session bl = pageBase.getBL(BLBO_Session.class);
DOSessionPool pool = pageBase.isNewItem() ? bl.prepareNewSessionPool() : bl.loadSessionPool(pageBase.getId()); 
String title = pageBase.isNewItem() ? pageBase.getLang().Common.SessionPool.getText() : pool.SessionPoolName.getString();
request.setAttribute("pool", pool);
%>

<v:dialog id="sessionpool_dialog" icon="sessionpool.png" title="@Common.SessionPool" width="750" height="750" autofocus="false">

<v:widget caption="@Common.Profile" icon="profile.png">
  <v:widget-block>
    <v:form-field caption="@Common.Type">
      <label class="checkbox-label"><input type="radio" name="pool.WorkstationType" value="<%=LkSNWorkstationType.BKO.getCode()%>"/> <%=LkSNWorkstationType.BKO.getHtmlDescription(pageBase.getLang())%></label>
      &nbsp;&nbsp;
      <label class="checkbox-label"><input type="radio" name="pool.WorkstationType" value="<%=LkSNWorkstationType.B2B.getCode()%>"/> <%=LkSNWorkstationType.B2B.getHtmlDescription(pageBase.getLang())%></label>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="@Common.Name">
      <v:input-text field="pool.SessionPoolName" enabled="<%=canEdit%>"/>
    </v:form-field>
    <v:form-field caption="@Common.Quantity">
      <v:input-text field="pool.Quantity" enabled="<%=canEdit%>"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<% if (!pageBase.isNewItem()) { %>
  <% String params = "SessionPoolId=" + pool.SessionPoolId.getString() + "&WorkstationType=" + pool.WorkstationType.getInt(); %>
  <v:pagebox gridId="session-grid"/>
  <v:async-grid id="session-grid" jsp="session_grid.jsp" params="<%=params%>" />
<% } %>

<script>

$(document).ready(function() {
  var dlg = $("#sessionpool_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        text: <v:itl key="@Common.Save" encode="JS"/>,
        disabled: <%=!canEdit%>,
        click: doSaveSessionPool
      }, 
      {
        text: <v:itl key="@Common.Cancel" encode="JS"/>,
        click: doCloseDialog
      }                     
    ];
  });
  
  $("[name='pool\\.WorkstationType'][value='<%=pool.WorkstationType.getInt()%>']").setChecked(true);
});

function doSaveSessionPool() {
  var reqDO = {
    Command: "SaveSessionPool",
    SaveSessionPool: {
      SessionPool: {
        SessionPoolId: <%=pool.SessionPoolId.isNull() ? "null" : "\"" + pool.SessionPoolId.getHtmlString() + "\""%>,
        SessionPoolName: $("#pool\\.SessionPoolName").val(),
        Quantity: $("#pool\\.Quantity").val(),
        WorkstationType: $("[name='pool\\.WorkstationType']:checked").val()
      }
    }
  };
  
  vgsService("session", reqDO, false, function(ansDO) {
    triggerEntityChange(<%=LkSNEntityType.SessionPool.getCode()%>);
    $("#sessionpool_dialog").dialog("close");
  });
}

</script>

</v:dialog>