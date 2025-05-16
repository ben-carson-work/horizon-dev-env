<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

	<v:widget caption="CRM General Settings">
		<v:widget-block>
			<v:form-field caption="Client ID">
			  <v:input-text field="settings.ClientId"/>
			</v:form-field>
			<v:form-field caption="Client Secret">
			  <v:input-text type="password" field="settings.ClientSecret"/>
			</v:form-field>
		</v:widget-block>
	</v:widget>

	<v:widget caption="CRM Account Settings">
	 <v:widget-block>
	   <v:form-field caption="Upsert URL">
	     <v:input-text field="settings.AccountUpsert_URL"/>
	   </v:form-field>
	   <v:form-field caption="Merge URL">
	     <v:input-text field="settings.AccountMerge_URL"/>
	   </v:form-field>
	   <v:form-field caption="Delete URL">
	     <v:input-text field="settings.AccountDelete_URL"/>
	   </v:form-field>
	 </v:widget-block>
	</v:widget>

  <v:widget caption="CRM Order Settings">
	  <v:widget-block>
	    <v:form-field caption="Upsert URL">
	      <v:input-text field="settings.OrderUpsert_URL"/>
	    </v:form-field>
	  </v:widget-block>
  </v:widget>
  
  <v:widget caption="CRM Interactions Settings">
	  <v:widget-block>
	    <v:form-field caption="Create URL">
	      <v:input-text field="settings.InteractionsCreate_URL"/>
	    </v:form-field>
	  </v:widget-block>
  </v:widget>

<script>

function getPluginSettings() {
 
  return {
    AccountUpsert_URL: $("#settings\\.AccountUpsert_URL").val(),
    AccountMerge_URL: $("#settings\\.AccountMerge_URL").val(),
    AccountDelete_URL: $("#settings\\.AccountDelete_URL").val(),
    OrderUpsert_URL: $("#settings\\.OrderUpsert_URL").val(),
    InteractionsCreate_URL: $("#settings\\.InteractionsCreate_URL").val(),
    ClientId: $("#settings\\.ClientId").val(),
    ClientSecret: $("#settings\\.ClientSecret").val()
	};
}
</script>