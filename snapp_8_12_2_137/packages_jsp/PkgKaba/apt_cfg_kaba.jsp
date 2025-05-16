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
<% int[] channels = new int[] {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32}; %>

  <v:widget caption="@PluginSettings.Kaba.IOBoard">
    <v:widget-block>
      <v:form-field caption="@Common.PortName">
        <select id="settings.PortName" class="form-control">
          <% for (LookupItem comPort : LkSN.ComPort.getItems()) { %>
            <% String com = comPort.getDescription(); %>
            <% String sel = JvString.isSameText(com, settings.getChildField("PortName").getJsString()) ? "selected" : ""; %>
            <option value="<%=com%>" <%=sel%>><%=com%></option>
          <% } %>
        </select>
      </v:form-field>
    </v:widget-block>
  </v:widget>
  <v:widget caption="@PluginSettings.Kaba.OutputSignals">
    <v:widget-block>
      <v:form-field caption="@PluginSettings.Kaba.LightRed">
        <select id="settings.LightRed" name="settings.LightRed" class="form-control" <%=sDisabled%>>
        <%                            
          for (int rate: channels) {
            if (rate == settings.getChildField("LightRed").getInt()) {%>
              <option value="<%= String.valueOf(rate)%>" selected="selected"><%= String.valueOf(rate)%></option>
            <% } else { %>
              <option value="<%= String.valueOf(rate)%>"><%= String.valueOf(rate)%></option>
          <% }
          }
       %>           
       </select>
      </v:form-field>
      <v:form-field caption="@PluginSettings.Kaba.LightGreen">
        <select id="settings.LightGreen" name="settings.LightGreen" class="form-control" <%=sDisabled%>>
        <%                            
          for (int rate: channels) {
            if (rate == settings.getChildField("LightGreen").getInt()) {%>
              <option value="<%= String.valueOf(rate)%>" selected="selected"><%= String.valueOf(rate)%></option>
            <% } else { %>
              <option value="<%= String.valueOf(rate)%>"><%= String.valueOf(rate)%></option>
          <% }
          }
        %>           
        </select>
      </v:form-field>
      <v:form-field caption="@PluginSettings.Kaba.LightBlue">
        <select id="settings.LightBlue" name="settings.LightBlue" class="form-control" <%=sDisabled%>>
         <%                            
           for (int rate: channels) {
             if (rate == settings.getChildField("LightBlue").getInt()) {%>
               <option value="<%= String.valueOf(rate)%>" selected="selected"><%= String.valueOf(rate)%></option>
             <% } else { %>
               <option value="<%= String.valueOf(rate)%>"><%= String.valueOf(rate)%></option>
           <% }
           }
         %>           
         </select>
      </v:form-field>
      <v:form-field caption="@PluginSettings.Kaba.FrontPictoGreen">
        <select id="settings.FrontPictoGreen" name="settings.FrontPictoGreen" class="form-control" <%=sDisabled%>>
          <%                            
            for (int rate: channels) {
              if (rate == settings.getChildField("FrontPictoGreen").getInt()) {%>
                <option value="<%= String.valueOf(rate)%>" selected="selected"><%= String.valueOf(rate)%></option>
              <% } else { %>
                <option value="<%= String.valueOf(rate)%>"><%= String.valueOf(rate)%></option>
            <% }
            }
          %>           
        </select>
      </v:form-field>
      <v:form-field caption="@PluginSettings.Kaba.FrontPictoRed">
        <select id="settings.FrontPictoRed" name="settings.FrontPictoRed" class="form-control" <%=sDisabled%>>
          <%                            
            for (int rate: channels) {
              if (rate == settings.getChildField("FrontPictoRed").getInt()) {%>
                <option value="<%= String.valueOf(rate)%>" selected="selected"><%= String.valueOf(rate)%></option>
              <% } else { %>
                <option value="<%= String.valueOf(rate)%>"><%= String.valueOf(rate)%></option>
            <% }
            }
          %>           
        </select>
      </v:form-field>
      <v:form-field caption="@PluginSettings.Kaba.BackPictoGreen">
        <select id="settings.BackPictoGreen" name="settings.BackPictoGreen" class="form-control" <%=sDisabled%>>
          <%                            
            for (int rate: channels) {
              if (rate == settings.getChildField("BackPictoGreen").getInt()) {%>
                <option value="<%= String.valueOf(rate)%>" selected="selected"><%= String.valueOf(rate)%></option>
              <% } else { %>
                <option value="<%= String.valueOf(rate)%>"><%= String.valueOf(rate)%></option>
            <% }
            }
          %>           
        </select>
      </v:form-field>
      <v:form-field caption="@PluginSettings.Kaba.BackPictoRed">
        <select id="settings.BackPictoRed" name="settings.BackPictoRed" class="form-control" <%=sDisabled%>>
          <%                            
            for (int rate: channels) {
              if (rate == settings.getChildField("BackPictoRed").getInt()) {%>
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
        PortName: $("#settings\\.PortName").val(),
        LightRed: $("#settings\\.LightRed").val(),
        LightGreen: $("#settings\\.LightGreen").val(),
        LightBlue: $("#settings\\.LightBlue").val(),
        FrontPictoGreen: $("#settings\\.FrontPictoGreen").val(),
        FrontPictoRed: $("#settings\\.FrontPictoRed").val(),
        BackPictoGreen: $("#settings\\.BackPictoGreen").val(),
        BackPictoRed: $("#settings\\.BackPictoRed").val()
    };
    
    $("[name='AptSettings']").val(JSON.stringify(cfg));
  }
</script>