<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="java.util.Map.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageWorkstation" scope="request"/>
<jsp:useBean id="pwks" class="com.vgs.snapp.dataobject.DOWorkstation" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
  JvDocument settings = (JvDocument)request.getAttribute("settings");
  boolean canEdit = rights.SystemSetupLicensee.canUpdate();
%>
<% String sDisabled = (canEdit) ? "" : "disabled=\"disabled\""; %>
<% int[] channels = new int[] {0, 1, 2, 3, 4, 5, 6, 7}; %>

  <v:widget caption="@PluginSettings.Moxa.TcpSettings">
    <v:widget-block>
      <v:form-field caption="@PluginSettings.Moxa.TcpAddress">
        <v:input-text field="settings.TcpAddress" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@PluginSettings.Moxa.TcpPort">
        <v:input-text field="settings.TcpPort" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
  <v:widget caption="@PluginSettings.Moxa.Reader">
    <v:widget-block>
      <v:form-field caption="@Common.PortName">
        <select id="settings.ReaderPortName" class="form-control">
        	<option/>
          <% for (LookupItem comPort : LkSN.ComPort.getItems()) { %>
            <% String com = comPort.getDescription(); %>
            <% String sel = JvString.isSameText(com, settings.getChildField("ReaderPortName").getString()) ? "selected" : ""; %>
            <option value="<%=com%>" <%=sel%>><%=com%></option>
          <% } %>
        </select>
      </v:form-field>
      <v:form-field caption="@Common.Baudrat">
        <v:lk-combobox lookup="<%=LkSN.BaudRate%>" field="settings.ReaderBaudRate"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>

  <v:widget caption="@PluginSettings.Moxa.Display">
    <v:widget-block>
      <v:form-field caption="@Common.PortName">
        <select id="settings.DisplayPortName" class="form-control">
          <option/>
          <% for (LookupItem comPort : LkSN.ComPort.getItems()) { %>
            <% String com = comPort.getDescription(); %>
            <% String sel = JvString.isSameText(com, settings.getChildField("DisplayPortName").getString()) ? "selected" : ""; %>
            <option value="<%=com%>" <%=sel%>><%=com%></option>
          <% } %>
        </select>
      </v:form-field>
      <v:form-field caption="@Common.Baudrate">
        <v:lk-combobox lookup="<%=LkSN.BaudRate%>" field="settings.DisplayBaudRate"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
  <v:widget caption="@PluginSettings.Moxa.InputSignals">
    <v:widget-block>
      <v:form-field caption="@PluginSettings.Moxa.EntryEvent">
        <select id="settings.EntryEvent" name="settings.EntryEvent" <%=sDisabled%>>
          <%                            
            for (int rate: channels) {
              if (!settings.getChildField("EntryEvent").isNull() && (rate == settings.getChildField("EntryEvent").getInt())) {%>
                <option value="<%= String.valueOf(rate)%>" selected="selected"><%= String.valueOf(rate)%></option>
              <% } else { %>
                <option value="<%= String.valueOf(rate)%>"><%= String.valueOf(rate)%></option>
             <% }
           } %>           
       </select>
      </v:form-field>
      <v:form-field caption="@PluginSettings.Moxa.ExitEvent">
        <select id="settings.ExitEvent" name="settings.ExitEvent" <%=sDisabled%>>
          <%                            
            for (int rate: channels) {
              if (!settings.getChildField("ExitEvent").isNull() && (rate == settings.getChildField("ExitEvent").getInt())) {%>
                <option value="<%= String.valueOf(rate)%>" selected="selected"><%= String.valueOf(rate)%></option>
              <% } else { %>
                <option value="<%= String.valueOf(rate)%>"><%= String.valueOf(rate)%></option>
            <% }
            }
          %>           
        </select>
      </v:form-field>
    </v:widget-block>
  </v:widget>
  <v:widget caption="@PluginSettings.Moxa.OutputSignals">
    <v:widget-block>
      <v:form-field caption="@PluginSettings.Moxa.LightOK">
        <select id="settings.LightOK" name="settings.LightOK" <%=sDisabled%>>
          <%                            
            for (int rate: channels) {
              if (!settings.getChildField("EntryEvent").isNull() && (rate == settings.getChildField("LightOK").getInt())) {%>
                <option value="<%= String.valueOf(rate)%>" selected="selected"><%= String.valueOf(rate)%></option>
              <% } else { %>
                <option value="<%= String.valueOf(rate)%>"><%= String.valueOf(rate)%></option>
            <% }
            }
          %>           
        </select>
      </v:form-field>
      <v:form-field caption="@PluginSettings.Moxa.LightNOK">
        <select id="settings.LightNOK" name="settings.LightNOK" <%=sDisabled%>>
         <%                            
           for (int rate: channels) {
             if (!settings.getChildField("ExitEvent").isNull() && (rate == settings.getChildField("LightNOK").getInt())) {%>
               <option value="<%= String.valueOf(rate)%>" selected="selected"><%= String.valueOf(rate)%></option>
             <% } else { %>
               <option value="<%= String.valueOf(rate)%>"><%= String.valueOf(rate)%></option>
           <% }
           }
         %>           
        </select>
      </v:form-field>
      <v:form-field caption="@PluginSettings.Moxa.LightReentry">
        <select id="settings.LightReentry" name="settings.LightReentry" <%=sDisabled%>>
         <%                            
           for (int rate: channels) {
             if (!settings.getChildField("ExitEvent").isNull() && (rate == settings.getChildField("LightReentry").getInt())) {%>
               <option value="<%= String.valueOf(rate)%>" selected="selected"><%= String.valueOf(rate)%></option>
             <% } else { %>
               <option value="<%= String.valueOf(rate)%>"><%= String.valueOf(rate)%></option>
           <% }
           }
         %>           
         </select>
      </v:form-field>
      <v:form-field caption="@PluginSettings.Moxa.LightChild">
       <select id="settings.LightChild" name="settings.LightChild" <%=sDisabled%>>
       <%                            
         for (int rate: channels) {
           if (!settings.getChildField("ExitEvent").isNull() && (rate == settings.getChildField("LightChild").getInt())) {%>
             <option value="<%= String.valueOf(rate)%>" selected="selected"><%= String.valueOf(rate)%></option>
           <% } else { %>
             <option value="<%= String.valueOf(rate)%>"><%= String.valueOf(rate)%></option>
         <% }
         }
       %>           
       </select>
      </v:form-field>
      <v:form-field caption="@PluginSettings.Moxa.Buzzer">
       <select id="settings.Buzzer" name="settings.Buzzer" <%=sDisabled%>>
       <%                            
         for (int rate: channels) {
           if (!settings.getChildField("ExitEvent").isNull() && (rate == settings.getChildField("Buzzer").getInt())) {%>
             <option value="<%= String.valueOf(rate)%>" selected="selected"><%= String.valueOf(rate)%></option>
           <% } else { %>
             <option value="<%= String.valueOf(rate)%>"><%= String.valueOf(rate)%></option>
         <% }
         }
       %>           
       </select>
      </v:form-field>
      <v:form-field caption="@PluginSettings.Moxa.OpenArmEntry">
        <select id="settings.OpenArmEntry" name="settings.OpenArmEntry" <%=sDisabled%>>
         <%                            
           for (int rate: channels) {
             if (!settings.getChildField("ExitEvent").isNull() && (rate == settings.getChildField("OpenArmEntry").getInt())) {%>
               <option value="<%= String.valueOf(rate)%>" selected="selected"><%= String.valueOf(rate)%></option>
             <% } else { %>
               <option value="<%= String.valueOf(rate)%>"><%= String.valueOf(rate)%></option>
           <% }
           }
         %>           
         </select>
      </v:form-field>
      <v:form-field caption="@PluginSettings.Moxa.OpenArmExit">
       <select id="settings.OpenArmExit" name="settings.OpenArmExit" <%=sDisabled%>>
       <%                            
         for (int rate: channels) {
           if (!settings.getChildField("ExitEvent").isNull() && (rate == settings.getChildField("OpenArmExit").getInt())) {%>
             <option value="<%= String.valueOf(rate)%>" selected="selected"><%= String.valueOf(rate)%></option>
           <% } else { %>
             <option value="<%= String.valueOf(rate)%>"><%= String.valueOf(rate)%></option>
         <% }
         }
       %>           
       </select>
      </v:form-field>
    </v:widget-block>
  </v:widget>
 
  <input type="hidden" name="AptSettings"/>
 
<script>
  function saveAptSettings() {
    var cfg = {
    	TcpAddress: $("#settings\\.TcpAddress").val(),
    	TcpPort: $("#settings\\.TcpPort").val(),
        ReaderPortName: $("#settings\\.ReaderPortName").val(),
        ReaderBaudRate: $("#settings\\.ReaderBaudRate").val(),
        DisplayPortName: $("#settings\\.DisplayPortName").val(),
        DisplayBaudRate: $("#settings\\.DisplayBaudRate").val(),
        EntryEvent: $("#settings\\.EntryEvent").val(),
        ExitEvent: $("#settings\\.ExitEvent").val(),
        LightOK: $("#settings\\.LightOK").val(),
        LightNOK: $("#settings\\.LightNOK").val(),
        LightReentry: $("#settings\\.LightReentry").val(),
        LightChild: $("#settings\\.LightChild").val(),
        Buzzer: $("#settings\\.Buzzer").val(),
        OpenArmEntry: $("#settings\\.OpenArmEntry").val(),
        OpenArmExit: $("#settings\\.OpenArmExit").val(),
    };
    
    $("[name='AptSettings']").val(JSON.stringify(cfg));
  }
</script>