<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccessLog" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="../common/header.jsp"/>
<v:page-title-box/>

<v:last-error/>

<%
  String defaultFromDateTime = pageBase.getBrowserFiscalDate().getXMLDateTime();
  String defaultToDateTime = pageBase.getBrowserFiscalDate().addDays(1).addMins(-1).getXMLDateTime();
  
  pageBase.setDefaultParameter("FromDateTime", defaultFromDateTime);
  pageBase.setDefaultParameter("ToDateTime", defaultToDateTime);
  boolean canAdjustAdmissionsCount = rights.AdjustAdmissionsCount.getBoolean();
%>

<script>

$(document).ready(function(){
	$("#search-btn").click(search)

	function search() {
		var dateFrom = $("#FromDateTime-picker").datepicker("getDate");
		var dateTo = $("#ToDateTime-picker").datepicker("getDate");
		
		if (checkMaxDateRange(dateFrom, dateTo, <%=rights.SearchesMaxDateRange.getInt()%>)) {
			setGridUrlParam("#accesslog-grid", "GoodTicketOnly", "");
		  setGridUrlParam("#accesslog-grid", "BadTicketOnly", "");
		  setGridUrlParam("#accesslog-grid", "Reconciled", "");
		  if ($("#RedemptionOK").isChecked() ^ $("#RedemptionKO").isChecked()) {
		    if ($("#RedemptionOK").isChecked())
		      setGridUrlParam("#accesslog-grid", "GoodTicketOnly", "true");
		    if ($("#RedemptionKO").isChecked())
		      setGridUrlParam("#accesslog-grid", "BadTicketOnly", "true");
		    
		  }
		  if ($("#Reconciled").isChecked())
	      setGridUrlParam("#accesslog-grid", "Reconciled", "true");
		  setGridUrlParam("#accesslog-grid", "FromDateTime", $("#FromDateTime-picker").getXMLDateTime());
		  setGridUrlParam("#accesslog-grid", "ToDateTime", $("#ToDateTime-picker").getXMLDateTime(true));
		  setGridUrlParam("#accesslog-grid", "UsageType", $("[name='UsageType']").getCheckedValues());
		  setGridUrlParam("#accesslog-grid", "LocationId", $("#LocationId").val());
		  setGridUrlParam("#accesslog-grid", "AccessAreaId", $("#AccessAreaId").val());
		  setGridUrlParam("#accesslog-grid", "AccessPointId", $("#AccessPointId").val(), true);
		}
	}

});

</script>


<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <v:button id="search-btn" caption="@Common.Search" fa="search"/>
      <% String clickAdjustAdmissions = "asyncDialogEasy('adjust_admissions_count_dialog', 'id=" + pageBase.getId() + "')"; %>
      <v:button id="adjust-admissions-count--btn" caption="@Right.AdjustAdmissionsCount" fa="sliders-v-square" onclick="<%=clickAdjustAdmissions%>" enabled="<%=canAdjustAdmissionsCount%>"/>
      <v:pagebox gridId="accesslog-grid"/>
    </div>
    
    <div class="tab-content">
      <div class="profile-pic-div">
        <v:widget caption="@Common.DateRange">
          <v:widget-block>
            <v:itl key="@Common.FromDate"/><br/>
            <v:input-text type="datetimepicker" field="FromDateTime" style="width:120px"/>
            <br/>
            <v:itl key="@Common.ToDate"/><br/>
            <v:input-text type="datetimepicker" field="ToDateTime" style="width:120px"/>
          </v:widget-block>
        </v:widget>
    
        <v:widget caption="@Common.Type">
          <v:widget-block>
          <% for (LookupItem item : LkSN.TicketUsageType.getItems()) { %>
            <label><input type="checkbox" name="UsageType" value="<%=item.getCode()%>"/> <%=item.getDescription(pageBase.getLang())%></label><br/>
          <% } %>
          </v:widget-block>
          <v:widget-block>
            <label><input type="checkbox" id="RedemptionOK"/> <v:itl key="@Ticket.RedemptionOK"/></label><br/>
            <label><input type="checkbox" id="RedemptionKO"/> <v:itl key="@Ticket.RedemptionKO"/></label>
          </v:widget-block>
          <v:widget-block>
            <label><input type="checkbox" id="Reconciled"/> <v:itl key="@Ticket.UsageInvalidated"/></label>
          </v:widget-block>
        </v:widget>
    
        <v:widget caption="@Common.Filter">
          <v:widget-block>
            <v:itl key="@Account.Location"/><br/>
            <snp:dyncombo id="LocationId" entityType="<%=LkSNEntityType.Location%>" auditLocationFilter="true"/>
            <div class="filter-divider"></div>
            <v:itl key="@Account.OpArea"/><br/>
            <snp:dyncombo  id="OpAreaId" entityType="<%=LkSNEntityType.OperatingArea%>" auditLocationFilter="true" parentComboId="LocationId"/>
            <div class="filter-divider"></div>
            <v:itl key="@AccessPoint.AccessPoint"/><br/>
            <snp:dyncombo id="AccessPointId" entityType="<%=LkSNEntityType.AccessPoint%>" auditLocationFilter="true" parentComboId="OpAreaId"/>    
          </v:widget-block>
          <v:widget-block>
            <div class="filter-divider"></div>
            <v:itl key="@Account.AccessArea"/><br/>
            <snp:dyncombo id="AccessAreaId" entityType="<%=LkSNEntityType.AccessArea%>" auditLocationFilter="true" parentComboId="LocationId"/>
          </v:widget-block>
        </v:widget>
      </div>
      
      <div class="profile-cont-div">
        <% String params = "FromDateTime=" + defaultFromDateTime + "&ToDateTime=" + defaultToDateTime; %>
        <v:async-grid id="accesslog-grid" jsp="accesslog_grid.jsp" params="<%=params%>"/>
      </div>
    </div>
  </v:tab-item-embedded>
</v:tab-group>


<jsp:include page="../common/footer.jsp"/>
