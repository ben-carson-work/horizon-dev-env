<%@page import="com.vgs.snapp.task.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTaskList" scope="request"/>


<div class="tab-toolbar">
  <v:button caption="@Common.Refresh" fa="sync-alt" onclick="changeGridPage('#asyncproc-grid', 1)"/>
  <span class="divider"></span>

  <v:pagebox gridId="asyncproc-grid"/>
</div>

<div class="tab-content">
  <v:async-grid id="asyncproc-grid" jsp="task/asyncproc_grid.jsp" />
</div>

<script>

function showAsyncProcDialog(dialog_page) {
  asyncDialogEasy(dialog_page, "&id=new");
}

</script>
