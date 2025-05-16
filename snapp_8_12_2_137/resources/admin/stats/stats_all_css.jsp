<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>


<style>
.container-fluid .row {margin:0;} 

.buttonset label.ui-state-active,
.btn-group .btn.active {
  background: var(--highlight-color) !important;
  color: black !important;
  text-shadow: none !important;
}

.stat-box {
  line-height: normal;
  padding: 10px;
  background-color: var(--content-bg-color);
  border: 1px solid var(--border-color);
  border-radius: 4px;
}

.stat-box-caption {
  text-align: center;
  font-size: 1.5em;
  font-weight: bold;
  opacity: 0.3;
}

.stat-box-currqty {
  margin-right: 50%;
  font-size: 2.5em;
  color: var(--base-blue-color);
  text-align: center;
}

.stat-box-prevqty {
  margin-right: 50%;
  font-size: 1.2em;
  font-weight: bold;
  color: var(--base-orange-color);
  text-align: center;
}

.stat-box-variation {
  width: 50%;
  float: right;
  font-size: 2.5em;
  text-align: right;
  margin-top: 10px;
  text-align: center;
}

.stat-box-value {
  font-size: 2.5em;
  font-weight: bold;
  color: var(--base-blue-color);
  text-align: center;
}

.stat-box-variation.positive {
  color: var(--base-green-color);
}

.stat-box-variation.negative {
  color: var(--base-red-color);
}

.chart {
  background-color: var(--content-bg-color);
  border: 1px solid var(--border-color);
  border-radius: 4px;
}

.pb-outer {
  background-color: #cccccc;
  width: 100px;
  height: 6px;
}

.pb-inner {
  height: 6px;
  float: left;
}

.pb-qty {
  font-weight: bold;
}

.td-qty-curr .pb-inner {
  background-color: var(--base-blue-color);
}

.td-qty-prev .pb-inner {
  background-color: var(--base-orange-color);
}

.td-var {
  font-size: 1.4em;
}

.td-var.positive {
  color: var(--base-green-color);
}

.td-var.negative {
  color: var(--base-red-color);
}
  
/* Pie animation */ 
.amcharts-pie-slice {
  transform: scale(1);
  transform-origin: 50% 50%;
  transition-duration: 0.3s;
  transition: all .3s ease-out;
  -webkit-transition: all .3s ease-out;
  -moz-transition: all .3s ease-out;
  -o-transition: all .3s ease-out;
  cursor: pointer;
  box-shadow: 0 0 30px 0 #000;
}

.amcharts-pie-slice:hover {
  transform: scale(1.1);
  filter: url(#shadow);
}

</style>

