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
      <v:form-field caption="@Common.IPAddress">
        <v:input-text field="settings.IPAddress" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@AccessPoint.EntryNumber">
        <v:input-text field="settings.EntryNumber" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@AccessPoint.LaneNumber">
        <v:input-text field="settings.LaneNumber" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@AccessPoint.BackEntryNumber">
        <v:input-text field="settings.BackEntryNumber" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@AccessPoint.BackLaneNumber">
        <v:input-text field="settings.BackLaneNumber" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@AccessPoint.LCDDisplay">
      	<v:db-checkbox field="settings.LCDDisplay" caption="" value="true" enabled="<%=canEdit%>" onclick="myOnClick(this)"/>
      </v:form-field>
      <div class="hidden" id="GraphicDiv">
      	<v:form-field caption="Extended Graphic Display" hint="If flagged display line length is increased to 29 digits">
      		<v:db-checkbox field="settings.ExtendedGraphDisplay" caption="" value="true" enabled="<%=canEdit%>"/>
				</v:form-field>
     	</div>
    </v:widget-block>
  </v:widget>
  
  <input type="hidden" name="AptSettings"/>
 
<script>
$(document).ready(
    function() {
     myOnClick($('#settings\\.LCDDisplay'));
    });
    
function myOnClick(cb) {
  $('#GraphicDiv').setClass("hidden", $(cb).isChecked());
  if ($(cb).isChecked()){
    $("#settings\\.ExtendedGraphDisplay").prop('checked', false);
  }
    
}
  function saveAptSettings() {
    var cfg = {
    		IPAddress: $("#settings\\.IPAddress").val(),
        EntryNumber: $("#settings\\.EntryNumber").val(),
        LaneNumber: $("#settings\\.LaneNumber").val(),
        BackEntryNumber: $("#settings\\.BackEntryNumber").val(),
        BackLaneNumber: $("#settings\\.BackLaneNumber").val(),
        LCDDisplay: $('#settings\\.LCDDisplay').prop('checked'),
        ExtendedGraphDisplay: $('#settings\\.ExtendedGraphDisplay').prop('checked')
    };
    
    $("[name='AptSettings']").val(JSON.stringify(cfg));
  }
</script>