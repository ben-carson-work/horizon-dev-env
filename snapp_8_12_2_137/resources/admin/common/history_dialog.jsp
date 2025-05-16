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

<%
DOHistoryRecapItem[] recaps = new DOHistoryRecapItem[2];
recaps[0] = pageBase.getBL(BLBO_HistoryLog.class).findHistoryRecapItem(pageBase.getId(), LkSNHistoryLogType.Create);
recaps[1] = pageBase.getBL(BLBO_HistoryLog.class).findHistoryRecapItem(pageBase.getId(), LkSNHistoryLogType.LastUpdate);
%>

<v:dialog id="history_dialog" title="@Common.History" width="800" height="600" autofocus="false">
  <div class="form-toolbar">
    <v:pagebox gridId="history-grid"/>
  </div>
  
  <v:grid style="margin-bottom:10px">
    <thead>
      <tr>
        <td colspan="2"><v:itl key="@Common.Creation"/></td>
        <td colspan="2"><v:itl key="@Common.LastUpdate"/></td>
      </tr>
    </thead>
    <tbody>
      <tr>
      <% for (DOHistoryRecapItem recap : recaps) { %>
        <% if (recap == null) { %>
          <td colspan="2" width="50%"><span class="list-subtitle"><v:itl key="@Common.None"/></span></td>
        <% } else { %>
          <td><v:grid-icon name="<%=recap.UserAccountIconName.getString()%>" repositoryId="<%=recap.UserAccountProfilePictureId.getString()%>"/></td>
          <td width="50%">
            <div>
              <snp:entity-link entityId="<%=recap.UserAccountId%>" entityType="<%=recap.UserAccountEntityType%>">
                <%=recap.UserAccountName.getHtmlString()%>
              </snp:entity-link>
            </div>
            <div>
              <snp:entity-link entityId="<%=recap.LocationId%>" entityType="<%=LkSNEntityType.Location%>">
                <%=recap.LocationName.getHtmlString()%>
              </snp:entity-link>
              &raquo;
              <snp:entity-link entityId="<%=recap.OpAreaId%>" entityType="<%=LkSNEntityType.OperatingArea%>">
                <%=recap.OpAreaName.getHtmlString()%>
              </snp:entity-link>
              &raquo;
              <snp:entity-link entityId="<%=recap.WorkstationId%>" entityType="<%=LkSNEntityType.Workstation%>">
                <%=recap.WorkstationName.getHtmlString()%>
              </snp:entity-link>
            </div>
            <div>
              <snp:datetime timestamp="<%=recap.LogDateTime%>" format="shortdatetime" timezone="local"/>
            </div>
          </td>
        <% } %>
      <% } %>
      </tr>
    </tbody>
  </v:grid>
  
  <% String params = "EntityId=" + pageBase.getId(); %>
  <v:async-grid id="history-grid" jsp="common/history_grid.jsp" params="<%=params%>"/>

<script>
$(document).ready(function() {
  var dlg = $("#history_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
      <v:itl key="@Common.Close" encode="JS"/>: doCloseDialog
    };
  });
});
</script>

</v:dialog>