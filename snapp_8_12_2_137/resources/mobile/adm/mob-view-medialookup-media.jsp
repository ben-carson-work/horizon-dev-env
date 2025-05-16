<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="view-medialookup-media">
  <div class="tab-header">
    <div class="toolbar-button btn-toolbar-back"></div>
    <div class="tab-header-title"><div class="snp-itl" data-key="@Common.Media"/></div>
  </div>
  <div class="tab-body">
    <div class="pref-section-spacer"></div>
    
    <div class="pref-section">
      <div class="pref-item-list">
        <v:mob-pref-simple id="pref-item-status" caption="@Common.Status"/>
        <v:mob-pref-simple id="pref-item-tdssn" caption="@Common.TDSSN"/>
        <v:mob-pref-simple id="pref-item-printed" caption="@Reservation.Flag_Printed"/>
        <v:mob-pref-simple id="pref-item-exclusive" caption="@Common.ExclusiveUse"/>
        <v:mob-pref-simple id="pref-item-pah" caption="@Common.PrintAtHome"/>
      </div>
    </div>
  
    <div class="pref-section">
      <div class="pref-item-list">
        <v:mob-pref-simple id="pref-item-trn" caption="@Common.Transaction"/>
        <v:mob-pref-simple id="pref-item-location" caption="@Account.Location"/>
        <v:mob-pref-simple id="pref-item-oparea" caption="@Account.OpArea"/>
        <v:mob-pref-simple id="pref-item-wks" caption="@Common.Workstation"/>
      </div>
    </div>
  </div>
</div>


<script>
UIMob.init("medialookup-media", function($view, params) {
  var media = params.MediaRef;
  var mediaStatusClass = (media.MediaStatus == LkSN.TicketStatus.Active.code) ? "good-status" : (media.MediaStatus < goodTicketLimit ? "warn-status" : "bad-status");
  
  $view.find("#pref-item-tdssn .pref-item-value").text(media.MediaCalcCode);
  $view.find("#pref-item-status .pref-item-value").text(media.MediaStatusDesc).addClass(mediaStatusClass);
  $view.find("#pref-item-printed .pref-item-value").text((media.PrintDateTime) ? formatShortDateTimeFromXML(media.PrintDateTime) : itl("@Common.No"));
  $view.find("#pref-item-exclusive .pref-item-value").text((media.ExclusiveUse) ? itl("@Common.Yes") : itl("@Common.No"));
  $view.find("#pref-item-pah .pref-item-value").text((media.PrintAtHome) ? itl("@Common.Yes") : itl("@Common.No"));

  // Transaction
  $view.find("#pref-item-trn .pref-item-value").text(media.TransactionCode);
  $view.find("#pref-item-location .pref-item-value").text(media.LocationName);
  $view.find("#pref-item-oparea .pref-item-value").text(media.OpAreaName);
  $view.find("#pref-item-wks .pref-item-value").text(media.WorkstationName);
});
</script>