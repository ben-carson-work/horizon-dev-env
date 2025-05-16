<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.query.*"%>

<% 
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 
%>

<div id="ent-secusage-waitdays-dialog" class="ent-dialog">
  <v:form-field caption="@Entitlement.SecUsageWaitDays" hint="@Entitlement.SecUsageWaitDaysHint">
    <v:input-text field="secusage-waitdays-edit" placeholder="0"/>
  </v:form-field>
</div>
