<%@page import="com.vgs.snapp.dataobject.DOCalendar"%>
<%@page import="com.vgs.web.service.SrvBO_OC"%>
<%@page import="com.vgs.web.library.BLBO_Calendar"%>
<%@page import="com.vgs.web.library.BLBO_Product"%>
<%@page import="com.vgs.snapp.dataobject.DOSaleCapacity"%>
<%@page import="com.vgs.web.library.BLBO_SaleCapacity"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
String productId = pageBase.getNullParameter("ProductId");
String calendarId = pageBase.getBL(BLBO_Product.class).findStopSaleCalendarId(productId);
request.setAttribute("id", calendarId);
DOCalendar cal;
if (calendarId != null) 
  cal = SrvBO_OC.getCalendar(pageBase.getConnector(), calendarId, true).Calendar;
else
  cal = pageBase.getBL(BLBO_Calendar.class).prepareNewCalendar(LkSNCalendarType.InternalUse);
%>


<v:dialog id="stopsale-dialog" tabsView="true" width="800" height="600" title="@Product.StopSaleCalendar">

  <v:tab-group name="tab" main="true">
    <v:tab-item-embedded tab="tabs-main" caption="@Common.Calendar" default="true">
      <div class="tab-content">
        <div class="stopsale-legend">
          <div class="stopsale-legend-item stopsale-legend-soft"><i class="fa fa-exclamation-circle"></i>&nbsp;<v:itl key="@Lookup.StopSaleType.Soft"/></div>
          <div class="stopsale-legend-item stopsale-legend-hard"><i class="fa fa-ban"></i>&nbsp;<v:itl key="@Lookup.StopSaleType.Hard"/></div>
        </div>
        
        <v:cal-month showYearOnTitle="true" showMonthNav="true"/>
      </div>
    </v:tab-item-embedded>
  
    <v:tab-item-embedded tab="tabs-history" caption="@Common.History">
      <jsp:include page="../common/page_tab_historydetail.jsp"/>
    </v:tab-item-embedded>
  </v:tab-group>
  
  <div id="stopsale-templates" class="hidden">
    <div class="stopsale-icon stopsale-icon-soft"><i class="fa fa-exclamation-circle"></i></div>
    <div class="stopsale-icon stopsale-icon-hard"><i class="fa fa-ban"></i></div>
  </div>
  
<style>
  <%@ include file="stopsale_dialog.css" %>
</style>


<script>
$(document).ready(function() {
  var stopSaleData = <%=cal.getJSONString()%>;
  const PRODUCT_ID = <%=JvString.jsString(productId)%>;
  const CAN_EDIT = <%=pageBase.isParameter("CanEdit", "true")%>;
  const MAP_STOPSALE = {
    "soft": <%=LkSNStopSaleType.Soft.getCode()%>,
    "hard": <%=LkSNStopSaleType.Hard.getCode()%>
  };

  <%@ include file="stopsale_dialog.js" %>
});
</script>  

</v:dialog>