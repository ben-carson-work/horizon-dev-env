<%@page import="com.vgs.snapp.jwt.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.vcl.fontawesome.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.LkTimeZone.TimeZoneItem"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>
<% BOSessionBean boSession = (pageBase == null) ? null : (BOSessionBean)pageBase.getSession(); %>

<% // This IF-BLOCK is supposed to always fail. Just a workaround to have this page highlighted as javascript. %>
<% if (request.getAttribute("BB63A701FB6F4C04B70C44E3CB161795") != null) { %>
<script>
<% } %>

const BASE_URL = "<v:config key="site_url"/>"; 
const FA_PREFIX = <%=JvString.jsString(JvFA.FA_PREFIX)%>;

const KEY_BACKSPACE = 8;
const KEY_TAB       = 9;
const KEY_ENTER     = 13;
const KEY_SHIFT     = 16;
const KEY_CTRL      = 17;
const KEY_CAPSLOCK  = 20;
const KEY_ESC       = 27;
const KEY_LEFT      = 37;
const KEY_UP        = 38;
const KEY_RIGHT     = 39;
const KEY_DOWN      = 40;
const KEY_MINUS     = 45;
const KEY_DELETE    = 46;

const KEY_0 = 48;
const KEY_1 = 49;
const KEY_2 = 50;
const KEY_3 = 51;
const KEY_4 = 52;
const KEY_5 = 53;
const KEY_6 = 54;
const KEY_7 = 55;
const KEY_8 = 56;
const KEY_9 = 57;

const KEY_CHAR_A = 65;
const KEY_CHAR_B = 66;
const KEY_CHAR_C = 67;
const KEY_CHAR_I = 73;
const KEY_CHAR_V = 86;
const KEY_CHAR_Y = 89;
const KEY_CHAR_Z = 90;

const KEY_NUM_0   = 96;
const KEY_NUM_1   = 97;
const KEY_NUM_2   = 98;
const KEY_NUM_3   = 99;
const KEY_NUM_4   = 100;
const KEY_NUM_5   = 101;
const KEY_NUM_6   = 102;
const KEY_NUM_7   = 103;
const KEY_NUM_8   = 104;
const KEY_NUM_9   = 105;
const KEY_NUM_DEC = 110;

const KEY_F1  = 112;
const KEY_F2  = 113;
const KEY_F3  = 114;
const KEY_F4  = 115;
const KEY_F5  = 116;
const KEY_F6  = 117;
const KEY_F7  = 118;
const KEY_F8  = 119;
const KEY_F9  = 120;
const KEY_F10 = 121;
const KEY_F11 = 122;
const KEY_F12 = 123;

const MSEC_PER_SEC  = 1000;
const MSEC_PER_MIN  = 60 * MSEC_PER_SEC;
const MSEC_PER_HOUR = 60 * MSEC_PER_MIN;
const MSEC_PER_DAY  = 24 * MSEC_PER_HOUR;

// Day Of Week
const DOW_SUN = 0;
const DOW_MON = 1;
const DOW_TUE = 2;
const DOW_WED = 3;
const DOW_THU = 4;
const DOW_FRI = 5;
const DOW_SAT = 6;

const CHAR_RAQUO = "\u00BB";
const CHAR_MDASH = "\u2014";
var ITL = {};

var BARCODE_MIN_LENGTH = <%=SnappUtils.BARCODE_MIN_LENGTH%>;

// Using javascript convention, where 0=SUNDAY..6=SATURDAY
var snpFirstDayOfWeek = 0;


function strToIntDef(value, defaultValue) {
  var result = parseInt(value);
  if (isNaN(result))
    return defaultValue;
  else
    return result;
}

function strToFloatDef(value, defaultValue) {
  var result = parseFloat(value);
  if (isNaN(result))
    return defaultValue;
  else
    return result;
}

function strToBoolDef(str, defaultValue) { 
  if ((str.toLowerCase() === 'true') || (str === '1')) 
	  return true; 
  else if ((str.toLowerCase() === 'false') || (str === '0'))
		return false; 
  else 
	  return defaultValue; 
}

function parseBool(value) {
  return (value == "true");
}

function parseFloatOrNull(value) {
  value = value.replace(",",".");
  if ((value == null) || (value == "") || (value == "null"))
    return null;
  else
    return parseFloat(value);
}

function escapeHtml(txt) {
  return $("<div>").text(txt).html();
}

