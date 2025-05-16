<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSale" scope="request"/>

<script>
function showUpdateStatusDialog() {
  var mediaIDs = $("[name='MediaId']").getCheckedValues();
  var queryBase64 = null; 
  if (mediaIDs == "")
    showMessage(itl("@Common.NoElementWasSelected"));
  else if ($("#media-grid-table").hasClass("multipage-selected")) {
    mediaIDs = "";            
    queryBase64 = $("#media-grid-table").attr("data-QueryBase64");
  }
  asyncDialogEasy("portfolio/media_change_status_dialog", "mediaIDs=" + mediaIDs, {"QueryBase64": queryBase64});
}
</script>

<div class="tab-toolbar">
  <v:button caption="@Common.Status" fa="lock" bindGrid="media-grid" bindGridEmpty="false" title="@Media.ChangeMediaStatus" enabled="<%=pageBase.getRights().MediaBlock.getBoolean()%>" href="javascript:showUpdateStatusDialog()"/>
  <v:pagebox gridId="media-grid"/>
</div>

<div class="tab-content">
  <v:last-error/>

  <% String params = "SaleId=" + pageBase.getId(); %>
  <v:async-grid id="media-grid" jsp="portfolio/media_grid.jsp" params="<%=params%>"/>
</div>

