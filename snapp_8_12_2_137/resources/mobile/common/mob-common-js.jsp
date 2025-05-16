<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.web.mob.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<% PageMOB_Base<?> pageBase = (PageMOB_Base<?>)request.getAttribute("pageBase"); %>

<script>

<jsp:include page="../../common/script/common-js.jsp"/>

var ITL = <%=pageBase.getBL(BLBO_Lang.class).getLangJSon("en")%>;

var LICENSE_ID = <%=BLBO_DBInfo.getLicenseId()%>;
var MOUSE_DOWN_EVENT = <%=JvString.jsString(pageBase.getEventMouseDown())%>;

var selectedAppNames = null;
var availableApps = [];

var workstationId = "<%=BLBO_DBInfo.getWorkstationId_BKO()%>";
var rootCategoryId_Person = "<%=pageBase.getBL(BLBO_Category.class).getRootCategoryId(LkSNEntityType.Person)%>";
var rootCategoryId_Organization = "<%=pageBase.getBL(BLBO_Category.class).getRootCategoryId(LkSNEntityType.Organization)%>";

var goodTicketLimit = 100;
var barcodeMinLength = 6;

var vgsInit = {};
var vgsFinalize = {};

var COMMON_STATUS = {};
COMMON_STATUS[LkSN.CommonStatus.Draft.code] = "draft";
COMMON_STATUS[LkSN.CommonStatus.Active.code] = "active";
COMMON_STATUS[LkSN.CommonStatus.Warn.code] = "warn";
COMMON_STATUS[LkSN.CommonStatus.Deleted.code] = "deleted";
COMMON_STATUS[LkSN.CommonStatus.Completed.code] = "completed";
COMMON_STATUS[LkSN.CommonStatus.FatalError.code] = "fatal";

window.addEventListener('unhandledrejection', function(event) {
  if (event.reason != null) { 
    console.log(event);
    UIMob.showError(event.reason.message || event.reason);
  }
});

window.onerror = function myErrorHandler(errorMsg, url, lineNumber) {
//  alert("Unhandled exception at " + url + ":" + lineNumber + ":\n\n" + errorMsg);
  alert(errorMsg);
  return false;
}

function encodeLocalStorageKey(key) {
  return LICENSE_ID + "#" + key;
}

function getLocalStorage(key) {
  return localStorage[encodeLocalStorageKey(key)];  
} 

function setLocalStorage(key, value) {
  return localStorage[encodeLocalStorageKey(key)] = value;  
} 

function delLocalStorage(key) {
  return localStorage.removeItem(encodeLocalStorageKey(key));  
} 

function formatShortDateFromXML(xmlDateTime) {
  var dt = xmlToDate(xmlDateTime);
  return formatDate(dt, BLMob.Rights.ShortDateFormat);
}

function formatShortDateTimeFromXML(xmlDateTime) {
  var dt = xmlToDate(xmlDateTime);
  return formatDate(dt, BLMob.Rights.ShortDateFormat) + " " + formatTime(dt, BLMob.Rights.ShortTimeFormat);
}

function getLookupRawDesc(lookupTable, itemCode) {
  var keys = Object.keys(lookupTable);
  for (var i=0; i<keys.length; i++) {
    var item = lookupTable[keys[i]]
    if (item.code == parseInt(itemCode))
      return item.description;
  }
  return null;
}

function getLookupDesc(lookupTable, itemCode) {
  return itl(getLookupRawDesc(lookupTable, itemCode));
}




</script>




