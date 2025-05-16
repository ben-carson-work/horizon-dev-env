<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<jsp:useBean id="settings" class="com.vgs.entity.dataobject.DOPlgSettings_VirtualBioComparator" scope="request"/>


<v:widget caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
    <v:form-field caption="@Plugin.FailureRatio" hint="Emulates biometric compare failure based on a scale frequency: 0=never, 10=always">
      <v:input-text field="settings.FailureRatio"/>
    </v:form-field>
    <v:form-field>
      <v:db-checkbox field="settings.StringMatch" value="true" caption="String match" hint="When selected, 'FailureRatio' is ignored and the comparison is done matching the templates as strings"/>
    </v:form-field>
  </v:widget-block>
</v:widget>
 
<script>

function getPluginSettings() {
  return {
    "FailureRatio": $("#settings\\.FailureRatio").val(),
    "StringMatch": $("#settings\\.StringMatch").isChecked()
  };
}

</script>
