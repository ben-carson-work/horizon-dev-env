<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<% 
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 

QueryDef qdef = new QueryDef(QryBO_Server.class);
qdef.addSelect(
    QryBO_Server.Sel.ServerId,
    QryBO_Server.Sel.ServerName,
    QryBO_Server.Sel.IconName,
    QryBO_Server.Sel.CommonStatus,
    QryBO_Server.Sel.CalcServerURL);
qdef.addSort(QryBO_Server.Sel.ServerId);
JvDataSet dsServer = pageBase.execQuery(qdef);
%>

<v:grid id="server-grid">
  <thead>
    <v:grid-title caption="Servers"/>
  </thead>
  <tbody>
    <v:ds-loop dataset="<%=dsServer%>">
      <%
      int serverId = dsServer.getField(QryBO_Server.Sel.ServerId).getInt();
      LookupItem status = LkSN.CommonStatus.getItemByCode(dsServer.getField(QryBO_Server.Sel.CommonStatus));
      %>
      <tr class="grid-row" data-serverid="<%=serverId%>">
        <td style="<v:common-status-style status="<%=status%>"/>"><v:grid-icon name="<%=dsServer.getField(QryBO_Server.Sel.IconName).getString()%>"/></td>
        <td><%=serverId%></td>
        <td width="100%">
          <strong><%=dsServer.getField(QryBO_Server.Sel.ServerName).getHtmlString()%></strong>
          <br/>
          <div style="max-width:150px; overflow:hidden; text-overflow:ellipsis">
            <span class="list-subtitle" title="<%=dsServer.getField(QryBO_Server.Sel.CalcServerURL).getHtmlString()%>"><%=dsServer.getField(QryBO_Server.Sel.CalcServerURL).getHtmlString()%></span>
          </div>
        </td>
      </tr>
    </v:ds-loop>
  </tbody>
</v:grid>
 
<script>
  $(document).ready(function() {
    $("#server-grid tr[data-serverid='<%=BLBO_DBInfo.getServerId()%>']").addClass("selected");
    
    $("#server-grid tr.grid-row").click(function() {
      var $this = $(this);
      $this.closest("table").find("tr.selected").removeClass("selected");
      $this.addClass("selected");
    });
  });
</script>
