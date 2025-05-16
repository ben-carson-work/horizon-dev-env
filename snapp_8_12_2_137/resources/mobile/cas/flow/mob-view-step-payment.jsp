<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="view-step-payment">
  <div class="tab-header">
    <div class="toolbar-button btn-toolbar-cancel"><i class="fa fa-times"></i></div>
    <div class="toolbar-button btn-toolbar-confirm btn-float-right"><i class="fa fa-check"></i></div>
    <div class="tab-header-title"><div class="snp-itl" data-key="@Payment.Payments"/></div>
  </div>
  
  <div class="tab-body noselect">
    <div class="payment-recap">
      <div class="payment-recap-line pr-due">
        <div class="payment-recap-caption"><div class="snp-itl" data-key="@Payment.TotalDue"/></div>
        <div class="payment-recap-value"></div>
      </div>
      <div class="payment-split-list">
        <div class="tendered-list"></div>
        <div class="split-input hidden">
          <div class="split-input-hint"><div class="snp-itl" data-key="@Payment.SelectPayment"/></div>
          <div class="split-input-amount"><i class="fa fa-pencil"></i>&nbsp;<span class="split-input-amount-value"></span>
          </div>
        </div>
      </div>
      <div class="payment-recap-line pr-tendered">
        <div class="payment-recap-caption"><div class="snp-itl" data-key="@Payment.TotalTendered"/></div>
        <div class="payment-recap-value"></div>
      </div>
      <div class="payment-recap-line pr-balance">
        <div class="payment-recap-caption"><div class="snp-itl" data-key="@Payment.TotalBalance"/></div>
        <div class="payment-recap-value"></div>
      </div>
    </div>

    <div class="calculator">
      <table>
        <tr>
          <td data-key="7" data-keycode="103">7</td>
          <td data-key="8" data-keycode="104">8</td>
          <td data-key="9" data-keycode="105">9</td>
          <td data-keycode="8" class="calc-fnc"><i class="fa fa-backspace"></i></td>
        </tr>
        <tr>
          <td data-key="4" data-keycode="100">4</td>
          <td data-key="5" data-keycode="101">5</td>
          <td data-key="6" data-keycode="102">6</td>
          <td data-keycode="46" class="calc-fnc"><i class="fa fa-times-circle"></i></td>
        </tr>
        <tr>
          <td data-key="1" data-keycode="97">1</td>
          <td data-key="2" data-keycode="98">2</td>
          <td data-key="3" data-keycode="99">3</td>
          <td data-keycode="13" class="calc-fnc" rowspan="2"><i class="fa fa-level-down fa-rotate-90"></i></td>
        </tr>
        <tr>
          <td data-key="0" data-keycode="96" colspan="2">0</td>
          <td data-keycode="110" class="decimal-separator calc-fnc">,</td>
        </tr>
      </table>
    </div>
    
    <div class="paymethod-list"/>
    <div class="paycut-list"/>
  
  </div>
  
  <div class="templates">
  
    <div class="paymethod">
      <div class="paymethod-inner">
        <div class="paymethod-icon"/>
        <div class="paymethod-name mobile-ellipsis"/>
      </div>
    </div>
    
    <div class="paycut">
      <div class="paycut-inner">
        <div class="paycut-icon"/>
        <div class="paycut-amount"/>
      </div>
    </div>
    
    <div class="split">
      <div class="split-line line1">
        <div class="split-name"/>
        <div class="split-amount"/>
      </div>
      <div class="split-line line2">
        <div class="split-info"/>
        <div class="split-subamount"/>
      </div>
    </div>
  </div>
</div>
