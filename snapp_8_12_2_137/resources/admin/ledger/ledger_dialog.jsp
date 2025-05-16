<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<% 
String groupEntityIDs = pageBase.getNullParameter("GroupEntityIDs") != null ? pageBase.getEmptyParameter("GroupEntityIDs") : pageBase.getId();
String refEntityId = pageBase.getNullParameter("RefEntityId");
%>

<v:dialog id="ledger_dialog" width="1280" height="600" title="@Ledger.Ledger">
  <div class="tab-toolbar">
    <v:pagebox gridId="ledger-grid"/>
  </div>
  <div class="tab-content">
    <% String params = "GroupEntityIDs=" + groupEntityIDs;%>
    <% if (refEntityId != null)
      params += "&RefEntityId=" + refEntityId;%>
    <v:async-grid id="ledger-grid" jsp="ledger/ledger_grid.jsp" params="<%=params%>"/>
  </div>

</v:dialog>


