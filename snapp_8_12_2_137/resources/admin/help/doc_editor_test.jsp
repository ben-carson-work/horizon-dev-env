<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageDocEditorTest" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<style>
.editor-desktop {
  position: fixed;
  top: 100px;
  left: 166px;
  right: 200px;
  bottom: 0px;
  background-color: #bbbbbb;
  overflow: scroll;
}

.editor-toolbar {
  position: fixed;
  top: 100px;
  right: 0px;
  bottom: 0px;
  width: 200px;
  background-color: #dfdfdf;
}

.editor-page {
  background-color: white;
  box-shadow: 0 0 10px rgba(0,0,0,0.6);
  margin: 10px auto;
}

.editor-band {
  border-top: 1px #cdcdcd solid;
  border-bottom: 1px #cdcdcd solid;
}

.editor-band-header {
  background-color: #f1f1f1;
  border-bottom: 1px #cdcdcd solid;
  font-weight: bold;
  padding: 3px;
}

</style>

<script>

var dpi = 150;
var uom = "cm";
var zoom = 100;

function measureToPixels(value) {
  if (uom == "cm")
    return Math.round(((value * dpi) / 2.54) * (zoom / 100));

  if (uom == "in")
    return Math.round((value * dpi) * (zoom / 100));

  throw new Exception("Unhandled measure type: " + uom);
}

function recursiveRecalcSizes(comp) {
  comp = (comp) ? comp : ".editor-page";
  var mWidth = $(comp).attr("data-MeasureWidth");
  var mHeight = $(comp).attr("data-MeasureHeight");
  
  if ((mWidth) && (mWidth != ""))
    $(comp).css("width", measureToPixels(mWidth)); 
  
  if ((mHeight) && (mHeight != ""))
    $(comp).css("height", measureToPixels(mHeight)); 
  
  var children = $(comp).children();
  for (var i=0; i<children.length; i++)
    recursiveRecalcSizes(children[i]);
}

$(document).ready(function() {
  recursiveRecalcSizes();
});

function zoomChanged(value) {
  value = parseFloat(value);
  if (!isNaN(value)) {
    zoom = value;
    recursiveRecalcSizes();
  }
}

function addBand() {
  var band = $("<div class=\"editor-band\"/>").appendTo(".editor-page");
  var header = $("<div class=\"editor-band-header\"/>").appendTo(band);
  var body = $("<div class=\"editor-band-body\" data-MeasureHeight=\"3\"/>").appendTo(band);
  
  recursiveRecalcSizes(body);
  
  header.html("band");
}

</script>


<div id="main-container">

<div class="editor-desktop">
  <div class="editor-page" data-MeasureWidth="21" data-MeasureHeight="29.7"></div>
</div>
<div class="editor-toolbar">
  <input type="text" onkeyup="zoomChanged($(this).val())"/><br/>
  <button onclick="addBand()">Add band</button>
</div>

</div>

<jsp:include page="/resources/common/footer.jsp"/>
