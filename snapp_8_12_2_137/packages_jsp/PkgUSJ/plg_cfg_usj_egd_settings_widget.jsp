<%@page import="com.vgs.snapp.lookup.LkSNDriverType"%>
<%@page import="com.vgs.snapp.query.QryBO_Account"%>
<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget id="usj-egd-settings" caption="Plugin settings" >
  <v:widget-block>
    <% JvDataSet dsPlugins = pageBase.getBL(BLBO_Plugin.class).getPluginDS(pageBase.getNullParameter("WorkstationId"), LkSNDriverType.ExtPayDevice); %>
    <v:form-field caption="External Payment Device">
      <v:combobox field="ExternalPaymentPluginId" lookupDataSet="<%=dsPlugins%>" idFieldName="PluginId" captionFieldName="PluginDisplayName" allowNull="false"/>
    </v:form-field>   
  </v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  var $cfg = $("#usj-egd-settings");
  
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#ExternalPaymentPluginId").val(params.settings.ExternalPaymentPluginId);
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
        ExternalPaymentPluginId: $cfg.find("#ExternalPaymentPluginId").val()  
    };
  });
});
</script>