<%@page import="com.vgs.vcl.JvImageCache"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget id="pay-onepay-settings" caption="Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
<%--  <v:widget-block>
	  <v:alert-box type="info"><b>*Payment method configuration*</b></br></br>
			Payment methods, except credit/debit card, have to be configured with an "Alias".</br>
				Accepted alias are:</br>
				<ul>
					<li>UNION_PAY</li>
		    	<li>ID_PAYMENT</li>
		    	<li>WAON_PAYMENT</li>
		    	<li>QP_PAYMENT</li>
	    	</ul>
		</v:alert-box>
  </v:widget-block> --%>
  <v:widget-block>
		<v:form-field caption="Host" mandatory="true">
      <v:input-text field="Host"/>
    </v:form-field>
		<v:form-field caption="Product key" mandatory="true">
      <v:input-text field="ProductKey"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  var $cfg = $("#pay-onepay-settings");
  
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#Host").val(params.settings.Host);
    $cfg.find("#ProductKey").val(params.settings.ProductKey);
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
        		Host : $cfg.find("#Host").val(),
  					ProductKey : $cfg.find("#ProductKey").val()
          };
        });
      });
</script>