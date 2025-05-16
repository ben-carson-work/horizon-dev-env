<%@page import="com.vgs.cl.document.JvDocument"%>
<%@page import="com.vgs.snapp.lookup.LkSN"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<v:widget caption="@Common.Settings" icon="settings.png">
  <v:widget-block>
    <v:db-checkbox field="settings.ReverseRFIDUid" caption="@Common.ReverseRFIDUid" hint="@Common.ReverseRFIDUidHint" value="true" />  
  </v:widget-block>
</v:widget>

 
<script>

function getDriverSettings() {
  return {
	ReverseRFIDUid: $("#settings\\.ReverseRFIDUid").isChecked()
  };
}

</script>
