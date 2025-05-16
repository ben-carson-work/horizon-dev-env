<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<% 
String errorStyle = "'color:red;font-weight:bold;text-align:center'";
String moreInfoStyle = "'color:black;font-weight:bold;text-align:center'";
%>

<v:dialog id="timezone_dialog" title="@Common.TimeZone" width="500" height="600" autofocus="true">

<v:grid>
  <tr class="grid-row"><td><b>Use default</b></td></tr>
</v:grid>

<v:grid>
  <% for (LookupItem timeZone : LkSN.TimeZone.getItems()) { %>
    <tr class="grid-row" data-timezonecode="<%=timeZone.getCode()%>">
      <td><%=timeZone.getHtmlDescription(pageBase.getLang())%></td>
    </tr>
  <% } %>
</v:grid>
  
<script>

$(document).ready(function() {
  var $dlg = $("#timezone_dialog");
  
  $dlg.find(".grid-row").click(function() {
    var timeZoneCode = $(this).attr("data-timezonecode");
    setForcedTimeZoneCode(timeZoneCode);
    window.location.reload();
  });
});
</script>

</v:dialog>