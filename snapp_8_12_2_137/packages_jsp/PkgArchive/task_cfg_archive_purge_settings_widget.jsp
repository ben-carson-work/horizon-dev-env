<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTask" scope="request"/>

<div id="archive-purge-settings">
  <v:alert-box type="info">
    This task looks for all sales flagged as "archived" and permanently deletes them.
  </v:alert-box>
  
  <v:widget caption="@Common.Settings">
    <v:widget-block>
      <v:form-field caption="ThreadPool Size" hint="Number of parallel processes">
        <v:input-text type="number" field="ThreadPoolSize" clazz="archive-field" placeholder="10"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
</div>

<script>
$(document).ready(function() {
  var $cfg = $("#archive-purge-settings");

  $(document).von($cfg, "task-load", function(event, params) {
    var doc = (params.TaskConfig) ? JSON.parse(params.TaskConfig) : {};
    $cfg.docToView({"doc":doc});
  });
  
  $(document).von($cfg, "task-save", function(event, params) {
    params.TaskConfig = $cfg.find(".archive-field").viewToDoc();
  });
});
</script>
