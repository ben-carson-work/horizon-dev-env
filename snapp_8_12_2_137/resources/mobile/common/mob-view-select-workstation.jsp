<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<style>
#select-wks-main[data-level='location'] .btn-back {
  visibility: hidden;
}
</style>

<div id="select-wks-main" data-level="location">
  <div class="tab-header">
    <div class="toolbar-button btn-back"><i class="fa fa-chevron-left"></i></div>
    <div class="toolbar-button" style="float:right"></div>
    <div class="tab-header-title">Select workstation</div>
  </div>

  <div class="tab-body waiting">
  
    <div id="select-wks-error" class="hidden">No elements</div>
    
    <div id="select-wks-pref" class="hidden">
      <div class="pref-section-spacer"></div>

      <div class="pref-section-title"></div>
      <div class="pref-section">
        <div class="pref-item-list">
        </div>
      </div>
    </div>
  </div>
</div>
