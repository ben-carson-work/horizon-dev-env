<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="view-step-upload">
  <div class="tab-header">
    <div class="toolbar-button btn-toolbar-confirm btn-float-right"><i class="fa fa-check"></i></div>
    <div class="tab-header-title"><span class="snp-itl" data-key="@Sale.UploadingTransaction"></span></div>
  </div>
  
  <div class="tab-body">
    <div class="trn-recap hidden">
      <div class="trn-recap-title"><span class="snp-itl" data-key="@Common.Recap"></span></div>
      <div class="trn-recap-body">
        <div class="trn-recap-line line1">
          <div class="trn-recap-pnr"><span class="trn-recap-value"></span></div>
          <div class="trn-recap-total"><span class="trn-recap-value"></span></div>
        </div>
        <div class="trn-recap-line line2">
          <div class="trn-recap-datetime"><span class="trn-recap-value"></span></div>
          <div class="trn-recap-due"><span class="snp-itl" data-key="@Payment.TotalDue"></span>: <span class="trn-recap-value"></span></div>
        </div>
        <div class="trn-recap-line line3">
          <div class="trn-recap-trntype"><span class="trn-recap-value"></span></div>
          <div class="trn-recap-tendered"><span class="snp-itl" data-key="@Payment.TotalTendered"></span>: <span class="trn-recap-value"></span></div>
        </div>
        <div class="trn-recap-line line4">
          <div/>
          <div class="trn-recap-balance"><span class="snp-itl" data-key="@Payment.TotalBalance"></span>: <span class="trn-recap-value"></span></div>
        </div>
      </div>
    </div>
  </div>
</div>


