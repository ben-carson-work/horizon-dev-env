<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="ent-crossover-timerange-dialog" class="ent-dialog" title="<v:itl key="@Entitlement.CrossoverTimeRange"/>">
  <v:widget>
    <v:widget-block>
      <v:form-field caption="@Entitlement.CrossoverTimeRange" hint="@Entitlement.CrossoverTimeRangeHint">
        <v:input-text type="timepicker" field="<%=JvUtils.newSqlStrUUID()%>" clazz="ent-crossover-from-time"/>
        <v:itl key="@Common.To" transform="lowercase"/>
        <v:input-text type="timepicker" field="<%=JvUtils.newSqlStrUUID()%>" clazz="ent-crossover-to-time" />
      </v:form-field>
    </v:widget-block>
  </v:widget>
</div>

