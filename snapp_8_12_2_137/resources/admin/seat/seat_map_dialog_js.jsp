<%@page import="org.apache.catalina.startup.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
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
<jsp:useBean id="dialogMapInfo" class="com.vgs.snapp.dataobject.DOSeatMapDialogInfo" scope="request"/>

<% 
boolean canEdit = dialogMapInfo.CanEdit.getBoolean();
DOSeatMap map = dialogMapInfo.SeatMap;
%>

<script>

var LkSNSeatBreakType_None = <%=LkSNSeatBreakType.None.getCode()%>;
var LkSNSeatBreakType_ChangeRow = <%=LkSNSeatBreakType.ChangeRow.getCode()%>;
var LkSNSeatBreakType_Disjunction = <%=LkSNSeatBreakType.Disjunction.getCode()%>;

var undoStack = [];
var redoStack = [];
var mutStack = [];
var modified = false;
var observing = false;
var lastSeatWidth = 15;
var lastSeatHeight = 15;

var observer = new MutationObserver(pushMutations);
observer.observe($(".vse-map")[0], {
  subtree: true,
  childList: true,
  attributes: true,
  attributeOldValue: true
});

function pushMutations(mutations) {
  if (observing) {
    mutations.forEach(function(m) {
      var doAppend = true;
      if (m.type == "attributes") {
        m.newValue = $(m.target).attr(m.attributeName);
        for (var i=0; i<mutStack.length; i++) {
          var ms = mutStack[i];
          if ((ms.type == m.type) && (ms.target == m.target) && (ms.attributeName == m.attributeName)) {
            doAppend = false;
            ms.newValue = m.newValue;
            break;
          }
        }
      }
      
      if (doAppend)
        mutStack.push(m);
    });
  }
}

function startMutationObserver() {
  observing = true;
  observer.takeRecords();
  mutStack = [];
}

function stopMutationObserver() {
  pushMutations(observer.takeRecords());
  redoStack = [];
  if (mutStack.length > 0) {
    modified = true;
    undoStack.push(mutStack);
    mutStack = [];
    compToInsp();
  }
  observing = false;
}








function makeSVG(tag, attrs) {
  var el = document.createElementNS('http://www.w3.org/2000/svg', tag);
  for (var k in attrs)
    el.setAttribute(k, attrs[k]);
  return el;
}

jQuery.fn.vseInspectorBind = _vseInspectorBind; 
function _vseInspectorBind(attributeName) {
  var prop = $(this); 
  prop.attr("data-attribute", attributeName);
  
  function _propToAttr() {
    // warn/confirm (attributeName == "data-category")
    
    startMutationObserver();
    try {
      var newValue = prop.val();
      var $selSeats = $(".vse-selected"); 
      
      if (attributeName != "data-category") {
        $selSeats.each(function() {
          var $seat = $(this);
          if (newValue != $seat.attr(attributeName)) {
            $seat.attr(attributeName, newValue);

            if (["x", "y", "width", "height", "data-break", "data-rotation"].indexOf(attributeName) >= 0) 
              $seat.vseUpdateSeatDims();
            
            if (attributeName == "width")
              lastSeatWidth = parseInt($seat.attr(attributeName));
            else if (attributeName == "height")
              lastSeatHeight = parseInt($seat.attr(attributeName));
          }
        });
      }
      else {
        // Backup previous "nextId" and "break" values
        $selSeats.each(function() {
          var $seat = $(this);
          $seat.attr(attributeName, newValue);
          $seat.attr("data-oldnextid", $seat.attr("data-nextseatid"));
          $seat.attr("data-oldbreak", $seat.attr("data-break"));
        });
        
        // Recover join gaps in old category
        $selSeats.each(function() {
          var $seat = $(this);
          var seatId = $seat.attr("id");
          var nextId = $seat.attr("data-nextseatid");
          var $next = $(".vse-seat#" + nextId);
          var $prev = $(".vse-seat[data-nextseatid='" + seatId + "']");
//          var seatBreak = parseInt($seat.attr("data-break"));
//          var prevBreak = parseInt($prev.attr("data-break"));
          $prev.attr("data-nextseatid", nextId);
          $prev.attr("data-break", LkSNSeatBreakType_Disjunction);
          $seat.removeAttr("data-nextseatid");

          $seat.vseUpdateSeatDims();
          $next.vseUpdateSeatDims();
          $prev.vseUpdateSeatDims();
        });

        // Filling "heads" and "tails"
        $selSeats.each(function() {
          var $seat = $(this);
          var nextId = $seat.attr("data-oldnextid");
          var $next = $selSeats.filter("#" + nextId);

          if ($next.length > 0) {
            $seat.attr("data-nextseatid", nextId);
            $seat.attr("data-break", $seat.attr("data-oldbreak"));
            $seat.vseUpdateSeatDims();
            $next.vseUpdateSeatDims();
          }
        });

        renderCategoryConfig();
      }

    }
    finally {
      stopMutationObserver();
    }
  }
  
  prop.change(_propToAttr);
}

function getMultiValue(sels, attrName) {
  if (sels.length == 1)
    return sels.attr(attrName);
  else {
    var result = null;
    sels.each(function() {
      var value = $(this).attr(attrName);
      if (result == null)
        result = value;
      else if (result != value)
        result = "";
    });
    return result;
  }
}

function compToInsp() {
  var viewType = $(".vse-map").attr("data-viewtype");
  var sels = $(".vse-selected");
  var mapSelected = sels.is(".vse-map");
  $("#doc-prop").setClass("v-hidden", !mapSelected || (viewType != "cat"));

  var seatSelected = sels.is(".vse-seat");
  $("#item-prop").setClass("v-hidden", !seatSelected);
  
  $("#catstatus-prop").setClass("v-hidden", seatSelected);
  $("#seatstatus-prop").setClass("v-hidden", seatSelected || (viewType != "status"));
  
  $(".vse-item-prop").each(function() {
    var prop = $(this);
    var propValue = prop.val();
    var attrName = prop.attr("data-attribute");
    if (attrName && (attrName != "")) {
      var newValue = getMultiValue(sels, attrName);
      if (propValue != newValue)
        prop.val(newValue);
    }
  });
  
  var seatsels = sels.filter(".vse-seat");
  $("#prop-seat-selcount").val(seatsels.length);
  if (mapInitialized) {
    var readOnly = !$(".vse-map").vseIsMapEditable();
    $("#btn-undo").button("option", "disabled", readOnly || (undoStack.length == 0));
    $("#btn-redo").button("option", "disabled", readOnly || (redoStack.length == 0));
    $("#btn-newseat-up").button("option", "disabled", readOnly);
    $("#btn-newseat-down").button("option", "disabled", readOnly);
    $("#btn-newseat-rect").button("option", "disabled", readOnly);
    $("#btn-delseat").button("option", "disabled", readOnly || (seatsels.length == 0));
    //$("#btn-lasso").button("option", "disabled", readOnly);
    $("#btn-select").button("option", "disabled", (seatsels.length != 1));
    $("#btn-break").button("option", "disabled", readOnly || (seatsels.length == 0));
    $("#btn-join").button("option", "disabled", readOnly);
    $("#btn-align").button("option", "disabled", readOnly || (seatsels.length < 2) || (seatsels.length > 3));
    $("#btn-invert").button("option", "disabled", readOnly || (seatsels.length != 1));
    $("#btn-sectors").button("option", "disabled", <%=!canEdit%>);
  }
}

