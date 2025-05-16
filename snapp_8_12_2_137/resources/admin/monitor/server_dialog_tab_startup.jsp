<%@page import="com.vgs.cl.document.FtTimestamp"%>
<%@page import="com.vgs.snapp.dataobject.DOServer.DOServerStatup"%>
<%@page import="com.vgs.snapp.dataobject.DOServer.DOServerParam"%>
<%@page import="com.vgs.web.library.BLBO_Server"%>
<%@page import="com.vgs.snapp.dataobject.DOServer"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
String idString = pageBase.getParameter("serverId");
int id = Integer.parseInt(idString);

DOServerStatup startUpList = pageBase.getBL(BLBO_Server.class).getServerStartupList(id, 10);
%>

<div class="tab-content">
  <v:widget caption="Date Time">
    <v:widget-block>
    <% for (FtTimestamp ts: startUpList.StartupDateTimeList) {%>
      <div>
        <snp:datetime timestamp="<%=ts.getDateTime()%>" format="ShortDateTime" timezone="server"/>
      </div>
    <% }%>
    </v:widget-block>
  </v:widget>
</div>