<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTask" scope="request"/>

<v:alert-box type="info">
  This task looks for all products which have been expired at least for the configured timeframe and flag them as "archivable".<br/>
  For each product that has been set as "archivable", if also all the other products within the same order are "archivable", then the whole order is flagged as "archivable", making it eligible for task "Archive - Store".
</v:alert-box>

<v:widget id="archive-analyze-settings" caption="@Common.Settings">
  <v:widget-block>
    <v:db-checkbox field="SimulationMode" clazz="archive-field" value="true" caption="Simulation mode" hint="Prevents any change to be made on DB and just provide the output of what products/orders would be touched."/>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="Expire days" hint="Number of days, after product expiration date (ValidDateTo), when the product becomes eligible for archiving">
      <v:input-text field="ExpireDays" clazz="archive-field" placeholder="0"/>
    </v:form-field>
    <v:form-field caption="Expire date from" hint="Include only product expired starting from specified date (included)">
      <v:input-text type="datepicker" field="ExpireDateFrom" clazz="archive-field" placeholder="@Common.Unlimited"/>
    </v:form-field>
    <v:form-field caption="Expire date to" hint="Include only product expired up to specified date (included)">
      <v:input-text type="datepicker" field="ExpireDateTo" clazz="archive-field" placeholder="@Common.Unlimited"/>
    </v:form-field>
    <v:form-field caption="@Product.ProductTags" hint="Include only product types matching these tags">
      <v:multibox field="ProductTagIDs" clazz="archive-field" idFieldName="TagId" captionFieldName="TagName" linkEntityType="<%=LkSNEntityType.Tag_ProductType%>"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block> 
    <v:form-field checkBoxField="AttachLogs" checkBoxClazz="archive-field" caption="Attach logs" hint="Create detailed attachments to each jobs about the orders/products analyzed. Configure max numbers of lines per file.">
      <v:input-text field="AttachLogSizeMax" clazz="archive-field" placeholder="100000"/>
    </v:form-field>
  </v:widget-block>
</v:widget>


<script>
$(document).ready(function() {
  var $cfg = $("#archive-analyze-settings");

  $(document).von($cfg, "task-load", function(event, params) {
    var doc = (params.TaskConfig) ? JSON.parse(params.TaskConfig) : {};
    $cfg.docToView({"doc":doc});
  });
  
  $(document).von($cfg, "task-save", function(event, params) {
    params.TaskConfig = $cfg.find(".archive-field").viewToDoc();
  });
});
</script>