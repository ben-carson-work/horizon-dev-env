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
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% 
request.setAttribute("EntityId", pageBase.getId());
request.setAttribute("GroupEntityId", pageBase.getNullParameter("GroupEntityId"));
String title = JvString.coalesce(pageBase.getNullParameter("Title"), pageBase.getLang().Ledger.Ledger.getText());
%>
<v:dialog id="ledgerref_rules_dialog" width="400" height="400" title="<%=title%>">

  <div class="tab-toolbar">
    <v:pagebox gridId="ledgerref-rules-grid-container"/>
  </div>
  
  <div class="tab-content">
    <div class="">
      <% String params = "GroupEntityId=" + pageBase.getNullParameter("GroupEntityId") + "&LedgerSerial=" + pageBase.getNullParameter("LedgerSerial");%>
      <v:async-grid id="ledgerref-rules-grid-container" jsp="ledger/ledgerref_rules_grid.jsp" params="<%=params%>"/>
    </div>
  </div>

</v:dialog>