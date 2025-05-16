const EVENT_CALMONTH_BEFOREMONTHCHANGE = "cal-month-beforemonthchange";     // Triggered right before month/year is changed
const EVENT_CALMONTH_AFTERMONTHCHANGE  = "cal-month-aftermonthchange";      // Triggered right after month/year is changed
  
$(document).ready(function() {
  const CLASSNAME = "cal-month";
  const INITIALIZED = "cal-month-initialized"; 
  
  $.fn.calMonth_SetMonth = _calMonth_SetMonth;
  
  snpObserver.registerListener(CLASSNAME, INITIALIZED, function($calendars) {
    $("<div class='cal-month-header'><div class='cal-month-nav cal-month-nav-prev'><i class='fa fa-chevron-left'></i></div><div class='cal-month-title'></div><div class='cal-month-nav cal-month-nav-next'><i class='fa fa-chevron-right'></i></div></div>").appendTo($calendars);
    var $table = $("<table></table>").appendTo($calendars);
    var $thead = $("<thead></thead>").appendTo($table);
    var $tbody = $("<tbody></tbody>").appendTo($table);
    var $trHead = $("<tr></tr>").appendTo($thead);
    
    for (const dow of getWeekDays()) {
      var $td = $("<td class='noselect' width='14.2857%'></td>").appendTo($trHead);
      $td.addClass(_getDayOfWeekClass(dow));    
      $td.text(_getDayOfWeekTitle(dow));        
    }
    
    for (var w=1; w<=6; w++) {
      var $tr = $("<tr class='cal-week'></tr>").appendTo($tbody);
      $tr.attr("data-week", w);
      for (const dow of getWeekDays()) {
        var $td = $("<td class='cal-day noselect'>&nbsp;<span class='cal-day-dom'></span></td>").appendTo($tr);
        $td.addClass(_getDayOfWeekClass(dow));    
        $td.attr("data-week", w);
        $td.attr("data-dow", dow);
      }
    }
    
    $calendars.each(function(index, elem) {
      var $cal = $(elem);
      var year = parseInt($cal.attr("data-year"));
      var month = parseInt($cal.attr("data-month"));
      if (!isNaN(year) && !isNaN(month)) {
        $cal.removeAttr("data-year");
        $cal.removeAttr("data-month");
        $cal.calMonth_SetMonth(year, month);
      }
    });
  });
  
  $(document).on("click", ".cal-month .cal-month-nav-prev", _navPrevClick);
  $(document).on("click", ".cal-month .cal-month-nav-next", _navNextClick);
  
  function _isHoliday(dow) {
    return (dow == DOW_SAT) || (dow == DOW_SUN);
  }

  function _getDayOfWeekClass(dow) {
    return _isHoliday(dow) ? "holiday" : "";
  }
  
  function _getDayOfWeekTitle(dow) {
    var date = new Date();
    date.setDate(date.getDate() + (dow - date.getDay()));
    return date.toLocaleString(navigator.language, {weekday:"short"}).toUpperCase();
  }
  
  function _getMonthTitle($cal, year, month) {
    var date = new Date(year, month-1, 1);
    var result = date.toLocaleString(navigator.language, {month:"long"});
    result = result.charAt(0).toUpperCase() + result.slice(1); // First letter upper case
    
    if ($cal.attr("data-showyearontitle") == "true")
      result += " " + year;
    
    return result;
  }  
  
  function _calMonth_SetMonth(year, month) {
    var $cal = $(this);
    if ((year != parseInt($cal.attr("data-year"))) || (month != parseInt($cal.attr("data-month")))) {
      $cal.trigger(EVENT_CALMONTH_BEFOREMONTHCHANGE);
      
      var weekDays = getWeekDays();
      var m = month - 1;
      var date = new Date(year, m, 1);
      var offset = date.getDay() - snpFirstDayOfWeek;
      if (offset < 0)
        offset += 7;
      date.setDate(date.getDate() - offset);

      $cal.find(".cal-month-title").text(_getMonthTitle($cal, year, month));
      $cal.attr("data-year", year);
      $cal.attr("data-month", month);

      for (var w=1; w<=6; w++) {
        var $wdiv = $cal.find(".cal-week[data-week='" + w + "']");
        for (var i=0; i<weekDays.length; i++) {
          var dow = weekDays[i];
          var $ddiv = $wdiv.find(".cal-day[data-dow='" + dow + "']");

          $ddiv.removeClass("active");
          if (date.getMonth() != m) 
            $ddiv.removeAttr("data-dom");
          else {
            $ddiv.attr("data-dom", date.getDate());
            $ddiv.find(".cal-day-dom").text(date.getDate());
          }
            
          $ddiv.setClass("other-month", date.getMonth() != m);

          date.setDate(date.getDate() + 1);
        }
      }

      $cal.trigger(EVENT_CALMONTH_AFTERMONTHCHANGE);
    }
  }  
  
  function _navClick($cal, delta) {
    var month = parseInt($cal.attr("data-month"));
    var year = parseInt($cal.attr("data-year"));
    if (!isNaN(month) && !isNaN(year)) {
      month += delta;
      if (month > 12) {
        month = 1;
        year++;
      }
      else if (month < 1) {
        month = 12;
        year--;
      }
      $cal.calMonth_SetMonth(year, month);
    }
  }
  
  function _navPrevClick() {
    _navClick($(this).closest("." + CLASSNAME), -1);
  }
  
  function _navNextClick() {
    _navClick($(this).closest("." + CLASSNAME), +1);
  }
});