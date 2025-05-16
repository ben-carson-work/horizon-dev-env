<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="view-account-security">
  <div class="tab-header">
    <div class="toolbar-button btn-toolbar-back custom-click"></div>
    <div class="toolbar-button btn-toolbar-save btn-float-right disabled"><i class="fa fa-save"></i></div>
    <div class="tab-header-title">
      <div class="tab-header-title-top"><span class="snp-itl" data-key="@Account.Account"/></div>
      <div class="tab-header-title-bottom"><span class="snp-itl" data-key="@Account.Security"/></div>
    </div>
  </div>
  
  <div class="tab-body">
    <div class="pref-edit-container">
      <div class="pref-section-spacer"></div>
      
      <div class="pref-section">
        <div class="pref-section-title"><span class="snp-itl" data-key="@Common.Login"/></div>
        <div class="pref-item-list">
          <v:mob-pref-simple id="pref-item-username" caption="@Common.UserName"/>
          <v:mob-pref-simple id="pref-item-email" caption="@Common.Email"/>
          <v:mob-pref-simple id="pref-item-roles" caption="@Common.SecurityRoles" arrow="true"/>
          <v:mob-pref-simple id="pref-item-status" caption="@Common.Status" arrow="true"/>
          <v:mob-pref-simple id="pref-item-changepwd" caption="@Common.ChangePassword" arrow="true"/>
        </div>
      </div>
      
      <div class="pref-section">
        <div class="pref-section-title"><span class="snp-itl" data-key="@Common.Platform"/></div>
        <div class="pref-item-list">
          <v:mob-pref-simple id="pref-item-platform-snp" clazz="pref-item-check" caption="SnApp"/>
          <v:mob-pref-simple id="pref-item-platform-b2b" clazz="pref-item-check" caption="B2B"/>
          <v:mob-pref-simple id="pref-item-platform-b2c" clazz="pref-item-check" caption="B2C"/>
        </div>
      </div>
      
      <div class="pref-section">
        <div class="pref-section-title"><span class="snp-itl" data-key="@Common.Statistics"/></div>
        <div class="pref-item-list">
          <v:mob-pref-simple id="pref-item-last-login" caption="@Account.LastLogin"/>
          <v:mob-pref-simple id="pref-item-pwd-change" caption="@Account.PasswordChangeDate"/>
        </div>
      </div>
    </div>
  </div>
  
  <div class="templates">
  </div>
</div>
