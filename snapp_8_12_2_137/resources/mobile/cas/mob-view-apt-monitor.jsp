<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="view-apt-monitor">

  <div class="tab-header">
    <div class="tab-header-default">
      <div class="toolbar-button btn-back disabled"><i class="fa fa-chevron-left"></i></div>
      <div class="tab-header-title"><span class="snp-itl" data-key="Access points status"/></div>
    </div>
    
    <div class="breadcrumb-container"></div>
  </div>
  
  <div class="tab-body">
    <div class="conn-box">
      <div class="mob-widget">
        <div class="mob-widget-header">
          <i class="fa fa-circle-notch fa-spin"></i>
          <span class="snp-itl" data-key="@Common.Connecting"/>
        </div>
      </div>
    
    </div>
    <div class="data-box"></div>
  </div>
  
  <div class="templates">
    <div class="apt-item">
      <div class="mob-widget">
        <div class="mob-widget-header mobile-ellipsis">
        </div>
        <div class="mob-widget-block">
          <div class="apt-val-res"></div>
        </div>
        <div class="apt-item-footer mob-widget-block">
          <div class="apt-status-item apt-status-entry"><i class="fa fa-arrow-alt-circle-up"></i></div>
          <div class="apt-status-item apt-status-reentry"><i class="fa fa-arrow-alt-circle-up"></i></div>
          <div class="apt-status-item apt-status-exit"><i class="fa fa-arrow-alt-circle-down"></i></div>
        </div>
      </div>
    </div>
  </div>

</div>
