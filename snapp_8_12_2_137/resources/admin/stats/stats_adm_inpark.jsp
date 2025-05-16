<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.bko.page.PageBO_StatsAdmInPark" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>

<script src="<v:config key="site_url"/>/libraries/amcharts/amcharts.js"></script>
<script src="<v:config key="site_url"/>/libraries/amcharts/serial.js"></script>
<script src="<v:config key="site_url"/>/libraries/amcharts/plugins/export/export.min.js"></script>
<link rel="stylesheet" href="<v:config key="site_url"/>/libraries/amcharts/plugins/export/export.css" type="text/css" media="all" />
<script src="<v:config key="site_url"/>/libraries/amcharts/themes/light.js"></script>

<script>var graphLang = "en";</script>
<% if (!rights.LangISO.isNull() && !rights.LangISO.isSameString("en")) { %>
  <script src="<v:config key="site_url"/>/libraries/amcharts/lang/<%=rights.LangISO.getEmptyString().toLowerCase()%>.js"></script>
  <script>graphLang = <%=JvString.jsString(rights.LangISO.getEmptyString().toLowerCase())%>;</script>
<% } %>


<v:page-title-box/>

<jsp:include page="stats_all_css.jsp"/>
<style>
  #custom-date-table.disabled {
    color: rgba(0,0,0,0.6);
  }
  
  #inpark-chart,
  #entry-chart {
    height: 300px;
  }
</style>

<jsp:include page="stats_all_js.jsp"/>
<jsp:include page="stats_adm_inpark_js.jsp"/>


<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Dashboard" default="true">
    <div class="tab-toolbar">
      <v:button caption="@Common.Refresh" fa="sync-alt" onclick="doApply()"/>
    </div>
    
    <div class="tab-content">
      <div class="profile-pic-div">
        <v:widget caption="@Common.DateRange">
          <v:widget-block>
            <table id="custom-date-table" style="width:100%;border:0;">
              <tr>
                <td width="50%">
                  <v:itl key="@Common.FiscalDate"/><br/>
                  <v:input-text type="datepicker" field="FiscalDate"/>
                </td>
                <td>&nbsp;</td>
                <td width="50%">
                  <v:itl key="@Stats.CompareDate"/><br/>
                  <v:input-text type="datepicker" field="CompareDate"/>
                </td>
              </tr>
            </table>        
          </v:widget-block>
          <v:widget-block style="text-align:center">
            <div style="margin-bottom:5px"><v:itl key="@Stats.CompareLabel"/></div>
            <div id="btnset-match" class="btn-group" role="group">
              <button type="button" class="btn btn-default" data-value="auto" title="<v:itl key="@Stats.CompareAutoHint"/>"><v:itl key="@Stats.CompareAuto"/></button>
              <button type="button" class="btn btn-default" data-value="week" title="<v:itl key="@Stats.CompareWeekHint"/>"><v:itl key="@Stats.CompareWeek"/></button>
              <button type="button" class="btn btn-default" data-value="year" title="<v:itl key="@Stats.CompareYearHint"/>"><v:itl key="@Stats.CompareYear"/></button>
            </div>
          </v:widget-block>
          <v:widget-block>
            <table style="width:100%">
              <tr>
                <td style="padding-bottom:5px"><v:itl key="@Common.Entries"/></td>
                <td style="padding-bottom:5px" align="right">
                  <div id="btnset-entry" class="btn-group" role="group">
                    <button type="button" class="btn btn-default" data-value="rdm"><v:itl key="@Stats.Scans"/></button>
                    <button type="button" class="btn btn-default" data-value="rot"><v:itl key="@Stats.Rotations"/></button>
                  </div>
                </td>
              </tr>
              <tr>
                <td><v:itl key="@Common.Exits"/></td>
                <td align="right">
                  <div id="btnset-exit" class="btn-group" role="group">
                    <button type="button" class="btn btn-default" data-value="rdm"><v:itl key="@Stats.Scans"/></button>
                    <button type="button" class="btn btn-default" data-value="rot"><v:itl key="@Stats.Rotations"/></button>
                  </div>
                </td>
              </tr>
            </table>
          </v:widget-block>
        </v:widget>
        
        <v:widget caption="@Account.Location">
          <v:widget-block>
            <v:itl key="@Account.Location"/><br/>
            <snp:dyncombo id="LocationId" entityType="<%=LkSNEntityType.Location%>" auditLocationFilter="true" allowNull="false"/> 
            
            <br/>
            
            <label for="AccessAreaId"><v:itl key="@Account.AccessArea"/></label><br/>
            <select id="AccessAreaId" multiple></select>
          </v:widget-block>
        </v:widget>
      </div>
      
      <div class="profile-cont-div">
    
        <div class="container-fluid">
          <div id="entry-stat-boxes"class="row"></div>
          <div class="row">
            <div class="col-md-12">
              <div id="inpark-chart" class="chart"></div>
            </div>
          </div>
          <div class="row">
            <div class="col-md-12">
              <div id="entry-chart" class="chart"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
    
  </v:tab-item-embedded>
</v:tab-group>
 
<jsp:include page="/resources/common/footer.jsp"/>
