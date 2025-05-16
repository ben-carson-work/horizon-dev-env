<%@page import="com.vgs.web.library.event.*"%>
<%@page import="com.vgs.snapp.api.performance.*"%>
<%@page import="com.vgs.snapp.library.*"%>
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
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
String performanceId = pageBase.isNewItem() ? null : pageBase.getId();
String eventId = pageBase.getNullParameter("EventId");
String locationId = pageBase.getNullParameter("LocationId");
JvDateTime dateTimeFrom = (pageBase.getNullParameter("DateTimeFrom") == null) ? JvDateTime.now() : JvDateTime.createByXML(pageBase.getNullParameter("DateTimeFrom"));
String[] resourceIDs = (pageBase.getNullParameter("ResourceId") == null) ? new String[0] : JvArray.stringToArray(pageBase.getNullParameter("ResourceId"), ",");
boolean xpi = pageBase.isParameter("XPI", "true");

UIBO_PerformanceDialog ui = new UIBO_PerformanceDialog(pageBase.getConnector(), performanceId, eventId, locationId, dateTimeFrom, resourceIDs, xpi); 
request.setAttribute("perf", ui.performance);
%>

<v:dialog id="performance_dialog" tabsView="true" title="<%=ui.title%>" width="900" height="700" autofocus="false">
  <v:tab-group name="tab" main="true">
    <v:tab-item-embedded tab="tabs-main" caption="@Common.Profile" icon="profile.png" default="true">
      <jsp:include page="performance_dialog_tab_main.jsp"/>
    </v:tab-item-embedded>
  
    <v:tab-item-embedded tab="tabs-admission" caption="@Performance.Admission" icon="accessarea.png">
      <jsp:include page="performance_dialog_tab_admission.jsp"/>
    </v:tab-item-embedded>
  
    <v:tab-item-embedded tab="tabs-resource" caption="@Resource.ResourceManagement" icon="<%=LkSNEntityType.ResourceType.getIconName()%>" include="<%=ui.showTabResource%>">
      <jsp:include page="performance_dialog_tab_resource.jsp"/>
    </v:tab-item-embedded>

    <v:tab-item-embedded tab="tabs-seat" caption="@Seat.LimitedCapacity" icon="<%=LkSNEntityType.SeatMap.getIconName()%>" include="<%=ui.showTabSeat%>">
      <jsp:include page="performance_dialog_tab_seat.jsp">
        <jsp:param value="<%=!ui.canEdit%>" name="readonly"/>
      </jsp:include>
    </v:tab-item-embedded>

    <v:tab-item-embedded tab="tabs-account" caption="@Account.Accounts" icon="account_prs.png" include="<%=ui.showTabAccount%>">
      <jsp:include page="performance_dialog_tab_account.jsp"/>
    </v:tab-item-embedded>

    <v:tab-item-embedded tab="tabs-portfolio" caption="@Common.Portfolios" icon="account_prs.png" include="<%=ui.showTabPortfolio%>">
      <jsp:include page="performance_dialog_tab_portfolio.jsp"/>
    </v:tab-item-embedded>

    <v:tab-item-embedded tab="tabs-history" caption="@Common.History" fa="history" include="<%=ui.showTabHistory%>">
      <jsp:include page="../common/page_tab_historydetail.jsp"/>
    </v:tab-item-embedded>

    <v:tab-item-embedded tab="tabs-log" caption="@Common.Logs" icon="<%=LkSNEntityType.Log.getIconName()%>" include="<%=ui.showTabLog%>">
      <jsp:include page="../common/page_tab_logs.jsp"/>
    </v:tab-item-embedded>
  </v:tab-group>
  
<script>

$(document).ready(function() {
  var perf = <%=ui.performance.getJSONString()%>;
  var dlg = $("#performance_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      <% if (ui.canEdit) { %>
        dialogButton("@Common.Save", doSavePerformance),
      <% } %>
      dialogButton("@Common.Cancel", doCloseDialog)
    ];
  });

  function doSavePerformance() {
    var deltaPrice = dlg.find("#perf\\.DeltaPrice").val();
    var reqDO = {
      Command: "SavePerformance",
      SavePerformance: {
        Performance: {
          PerformanceId: perf.PerformanceId,
          EventId: perf.EventId,
          PerformanceName: dlg.find("#perf\\.PerformanceName").val(),
          PerformanceTypeFromCalendar: dlg.find("#perf\\.PerformanceTypeFromCalendar").isChecked(),
          DynRateCode: dlg.find("#perf\\.DynRateCode").isChecked(),
          CalendarId: dlg.find("#perf\\.CalendarId").val(),
          PerformanceTypeId: dlg.find("#perf\\.PerformanceTypeId").val(),
          RateCodeId: dlg.find("#perf\\.RateCodeId").val(),
          LocationId: dlg.find("#perf\\.LocationId").val(),
          AccessAreaId: $("#perf\\.AccessAreaId").val(),
          AdmissionOpenMins: dlg.find("#perf\\.AdmissionOpenMins").val(),
          AdmissionCloseMins: dlg.find("#perf\\.AdmissionCloseMins").val(),
          OnSaleFrom: dlg.find("#perf\\.OnSaleFrom-picker").getXMLDate(),
          OnSaleTo: dlg.find("#perf\\.OnSaleTo-picker").getXMLDate(),
          RestrictOpenOrder: dlg.find("#perf\\.RestrictOpenOrder").isChecked(),
          DeltaPrice: deltaPrice === "" ? null : deltaPrice,
          ResourceTypeList: functionExists("getResourcesForSave") ? getResourcesForSave() : [],
          TagIDs: dlg.find("#perf\\.TagIDs").val(),
          InheritFulfilmentArea: dlg.find("#perf\\.InheritFulfilmentArea").isChecked(),
          FulfilmentAreaTagId: dlg.find("[name='perf\\.FulfilmentAreaTagId']").val()
        }
      }
    };
    
    if (perf.AutoCreated !== true) {
      reqDO.SavePerformance.Performance.DateTimeFrom = dlg.find("#perf\\.DateTimeFrom-picker").getXMLDateTime();
      reqDO.SavePerformance.Performance.DateTimeTo = dlg.find("#perf\\.DateTimeTo-picker").getXMLDateTime();
      reqDO.SavePerformance.Performance.PerformanceStatus = dlg.find("#perf\\.PerformanceStatus").val();
    }
    
    vgsService("Performance", reqDO, false, function(ansDO) {
      $(document).trigger("OnSchedulerChange", ansDO.Answer.SavePerformance.PerformanceId);
      triggerEntityChange(<%=LkSNEntityType.Performance.getCode()%>, ansDO.Answer.SavePerformance.PerformanceId);
      $("#performance_dialog").dialog("close");
    });
  };

  function doOpenSiae() {
    dlg.dialog("close");
    asyncDialogEasy("siae/siae_performance_dialog", "id=" + perf.PerformanceId);
  };
});

</script>

</v:dialog>



