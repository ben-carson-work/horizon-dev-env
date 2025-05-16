<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.bko.page.PageBO_StatsGeneralActivity" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
String defaultLocationId = rights.MasterLocationId.isNull(pageBase.getSession().getLocationId());
String dateFromDefault = pageBase.getFiscalDate().getXMLDate();
String dateToDefault = pageBase.getFiscalDate().getXMLDate();
pageBase.setDefaultParameter("DateFrom", dateFromDefault);
pageBase.setDefaultParameter("DateTo", dateToDefault);
%>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>



<script>

function getStringParam(selector) {
  var value = $(selector).val();
  return (value == null) ? "" : value;
}

function doApply() {
  setGridUrlParam("#genactivity-data", "DateFrom", $("#DateFrom-picker").getXMLDate());
  setGridUrlParam("#genactivity-data", "DateTo", $("#DateTo-picker").getXMLDate());
  setGridUrlParam("#genactivity-data", "LocationId", getStringParam("#LocationId"));
  setGridUrlParam("#genactivity-data", "OpAreaId", getStringParam("#OpAreaId"));
  setGridUrlParam("#genactivity-data", "WorkstationId", getStringParam("#WorkstationId"));
  changeGridPage("#genactivity-data", "first");
}

function getDocExecParams() {
  return 
      "p_DateFrom=" + $("#DateFrom").val() + "&" +
      "p_DateTo=" + $("#DateTo").val() + "&" +
      "p_LocationId=" + getStringParam("#LocationId") + "&" +
      "p_OpAreaId=" + getStringParam("#OpAreaId") + "&" +
      "p_WorkstationId=" + getStringParam("#WorkstationId");
}

</script>



<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Dashboard" default="true">
    <div class="tab-toolbar">
      <v:button caption="@Common.Apply" fa="search" href="javascript:doApply()"/>
      <snp:btn-report docContext="<%=LkSNContextType.Dashboard_GeneralActivity%>"/>
    </div>
  
    <div class="tab-content">
      <div class="profile-pic-div">
        <v:widget caption="@Common.DateRange">
          <v:widget-block>
            <v:itl key="@Common.FromDate"/><br/>
            <v:input-text type="datepicker" field="DateFrom"/>
            <br/>
            <v:itl key="@Common.ToDate"/><br/>
            <v:input-text type="datepicker" field="DateTo"/>
          </v:widget-block>
        </v:widget>
        
        <v:widget caption="@Account.Location">
          <v:widget-block>
            <v:itl key="@Account.Location"/><br/>
            <snp:dyncombo id="LocationId" entityType="<%=LkSNEntityType.Location%>" entityId="<%=defaultLocationId%>" auditLocationFilter="true" allowNull="false"/>
            
            <br/>
            
            <v:itl key="@Account.OpArea"/><br/>
            <snp:dyncombo id="OpAreaId" entityType="<%=LkSNEntityType.OperatingArea%>" parentComboId="LocationId" auditLocationFilter="true"/>
            
            <br/>
            
            <v:itl key="@Common.Workstation"/><br/>
            <snp:dyncombo id="WorkstationId" entityType="<%=LkSNEntityType.Workstation%>" parentComboId="OpAreaId" auditLocationFilter="true"/>
          </v:widget-block>
        </v:widget>
      </div>
      
      <div class="profile-cont-div">
        <% String params = "DateFrom=" + dateFromDefault + "&DateTo=" + dateToDefault + "&LocationId=" + JvString.getEmpty(defaultLocationId); %>
        <v:async-grid id="genactivity-data" jsp="stats/stats_general_activity_data.jsp" params="<%=params%>"/>
      </div>
    </div>
  </v:tab-item-embedded>
</v:tab-group>

<jsp:include page="/resources/common/footer.jsp"/>
