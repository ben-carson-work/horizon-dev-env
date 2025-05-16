<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<style>
  #perf-container {
    height: 100%;
    position: relative;
  }
  
  #perf-container .item-container {
    position: relative;
    top: 0;
    left: 0;
    bottom: 0;
    right: 0;
    height: initial;
  }
  
  .item-container {
    min-height: 50px;
  }
  
  .catalog-item {
    position: relative;
    cursor: pointer;
    height: 40px;
    overflow: hidden;
  }
  
  .catalog-item:hover {
    background-color: rgba(0,0,0,0.05);
  }
  
  .catalog-item.selected {
    background-color: var(--highlight-color);
    cursor: default;
  }
  
  .item-img {
    position: absolute;
    top: 4px;
    left: 4px;
    width: 32px;
    height: 32px;
  }
  
  .item-caption {
    margin-left: 42px;
    top: 0;
    right: 0;
    bottom: 0;
    line-height: 40px;
    font-size: 1.3em;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
  }
  
  .waiting {
    background-image: url('<v:config key="resources_url"/>/admin/images/new-spinner32.gif');
    background-repeat: no-repeat;
    background-position: center 20px;
    min-height: 50px;
  }
  
  .no-elem-found {
    font-size: 1.5em;
    text-align: center;
    padding: 20px;
    color: rgba(0,0,0,0.5);
  }
  
  .perf-date {
    padding: 2px 4px 2px 4px;
    margin: 10px 10px 2px 10px;
    font-weight: bold;
    border-bottom: 1px var(--tab-border-color) solid;
    color: rgba(0,0,0,0.8);
  }
  
  .perf-item .item-img {
    width: 28px;
    height: 32px;
    padding: 7px 0px 7px 10px;
    opacity: 0.6;
  }
</style>

