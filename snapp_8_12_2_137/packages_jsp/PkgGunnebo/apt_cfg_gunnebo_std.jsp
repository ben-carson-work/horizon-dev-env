<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.snapp.lookup.LkSN"%>
<%@page import="com.vgs.cl.lookup.LookupItem"%>
<%@page import="com.vgs.cl.document.JvDocument"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageWorkstation" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>

<v:widget caption="@Common.Settings" icon="settings.png">
	<v:widget-block>
	  <v:form-field caption="@Common.PortName">
			<select id="settings.PortName" class="form-control">
				<% for (LookupItem comPort : LkSN.ComPort.getItems()) { %>
				<% String com = comPort.getDescription(); %>
				<% String sel = JvString.isSameText(com, settings.getChildField("PortName").getString()) ? "selected" : ""; %>
				<option value="<%=com%>" <%=sel%>><%=com%></option>
				<% } %>
			</select>
		</v:form-field>
		<v:form-field caption="@Common.Baudrate">
	  	<v:lk-combobox lookup="<%=LkSN.BaudRate%>" field="settings.Baudrate"/>
		</v:form-field>
		<v:form-field caption="All lights notifying" hint="If flagged all notifications will be done on all available lights, i.e for valid ticket all the light will be flash green">
			<v:db-checkbox field="settings.NotifyAllLight" caption="@Common.Enabled" value="true"/>
		</v:form-field>
	</v:widget-block>
</v:widget>

<input type="hidden" name="AptSettings"/>
 
<script>
  function saveAptSettings() {
    var cfg = {
        PortName: $("#settings\\.PortName").val(),
        Baudrate: $("#settings\\.Baudrate").val(),
        NotifyAllLight: $("#settings\\.NotifyAllLight").isChecked()
    };
    
    $("[name='AptSettings']").val(JSON.stringify(cfg));
  }
</script>