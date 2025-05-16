<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:dialog id="retrymessage_dialog" title="@Common.Retry" width="800" autofocus="false">
<script>
$(document).ready(function(){
  var $dlg = $("#retrymessage_dialog");
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        text: itl("@Common.Save"),
        click: doSchedule
      }, 
      {
        text: itl("@Common.Cancel"),
        click: doCloseDialog
      }                     
    ];
  });
  
  function doSchedule() {
    var ids = <%= JvString.jsString(pageBase.getParameter("OutboundQueueId")) %>;
    ids = ids || $("[name='OutboundQueueId']").getCheckedValues();
    if (ids == "")
      showMessage(itl("@Common.NoElementWasSelected"));
    else {
      var scheduleDateTime = getNull($('#OutboundScheduleDateTime-picker').getXMLDateTime());
      var $cbSchedule = $dlg.find("[name='cbSchedule']");
      if ($cbSchedule.isChecked() && (scheduleDateTime == null))
        showMessage(itl("@Common.MandatoryFieldMissingError", $cbSchedule.closest("label").text()));
      else {
        var reqDO = {
          Command: "RescheduleQueueItems",
          RescheduleQueueItems: {
            OutboundQueueIDs: ids,
            ScheduleDateTime: scheduleDateTime,
            Regenerate: $dlg.find("[name='cbRegenerate']").isChecked(),
            Notes: getNull($("#OutboundNotes").val())
          }
        };
          
        if ($("#outqueue-grid-table").hasClass("multipage-selected"))        
          reqDO.RescheduleQueueItems.QueryBase64 = $("#outqueue-grid-table").attr("data-QueryBase64");    
        
        vgsService("Outbound", reqDO, false, function(ansDO) {
          showAsyncProcessDialog(ansDO.Answer.RescheduleQueueItems.AsyncProcessId, function() {
            $("#retrymessage_dialog").dialog("close");
            changeGridPage("#outboundqueue-grid", 1);
          });
        });
      }
    }
  }
  
});
</script>

  <v:widget caption="@Common.Options">
    <v:widget-block>
      <v:form-field caption="@Outbound.OutboundScheduleDateTime" hint="@Outbound.OutboundScheduleDateTimeHint" checkBoxField="cbSchedule">
        <v:input-text type="datetimepicker" field="OutboundScheduleDateTime"/>
      </v:form-field>
      
      <v:form-field caption="@Outbound.OutboundRegenerate" hint="@Outbound.OutboundRegenerateHint" checkBoxField="cbRegenerate">
      </v:form-field>
    </v:widget-block>
  </v:widget>
    
  <v:widget caption="@Common.Notes">
    <v:widget-block>
      <v:input-txtarea field="OutboundNotes" rows="10"/>
    </v:widget-block>
  </v:widget>

</v:dialog>