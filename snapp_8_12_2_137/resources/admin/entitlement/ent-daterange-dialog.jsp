<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="ent-daterange-dialog" class="ent-dialog" title="<v:itl key="@Entitlement.DateRange"/>">
  <v:widget>
    <v:widget-block>
      <label class="checkbox-label"><input type="radio" id="date-range-validity-group-radio" name="date-range-validity-group-radio" value="<%=LkSNDateRangeValidityType.Valid.getCode()%>"/> <v:itl key="@Lookup.DateRangeValidityType.Valid"/> <v:hint-handle hint="@Entitlement.DateRangeValidityHint_Valid"/></label>
      &nbsp;&nbsp;&nbsp;           
      <label class="checkbox-label"><input type="radio" id="date-range-validity-group-radio" name="date-range-validity-group-radio" value="<%=LkSNDateRangeValidityType.Invalid.getCode()%>"/> <v:itl key="@Lookup.DateRangeValidityType.Invalid"/> <v:hint-handle hint="@Entitlement.DateRangeValidityHint_Invalid"/></label>           
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="@Common.FromDate">
        <v:input-text type="datepicker" field="<%=JvUtils.newSqlStrUUID()%>" clazz="from-date-picker" placeholder="@Common.Unlimited"/>
      </v:form-field>
      <v:form-field caption="@Common.ToDate">
        <v:input-text type="datepicker" field="<%=JvUtils.newSqlStrUUID()%>" clazz="to-date-picker" placeholder="@Common.Unlimited" />
      </v:form-field>
    </v:widget-block>
  </v:widget>
</div>
