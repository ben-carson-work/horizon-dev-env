<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTransaction" scope="request"/>

<script>
function showUpdateStatusDialog() {
  var mediaIDs = $("[name='MediaId']").getCheckedValues();
  if (mediaIDs == "")
    showMessage(<v:itl key="@Common.NoElementWasSelected" encode="JS"/>);
  else  
    asyncDialogEasy("portfolio/media_change_status_dialog", "mediaIDs=" + mediaIDs);
}
</script>

<div class="tab-toolbar">
  <v:button caption="@Common.Status" fa="lock" title="@Media.ChangeMediaStatus" enabled="<%=pageBase.getRights().MediaBlock.getBoolean()%>" href="javascript:showUpdateStatusDialog()"/>
  <v:pagebox gridId="media-grid"/>
</div>

<div class="tab-content">
  <v:last-error/>

  <% String params = "TransactionId=" + pageBase.getId(); %>
  <v:async-grid id="media-grid" jsp="portfolio/media_grid.jsp" params="<%=params%>"/>
</div>