jQuery.fn.vseInitSeat = _vseInitSeat; 
function _vseInitSeat() {
  var $this = $(this);  
  $this.draggable({
    cursor: "move",
    start: function(event, ui) {
      var seat = $(this);
      seat.data("old-position", ui.position);
      if (!seat.is(".vse-selected")) {
        $(".vse-selected").removeClass("vse-selected");
        $(this).addClass("vse-selected");
      }
      startMutationObserver();
    },
    drag: function(event, ui) {
      if (!$(".vse-map").vseIsMapEditable())
        return false;
      else {
        var seat = $(this);
        var oldpos = seat.data("old-position");
        var dx = ui.position.left - oldpos.left;
        var dy = ui.position.top - oldpos.top;
        seat.data("old-position", ui.position);
        
        $(".vse-seat.vse-selected").each(function() {
          var seat = $(this);
          seat.attr("x", parseFloat(seat.attr("x")) + (dx * 100 / zoom));
          seat.attr("y", parseFloat(seat.attr("y")) + (dy * 100 / zoom));
          seat.vseUpdateSeatDims();
        });
      }
    },
    stop: function() {
      stopMutationObserver();
      compToInsp();
    }
  }).click(function(event) {
    var seat = $(this);
    if (event.ctrlKey) 
      seat.toggleClass("vse-selected");
    else {
      $(".vse-selected").removeClass("vse-selected");
      seat.addClass("vse-selected");
    }
    event.stopPropagation();
    compToInsp();
  });
  
  <% if (!map.PerformanceId.isNull()) { %>
    $this.each(function(idx, elem) {
      var $elem = $(elem);
      $elem.addClass("v-tooltip v-tooltip-nocache").attr("data-jsp", "seat/seat_tooltip&PerformanceId=" + <%=map.PerformanceId.getJsString()%> + "&SeatId=" + $elem.attr("id"));
    });
  <% } %>
  
  compToInsp();
  return $(this);
}

jQuery.fn.vseGetSeatCenter = _vseGetSeatCenter;
function _vseGetSeatCenter() {
  var seat = $(this);
  return {
    "x": strToFloatDef(seat.attr("x"), 0) + (strToFloatDef(seat.attr("width"), 0) / 2), 
    "y": strToFloatDef(seat.attr("y"), 0) + (strToFloatDef(seat.attr("height"), 0) / 2) 
  };
}

jQuery.fn.vseUpdateSeatDims = _vseUpdateSeatDims; 
function _vseUpdateSeatDims() {
  $(this).each(function() {
    var seat = $(this);
    var x = strToFloatDef(seat.attr("x"), 0);
    var y = strToFloatDef(seat.attr("y"), 0);
    var w = strToFloatDef(seat.attr("width"), 0);
    var h = strToFloatDef(seat.attr("height"), 0);
    var r = strToFloatDef(seat.attr("data-rotation"), 0);
    
    var cx = x + (w / 2);
    var cy = y + (h / 2);
    var trans = "rotate(" + r + ", " + cx + ", " + cy + ")";
    if (seat.attr("transform") != trans)
      seat.attr("transform", trans);
    
    var id = seat.attr("id");
    var nextId = seat.attr("data-nextseatid");
    
    var srcLine = $(".vse-seat-line[data-srcseatid='" + id + "']");
    srcLine.attr("x1", cx);
    srcLine.attr("y1", cy);
    srcLine.setClass("v-hidden", !(nextId) || (nextId == ""));
    srcLine.setClass("break-row", seat.attr("data-break") == LkSNSeatBreakType_ChangeRow);
    srcLine.setClass("break-dis", seat.attr("data-break") == LkSNSeatBreakType_Disjunction);

    var prevSeatId = $(".vse-seat[data-nextseatid='" + id + "']").attr("id");
    var dstLine = $(".vse-seat-line[data-srcseatid='" + prevSeatId + "']");
    dstLine.attr("x2", cx);
    dstLine.attr("y2", cy);
    dstLine.removeClass("v-hidden");
  });
  return $(this);
}

jQuery.fn.vseIsMapEditable = _vseIsMapEditable;
function _vseIsMapEditable() {
  return <%=canEdit%> && ($(this).attr("data-viewtype") == "cat");
}

jQuery.fn.vseCreateSeat = _vseCreateSeat; 
function _vseCreateSeat(delta) {
  var map = $(this);
  var id = newStrUUID();
  var x = ($(".vse-desktop").scrollLeft() * 100 / zoom) + 10;
  var y = ($(".vse-desktop").scrollTop() * 100 / zoom) + 10;
  delta = isNaN(parseInt(delta)) ? 1 : parseInt(delta);

  var prevSeat = null;
  var sels = map.find(".vse-seat.vse-selected");
  var col = "";
  $(".vse-selected").removeClass("vse-selected");
  if (sels.length > 0) {
    prevSeat = sels.last();
    prevSeat.attr("data-nextseatid", id);
    
    var prevCol = parseInt(prevSeat.attr("data-col"));
    if (!isNaN(prevCol))
      col = prevCol + delta;
    
    var prevSeatId = prevSeat.attr("id");
    $(".vse-seat-line[data-srcseatid='" + prevSeatId + "']").attr("data-dstseatid", id).removeClass("v-hidden");
    
    var px = parseFloat(prevSeat.attr("x"));
    var py = parseFloat(prevSeat.attr("y"));
    var superSeat = map.find(".vse-seat[data-nextseatid='" + prevSeatId + "']");
    if (superSeat.length == 0) {
      x = px + parseFloat(prevSeat.attr("width")) + 5;
      y = py;
    }
    else {
      superSeat = superSeat.last();
      x = px + (px - parseFloat(superSeat.attr("x")));
      y = py + (py - parseFloat(superSeat.attr("y")));
    }
  }      

  var seat = $(makeSVG("rect", {
    "id": id,
    "class": "vse-seat vse-selected", 
    "rx": 2,
    "ry": 2,
    "x": x,
    "y": y,
    "width": (prevSeat == null) ? lastSeatWidth : prevSeat.attr("width"),
    "height": (prevSeat == null) ? lastSeatHeight : prevSeat.attr("height"),
    "data-rotation": (prevSeat == null) ? 0 : prevSeat.attr("data-rotation"),
    "data-category": (prevSeat == null) ? "" : prevSeat.attr("data-category"),
    "data-sector": (prevSeat == null) ? "" : prevSeat.attr("data-sector"),
    "data-envelope": (prevSeat == null) ? "" : prevSeat.attr("data-envelope"),
    "data-weight": (prevSeat == null) ? "" : prevSeat.attr("data-weight"),
    "data-row": (prevSeat == null) ? "" : prevSeat.attr("data-row"),
    "data-col": col,
    "data-aisleleft": false,
    "data-aisleright": false,
    "data-break": 0
  })).appendTo(map.find(".vse-seat-container")).vseInitSeat();

  $(makeSVG("line", {
    "class": "vse-seat-line v-hidden",
    "data-srcseatid": id, 
    "data-dstseatid": ""
  })).appendTo(map.find(".vse-line-container"));
  
  seat.vseUpdateSeatDims();
  compToInsp();
  renderCategoryConfig();

  return seat;
}

