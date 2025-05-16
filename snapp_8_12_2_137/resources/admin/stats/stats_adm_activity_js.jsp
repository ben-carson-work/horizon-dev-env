<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.bko.page.PageBO_StatsAdmActivity" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
  JvDateTime dateFrom = null;
JvDateTime dateTo = null;
LookupItem grouping = null;
String locationId = null;
String[] accessAreaIDs = null;
LookupItem interval = null;
String compareType = null;
//pageBase.setDefaultParameter("DateFrom", pageBase.getFiscalDate().getXMLDate());
//pageBase.setDefaultParameter("DateTo", pageBase.getFiscalDate().getXMLDate());


DOCmd_Stats.DORequest.DOAdmActivityRequest reqDO = pageBase.getBL(BLBO_UserFilter.class).findUserFilter(DOCmd_Stats.DORequest.DOAdmActivityRequest.class);
if (reqDO != null) {
  interval = reqDO.Interval.getLkValue();
  grouping = reqDO.Grouping.getLkValue();
  compareType = reqDO.CompareType.getString();
  locationId = reqDO.LocationId.getString();
  accessAreaIDs = reqDO.AccessAreaId.getArray();
}

if (interval == null)
  interval = LkStatInterval.Last30d;

if (interval.isLookup(LkStatInterval.Custom)) {
  if (reqDO != null) {
    dateFrom = reqDO.DateFrom.getDateTime();
    dateTo = reqDO.DateTo.getDateTime();
  }
  if (dateFrom == null)
    dateFrom = pageBase.getFiscalDate();
  if (dateTo == null)
    dateTo = dateFrom;
}

if (compareType == null)
  compareType = "auto";

if (grouping == null)
  grouping = LkStatGrouping.Week;

if (locationId == null)
  locationId = rights.MasterLocationId.isNull(pageBase.getSession().getLocationId());
%>

<script>

$(document).ready(function() {
  $("#StatInterval").val(<%=interval.getCode()%>);
  <% if (interval.isLookup(LkStatInterval.Custom)) { %>
    $("#DateFrom-picker").datepicker("setDate", xmlToDate(<%=JvString.jsString(dateFrom.getXMLDate())%>));
    $("#DateTo-picker").datepicker("setDate", xmlToDate(<%=JvString.jsString(dateTo.getXMLDate())%>));
  <% } else { %>
    recalcInterval();
  <% } %>
  
  $("#btnset-grouping .btn[data-value=" + <%=grouping.getCode()%> + "]").addClass("active");
  $("#btnset-match .btn[data-value=" + <%=JvString.jsString(compareType)%> + "]").addClass("active");

  $("#DateFrom-picker").datepicker().on("input change", doApply);
  $("#DateTo-picker").datepicker().on("input change", doApply);

  $(".btn-group .btn").click(function() {
    var $this = $(this);
    $this.closest(".btn-group").find(".btn").removeClass("active");
    $this.addClass("active");
    doApply();
  });
  
  var multiAcArea = $("#AccessAreaId").selectize({
    dropdownParent: "body",
    closeAfterSelect: true,
    plugins: ['remove_button','drag_drop'],
    onChange: function() {
      multiAcArea.blur();
      doApply();
    }
  })[0].selectize;

  var firstRun = true; 
  $("#LocationId").change(function() {
    $("#AccessAreaId").addClass("disabled");
    var reqDO = {
      EntityType: <%=LkSNEntityType.AccessArea.getCode()%>,
      AncestorEntityType: <%=LkSNEntityType.Location.getCode()%>,
      AncestorId: $("#LocationId").val(),
      PagePos: 1,
      RecordPerPage: 10000
    };
    vgsService("FullTextLookup", reqDO, true, function(ansDO) {
      $("#AccessAreaId").removeClass("disabled");
      multiAcArea.clearOptions();
      if ((ansDO) && (ansDO.Answer) && (ansDO.Answer.ItemList)) {
        var list = ansDO.Answer.ItemList;
        for (var i=0; i<list.length; i++)
          multiAcArea.addOption({value:list[i].ItemId, text:list[i].ItemName});
        multiAcArea.refreshOptions(false);
        if (firstRun) {
          firstRun = false;
          var values = [<%=JvArray.arrayToString(accessAreaIDs, ",", "'")%>];
          if (values.length == 0)
            doApply();
          else
            multiAcArea.setValue(values);
        }
        else
          doApply();
      }
    });
  });

  $("#StatInterval").change(function() {
    recalcInterval();
    doApply();
  });

  var locationId = <%=JvString.jsString(locationId)%>;
  if (location != null)
    $("#LocationId").val(locationId);
  else
    doApply();
});

