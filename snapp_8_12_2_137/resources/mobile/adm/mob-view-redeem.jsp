<%@page import="com.vgs.snapp.web.mob.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="view-redeem">
  <div id="tab-header-idle" class="tab-header">
    <div class="toolbar-button btn-scantype" data-scantype="entry"><i class="fa fa-arrow-alt-up"></i></div>
    <div class="toolbar-button btn-scantype" data-scantype="simulate"><i class="fa fa-question"></i></div>
    <div class="toolbar-button btn-scantype" data-scantype="exit"><i class="fa fa-arrow-alt-down"></i></div>
    <div class="toolbar-button btn-scantype" data-scantype="lookup"><i class="fa fa-search"></i></div>
    <div class="toolbar-button btn-keyboard btn-float-right"><i class="fa fa-keyboard"></i></div>
    <div class="toolbar-button btn-camera btn-float-right"><i class="fa fa-camera"></i></div>
    <div class="tab-header-title"><div class="snp-itl" data-key="@AccessPoint.Ready"/></div>
  </div>
  <div id="tab-header-manual" class="tab-header hidden">
    <div class="toolbar-button btn-keyboard btn-float-right"><i class="fa fa-keyboard"></i></div>
    <div class="pane-text"><input type="text" style="text-transform:uppercase"/></div>
  </div> 
  <div id="tab-header-result" class="tab-header hidden"><div class="tab-header-title"></div></div>
  <div id="tab-header-wait" class="tab-header hidden"><i class="fa fa-spin fa-circle-notch"></i></div>
  
  <div class="tab-body"></div>
  
  <div class="templates">
    <div class="valres-item">
      <div class="valres-header">
        <span class="valres-opmsg"></span>
        <span class="valres-rot"></span>
      </div>
      <div class="valres-body">
        <div class="valres-pic"></div>
        <div class="valres-detail">
          <div class="valres-detail-item valres-detail-item-account"></div>
          <div class="valres-detail-item valres-detail-item-product"></div>
          <div class="valres-detail-item valres-detail-item-message"></div>
        </div>
      </div>
    </div>
  </div>
</div>