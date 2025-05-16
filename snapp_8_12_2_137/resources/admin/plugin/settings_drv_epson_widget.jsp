<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<%
JvDocument settings = (JvDocument)request.getAttribute("settings"); 
String recLetterQualityHint = 
    "TRUE: Printing resolution of bitmap is the same as that of the printer respecting both height and width." + JvString.CRLF + 
    "FALSE : Printing resolution of bitmap is a half of that of the printer respecting both height and width.";

%>
<v:widget caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
    <v:db-checkbox field="settings.RecLetterQuality" caption="Letter Quality" hint="<%=recLetterQualityHint %>" value="true"/>   
  </v:widget-block>
</v:widget>

 
<script>

function getDriverSettings() {
  return {
    RecLetterQuality: $("#settings\\.RecLetterQuality").isChecked()
  };
}

</script>
