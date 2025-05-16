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

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<script>

function getStringParam(selector) {
  var value = $(selector).val();
  return (value == null) ? "" : value;
}

function getSmoothCurrency(amt){
  return mainCurrencySymbol + " " + getSmoothQuantity(amt);  
}

function getSmoothQuantity(qty) {
  var k = 1000;
  var m = k * k;
  if (qty < k)
    return qty;
  else if (qty < (k * 10) )
    return (Math.round((qty / k) * 10) / 10) + "K";
  else if (qty < m)
    return Math.round(qty / k) + "K";
  else  
    return (Math.round((qty / m) * 10) / 10) + "M";
}

function formatVariationPerc(currqty, prevqty) {
  if (currqty == prevqty)
    return "=";
  else if ((currqty == 0) || (prevqty == 0))
    return "&infin;";
  else {
    var perc = Math.round(100 * (currqty - prevqty) / prevqty);
    return ((perc > 0) ? "+" : "") + getSmoothQuantity(perc) + " %";
  }
}

function addVarianceClass(elem, currqty, prevqty) {
  if (currqty > prevqty)
    $(elem).addClass("positive");
  else if (currqty < prevqty)
    $(elem).addClass("negative");
}

function createStatBox(caption, currqty, prevqty, containerClasses, isCurrency) {
  if(isCurrency){
    currqty = isNaN(parseFloat(currqty)) ? 0 : parseFloat(currqty); 
  	prevqty = isNaN(parseFloat(prevqty)) ? 0 : parseFloat(prevqty);
  }else{
  	currqty = isNaN(parseInt(currqty)) ? 0 : parseInt(currqty); 
  	prevqty = isNaN(parseInt(prevqty)) ? 0 : parseInt(prevqty);
  }
  
  var div = $("<div class='" + containerClasses + "'/>");
  var divInner = $("<div class='stat-box'/>").appendTo(div);
  var divCaption = $("<div class='stat-box-caption'/>").appendTo(divInner);
  var divVar = $("<div class='stat-box-variation'/>").appendTo(divInner);
  var divCurrQty = $("<div class='stat-box-currqty'/>").appendTo(divInner);
  var divPrevQty = $("<div class='stat-box-prevqty'/>").appendTo(divInner);
  
  divCaption.text(caption);
  
  if (isCurrency) {
    divCurrQty.css("white-space", "nowrap");
    divCurrQty.html(getSmoothCurrency(currqty));
  	divPrevQty.html(getSmoothCurrency(prevqty));
  }
  else{
  	divCurrQty.text(getSmoothQuantity(currqty));
  	divPrevQty.text(getSmoothQuantity(prevqty));
  	divCurrQty.attr("title", itl("@Stats.CurrentInterval") + ": " + formatAmount(currqty, 0));
  	divPrevQty.attr("title", itl("@Stats.PreviousInterval") + ": " + formatAmount(prevqty, 0));
  }
  
  divVar.html(formatVariationPerc(currqty, prevqty));
  addVarianceClass(divVar, currqty, prevqty)
  
  return div;
}
//ADDED  
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
  var tag = false;
  if ($("#TagIDs").val())
    tag = (($("#TagIDs").val().length > 0) ? true : false);
    
  $("#btn-grouping-<%=LkStatGrouping.Slot15.getCode()%>").setEnabled((days <= 1) && !tag);
  $("#btn-grouping-<%=LkStatGrouping.Hour.getCode()%>").setEnabled((days <= 2) && ! tag);
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

  function renderItemsTable(tbodySelector, objList, currTotal, prevTotal, currPercentTotal, prevPercentTotal, currField, prevField, iconField, pictureField, nameField, codeField, itemId, entityType, isCurrency, noImgRepository) {
    var tbody = $(tbodySelector).empty();
    var list = (objList) ? objList : [];
    for (var i=0; i<list.length; i++) {
      var item = list[i];
      
      var tr = $("<tr class='grid-row'/>").appendTo(tbody);
      var tdIco = $("<td><img class='list-icon' width='32' height='32'/></td>").appendTo(tr);
      var tdPrd = $("<td width='100%'><a class='list-title'/><br/><span class='event-code list-subtitle'/></td>").appendTo(tr);
      var tdCur = $("<td class='td-qty-curr' align='center' nowrap><div class='pb-qty'/><div class='pb-outer'><div class='pb-inner'/></div></td>").appendTo(tr);
      var tdPrv = $("<td class='td-qty-prev' align='center' nowrap><div class='pb-qty'/><div class='pb-outer'><div class='pb-inner'/></div></td>").appendTo(tr);
      var tdVar = $("<td class='td-var' align='center' nowrap/>").appendTo(tr);
      if (item[iconField] || item[pictureField])
        if (noImgRepository)
          tdIco.find("img").attr("src", getNoRepositoryIconURL(item[iconField], item[pictureField]));
        else
          tdIco.find("img").attr("src", getVComboIconURL(item[iconField], item[pictureField]));
      if (item[itemId])
      	tdPrd.find("a").text(item[nameField]).attr("href", getPageURL(entityType, item[itemId]));
      else {
        var span = $("<span class='list-title'/>")
        tdPrd.find("a").replaceWith(span); 
        span.text(item[nameField]);
      }

      tdPrd.find(".event-code").text(item[codeField]);

      var curramt = strToIntDef(item[currField], 0);
      var currprc = (100 * curramt) / parseInt(currPercentTotal);
      if (curramt < 0)
        currprc = 0;
      
      tdCur.find(".pb-inner").css("width", ((currprc > 100) ? 100 :  currprc) + "%");

      if (isCurrency)
      	tdCur.find(".pb-qty").html(formatCurr(item[currField]) + "&nbsp;&nbsp;&nbsp;(" + formatAmount(currprc, 0, ',', '.') + "%)");
      else
        tdCur.find(".pb-qty").html(curramt + "&nbsp;&nbsp;&nbsp;(" + formatAmount(currprc, 0) + "%)");
      
      var prevamt = strToIntDef(item[prevField], 0);
      var prevprc = 100 * prevamt / parseInt(prevPercentTotal);
      if (prevamt < 0)
        prevprc = 0;

      tdPrv.find(".pb-inner").css("width", ((prevprc > 100) ? 100 :  prevprc)+ "%");
      if (isCurrency)
      	tdPrv.find(".pb-qty").html(formatCurr(item[prevField]) + "&nbsp;&nbsp;&nbsp;(" + formatAmount(prevprc, 0) + "%)");
      else
        tdPrv.find(".pb-qty").html(prevamt + "&nbsp;&nbsp;&nbsp;(" + formatAmount(prevprc, 0) + "%)");

      tdVar.html(formatVariationPerc(curramt, prevamt));
      addVarianceClass(tdVar, curramt, prevamt)
    }
  }
  
  function getNoRepositoryIconURL(iconName, paymethodIcon) {
    return "<v:config key="site_url"/>/imagecache?size=28&name=" + encodeURI((paymethodIcon) ? paymethodIcon : iconName ); 
  }
  
  function overrideGraphSettings(defaultSettings, overrideSettings) {
    defaultSettings = defaultSettings || {};
    overrideSettings = overrideSettings || {};
    
    for (const key of Object.keys(overrideSettings)) {
      var defaultValue = defaultSettings[key];
      var overrideValue = overrideSettings[key];
      
      if ((defaultValue == null) || (typeof defaultValue != "object"))
        defaultSettings[key] = overrideValue;
      else 
        overrideGraphSettings(defaultValue, overrideValue); 
    }
    
    return defaultSettings;
  }
  
  function createChart(settings) {
    return overrideGraphSettings({
      "language": <%=JvString.jsString(rights.LangISO.getEmptyString().toLowerCase())%>,
      "theme": "light",
      "marginRight": 50,
      "export": {
        "enabled": true
      }
    }, settings);
  }
  
  function createChartSerial(settings) {
    return overrideGraphSettings(createChart({
      "type": "serial",
    }), settings);
  }
  
  function createChartPie(settings) {
    return overrideGraphSettings(createChart({
      "type": "pie",
      "innerRadius": "50%",
      "export": {
        "enabled": true
      }
    }), settings);
  }

  function createChartGraphLine(settings) {
    return overrideGraphSettings({
      "type": "line",
      "bullet": "round",
      "bulletBorderAlpha": 1,
      "bulletColor": "white",
      "bulletSize": 8,
      "hideBulletsCount": 50,
      "lineThickness": 4,
      "title": itl("@Stats.CurrentInterval"),
      "lineColor": "var(--base-blue-color)",
      "fillAlphas": 0.1,
      "lineAlpha": 1,
      "useLineColorForBulletBorder": true,
      "stackable": false
    }, settings);
  }

  function createChartGraphBar(settings) {
    return overrideGraphSettings({
      "type": "column",
      "lineAlpha": 0,
      "fillAlphas": 1      
    }, settings);
  }
  
  function createChartValueAxisLine(settings) {
    return overrideGraphSettings({
      "stackType": "regular",
      "gridAlpha": 0.07,
      "axisColor": "var(--border-color)",
      "inside": true
    }, settings);
  }
  
  function createChartCategoryAxisLine(settings) {
    return overrideGraphSettings({
      "axisColor": "var(--border-color)",
      "gridAlpha": 0.07,
      "guides": [{
        "lineColor": "var(--border-color)",
        "lineAlpha": 1,
        "fillColor": "var(--border-color)",
        "fillAlpha": 0.4
      }]
    }, settings);
  }
  
  function createChartCategoryAxisBar(settings) {
    return overrideGraphSettings({
      "gridPosition": "start",
      "gridAlpha": 0,
      "position": "left"
    }, settings);
  }
</script>
