<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<jsp:useBean id="settings" class="com.vgs.entity.dataobject.DOPlgSettings_JavaPOS" scope="request"/>


<v:widget caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
     <v:form-field caption="@Common.Name">
      <v:input-text field="settings.DeviceName"/>
    </v:form-field>
    <v:form-field caption="@Common.Chinese">
      <v:db-checkbox field="settings.Chinese" caption="" value="true" />
    </v:form-field>
    <v:form-field caption="Ignore media cut" hint="If flagged the automatic cuts of media print will be ignored">
      <v:db-checkbox field="settings.PreventForceCut" caption="" value="true" />
    </v:form-field>
  </v:widget-block>
</v:widget>
 
 
<script>

function getPluginSettings() {
  return {
    DeviceName: $("#settings\\.DeviceName").val(),
    Chinese: $("#settings\\.Chinese").isChecked(),
    PreventForceCut: $("#settings\\.PreventForceCut").isChecked()
  };
}

</script>
 