<%@page import="com.vgs.dataobject.DOWsLang"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_DocTemplate.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
String expirationRuleCode = pageBase.getParameter("ExpirationRule");
String firstUsageRuleCode = pageBase.getParameter("FirstUsageRule");

boolean isFirstUsageRule = false;
boolean dateRange = false;
String title = "noTitle";
LookupItem rule;

if (expirationRuleCode != null) {
  rule = LkSN.ExpirationRule.getItemByCode(expirationRuleCode);
  dateRange = rule.isLookup(LkSNExpirationRule.VarDateRange);
  title = rule.getDescription(pageBase.getLang());
}
else if (firstUsageRuleCode != null) {
  rule = LkSN.FirstUsageRule.getItemByCode(firstUsageRuleCode);
  dateRange = rule.isLookup(LkSNFirstUsageRule.VarDateRange);
  title = pageBase.getLang().Product.VarFirstUsageRule.getText() + ": " + rule.getDescription(pageBase.getLang());
  isFirstUsageRule = true;
}
else
  throw new RuntimeException("Either paramter ExpirationRule or FirstUsageRule are missing");


int width = dateRange ? 610 : 310;
%>

<v:dialog id="variabledate_dialog" title="<%=title%>" width="<%=width%>" autofocus="false">

<script>

var dlg = $("#variabledate_dialog");
var datePickerFrom = dlg.find("#datepicker-from");
var datePickerTo = dlg.find("#datepicker-to");
dlg.on("snapp-dialog", function(event, params) {
  params.buttons = [
    {
      "text": itl("@Common.Ok"),
      "class": "hl-green",
      "click": doVariableDateOK
    },
    {
      "text": itl("@Common.Cancel"),
      "class": "hl-green",
      "click": doVariableDateCANCEL
    }
  ];
  
  datePickerFrom.datepicker({
    onSelect: function() {
      var dateFrom = datePickerFrom.datepicker("getDate");
      var dateTo = datePickerTo.datepicker("getDate");
      if (dateFrom > dateTo)
        datePickerTo.datepicker("setDate", dateFrom);
    }
  });
      
  datePickerTo.datepicker({
    onSelect: function() {
      var dateFrom = datePickerFrom.datepicker("getDate");
      var dateTo = datePickerTo.datepicker("getDate");
      if (dateFrom > dateTo)
        datePickerFrom.datepicker("setDate", dateTo);
    }
  });
});

function doVariableDateOK() {
  var xmlDateFrom = dateToXML(datePickerFrom.datepicker("getDate"));
  var xmlDateTo = (datePickerTo.length == 0) ? "" : dateToXML(datePickerTo.datepicker("getDate"));
  var validFrom = null;
  var validTo = null;
  <% if (rule.isLookup(isFirstUsageRule ? LkSNFirstUsageRule.VarDateRange : LkSNExpirationRule.VarDateRange)) { %>
    validFrom = xmlDateFrom; 
    validTo = xmlDateTo; 
  <% } else if(rule.isLookup(isFirstUsageRule ? LkSNFirstUsageRule.VarExpirationDate : LkSNExpirationRule.VarExpirationDate)) { %>
    validTo = xmlDateFrom; 
  <% } else if(rule.isLookup(isFirstUsageRule ? LkSNFirstUsageRule.VarValidityDay : LkSNExpirationRule.VarValidityDay)) { %>
    validFrom = xmlDateFrom; 
    validTo = xmlDateFrom; 
  <% } %>
  
  <% if (isFirstUsageRule) { %>
    addCheckAddToCartValues({"FirstUsageFrom": validFrom, "FirstUsageTo": validTo});
  <% } else { %>
    addCheckAddToCartValues({"ValidFrom": validFrom, "ValidTo": validTo});
  <% } %>

  dlg.dialog("close");
}

function doVariableDateCANCEL() {
  dlg.dialog("close");
}
</script>

<style>
#variabledate_dialog .datepicker {
  display: inline-block;
  font-size: 1.3em;
}
#variabledate_dialog .datepicker .ui-datepicker {
  box-shadow: none;
}
</style>

<div id="datepicker-from" class="datepicker"></div>
<% if (dateRange) { %>
  <div id="datepicker-to" class="datepicker"></div>
<% } %>



</v:dialog>
