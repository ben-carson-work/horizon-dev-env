<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProduct" scope="request"/>

<style>
  .attribute-tools {
    float: right;
  }
  
  .attribute-tools .fa {
    width: 20px;
    text-align: center;
    font-size: 1.3em;
    opacity: 0.25;
  }
  
  .attribute-tools .add-btn {
    cursor: pointer;
  }
  
  .attribute-tools .info-btn {
    cursor: help;
  }
  
  .attribute-tools .fa:hover {
    opacity: 1;
  }
    
  .legend-color {
    border-left: 4px solid gray;
  }
  
  .legend-fixed {
    border-left-color: var(--base-blue-color);
  }
  
  .attribute-legend-grid {
    border-spacing: 2px;
  }
  
  .attribute-legend-grid  td {
    padding: 2px; 
  }
  
  .legend-dynamic {
    border-left-color: var(--base-green-color);
  }
  
  .legend-dynforce {
    border-left-color: var(--base-orange-color);
  }
  
  .legend-disabled {
    border-left-color: var(--base-gray-color);
  }
  
  .attribute-item td:first-child {
    border-left: 4px solid var(--base-blue-color);
  }
  
  .attribute-item[data-SelectionType='<%=LkSNAttributeSelection.Fixed.getCode()%>'] td:first-child {
    border-left-color: var(--base-blue-color);
  }
  
  .attribute-item[data-SelectionType='<%=LkSNAttributeSelection.Dynamic.getCode()%>'] td:first-child {
    border-left-color: var(--base-green-color);
  }
  
  .attribute-item[data-SelectionType='<%=LkSNAttributeSelection.DynForce.getCode()%>'] td:first-child {
    border-left-color: var(--base-orange-color);
  }
    
  .attribute-item[data-Active='false'] td:first-child {
    border-left-color: var(--base-gray-color);
  }

  .attribute-item .ai-icon {margin-left: 10px;} 
  .attribute-item:not([data-seat='true']) .icon-seat {display: none;}
  .attribute-item:not([data-dynamicentitlement='true']) .icon-dynent {display: none;}
  /*
  .attribute-item .icon-seat {color: var(--base-red-color);}
  .attribute-item .icon-dynent {color: var(--base-green-color);}
  */

</style>
