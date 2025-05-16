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
      <v:form-field caption="@AccessPoint.GcmAddress">
        <v:input-text field="settings.GcmAddress" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@AccessPoint.EntryNumber">
        <v:input-text field="settings.EntryNumber" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@AccessPoint.ReaderNumber">
        <v:input-text field="settings.ReaderNumber" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@AccessPoint.BackEntryNumber">
        <v:input-text field="settings.BackEntryNumber" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@AccessPoint.BackReaderNumber">
        <v:input-text field="settings.BackReaderNumber" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@AccessPoint.Lane">
        <% String[] lanes = new String[] {"Left", "Right"}; %>
        <select id="settings.Lane" name="settings.Lane" class="form-control" <%=sDisabled%>>
          <% for (String lane : lanes) { %>
            <% String sel = JvString.isSameText(lane, settings.getChildField("Lane").getJsString()) ? "selected" : ""; %>
            <option value="<%=lane%>" <%=sel%>><%=lane%></option>
          <% } %>
        </select>
      </v:form-field>
      <v:form-field caption="@AccessPoint.SingleLane">
        <v:db-checkbox field="settings.SingleLane" caption="" value="true" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="@AccessPoint.DisableBackDsp">
        <v:db-checkbox field="settings.DisableBackDsp" caption="" value="true" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@AccessPoint.DisplayLines">
        <v:input-text field="settings.DisplayLines" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
  
  <input type="hidden" name="AptSettings"/>
 
<script>
  function saveAptSettings() {
    var cfg = {
        GcmAddress: $("#settings\\.GcmAddress").val(),
        EntryNumber: $("#settings\\.EntryNumber").val(),
        ReaderNumber: $("#settings\\.ReaderNumber").val(),
        BackEntryNumber: $("#settings\\.BackEntryNumber").val(),
        BackReaderNumber: $("#settings\\.BackReaderNumber").val(),
        Lane: $('#settings\\.Lane').val(),
        SingleLane: $('#settings\\.SingleLane').prop('checked'),
        DisableBackDsp: $('#settings\\.DisableBackDsp').prop('checked'),
        DisplayLines: $("#settings\\.DisplayLines").val()
    };
    
    $("[name='AptSettings']").val(JSON.stringify(cfg));
  }
</script>