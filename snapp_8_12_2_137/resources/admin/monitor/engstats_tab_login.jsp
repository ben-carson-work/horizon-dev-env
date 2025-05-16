<%@page import="com.vgs.snapp.web.bko.dataobject.DOLoginStats"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageEngineStats" scope="request"/>
<%
  pageBase.setDefaultParameter("DateFrom", JvDateTime.date().getXMLDate());
%>
<%
  pageBase.setDefaultParameter("DateTo", JvDateTime.date().getXMLDate());
%>


<script>
function doSearch() {
  asyncWidget("#stats-data", "stats/stats_login_table", "DateFrom=" + $("#DateFrom-picker").getXMLDate() + "&DateTo=" + $("#DateTo-picker").getXMLDate());
}

$(document).ready(doSearch);
</script>


<div class="tab-toolbar">
  <v:button caption="@Common.Apply" fa="search" href="javascript:doSearch()"/>
</div>

<div class="tab-content">
  <div class="profile-pic-div">
    <v:widget caption="@Common.Filters" icon="filter.png">
      <v:widget-block>
        <v:itl key="@Common.FromDate"/><br/>
        <v:input-text type="datepicker" field="DateFrom"/>
        <v:itl key="@Common.ToDate"/><br/>
        <v:input-text type="datepicker" field="DateTo"/>
      </v:widget-block>
    </v:widget>
  </div>
  
  <div class="profile-cont-div">
    <v:widget caption="@Common.Data">
      <v:widget-block>
        <v:itl key="@Stats.LoginStatsDesc"/><br/>
        &nbsp;<br/>
        
        <div id="stats-data"></div>
      </v:widget-block>
    </v:widget>
  </div>
</div>