jQuery.fn.vseDeleteSeat = _vseDeleteSeat; 
function _vseDeleteSeat(delta) {
  $(this).each(function() {
    var seat = $(this);
    var id = seat.attr("id");
    $(".vse-seat-line[data-srcseatid='" + id + "']").remove();
    $(".vse-seat[data-nextseatid='" + id + "']").attr("data-nextseatid", "").vseUpdateSeatDims();
    seat.remove();
  });
  renderCategoryConfig();
}

jQuery.fn.vseBreakLinkAfter = _vseBreakLinkAfter;
function _vseBreakLinkAfter() {
  var seats = $(this);
  seats.each(function() {
    var seat = $(this);
    seat.attr("data-nextseatid", "");
    seat.parents(".vse-map").find(".vse-seat-line[data-srcseatid='" + seat.attr("id") + "']").attr("data-dstseatid", "");
    seat.vseUpdateSeatDims();
  });
  return seats;
}

jQuery.fn.vseFindNextSeat = _vseFindNextSeat;
function _vseFindNextSeat() {
  var nextSeatId = getNull($(this).attr("data-nextseatid"));
  if (nextSeatId != null) {
    var next = $("#" + nextSeatId);
    if (next.length > 0)
      return next;
  }
  return null; 
}

jQuery.fn.vseFindPrevSeat = _vseFindPrevSeat;
function _vseFindPrevSeat() {
  var prev = $(".vse-seat[data-nextseatid='" + $(this).attr("id") + "']");
  return (prev.length == 0) ? null : prev; 
}

jQuery.fn.vseIsBefore = _vseIsBefore;
function _vseIsBefore(seat) {
  if ($(this).attr("id") != seat.attr("id")) {
    var x = $(this);
    while (x != null) {
      x = x.vseFindNextSeat();
      if ((x != null) && (x.attr("id") == seat.attr("id"))) 
        return true;
    }
  }
  return false;
}

function getSlope(x1, y1, x2, y2) {
  return (y1 - y2) / (x1 - x2);
}

function getCircle(x1, y1, x2, y2, x3, y3) {
  if (y1 == y2 || x1 == x2) { // division by 0
      var tx = x1;
      var ty = y1;
      x1 = x3;
      y1 = y3;
      x3 = tx;
      y3 = ty;
  }

  var mr = getSlope(x1, y1, x2, y2);
  var mt = getSlope(x3, y3, x2, y2);
  var triangle_area = x1 * (y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2);
  if ((mr == mt) || (triangle_area == 0))
    throw "Seats cannot be on the same line for arc seat distribution";
  
  var x = (mr * mt * (y3 - y1) + mr * (x2 + x3) - mt * (x1 + x2)) / (2 * (mr - mt));
  var y = -1 / mr * (x - (x1 + x2) / 2) + (y1 + y2) / 2;
  var r = Math.sqrt(Math.pow(x1 - x, 2) + Math.pow(y1 - y, 2));
  return {x: x, y: y, r: r};
}

function toDegrees (angle) {
  return angle * (180 / Math.PI);
}

function toRadians (angle) {
  return angle * (Math.PI / 180);
}

function getSectorPoints(n, x1, y1, x2, y2, x3, y3) {
  var circle = getCircle(x1, y1, x2, y2, x3, y3);
  var dx = x1 - circle.x;
  var dy = circle.y - y1; // swap to move from screen coordinates to cartesian
  var radianFrom = (Math.atan2(dy, dx) + Math.PI * 2) % (Math.PI * 2);
  dx = x2 - circle.x;
  dy = circle.y - y2;
  var radianMiddle = (Math.atan2(dy, dx) + Math.PI * 2) % (Math.PI * 2);
  dx = x3 - circle.x;
  dy = circle.y - y3;
  var radianTo = (Math.atan2(dy, dx) + Math.PI * 2) % (Math.PI * 2);  
  
  var radian = radianFrom;
  var step;
  
  // first point is always in result
  var result = [];
  
  if (radianFrom > radianMiddle) {
    if (radianFrom > radianTo) {
      if (radianMiddle > radianTo) { // clockwise
      step = (radianTo - radianFrom) / (n - 1);
      } else { // counter clockwise
        step = (2 * Math.PI + radianTo - radianFrom) / (n - 1);
      }
    } else { // counter clockwise
      step = -(2 * Math.PI + radianFrom - radianTo) / (n - 1);
    }
  } else {
    if (radianFrom > radianTo) { // counter clockwise
      step = (2 * Math.PI + radianTo - radianFrom) / (n - 1);
    } else if (radianTo > radianMiddle) { // counter clockwise
      step = (radianTo - radianFrom) / (n - 1);
    } else { // clocwise
      step = (2 * Math.PI + radianFrom - radianTo) / (n - 1);
    }
  }
  //console.log('from, to, step, middle', radianFrom, radianTo, step, radianMiddle);
  
  for (var i = 0; i < n; ++i) {
    var x = Math.cos(radian) * circle.r + circle.x;
    var y = circle.y - Math.sin(radian) * circle.r;
    var rot = (toDegrees(radian) - 90) * -1;
    result.push({"x": x, "y": y, "rot": rot});
    radian += step;
  }
  
  // last point is always in result
  //result.push({"x": x3, "y": y3, "rot": 0});
  return result;
}

