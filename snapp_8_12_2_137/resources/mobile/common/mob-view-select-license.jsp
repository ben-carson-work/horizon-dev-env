<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="select-license-main" data-level="location">
  <div class="tab-header">
    <div class="tab-header-title">License type</div>
  </div>

  <div class="tab-body waiting">
  
    <div id="select-license-error" class="hidden">No available license found</div>
    
    <div id="select-license-pref" class="hidden">
      <div class="pref-section-spacer"></div>

      <div class="pref-section">
        <div class="pref-item-list">
        </div>
      </div>
    </div>
  </div>
</div>
