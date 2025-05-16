<%@page import="java.util.*"%>
<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<% List<SrvBOBase> list = BOServiceManager.getServices(); %>


<v:grid>
  <thead>
    <tr>
      <td><v:grid-checkbox header="true" /></td>
      <td></td>
      <td width="100px"><v:itl key="@Common.Status"/></td>
      <td width="50%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Description"/>
      </td>
      <td width="50%">
        Last message
      </td>
      <td align="right" width="140px" nowrap>
        Activity/Loop count<br/>
        Last loop
      </td>
    </tr>
  </thead>
  <tbody>
  <% for (SrvBOBase srv : list) { %>
    <tr class="grid-row">
      <td style="<v:common-status-style status="<%=srv.getCommonStatus()%>"/>"><v:grid-checkbox name="ServiceId" value="<%=srv.getServiceId()%>"/></td>
      <td><v:grid-icon name="<%=srv.getIconName()%>"/></td>
      <td>
        <%=srv.getStatus().getHtmlDescription(pageBase.getLang())%><br>
        <% String key = srv.isOptional() ? "@Common.Optional" : "@Common.Mandatory"; %>
        <span class="list-subtitle"><v:itl key="<%=key%>" transform="lowercase"/></span>
      </td>
      <td>
        <%=JvString.escapeHtml(srv.getName())%><br/>
        <span class="list-subtitle"><%=JvString.escapeHtml(srv.getDescription())%></span>
      </td>
      <td>
        <span class="list-subtitle"><%=JvString.escapeHtml(srv.getLastErrorMessage())%></span>
      </td>
      <td align="right" nowrap>
        <%=srv.getActivityCount()%> / <%=srv.getLoopCount()%><br/>
        <span class="list-subtitle"><%=(srv.getLastLoop() == null) ? "" : srv.getLastLoop().format(pageBase.getShortDateFormat() + " " + pageBase.getLongTimeFormat())%></span>
      </td>
    </tr>
  <% } %>
  </tbody>
</v:grid>

