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
      <v:form-field caption="@AccessPoint.ProjectNumber">
        <v:input-text field="settings.ProjectNumber" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@AccessPoint.EntryNumber">
        <v:input-text field="settings.EntryNumber" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@AccessPoint.LaneNumber">
        <v:input-text field="settings.LaneNumber" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
  
  <input type="hidden" name="AptSettings"/>
 
<script>
  function saveAptSettings() {
    var cfg = {
        ProjectNumber: $("#settings\\.ProjectNumber").val(),
        EntryNumber: $("#settings\\.EntryNumber").val(),
        LaneNumber: $("#settings\\.LaneNumber").val()
    };
    
    $("[name='AptSettings']").val(JSON.stringify(cfg));
  }
</script>