jQuery.fn.vseAlignSeats = _vseAlignSeats;
function _vseAlignSeats() {
  var seats = $(this); 
  if (seats.length == 2) {
    var first = seats.first();
    var last = seats.last();
    if (last.vseIsBefore(first)) {
      var x = first;
      first = last;
      last = x;
    }

    var cnt = 0;
    var seat = first;
    while ((seat != null) && (seat.attr("id") != last.attr("id"))) {
      seat = seat.vseFindNextSeat();
      cnt++;
    }
    
    if (cnt > 0) {
      var fx = parseFloat(first.attr("x"));
      var fy = parseFloat(first.attr("y"));
      var dx = (parseFloat(last.attr("x")) - fx) / cnt;  
      var dy = (parseFloat(last.attr("y")) - fy) / cnt;
  
      var idx = 1;
      var seat = first.vseFindNextSeat();
      while (seat.attr("id") != last.attr("id")) {
        seat.attr("x", fx + dx * idx);
        seat.attr("y", fy + dy * idx);
        seat.vseUpdateSeatDims();
        seat = seat.vseFindNextSeat();
        idx++;
      }
    }
  }
  else if (seats.length == 3) {
    seats.sort(function(a, b) {
      return $(a).vseIsBefore($(b)) ? -1 : 1;
    });
    
    var fst = $(seats[0]);
    var mid = $(seats[1]);
    var lst = $(seats[2]);
    
    var x1 = parseFloat(fst.attr("x"));
    var y1 = parseFloat(fst.attr("y"));
    var x2 = parseFloat(mid.attr("x"));
    var y2 = parseFloat(mid.attr("y"));
    var x3 = parseFloat(lst.attr("x"));
    var y3 = parseFloat(lst.attr("y"));
    
    var arr = [fst]; 
    var seat = fst;
    while ((seat != null) && (seat.attr("id") != lst.attr("id"))) {
      seat = seat.vseFindNextSeat();
      arr.push(seat);
    }
    
    var points = [];
    try {
      points = getSectorPoints(arr.length, x1, y1, x2, y2, x3, y3);
    }
    catch(err) {
      showIconMessage("warning", err);
    }

    if (points.length == arr.length) {
      for (var i=0; i<arr.length; i++) {
        var p = points[i];
        var seat = $(arr[i]);
        seat.attr("x", p.x);
        seat.attr("y", p.y);
        seat.attr("data-rotation", p.rot);
        seat.vseUpdateSeatDims();
      }
    }
  }
  else
    showIconMessage("warning", "Please select only 2 or 3 seats");
}

jQuery.fn.vseInvertDirection = _vseInvertDirection;
function _vseInvertDirection() {
  // Find last seat
  var last = $(this);
  var next = null;
  while ((next = last.vseFindNextSeat()) != null)
    last = next;
  
  // Fill ordered array
  var seats = [];
  var seat = last;
  while (seat != null) {
    seats.push(seat);
    seat = seat.vseFindPrevSeat();
  }
  
  // Reorder seats
  for (var i=0; i<seats.length; i++) {
    var seat = seats[i];
    var nextId = (i+1 < seats.length) ? seats[i+1].attr("id") : "";
    seat.attr("data-nextseatid", nextId);
    $(".vse-seat-line[data-srcseatid='" + seat.attr("id") + "']").attr("data-dstseatid", nextId);
    seat.vseUpdateSeatDims();
  }
}


var zoom_values = [10,20,30,40,50,60,70,80,90,100,130,160,190,220,250,280,310,340,370,400]
var zoom = 100;

function setZoom(value) {
  zoom = value;
  $(".vse-slider-value").text(zoom + "%");
  $(".vse-map .gseat").attr("transform", "scale(" + (zoom/100) + ")");
}

var mapInitialized = false;

