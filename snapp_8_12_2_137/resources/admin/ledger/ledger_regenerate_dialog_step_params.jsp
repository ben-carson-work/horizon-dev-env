<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
String yesterdayXML = pageBase.getFiscalDate().addDays(-1).getXMLDate(); 
pageBase.setDefaultParameter("picker-date-from", yesterdayXML);
pageBase.setDefaultParameter("picker-date-to", yesterdayXML);
%>

<v:wizard-step id="wizard-step-params" title="@Common.Parameters">
  <v:widget caption="@Common.DateRange">
    <v:widget-block>
      <v:form-field caption="@Common.From" mandatory="true">
        <v:input-text type="datepicker" field="picker-date-from"/>
      </v:form-field>
      <v:form-field caption="@Common.To" mandatory="true">
        <v:input-text type="datepicker" field="picker-date-to"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>

<script>
//# sourceURL=ledger_regenerate_dialog_step_params.jsp

$(document).ready(function() {
  const $step = $("#wizard-step-params");
  const $wizard = $step.closest(".wizard");

  $step.vWizard("step-validate", function(callback) {
    checkRequired($step, callback);
  });
});

</script>
    
</v:wizard-step>
