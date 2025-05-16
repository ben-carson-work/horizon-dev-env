<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.bko.page.PageBO_Calendar" scope="request"/>
<jsp:useBean id="cal" class="com.vgs.snapp.dataobject.DOCalendar" scope="request"/>

<script>
var cal = <%=cal.getJSONString()%>;

$(document).ready(function() {
  renderCalendar((new Date()).getFullYear());
  
  $("#cal\\.DatedCalendar").click(refreshVisibility);
  refreshVisibility();
  
  $(".snapp-calendar .cal-day").mousedown(dayMouseEvent).mouseover(dayMouseEvent);
  $(".snapp-calendar .cal-month-title").click(monthClick);
});

function refreshVisibility() {
  $("#dated-block").setClass("hidden", !$("#cal\\.DatedCalendar").isChecked());
}

function renderCalendar(year) {
  $("#current-year").text(year);
  
  var $days = $(".snapp-calendar .cal-day");
  $days.removeClass("active");
  $days.removeAttr("data-pt");
  $days.removeAttr("data-rc");
  $days.find(".cal-day-rc").remove();
  
  for (var month=1; month<=12; month++) {
    var $mdiv = $(".cal-month[data-month='" + month + "']");
    $mdiv.calMonth_SetMonth(year, month);
  }
  
  if (cal.YearList) {
    $.each(cal.YearList, function(yi, yelem) {
      if (yelem.Year == year) {
        if (yelem.MonthList) {
          $.each(yelem.MonthList, function(mi, melem) {
            if (melem.DayList) {
              $.each(melem.DayList, function(di, delem) {
                var $day = $(".cal-month[data-month='" + melem.Month + "'] .cal-day[data-dom='" + delem.Day + "']");
                $day.addClass("active");
                setDayPerformanceType($day, delem.PerformanceTypeId);
                setDayRateCode($day, delem.RateCodeId);
              });
            }
          });
        }
      }
    });
  }
}

function setDayPerformanceType($day, performanceTypeId) {
  if ((getNull(performanceTypeId) == null) || (performanceTypeId == "DEFAULT"))
    $day.removeAttr("data-pt");
  else
    $day.attr("data-pt", performanceTypeId);
}

function setDayRateCode($day, rateCodeId) {
  if ((getNull(rateCodeId) == null) || (rateCodeId == "DEFAULT")) {
    $day.removeAttr("data-rc");
    $day.find(".cal-day-rc").remove();
  } 
  else {
    $day.attr("data-rc", rateCodeId);
    $day.not(":has(.cal-day-rc)").append("<span class='cal-day-rc'></span>");
    $day.find(".cal-day-rc").html(findRateCodeHtml(rateCodeId));
  }
}

function updateYear(yearObj) {
  var found = false;
  $.each(cal.YearList, function(yi, yelem) {
    if (yelem.Year == yearObj.Year) {
      cal.YearList[yi] = yearObj;
      found = true;
    }
  });  
  
  if (!found) {
    if (!(cal.YearList))
      cal.YearList = [];
    cal.YearList.push(yearObj);
  }
}

function getCurrentYear() {
  var year = parseInt($("#current-year").text());
  if (isNaN(year))
    year = (new Date()).getFullYear();
  return year;
}

function encodeCurrentYear() {
  var result = {
    Year: getCurrentYear(),
    MonthList:[]
  };
  
  $(".cal-month").each(function(mi, month) {
    var $month = $(month);
    var data = {
      Month: $month.attr("data-month"),
      DayList: []
    } 
    
    $month.find(".cal-day").not(".other-month").each(function(dd, day) {
      var $day = $(day);
      if ($day.is(".active")) {
        data.DayList.push({
          Day: $day.attr("data-dom"),
          PerformanceTypeId: $day.attr("data-pt") ? $day.attr("data-pt") : null,
          RateCodeId: $day.attr("data-rc") ? $day.attr("data-rc") : null
        });
      }
    });
    
    if (data.DayList.length > 0)
      result.MonthList.push(data);
  });
  
  return result;
}

function changeYear(delta) {
  updateYear(encodeCurrentYear());
  renderCalendar(getCurrentYear() + delta);
}

function toolItemClick(item) {
  var $item = $(item);
  if ($item.is(".selected"))
    $item.removeClass("selected");
  else {
    var group = $item.attr("data-toolgroup");
    var $all = $(".tool-item[data-toolgroup='" + group + "']");
    $all.removeClass("selected");
    $item.addClass("selected");
  }
}

function findRateCodeCode(id) {
  if ((id) && (id != "DEFAULT"))
    return $(".tool-item[data-id='" + id + "']").attr("data-code");
  else
    return "";
}

function findRateCodeHtml(id) {
  if ((id) && (id != "DEFAULT")) {
    var $rc = $(".tool-item[data-id='" + id + "']");
    var symbol = $rc.attr("data-symbol");
    if ((symbol) && (symbol != ""))
      return "<i class='fa fa-" + symbol + "'></i>";
    else
      return $rc.attr("data-code");
  }
  else
    return "";
}
  
function getSelectedTool(toolgroup) {
  var item = $(".tool-item[data-toolgroup='" + toolgroup + "'].selected");
  return (item.length == 0) ? undefined : item.attr("data-id");
}

var dayActiveAdd = true;
function dayMouseEvent() {
  if ((event.buttons == 1) && ((event.type == "mousedown") || (event.type == "mouseover"))) {
    var $day = $(this);
    if (!$day.is(".other-month")) {
      var pt = getSelectedTool("PT");
      var rc = getSelectedTool("RC");
      
      if (event.type == "mousedown") 
        dayActiveAdd = !$day.is(".active") || ($day.attr("data-pt") != pt) || ($day.attr("data-rc") != rc);
      
      $day.setClass("active", dayActiveAdd);
      setDayPerformanceType($day, dayActiveAdd ? pt : null);
      setDayRateCode($day, dayActiveAdd ? rc : null);
    }
  }
}

function monthClick() {
  var $month = $(this).closest(".cal-month");
  if ($month.find(".cal-day.active").length == 0) {
    var $days = $month.find(".cal-day").not(".other-month"); 
    $days.addClass("active");
    setDayPerformanceType($days, getSelectedTool("PT"));
    setDayRateCode($days, getSelectedTool("RC"));
  }
}

function doSaveCalendar() {
  updateYear(encodeCurrentYear());
  cal.CalendarCode = $("#cal\\.CalendarCode").val();
  cal.CalendarName = $("#cal\\.CalendarName").val();
  cal.Enabled = $("#cal\\.Enabled").isChecked();
  cal.DatedCalendar = $("#cal\\.DatedCalendar").isChecked();
  cal.DatedLocationId = $("#cal\\.DatedLocationId").val();
  cal.DatedAccessAreaId = $("#cal\\.DatedAccessAreaId").val();
  cal.ValidDaysInThePast = parseInt($("#cal\\.ValidDaysInThePast").val());
  cal.CategoryId = $("#cal\\.CategoryId").val();
 
  var reqDO = {
    Command: "SaveCalendar",
    SaveCalendar: {
      Calendar: cal
    }
  };

  showWaitGlass();
  vgsService("Calendar", reqDO, false, function(ansDO) {
    hideWaitGlass();
    entitySaveNotification(<%=LkSNEntityType.Calendar.getCode()%>, ansDO.Answer.SaveCalendar.CalendarId);
  });
}

</script>