function recalcInterval() {
  var now = new Date();
  var y = now.getFullYear(); 
  var m = now.getMonth(); 
  var d = now.getDate();
  var today = new Date(y, m, d);
  var dateFrom = new Date(y, m, d);
  var dateTo = new Date(y, m, d);
  var value = parseInt($("#StatInterval").val());
  if (value == <%=LkStatInterval.Yesterday.getCode()%>) {
    dateFrom.setDate(today.getDate() - 1);
    dateTo.setDate(today.getDate() - 1);
  }
  else if (value == <%=LkStatInterval.LastWeek.getCode()%>) {
    var fd = today.getDate() - today.getDay();
    dateFrom.setDate(fd);
    dateTo.setDate(fd + 6);
  }
  else if (value == <%=LkStatInterval.LastMonth.getCode()%>) {
    dateFrom = new Date(y, m-1, 1);
    dateTo = new Date(y, m, 0);
  }
  else if (value == <%=LkStatInterval.LastYear.getCode()%>) {
    dateFrom = new Date(y-1, 0, 1);
    dateTo = new Date(y-1, 11, 31);
  }
  else if (value == <%=LkStatInterval.Last7d.getCode()%>) {
    dateFrom.setDate(today.getDate() - 7);
    dateTo.setDate(today.getDate() - 1);
  }
  else if (value == <%=LkStatInterval.Last30d.getCode()%>) {
    dateFrom.setDate(today.getDate() - 30);
    dateTo.setDate(today.getDate() - 1);
  }
  else if (value == <%=LkStatInterval.YTD.getCode()%>) {
    dateFrom = new Date(y, 0, 1);
  }

  $("#DateFrom-picker").datepicker("setDate", dateFrom);
  $("#DateTo-picker").datepicker("setDate", dateTo);
}

function enableDisable() {
  var disabled = (parseInt($("#StatInterval").val()) != <%=LkStatInterval.Custom.getCode()%>);
  $("#custom-date-table").setClass("disabled", disabled);
  $("#DateFrom-picker").datepicker(disabled ? "disable" : "enable");
  $("#DateTo-picker").datepicker(disabled ? "disable" : "enable");

  var dateFrom = $("#DateFrom-picker").datepicker("getDate");
  var dateTo = $("#DateTo-picker").datepicker("getDate");
  var msday = 1000*60*60*24;
  var days = 1 + Math.round(Math.abs(dateTo.getTime() - dateFrom.getTime()) / msday);
  $("#btn-grouping-<%=LkStatGrouping.Slot15.getCode()%>").setEnabled(days <= 1);
  $("#btn-grouping-<%=LkStatGrouping.Hour.getCode()%>").setEnabled(days <= 2);
  $("#btn-grouping-<%=LkStatGrouping.Day.getCode()%>").setEnabled(days <= 31);
  $("#btn-grouping-<%=LkStatGrouping.Week.getCode()%>").setEnabled(days <= 366);
  
  var radios = $("#btnset-grouping .btn");
  if (!radios.filter(".active").isEnabled()) {
    radios.removeClass("active");
    for (var i=0; i<radios.length; i++) {
      var radio = $(radios[i]);
      if (radio.isEnabled()) {
        radio.addClass("active");
        break;
      }
    }
  }
  
  var compare = $("#btnset-match .btn.active").attr("data-value");
  var compareDateFrom;
  var compareDateTo;
  if (compare == "auto") {
    compareDateFrom = new Date(dateFrom.getFullYear(), dateFrom.getMonth(), dateFrom.getDate() - days); 
    compareDateTo = new Date(dateTo.getFullYear(), dateTo.getMonth(), dateTo.getDate() - days);
  }
  if (compare == "week") {
    compareDateFrom = new Date(dateFrom.getFullYear(), dateFrom.getMonth(), dateFrom.getDate() - 7); 
    compareDateTo = new Date(dateTo.getFullYear(), dateTo.getMonth(), dateTo.getDate() - 7);
  }
  else if (compare == "year") {
    compareDateFrom = new Date(dateFrom.getFullYear() - 1, dateFrom.getMonth(), dateFrom.getDate()); 
    compareDateTo = new Date(dateTo.getFullYear() - 1, dateTo.getMonth(), dateTo.getDate());
  }
  $("#CompareDateFrom-picker").datepicker("setDate", compareDateFrom).datepicker("disable");
  $("#CompareDateTo-picker").datepicker("setDate", compareDateTo).datepicker("disable");
}

