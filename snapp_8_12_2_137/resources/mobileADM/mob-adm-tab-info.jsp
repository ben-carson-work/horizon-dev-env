<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileAdmission" scope="request"/>
<jsp:useBean id="wks" class="com.vgs.entity.dataobject.DOEnt_Workstation" scope="request"/>
<%
DOEnt_Workstation.DOWorkstation.DOAccessPoint apt = (DOEnt_Workstation.DOWorkstation.DOAccessPoint)request.getAttribute("apt");
%>

<jsp:include page="mob-adm-tab-info-js.jsp"/>

<div id="info-main-tab-content" class="tab-content">
  <div class="tab-header"><div class="tab-header-title"><v:itl key="@Common.Info"/></div></div>

  <div class="tab-body">
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
        <div class="pref-item">
          <div class="pref-item-caption"><v:itl key="@Account.Location"/></div>
          <div class="pref-item-value"><v:label field="<%=wks.Workstation.LocationName%>"/></div>
        </div>
        <div class="pref-item">
          <div class="pref-item-caption"><v:itl key="@Account.OpArea"/></div>
          <div class="pref-item-value"><v:label field="<%=wks.Workstation.OpAreaName%>"/></div>
        </div>
        <div id="pref-item-workstation" class="pref-item pref-item-arrow">
          <div class="pref-item-caption"><v:itl key="@Common.Workstation"/></div>
          <div class="pref-item-value"><v:label field="<%=wks.Workstation.WorkstationName%>"/></div>
        </div>
        <div id="pref-item-gate" class="pref-item" data-ItemId="<%=apt.AptOperAreaAccountId.getHtmlString()%>">
          <div class="pref-item-caption"><v:itl key="@AccessPoint.Gate"/></div>
          <div class="pref-item-value"><v:label field="<%=apt.AptOperAreaDisplayName%>"/></div>
        </div>
        <div class="pref-item">
          <div class="pref-item-caption"><v:itl key="@AccessPoint.AccessPoint"/></div>
          <div class="pref-item-value"><v:label field="<%=apt.AptName%>"/></div>
        </div>
      </div>
    </div>
  </div>
</div>
