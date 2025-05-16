<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="ent-reentry-dialog" class="ent-dialog" title="<v:itl key="@Entitlement.ReEntry"/>">
  <div><v:itl key="@Common.Quantity"/></div>
  <v:input-text field="reentry-qty-edit" placeholder="@Common.Unlimited"/>
</div>