function doApply() {
  showWaitGlass();
  enableDisable();
  
  var reqDO = {
    Command: "AdmActivity",
    AdmActivity: {
      DateFrom: $("#DateFrom-picker").getXMLDate(),
      DateTo: $("#DateTo-picker").getXMLDate(),
      CompareDateFrom: $("#CompareDateFrom-picker").getXMLDate(),
      CompareDateTo: $("#CompareDateTo-picker").getXMLDate(),
      LocationId: getStringParam("#LocationId"),
      AccessAreaId: getStringParam("#AccessAreaId"),
      Grouping: $("#btnset-grouping .btn.active").attr("data-value"),
      Interval: $("#StatInterval").val(),
      CompareType: $("#btnset-match .btn.active").attr("data-value")
    }
  };
  
  vgsService("Stats", reqDO, false, function(ansDO) {
    hideWaitGlass();
    var admActivity = {};
    if ((ansDO) && (ansDO.Answer) && (ansDO.Answer.AdmActivity))
      admActivity = ansDO.Answer.AdmActivity.AdmActivity;
    
    $("#entry-stat-boxes").empty()
      .append(createStatBox(<v:itl key="@Common.Total" encode="JS"/>, admActivity.CurrQuantity, admActivity.PrevQuantity, "col-lg-3 col-md-6"))
      .append(createStatBox(<v:itl key="@Entitlement.Entries" encode="JS"/>, admActivity.CurrQtyEntry, admActivity.PrevQtyEntry, "col-lg-3 col-md-6"))
      .append(createStatBox(<v:itl key="@Entitlement.Crossovers" encode="JS"/>, admActivity.CurrQtyCrossover, admActivity.PrevQtyCrossover, "col-lg-3 col-md-6"))
      .append(createStatBox(<v:itl key="@Entitlement.ReEntries" encode="JS"/>, admActivity.CurrQtyReentry, admActivity.PrevQtyReentry, "col-lg-3 col-md-6"));

    renderSlotChart(admActivity);
    renderItemsTable($("#product-grid tbody"), admActivity.ProductList, admActivity.CurrQuantity, admActivity.PrevQuantity, admActivity.CurrQuantity, admActivity.PrevQuantity, "CurrQuantity", "PrevQuantity", "IconName", "ProfilePictureId", "ProductName", "ProductCode", "ProductId", <%=LkSNEntityType.ProductType.getCode()%>, false, false);
    renderItemsTable($("#event-grid  tbody"), admActivity.EventList, admActivity.CurrQuantity, admActivity.PrevQuantity, admActivity.CurrQuantity, admActivity.PrevQuantity, "CurrQuantity", "PrevQuantity", "IconName", "ProfilePictureId", "EventName", "EventCode", "EventId", <%=LkSNEntityType.Event.getCode()%>, false, false);
  });
}