function getTimezoneCode() {
  tmSummer = new Date(Date.UTC(2015, 6, 30, 0, 0, 0, 0));
  so = -1 * tmSummer.getTimezoneOffset();
  tmWinter = new Date(Date.UTC(2015, 12, 30, 0, 0, 0, 0));
  wo = -1 * tmWinter.getTimezoneOffset();

  if (-660 == so && -660 == wo) return <%=LkTimeZone.Etc_GMT_P11.getCode()%>;// 'Pacific/Midway';
  if (-600 == so && -600 == wo) return <%=LkTimeZone.Pacific_Honolulu.getCode()%>;// 'Pacific/Tahiti';
  if (-570 == so && -570 == wo) return <%=LkTimeZone.America_Anchorage.getCode()%>;// 'Pacific/Marquesas';
  if (-540 == so && -600 == wo) return <%=LkTimeZone.America_Anchorage.getCode()%>;// 'America/Adak';
  if (-540 == so && -540 == wo) return <%=LkTimeZone.America_Anchorage.getCode()%>;// 'Pacific/Gambier';
  if (-480 == so && -540 == wo) return <%=LkTimeZone.America_Anchorage.getCode()%>;// 'US/Alaska';
  if (-480 == so && -480 == wo) return <%=LkTimeZone.America_Santa_Isabel.getCode()%>;// 'Pacific/Pitcairn';
  if (-420 == so && -480 == wo) return <%=LkTimeZone.America_Los_Angeles.getCode()%>;// 'US/Pacific';
  if (-420 == so && -420 == wo) return <%=LkTimeZone.America_Phoenix.getCode()%>;// 'US/Arizona';
  if (-360 == so && -420 == wo) return <%=LkTimeZone.America_Phoenix.getCode()%>;// 'US/Mountain';
  if (-360 == so && -360 == wo) return <%=LkTimeZone.America_Denver.getCode()%>;// 'America/Guatemala';
  if (-360 == so && -300 == wo) return <%=LkTimeZone.America_Chihuahua.getCode()%>;// 'Pacific/Easter';
  if (-300 == so && -360 == wo) return <%=LkTimeZone.America_Chicago.getCode()%>;// 'US/Central';
  if (-300 == so && -300 == wo) return <%=LkTimeZone.America_Bogota.getCode()%>;// 'America/Bogota';
  if (-240 == so && -300 == wo) return <%=LkTimeZone.America_New_York.getCode()%>;// 'US/Eastern';
  if (-240 == so && -240 == wo) return <%=LkTimeZone.America_Caracas.getCode()%>;// 'America/Caracas';
  if (-240 == so && -180 == wo) return <%=LkTimeZone.America_Santiago.getCode()%>;// 'America/Santiago';
  if (-180 == so && -240 == wo) return <%=LkTimeZone.America_Halifax.getCode()%>;// 'Canada/Atlantic';
  if (-180 == so && -180 == wo) return <%=LkTimeZone.America_Montevideo.getCode()%>;// 'America/Montevideo';
  if (-180 == so && -120 == wo) return <%=LkTimeZone.America_Sao_Paulo.getCode()%>;// 'America/Sao_Paulo';
  if (-150 == so && -210 == wo) return <%=LkTimeZone.America_St_Johns.getCode()%>;// 'America/St_Johns';
  if (-120 == so && -180 == wo) return <%=LkTimeZone.America_Godthab.getCode()%>;// 'America/Godthab';
  if (-120 == so && -120 == wo) return <%=LkTimeZone.America_Montevideo.getCode()%>;// 'America/Noronha';
  if (-60 == so && -60 == wo) return <%=LkTimeZone.Atlantic_Cape_Verde.getCode()%>;// 'Atlantic/Cape_Verde';
  if (0 == so && -60 == wo) return <%=LkTimeZone.Atlantic_Azores.getCode()%>;// 'Atlantic/Azores';
  if (0 == so && 0 == wo) return <%=LkTimeZone.Africa_Casablanca.getCode()%>;// 'Africa/Casablanca';
  if (60 == so && 0 == wo) return <%=LkTimeZone.Europe_London.getCode()%>;// 'Europe/London';
  if (60 == so && 60 == wo) return <%=LkTimeZone.Africa_Lagos.getCode()%>;// 'Africa/Algiers';
  if (60 == so && 120 == wo) return <%=LkTimeZone.Africa_Windhoek.getCode()%>;// 'Africa/Windhoek';
  if (120 == so && 60 == wo) return <%=LkTimeZone.Europe_Berlin.getCode()%>;// 'Europe/Amsterdam';
  if (120 == so && 120 == wo) return <%=LkTimeZone.Africa_Johannesburg.getCode()%>;// 'Africa/Harare';
  if (180 == so && 120 == wo) return <%=LkTimeZone.Europe_Bucharest.getCode()%>;// 'Europe/Athens';
  if (180 == so && 180 == wo) return <%=LkTimeZone.Africa_Nairobi.getCode()%>;// 'Africa/Nairobi';
  if (240 == so && 180 == wo) return <%=LkTimeZone.Europe_Moscow.getCode()%>;// 'Europe/Moscow';
  if (240 == so && 240 == wo) return <%=LkTimeZone.Asia_Dubai.getCode()%>;// 'Asia/Dubai';
  if (270 == so && 210 == wo) return <%=LkTimeZone.Asia_Tehran.getCode()%>;// 'Asia/Tehran';
  if (270 == so && 270 == wo) return <%=LkTimeZone.Asia_Kabul.getCode()%>;// 'Asia/Kabul';
  if (300 == so && 240 == wo) return <%=LkTimeZone.Asia_Baku.getCode()%>;// 'Asia/Baku';
  if (300 == so && 300 == wo) return <%=LkTimeZone.Asia_Karachi.getCode()%>;// 'Asia/Karachi';
  if (330 == so && 330 == wo) return <%=LkTimeZone.Asia_Calcutta.getCode()%>;// 'Asia/Calcutta';
  if (345 == so && 345 == wo) return <%=LkTimeZone.Asia_Katmandu.getCode()%>;// 'Asia/Katmandu';
  if (360 == so && 300 == wo) return <%=LkTimeZone.Asia_Yekaterinburg.getCode()%>;// 'Asia/Yekaterinburg';
  if (360 == so && 360 == wo) return <%=LkTimeZone.Asia_Colombo.getCode()%>;// 'Asia/Colombo';
  if (390 == so && 390 == wo) return <%=LkTimeZone.Asia_Rangoon.getCode()%>;// 'Asia/Rangoon';
  if (420 == so && 360 == wo) return <%=LkTimeZone.Asia_Almaty.getCode()%>;// 'Asia/Almaty';
  if (420 == so && 420 == wo) return <%=LkTimeZone.Asia_Bangkok.getCode()%>;// 'Asia/Bangkok';
  if (480 == so && 420 == wo) return <%=LkTimeZone.Asia_Krasnoyarsk.getCode()%>;// 'Asia/Krasnoyarsk';
  if (480 == so && 480 == wo) return <%=LkTimeZone.Australia_Perth.getCode()%>;// 'Australia/Perth';
  if (540 == so && 480 == wo) return <%=LkTimeZone.Asia_Irkutsk.getCode()%>;// 'Asia/Irkutsk';
  if (540 == so && 540 == wo) return <%=LkTimeZone.Asia_Tokyo.getCode()%>;// 'Asia/Tokyo';
  if (570 == so && 570 == wo) return <%=LkTimeZone.Australia_Darwin.getCode()%>;// 'Australia/Darwin';
  if (570 == so && 630 == wo) return <%=LkTimeZone.Australia_Adelaide.getCode()%>;// 'Australia/Adelaide';
  if (600 == so && 540 == wo) return <%=LkTimeZone.Asia_Yakutsk.getCode()%>;// 'Asia/Yakutsk';
  if (600 == so && 600 == wo) return <%=LkTimeZone.Australia_Brisbane.getCode()%>;// 'Australia/Brisbane';
  if (600 == so && 660 == wo) return <%=LkTimeZone.Australia_Sydney.getCode()%>;// 'Australia/Sydney';
  if (630 == so && 660 == wo) return <%=LkTimeZone.Australia_Hobart.getCode()%>;// 'Australia/Lord_Howe';
  if (660 == so && 600 == wo) return <%=LkTimeZone.Asia_Vladivostok.getCode()%>;// 'Asia/Vladivostok';
  if (660 == so && 660 == wo) return <%=LkTimeZone.Pacific_Guadalcanal.getCode()%>;// 'Pacific/Guadalcanal';
  if (690 == so && 690 == wo) return <%=LkTimeZone.Etc_GMT_M12.getCode()%>;// 'Pacific/Norfolk';
  if (720 == so && 660 == wo) return <%=LkTimeZone.Asia_Magadan.getCode()%>;// 'Asia/Magadan';
  if (720 == so && 720 == wo) return <%=LkTimeZone.Pacific_Fiji.getCode()%>;// 'Pacific/Fiji';
  if (720 == so && 780 == wo) return <%=LkTimeZone.Pacific_Auckland.getCode()%>;// 'Pacific/Auckland';
  if (765 == so && 825 == wo) return <%=LkTimeZone.Pacific_Tongatapu.getCode()%>;// 'Pacific/Chatham';
  if (780 == so && 780 == wo) return <%=LkTimeZone.Pacific_Apia.getCode()%>;// 'Pacific/Enderbury'
  if (840 == so && 840 == wo) return <%=LkTimeZone.Pacific_Kiritimati.getCode()%>;// 'Pacific/Kiritimati';
  return <%=LkTimeZone.Etc_GMT.getCode()%>;
}
function getSelectedTimezoneCode() {
  var forced = getCookie("ForcedBrowserTimeZoneCode");
  var code;
  if ((forced) && (forced.length > 0))
    return forced;
  else
    return getTimezoneCode();
}
function doUpdateTimeZoneCookie() {
  document.cookie = "BrowserTimeZoneCode=" + getSelectedTimezoneCode();
}
function setForcedTimeZoneCode(code) {
  setCookie("ForcedBrowserTimeZoneCode", (code) ? code : "", 7);
  doUpdateTimeZoneCookie();
}
function convertDateTimeToSelectedTimezone(dt) {
  var ms = dt.getMilliseconds();
  var sDateTime = dt.toLocaleString("en-US", {timeZone: getTimezoneId(getSelectedTimezoneCode())});
  dt = new Date(sDateTime);
  dt.setUTCMilliseconds(ms);
  return dt;
}
doUpdateTimeZoneCookie();

