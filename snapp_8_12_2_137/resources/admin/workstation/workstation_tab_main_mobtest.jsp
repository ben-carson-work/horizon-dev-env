<%@page import="java.net.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageWorkstation" scope="request"/>
<jsp:useBean id="wks" class="com.vgs.snapp.dataobject.DOWorkstation" scope="request"/>

<style>
#mobtest-back   {position:fixed; top:0; bottom:0; left:0; right:0; z-index:10000; background:rgba(0,0,0,0.4)} 
#mobtest-pane   {position:absolute; top:0; bottom: 0; right:0; width:60vh; background:white; box-shadow:0 0 20px black;}
#mobtest-iframe {border:none}
</style>

<div id="mobtest-back" class="hidden">
  <div id="mobtest-pane">
    <iframe id="mobtest-iframe" width="100%" height="100%"></iframe>
  </div>
</div>

<script>
$(document).ready(() => {
  var $back = $("#mobtest-back");
  $back.click(_hide);
  $("#btn-mob-test").click(_show);
  
  function _show() {
    $back.removeClass("hidden");
    $("#mobtest-iframe").attr("src", BASE_URL + "/admin?page=mobile_admission&id=" + <%=wks.WorkstationId.getJsString()%>);
  }
  
  function _hide() {
    $back.addClass("hidden")
  }
});
</script>