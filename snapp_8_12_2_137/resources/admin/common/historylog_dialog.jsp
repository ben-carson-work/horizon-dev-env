<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<v:dialog id="historylog_dialog" title="@Common.History" width="1200" height="800" autofocus="false">
  <% String params = "EntityId=" + pageBase.getId() + "&LogDateTime=" + pageBase.getNullParameter("LogDateTime"); %>
  <v:async-grid id="history-detail-grid" jsp="common/history_detail_grid.jsp" params="<%=params%>"/>

  <script>
  $(document).ready(function() {
    var dlg = $("#historylog_dialog");
    dlg.on("snapp-dialog", function(event, params) {
      params.buttons = {
        <v:itl key="@Common.Close" encode="JS"/>: doCloseDialog
      };
    });
  });
  </script>

</v:dialog>