function getTimezoneId(timeZoneCode) {
  var ids = {};
  <% for (LookupItem item : LkSN.TimeZone.getItems()) { %>
    ids[<%=item.getCode()%>] = <%=JvString.jsString(((TimeZoneItem)item).getId())%>;
  <% } %>
  return ids[timeZoneCode];
}

function getSmoothSize(bytes) {
  var b = (bytes) ? bytes : 0;
  if (b < 1024)
    return b + " Byte";
  else if (b < 1024 * 1024)
    return Math.round(b / 1024) + " KB";
  else if (b < 1024 * 1024 * 30)
    return Math.round(b / (1024 * 1024) * 10) / 10 + " MB";
  else if (b < 1024 * 1024 * 1024)
    return Math.round(b / (1024 * 1024)) + " MB";
  else if (b < 1024 * 1024 * 1024 * 1024)
    return Math.round(b / (1024 * 1024 * 1024) * 10) / 10 + " GB";
  else
    return Math.round(b / (1024 * 1024)) + " MB";
}

function getSmoothQuantity(value) {
  var v = (value) ? value : 0;
  if (v < 1000)
    return v;
  else if (v < 1000 * 10)
    return Math.round(v / 1000 * 10) / 10 + "K";
  else if (v < 1000 * 1000)
    return Math.round(v / 1000) + "K";
  else if (v < 1000 * 1000 * 30)
    return Math.round(v / (1000 * 1000) * 10) / 10 + "M";
  else if (v < 1000 * 1000 * 1000)
    return Math.round(v / (1000 * 1000)) + "M";
  else if (v < 1000 * 1000 * 1000 * 1000)
    return Math.round(v / (1000 * 1000 * 1000) * 10) / 10 + "B";
  else
    return Math.round(v / (1000 * 1000)) + "M";
}

