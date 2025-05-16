<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
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
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<v:dialog id="sessions_dialog" icon="sessionpool.png" title="Generic sessions" width="750" height="550" autofocus="false">

<% String params = "SessionPoolId=null&WorkstationType=" + pageBase.getParameter("WorkstationType"); %>
<v:pagebox gridId="session-grid"/>
<v:async-grid id="session-grid" jsp="session_grid.jsp" params="<%=params%>" />

<script>

$(document).ready(function() {
  var dlg = $("#sessions_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        text: <v:itl key="@Common.Ok" encode="JS"/>,
        click: doCloseDialog
      }                     
    ];
  });
});

</script>

</v:dialog>