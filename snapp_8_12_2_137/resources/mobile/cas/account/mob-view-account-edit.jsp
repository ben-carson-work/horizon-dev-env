<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="view-account-edit">
  <div class="tab-header">
    <div class="toolbar-button btn-toolbar-back custom-click"></div>
    <div class="toolbar-button btn-toolbar-save btn-float-right disabled"><i class="fa fa-save"></i></div>
    <div class="tab-header-title">
      <div class="tab-header-title-top"><span class="snp-itl" data-key="@Account.Account"/></div>
      <div class="tab-header-title-bottom"><span class="snp-itl" data-key="@Common.Edit"/></div>
    </div>
  </div>
  
  <div class="tab-body">
    <div class="pref-edit-container">
      <div class="pref-section">
        <div class="pref-section-spacer"></div>
        <div class="pref-item-list">
          <v:mob-pref-simple id="pref-item-category" caption="@Category.Category" arrow="true"/>
          <v:mob-pref-simple id="pref-item-security" caption="@Account.Security" arrow="true"/>
        </div>
      </div>
        
      <div class="maskedit-container"></div>
    </div>
  </div>
</div>
