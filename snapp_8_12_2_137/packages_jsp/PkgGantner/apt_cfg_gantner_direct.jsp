<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="java.util.Map.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageWorkstation" scope="request"/>
<jsp:useBean id="pwks" class="com.vgs.snapp.dataobject.DOWorkstation" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
  JvDocument settings = (JvDocument)request.getAttribute("settings");
  boolean canEdit = rights.SystemSetupLicensee.canUpdate();
  String sDisabled = (canEdit) ? "" : "disabled=\"disabled\""; 
  int[] channels = new int[] {1, 2, 3, 4}; 
  
  if (settings.getChildField("LightOKTime").isNull())
    settings.getChildField("LightOKTime").setInt(500);
  if (settings.getChildField("LightNOKTime").isNull())
      settings.getChildField("LightNOKTime").setInt(500);
  if (settings.getChildField("LightReentryTime").isNull())
      settings.getChildField("LightReentryTime").setInt(500);
  if (settings.getChildField("LightFlashTime").isNull())
      settings.getChildField("LightFlashTime").setInt(500);
  if (settings.getChildField("OpenArmEntryTime").isNull())
      settings.getChildField("OpenArmEntryTime").setInt(500);
  if (settings.getChildField("OpenArmExitTime").isNull())
      settings.getChildField("OpenArmExitTime").setInt(500);
%>

  <v:widget caption="@PluginSettings.Gantner.ServerSettings" icon="settings.png">
    <v:widget-block>
      <v:form-field caption="@PluginSettings.Gantner.ServerIP">
        <v:input-text field="settings.ServerIP" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@PluginSettings.Gantner.ServerPort">
        <v:input-text field="settings.ServerPort" enabled="<%=canEdit%>" type="number"/>
      </v:form-field>
      <v:form-field caption="@Common.Password">
        <v:input-text field="settings.ServerPassword" enabled="<%=canEdit%>" type="password"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
  
  <v:widget caption="@PluginSettings.Gantner.DeviceSettings" icon="settings.png">
    <v:widget-block>
      <v:form-field caption="@PluginSettings.Gantner.DeviceType">
        <select id="settings.DeviceType" class="form-control">
          <% String sel = (settings.getChildField("DeviceType").getInt() == 1) ? "selected" : ""; %>
          <option value="1" <%= sel %>>GATAccess</option>
          <% sel = (settings.getChildField("DeviceType").getInt() == 2) ? "selected" : ""; %>
          <option value="2" <%= sel %>>GATInfo</option>
        </select>
      </v:form-field>
      <v:form-field caption="@PluginSettings.Gantner.DeviceIP">
        <v:input-text field="settings.DeviceIP" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@PluginSettings.Gantner.DevicePort">
        <v:input-text field="settings.DevicePort" enabled="<%=canEdit%>" type="number"/>
      </v:form-field>
      <v:form-field caption="@PluginSettings.Gantner.DeviceChannel">
        <v:input-text field="settings.DeviceChannel" enabled="<%=canEdit%>" type="number"/>
      </v:form-field>
      <v:form-field caption="@AccessPoint.ShowCustomerMessages">
        <v:db-checkbox field="settings.ShowCustomerMessages" caption="" value="true" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@AccessPoint.RemoveLeadingZerosFromMediaCode">
        <v:db-checkbox field="settings.RemoveLeadingZerosFromMediaCode" caption="" value="true" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
  
  <v:widget caption="@PluginSettings.Gantner.OutputSignals" icon="settings.png">
    <v:widget-block>
      <v:form-field caption="@PluginSettings.Gantner.LightOK">
        <select id="settings.LightOK" name="settings.LightOK" class="form-control" <%=sDisabled%>>
          <%if (settings.getChildField("LightOK").isNull()) {%>
            <option value="0" selected="selected"></option>
          <%} else {%>
            <option value="0"></option>
          <%}%>
          <%                            
            for (int rate: channels) {
              if (rate == settings.getChildField("LightOK").getInt()) {%>
                <option value="<%= String.valueOf(rate)%>" selected="selected"><%= String.valueOf(rate)%></option>
              <% } else { %>
                <option value="<%= String.valueOf(rate)%>"><%= String.valueOf(rate)%></option>
            <% }
            }
          %>           
        </select>
      </v:form-field>
      <v:form-field caption="@Common.Time">
        <v:input-text field="settings.LightOKTime" enabled="<%=canEdit%>" type="number"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="@PluginSettings.Gantner.LightNOK">
        <select id="settings.LightNOK" name="settings.LightNOK" class="form-control" <%=sDisabled%>>
          <%if (settings.getChildField("LightNOK").isNull()) {%>
            <option value="0" selected="selected"></option>
          <%} else {%>
            <option value="0"></option>
          <%}%>
          <%                            
            for (int rate: channels) {
              if (rate == settings.getChildField("LightNOK").getInt()) {%>
                <option value="<%= String.valueOf(rate)%>" selected="selected"><%= String.valueOf(rate)%></option>
              <% } else { %>
                <option value="<%= String.valueOf(rate)%>"><%= String.valueOf(rate)%></option>
            <% }
            }
          %>           
        </select>
      </v:form-field>
      <v:form-field caption="@Common.Time">
        <v:input-text field="settings.LightNOKTime" enabled="<%=canEdit%>" type="number"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="@PluginSettings.Gantner.LightReentry">
        <select id="settings.LightReentry" name="settings.LightReentry" class="form-control" <%=sDisabled%>>
          <%if (settings.getChildField("LightReentry").isNull()) {%>
            <option value="0" selected="selected"></option>
          <%} else {%>
            <option value="0"></option>
          <%}%>
          <%                            
            for (int rate: channels) {
              if (rate == settings.getChildField("LightReentry").getInt()) {%>
                <option value="<%= String.valueOf(rate)%>" selected="selected"><%= String.valueOf(rate)%></option>
              <% } else { %>
                <option value="<%= String.valueOf(rate)%>"><%= String.valueOf(rate)%></option>
            <% }
            }
          %>           
        </select>
      </v:form-field>
      <v:form-field caption="@Common.Time">
        <v:input-text field="settings.LightReentryTime" enabled="<%=canEdit%>" type="number"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="@PluginSettings.Gantner.LightFlash">
        <select id="settings.LightFlash" name="settings.LightFlash" class="form-control" <%=sDisabled%>>
          <%if (settings.getChildField("LightFlash").isNull()) {%>
            <option value="0" selected="selected"></option>
          <%} else {%>
            <option value="0"></option>
          <%}%>
          <%                            
            for (int rate: channels) {
              if (rate == settings.getChildField("LightFlash").getInt()) {%>
                <option value="<%= String.valueOf(rate)%>" selected="selected"><%= String.valueOf(rate)%></option>
              <% } else { %>
                <option value="<%= String.valueOf(rate)%>"><%= String.valueOf(rate)%></option>
            <% }
            }
          %>           
        </select>
      </v:form-field>
      <v:form-field caption="@Common.Time">
        <v:input-text field="settings.LightFlashTime" enabled="<%=canEdit%>" type="number"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="@PluginSettings.Gantner.OpenArmEntry">
        <select id="settings.OpenArmEntry" name="settings.OpenArmEntry" class="form-control" <%=sDisabled%>>
          <%if (settings.getChildField("OpenArmEntry").isNull()) {%>
            <option value="0" selected="selected"></option>
          <%} else {%>
            <option value="0"></option>
          <%}%>
          <%                            
            for (int rate: channels) {
              if (rate == settings.getChildField("OpenArmEntry").getInt()) {%>
                <option value="<%= String.valueOf(rate)%>" selected="selected"><%= String.valueOf(rate)%></option>
              <% } else { %>
                <option value="<%= String.valueOf(rate)%>"><%= String.valueOf(rate)%></option>
            <% }
            }
          %>           
        </select>
      </v:form-field>
      <v:form-field caption="@Common.Time">
        <v:input-text field="settings.OpenArmEntryTime" enabled="<%=canEdit%>" type="number"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="@PluginSettings.Gantner.OpenArmExit">
        <select id="settings.OpenArmExit" name="settings.OpenArmExit" class="form-control" <%=sDisabled%>>
          <%if (settings.getChildField("OpenArmExit").isNull()) {%>
            <option value="0" selected="selected"></option>
          <%} else {%>
            <option value="0"></option>
          <%}%>
          <%                            
            for (int rate: channels) {
              if (rate == settings.getChildField("OpenArmExit").getInt()) {%>
                <option value="<%= String.valueOf(rate)%>" selected="selected"><%= String.valueOf(rate)%></option>
              <% } else { %>
                <option value="<%= String.valueOf(rate)%>"><%= String.valueOf(rate)%></option>
            <% }
            }
          %>           
        </select>
      </v:form-field>
      <v:form-field caption="@Common.Time">
        <v:input-text field="settings.OpenArmExitTime" enabled="<%=canEdit%>" type="number"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
  
