<%@page import="com.sun.mail.imap.Rights.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.servlet.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
DONotifyRule.DONotifyRulePerformance settings = ((DONotifyRule)request.getAttribute("notifyRule")).NotifyRulePerformance;
request.setAttribute("settings", settings);
%>

<v:widget id="notifyryle-performance" caption="@Common.Options">
  <v:widget-block>
    <v:form-field caption="@Event.Events" mandatory="true">
      <v:multibox field="settings.EventIDs" idFieldName="EventId" captionFieldName="EventName" lookupDataSet="<%=pageBase.getBL(BLBO_Event.class).getEventDS()%>"/>
    </v:form-field>
    
    <v:form-field caption="@Seat.Category">
      <v:combobox
          field="settings.SeatCategoryId"
          lookupDataSet="<%=pageBase.getBL(BLBO_Seat.class).getSeatCategoryDS()%>" 
          idFieldName="AttributeItemId" 
          captionFieldName="AttributeItemName" 
          groupFieldName="AttributeId" 
          groupLabelFieldName="AttributeName"
          allowNull="true"
      />
    </v:form-field>
    
    <v:form-field caption="@Seat.Envelope">
      <snp:dyncombo field="settings.SeatEnvelopeId" entityType="<%=LkSNEntityType.SeatEnvelope%>"/>
    </v:form-field>
    
    <%-- 
    <v:form-field caption="@Notify.NotifyRulePerformanceQuantityType" hint="@Notify.NotifyRulePerformanceQuantityTypeHint">
      <v:lk-combobox field="settings.QuantityType" lookup="<%=LkSN.NotifyRulePerformanceQuantityType%>"/>
    </v:form-field>
    --%>
    
    <v:form-field caption="@Common.Quantity" hint="@Notify.NotifyRulePerformanceQuantityHint">
      <v:input-text field="settings.Quantity"/>
    </v:form-field>

  </v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  <% if (settings.QuantityValueType.isLookup(LkSNPriceValueType.Percentage)) { %>
    $("#notifyryle-performance [name='settings.Quantity']").val(<%=settings.Quantity.getInt()%> + "%");
  <% } %>
});

function getNotifyRulePerformance_Config() {
  var rawQuantity = $("#notifyryle-performance [name='settings.Quantity']").val();
  var quantityValueType = (rawQuantity.indexOf("%") < 0) ? <%=LkSNPriceValueType.Absolute.getCode()%> : <%=LkSNPriceValueType.Percentage.getCode()%>;
  var quantity = parseInt(rawQuantity.replace("%", ""));
  
  return {
    EventIDs: $("#notifyryle-performance [name='settings.EventIDs']").val(),
    SeatCategoryId: $("#notifyryle-performance [name='settings.SeatCategoryId']").val(),
    SeatEnvelopeId: $("#notifyryle-performance [name='settings.SeatEnvelopeId']").val(),
    /*QuantityType: $("#notifyryle-performance [name='settings.QuantityType']").val(),*/
    QuantityType: <%=LkSNNotifyRulePerformanceQuantityType.QuantityMin.getCode()%>,
    QuantityValueType: quantityValueType,
    Quantity: quantity
  };
}
</script>