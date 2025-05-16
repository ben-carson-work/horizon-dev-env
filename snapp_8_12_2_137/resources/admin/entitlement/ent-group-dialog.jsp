<%@page import="com.vgs.cl.JvUtils"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="ent-group-dialog" class="ent-dialog" title="<v:itl key="@Entitlement.Group"/>">
  <div><v:itl key="@Common.Code"/></div>
  <v:input-text field="group-code-edit"/>
</div>
