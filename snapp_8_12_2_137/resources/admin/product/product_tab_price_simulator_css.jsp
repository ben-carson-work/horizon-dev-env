<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProduct" scope="request"/>
<jsp:useBean id="product" class="com.vgs.snapp.dataobject.DOProduct" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<style>
@media screen {
	#pricesim-calendar {
	  width: 100%;
	  border-collapse: collapse;
	  -webkit-print-color-adjust: exact;
	}
	
	#pricesim-calendar td {
		border: 1px solid var(--border-color);
		padding: 10px 5px 10px 5px;
		position: relative;
	}
	
	#pricesim-calendar thead td {
	  background-color: #e6e6e6 !important;
	  font-weight: bold;
	  text-align: center;
	}
	
	#pricesim-calendar tbody td.cal-price-cell-valued {
	  background-color: var(--content-bg-color) !important;
	  text-align: center;
	  width: 14%;
	}
	
	#pricesim-calendar .cal-price-cell-valued-price {
	  font-size: 1.5em;
		font-weight: bold;
		padding-top: 30px;
		padding-bottom: 30px;
	}
	
	#pricesim-calendar .cal-price-cell-noprice .cal-price-cell-valued-price {
	  opacity: 0.4;
	}
	
	#pricesim-calendar .cal-price-cell-valued-num {
	  position: absolute;
	  top: 0;
	  left: 0;
	  padding-top: 2px;
	  padding-left: 5px;
	  opacity: 0.8;  
	}
	
	#pricesim-calendar .cal-price-cell-valued-performance {
	  position: absolute;
	  left: 0; 
	  bottom: 0;
	  padding: 5px;
	  width: 100px;
	  margin: right;
	}
	
	#pricesim-calendar .cal-price-cell-valued-performance-container {
		width: 30px;
		line-height: 30px;
	}
	
	#pricesim-calendar .cal-price-cell-valued-availability {
	  display: none; 
	  position: absolute;
	  right:0;
	  bottom: 0;
	  padding: 5px;
	  width: 100px;
	  margin: left;
	}
	
	#pricesim-calendar .seat-allocation .cal-price-cell-valued-availability {
	  display: block;
	}
	
	#pricesim-calendar .cal-price-cell-valued-availability .prgbar-lbl {
	  text-align: center;
	  font-weight: bold; 
	}
	
	#pricesim-calendar .cal-price-cell-valued-availability .prgbar-ext {
	  height: 6px;
	}
	
	#pricesim-calendar .cal-price-cell-valued-availability .prgbar-ext-gray {
	  background-color: var(--base-gray-color) !important;
	}
	
	#pricesim-calendar .cal-price-cell-valued-availability .prgbar-ext-red {
	  background-color: var(--base-red-color) !important;
	}
	
	#pricesim-calendar .cal-price-cell-valued-availability .prgbar-int {
	  float: right;
	  height: 6px;
	}
	
	#pricesim-calendar .cal-price-cell-valued-availability .prgbar-int-green {
	  background-color: var(--base-green-color) !important;
	}
	
	#pricesim-calendar .cal-price-cell-valued-availability .prgbar-int-orange {
	  background-color: var(--base-orange-color) !important;
	}
}

@media print {
  @page {size: landscape}

  #adminnavbar,
  #admintopbar,
  #page-title-box .page-path,
  .v-tabs-nav,
  .tab-toolbar {
    display: none;
  }
  
  #page-title-box {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
  }
  
  #pricesim-tab {
    position: fixed;
    top: 70px;
    bottom: 0;
    left: 0;
    right: 0;
    font-size: 0.5em;
  }
  
	#pricesim-calendar {
	  width: 100%;
	  border-collapse: collapse;
	  -webkit-print-color-adjust: exact;
	}
	
	#pricesim-calendar td {
		border: 1px solid var(--border-color) !important;
		padding: 10px 5px 10px 5px;
		position: relative;
	}
	
	#pricesim-calendar thead td {
	  background-color: #e6e6e6;
	  font-weight: bold;
	  text-align: center;
	}
	
	#pricesim-calendar tbody td.cal-price-cell-valued {
	  background-color: var(--content-bg-color) !important;
	  text-align: center;
	}
	
	#pricesim-calendar .cal-price-cell-valued-price {
	  font-size: 1.5em;
		font-weight: bold;
		padding-top: 30px;
		padding-bottom: 30px;
	}
	
	#pricesim-calendar .cal-price-cell-noprice .cal-price-cell-valued-price {
	  opacity: 0.4;
	}
	
	#pricesim-calendar .cal-price-cell-valued-num {
	  position: absolute;
	  top: 0;
	  left: 0;
	  padding-top: 2px;
	  padding-left: 5px;
	  opacity: 0.8;  
	}
	
	#pricesim-calendar .cal-price-cell-valued-performance {
	  position: absolute;
	  left: 0; 
	  bottom: 0;
	  padding: 5px;
	  width: 70px;
	  margin: right;
	}
	
	#pricesim-calendar .cal-price-cell-valued-performance-container {
		width: 20px;
		line-height: 20px;
	}
	
	#pricesim-calendar .cal-price-cell-valued-availability {
	  display: none; 
	  position: absolute;
	  right:0;
	  bottom: 0;
	  padding: 5px;
	  width: 60px;
	  margin: left;
	}
	
	#pricesim-calendar .seat-allocation .cal-price-cell-valued-availability {
	  display: block;
	}
	
	#pricesim-calendar .cal-price-cell-valued-availability .prgbar-lbl {
	  text-align: center;
	  font-weight: bold; 
	}
	
	#pricesim-calendar .cal-price-cell-valued-availability .prgbar-ext {
	  height: 6px;
	}
	
	#pricesim-calendar .cal-price-cell-valued-availability .prgbar-ext-gray {
	  background-color: var(--base-gray-color) !important;
	}
	
	#pricesim-calendar .cal-price-cell-valued-availability .prgbar-ext-red {
	  background-color: var(--base-red-color) !important;
	}
	
	#pricesim-calendar .cal-price-cell-valued-availability .prgbar-int {
	  float: right;
	  height: 6px;
	}
	
	#pricesim-calendar .cal-price-cell-valued-availability .prgbar-int-green {
	  background-color: var(--base-green-color) !important;
	}
	
	#pricesim-calendar .cal-price-cell-valued-availability .prgbar-int-orange {
	  background-color: var(--base-orange-color) !important;
	}

}

</style>