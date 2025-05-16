<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="ent-override-dialog" class="ent-dialog" title="<v:itl key="@Entitlement.ExtraEntry"/>">
  <div><v:itl key="@Common.Quantity"/></div>
  <v:input-text field="override-qty-edit" placeholder="@Common.Unlimited"/>
</div>
