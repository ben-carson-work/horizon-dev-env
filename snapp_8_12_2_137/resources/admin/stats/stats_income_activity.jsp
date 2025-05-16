<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.bko.page.PageBO_StatsIncomeActivity" scope="request"/>
<jsp:useBean id="data" class="com.vgs.web.dataobject.DOGeneralActivity" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>
<jsp:include page="/resources/common/amchart-include.jsp"><jsp:param name="amchart-graphs" value="serial,pie"/></jsp:include>

<v:page-title-box/>

<style>
  #custom-date-table.disabled {
    color: rgba(0,0,0,0.6);
  }
  
  .chart {
    min-height: 300px;
  }
  
  .pie-chart{
    min-height: 300px;
  }

</style>

<jsp:include page="stats_income_activity_js.jsp"/>


<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Dashboard" default="true">

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
        <v:widget caption="@Account.Location">
          <v:widget-block>
            <v:itl key="@Account.Location"/><br/>
            <snp:dyncombo id="LocationId" entityType="<%=LkSNEntityType.Location%>" auditLocationFilter="true" allowNull="<%=(rights.AuditLocationFilter.isLookup(LkSNAuditLocationFilter.All) ? true : false) %>"/> 
            
            <br/>
            
            <label for="OperatingAreaId"><v:itl key="@Account.OpArea"/></label><br/>
            <select id="OperatingAreaId" multiple></select>
          </v:widget-block>
        </v:widget>
        
        <v:widget caption="@Product.ProductTags">
          <v:widget-block>
            <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
            <v:multibox field="TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName"/>
          </v:widget-block>
        </v:widget>
      </v:profile-recap>
       
      <v:profile-main>
        <div class="container-fluid">
          <div id="stat-boxes" class="row"></div>
          <div class="row">
            <div class="col-md-12">
              <div id="amount-chart" class="chart"></div>
            </div>
          </div>
        </div>
        
        <v:stat-section id="stat-payment" title="@Payment.PaymentMethods">
          <div class="container-fluid">
            <div class="row">
              <div class="col-lg-6 col-md-12">
                <v:grid id="payment-grid" style="margin-top:5px;">
                  <tbody></tbody>
                </v:grid>
              </div>
              <div id="payment-container" class="col-lg-6 col-md-12">
                <div id="payment-chart" class="pie-chart"></div>              
              </div>
            </div>
          </div>
        </v:stat-section>

        <div class="container-fluid">
          <div class="row">
            <v:stat-section title="@Product.PrintGroups" clazz="col-lg-6 col-md-12">
              <div id="pdt-print-chart" class="pie-chart"></div>
            </v:stat-section>
            <v:stat-section title="@Product.FinanceGroups" clazz="col-lg-6 col-md-12">
              <div id="pdt-fin-chart" class="pie-chart"></div>
            </v:stat-section>
          </div>
          <div class="row">
            <v:stat-section title="@Product.AdmGroups" clazz="col-lg-6 col-md-12">
              <div id="pdt-adm-chart" class="pie-chart"></div>
            </v:stat-section>
            <v:stat-section title="@Product.AreaGroups" clazz="col-lg-6 col-md-12">
              <div id="pdt-area-chart" class="pie-chart"></div>
            </v:stat-section>
          </div>
        </div>
        
        <div class="container-fluid">
          <div class="row">
            <div class="col-lg-6 col-md-12">
              <v:grid id="product-grid">
                <thead><v:grid-title caption="@Stats.ProductTypesTop20"/></thead>
                <tbody></tbody>
              </v:grid>
            </div>
            <div class="col-lg-6 col-md-12">
              <v:grid id="event-grid">
                <thead><v:grid-title caption="@Stats.EventsTop20"/></thead>
                <tbody></tbody>
              </v:grid>
            </div>
          </div>
        </div>
      </v:profile-main>
    </v:tab-content>

  </v:tab-item-embedded>
</v:tab-group>
 
<jsp:include page="/resources/common/footer.jsp"/>
