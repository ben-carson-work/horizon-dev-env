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

<v:dialog id="mark_as_resolved_message_dialog" title="@Outbound.MarkAsResolved" width="700" height="500">
<script>
$(document).ready(function(){
  var dlg = $("#mark_as_resolved_message_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        text: <v:itl key="@Common.Save" encode="JS"/>,
        click: markAsResolvedMessages
      }, 
      {
        text: <v:itl key="@Common.Cancel" encode="JS"/>,
        click: doCloseDialog
      }                     
    ];
  });  
});

function markAsResolvedMessages() {
  var ids = <%= JvString.jsString(pageBase.getParameter("OutboundQueueId")) %>;
  ids = ids || $("[name='OutboundQueueId']").getCheckedValues();
  if (ids == "")
    showMessage(<v:itl key="@Common.NoElementWasSelected" encode="JS"/>);
  else {
    var reqDO = {
      Command: "ChangeOutboundQueueStatus",
      ChangeOutboundQueueStatus: {
        OutboundQueueStatus: <%=LkSNOutboundQueueHistoryStatus.Info.getCode()%>,
        OutboundQueueAction: <%=LkSNOutboundQueueAction.Resolve.getCode()%>,
        OutboundQueueIDs: ids,
        Notes: $('#OutboundNotes').val() == '' ? null : $('#OutboundNotes').val()
      }
    };
    
    if ($("#outqueue-grid-table").hasClass("multipage-selected"))        
      reqDO.ChangeOutboundQueueStatus.QueryBase64 = $("#outqueue-grid-table").attr("data-QueryBase64");           
    
    vgsService("Outbound", reqDO, false, function(ansDO) {
      showAsyncProcessDialog(ansDO.Answer.ChangeOutboundQueueStatus.AsyncProcessId, function() {
        $("#mark_as_resolved_message_dialog").dialog("close");
        changeGridPage("#outboundqueue-grid", 1);
      });
    });
  }
}


</script>

  <div class="tab-content">
    <v:widget caption="@Common.General">
      <v:widget-block>
        <v:form-field caption="@Common.Notes">
          <v:input-txtarea field="OutboundNotes" rows="10"/>
        </v:form-field>
      </v:widget-block>
    </v:widget>
  </div>
</v:dialog>