function getSmoothTime(msecs) {
  msecs = (msecs) ? msecs : 0;

  var result = "";
  
  var days = Math.trunc(msecs / MSEC_PER_DAY);
  if (days > 0)
    result += " " + days + "d";
  msecs -= days * MSEC_PER_DAY;
  
  var hours = Math.trunc(msecs / MSEC_PER_HOUR);
  if (hours > 0)
    result += " " + hours + "h";
  msecs -= hours * MSEC_PER_HOUR;
  
  if (days === 0) {
    var mins = Math.trunc(msecs / MSEC_PER_MIN);
    if ((mins > 0) || (hours > 0))
      result += " " + mins + "m";
    msecs -= mins * MSEC_PER_MIN;
    
    if (hours === 0) {
      var secs = Math.trunc(msecs / MSEC_PER_SEC);
      if ((secs > 0) || (mins > 0))
        result += " " + secs + "s";
      msecs -= secs * MSEC_PER_SEC;

      if ((mins === 0) && (secs === 0))
        result += " " + Math.trunc(msecs) + "ms";
    }
  }
  
  return result.trim();
}

function newStrUUID() {
  function s4() {
    return Math.floor((1 + Math.random()) * 0x10000)
      .toString(16)
      .substring(1);
  }
  return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
}

function getCookie(name) {
  var entries = (document.cookie || "").split(";");
  for (var i=0; i<entries.length; i++) {
    var entry = entries[i].trim();
    var parts = entry.split("=");
    if (parts.length >= 2) {
      if (parts[0].trim() == name)
        return decodeURIComponent(parts[1].trim());
    }
  }
  return null;
}

function setCookie(name, value, expdays) {
  var d = new Date();
  d.setTime(d.getTime() + (expdays*24*60*60*1000));
  document.cookie = name + "=" + value + "; expires=" + d.toUTCString();
}

function getVgsServiceError(ans) {
  if (ans.status == 0)
    return "Server is unreacheable or the request timed out.\nPlease try again.";
  else if ((ans.status != null) && (ans.status != 200)) 
    return ans.status + ": " + ans.statusText;
  else if (ans.Header == null)
    return "Unreadable response";
  else if (ans.Header.StatusCode != 200)
    return (ans.Header.ErrorMessage || "unknown error");
  else
    return null;
}

function isUnauthorizedAnswer(ansDO) {
  return (ansDO) && (ansDO.Header) && ((ansDO.Header.StatusCode == 401) || (ansDO.Header.StatusCode == 1203));
} 

function leadZero(value, digits) {
  var val = "" + value; // Convert to string
  while (val.length < digits)
    val = "0" + val;
  return val;
}

function nowMillis() {
  return (new Date()).getTime();
}

function dateToXML(date) {
  return date.getFullYear() + "-" + leadZero(date.getMonth() + 1, 2) + "-" + leadZero(date.getDate(), 2) + "T" + leadZero(date.getHours(), 2) + ":" + leadZero(date.getMinutes(), 2) + ":" + leadZero(date.getSeconds(), 2) + "." + leadZero(date.getMilliseconds(), 3);
}

function xmlToDate(s) {
  if ((s) && (s.length >= 10)) {
    var year = parseInt(s.substring(0,4));
    var month = parseInt(s.substring(5,7)) - 1;
    var day = parseInt(s.substring(8,10));
    var hh = 0;
    var mm = 0;
    var ss = 0;
    var ms = 0;
    var offset = null;
    if (s.length >= 16) {
      hh = parseInt(s.substring(11,13));
      mm = parseInt(s.substring(14,16));
    }
    if (s.length >= 19) 
      ss = parseInt(s.substring(17,19));
    if (s.length >= 23) 
      ms = parseInt(s.substring(20,23));
    if (s.length > 23) {
      var rawOffSet = s.substring(23);
      var oSign = 0;
      var oHH = 0;
      var oMM = 0;
      if (rawOffSet.length > 0) 
        oSign = (rawOffSet[0] == "+") ? -1 : (rawOffSet[0] == "-") ? +1 : 0;
      if (rawOffSet.length >= 3)
        oHH = strToIntDef(rawOffSet.substring(1, 3), 0);
      if (rawOffSet.length >= 5)
        oMM = strToIntDef(rawOffSet.substring(3, 5), 0);
      offset = ((oHH * 60) + oMM) * oSign;
    }
    var date = new Date(year, month, day, hh, mm, ss, ms);
    if (offset !== null)    
      date =  new Date(date.getTime() - (date.getTimezoneOffset() * 60000) + (offset * 60000));
    return date;
  }
  else
    return new Date(); 
}

