<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<%
String fixedBkg = "#e4e4e4";
String fixedBrd = "#d3d3d3";
String dynamBkg = "#fffedd";
String dynamBrd = "#e3ddae";
String disabBkg = "#efcece";
String disabBrd = "#e2a1a1";
%>

<style>
  .attribute-item-box, .salerights-item-box, .gatecategory-item-box, .srcproducts-item-box {
    float: left;
    margin: 3px;
    padding: 6px;
    background-color: <%=fixedBkg%>;
    border: 1px <%=fixedBrd%> solid;
    border-radius: 3px;
    cursor: pointer;
    text-shadow: 0pt 1px 0pt rgba(255, 255, 255, 1);
  } 
  
  .attribute-item-box[data-SelectionType='<%=LkSNAttributeSelection.Dynamic.getCode()%>'],
  .attribute-item-box[data-SelectionType='<%=LkSNAttributeSelection.DynForce.getCode()%>'] {
    background-color: <%=dynamBkg%>;
    border-color: <%=dynamBrd%>;
  }

  .attribute-item-box[data-Active='false'] {
    background-color: <%=disabBkg%> !important;
    border-color: <%=disabBrd%> !important;
  }
  
  .attribute-item-box:hover,.salerights-item-box:hover,.gatecategory-item-box:hover, .srcproducts-item-box:hover {
    border-color: #999999;
  }
  
  .attribute-item-box .item-name, .salerights-item-box .item-name, .gatecategory-item-box .item-name, .srcproducts-item-box .item-name {
    color: rgba(0, 0, 0, 0.8);
    font-weight: bold;
  }
  
  .attribute-item-box .attr-name, .salerights-item-box .ent-type-name, .srcproducts-item-box .ent-type-name {
    color: rgba(0, 0, 0, 0.7);
  }
  
  .attribute-item-box .attr-name.seat {
    background-image: url('<v:image-link name="<%=LkSNEntityType.SeatMap.getIconName()%>" size="14"/>');
    background-repeat: no-repeat;
    background-position: left center;
    padding-left: 16px;
  }
  
  .form-field {
    line-height: 20px;
  }
  
  .checkbox-label {
    display: inline;
  }
  
  .salerights-selection, .attribute-selection, .gatecategory-selection, .srcproducts-selection {
    clear: left;
    padding-top: 10px;
  }
  
  #product_multiedit_dialog .form-field-caption {
    width: 400px;
  }
  
  #product_multiedit_dialog .form-field-value {
    margin-left: 403px;
  }
  
</style>