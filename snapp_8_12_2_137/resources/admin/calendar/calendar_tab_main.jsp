<%@page import="java.util.Calendar"%>
<%@page import="java.text.*"%>
<%@page import="com.vgs.snapp.web.bko.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.bko.page.PageBO_Calendar" scope="request"/>
<jsp:useBean id="cal" class="com.vgs.snapp.dataobject.DOCalendar" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% boolean canEdit = rights.SettingsCalendars.getBoolean(); %>

<jsp:include page="calendar_tab_main-css.jsp"/>
<jsp:include page="calendar_tab_main-js.jsp"/>

<div class="tab-toolbar">
  <v:button fa="save" caption="@Common.Save" onclick="doSaveCalendar()"/>
  
  <% if (!pageBase.isNewItem()) { %>
    <% String clickHistory = "asyncDialogEasy('common/history_detail_dialog', 'id=" + pageBase.getId() + "');"; %>
    <v:button caption="@Common.History" fa="history" onclick="<%=clickHistory%>"/>
  <% } %>
  <span class="divider"></span>
  <% String hrefExport = ConfigTag.getValue("site_url") + "/admin?page=export&EntityIDs=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Calendar.getCode(); %> 
  <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" href="<%=hrefExport%>"/>
</div>

<div class="tab-content snapp-calendar">
  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="@Common.Code" mandatory="true">
        <v:input-text field="cal.CalendarCode" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Common.Name" mandatory="true">
        <v:input-text field="cal.CalendarName" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Category.Category">
        <v:combobox field="cal.CategoryId" lookupDataSet="<%=pageBase.getBL(BLBO_Category.class).getCategoryAshedTreeDS(LkSNEntityType.Calendar)%>" idFieldName="CategoryId" captionFieldName="AshedCategoryName" linkEntityType="<%=LkSNEntityType.Category%>" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:db-checkbox field="cal.Enabled" value="true" caption="@Common.Enabled"/>
      <v:form-field caption="@Common.ValidDaysInThePast" hint="@Common.ValidDaysInThePastHint">
        <v:input-text field="cal.ValidDaysInThePast" placeholder="180"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:db-checkbox field="cal.DatedCalendar" value="true" caption="@Common.DatedCalendar" enabled="<%=canEdit%>"/>
      <div id="dated-block" class="hidden">
        <v:form-field caption="@Account.Location" mandatory="true">
          <snp:dyncombo entityType="<%=LkSNEntityType.Location%>" field="cal.DatedLocationId" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Account.AccessArea" mandatory="true">
          <snp:dyncombo entityType="<%=LkSNEntityType.AccessArea%>" field="cal.DatedAccessAreaId" parentComboId="cal.DatedLocationId" enabled="<%=canEdit%>"/>
        </v:form-field>
      </div>
    </v:widget-block>
  </v:widget>
  
  <div>
    <div id="cal-left-column">
      <v:widget id="tools-widget" caption="@Common.Tools">
        <v:widget-block>
			    <span class="flat-button flat-button-prev" onclick="changeYear(-1)"></span>
			    <span class="flat-button flat-button-next" onclick="changeYear(+1)"></span>
          <span id="current-year"></span>
        </v:widget-block>
        <v:widget-block>
          <div class="tool-title"><v:itl key="@Performance.PerformanceTypes"/></div>
          <div class="tool-item" data-toolgroup="PT" data-id="DEFAULT" onclick="toolItemClick(this)">
            <div class="tool-item-color" style="background-color:white"></div>
            <div class="tool-item-name"><v:itl key="@Common.Default" transform="uppercase"/></div>
          </div>
          <% JvDataSet dsPT = pageBase.getBL(BLBO_PerformanceType.class).getDS(); %>
          <v:ds-loop dataset="<%=dsPT%>">
            <style>.cal-day[data-pt='<%=dsPT.getField("PerformanceTypeId").getHtmlString()%>'] {background-color:#<%=dsPT.getField("PerformanceTypeColor").getHtmlString()%>}</style>
            <div class="tool-item" data-toolgroup="PT" data-id="<%=dsPT.getField("PerformanceTypeId").getHtmlString()%>" onclick="toolItemClick(this)">
              <div class="tool-item-color" style="background-color:#<%=dsPT.getField("PerformanceTypeColor").getHtmlString()%>"></div>
              <div class="tool-item-name"><%=dsPT.getField("PerformanceTypeName").getHtmlString()%></div>
            </div>
          </v:ds-loop>
        </v:widget-block>
        <v:widget-block>
          <div class="tool-title"><v:itl key="@Common.RateCodes"/></div>
          <div class="tool-item" data-toolgroup="RC" data-id="DEFAULT" onclick="toolItemClick(this)">
            <v:itl key="@Common.Default" transform="uppercase"/>
          </div>
          <% JvDataSet dsRC = pageBase.getBL(BLBO_RateCode.class).getDS(); %>
          <v:ds-loop dataset="<%=dsRC%>">
            <div class="tool-item" data-toolgroup="RC" data-id="<%=dsRC.getField("RateCodeId").getHtmlString()%>" data-code="<%=dsRC.getField("RateCodeCode").getHtmlString()%>" data-symbol="<%=dsRC.getField("RateCodeSymbol").getHtmlString()%>" onclick="toolItemClick(this)">
              [<%=dsRC.getField("RateCodeCode").getHtmlString()%>]
              <% String symbol = dsRC.getField("RateCodeSymbol").getString(); %>
              <% if (symbol != null) { %>
                <i class="fa fa-<%=symbol%>"></i>
              <% } %>
              <%=dsRC.getField("RateCodeName").getHtmlString()%>
            </div>
          </v:ds-loop>
        </v:widget-block>
      </v:widget>
    </div>
 
    <div id="cal-center-column">
		  <div id="calendar" class="row noselect">
		  <% for (int m=1; m<=12; m++) { %>
		    <div class="col-lg-4 col-sm-6 cal-month-container">
          <v:cal-month month="<%=m%>"/>
		    </div>
		  <% } %>
		  </div>
    </div>
  </div>
  
</div>