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
%>

<div id="topmenu-msg-widget" class="msg-need-update">
  <i class="fa fa-comment"></i>
  <span class="topmenu-caption"><v:itl key="@Common.NotificationCenter"/><span class="msg-unread-notify badge" data-UnreadCount="<%=unreadCount%>"><%=unreadCount%></span></span>
  <div class="topmenu-content">
    <div class="msg-list-header">
      <span style="float:left"><v:itl key="@Common.NotificationCenter"/></span>
      <span style="float:right"><a href="<%=pageBase.getContextURL()%>?page=message_user_list"><v:itl key="@Common.ShowAll"/></a></span>
    </div>
    <div class="msg-list-body"></div>
  </div>
</div>

<script>
$("#topmenu-msg-widget").mouseover(function() {
  var $this = $(this);
  if ($this.is(".msg-need-update")) {
    $this.removeClass("msg-need-update");
    asyncLoad($this.find(".msg-list-body"), "<%=pageBase.getContextURL()%>?page=widget&jsp=../common/message/message_topmenu_widget");
  }
});

function updateMessageUnreadCount(unreadCount) {
  var span = $("#topmenu-msg-widget .msg-unread-notify");
  var oldValue = span.attr("data-UnreadCount");
  if (oldValue != unreadCount+"") {
    span.text(unreadCount).attr("data-UnreadCount", unreadCount);
    $("#topmenu-msg-widget").addClass("msg-need-update");
  }
}

var messageUpdateInterval = 60000; // Every minute
var messageThreadInitialized = false;
$(document).ready(function() {
  if (!messageThreadInitialized) {
    setTimeout(checkMessageChanges, messageUpdateInterval); 
    messageThreadInitialized = true;
  }
});

function checkMessageChanges() {
  vgsService("Message", {Command:"GetUnreadCount",DontKeepSessionAlive:true}, true, function(ans) {
    var error = getVgsServiceError(ans);
    if ((error == null) && (ans) && (ans.Answer) && (ans.Answer.GetUnreadCount)) 
      updateMessageUnreadCount(ans.Answer.GetUnreadCount.UnreadCount);
    setTimeout(checkMessageChanges, messageUpdateInterval); 
  });
}
</script>