<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>


<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:form-field caption="Driver class name">
      <v:input-text field="settings.DriverClassName" placeholder="com.microsoft.sqlserver.jdbc.SQLServerDriver"/>
    </v:form-field>
    <v:form-field caption="Connection URL">
      <v:input-text field="settings.ConnectionURL" placeholder="jdbc:sqlserver://192.168.1.1;databaseName=SNP-ARCHIVE;user=*****;password=*****"/>
    </v:form-field>
  </v:widget-block>

  <v:widget-block>
    <v:alert-box type="info">
      The plugin will automatically create necessary tables in the specified database:
      <ul>
        <li>ARCHIVE_DOC</li>
        <li>ARCHIVE_IDX</li>
      </ul> 
    </v:alert-box>
  </v:widget-block>
</v:widget>
 
<script>

function getPluginSettings() {
  return {
    DriverClassName: $("#settings\\.DriverClassName").val(),
    ConnectionURL: $("#settings\\.ConnectionURL").val()
  };
}

</script>
