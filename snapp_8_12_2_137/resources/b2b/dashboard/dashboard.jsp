<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.b2b.page.PageB2B_Dashboard" scope="request"/>


<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<style>
.mainlist-container {
  padding:5px
}

.dashboard-widget {
  float: left;
  width: 20%;
  box-sizing: border-box;
  padding: 5px;
  overflow: hidden;
}

.dashboard-widget .postbox {
  min-height: 288px;
  margin: 0;
}

.dashboard-widget td {
  white-space: nowrap;
}

.dashboard-red-value {
  color: var(--base-red-color);
}

@media all and (max-width:1500px) {
  .dashboard-widget {width: 33.33%}
}

@media all and (max-width:1024px) {
  .dashboard-widget {width: 50%}
}

@media all and (max-width:850px) {
  .dashboard-widget {width: 100%}
}

</style>

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="dashboard" caption="@Common.Dashboard" default="true">
    <div class="mainlist-container">
      <div class="dashboard-widget"><jsp:include page="widget_account_profile.jsp"/></div>
      <div class="dashboard-widget"><jsp:include page="widget_finance_recap.jsp"/></div>
      <div class="dashboard-widget"><jsp:include page="widget_lastorders.jsp"/></div>
      <div class="dashboard-widget"><jsp:include page="widget_finance_lastcredits.jsp"/></div>
      <div class="dashboard-widget"><jsp:include page="widget_finance_lastactivity.jsp"/></div>
    </div>
  </v:tab-item-embedded>
</v:tab-group>
 
<jsp:include page="/resources/common/footer.jsp"/>

