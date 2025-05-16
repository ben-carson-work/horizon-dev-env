<%@page import="com.vgs.snapp.dataobject.DOServer.DOServerWarVersionItem"%>
<%@page import="com.vgs.snapp.dataobject.DOServer.DOServerWarVersion"%>
<%@page import="com.vgs.cl.document.FtTimestamp"%>
<%@page import="com.vgs.web.library.BLBO_DBInfo"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
String idString = pageBase.getParameter("serverId");
int id = Integer.parseInt(idString);

DOServerWarVersion warVersionList = pageBase.getBL(BLBO_Server.class).getServerWarVersionList(id, 10);
%>

<div class="tab-content">
  <v:widget caption="@System.Versions">
    <v:widget-block>
    <% for (DOServerWarVersionItem item : warVersionList.ServerWarVersionList) {%>
      <div>
        <snp:datetime timestamp="<%=item.InstallDateTime%>" format="ShortDateTime" timezone="server"/>
        <td>&nbsp;&nbsp;&nbsp;</td>
        <td><%=item.WarVersion%></td>
      </div>
    <% }%>
    </v:widget-block>
  </v:widget>
</div>