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
<% request.setAttribute("EntityId", pageBase.getId()); %>
<% request.setAttribute("GroupEntityId", pageBase.getNullParameter("GroupEntityId")); %>

<v:dialog id="ledgerref_dialog" width="1000" height="600" title="@Ledger.Ledger">

  <div class="tab-toolbar">
    <v:pagebox gridId="ledgerref-grid-container"/>
  </div>
  
  <div class="tab-content">
    <div class="">
      <% String params = "RefEntityId=" + pageBase.getNullParameter("RefEntityId");%>
      <v:async-grid id="ledgerref-grid-container" jsp="ledger/ledgerref_grid.jsp" params="<%=params%>"/>
    </div>
  </div>

</v:dialog>


