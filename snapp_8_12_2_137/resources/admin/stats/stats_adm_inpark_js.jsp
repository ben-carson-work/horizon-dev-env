<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.bko.page.PageBO_StatsAdmInPark" scope="request"/>
<jsp:useBean id="data" class="com.vgs.web.dataobject.DOGeneralActivity" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
  DOCmd_Stats.DORequest.DOAdmInParkRequest reqDO = pageBase.getBL(BLBO_UserFilter.class).findUserFilter(DOCmd_Stats.DORequest.DOAdmInParkRequest.class);

JvDateTime fiscalDate = pageBase.getFiscalDate();
String locationId = null;
String[] accessAreaIDs = null;
String compareType = null;
String entryRot = ((reqDO != null) && reqDO.EntryAsRotation.getBoolean()) ? "rot" : "rdm";
String exitRot = ((reqDO != null) && reqDO.ExitAsRotation.getBoolean()) ? "rot" : "rdm";

if (reqDO != null) {
  compareType = reqDO.CompareType.getString();
  locationId = reqDO.LocationId.getString();
  accessAreaIDs = reqDO.AccessAreaId.getArray();
}

if (compareType == null)
  compareType = "auto";

if (locationId == null)
  locationId = rights.MasterLocationId.isNull(pageBase.getSession().getLocationId());
%>

<script>

$(document).ready(function() {
  $("#btnset-match .btn[data-value=" + <%=JvString.jsString(compareType)%> + "]").addClass("active");
  $("#btnset-entry .btn[data-value=" + <%=JvString.jsString(entryRot)%> + "]").addClass("active");
  $("#btnset-exit .btn[data-value=" + <%=JvString.jsString(exitRot)%> + "]").addClass("active");

  $("#FiscalDate-picker").datepicker("setDate", xmlToDate(<%=JvString.jsString(fiscalDate.getXMLDate())%>)).on("input change", doApply);

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

  var locationId = <%=JvString.jsString(locationId)%>;
  if (location != null)
    $("#LocationId").val(locationId);
  else
    doApply();
});

function enableDisable() {
  var fiscalDate = $("#FiscalDate-picker").datepicker("getDate");
  var compare = $("#btnset-match .btn.active").attr("data-value");
  var compareDate;
  if (compare == "auto") 
    compareDate = new Date(fiscalDate.getFullYear(), fiscalDate.getMonth(), fiscalDate.getDate() - 1); 
  if (compare == "week") 
    compareDate = new Date(fiscalDate.getFullYear(), fiscalDate.getMonth(), fiscalDate.getDate() - 7); 
  else if (compare == "year") 
    compareDate = new Date(fiscalDate.getFullYear() - 1, fiscalDate.getMonth(), fiscalDate.getDate()); 
  $("#CompareDate-picker").datepicker("setDate", compareDate).datepicker("disable");
}

function doApply() {
  showWaitGlass();
  enableDisable();
  
  var reqDO = {
    Command: "AdmInPark",
    AdmInPark: {
      FiscalDate: $("#FiscalDate-picker").getXMLDate(),
      CompareDate: $("#CompareDate-picker").getXMLDate(),
      LocationId: getStringParam("#LocationId"),
      AccessAreaId: getStringParam("#AccessAreaId"),
      EntryAsRotation: $("#btnset-entry .btn.active").attr("data-value") == "rot",
      ExitAsRotation: $("#btnset-exit .btn.active").attr("data-value") == "rot",
      CompareType: $("#btnset-match .btn.active").attr("data-value")
    }
  };
  
  vgsService("Stats", reqDO, false, function(ansDO) {
    hideWaitGlass();
    var admInPark = {};
    if ((ansDO) && (ansDO.Answer) && (ansDO.Answer.AdmInPark))
      admInPark = ansDO.Answer.AdmInPark.AdmInPark;

    admInPark.TimeList = (admInPark.TimeList) ? admInPark.TimeList : [];
    admInPark.TimeList.forEach(function(item, index) {
      item.Timestamp = item.TimeSlot.replace("T", " ").substring(0, 16);
      item.CurrQtyExitNEG = item.CurrQtyExit * -1;
      item.PrevQtyExitNEG = item.PrevQtyExit * -1;
    });
    
    admInPark.CurrTimeSlotStart = admInPark.CurrTimeSlot.replace("T", " ").substring(0, 16);
    admInPark.CurrTimeSlotEnd = xmlToDate(admInPark.CurrTimeSlotStart);
    admInPark.CurrTimeSlotEnd.setMinutes(admInPark.CurrTimeSlotEnd.getMinutes() + 15);
    admInPark.CurrTimeSlotEnd = dateToXML(admInPark.CurrTimeSlotEnd).replace("T", " ").substring(0, 16);
    
    var cts = admInPark.CurrTimeSlotEnd.substring(11);
    $("#entry-stat-boxes").empty()
      .append(createStatBox(itl("@Stats.InPark") + " — " + cts, admInPark.CurrQtyInPark, admInPark.PrevQtyInPark, "col-lg-4 col-md-6"))
      .append(createStatBox(itl("@Common.Entries") + " — " + cts, admInPark.CurrQtyEntry, admInPark.PrevQtyEntry, "col-lg-4 col-md-6"))
      .append(createStatBox(itl("@Common.Exits") + " — " + cts, admInPark.CurrQtyExit, admInPark.PrevQtyExit, "col-lg-4 col-md-6"))
    

    renderInParkChart(admInPark);
    renderEntryChart(admInPark);
  });
}

