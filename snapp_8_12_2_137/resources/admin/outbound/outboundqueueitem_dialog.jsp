<%@page import="com.vgs.snapp.web.queue.outbound.BLBO_Outbound"%>
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

<% 
String docData = pageBase.getBL(BLBO_Outbound.class).getQueueItemDocData(pageBase.getId());
request.setAttribute("message", docData);
request.setAttribute("flat", false);
%>

<v:dialog id="outbound_queue_item_dialog" title="@Common.Message" width="800" height="600">
<script>
$(document).ready(function(){
  var dlg = $("#outbound_queue_item_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        text: <v:itl key="@Common.Download" encode="JS"/>,
        click: doDownload
      },
      {
        text: <v:itl key="@Common.Close" encode="JS"/>,
        click: doCloseDialog
      }
    ];
  });  
  
  function doDownload() {
    window.open("<%=pageBase.getContextURL()%>?page=outboundqueue&action=download-item&OutboundQueueItemId=<%=pageBase.getId()%>", "_new");
  }
});
</script>

  <div class="tab-content">
    <jsp:include page="../common/text_format_widget.jsp"/>
  </div>
</v:dialog>