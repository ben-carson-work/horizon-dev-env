<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget id="dev-man-rototype-settings" caption="@Common.Settings">
  <v:widget-block>
    <v:form-field caption="Service URL">
      <v:input-text field="ServiceURL" placeholder="ws://127.0.0.1"/>
    </v:form-field>
    <v:form-field caption="Service Port">
      <v:input-text field="ServicePort" placeholder="5846"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  var $cfg = $("#dev-man-rototype-settings");
  
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#ServiceURL").val(params.settings.ServiceURL);
    $cfg.find("#ServicePort").val(params.settings.ServicePort);
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
      ServiceURL:  $cfg.find("#ServiceURL").val(),
      ServicePort: _parseInt($cfg.find("#ServicePort"))
    };
  });
  
  function _parseInt($field) {
    var value = getNull($field.val());
    if (value == null)
      return null;
    else {
      var result = parseInt(value);
      if (isNaN(result)) {
        var fieldName = $field.closest(".form-field").find(".form-field-caption").text();
        throw "Invalid value \"" + value + "\" for field \"" + fieldName + "\""
      }
      return result;
    }
  }
});
</script>
