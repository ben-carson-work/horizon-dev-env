<%@page import="com.vgs.snapp.query.QryBO_Message.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<% 
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 
BOSessionBean boSession = (pageBase == null) ? null : (BOSessionBean)pageBase.getSession(); 

int unreadCount = pageBase.getBL(BLBO_Message.class).getUnreadCount();

QueryDef qdef = new QueryDef(QryBO_Message.class);
// Select
qdef.addSelect(Sel.MessageId);
qdef.addSelect(Sel.MessageType);
qdef.addSelect(Sel.MessageName);
qdef.addSelect(Sel.Enabled);
qdef.addSelect(Sel.ForcePopupDialog);
qdef.addSelect(Sel.DateTimeFrom);
qdef.addSelect(Sel.DateTimeTo);
qdef.addSelect(Sel.Message);
qdef.addSelect(Sel.ReadDateTime);
// Filter
qdef.addFilter(Fil.ReadUserAccountId, boSession.getUserAccountId());
qdef.addFilter(Fil.ApplyRights, "true");
qdef.addFilter(Fil.ForNow, "true");
// Sort
qdef.addSort(Sel.DateTimeFrom, false);
// Paging
qdef.pagePos = 1;
qdef.recordPerPage = 8;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
%>

<% if (ds.isEmpty()) { %>
  <div class="msg-empty"><v:itl key="@Common.NotificationEmptyMsg"/></div>
<% } else { %>
  <v:ds-loop dataset="<%=ds%>">
    <% boolean unread = ds.getField(Sel.ReadDateTime).isNull(); %>
    <% String messageId = ds.getField(Sel.MessageId).getHtmlString(); %>
    <div class="msg-item <%=unread?"msg-unread":""%>" data-MessageId="<%=messageId%>" onclick="showMessageReadDialog(this)">
      <div class="msg-item-title"><span class="msg-unread-bullet">&#x26AB;</span>&nbsp;<%=ds.getField(Sel.MessageName).getHtmlString()%></div>
      <div class="msg-item-datetime"><snp:datetime timestamp="<%=ds.getField(Sel.DateTimeFrom)%>" format="shortdatetime" timezone="local"/></div>
      <div class="msg-item-body"><%=JvString.escapeHtml(JvString.trunc(ds.getField(Sel.Message).getString(), 100))%></div>
    </div>
  </v:ds-loop>
<% } %>

<script>
function showMessageReadDialog(item) {
  asyncDialogEasy("../common/message/message_user_dialog", "id=" + $(item).attr("data-MessageId"));
}
</script>
