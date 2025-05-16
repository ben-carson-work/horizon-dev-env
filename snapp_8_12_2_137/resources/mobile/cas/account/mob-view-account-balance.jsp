<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="view-account-balance">
  <div class="tab-header">
    <div class="toolbar-button btn-toolbar-back"></div>
    <div class="tab-header-title">
      <div class="tab-header-title-top"><span class="snp-itl" data-key="@Account.Account"/></div>
      <div class="tab-header-title-bottom"><span class="snp-itl" data-key="@Common.Balance"/></div>
    </div>
  </div>
  
  <div class="tab-body">
  </div>
  
  <div class="templates">
    <div class="mob-widget slot-item">
      <div class="mob-widget-header"></div>
      <div class="mob-widget-block">
        <v:mob-pref-simple clazz="pref-item-balance" caption="@Common.Balance"/>
        <v:mob-pref-simple clazz="pref-item-credit" caption="@Common.CreditLimit"/>
        <v:mob-pref-simple clazz="pref-item-expire" caption="@Common.Expiration"/>
        <v:mob-pref-simple clazz="pref-item-trn" caption="@Common.Transactions" arrow="true"/>
      </div>
    </div>
  </div>
</div>