function renderInParkChart(admInPark) {
  AmCharts.makeChart("inpark-chart", {
    "language": graphLang,
    "type": "serial",
    "theme": "light",
    "marginRight":30,
    "dataDateFormat": "YYYY-MM-DD JJ:NN",
    "dataProvider": admInPark.TimeList,
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
      "position": "left",
      "precision": 0,
      "title": itl("@Stats.InPark")
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
      "title": itl("@Stats.CurrentInterval"),
      "lineColor": getComputedStyle(document.body).getPropertyValue("--base-blue-color"),
      "fillAlphas": 0.1,
      "lineAlpha": 1,
      "useLineColorForBulletBorder": true,
      "valueField": "CurrQtyInPark",
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
      "title": itl("@Stats.PreviousInterval"),
      "lineColor": getComputedStyle(document.body).getPropertyValue("--base-orange-color"),
      "lineAlpha": 1,
      "useLineColorForBulletBorder": true,
      "valueField": "PrevQtyInPark",
      "stackable": false,
      "balloonText": "<span style='font-size:18px;'>[[value]]</span>"
    }],
    "chartCursor": {
      "cursorAlpha": 0,
      "categoryBalloonDateFormat": "JJ:NN"
    },
    "categoryAxis": {
      "parseDates": true,
      "minPeriod": "15mm",
      "startOnAxis": true,
      "axisColor": "#DADADA",
      "gridAlpha": 0.07,
      "guides": [{
        "date": admInPark.CurrTimeSlotStart,
        "toDate": admInPark.CurrTimeSlotEnd,
        "lineColor": getComputedStyle(document.body).getPropertyValue("--base-gray-color"),
        "lineAlpha": 1,
        "fillColor": getComputedStyle(document.body).getPropertyValue("--base-gray-color"),
        "fillAlpha": 0.4,
        "dashLength": 2,
        "inside": true,
        "labelRotation": 90
      }]
    }
  });
}

function renderEntryChart(admInPark) {
  AmCharts.makeChart("entry-chart", {
    "language": graphLang,
    "type": "serial",
    "theme": "light",
    "marginRight":30,
    "dataDateFormat": "YYYY-MM-DD JJ:NN",
    "dataProvider": admInPark.TimeList,
    "categoryField": "Timestamp",
    "plotAreaBorderAlpha": 0,
    "marginTop": 10,
    "marginLeft": 0,
    "marginBottom": 0,
    "columnSpacing": 0,
    "columnWidth": 0.9,
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
      "position": "left",
      "precision": 0,
      "title": itl("@Common.Exits") + " / " + itl("@Common.Entries")
    }],
    "balloon": {
      "borderThickness": 1,
      "shadowAlpha": 0
    },
    "graphs": [
      {
        "balloonText": "<b>[[CurrQtyEntry]]</b> " + $("<div/>").text(itl("@Common.Entries").toLowerCase()).html(),
        "lineColor": getComputedStyle(document.body).getPropertyValue("--base-green-color"),
        "fillAlphas": 1.0,
        "lineAlpha": 0,
        "type": "column",
        "valueField": "CurrQtyEntry",
        "title": itl("@Stats.CurrentInterval") + " [" + itl("@Common.Entries").toLowerCase() + "]"
      },
      {
        "balloonText": "<b>[[CurrQtyExit]]</b> " + $("<div/>").text(itl("@Common.Exits").toLowerCase()).html(),
        "legendValueText": "[[CurrQtyExit]]",
        "lineColor": getComputedStyle(document.body).getPropertyValue("--base-green-color"),
        "fillAlphas": 1,
        "lineAlpha": 0,
        "type": "column",
        "valueField": "CurrQtyExitNEG",
        "title": itl("@Stats.CurrentInterval") + " [" + itl("@Common.Exits").toLowerCase() + "]"
      },
      {
        "newStack": true,
        "balloonText": "<b>[[PrevQtyEntry]]</b> " + $("<div/>").text(itl("@Common.Entries").toLowerCase()).html(),
        "lineColor": getComputedStyle(document.body).getPropertyValue("--base-green-color"),
        "fillAlphas": 0.4,
        "lineAlpha": 0,
        "type": "column",
        "valueField": "PrevQtyEntry",
        "title": itl("@Stats.PreviousInterval") + " [" + itl("@Common.Entries").toLowerCase() + "]"
      },
      {
        "balloonText": "<b>[[PrevQtyExit]]</b> " + $("<div/>").text(itl("@Common.Exits").toLowerCase()).html(),
        "legendValueText": "[[PrevQtyExit]]",
        "lineColor": getComputedStyle(document.body).getPropertyValue("--base-red-color"),
        "fillAlphas": 0.4,
        "lineAlpha": 0,
        "type": "column",
        "valueField": "PrevQtyExitNEG",
        "title": itl("@Stats.PreviousInterval") + " [" + itl("@Common.Exits").toLowerCase() + "]"
      }
    ],
    "chartCursor": {
      "cursorAlpha": 0,
      "categoryBalloonDateFormat": "JJ:NN"
    },
    "categoryAxis": {
      "parseDates": true,
      "minPeriod": "15mm",
      "gridPosition": "start",
      "gridAlpha": 0,
      "tickPosition": "start"
    },
    "guides": [{
      "date": admInPark.CurrTimeSlotStart,
      "toDate": admInPark.CurrTimeSlotEnd,
      "lineColor": getComputedStyle(document.body).getPropertyValue("--base-gray-color"),
      "lineAlpha": 1,
      "fillColor": getComputedStyle(document.body).getPropertyValue("--base-gray-color"),
      "fillAlpha": 0.4,
      "dashLength": 2,
      "inside": true,
      "labelRotation": 90
    }]
  });
}

</script>
