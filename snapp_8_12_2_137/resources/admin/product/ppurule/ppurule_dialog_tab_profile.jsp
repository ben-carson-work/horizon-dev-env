<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="ppurule" class="com.vgs.snapp.dataobject.DOPPURule" scope="request"/>

<div class="tab-content">
  <v:widget caption="@Common.Profile">
    <v:widget-block>
      <v:form-field caption="@Product.MembershipPoint" mandatory="true">
        <%
        JvDataSet dsMembershipPoint = pageBase.getBL(BLBO_RewardPoint.class).getRewardPointDS(true);
        %>
        <v:combobox field="ppurule.MembershipPointId" lookupDataSet="<%=dsMembershipPoint%>" captionFieldName="MembershipPointName" idFieldName="MembershipPointId" allowNull="false"/>
      </v:form-field>
      <v:form-field caption="@Common.Value" mandatory="true">
        <v:input-text field="ppurule.MembershipPointValue"/>
      </v:form-field>
      <v:form-field caption="@Common.Priority" mandatory="true">
        <v:input-text field="ppurule.PriorityOrder"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:db-checkbox field="ppurule.Active" caption="@Common.Active" value="true"/>
    </v:widget-block>
  </v:widget>

  <v:widget caption="@Common.DateTime">
    <v:widget-block>
      <v:form-field caption="@Common.Calendar">
        <% JvDataSet dsCalendar = pageBase.getBL(BLBO_Calendar.class).getCalendarDS(ppurule.CalendarId.getString()); %>
        <v:combobox field="ppurule.CalendarId" lookupDataSet="<%=dsCalendar%>" captionFieldName="CalendarName" idFieldName="CalendarId"/>
      </v:form-field>
      <v:form-field caption="@Common.FromDate" hint="@Common.PPURuleFromDateHint">
        <v:input-text type="datepicker" field="ppurule.ValidDateFrom" placeholder="@Common.Unlimited"/>
        &nbsp;&nbsp;&nbsp; <v:itl key="@Common.To" transform="lowercase"/> <v:hint-handle hint="@Common.PPURuleToDateHint"/>&nbsp;&nbsp;&nbsp; 
        <v:input-text type="datepicker" field="ppurule.ValidDateTo" placeholder="@Common.Unlimited" />
      </v:form-field>
      <v:form-field caption="@Common.FromTime">
        <v:input-text type="timepicker" field="ppurule.ValidTimeFrom" placeholder="@Common.Unlimited"/>
        &nbsp;&nbsp;&nbsp; <v:itl key="@Common.To" transform="lowercase"/> &nbsp;&nbsp;&nbsp;
        <v:input-text type="timepicker" field="ppurule.ValidTimeTo" placeholder="@Common.Unlimited"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
</div>

