<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="ent-timerange-dialog" class="ent-dialog" title="<v:itl key="@Entitlement.TimeRange"/>">
  <v:widget>
    <v:widget-block>
      <v:form-field caption="@Entitlement.OverallTimeRange" hint="@Entitlement.OverallTimeRangeHint">
        <v:input-text type="timepicker" field="<%=JvUtils.newSqlStrUUID()%>" clazz="ent-from-time"/>
        <v:itl key="@Common.To" transform="lowercase"/>
        <v:input-text type="timepicker" field="<%=JvUtils.newSqlStrUUID()%>" clazz="ent-to-time" />
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="@Entitlement.FirstDayTimeRange" hint="@Entitlement.FirstDayTimeRangeHint">
        <v:input-text type="timepicker" field="<%=JvUtils.newSqlStrUUID()%>" clazz="ent-firstday-from-time"/>
        <v:itl key="@Common.To" transform="lowercase"/>
        <v:input-text type="timepicker" field="<%=JvUtils.newSqlStrUUID()%>" clazz="ent-firstday-to-time" />
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="@Entitlement.SelectionTimeRange" hint="@Entitlement.SelectionTimeRangeHint">
        <v:input-text type="timepicker" field="<%=JvUtils.newSqlStrUUID()%>" clazz="ent-selection-from-time"/>
        <v:itl key="@Common.To" transform="lowercase"/>
        <v:input-text type="timepicker" field="<%=JvUtils.newSqlStrUUID()%>" clazz="ent-selection-to-time" />
      </v:form-field>
    </v:widget-block>
  </v:widget>
</div>