function xmlToUserDate(s) {
  return convertDateTimeToSelectedTimezone(xmlToDate(s));
}

function getUrlParam(urlo, key) {
  var urlParams = {};
  urlo.replace(
    new RegExp("([^?=&]+)(=([^&]*))?", "g"),
    function($0, $1, $2, $3) {
      urlParams[$1] = $3;
    }
  );
  
  return urlParams[key];
}

function setUrlParam(urlo, key, value) {
  if (urlo) {
    key = escape(key); 
    value = encodeURIComponent(value || "");
    
    var r = "";
    var us = urlo.split("?");
    if (us.length < 2) {
      r = urlo + "?";
      urlo = "";
    }
    else {
      r = us[0] + "?";
      urlo = us[1];
    }
    
    var kvp = urlo.split('&');
    var i=kvp.length; var x; 
    while(i--) {
      x = kvp[i].split('=');
      if (x[0]==key) {
        x[1] = value;
        kvp[i] = x.join('=');
        break;
      }
    }
    if(i<0) {kvp[kvp.length] = [key,value].join('=');}
    return r + kvp.join('&'); 
  }
}

function getIconURL(name, size, subicon) {
  if (subicon)
    name += "|" + subicon;
  return BASE_URL + "/imagecache?name=" + encodeURIComponent(name) + "&size=" + size;
}

String.prototype.replaceAll = function(s, r) {
  return this.split(s).join(r);
};

$.fn.von = function(owner, events, handler) {
  var $this = $(this);
  $this.on(events, handler);
  if (owner) {
    $(owner).on("remove", function() {
      $this.off(events, handler);
    });
  }
};


jQuery.fn.setClass = function(clazz, condition) {
  var $this = $(this);
  if (condition)
    $this.addClass(clazz);
  else
    $this.removeClass(clazz);
  return $this;
};

jQuery.fn.hasAttr = function(attrname) {
  var attr = $(this).attr(attrname);
  return (typeof attr !== typeof undefined && attr !== false);
};


jQuery.fn.getXMLDate = function() {
  var date = $(this).datepicker("getDate");
  if (date == null)
    return "";
  else {
    var sDD = date.getDate().toString();
    var sMM = (date.getMonth() + 1).toString();
    var sYY = date.getFullYear().toString();
    while (sDD.length < 2)
      sDD = "0" + sDD;
    while (sMM.length < 2)
      sMM = "0" + sMM;
    return sYY + "-" + sMM + "-" + sDD;
  }
};

jQuery.fn.getXMLDateTime = function(defaultTimeMax) {
  var result = $(this).getXMLDate();
  
  var hhCombo = $("#" + $(this).attr("id").replace(".", "\\.").replace("picker", "HH"));
  var mmCombo = $("#" + $(this).attr("id").replace(".", "\\.").replace("picker", "MM"));

  var hh = (hhCombo.getComboIndex() > 0) ? hhCombo.val() : ((defaultTimeMax) ? "23" : "00");
  var mm = (mmCombo.getComboIndex() > 0) ? mmCombo.val() : ((defaultTimeMax) ? "59" : "00");
  var ss = ((defaultTimeMax) ? "59" : "00");
  
  if (result != "") 
    result += "T" + hh + ":" + mm + ":" + ss;

  return result;
};

jQuery.fn.getXMLTime = function(defaultTimeMax) {
  var hhCombo = $("#" + $(this).attr("id").replace(".", "\\.") + "-HH");
  var mmCombo = $("#" + $(this).attr("id").replace(".", "\\.") + "-MM");
  
  if (hhCombo.getComboIndex() == 0)
    return "";
  else {
    var hh = (hhCombo.getComboIndex() > 0) ? hhCombo.val() : ((defaultTimeMax) ? "23" : "00");
    var mm = (mmCombo.getComboIndex() > 0) ? mmCombo.val() : ((defaultTimeMax) ? "59" : "00");
    
    return hh + ":" + mm;
  }
};

jQuery.fn.setXMLTime = function(value) {
  var $this = $(this);
  $this.val(value);
  
  var $hh = $("#" + $this.attr("id").replace(".", "\\.") + "-HH");
  var $mm = $("#" + $this.attr("id").replace(".", "\\.") + "-MM");
  
  var splits = [];
  if (getNull(value) != null)
    splits = value.split(":");
  $hh.val((splits.length < 1) ? "HH" : splits[0]);
  $mm.val((splits.length < 2) ? "MM" : splits[1]);

  return $this;
};

