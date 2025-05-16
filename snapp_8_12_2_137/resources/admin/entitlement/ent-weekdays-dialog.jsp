<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<div id="ent-weekdays-dialog" class="ent-dialog" title="<v:itl key="@Entitlement.WeekDays"/>">
  <v:alert-box type="info"><v:itl key="@Entitlement.WeekDaysHint"/></v:alert-box>
  
  <v:grid id="day-of-week">
    <thead>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="100%"><v:itl key="@Common.DayOfWeek"/></td>
      </tr>
    </thead>
    <tbody>
    <% String[] weekdays = DateFormatSymbols.getInstance(pageBase.getLocale()).getWeekdays(); %>
    <% int start = Calendar.getInstance(pageBase.getLocale()).getFirstDayOfWeek(); %>
    <% for (int i=start; i<start+7; i++) { %>
    <%   int value = ((i-1)%7)+1; %>
    <%   String dow = weekdays[value]; %>
      <tr>
        <% String cbid = "weekdays-cb-" + value; %>
        <td><v:grid-checkbox id="<%=cbid%>" name="weekdays-cb" value="<%=String.valueOf(value)%>"/></td>
        <td><label for="<%=cbid%>"><%=JvString.escapeHtml(JvString.getPascalCase(dow))%></label></td>
      </tr>
    <% } %>
    </tbody>
  </v:grid>
</div>
