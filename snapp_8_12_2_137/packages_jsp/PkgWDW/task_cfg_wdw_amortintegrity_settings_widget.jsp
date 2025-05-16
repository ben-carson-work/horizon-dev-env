<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<%
  JvDocument cfg = (JvDocument)request.getAttribute("cfg");
  String optSelected = cfg.getChildField("FromDate").isNull() ? "0" : "1";
  
  String amortizationIntegrity_Description = "The purpose of this task is to look for all tickets used, upgraded or renewed which require amortization periods<br>" +
      "and to verify the choerence between the periods created and the periods obtained by the configuration.<br><br>" +
      "If the number of periods is different the task will update the ticket with the correct number ones.<br><br>" +
      "Behaviour constraints:<br>" +
      "- No \"Applied\" or \"Voided\" periods will be updated/removed<br>" + 
      "- Periods will never be updated with a date which is before the date of the task execution<br>" +
      "- Total amount of the updated periods will never be higher that the clearing left at the time of task execution";
  
  String amortizationIntegrity_SimulateWriting_Hint = "Task will perform all checks and write all logs but will not change any data in the DB";
      
  String amortizationIntegrity_CheckExisting_Hint = "Check the integrity of already created periods for USED products";
  String amortizationIntegrity_ForceRewriting_Hint = "Force task to re-write periods when the configuration of a product (calendar or period type) has been changed along the road";
  String amortizationIntegrity_ForceOverExpRewriting_Hint = "Force task to re-write periods when at least one amortization period is after \"Valid to\" of the product";
  
  String amortizationIntegrity_CheckConfig_Hint = "Check the integrity of the saved period number and calendar for UNUSED products";
  
  String amortizationIntegrity_ReferenceDate_Hint = "Allow the task to analyze products used, upgraded or renewed in a specific date range.\r\n" +
      "If \"Reference date\" is set to \"Date range\" it will be automatically set to \"Previous fiscal date\" after each task execution.";
%>

<v:alert-box type="info"><%=amortizationIntegrity_Description%></v:alert-box>

<v:widget caption="Configuration">
  <v:widget-block>
    <v:db-checkbox field="cfg.SimulateWriting" value="true" caption="Simulate DB update" hint="<%=amortizationIntegrity_SimulateWriting_Hint%>"/><br/>
  </v:widget-block>
  <v:widget-block>
    <v:db-checkbox field="cfg.CheckExisting" value="true" caption="Check exsiting periods integrity (Used products)" hint="<%=amortizationIntegrity_CheckExisting_Hint%>"/><br/>
    <div id="fix-existing" class="hidden">
      <v:db-checkbox field="cfg.ForceRewriting" value="true" caption="Force rewriting on changed configuration" hint="<%=amortizationIntegrity_ForceRewriting_Hint%>"/><br/>
      <v:db-checkbox field="cfg.ForceOverExpRewriting" value="true" caption="Force rewriting for periods after expiration" hint="<%=amortizationIntegrity_ForceOverExpRewriting_Hint%>"/>
    </div>
  </v:widget-block>
  <v:widget-block>
    <v:db-checkbox field="cfg.CheckConfig" value="true" caption="Check configuration integrity (Unused products)" hint="<%=amortizationIntegrity_CheckConfig_Hint%>"/><br/>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="@Common.ReferenceDate" hint="<%=amortizationIntegrity_ReferenceDate_Hint%>">
      <select name="cfg.DateType" id="cfg.DateType" class="form-control">
        <option value="0"><v:itl key="@Lookup.LedgerRegDateTimeRule.PreviousFiscalDate"/></option>
        <option value="1"><v:itl key="@Common.DateRange"/></option>
      </select>
    </v:form-field>
  </v:widget-block>
  <v:widget-block id="date-range" clazz="v-hidden">
    <v:form-field caption="@Common.FromDate">
      <v:input-text type="datepicker" field="cfg.FromDate"/>
    </v:form-field>
    <v:form-field caption="@Common.ToDate">
      <v:input-text type="datepicker" field="cfg.ToDate"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
$("#cfg\\.CheckExisting").click(enableDisable);
$("#cfg\\.DateType").change(enableDisable);

var sel = $("#cfg\\.DateType");
$(sel).find("option").each(function(i){
  if ($(this).val() == <%=optSelected%>)
    $(this).attr("selected","selected");
});

enableDisable();

function checkDates() {
  var typ = $("#cfg\\.DateType").val();
  if (typ == 1) {
    var dateFrom = $("#cfg\\.FromDate-picker").datepicker("getDate");
    var dateTo = $("#cfg\\.ToDate-picker").datepicker("getDate");
    var today = new Date();
    
    if (!dateFrom)
      throw new Error("\"From date\" cannot be empty");
    
    if (!dateTo)
      throw new Error("\"To date\" cannot be empty");
    
    if (dateFrom > dateTo)
      throw new Error("\"From date\" cannot be after \"To date \"");
    
    if ((dateFrom > today) || (dateTo > today))
      throw new Error("\"From date\" or \"To date \" cannot be in the future");
  }
}

function enableDisable() {
  var typ = $("#cfg\\.DateType").val();
  $("#date-range").setClass("v-hidden", typ == 0);
  
  $checkExisting = $("#cfg\\.CheckExisting").isChecked();
  $("#fix-existing").setClass("hidden", !$checkExisting); 
}

function saveTaskConfig(reqDO) {
  checkDates();
  var typ = $("#cfg\\.DateType").val();
  var checkExisting = $("#cfg\\.CheckExisting").isChecked();
  var config = {
        SimulateWriting: $("#cfg\\.SimulateWriting").isChecked(),
        CheckExisting: checkExisting,
        ForceRewriting: checkExisting && $("#cfg\\.ForceRewriting").isChecked(), 
        ForceOverExpRewriting: checkExisting && $("#cfg\\.ForceOverExpRewriting").isChecked(),
        CheckConfig: $("#cfg\\.CheckConfig").isChecked(),
        FromDate: typ == 0 ? null : getNull($("#cfg\\.FromDate-picker").getXMLDate()),
        ToDate: typ == 0 ? null : getNull($("#cfg\\.ToDate-picker").getXMLDate())
      }
  console.log(config);    
  reqDO.TaskConfig = JSON.stringify(config);    
}
</script>

