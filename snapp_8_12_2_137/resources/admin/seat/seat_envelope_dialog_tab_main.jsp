<%@page import="com.vgs.web.library.seat.BLBO_SeatEnvelope"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="envelope" class="com.vgs.snapp.dataobject.DOSeatEnvelope" scope="request"/>
<% 
boolean canEdit = true; 
boolean system = envelope.SeatEnvelopeCode.isSameString("DEFAULT");
String sReadOnly = canEdit ? "" : " readonly=\"readonly\"";
%>

<style>
#envelope.SeatEnvelopeColor {
  width: 80px;
  cursor: pointer;
}
</style>

<div class="tab-content">
  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="@Common.Code" mandatory="true">
        <v:input-text field="envelope.SeatEnvelopeCode" enabled="<%=canEdit&&!system%>"/>
      </v:form-field>
      <v:form-field caption="@Common.Name" mandatory="true">
        <v:input-text field="envelope.SeatEnvelopeName" enabled="<%=canEdit&&!system%>"/>
      </v:form-field>
      <v:form-field caption="@Common.Color">
        <v:color-picker field="envelope.SeatEnvelopeColor" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
    <% if (!system) { %>
	    <v:widget-block>
        <v:form-field caption="@Common.Priority" hint="@Seat.SeatEnvelopePriorityHint">
          <v:input-text field="envelope.SeatEnvelopePriority" enabled="<%=canEdit%>"/>        
        </v:form-field>
  		  <v:form-field clazz="form-field-optionset">
          <div><v:db-checkbox field="envelope.ExclusiveUse" caption="@Seat.EnvelopeExclusiveUse" title="@Seat.EnvelopeExclusiveUseHint" value="true" enabled="<%=canEdit%>"/></div>
          <div><v:db-checkbox field="envelope.Extra" caption="@Seat.EnvelopeExtra" title="@Seat.EnvelopeExtraHint" value="true" enabled="<%=canEdit%>"/></div>
  		  </v:form-field>
   		</v:widget-block>
    <% } %>
  </v:widget>

  <% if (!system) { %>
    <v:widget caption="@Seat.AllotmentRelease">
      <v:widget-block>
        <v:form-field caption="@Seat.SwapHours" hint="@Seat.SwapHoursHint">
          <v:input-text field="envelope.SwapHours" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Seat.Envelope">
          <% JvDataSet dsEnvelope = pageBase.getBL(BLBO_SeatEnvelope.class).getSeatEnvelopeDS(); %>
          <v:combobox field="envelope.SwapSeatEnvelopeId" lookupDataSet="<%=dsEnvelope%>" idFieldName="SeatEnvelopeId" captionFieldName="SeatEnvelopeName" allowNull="true" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
    </v:widget>
  <% } %>
</div>

<script>
  function applyColor() {
    var el = $("#envelope\\.SeatEnvelopeColor");
    el.css("background", el.val());
    el.css("color", el.val());
  }
  $("#envelope\\.SeatEnvelopeColor").change(applyColor);
  $(document).ready(applyColor);
</script>