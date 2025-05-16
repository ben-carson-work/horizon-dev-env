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
      <v:form-field caption="@Common.IPAddress">
        <v:input-text field="settings.IPAddress"/>
      </v:form-field>
      <v:form-field caption="@Common.HostPort">
        <v:input-text field="settings.HostPort"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="Green light duration">
        <v:input-text field="settings.GreenLightDuration" type="number" placeholder="default values is 5000 milliseconds"/>
      </v:form-field>
      <v:form-field caption="Red light duration">
        <v:input-text field="settings.RedLightDuration" type="number" placeholder="default values is 5000 milliseconds"/>
      </v:form-field>
      <v:form-field caption="Yellow light duration">
        <v:input-text field="settings.YellowLightDuration" type="number" placeholder="default values is 5000 milliseconds"/>
      </v:form-field>
      <v:form-field caption="Flashing green light duration">
        <v:input-text field="settings.Flash_GreenLightDuration" type="number" placeholder="default values is 5000 milliseconds"/>
      </v:form-field>
      <v:form-field caption="Flashing red light duration">
        <v:input-text field="settings.Flash_RedLightDuration" type="number" placeholder="default values is 5000 milliseconds"/>
      </v:form-field>
      <v:form-field caption="Flashing yellow light duration">
        <v:input-text field="settings.Flash_YellowLightDuration" type="number" placeholder="default values is 5000 milliseconds"/>
      </v:form-field>    
    </v:widget-block>
  </v:widget>
  
  <input type="hidden" name="AptSettings"/>
 
<script>
  function saveAptSettings() {
    var cfg = {
        IPAddress: $("#settings\\.IPAddress").val(),
        HostPort: $("#settings\\.HostPort").val(),
        GreenLightDuration: $("#settings\\.GreenLightDuration").val(),
        RedLightDuration: $("#settings\\.RedLightDuration").val(),
        YellowLightDuration: $("#settings\\.YellowLightDuration").val(),
        Flash_GreenLightDuration: $("#settings\\.Flash_GreenLightDuration").val(),
        Flash_RedLightDuration: $("#settings\\.Flash_RedLightDuration").val(),
        Flash_YellowLightDuration: $("#settings\\.Flash_YellowLightDuration").val()
    };
    
    $("[name='AptSettings']").val(JSON.stringify(cfg));
  }
</script>