<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="view-info-device">
  <div class="tab-header">
    <div class="toolbar-button btn-toolbar-back"></div>
    <div class="tab-header-title"><v:itl key="Device info"/></div>
  </div>

  <div class="tab-body">
    <div class="pref-section-spacer"></div>
    
    <div class="pref-section">
      <div class="pref-item-list">
        <v:mob-pref-simple id="os-platform" caption="Platform"/>
        <v:mob-pref-simple id="app-version" caption="App version"/>
        <v:mob-pref-simple id="device-code" caption="Device ID" arrow="true"/>
      </div>
    </div>
    
    <div class="pref-section">
      <div class="pref-item-list">
        <v:mob-pref-simple id="screenres" caption="@Common.Screen"/>
        <v:mob-pref-simple id="pixelratio" caption="Pixel ratio"/>
      </div>
    </div>
    
    <div class="pref-section-title">Hardware</div>
    <div class="pref-section">
      <div class="pref-item-list">
        <v:mob-pref-simple id="hardware-nfc" caption="NFC"/>
        <v:mob-pref-simple id="hardware-barcodecamera" caption="Barcode camera"/>
        <v:mob-pref-simple id="hardware-barcode" caption="Barcode"/>
        <v:mob-pref-simple id="hardware-magstripe" caption="Msg stripe"/>
        <v:mob-pref-simple id="hardware-gps" caption="GPS"/>
        <v:mob-pref-simple id="hardware-vibrator" caption="Vibration"/>
      </div>
    </div>
  </div>
</div>