var fmtDateMonths = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
var fmtDateWeekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
function formatDate(date, snpFormat) {
  snpFormat = (snpFormat) ? snpFormat : snpShortDateFormat;
  if (date == null)
    return null;
  else {
    if (typeof date === "string")
      date = xmlToDate(date);
   
    switch (parseInt(snpFormat)) {
    case 101: return leadZero(date.getDate(), 2) + "/" + leadZero(date.getMonth() + 1, 2) + "/" + date.getFullYear();
    case 102: return leadZero(date.getDate(), 2) + "/" + leadZero(date.getMonth() + 1, 2) + "/" + (""+date.getFullYear()).substring(2,4);
    case 103: return leadZero(date.getMonth() + 1, 2) + "/" + leadZero(date.getDate(), 2) + "/" + date.getFullYear();
    case 104: return leadZero(date.getMonth() + 1, 2) + "/" + leadZero(date.getDate(), 2) + "/" + (""+date.getFullYear()).substring(2,4);
    case 201: return fmtDateWeekDays[date.getDay()] + " " + date.getDate() + " " + fmtDateMonths[date.getMonth()] + " " + date.getFullYear();
    case 202: return date.getDate() + " " + fmtDateMonths[date.getMonth()] + " " + date.getFullYear();
    case 203: return fmtDateMonths[date.getMonth()] + " " + date.getDate() + ", " + date.getFullYear();
    case 204: return fmtDateWeekDays[date.getDay()] + ", " + fmtDateMonths[date.getMonth()] + " " + date.getDate() + ", " + date.getFullYear();
    case 205: return fmtDateMonths[date.getMonth()].substring(0,3) + " " + date.getDate() + ", " + date.getFullYear();
    case 206: return fmtDateMonths[date.getMonth()].substring(0,3) + ", " + date.getFullYear();
    }
  }
}

function formatTime(date, snpFormat) {
  snpFormat = (snpFormat) ? snpFormat : snpShortTimeFormat;
  if (date == null)
    return null;
  else {
    if (typeof date === "string")
      date = xmlToDate(date);
    
    var h12 = date.getHours();
    var ampm = ((h12 >= 0) && (h12 < 12)) ? "am" : "pm";
    if (h12 == 0)
      h12 = 12;
    else if (h12 > 12)
      h12-= 12;
    
    switch (parseInt(snpFormat)) {
    case 101: return leadZero(date.getHours(), 2) + ":" + leadZero(date.getMinutes(), 2);
    case 102: return h12 + ":" + leadZero(date.getMinutes(), 2) + " " + ampm;
    case 201: return leadZero(date.getHours(), 2) + ":" + leadZero(date.getMinutes(), 2) + ":" + leadZero(date.getSeconds(), 2);
    case 202: return h12 + ":" + leadZero(date.getMinutes(), 2) + ":" + leadZero(date.getSeconds(), 2) + " " + ampm;
    }
  }
}

var mainCurrencyFormat = <%=LkCurrencyFormat.Symbol_Amount.getCode()%>;
var mainCurrencySymbol = "$";
var mainCurrencyISO = "USD";
var thousandSeparator = ",";
var decimalSeparator = ".";

function formatAmount(a, c, d, t) {
  var 
    c = isNaN(c = Math.abs(c)) ? 2 : c, 
    d = d == undefined ? decimalSeparator : d, 
    t = t == undefined ? thousandSeparator : t, 
    n = roundValue(a, c), 
    s = n < 0 ? "-" : "", 
    i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "", 
    j = (j = i.length) > 3 ? j % 3 : 0;
  return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
}

function roundValue(val, c) {
  let f = Math.pow(10, c)
  let epsilon = val > 0 ? Number.EPSILON : -Number.EPSILON
  return "" + Math.round((val + epsilon) * f) / f
}

function formatCurr(amount, format, symbol, iso) {
  amount = ((typeof amount) == "string") ? parseFloat(amount) : amount;
  format = (format) ? format : mainCurrencyFormat;
  symbol = (symbol != null) ? symbol : mainCurrencySymbol;
  iso = (iso) ? iso : mainCurrencyISO;
  
  switch (format) {
  case <%=LkCurrencyFormat.Symbol_Amount.getCode()%>:
    return symbol + " " + formatAmount(amount, 2, decimalSeparator, thousandSeparator);
  case <%=LkCurrencyFormat.Amount_Code.getCode()%>:
    return formatAmount(amount, 2, decimalSeparator, thousandSeparator) + " " + iso;
  }
  
  return "?";
}

function addTrailingSlash(u) {
  u = (u) ? u : "";
  if ((u.length == 0) || (u.charAt(u.length - 1) != "/"))
    u += "/";
  return u;
}

function calcIconName(name, size) {
  return addTrailingSlash(BASE_URL) + "imagecache?name=" + encodeURIComponent(name) + "&size=" + size;
}

function calcRepositoryURL(repositoryId, type) {
  type = (type) ? type : "small";
  return addTrailingSlash(BASE_URL) + "repository?id=" + repositoryId + "&type=" + type;
}

function calcEntityDesc(code, name) {
  var result = name;
  if (code != null)
    result = ("[" + code + "] " + result).trim();
  
  return result;
}

function functionExists(name) {
  return (eval("typeof " + name) == "function");
}

function hidePasswordDOM() {
  $("input[type='password']").each(function(index, elem) {
    var $elem = $(elem);
    var value = $elem.val();
    $elem.removeAttr("value");
    $elem.val(value);
  });
}

