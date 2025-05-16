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
  boolean canEdit = rights.SystemSetupLicensee.canUpdate();
%>
<% String sDisabled = (canEdit) ? "" : "disabled=\"disabled\""; %>

  <v:widget caption="Settings" icon="settings.png">
    <v:widget-block>
      <v:form-field caption="@AccessPoint.Model">
        <select id="settings.Model" name="settings.Model" class="form-control" <%=sDisabled%>>
          <% 
            String[] models = new String[2];
            models[0] = "8500";
            models[1] = "9500";
         
            for (String model: models) {
              if (!settings.getChildField("Model").isNull() && (model.equalsIgnoreCase(settings.getChildField("Model").getString()))) {%>
                <option value="<%= model%>" selected="selected"><%= model%></option>
              <% } else { %>
                <option value="<%= model%>"><%= model%></option>
            <% }
            }
          %>           
        </select>
      </v:form-field>
      <v:form-field caption="@Common.GunNumber">
        <v:input-text field="settings.GunNumber" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Common.PortName">
        <select id="settings.portName" class="form-control">
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
      <v:form-field caption="@AccessPoint.EntryExitSwap">
        <v:db-checkbox field="settings.EntryExitSwap" caption="" value="true" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
 
  <input type="hidden" name="AptSettings"/>
 
<script>
  function saveAptSettings() {
    var cfg = {
        Model: $("#settings\\.Model").val(),
    		GunNumber: $("#settings\\.GunNumber").val(),
    		PortName: $("#settings\\.portName").val(),
        BaudRate: $("#settings\\.Baudrate").val(),
        EntryExitSwap: $('#settings\\.EntryExitSwap').prop('checked')
    };
    
    $("[name='AptSettings']").val(JSON.stringify(cfg));
  }
</script>