<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.web.gencache.*"%>
<%@page import="com.vgs.cl.json.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<% 
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 
pageBase.setDefaultParameter("ValidityDate", JvDateTime.date().getXMLDate());
pageBase.setDefaultParameter("ValidityDays", "1");
%>


<v:dialog id="vgssupport_password_dialog" title="vgs-support password" width="500" autofocus="false">

<v:widget caption="@Common.General">
  <v:widget-block>
    <v:form-field caption="LicenseId">
      <v:input-text type="text" field="LicenseId"/>
    </v:form-field>
    <v:form-field caption="Date">
      <v:input-text type="datepicker" field="ValidityDate"/>
    </v:form-field>
    <v:form-field caption="Validity days">
      <v:input-text type="text" field="ValidityDays"/>
    </v:form-field>
    <v:form-field>
      <v:db-checkbox field="ReadOnly" value="true" caption="Read-Only"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:button id="btn-generate" caption="Generate"/>
    <div id="result-block" class="hidden"><span id="result-password"></span> <span id="result-copy" title="Copy to clipboard"><i class="fa fa-copy"></i></span></div>
  </v:widget-block>
</v:widget>

<style>
  #vgssupport_password_dialog #result-block {
    display: inline-block;
    white-space: nowrap;
    padding: 5px 10px;
    border-radius: 4px;
    background-color: var(--border-color);
    color: black;
    vertical-align: middle;
    font-family: monospace;
    font-size: 1.4em;
  }
  
  #vgssupport_password_dialog #result-copy {
    cursor: pointer;
    color: black;
    opacity: 0.4;
  } 
  
  #vgssupport_password_dialog #result-copy:hover {
    opacity: 1;
  } 
</style>

<script>

$(document).ready(function() {

  var $dlg = $("#vgssupport_password_dialog");
  $dlg.find("#btn-generate").click(_generate);
  $dlg.find("#result-copy").click(_copyPassword);

  function _generate() {
    var reqDO = {
      Command: "GenerateSupportPassword",
      GenerateSupportPassword: {
        LicenseId: $dlg.find("#LicenseId").val(),
        ValidityDate: $dlg.find("#ValidityDate-picker").getXMLDate(),
        ValidityDays: $dlg.find("#ValidityDays").val(),
        ReadOnly: $dlg.find("#ReadOnly").isChecked()
      }
    };
    
    vgsService("PkgStoreAdmin", reqDO, false, function(ansDO) {
      var $resultBlock = $dlg.find("#result-block");
      $resultBlock.removeClass("hidden");
      $resultBlock.find("#result-password").text(ansDO.Answer.GenerateSupportPassword.Password);
    });
  }
  
  function _copyPassword() {
    navigator.clipboard.writeText($dlg.find("#result-password").text());
    showMessage("Password copied to clipboard");
  }

});

</script>

</v:dialog>
 