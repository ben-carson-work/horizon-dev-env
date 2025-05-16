<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.web.page.*"%>
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
      <v:form-field caption="@Common.URL" mandatory="true">
        <v:input-text field="settings.URL"/>
      </v:form-field>
      <v:form-field caption="Device Name" mandatory="true">
        <v:input-text field="settings.DeviceName"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
  
  <input type="hidden" name="AptSettings"/>
 
<script>
  function saveAptSettings() {
    var cfg = {
        URL: $("#settings\\.URL").val(),
        DeviceName: $("#settings\\.DeviceName").val()
    };
    
    $("[name='AptSettings']").val(JSON.stringify(cfg));
  }
</script>