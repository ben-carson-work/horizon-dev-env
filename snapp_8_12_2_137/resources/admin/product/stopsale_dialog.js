var $dlg = $("#stopsale-dialog");
$dlg.on("snapp-dialog", function(event, params) {
  params.buttons = [];
  if (CAN_EDIT === true)
    params.buttons.push(dialogButton("@Common.Save", saveStopSale));
  params.buttons.push(dialogButton("@Common.Close", doCloseDialog));
});

var $cal = $dlg.find(".cal-month");
var today = new Date();

$cal.on(EVENT_CALMONTH_BEFOREMONTHCHANGE, _beforeMonthChange);
$cal.on(EVENT_CALMONTH_AFTERMONTHCHANGE, _afterMonthChange);
$cal.calMonth_SetMonth(today.getFullYear(), today.getMonth()+1);
$cal.find(".cal-day").click(_onDayClick);

function _encodeStopSaleType(code) {
  var result = MAP_STOPSALE[code];
  if (result)
    return result;
  else
    throw "Invalid stop-sale code: \"" + code + "\"";
}

function _decodeStopSaleType(stopSaleType) {
  for (const code of Object.keys(MAP_STOPSALE))
    if (MAP_STOPSALE[code] == parseInt(stopSaleType))
      return code;
  throw "Invalid stop-sale type: \"" + stopSaleType + "\"";
}

function _setStopSale($day, stopSale) {
  stopSale = getNull(stopSale);
  $day.setClass("active", stopSale != null);
  $day.attr("data-stopsale", stopSale);
  
  $day.find(".stopsale-icon").remove();
  if (stopSale != null) 
    $dlg.find("#stopsale-templates .stopsale-icon-" + stopSale).clone().appendTo($day);
}

function _flushActiveMonth() {
  var iYear = parseInt($cal.attr("data-year"));
  var iMonth = parseInt($cal.attr("data-month"));
  var monthDO = _findOrCreateMonth(iYear, iMonth);
  
  monthDO.DayList = [];
  $cal.find(".cal-day.active").each(function(index, elem) {
    var $day = $(elem);
    var dom = $day.attr("data-dom");
    monthDO.DayList.push({
      "Day": dom,
      "StopSaleType": _encodeStopSaleType($day.attr("data-stopsale"))
    });
  });
}

function _onDayClick() {
  const values = [null, "soft", "hard"];
  var $day = $(this);
  var stopSale = getNull($day.attr("data-stopsale"));
  stopSale = values[(Math.max(0, values.indexOf(stopSale)) + 1) % values.length];
  _setStopSale($day, stopSale);
}

function _findYear(iYear) {
  for (const yearDO of stopSaleData.YearList || [])
    if (yearDO.Year == iYear)
      return yearDO;
  return null;
}

function _findOrCreateYear(iYear) {
  var yearDO = _findYear(iYear);
  if (yearDO == null) {
    yearDO = {
      "Year": iYear,
      "MonthList": []
    };
    
    stopSaleData.YearList = stopSaleData.YearList || [];
    stopSaleData.YearList.push(yearDO);
  }
  return yearDO;
}

function _findMonth(iYear, iMonth) {
  var yearDO = _findYear(iYear) || {};
  for (const monthDO of yearDO.MonthList || [])
    if (monthDO.Month == iMonth)
      return monthDO;
  return null;
}

function _findOrCreateMonth(iYear, iMonth) {
  var yearDO = _findOrCreateYear(iYear);
  var monthDO = _findMonth(iYear, iMonth);
  
  if (monthDO == null) {
    monthDO = {
      "Month": iMonth,
      "DayList": []
    };
    
    yearDO.MonthList = yearDO.MonthList || [];
    yearDO.MonthList.push(monthDO);
  }
  
  return monthDO;
}

function _beforeMonthChange() {
  if ($cal.attr("data-month") && $cal.attr("data-year")) {
    _flushActiveMonth();
    _setStopSale($cal.find(".cal-day.active"), null);
  }
}

function _afterMonthChange() {
  var iYear = parseInt($cal.attr("data-year"));
  var iMonth = parseInt($cal.attr("data-month"));
  var monthDO = _findMonth(iYear, iMonth) || {};
  
  for (const dayDO of monthDO.DayList || []) {
    var $day = $cal.find(".cal-day[data-dom='" + dayDO.Day + "']");
    _setStopSale($day, _decodeStopSaleType(dayDO.StopSaleType));
  }
}

function saveStopSale() {
  _flushActiveMonth();
  
  var reqDO = {
    StopSaleProduct: {
      ProductId: PRODUCT_ID
    },
    Calendar: stopSaleData
  };
  
  snpAPI.cmd("Calendar", "SaveCalendar", reqDO).then(() => $dlg.dialog("close"));
}
