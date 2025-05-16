<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageWorkstation" scope="request"/>

<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>

<v:widget caption="Plugin settings">
  <v:widget-block>
   <v:form-field caption="Port Number" mandatory="true">
     <v:input-text field="settings.ServerPort" type="number" />
   </v:form-field>
  </v:widget-block>
</v:widget>

  <input type="hidden" name="AptSettings"/>
  
<script>
function saveAptSettings() {
  var cfg = {
      ServerPort : $("#settings\\.ServerPort").val()
	};
  $("[name='AptSettings']").val(JSON.stringify(cfg));
}
</script>