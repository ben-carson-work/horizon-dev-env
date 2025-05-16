<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.query.*"%>

<% 
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 
%>

<div id="ent-resourcebaseddays-dialog" class="ent-dialog">
  <v:form-field caption="@Common.StartValidity" hint="@Entitlement.ResourceStartDaysHint">
    <v:input-text field="resourcestartdays-qty-edit" placeholder="@Ticket.EncodeDateTime"/>
  </v:form-field>

  <v:form-field caption="@Common.Expiration" hint="@Entitlement.ResourceExpDaysHint">
    <input type="text" class="form-control" id="resourceexpdays-qty-edit"/>
  </v:form-field>
</div>
