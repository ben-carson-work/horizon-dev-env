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

<% DOLockInfo lockInfo = pageBase.getBL(BLBO_Lock.class).findLock(pageBase.getNullParameter("SaleId")); %>

<v:dialog id="salelock_dialog" title="@Common.LockInfo" width="500" resizable="false" autofocus="false">

<% if (lockInfo == null) { %>
  <v:itl key="@Sale.LockReleased"/>
<% } else { %>
  <strong><v:itl key="@Sale.SaleLockNotes" param1="<%=lockInfo.EntityDesc.getString()%>"/></strong>
  <% if (pageBase.isVgsContext("CLC")) { %>
    <br/>&nbsp;<br/>
    <v:form-field caption="@Account.Location"><strong><%=lockInfo.LocationName.getHtmlString()%></strong></v:form-field>
    <v:form-field caption="@Account.OpArea"><strong><%=lockInfo.OpAreaName.getHtmlString()%></strong></v:form-field>
    <v:form-field caption="@Common.Workstation"><strong><%=lockInfo.WorkstationName.getHtmlString()%></strong></v:form-field>
    <v:form-field caption="@Common.User"><strong><%=lockInfo.UserAccountName.getHtmlString()%></strong></v:form-field>
  <% } %>
<% } %>
  
<script>

$(document).ready(function() {
  var dlg = $("#salelock_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        "text": <v:itl key="@Common.Close" encode="JS"/>,
        "class": "hl-red",
        "click": doCloseDialog
      }
    ];
  });
});

</script>
  
</v:dialog>