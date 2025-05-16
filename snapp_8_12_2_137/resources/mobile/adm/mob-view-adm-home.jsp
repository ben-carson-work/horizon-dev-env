<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="page-main" data-activetab="redeem">
  <div class="tab-button-list">
    <div class="tab-button tab-button-default" data-packagename="AppMOB_Admission" data-viewname="redeem">
      <div class="tab-button-icon"><i class="fa fa-barcode-scan"></i></div>
      <div class="tab-button-caption"><div class="snp-itl" data-key="@AccessPoint.Redemption"/></div>
    </div>
    <div class="tab-button" data-packagename="AppMOB_Admission" data-viewname="attendance">
      <div class="tab-button-icon"><i class="fa fa-chart-line"></i></div>
      <div class="tab-button-caption"><div class="snp-itl" data-key="@AccessPoint.Attendance"/></div>
    </div>
    <div class="tab-button" data-packagename="COMMON" data-viewname="info">
      <div class="tab-button-icon"><i class="fa fa-info"></i></div>
      <div class="tab-button-caption"><div class="snp-itl" data-key="@Common.Info"/></div>
    </div>
  </div>
</div>

<script>
UIMob.init("adm-home", function($view, params) {
  UIMob.initTabsContent($view);
});
</script>

