<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<jsp:useBean id="settings" class="com.vgs.entity.dataobject.DOPlgSettings_VirtualOutboundBroker" scope="request"/>

<v:widget caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
    <v:form-field caption="@Plugin.FailureRatio" hint="Emulates send failure based on a scale frequency: 0=never, 10=always">
      <v:input-text placeholder="0" field="settings.FailureRatio"/>
    </v:form-field>
    <v:form-field caption="Sleep" hint="Emulates the queue time in second(time between the insertion of the message and the its processing)">
      <v:input-text placeholder="0" field="settings.Sleep"/>
    </v:form-field>
    <v:form-field caption="@Common.Path" hint="When empty, the message is not saved anywhere">
      <v:input-text field="settings.DestinationPath"/>
    </v:form-field>
  </v:widget-block>
</v:widget>
 
<script>

function getPluginSettings() {
  return {
    FailureRatio: $("#settings\\.FailureRatio").val() != "" ? $("#settings\\.FailureRatio").val() : 0,
    Sleep: $("#settings\\.Sleep").val() != "" ? $("#settings\\.Sleep").val() : 0,
    DestinationPath: $("#settings\\.DestinationPath").val()
  };
}

</script>
 