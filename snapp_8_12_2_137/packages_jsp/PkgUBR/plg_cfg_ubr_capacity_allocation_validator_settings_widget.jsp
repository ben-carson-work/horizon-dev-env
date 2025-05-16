<%@page import="com.vgs.web.library.BLBO_Seat"%>
<%@page import="com.vgs.snapp.web.search.BLBO_QueryRef_SeatEnvelope"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% JvDocument settings = (JvDocument) request.getAttribute("settings"); %>

<v:widget caption="Settings" icon="settings.png">
  <v:widget-block>
	<v:form-field caption="Endpoint URL" mandatory="true">
	  <v:input-text field="settings.EndPointUrl" />
	</v:form-field>
	<v:form-field caption="Envelopes" hint="Envelopes that will be checked on the \"ECO\" system" mandatory="true">
      <% JvDataSet dsEnvelope = pageBase.getBL(BLBO_Seat.class).getEnvelopeDS(); %>
      <v:multibox field="settings.EnvelopeIDs" lookupDataSet="<%=dsEnvelope%>" idFieldName="SeatEnvelopeId" captionFieldName="SeatEnvelopeName"/>
    </v:form-field>
	<v:form-field caption="Connection timeout (secs)">
	  <v:input-text field="settings.ConnectionTimeout" placeholder="5"/>
	</v:form-field>
	<v:form-field caption="Read timeout (secs)">
	  <v:input-text field="settings.ReadTimeout" placeholder="5"/>
	</v:form-field>
  </v:widget-block>
</v:widget>

<script>
function getPluginSettings() {
  return {
    EndPointUrl: $("#settings\\.EndPointUrl").val(),
    ConnectionTimeout: $("#settings\\.ConnectionTimeout").val(),
    ReadTimeout: $("#settings\\.ReadTimeout").val(),
    EnvelopeIDs: $("#settings\\.EnvelopeIDs").val()
  };
}
</script>