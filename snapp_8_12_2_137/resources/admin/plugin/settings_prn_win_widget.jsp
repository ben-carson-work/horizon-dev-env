<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<jsp:useBean id="settings" class="com.vgs.entity.dataobject.DOPlgSettings_WinPrinter" scope="request"/>


<v:widget caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
    <v:form-field caption="@Common.Name">
      <v:input-text field="settings.PrinterName"/>
    </v:form-field>
    <v:form-field caption="@Common.DPI">
      <v:input-text field="settings.PrinterDPI"/>
    </v:form-field>
    <v:form-field caption="Timeout (sec.)" hint="Print job timeout in seconds">
      <v:input-text field="settings.JobTimeout" placeholder="30" type="number"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>

function getPluginSettings() {
  return {
    PrinterDPI: $("#settings\\.PrinterDPI").val(),
    PrinterName: $("#settings\\.PrinterName").val(),
    JobTimeout: $("#settings\\.JobTimeout").val()
  };
}

</script>
