<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib uri="vgs-tags" prefix="v" %>


<div id="ent-antipassbackmin-dialog" class="ent-dialog" title="<v:itl key="@Entitlement.AntiPassBackMinutes"/>">
  <div><v:itl key="@Performance.Minutes"/></div>
  <v:input-text field="minutes-qty-edit" placeholder="@Common.Unlimited"/>
</div>