function itl(key) {
  var result = "";
  if (key) {
    if (key.charAt(0) == "@")
      key = key.substr(1);
    
    result = ITL[key];
    if (result) {
      for (var i=1; i<arguments.length; i++) 
        result = result.replace("%" + i, arguments[i] || "");
    }
    else
      result = key;
  }
  
  return result;
}

function isSameText(s1, s2) {
  var s1 = getNull(s1);
  var s2 = getNull(s2);
  if ((s1 == null) && (s2 == null))
    return true;
  else if ((s1 != null) && (s2 != null))
    return (s1.toUpperCase() === s2.toUpperCase());
  else
    return false;
}

/**
 * Return NULL in case input value is: NULL, UNDEFINED, "" (empty string); In all other cases just return the input value.
 */
function getNull(value) {
  if ((value === "") || (value === null) || (value === undefined))
    return null;
  else
    return value;
}
 
 /**
  * Return an array of integers (0..6) where each value represent the DayOfWeek (0=Sunday, 1=Monday, etc)
  */
function getWeekDays() {
  var result = [];
  for (var i=0; i<7; i++) 
    result[i] = (snpFirstDayOfWeek + i) % 7;
  return result;
}
 
/**
 * Returns an int array starting from a comma separated string
 */
function getIntArray(value) {
  var strings = (value || "").split(",");
  var result = [];
  for (var i=0; i<strings.length; i++) {
    var intValue = parseInt(strings[i]);
    if (!isNaN(intValue))
      result.push(intValue);
  }
  return result;
}

/**
 * Returns the array removing any duplicated item
 */
function distinct(array) {
  function _unique(value, index, self) {
    return self.indexOf(value) === index;
  }
  return array.filter(_unique);
}

/*
 * Detects colors similarity
 * Returns a float value between 0 and 1. 0 means opposite colors, 1 means same colors.
 */
function hexColorDelta(hex1, hex2) {
  function _RGB(hex) {
    return {
      red: parseInt(hex.substring(0, 2), 16),
      green: parseInt(hex.substring(2, 4), 16),
      blue: parseInt(hex.substring(4, 6), 16)
    }
  }
  
  var rgb1 = _RGB(hex1);
  var rgb2 = _RGB(hex2);
  // calculate differences between reds, greens and blues
  var r = 255 - Math.abs(rgb1.red   - rgb2.red);
  var g = 255 - Math.abs(rgb1.green - rgb2.green);
  var b = 255 - Math.abs(rgb1.blue  - rgb2.blue);
  // limit differences between 0 and 1
  r /= 255;
  g /= 255;
  b /= 255;
  // 0 means opposite colors, 1 means same colors
  return (r + g + b) / 3;
}

function visibilityObserver(elem, callback) {
  var observer = new IntersectionObserver(function(entries) {
    if (entries[0].isIntersecting === true)
      callback();
  }, { threshold: [0.01] });
  
  if (elem instanceof jQuery)
    elem = elem[0];
  
  observer.observe(elem);
}

function extractFileExtension(fileName) {
  if (fileName) {
    var idx = fileName.lastIndexOf(".");
    if ((idx >= 0))
      return fileName.substring(idx + 1);
  }
  return "";
}

function isAbortError(error) {
  return (error instanceof DOMException && error.name == "AbortError");
}

/**
 * Add a keypress listener and calls "callback" in case the key ENTER(13) is hit
 */
$.fn.keypressEnter = function(callback) {
  $(this).keypress(function(e) {
    if (e.keyCode == KEY_ENTER) 
      callback();
  });
};

/**
 * Add a keypress listener and "prevents event default" for any non numeric key
 */
$.fn.keypressNumOnly = function(callback) {
  $(this).keypress(function(e) {
    if (e.keyCode < 48 || e.keyCode > 57)
      e.preventDefault(); 
  });
};

var uploadBannedExtensions = null;
var uploadFileSizeLimit = null;
function validateUpload(files) {
  files = Array.isArray(files) ? files : [files];
  
  for (const file of files) {
    var fileExtension = extractFileExtension(file.name);
    if (getNull(fileExtension) == null) 
      throw itl("@Upload.CannotUploadFileWithoutExtension");

    if (uploadBannedExtensions) {
      var fileExtension = fileExtension.toLowerCase();
      for (const bannedExtension of uploadBannedExtensions)
        if (fileExtension == bannedExtension.toLowerCase())
          throw itl("@Upload.FileExtensionNotAllowed", "." + fileExtension);
    }
    
    if (uploadFileSizeLimit) {
      var fsize_B = file.size; 
      var fSize_MB = fsize_B / (1024 * 1024);
      
      if (fSize_MB > uploadFileSizeLimit)
        throw itl("@Upload.FileSizeExceeded");
    }
  }
}

function asyncValidateUpload(files) {
  return new Promise((resolve, reject) => {
    validateUpload(files);
    resolve(files);
  });
}

function createDocEditorFile(file, dataURL) {
  return {
    FileName: file.name,
    LastModified: dateToXML(file.lastModifiedDate), 
    FileSize: file.size,
    ContentType: dataURL.substring(dataURL.indexOf(":") + 1, dataURL.indexOf(";")),
    Content: dataURL.substring(dataURL.indexOf(",") + 1)
  };
}