$(document).ready(initMap);
function initMap() {
  $(".vse-map").addClass("vse-selected");
  compToInsp();
  
  $(".vse-desktop").click(function() {
    $(".vse-seat").removeClass("vse-selected");
    $(".vse-map").addClass("vse-selected");
    compToInsp();
  }).on("mousewheel", function(event) {
    if (event.ctrlKey) {
      var idx = zoom_values.indexOf(zoom) + event.deltaY;
      setZoom(zoom_values[Math.max(0, Math.min(19, idx))]);
      $(".vse-slider").slider("value", idx + 1);
      event.preventDefault();
    }
  });

  $(".vse-map").selectable({
    filter: ".vse-seat",
    selecting: function(event, ui) {
      $(ui.selecting).addClass("vse-selecting");
    },
    start: function() {
      $(document).trigger("click");
    },
    stop: function(event, ui) {
      if ($("#btn-newseat-rect").is(".selected")) {
        $("#btn-newseat-rect").removeClass("selected");
        var r = $(".ui-selectable-helper");
        var d = $(".vse-desktop");
        var x = (r.offset().left - d.offset().left + d.scrollLeft()) * 100 / zoom;
        var y = (r.offset().top - d.offset().top + d.scrollTop()) * 100 / zoom;
        var w = r.outerWidth() * 100 / zoom;
        var h = r.outerHeight() * 100 / zoom;
        showNewSeatRectDialog(x, y, w, h);
      }
      else {
        if (!event.ctrlKey)
          $(".vse-selected").removeClass("vse-selected");
        $(this).find(".vse-selecting").addClass("vse-selected").removeClass("vse-selecting");
        if ($(".vse-seat.vse-selected").length == 0)
          $(".vse-map").addClass("vse-selected");
        compToInsp(); 
      }
    }
  });

  $(".vse-seat").vseInitSeat();
  
  $(".vse-slider").slider({
    min: 1,
    max: 20,
    value: 10,
    slide: function() {
      setTimeout(function() {
        setZoom(zoom_values[parseInt($(".vse-slider").slider("value")) - 1])
      }, 100);
    }
  });
  
  var $selViewType = $("<%=map.PerformanceId.isNull() ? "#radio-viewtype-cat" : "#radio-viewtype-status"%>");
  $selViewType.prop("checked", true);
  $selViewType.closest("label").addClass("active");
  
  $(".buttonset").buttonset();
  $("[name='radio-viewtype']").change(applyViewType);
  applyViewType();


  $("#prop-seat-row").vseInspectorBind("data-row");
  $("#prop-seat-col").vseInspectorBind("data-col");
  
  $("#prop-seat-category").vseInspectorBind("data-category");
  $("#prop-seat-sector").vseInspectorBind("data-sector");
  $("#prop-seat-envelope").vseInspectorBind("data-envelope");
  $("#prop-seat-weight").vseInspectorBind("data-weight");
  $("#prop-seat-aisleleft").vseInspectorBind("data-aisleleft");
  $("#prop-seat-aisleright").vseInspectorBind("data-aisleright");
  $("#prop-seat-break").vseInspectorBind("data-break");

  $("#prop-seat-x").vseInspectorBind("x");
  $("#prop-seat-y").vseInspectorBind("y");
  $("#prop-seat-width").vseInspectorBind("width");
  $("#prop-seat-height").vseInspectorBind("height");
  $("#prop-seat-rotation").vseInspectorBind("data-rotation");
  
  renderCategoryConfig();
  refreshSectorStyle();
  mapInitialized = true;
  
  compToInsp();
}

$(document).keydown(onKeyDown);
function onKeyDown(event) {
  if ((event.keyCode == KEY_BACKSPACE) && ($('input:focus').length == 0)) {
    event.preventDefault();
    event.stopPropagation();
  }
  
  if ($(".vse-map").vseIsMapEditable() && !observing) {
    if ((event.keyCode == KEY_ESC) && ($(".vgs-line-canvas").length > 0)) {
      $(".vgs-line-canvas").remove();
    }
    else if ((event.keyCode == KEY_ENTER) && $(event.target).is(".sector-name")) {
      doAddSector();
    }
    else if (event.ctrlKey && (String.fromCharCode(event.keyCode).toUpperCase() == "Z")) {
      event.preventDefault();
      event.stopPropagation();
      vseAction_Undo();
    }
    else if (event.ctrlKey && (String.fromCharCode(event.keyCode).toUpperCase() == "Y")) {
      event.preventDefault();
      event.stopPropagation();
      vseAction_Redo();
    }
    else if (event.ctrlKey && (String.fromCharCode(event.keyCode).toUpperCase() == "B")) {
      event.preventDefault();
      event.stopPropagation();
      vseAction_BreakLink();
    }
    else if (event.ctrlKey && (String.fromCharCode(event.keyCode).toUpperCase() == "J")) {
      event.preventDefault();
      event.stopPropagation();
      startLineDraw();
    }
    else if (event.ctrlKey && (String.fromCharCode(event.keyCode).toUpperCase() == "A")) {
      event.preventDefault();
      event.stopPropagation();
      vseAction_AlignSeats();
    }
    else if (event.ctrlKey && (String.fromCharCode(event.keyCode).toUpperCase() == "U")) {
      event.preventDefault();
      event.stopPropagation();
      vseAction_InvertDirection();
    }
    else if ((event.ctrlKey || event.shiftKey) && ($(":focus").length == 0) && ([KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT].indexOf(event.keyCode) >= 0)) {
      startMutationObserver();
      try {
        var delta = event.shiftKey ? 2 : 0.25;
        var dx = (event.keyCode == KEY_RIGHT) ? delta : (event.keyCode == KEY_LEFT) ? -delta : 0;         
        var dy = (event.keyCode == KEY_DOWN) ? delta : (event.keyCode == KEY_UP) ? -delta : 0;  
        $(".vse-seat.vse-selected").each(function() {
          var seat = $(this);
          seat.attr("x", parseFloat(seat.attr("x")) + dx);
          seat.attr("y", parseFloat(seat.attr("y")) + dy);
          seat.vseUpdateSeatDims();
          compToInsp();
        });
        event.preventDefault();
        event.stopPropagation();
      }
      finally {
        stopMutationObserver();
      }
    }
    else if (($("input:focus").length == 0) && (event.keyCode == KEY_DELETE)) {
      event.preventDefault();
      event.stopPropagation();
      vseAction_DeleteSeat();
    }
  }
}

function vseSeatFromPoint(x, y) {
  var result = null;
  var res = [];
  
  var ele = document.elementFromPoint(x, y);
  while (ele && (ele.tagName != "BODY") && (ele.tagName != "HTML") && !$(ele).is(".vse-map")) {
    res.push(ele);
    $(ele).addClass("vse-line-canvas-hidetrick");
    ele = document.elementFromPoint(x, y);
    if ($(ele).is(".vse-seat")) {
      result = $(ele);
      break;
    }
  }

  $(res).removeClass("vse-line-canvas-hidetrick");

  return result;
}

function startLineDraw() {
  startMutationObserver();
  $(".vse-selected").removeClass("vse-selected");
  var lineCanvas = $("<svg class='vse-line-canvas' width='10000' height='10000'/>").appendTo("body");
  var lineElem = $(makeSVG("line", {})).appendTo(lineCanvas);
  var oldX = null;
  var oldY = null;
  var overElem = null;
  var startPoint = null;
  var startElem = null;
  
  lineCanvas
      .mousemove(function(event) {
        if ((event.pageX != oldX) || (event.pageY != oldY)) {
          oldX = event.pageX;
          oldY = event.pageY;
          var elem = vseSeatFromPoint(oldX, oldY);
          if (elem != overElem) {
            if (overElem != null) 
              overElem.removeClass("vse-dragdrop-over");
            if (elem != null) 
              elem.addClass("vse-dragdrop-over");
            overElem = elem;
          }

          if (startPoint != null) {
            lineElem.attr("x1", startPoint.x);
            lineElem.attr("y1", startPoint.y);
            lineElem.attr("x2", oldX);
            lineElem.attr("y2", oldY);
          }
        }
      })
      .mousedown(function(event) {
        startPoint = {"x":event.pageX,"y":event.pageY};
        startElem = overElem;
        if (startElem != null)
          startElem.addClass("vse-dragdrop-start");
      })
      .mouseup(function(event) {
        lineCanvas.remove();
        var endElem = overElem;
        if (startElem != null) 
          startElem.removeClass("vse-dragdrop-over").removeClass("vse-dragdrop-start");
        if (endElem != null) 
          endElem.removeClass("vse-dragdrop-over");
        if ((startElem != null) && (endElem != null)) {
          var srcId = startElem.attr("id");
          var dstId = endElem.attr("id");
          var srcSeat = $("#" + srcId); 
          var dstSeat = $("#" + dstId); 
          var join = true;
          
          if ($(".vse-seat[data-nextseatid='" + dstId + "']").length > 0) {
            join = false;
            showIconMessage("warning", <v:itl key="@Seat.JoinSeatDestinationError" encode="JS"/>); 
          }
          else if (srcSeat.attr("data-Category") != dstSeat.attr("data-Category")) {
            join = false;
            showIconMessage("warning", <v:itl key="@Seat.JoinSeatIncompatibleError" encode="JS"/>); 
          }
          else {
            function getNextSeatId(seat) {
              var result = seat.attr("data-nextseatid");
              return (result && (result != "")) ? result : null;
            }
            
            var nextSeat = endElem;
            while (join && (getNextSeatId(nextSeat) != null)) {
              var nextSeatId = getNextSeatId(nextSeat);
              if (nextSeatId != startElem.attr("id")) 
                nextSeat = $("#" + nextSeatId);
              else {
                join = false;
                showIconMessage("warning", <v:itl key="@Seat.CircularReferenceError" encode="JS"/>); 
              }
            }
          }
          
          if (join) {
            startElem.attr("data-nextseatid", dstId);
            $(".vse-seat-line[data-srcseatid='" + srcId + "']").attr("data-dstseatid", dstId);
            if (srcSeat.attr("data-Sector") != dstSeat.attr("data-Sector"))
              srcSeat.attr("data-break", LkSNSeatBreakType_Disjunction);
            startElem.vseUpdateSeatDims();
            endElem.vseUpdateSeatDims();
          }
        }
        
        stopMutationObserver();
      });
}

function repositoryPickupCallback(id) {
  $(".vse-map").attr("data-backgroundrepositoryid", id);
  $(".vse-background-image").attr("xlink:href", "<v:config key="site_url"/>/repository?id=" + id);
  resizeBackgroundImage();
}

function resizeBackgroundImage() {
  var svg_img = $(".vse-background-image");
  var urlo = svg_img.attr("xlink:href");
  if (urlo && (urlo != "")) {
    var img = new Image();
    img.src = urlo;
    img.onload = function() {
      svg_img.attr('height', this.height).attr('width', this.width);
    };
  }
}
$(document).ready(resizeBackgroundImage);

function recursiveUpdateSeqNumber(seat, index) {
  seat.attr("data-seqnumber", index);
  var nextSeatId = seat.attr("data-nextseatid");
  if ((nextSeatId) && (nextSeatId != "")) {
    var next = $("#" + nextSeatId);
    if (next.length > 0)
      recursiveUpdateSeqNumber(next, index + 1);
  }
}

function doSaveMap(callback) {
  showWaitGlass();
  var map = {
    SeatMapId: <%=map.SeatMapId.getJsString()%>,
    AccessAreaId: <%=map.AccessAreaId.getJsString()%>,
    SeatSectorId: <%=map.SeatSectorId.getJsString()%>,
    PerformanceId: <%=map.PerformanceId.getJsString()%>,
    SeatMapName: $("#prop-map-name").val(),
    BackgroundRepositoryId: $(".vse-map").attr("data-backgroundrepositoryid"),
    SectorList: [],
    SeatList: []
  };
  
  // Check for empty categories
  var null_category_seats = [];
  $(".vse-seat").each(function() {
    var seat = $(this);
    var cat = seat.attr("data-category");
    if (!(cat) || (cat == ""))
      null_category_seats.push(seat);
  });
  if (null_category_seats.length > 0) {
    $(".vse-selected").removeClass("vse-selected");
    $(null_category_seats).addClass("vse-selected");
    compToInsp();
    hideWaitGlass();
    showIconMessage("warning", itl("@Seat.MissingCategoryError", null_category_seats.length)); 
    return;
  }

  // Check for duplicated first seats
  var dup_first_seats = [];
  var first_seats = [];
  var misjoin_seats = [];
  $(".vse-seat").each(function(idx, seat) {
    seat = $(seat);
    var seatName = seat.attr("data-row") + " " + seat.attr("data-col");
    if ($(".vse-seat[data-nextseatid='" + seat.attr("id") + "']").length == 0) {
      $(first_seats).each(function(idxFirst, first) {
        first = $(first);
        if (first.attr("data-category") == seat.attr("data-category")) {
          dup_first_seats.push(seat);
          misjoin_seats.push(seat);
          misjoin_seats.push(first);
        }
      });
      first_seats.push(seat);
      recursiveUpdateSeqNumber(seat, 0);
    }
  });

  if (dup_first_seats.length > 0) {
    $(".vse-seat-misjoin").removeClass("vse-seat-misjoin");
    $(misjoin_seats).each(function(idx, dup) {
      $(dup).addClass("vse-seat-misjoin");
    });
    setRadioChecked("[name='radio-viewtype']", "mis");
    $(".vse-map").attr("data-viewtype", "mis");
    $(".buttonset").buttonset("refresh");
    hideWaitGlass();
    showIconMessage("warning", <v:itl key="@Seat.MissingJoinError" encode="JS" param1="%1"/>.replace("%1", dup_first_seats.length)); 
    return;
  }
  
  $(".vse-seat").each(function() {
    var seat = $(this);
    map.SeatList.push({
      SeatId: seat.attr("id"),
      X: seat.attr("x"),
      Y: seat.attr("y"),
      Width: seat.attr("width"),
      Height: seat.attr("height"),
      SeatSectorId: seat.attr("data-sector"),
      SeatCategoryId: seat.attr("data-category"),
      SeatEnvelopeId: seat.attr("data-envelope"),
      Row: seat.attr("data-row"),
      Col: seat.attr("data-col"),
      Weight: seat.attr("data-weight"),
      SeqNumber: seat.attr("data-seqnumber"),
      Rotation: seat.attr("data-rotation"),
      AisleLeft: seat.attr("data-aisleleft"),
      AisleRight: seat.attr("data-aisleright"),
      BreakType: seat.attr("data-break")
    });
  });
  
  $("#prop-seat-sector option").each(function() {
    var id = $(this).val();
    if (id && (id != "")) {
      map.SectorList.push({
        SectorId: id,
        SectorName: $(this).text()
      });
    }
  });
  
  var reqDO = {
    Command: "SaveMap",
    SaveMap: {
      SeatMap: map
    }
  };
  
  vgsService("Seat", reqDO, false, function(ansDO) {
    hideWaitGlass();
    modified = false;
    triggerEntityChange(<%=LkSNEntityType.SeatSector.getCode()%>);
    if (map.PerformanceId != null)
      triggerEntityChange(<%=LkSNEntityType.Performance.getCode()%>, map.PerformanceId);
    if (callback)
      callback();
  });
}

function saveMap() {
  doSaveMap(function() {
    showMessage(<v:itl key="@Common.SaveSuccessMsg" encode="JS"/>);
  });
}

function doCloseMapEditorDialog() {
  $("#seat_map_dialog").dialog("close");
  $("#sectors-dialog").remove();
}

function closeMapEditorDialog() {
  if (modified && <%=canEdit%>) {
    var dlg = $("<div title='SnApp'/>");
    dlg.text(<v:itl key="@Common.SaveChangeConfirm" encode="JS"/>);
    dlg.dialog({
      resizable: false,
      modal: true,
      buttons: {
        <v:itl key="@Common.Save" encode="JS"/>: function() {
          dlg.remove();
          doSaveMap(doCloseMapEditorDialog);
        },
        <v:itl key="@Common.SaveDont" encode="JS"/>: function() {
          dlg.remove();
          doCloseMapEditorDialog();
        },
        <v:itl key="@Common.Cancel" encode="JS"/>: function() {
          dlg.remove();
        }
      }
    });
  } 
  else
    doCloseMapEditorDialog();
}

function showSectorsDialog() {
  var dlg = $("#sectors-dialog");
  dlg.dialog({
    width: 600,
    height: 500,
    modal: true,
    buttons: {
      <v:itl key="@Common.Close" encode="JS"/>: function() {
        dlg.find("tr").not("#tr-newsector").each(function() {
          var id = $(this).attr("data-sectorid");
          var name = $(this).find("input").val();
          var opt = $("#prop-seat-sector option[value='" + id + "']");
          if (opt.length == 0) 
            opt = $("<option value='" + id + "'/>").appendTo("#prop-seat-sector");
          opt.text(name);
        });
        dlg.dialog("close"); 
      }
    }
  });
}

function doAddSector() {
  var txtNewSector = $("#tr-newsector input");
  var newSectorName = txtNewSector.val().trim(); 
  if (newSectorName != "") {
    var id = newStrUUID();
    var tr = $("<tr data-sectorid='" + id + "'/>").insertBefore("#tr-newsector");
    $("<td><div class='color-box'></div></td>").appendTo(tr);
    $("<td><input type='text' class='sector-name'/></td>").appendTo(tr);
    $("<td align='right'><a class='del-link' href='javascript:doDelSector(\"" + id + "\")'></a></td>").appendTo(tr);
    tr.find("input").val(newSectorName);
    tr.find("a").text(<v:itl key="@Common.Delete" encode="JS"/>);
    txtNewSector.val("");
    refreshSectorStyle();
  }
}

function doDelSector(sectorId) {
  confirmDialog(null, function() {
    $("#sectors-dialog tr[data-sectorid='" + sectorId + "']").remove();
    $("#prop-seat-sector option[value='" + sectorId + "']").remove();
    $(".vse-seat[data-sector='" + sectorId + "']").attr("data-sector", "");
    refreshSectorStyle();
  });
}

function refreshSectorStyle() {
  var colors = [
    "#7f7f7f", "#880015", "#ed1c24", "#ff7f27", "#fff200", "#22b14c", "#00a2e8", "#3f48cc", "#a349a4", 
    "#c3c3c3", "#b97a57", "#ffaec9", "#ffc90e", "#efe4b0", "#b5e61d", "#99d9ea", "#7092be", "#c8bfe7"];
  
  var i = 0;
  $("#sector-style").empty();
  $("#sectors-dialog tr").not("#tr-newsector").each(function() {
    var id = $(this).attr("data-sectorid");
    var color = (i < colors.length) ? colors[i++] : "#000000";
    $("#sector-style").append(".vse-map[data-viewtype='sec'] .vse-seat[data-sector='" + id + "'] {fill:" + color + "}");
    $("#sector-style").append("tr[data-sectorid='" + id + "'] .color-box {background-color:" + color + "}");
  });
}

function applyViewType() {
  var viewType = $("[name='radio-viewtype']:checked").val();
  viewType = (viewType && viewType != "") ? viewType : "cat";
  $(".vse-map").attr("data-viewtype", viewType);
  
  if (viewType != "cat")
    $(".vse-selected").removeClass("vse-selected");
  
  if (viewType == "status") 
    doRefreshSeatStatus();
  else
    renderCategoryConfig();
  
  compToInsp();
}

var seatStatusLastUpdate = null;
var optimizedLastUpdate = null;
function doRefreshSeatStatus() {
  var reqDO = {
    Command: "LoadSeatStatus",
    LoadSeatStatus: {
      PerformanceId: <%=map.PerformanceId.getJsString()%>,
      LastUpdate: optimizedLastUpdate,
      IncludeCategoryRecap: true
    }
  };
  
  vgsService("Seat", reqDO, false, function(ansDO) {
    var list = ansDO.Answer.LoadSeatStatus.SeatList;
    if (list) {
      for (var i=0; i<list.length; i++) {
        var status = "free";
        if (list[i].QuantityPaid > 0)
          status = "paid";
        else if (list[i].QuantityReserved > 0)
          status = "reserved";
        else if (list[i].QuantityHeld > 0)
          status = "held";
        
        $("#" + list[i].SeatId).attr("data-status", status);
      }
    }
    
    if ($(".vse-map").attr("data-viewtype") == "status")
      renderCategoryStatus(ansDO.Answer.LoadSeatStatus.CategoryRecap);
    
    if (ansDO.Answer.LoadSeatStatus.LastUpdate) {
      if (seatStatusLastUpdate != ansDO.Answer.LoadSeatStatus.LastUpdate) {
        seatStatusLastUpdate = ansDO.Answer.LoadSeatStatus.LastUpdate;
        optimizedLastUpdate = seatStatusLastUpdate;
      }
      else {
        var dt = xmlToDate(ansDO.Answer.LoadSeatStatus.LastUpdate);
        dt.setMilliseconds(dt.getMilliseconds() + 100);
        optimizedLastUpdate = dateToXML(dt);
      }
    }
    
    if ($("[name='radio-viewtype']:checked").val() == "status")
      setTimeout(doRefreshSeatStatus, 1000);
  });
}

function renderCategoryBar(name, color, value, perc, showPerc) {
  var tr = $("<tr/>").appendTo("#catstatus-tbody");
  var th = $("<th/>").appendTo(tr);
  var td = $("<td align='center'/>").appendTo(tr);
  td.html(value + (showPerc ? "&nbsp;&nbsp;&nbsp;(" + Math.round(perc) + "%)" : ""));
  
  var pb_ext = $("<div class='prgbar-ext'/>").appendTo(td);
  var pb_int = $("<div class='prgbar-int'/>").appendTo(pb_ext);
  pb_int.css("width", perc + "%");
  pb_int.css("background-color", color);
  
  th.text(name);
}

function renderCategoryStatus(recap) {
  $("#catstatus-tbody").empty();
  for (var s=0; s<recap.SectorList.length; s++) {
    var sector = recap.SectorList[s];
    if (sector.SeatMapId == <%=map.SeatMapId.getJsString()%>) {
      for (var c=0; c<sector.CategoryList.length; c++) {
        var cat = sector.CategoryList[c];
        var perc = (100 * (cat.QuantityFree / cat.QuantityMax));
        renderCategoryBar(cat.SeatCategoryName, cat.SeatCategoryColor, cat.QuantityFree, perc, true);
      }
    }
  }
}

function renderCategoryConfig() {
  var viewType = $(".vse-map").attr("data-viewtype");
  if (viewType != "status") {
    var opts = $("#prop-seat-category option");
    var total = 0;
    var cats = [];
    
    for (var i=0; i<opts.length; i++) {
      var opt = $(opts[i]);
      if (opt.val()) {
        var cnt = $(".vse-seat[data-category='" + opt.val() + "']").length;
        if (cnt > 0) {
          total += cnt;
          cats.push({
            name: opt.text(),
            color: $("#prop-seat-category option[value='" + opt.val() + "']").attr("data-color"),
            count: cnt
          });
        }
      }
    }
    
    $("#catstatus-tbody").empty();
    for (var i=0; i<cats.length; i++) 
      renderCategoryBar(cats[i].name, cats[i].color, cats[i].count, 100 * cats[i].count / total, false);
  }
}

function doCreateRect(params) {
  function _doCreateRect() {
    try {
      $(".vse-selected").removeClass("vse-selected");
      var x = params.x;
      var y = params.y;
      var w = params.width;
      var h = params.height;
      var rows = params.rows;
      var cols = params.cols;
      var zigzag = (params.wpattern == "zigzag");
      var lblR2L = (params.cdir == "right-to-left");
      var lblT2B = (params.rdir == "top-to-bottom");
      var dirR2L = (params.hdir == "right-to-left");
      var dirT2B = (params.vdir == "top-to-bottom");
      var rls = (!params.rowlabelstart || (params.rowlabelstart == "")) ? "A" : params.rowlabelstart;
      var cls = isNaN(parseInt(params.collabelstart)) ? 1 : parseInt(params.collabelstart);
      var xd = (cols <= 1) ? 0 : ((w - params.seatwidth) / (cols - 1));
      var yd = (rows <= 1) ? 0 : ((h - params.seatheight) / (rows - 1));
      for (var r=0; r<rows; r++) {
        var evenRow = ((r % 2) == 0);
        for (var c=0; c<cols; c++) {
          var seat = $('.vse-map').vseCreateSeat(1);
          var rowLabelIndex = (dirT2B ^ lblT2B) ? rows - r - 1 : r;
          var colLabelIndex = ((evenRow || zigzag) ^ dirR2L ^ lblR2L) ? (c + 1) : (cols - c);
          seat.attr("x", ((evenRow || zigzag) ^ dirR2L) ? (x + xd * c) : (x + w - params.seatwidth - xd * c));
          seat.attr("y", dirT2B ? y + (yd * r) : (y + h - params.seatheight - yd * r));
          seat.attr("width", params.seatwidth);
          seat.attr("height", params.seatheight);
          seat.attr("data-category", params.category);
          seat.attr("data-sector", params.sector);
          seat.attr("data-envelope", params.envelope);
          seat.attr("data-col", cls + colLabelIndex - 1);
          seat.attr("data-row", rls.substring(0,rls.length-1)+String.fromCharCode(rls.charCodeAt(rls.length-1) + rowLabelIndex));
          seat.attr("data-break", (c + 1 == cols) ? zigzag ? "2" : "1" : "0");
          seat.attr("data-createid", params.id);
          
          seat.vseUpdateSeatDims();
        }
      }
    }
    finally {
      hideWaitGlass();
    }
  }
  
  showWaitGlass();
  setTimeout(_doCreateRect, 100);
}

function showNewSeatRectDialog(x, y, w, h) {
  $("#nsrect-category").html($("#prop-seat-category").html());
  $("#nsrect-sector").html($("#prop-seat-sector").html());
  $("#nsrect-envelope").html($("#prop-seat-envelope").html());
  
  $("#nsrect-dialog").dialog({
    modal: true,
    width: 600,
    height: 710,
    buttons: {
      <v:itl key="@Common.Create" encode="JS"/>: function() {
        var params = {
          type: "create-rect",
          id: newStrUUID(),
          x: x,
          y: y,
          width: w,
          height: h,
          rows: parseInt($("#nsrect-rows").val()),
          cols: parseInt($("#nsrect-cols").val()),
          rowlabelstart: $("#nsrect-rowlabelstart").val(),
          collabelstart: $("#nsrect-collabelstart").val(),
          rdir: $("#nsrect-rdir").val(),
          cdir: $("#nsrect-cdir").val(),
          vdir: $("#nsrect-vdir").val(),
          hdir: $("#nsrect-hdir").val(),
          wpattern: $("#nsrect-wpattern").val(),
          seatwidth: parseInt($("#nsrect-width").val()),
          seatheight: parseInt($("#nsrect-height").val()),
          category: $("#nsrect-category").val(),
          sector: $("#nsrect-sector").val(),
          envelope: $("#nsrect-envelope").val()
        };
        
        $("#nsrect-dialog").dialog("close");
        doCreateRect(params);
        
        mutStack.push(params);
        stopMutationObserver();
      },
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    }
  });
}










function vseAction_Undo() {
  if (undoStack.length > 0) {
    var us = undoStack.pop();
    redoStack.push(us.slice(0));
    while (us.length > 0) {
      var m = us.pop();
      if (m.type == "attributes") 
        $(m.target).attr(m.attributeName, m.oldValue);
      else if (m.type == "create-rect") 
        $(".vse-seat[data-createid='" + m.id + "']").vseDeleteSeat();      
      else if (m.type == "childList") {
        if (m.addedNodes.length > 0) 
          $(m.addedNodes).remove();
        if (m.removedNodes.length > 0) 
          $(m.removedNodes).appendTo(m.target).filter(".vse-seat").vseInitSeat();
      }
    }

    compToInsp();
  }
}

function vseAction_Redo() {
  if (redoStack.length > 0) {
    var us = redoStack.pop();
    undoStack.push(us.slice(0));
    while (us.length > 0) {
      var m = us.pop();
      if (m.type == "attributes") 
        $(m.target).attr(m.attributeName, m.newValue);
      else if (m.type == "create-rect")
        doCreateRect(m);
      else if (m.type == "childList") {
        if (m.addedNodes.length > 0) 
          $(m.addedNodes).appendTo(m.target).filter(".vse-seat").vseInitSeat();
        if (m.removedNodes.length > 0) 
          $(m.removedNodes).remove();
      }
    }
    
    compToInsp();
  }
}

function vseAction_CreateSeat(delta) {
  startMutationObserver();
  try {
    $('.vse-map').vseCreateSeat(delta);
  }
  finally {
    stopMutationObserver();
  }
}

function vseAction_DeleteSeat() {
  startMutationObserver();
  try {
    $(".vse-seat.vse-selected").vseDeleteSeat();
  }
  finally {
    stopMutationObserver();
  }
}

function vseAction_BreakLink() {
  startMutationObserver();
  try {
    $('.vse-seat.vse-selected').vseBreakLinkAfter();
  }
  finally {
    stopMutationObserver();
  }
}

function vseAction_AlignSeats() {
  startMutationObserver();
  try {
    $('.vse-seat.vse-selected').vseAlignSeats();
  }
  finally {
    stopMutationObserver();
  }
}

function vseAction_InvertDirection() {
  startMutationObserver();
  try {
    $('.vse-seat.vse-selected').vseInvertDirection();
  }
  finally {
    stopMutationObserver();
  }
}

function vseAction_Lasso() {
  var lineCanvas = $("<svg class='vse-line-canvas' width='10000' height='10000'/>").appendTo("body");
  var polyElem = $(makeSVG("polyline", {"stroke":"#f00000", "fill":"rgba(0,0,0,0.2)", "stroke-width":"3", "points":""})).appendTo(lineCanvas);
  var points = [];
  var sPoints = "";
  
  function _addPoint(x, y) {
    if (sPoints != "")
      sPoints += " ";
    sPoints += x + "," + y;
    points.push({"x":x, "y":y});
    polyElem.attr("points", sPoints);
  }
  
  function _isPointInPoly(poly, pt) {
    for(var c = false, i = -1, l = poly.length, j = l - 1; ++i < l; j = i)
        ((poly[i].y <= pt.y && pt.y < poly[j].y) || (poly[j].y <= pt.y && pt.y < poly[i].y))
        && (pt.x < (poly[j].x - poly[i].x) * (pt.y - poly[i].y) / (poly[j].y - poly[i].y) + poly[i].x)
        && (c = !c);
    return c;
  }
  
  lineCanvas
      .mousedown(function(event) {
        points = [];
        sPoints = "";
        _addPoint(event.pageX, event.pageY);
      })
      .mousemove(function(event) {
        if (points.length > 0) 
          _addPoint(event.pageX, event.pageY);
      })
      .mouseup(function(event) {
        lineCanvas.remove();
        if (!event.ctrlKey)
          $(".vse-selected").removeClass("vse-selected");
        $(".vse-seat").each(function() {
          var r = this.getBoundingClientRect();
          var pt = {
            x: (r.left + r.right) / 2,
            y: (r.top + r.bottom) / 2
          };
          
          if (_isPointInPoly(points, pt)) 
            $(this).addClass("vse-selected");
        });
        compToInsp();
      });
}

function vseAction_Select(attributeName) {
  var seat = $(".vse-selected").removeClass("vse-selected").first();
  $(".vse-seat[" + attributeName + "='" + seat.attr(attributeName) + "']").addClass("vse-selected");
  compToInsp();
}


</script>