<input type="hidden" name="AptSettings"/>
  
<script> 
  function saveAptSettings() {
    var cfg = {
       ServerIP: $("#settings\\.ServerIP").val(),
       ServerPort: $("#settings\\.ServerPort").val(),
       ServerPassword: $("#settings\\.ServerPassword").val(),
       ShowCustomerMessages: $("#settings\\.ShowCustomerMessages").isChecked(),
       DeviceType: $("#settings\\.DeviceType").val(),
       DeviceIP: $("#settings\\.DeviceIP").val(),
       DevicePort: $("#settings\\.DevicePort").val(),
       DeviceChannel: $("#settings\\.DeviceChannel").val(),
       LightOK: $("#settings\\.LightOK").val(),
       LightNOK: $("#settings\\.LightNOK").val(),
       LightReentry: $("#settings\\.LightReentry").val(),
       LightFlash: $("#settings\\.LightFlash").val(),
       OpenArmEntry: $("#settings\\.OpenArmEntry").val(),
       OpenArmExit: $("#settings\\.OpenArmExit").val(),
       LightOKTime: $("#settings\\.LightOKTime").val(),
       LightNOKTime: $("#settings\\.LightNOKTime").val(),
       LightReentryTime: $("#settings\\.LightReentryTime").val(),
       LightFlashTime: $("#settings\\.LightFlashTime").val(),
       OpenArmEntryTime: $("#settings\\.OpenArmEntryTime").val(),
       OpenArmExitTime: $("#settings\\.OpenArmExitTime").val(),
       RemoveLeadingZerosFromMediaCode:$("#settings\\.RemoveLeadingZerosFromMediaCode").isChecked()
    };
    
    $("[name='AptSettings']").val(JSON.stringify(cfg));
  }
</script> 
 
