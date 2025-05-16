<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageWorkstation" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
  JvDocument settings = (JvDocument)request.getAttribute("settings");
%>

  <v:widget caption="Settings" icon="settings.png">
    <v:widget-block>
      <v:form-field caption="Turnstile Address" mandatory="true">
        <v:input-text field="settings.TurnstileAddress"/>
      </v:form-field>
      <v:form-field caption="Manual cmd port" hint="Port to be used for manual command process" mandatory="true">
        <v:input-text field="settings.ManualCommandPort" type="numeric"/>
      </v:form-field>
      <v:form-field caption="Tck verify port" hint="Port to be used for ticket verification process" mandatory="true">
        <v:input-text field="settings.TicketVerificationPort" type="numeric"/>
      </v:form-field>
    </v:widget-block>
		<v:widget-block>
	  	<v:db-checkbox field="settings.Goodfellow" caption="Goodfellow ticket check" hint="Flag it to enable ticket verification on Goodfellow software" value="true"/>
			<div class="v-hidden" id="GF-config">
	      <v:form-field caption="GF Address" hint="Goodfellow machine address">
	        <v:input-text field="settings.GFAddress"/>
	      </v:form-field>
	      <v:form-field caption="Tck verify port" hint="Port to be used for ticket verification with Goodfellow software">
	        <v:input-text field="settings.GFClientePort" type="numeric"/>
	      </v:form-field>
	      <v:form-field caption="Manual cmd port" hint="Port to be used for manual command process with Goodfellow software">
	        <v:input-text field="settings.GFServerePort" type="numeric"/>
	      </v:form-field>
	      <v:db-checkbox field="settings.ForwardOnlyDaylyTicket" caption="Only daily tickets" hint="Flag it to forward only daily tickets to Goodfellows. If not flag all GF tickets, included annual passes , will be forwarded to GF for validation" value="true"/>
			</div>
		</v:widget-block>
  </v:widget>
  
  <input type="hidden" name="AptSettings"/>
 
<script>
	$(document).ready(function() {
	  enableDisbaleGoodfellow();
	});
	
	$("#settings\\.Goodfellow").change(enableDisbaleGoodfellow);
	
	function enableDisbaleGoodfellow() {
	  var enabled = $("#settings\\.Goodfellow").isChecked();
	  $("#GF-config").setClass("v-hidden", !enabled); 
	}

  function saveAptSettings() {
    var cfg = {
        TurnstileAddress: 				$("#settings\\.TurnstileAddress").val(),
        ManualCommandPort: 				$("#settings\\.ManualCommandPort").val(),
        TicketVerificationPort: 	$("#settings\\.TicketVerificationPort").val(),
        Goodfellow:								$("#settings\\.Goodfellow").isChecked(),
        GFAddress:								$("#settings\\.GFAddress").val(),
        GFClientePort:						$("#settings\\.GFClientePort").val(),
        GFServerePort:						$("#settings\\.GFServerePort").val(),
        ForwardOnlyDaylyTicket:		$("#settings\\.ForwardOnlyDaylyTicket").isChecked()
    };
    
    $("[name='AptSettings']").val(JSON.stringify(cfg));
  }
</script>