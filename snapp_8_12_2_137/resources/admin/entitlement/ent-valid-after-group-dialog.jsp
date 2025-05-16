<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.query.*"%>

<% 
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 
%>

<div id="ent-valid-after-group-dialog" class="ent-dialog">
  <v:form-field caption="@Entitlement.Group" hint="@Entitlement.ValidAfterGroupHint">
    <v:input-text field="valid-after-group-edit"/>
  </v:form-field>
</div>