function renderSlotChart(admActivity) {
  var data = (admActivity.OverviewList) ? admActivity.OverviewList : [];
  data.forEach(function(item, index) {
    item.Timestamp = item.TimeSlot.replace("T", " ").substring(0, 16);
  });
  
  var grouping = parseInt($("#btnset-grouping .btn.active").attr("data-value"));

  var minPeriod = "DD";
  if (grouping == <%=LkStatGrouping.Slot15.getCode()%>) 
    minPeriod = "15mm";
  else if (grouping == <%=LkStatGrouping.Hour.getCode()%>) 
    minPeriod = "hh";
  else if (grouping == <%=LkStatGrouping.Month.getCode()%>) 
    minPeriod = "MM";

  var balloonDateFormat = "MMM DD, YYYY";
  if ((grouping == <%=LkStatGrouping.Slot15.getCode()%>) || (grouping == <%=LkStatGrouping.Hour.getCode()%>))
    balloonDateFormat = "MMM DD, YYYY - JJ:NN";
  else if (grouping == <%=LkStatGrouping.Month.getCode()%>)
    balloonDateFormat = "MMM, YYYY";

  AmCharts.makeChart("entry-chart", {
    "language": graphLang,
    "type": "serial",
    "theme": "light",
    "marginRight":30,
    "dataDateFormat": "YYYY-MM-DD JJ:NN",
    "dataProvider": data,
    "categoryField": "Timestamp",
    "plotAreaBorderAlpha": 0,
    "marginTop": 10,
    "marginLeft": 0,
    "marginBottom": 0,
    "legend": {
      "equalWidths": false,
      "periodValueText": "total: [[value.sum]]",
      "position": "top",
      "valueAlign": "left",
      "valueWidth": 100
    },
    "valueAxes": [{
      "stackType": "regular",
      "gridAlpha": 0.07,
      "position": "left"
    }],
    "balloon": {
      "borderThickness": 1,
      "shadowAlpha": 0
    },
    "graphs": [{
      "id": "g1",
      "type": "line",
      "balloon":{
        "drop":true,
        "adjustBorderColor":false,
        "color":"#ffffff"
      },
      "bullet": "round",
      "bulletBorderAlpha": 1,
      "bulletColor": "#FFFFFF",
      "bulletSize": 8,
      "hideBulletsCount": 50,
      "lineThickness": 4,
      "title": <v:itl key="@Stats.CurrentInterval" encode="JS"/>,
      "lineColor": getComputedStyle(document.body).getPropertyValue("--base-blue-color"),
      "fillAlphas": 0.1,
      "lineAlpha": 1,
      "useLineColorForBulletBorder": true,
      "valueField": "CurrQuantity",
      "stackable": false,
      "balloonText": "<span style='font-size:18px;'>[[value]]</span>"
    },
    {
      "id": "g2",
      "type": "line",
      "balloon":{
        "drop":true,
        "adjustBorderColor":false,
        "color":"#ffffff"
      },
      "bullet": "round",
      "bulletBorderAlpha": 1,
      "bulletColor": "#FFFFFF",
      "bulletSize": 8,
      "hideBulletsCount": 50,
      "lineThickness": 4,
      "title": <v:itl key="@Stats.PreviousInterval" encode="JS"/>,
      "lineColor": getComputedStyle(document.body).getPropertyValue("--base-orange-color"),
      "lineAlpha": 1,
      "useLineColorForBulletBorder": true,
      "valueField": "PrevQuantity",
      "stackable": false,
      "balloonText": "<span style='font-size:18px;'>[[value]]</span>"
    }],
    "chartScrollbar": {},
    "chartCursor": {
      "cursorAlpha": 0,
      "categoryBalloonDateFormat": balloonDateFormat
    },
    "categoryAxis": {
      "parseDates": true,
      "minPeriod": minPeriod,
      "startOnAxis": true,
      "axisColor": "#DADADA",
      "gridAlpha": 0.07
    },
    "export": {
      "enabled": true
     }
  });
}

</script>
