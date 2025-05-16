<%@page import="com.vgs.web.library.BLBO_Plugin"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<%
JvDocument settings = (JvDocument)request.getAttribute("settings");
%>

<v:widget caption="@Common.Settings" icon="settings.png">
  <v:widget-block>
    <v:form-field caption="@Common.PortName">
      <select id="settings.COMPort" class="form-control">
        <% for (LookupItem comPort : LkSN.ComPort.getItems()) { %>
          <% String com = comPort.getDescription(); %>
          <% String sel = JvString.isSameText(com, settings.getChildField("COMPort").getString()) ? "selected" : ""; %>
          <option value="<%=com%>" <%=sel%>><%=com%></option>
        <% } %>
      </select>
    </v:form-field>
    <v:form-field caption="@Common.Baudrate">
      <select id="settings.BaudRate" class="form-control">
        <option value="4800" <%=(4800 == settings.getChildField("BaudRate").getInt()) ? "selected" : ""%>>4800</option>
        <option value="9600" <%=(9600 == settings.getChildField("BaudRate").getInt()) ? "selected" : ""%>>9600</option>
        <option value="14400" <%=(14400 == settings.getChildField("BaudRate").getInt()) ? "selected" : ""%>>14400</option>
        <option value="19200" <%=(19200 == settings.getChildField("BaudRate").getInt()) ? "selected" : ""%>>19200</option>
        <option value="38400" <%=(38400 == settings.getChildField("BaudRate").getInt()) ? "selected" : ""%>>38400</option>
        <option value="57600" <%=(57600 == settings.getChildField("BaudRate").getInt()) ? "selected" : ""%>>57600</option>
        <option value="115200" <%=(115200 == settings.getChildField("BaudRate").getInt()) ? "selected" : ""%>>115200</option>
      </select>
    </v:form-field>
    <v:form-field caption="@Common.DataBits">
      <select id="settings.DataBits" class="form-control">
        <option value="5" <%=(5 == settings.getChildField("DataBits").getInt()) ? "selected" : ""%>>5</option>
        <option value="6" <%=(6 == settings.getChildField("DataBits").getInt()) ? "selected" : ""%>>6</option>
        <option value="7" <%=(7 == settings.getChildField("DataBits").getInt()) ? "selected" : ""%>>7</option>
        <option value="8" <%=(8 == settings.getChildField("DataBits").getInt()) ? "selected" : ""%>>8</option>
      </select>
    </v:form-field>
    <v:form-field caption="@Common.Parity">
      <select id="settings.Parity" class="form-control">
        <option value="0" <%=(0 == settings.getChildField("Parity").getInt()) ? "selected" : ""%>>NONE</option>
        <option value="1" <%=(1 == settings.getChildField("Parity").getInt()) ? "selected" : ""%>>ODD</option>
        <option value="2" <%=(2 == settings.getChildField("Parity").getInt()) ? "selected" : ""%>>EVEN</option>
      </select>
    </v:form-field>
    <v:form-field caption="@Common.StopBits">
      <select id="settings.StopBits" class="form-control">
        <option value="0" <%=(0 == settings.getChildField("StopBits").getInt()) ? "selected" : ""%>>0</option>
        <option value="1" <%=(1 == settings.getChildField("StopBits").getInt()) ? "selected" : ""%>>1</option>
     </select>
    </v:form-field>
    <v:form-field caption="@Common.Timeout" hint="Define the transaction timeout(in seconds), if payment doesn't compleate execution in this time payment a timeout error is raised on snapp and payment is aborted. Default value is 90 sec.">
			<v:input-text field="settings.Timeout" type="number"  placeholder="90"/>
    </v:form-field>
  </v:widget-block>
</v:widget>
 
<script>

function getPluginSettings() {
  return {
    COMPort: $("#settings\\.COMPort").val(),
    BaudRate: $("#settings\\.BaudRate").val(),
    DataBits: $("#settings\\.DataBits").val(),
    Parity: $("#settings\\.Parity").val(),
    StopBits: $("#settings\\.StopBits").val(),
    Timeout: $("#settings\\.Timeout").val()
  };
}

</script>
 