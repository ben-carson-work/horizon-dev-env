<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageEngineStats" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<script src="<v:config key="site_url"/>/libraries/amcharts/amcharts.js"></script>
<script src="<v:config key="site_url"/>/libraries/amcharts/serial.js"></script>
<script src="<v:config key="site_url"/>/libraries/amcharts/pie.js"></script>
<script src="<v:config key="site_url"/>/libraries/amcharts/plugins/export/export.min.js"></script>
<link rel="stylesheet" href="<v:config key="site_url"/>/libraries/amcharts/plugins/export/export.css" type="text/css" media="all" />
<script src="<v:config key="site_url"/>/libraries/amcharts/themes/light.js"></script>

<script>var graphLang = "en";</script>
<% if (!rights.LangISO.isNull() && !rights.LangISO.isSameString("en")) { %>
  <script src="<v:config key="site_url"/>/libraries/amcharts/lang/<%=rights.LangISO.getEmptyString().toLowerCase()%>.js"></script>
  <script>graphLang = <%=JvString.jsString(rights.LangISO.getEmptyString().toLowerCase())%>;</script>
<% } %>

<style>
  .chart-row{
    padding: 5px;
  }

  #custom-date-table.disabled {
    color: rgba(0,0,0,0.6);
  }
  
  .APIchart {
    min-height: 250px;
  }
  
  .chart-container{
    min-height: 750px;
    background-color: var(--content-bg-color);
    border: 1px solid var(--border-color);
    border-radius: 4px;
  }
  
  .list-title {
    color: #21759b;
  }
 
</style>
<jsp:include page="../stats/stats_all_js.jsp"/>
<jsp:include page="../stats/stats_all_css.jsp" />
<jsp:include page="engstats_tab_apis_js.jsp"/>

  <v:tab-toolbar>
    <v:button caption="@Common.Refresh" fa="sync-alt" onclick="doApply()"/>
    
    <div id="btnset-grouping" class="btn-group" role="group" style="float:right">
      <% for (LookupItem item : LkSN.StatGrouping.getItems()) { %>
        <button id="btn-grouping-<%=item.getCode()%>" type="button" class="btn btn-default" data-value="<%=item.getCode()%>"><v:itl key="<%=item.getRawDescription()%>"/></button>
      <% } %>
    </div>
  </v:tab-toolbar>

  <v:tab-content>
 
    <v:profile-recap>
      <v:widget caption="@Common.DateRange">
        <v:widget-block>
          <v:itl key="@Stats.DatesInterval"/><br/>
          <v:lk-combobox field="StatInterval" lookup="<%=LkSN.StatInterval%>" allowNull="false"/>
          <table id="custom-date-table" style="width:100%;border:0;">
            <tr>
              <td width="50%">
                <v:itl key="@Common.FromDate"/><br/>
                <v:input-text type="datepicker" field="DateFrom"/>
              </td>
              <td>&nbsp;</td>
              <td width="50%">
                <v:itl key="@Common.ToDate"/><br/>
                <v:input-text type="datepicker" field="DateTo"/>
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
          <table id="custom-date-table" style="width:100%;border:0;margin-top:10px">
            <tr>
              <td width="50%"><v:input-text type="datepicker" field="CompareDateFrom"/></td>
              <td>&nbsp;</td>
              <td width="50%"><v:input-text type="datepicker" field="CompareDateTo"/></td>
            </tr>
          </table>        
        </v:widget-block>
      </v:widget>
      <v:widget caption="@Common.Server">
        <v:widget-block>
          <snp:dyncombo id="ServerId" entityType="<%=LkSNEntityType.Server%>" auditLocationFilter="false" allowNull="true"/>
        </v:widget-block>
      </v:widget>
      <v:widget caption="@Common.Services">
        <v:widget-block>
          <v:itl key="@Common.Services"/><br/>
          <snp:dyncombo id="Service" entityType="<%=LkSNEntityType.ApiRequestCode%>" auditLocationFilter="false" allowNull="true"/>
          <br/>
          <label for="Command"><v:itl key="@Common.Command"/></label><br/>
          <select id="Command" multiple></select>
        </v:widget-block>
      </v:widget>
    </v:profile-recap>
 
    <v:profile-main>
      <div class="container-fluid"> 
        <div class="row chart-row">
          <div class="col-md-12 chart-container">
            <div id="count-chart" class="APIchart"></div>
            <div id="avg-chart" class="APIchart"></div>
            <div id="max-chart" class="APIchart"></div>
          </div>
        </div>
        <div class="row">
          <v:alert-box type="info" style="margin-top:20px">
            <strong>APIs Count / Average / Max / Min</strong>
            <ul>
              <li><strong>Current/Prevous interval</strong>: expressed as <strong>Value (Percentage across all API calls)</strong></li>
              <li><strong>Variation</strong>: Deviation from the compared range in percentage</li>
            </ul>
          </v:alert-box>
          
          <div class="col-lg-6 col-md-6">
            <v:grid id="count-grid">
              <thead><v:grid-title caption="@System.CountTop10" hint="@System.CountTop10Hint"/></thead>
              <thead>
                <tr>
                  <td width="100%">API</td>
                  <td><v:itl key="@Stats.CurrentInterval"/></td>
                  <td><v:itl key="@Stats.PreviousInterval"/></td>
                  <td><v:itl key="@Stats.Variation"/></td>
                </tr>
              </thead>
              <tbody></tbody>
            </v:grid>
          </div>
          <div class="col-lg-6 col-md-6">
            <v:grid id="average-grid">
              <thead><v:grid-title caption="@System.AverageTop10" hint="@System.AverageTop10Hint"/></thead>
              <thead>
                <tr>
                  <td width="100%">API</td>
                  <td><v:itl key="@Stats.CurrentInterval"/></td>
                  <td><v:itl key="@Stats.PreviousInterval"/></td>
                  <td><v:itl key="@Stats.Variation"/></td>
                </tr>
              </thead>
              <tbody></tbody>
            </v:grid>
          </div>
          <div class="col-lg-6 col-md-6">
            <v:grid id="max-grid">
              <thead><v:grid-title caption="@System.MaxTop10" hint="@System.MaxTop10Hint"/></thead>
              <thead>
                <tr>
                  <td width="100%">API</td>
                  <td><v:itl key="@Stats.CurrentInterval"/></td>
                  <td><v:itl key="@Stats.PreviousInterval"/></td>
                  <td><v:itl key="@Stats.Variation"/></td>
                </tr>
              </thead>
              <tbody></tbody>
            </v:grid>
          </div>
          <div class="col-lg-6 col-md-6">
            <v:grid id="min-grid">
              <thead><v:grid-title caption="@System.MinTop10" hint="@System.MinTop10Hint"/></thead>
              <thead>
                <tr>
                  <td width="100%">API</td>
                  <td><v:itl key="@Stats.CurrentInterval"/></td>
                  <td><v:itl key="@Stats.PreviousInterval"/></td>
                  <td><v:itl key="@Stats.Variation"/></td>
                </tr>
              </thead>
              <tbody></tbody>
            </v:grid>
          </div>
        </div>
      </div>
    </v:profile-main>
  </v:tab-content>
