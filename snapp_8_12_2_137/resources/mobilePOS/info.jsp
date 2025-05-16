<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="apt" class="com.vgs.snapp.dataobject.DOAccessPointRef" scope="request"/>
<% PageMobileSales pageBase = (PageMobileSales)request.getAttribute("pageBase"); %>

<jsp:include page="info-js.jsp" />


<div id="info-main-tab-content" class="tab-content">
  <div class="">
    <div class="pref-section-spacer"></div>
    <div class="pref-section">
      <div class="pref-item-list">
        <div id="pref-item-logout" class="pref-item pref-item-arrow">
          <div class="pref-item-caption"><v:itl key="@Common.User"/></div>
          <div class="pref-item-value"><%=JvString.escapeHtml(pageBase.getSession().getUserDesc())%></div>
        </div>
      </div>
    </div>
    <div class="pref-section">
      <div class="pref-item-list">
        <div  id="pref-item-workstation" class="pref-item pref-item-arrow">
            <div class="pref-item-caption"><v:itl key="@Common.Workstation"/></div>
            <div class="pref-item-value"><%=JvString.escapeHtml(pageBase.getSession().getWorkstationName())%></div>
        </div>
      </div>
    </div>
    <div class="pref-section">
      <div class="pref-item-list">
        <div  id="pref-item-synchronize" class="pref-item pref-item-arrow">
            <div class="pref-item-caption">Synchronize</div>
            <div class="pref-item-value">Synchronize Product</div>
        </div>
      </div>
    </div>
  </div>
</div>
