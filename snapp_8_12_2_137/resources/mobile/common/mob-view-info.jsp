<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="view-info">
  <div class="tab-header"><div class="tab-header-title"><v:itl key="@Common.Info"/></div></div>

  <div class="tab-body">
    <div class="pref-section-spacer"></div>
    
    <div id="pref-section-user" class="pref-section">
      <div class="pref-item-list">
        <v:mob-pref-simple id="pref-item-user" caption="@Common.User" arrow="true"/>
        <v:mob-pref-simple id="pref-item-changeapp" caption="APP" value="change" arrow="true"/>
        <v:mob-pref-simple id="pref-item-deviceinfo" caption="Device info" arrow="true"/>
      </div>
    </div>
    
    <div class="pref-section">
      <div class="pref-item-list">
        <v:mob-pref-simple id="pref-item-location" caption="@Account.Location"/>
        <v:mob-pref-simple id="pref-item-oparea" caption="@Account.OpArea"/>
        <v:mob-pref-simple id="pref-item-wks" caption="@Common.Workstation" arrow="true"/>
        <v:mob-pref-simple id="pref-item-gate" caption="@AccessPoint.Gate" clazz="controlled-apt" arrow="true"/>
        <v:mob-pref-simple id="pref-item-apt" caption="@AccessPoint.AccessPoint" clazz="controlled-apt"/>
      </div>
    </div>

  </div>
</div>