function asyncReadFile(file) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onerror = () => reject(reader.error);
    reader.onload = () => resolve(createDocEditorFile(file, reader.result));
  });
}

function stringToIntArray(value) {
  var result = [];
  for (const item of (value || "").split(",")) {
    var intItem = parseInt(item);
    if (!isNaN(intItem))
      result.push(intItem);
  }
  return result;
}

function isValidMediaCode(mediaCode) {
  return (mediaCode || "").length >= BARCODE_MIN_LENGTH;
}

function isAnonymousAccount(accountName) {
  return ((accountName || "").trim().length <= 0);
}

/**
 * Async function which returns an array of com.vgs.snapp.dataobject.DODocEditorFile JSON
 *
 * @options: see window.showOpenFilePicker options
 */
function asyncUploadFile(options) {
  if (options.id)
    options.id = options.id.replaceAll(".", "_");
  return new Promise((resolve, reject) => {
    window.showOpenFilePicker(options)
      .then(handles => Promise.all(handles.map(handle => handle.getFile())))
      .then(files => asyncValidateUpload(files))
      .then(files => Promise.all(files.map(file => asyncReadFile(file)))) 
      .then(resolve)
      .catch(reject);
  });
}

/**
 * Adds file drop capabilities to a jQuery object.
 *
 * params = {
 *   dragOverClassName: CSS class to add to the jQuery object when file is dragged over,
 *   onDrop: function(array of com.vgs.snapp.dataobject.DODocEditorFile) - File drop handler 
 * }
 */
$.fn.fileDrop = function(params) {
  params = params || {};
  
  var $comp = $(this);
  
  $comp.on("dragenter", function(event) {
    $(this).addClass(params.dragOverClassName);
    event.preventDefault();
  });
  
  $comp.on("dragleave", function(event) {
    if (!this.contains(event.relatedTarget))
      $(this).removeClass(params.dragOverClassName);
  });
  
  $comp.on("dragover", function(event) {
    event.preventDefault();
  });
  
  $comp.on("drop", function(event) {
    event.preventDefault();
    $(this).removeClass(params.dragOverClassName);
  
    if (params.onDrop) {
      var fileList = event.originalEvent.dataTransfer.files;
      var files = [];
      for (var i=0; i<fileList.length; i++)
        files.push(fileList[i]);
      
      Promise.all(files.map(file => asyncReadFile(file))).then(params.onDrop);
    }
  });
};

/**
 * Return TRUE if "v1" is greater than "v2"
 * v1='8.11.2.108.8' and v2='8.12.2.0' must return true
 */
function isGreaterVersion(v1, v2) {
  v1 = v1 || "";
  v2 = v2 || "";
  
  var split1 = v1.split(".").map(it => parseInt(it));
  var split2 = v2.split(".").map(it => parseInt(it));
  
  for (var i=0; i<split1.length; i++)
    if ((split2.length > i) && (split1[i] > split2[i]))
      return true;
  
  return false;
}

/* 
 *   input "encodedPrice" = "-20%"
 *   output {
 *     PriceActionType: LkSNPriceActionType.Subtract
 *     PriceValueType:  LkSNPriceValueType.Percentage
 *     PriceValue: 20.0
 *   }
 */
function decodePriceVariance(encodedPrice) {
  let decodedPrice = {};
  encodedPrice = new String(encodedPrice);
  
  decodedPrice.PriceActionType = encodedPrice.indexOf("-") >= 0 ? <%=LkSNPriceActionType.Subtract.getCode()%> : <%=LkSNPriceActionType.Add.getCode()%>;
  decodedPrice.PriceValueType = encodedPrice.indexOf("%") >= 0 ? <%=LkSNPriceValueType.Percentage.getCode()%> : <%=LkSNPriceValueType.Absolute.getCode()%>;
  
  let value = encodedPrice.replace("%", "").replace("+", "").replace("-", "").replace(",", ".");
  if (value != "") {
    value = parseFloat(value);
    if (isNaN(value)) 
      value = null;
  }
  
  decodedPrice.PriceValue = value;
  
  return decodedPrice;
}

 /* 
  *   input {
  *     PriceActionType: LkSNPriceActionType.Subtract
  *     PriceValueType:  LkSNPriceValueType.Percentage
  *     PriceValue: 20.0
  *   }
  *   output "encodedPrice" = "-20%"
  */
function encodePriceVariance(actionType, valueType, value) {
  if (value) {
    let encodedPrice = "";
    
    if (actionType == <%= LkSNPriceActionType.Subtract.getCode() %>) 
      encodedPrice += "-";
    else
      encodedPrice += "+";
    
    if (value !== null && value !== undefined) 
      encodedPrice += value;
    
    if (valueType == <%= LkSNPriceValueType.Percentage.getCode() %>) 
      encodedPrice += "%";
    
    return encodedPrice;
  }
}

<%@ include file="snp-web-socket.js" %>
<%@ include file="snp-token-renew.js" %>

<% // This IF-BLOCK is supposed to always fail. Just a workaround to have this page highlighted as javascript. %>
<% if (request.getAttribute("BB63A701FB6F4C04B70C44E3CB161795") != null) { %>
</script>
<% } %>
