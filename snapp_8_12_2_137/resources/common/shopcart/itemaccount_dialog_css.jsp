<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<style>
  #itemaccount_dialog .body-block {
    position: absolute;
    left: 0;
    right: 0;
    top: 0;
    bottom: 60px;
    padding: 10px;
    overflow: auto;
  }

  #itemaccount_dialog .tab-button-list {
    width: 25%;
    float: left;
    list-style-type: none;
    margin: 0;
    padding: 0;
  }
  
  #itemaccount_dialog .tab-button {
    position: relative;
    border: 1px solid rgba(0,0,0,0.1);
    border-right-width: 0;
    border-top-width: 0;
    margin: 0;
    margin-left: 10px;
    padding: 6px;
    z-index: 100;
  }

  #itemaccount_dialog .tab-button:first-child {
    border-top-width: 1px;
    margin-top: 10px;
  }
  
  #itemaccount_dialog .tab-button:not(.selected):hover {
    background-color: rgba(0,0,0,0.05);
    cursor: pointer;
  }
  
  #itemaccount_dialog .tab-button.selected {
    background-color: white;
    border-color: var(--tab-border-color);
    border-top-width: 1px;
    margin-left: 0;
    margin-right: -1px;
    padding-top: 10px;
    padding-bottom: 10px;
  }
  
  #itemaccount_dialog .tab-button-icon {
    float: left;
    width: 36px;
    height: 36px;
    opacity: 0.4;
  }
  
  #itemaccount_dialog .tab-button-account {
    margin-left: 40px;
    font-size: 1.3em;
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
  }
  
  #itemaccount_dialog .tab-button-product {
    margin-left: 40px;
    color: rgba(0,0,0,0.8);
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
  }
  
  #itemaccount_dialog .tab-button .tab-button-icon {
    font-size: 2em;
    text-align: center;
    margin-top: 5px;
  }
  
  #itemaccount_dialog .tab-button.selected .tab-button-icon {
    opacity: 1;
  }
  
  #itemaccount_dialog .tab-button-icon .ok-icon {
    display: none;
    color: var(--base-green-color);
  }
  
  #itemaccount_dialog .tab-button .warn-icon {
    color: var(--base-orange-color);
  }
  
  #itemaccount_dialog .tab-button.account-ok .ok-icon {
    display: inline;
  }
  
  #itemaccount_dialog .tab-button.account-ok .warn-icon {
    display: none;
  }
    
  #itemaccount_dialog .tab-content {
    position:relative;
    background-color: white;
    border: 1px solid var(--tab-border-color);
    margin-left: 25%;
    min-height: 200px;
    padding: 10px;
  }

  #itemaccount_dialog .tab-content .postbox {
    border: 0;
  }
  
  #itemaccount_dialog .tab-content .widget-title {
    background: none;
    border-color: var(--tab-border-color);
  }
  
  #itemaccount_dialog .tab-content .widget-title-caption {
    font-size: 1.3em;
    font-weight: normal;
  }
  
  #itemaccount_dialog .tab-content .widget-title-icon {
    display: none;
  }
  
</style>
