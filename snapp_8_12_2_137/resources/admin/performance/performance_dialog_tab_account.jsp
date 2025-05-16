<%@page import="com.vgs.vcl.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="perf" class="com.vgs.snapp.dataobject.DOPerformance" scope="request"/>

<div class="tab-toolbar">
  <v:button caption="@Common.Search" fa="search" onclick="doPerfAccountSearch()"/>
  <v:button caption="@Common.SendNotification" fa="envelope" onclick="doPerfAccountNotification()"/>
  
  <v:pagebox gridId="perf-account-grid"/>
</div>

<div class="tab-content">
  <% 
  /* UGO: EntityType filter does not make sense in this context, but it's (as for now) mandatory in account_grid.jsp. 
     We don't have time now to fix it (development done just for a demo). */ 
  %>
  <% String params = "PerformanceId=" + perf.PerformanceId.getString() + "&EntityType=" + LkSNEntityType.Person.getCode(); %>
  <v:async-grid id="perf-account-grid" jsp="account/account_grid.jsp" params="<%=params%>" />   
</div>

<script>
function doPerfAccountSearch() {
  changeGridPage("#perf-account-grid", "first");
}

function doPerfAccountNotification() {
  var $dlg = $("#dlg-perf-account-notify-template");
  $dlg.dialog({
    title: "Select template",
    width: 640,
    buttons: [
      {
        text: itl("@Common.Ok"),
        click: _doSendNotification
      },
      {
        text: itl("@Common.Cancel"),
        click: doCloseDialog
      }
    ]
  });
  
  function _doSendNotification() {
    $dlg.dialog("close");
    
    var reqDO = {
      Command: "SendAccountNotification",
      SendAccountNotification: {
        QueryBase64: $("#perf-account-grid .grid-content").attr("data-querybase64"),
        DocTemplate: {DocTemplateId: $dlg.find("#AccountNotifyDocTemplateId").val()},
        Performance: {PerformanceId: <%=JvString.jsString(pageBase.getId())%>}
      }
    };
    
    showWaitGlass();
    vgsService("Account", reqDO, false, function() {
      hideWaitGlass();
      showMessage("Notification sent!");
    })
  }
}
</script>

<div class="hidden">
  <div id="dlg-perf-account-notify-template"> 
    <v:form-field caption="@DocTemplate.DocTemplate">
      <v:combobox id="AccountNotifyDocTemplateId" lookupDataSet="<%=pageBase.getBL(BLBO_DocTemplate.class).getDocTemplateDS(LkSNDocTemplateType.AccountNotification)%>" captionFieldName="DocTemplateName" idFieldName="DocTemplateId" allowNull="false"/>
    </v:form-field>
  </div>
</div>