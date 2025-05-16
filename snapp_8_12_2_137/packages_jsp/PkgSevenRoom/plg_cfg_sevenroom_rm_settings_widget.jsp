<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>

<v:widget caption="Seven Room settings">
  <v:widget-block>
    <v:form-field caption="Base URL" hint="Expecting the portion of URL preceding \"/v1/{restaurant_code}\"" mandatory="true">
      <v:input-text field="settings.BaseURL"/>
    </v:form-field>
    <v:form-field caption="API Key" hint="Private API key provided by SevenRooms" mandatory="true">
      <v:input-text field="settings.APIKey"/>
    </v:form-field>
    <v:form-field caption="Connection timeout" hint="Connection timeout (milliseconds)">
      <v:input-text field="settings.ConnectionTimeout" placeholder="30000" />
    </v:form-field>
    <v:form-field caption="Read timeout" hint="Read timeout (milliseconds)">
      <v:input-text field="settings.ReadTimeout" placeholder="60000"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="Restaurant code field" hint="Field, configured on the resource type, which represent the {restaurant_code} portion of the APIs URL." mandatory="true">
      <snp:dyncombo field="settings.Restaurant_MetafieldId" entityType="<%=LkSNEntityType.MetaField%>"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="Time from field" hint="Field, configured on th resource type, which tells the starting time range for valid restaurant time slots" mandatory="true">
      <snp:dyncombo field="settings.TimeFrom_MetafieldId" entityType="<%=LkSNEntityType.MetaField%>"/>
    </v:form-field>
    <v:form-field caption="Time to field" hint="Field, configured on th resource type, which tells the ending time range for valid restaurant time slots" mandatory="true">
      <snp:dyncombo field="settings.TimeTo_MetafieldId" entityType="<%=LkSNEntityType.MetaField%>"/>
    </v:form-field>
    <% 
    String offsetStartHint = 
        "Offset (in minutes) relative to the performance end time, which tells the starting time range for valid restaurant time slots." + JvString.CRLF + 
        "- When negative, indicates (n) minutes **before** the performance end" + JvString.CRLF + 
        "- When positive, indicates (n) minutes **after** the performance end";
    %>
    <v:form-field caption="Offset start" hint="<%=offsetStartHint%>" mandatory="true">
      <v:input-text field="settings.OffsetStartMins"/>
    </v:form-field>
    <% 
    String offsetEndHint = 
        "Offset (in minutes) relative to the performance end time, which tells the ending time range for valid restaurant time slots." + JvString.CRLF + 
        "- When negative, indicates (n) minutes **before** the performance end" + JvString.CRLF + 
        "- When positive, indicates (n) minutes **after** the performance end";
    %>
    <v:form-field caption="Offset end" hint="<%=offsetEndHint%>" mandatory="true">
      <v:input-text field="settings.OffsetEndMins"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
function getPluginSettings() {
  return {
    BaseURL                : $("#settings\\.BaseURL").val(),
    APIKey                 : $("#settings\\.APIKey").val(),
    ConnectionTimeout      : $("#settings\\.ConnectionTimeout").val(),
    ReadTimeout            : $("#settings\\.ReadTimeout").val(),
    Restaurant_MetafieldId : $("#settings\\.Restaurant_MetafieldId").val(),
    TimeFrom_MetafieldId   : $("#settings\\.TimeFrom_MetafieldId").val(),
    TimeTo_MetafieldId     : $("#settings\\.TimeTo_MetafieldId").val(),
    OffsetStartMins        : $("#settings\\.OffsetStartMins").val(),
    OffsetEndMins          : $("#settings\\.OffsetEndMins").val()
  };
}
</script>