<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib uri="vgs-tags" prefix="v" %>


<div id="ent-aptsingleusemin-dialog" class="ent-dialog" title="<v:itl key="@Entitlement.AptSingleUseMinutes"/>">
  <v:alert-box type="info"><v:itl key="@Entitlement.AptSingleUseMinutesHint"/></v:alert-box>
  <div><v:itl key="@Performance.Minutes"/></div>
  <v:input-text field="single-use-min-edit" placeholder="@Common.Unlimited"/>
</div>
