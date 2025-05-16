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
<% int[] channels = new int[] {1, 2, 3, 4}; %>

  <v:widget caption="@PluginSettings.SeaDACLite.OutputSignals">
    <v:widget-block>
      <v:form-field caption="@Common.Name">
        <v:input-text field="settings.DeviceName" placeholder="SeaDAC Lite 0"/>
      </v:form-field>
      <v:form-field caption="@PluginSettings.SeaDACLite.OpenArmOutputNumber">
        <select id="settings.OpenArmOutputNumber" name="settings.OpenArmOutputNumber" class="form-control" <%=sDisabled%>>
           <%                            
             for (int rate: channels) {
               if (rate == settings.getChildField("OpenArmOutputNumber").getInt()) {%>
                 <option value="<%= String.valueOf(rate)%>" selected="selected"><%= String.valueOf(rate)%></option>
               <% } else { %>
                 <option value="<%= String.valueOf(rate)%>"><%= String.valueOf(rate)%></option>
             <% }
             }
           %>           
        </select>
      </v:form-field>
      <v:form-field caption="@PluginSettings.SeaDACLite.RelayOpenDuration">
        <v:input-text field="settings.OpenArmOutputDuration" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
 
  <input type="hidden" name="AptSettings"/>
 
<script>
  function saveAptSettings() {
    var cfg = {
    		DeviceName: $("#settings\\.DeviceName").val(),
    	  OpenArmOutputNumber: $("#settings\\.OpenArmOutputNumber").val(),
    	  OpenArmOutputDuration: $("#settings\\.OpenArmOutputDuration").val()
    };
    
    $("[name='AptSettings']").val(JSON.stringify(cfg));
  }
</script>