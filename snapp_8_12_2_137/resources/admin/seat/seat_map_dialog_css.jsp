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
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request" />

<style>
.ui-selectable-helper {
	border-width: 2px;
  border-color: red;
  background-color: rgba(0,0,0,0.2);
	z-index: 1000;
}

.ui-button.selected .ui-button-text {
  background-color: var(--base-orange-color);
}

.seat_map_dialog_class {
	position: fixed !important;
	top: 10px !important;
	bottom: 10px !important;
	left: 10px !important;
	right: 10px !important;
	width: initial !important;
	border-radius: 0 !important;
}

.seat_map_dialog_class .ui-dialog-content {
	position: absolute;
	top: 0;
	bottom: 0;
	left: 0;
	right: 0;
}

.vse-toolbar {
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	padding: 10px;
	background-color: #eeeeee;
	border-bottom: 1px solid #cccccc;
}

.vse-desktop {
	position: absolute;
	top: 50px;
	left: 300px;
	bottom: 0;
	right: 0;
	overflow: auto;
	background-color: #aaaaaa;
}

.vse-objinsp {
	position: absolute;
	top: 50px;
	left: 0;
	bottom: 0;
	width: 300px;
	background-color: #f8f8f8;
	border-right: 1px solid #cccccc;
}

.vse-map {
	background-color: white;
}

.vse-toolbar .btn-close-dialog {
	position: absolute;
	top: 10px;
	right: 10px;
	width: 30px;
	height: 30px;
	cursor: pointer;
	font-size: 2em;
	opacity: 0.4;
}

.vse-toolbar .btn-close-dialog:hover {
  opacity: 1;
}

.vse-seat {
	stroke: black;
	stroke-width: 0.6;
	fill: white;
}

.vse-seat.vse-selected {
	stroke-dasharray: 3 2;
	stroke-width: 1.5;
}

.vse-seat-line {
	stroke: rgba(0, 0, 0, 0.6);
	stroke-width: 1;
	marker-end: url(#vse-seat-line-end);
  visibility: hidden;
  pointer-events: none;
}

.vse-seat-line.break-row {
  stroke-dasharray: 3 2;
  stroke-width: 1.5;
}

.vse-seat-line.break-dis {
  stroke: red;
  stroke-dasharray: 3 2;
  stroke-width: 1.5;
}

.vse-map[data-viewtype='cat'] .vse-seat-line {
  visibility: visible;
}

.vse-map[data-viewtype='mis'] .vse-seat-misjoin {
  fill: var(--base-red-color);
} 

.vse-map[data-viewtype='status'] .vse-seat[data-status='held'] {
  fill: var(--base-orange-color);
} 

.vse-map[data-viewtype='status'] .vse-seat[data-status='reserved'] {
  fill: var(--base-green-color);
} 

.vse-map[data-viewtype='status'] .vse-seat[data-status='paid'] {
  fill: var(--base-blue-color);
} 

.vse-line-canvas {
	position: fixed;
	top: 0;
	bottom: 0;
	left: 0;
	right: 0;
	background-color: rgba(0, 0, 0, 0.1);
	z-index: 10000;
	cursor: crosshair;
}

.vse-line-canvas line {
	stroke: red;
	stroke-dasharray: 3 2;
	stroke-width: 3;
}

.vse-lasso-poly-point {
  fill: red;
}

.vse-seat.vse-dragdrop-over,.vse-seat.vse-dragdrop-start {
	stroke-dasharray: 3 2;
	stroke-width: 3;
	stroke: red;
}

.vse-line-canvas-hidetrick {
	display: none !important;
}

.vse-slider {
	display: inline-block;
	margin-left: 10px;
	margin-right: 10px;
	width: 200px;
}

.vse-slider-value {
	display: inline-block;
}

.vse-property-table {
	width: 100%;
	border-spacing: 0px;
}

.vse-property-table .vse-property-section {
	background-color: #f0f0f0;
	padding: 2px 4px 2px 4px;
	text-align: left;
	font-weight: bold;
}

.vse-property-table th {
	background-color: #f8f8f8;
	padding: 2px 6px 2px 16px;
	text-align: left;
	font-weight: normal;
}

.vse-property-table td {
	background-color: white;
}

.vse-property-table input[type="text"],.vse-property-table select {
	border: 0px;
	margin: 0px;
	padding: 0px 4px 0px 4px;
	width: 100%;
}

#sectors-dialog tr .del-link {
	visibility: hidden;
}

#sectors-dialog tr:hover .del-link {
	visibility: visible;
}

#sectors-dialog .color-box {
  width: 20px;
  height: 20px;
  margin-right: 10px;
  border: 1px solid rgba(0,0,0,0.2);
}

#btnset-viewtype label.ui-state-active {
	background: var(--highlight-color) !important;
	color: black !important;
	text-shadow: none !important;
}

#catstatus-tbody th,
#catstatus-tbody td {
  border-bottom: 1px solid rgba(0,0,0,0.1);
  padding-top: 5px;
  padding-bottom: 5px;
}

#catstatus-tbody td,
#seatstatus-tbody td {
  background-color: inherit;
  padding-right: 10px;
  width: 120px;
}

#seat_map_dialog .prgbar-ext {
  width: 100%;
  height: 6px;
  background-color: var(--base-gray-color);
}

#seat_map_dialog .prgbar-int {
  height: 6px;
  float: left;
}

#seat_map_dialog .legend-color {
  display: inline-block;
  width: 9px;
  height: 9px;
  border: 1px solid rgba(0,0,0,0.5);
  /*margin-right: 5px;*/
  border-radius: 2px;
}
</style>