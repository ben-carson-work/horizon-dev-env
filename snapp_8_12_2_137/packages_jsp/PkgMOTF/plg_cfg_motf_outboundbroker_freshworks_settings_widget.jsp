<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
  
	<v:widget id="freshworks-generic-settings" caption="FreshWorks General Settings">
		<v:widget-block>
			<v:form-field caption="Freshworks API access Token" mandatory="true" hint="Freshworks API Token">
			  <v:input-text type="password" field="Token"/>
			</v:form-field>
		</v:widget-block>
	</v:widget>

	<v:widget id="freshworks-account-settings" caption="FreshWorks Account API Settings">
	 <v:widget-block>
	   <v:form-field caption="Create/Update Endpoint" mandatory="true" hint="Freshworks Account Create/Update Endpoint">
	     <v:input-text field="AccountCreateUpdateEndpoint"/>
	   </v:form-field>
	 </v:widget-block>
	</v:widget>


<script>
var $cfg_general = $("#freshworks-generic-settings");
var $cfg_account = $("#freshworks-account-settings");

$(document).von($cfg_general, "plugin-settings-load", function(event, params) {
  $cfg_general.find("#Token").val(params.settings.Token);
  $cfg_account.find("#AccountCreateUpdateEndpoint").val(params.settings.AccountCreateUpdateEndpoint);
});

$(document).von($cfg_general, "plugin-settings-save", function(event, params) {
  params.settings = {
  		Token: $cfg_general.find("#Token").val(), 
  		AccountCreateUpdateEndpoint: $cfg_account.find("#AccountCreateUpdateEndpoint").val(),
  };
});

</script>