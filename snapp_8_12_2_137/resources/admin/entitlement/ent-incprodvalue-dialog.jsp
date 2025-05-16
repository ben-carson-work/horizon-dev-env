<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="ent-incprodvalue-dialog" class="ent-dialog" title="<v:itl key="@Entitlement.IncProdValue"/>">
  <div><v:itl key="@Common.Amount"/></div>
  <v:input-text field="incprod-value-edit"/>
</div>
