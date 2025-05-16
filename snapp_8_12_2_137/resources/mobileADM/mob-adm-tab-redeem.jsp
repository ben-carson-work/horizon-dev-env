<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<% DOEnt_Workstation.DOWorkstation.DOAccessPoint apt = (DOEnt_Workstation.DOWorkstation.DOAccessPoint)request.getAttribute("apt"); %>

<jsp:include page="mob-adm-tab-redeem-css.jsp"/>
<jsp:include page="mob-adm-tab-redeem-js.jsp"/>

<div id="redeem-main-tab-content" class="tab-content">
  <div id="tab-header-redeem-idle" class="tab-header">
    <div class="toolbar-button btn-usagetype" data-scantype="entry"></div>
    <div class="tab-header-title"><v:itl key="@AccessPoint.Ready"/></div>
    <div class="toolbar-button btn-keyboard"></div>
    <div class="toolbar-button btn-camera"></div>
    <div class="toolbar-button btn-face"></div>
  </div>
  <div id="tab-header-redeem-manual" class="tab-header hidden">
    <div class="pane-text"><input type="text" placeholder="<v:itl key="@Common.InsertBarcode"/>" style="text-transform:uppercase"/></div>
    <div class="toolbar-button btn-keyboard"></div>
    <div class="toolbar-button btn-inputtype btn-media"></div>
    <div class="toolbar-button btn-inputtype btn-document"></div>
  </div>
  <div id="tab-header-redeem-result" class="tab-header hidden"><div class="tab-header-title"></div></div>
  <div id="tab-header-redeem-wait" class="tab-header hidden"></div>
  
  <div class="tab-body">
    <div class="gate-block"><v:itl key="@AccessPoint.Gate"/>: <span class="info-currentgate"><v:label field="<%=apt.AptOperAreaDisplayName%>"/></span></div>
    <div id="valres-list"></div>
  </div>
  
  <div id="valres-item-template" class="valres-item hidden">
    <div class="valres-header">
      <div class="valres-header-messages">
        <div class="valres-header-title">
          <span class="valres-opmsg"></span>
          <span class="valres-rot"></span>
        </div>
        <div class="valres-header-info">
          <span class="valres-datetime"></span>
          <span class="valres-mediacode"></span>
        </div>
      </div>
      <span class="valres-header-button btn-override"><i class="fa fa-circle-arrow-up"></i></span>
      <span class="valres-header-button btn-question"><i class="fa fa-circle-question"></i></span>
    </div>
    <div class="valres-body">
      <div class="valres-pic"></div>
      <div class="valres-detail">
        <div class="valres-detail-item valres-detail-item-account"></div>
        <div class="valres-detail-item valres-detail-item-product"></div>
        <div class="valres-detail-item valres-detail-item-seat"></div>
        <div class="valres-detail-item valres-detail-item-message"></div>
      </div>
    </div>
  </div>
</div>
