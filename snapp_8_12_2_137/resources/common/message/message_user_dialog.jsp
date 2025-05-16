<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
BOSessionBean boSession = (BOSessionBean)pageBase.getSession(); 
String messageId = pageBase.getId();

pageBase.getBL(BLBO_Message.class).setMessageRead(messageId, boSession.getUserAccountId(), boSession.getWorkstationId());
int unreadcount = pageBase.getBL(BLBO_Message.class).getUnreadCount(); 

DOMessage msg = pageBase.getBL(BLBO_Message.class).loadMessage(messageId);
%>

<v:dialog id="message_user_dialog" title="@Common.Message" width="800" height="600">

<style>
#message_user_dialog {
  padding: 20px;
}

.msgread-title {
  font-size: 2em;
  margin-bottom: 10px;
}

.msgread-datetime {
  color: rgba(0,0,0,0.8);
}

.msgread-body {
  border-top: 1px solid rgba(0,0,0,0.1);
  margin-top: 10px;
  padding-top: 20px;
}
</style>

  <div class="msgread-title"><%=msg.MessageName.getHtmlString()%></div>
  <table style="width:100%">
    <tr>
      <td><div class="msgread-datetime"><snp:datetime timestamp="<%=msg.CreateDateTime%>" format="shortdatetime" timezone="local"/></div></td>
      <td align="right"><div class="msgread-user"><snp:entity-link entityId="<%=msg.CreateUserAccountId%>" entityType="<%=LkSNEntityType.Person%>"><%=msg.CreateUserAccountName.getHtmlString()%></snp:entity-link> </div></td>
    </tr>
  </table>
  <div class="msgread-body"><%=msg.Message.getHtmlString()%></div>


<script>
$(document).ready(function() {
  var dlg = $("#message_user_dialog");

  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
      <v:itl key="@Common.Ok" encode="JS"/>: doCloseDialog
    };
    
    updateMessageUnreadCount(<%=unreadcount%>);
    triggerEntityChange(<%=LkSNEntityType.MessageUser.getCode()%>);
  });
});
</script>

</v:dialog>