<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="view-apt-monitor-detail">

  <div class="tab-header">
    <div class="toolbar-button btn-toolbar-back"></div>
    <div class="toolbar-button btn-toolbar-menu btn-float-right"><i class="fa fa-bars"></i></div>
    <div class="tab-header-title"></div>
  </div>
  
  <div class="tab-body">
    <div class="apt-recap">
      <div class="apt-recap-status">
        <div class="apt-status-item status-entry">
          <div class="apt-status-icon"><i class="fa fa-arrow-alt-circle-up"></i></div>
          <div class="apt-status-body">
            <div class="apt-status-caption mobile-ellipsis"><span class="snp-itl" data-key="@AccessPoint.EntryControl"/></div>
            <div class="apt-status-value mobile-ellipsis"></div>
          </div>
        </div>
        <div class="apt-status-item status-reentry">
          <div class="apt-status-icon"><i class="fa fa-arrow-alt-circle-up" style="transform:rotate(-45deg)"></i></div>
          <div class="apt-status-body">
            <div class="apt-status-caption mobile-ellipsis"><span class="snp-itl" data-key="@AccessPoint.ReentryControl"/></div>
            <div class="apt-status-value mobile-ellipsis"></div>
          </div>
        </div>
        <div class="apt-status-item status-exit">
          <div class="apt-status-icon"><i class="fa fa-arrow-alt-circle-down"></i></div>
          <div class="apt-status-body">
            <div class="apt-status-caption mobile-ellipsis"><span class="snp-itl" data-key="@AccessPoint.ExitControl"/></div>
            <div class="apt-status-value mobile-ellipsis"></div>
          </div>
        </div>
      </div>
      <div class="apt-recap-counter">
        <div class="apt-counter-item apt-counter-in-wait">
          <div class="apt-counter-caption">IN Waiting</div>
          <div class="apt-counter-value">-</div>
        </div>
        <div class="apt-counter-item apt-counter-in-tot">
          <div class="apt-counter-caption">IN Total</div>
          <div class="apt-counter-value">-</div>
        </div>
        <div class="apt-counter-spacer"/>
        <div class="apt-counter-item apt-counter-out-wait">
          <div class="apt-counter-caption">OUT Waiting</div>
          <div class="apt-counter-value">-</div>
        </div>
        <div class="apt-counter-item apt-counter-out-tot">
          <div class="apt-counter-caption">OUT Total</div>
          <div class="apt-counter-value">-</div>
        </div>
      </div>
    </div>
    
    <div class="usage-list"></div>
  </div>
  
  <div class="templates">
    <div class="mob-widget usage-item">
      <div class="mob-widget-header">
        <div class="valres-desc"></div>
        <div class="usage-datetime"></div>
      </div>
      <div class="mob-widget-block">
        <div class="mob-card">
          <div class="mob-card-icon"></div>
          <div class="mob-card-body">
            <div class="mob-card-title"></div>
          </div>
        </div>
      </div>
    </div>
  </div>

</div>
