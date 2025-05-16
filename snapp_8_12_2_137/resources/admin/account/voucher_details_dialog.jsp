<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:dialog id="voucher_details_dialog" icon="voucher.png" tabsView="true" title="Voucher" width="950" height="650" autofocus="false">

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-main" caption="@Common.Profile" icon="profile.png" default="true">
    <jsp:include page="voucher_details_dialog_tab_main.jsp"/>
  </v:tab-item-embedded>

  <v:tab-item-embedded tab="tabs-transaction" caption="@Common.Transaction" icon="transaction.png">
    <jsp:include page="voucher_details_dialog_tab_transaction.jsp"/>
  </v:tab-item-embedded>

  <% if (pageBase.getBL(BLBO_Log.class).hasLogs(pageBase.getId())) { %>
    <v:tab-item-embedded tab="tabs-log" caption="@Common.Logs" icon="<%=LkSNEntityType.Log.getIconName()%>">
      <div class="tab-content">
        <% String params = "EntityId=" + JvString.escapeHtml(pageBase.getId()); %>
        <v:async-grid id="log-grid" jsp="log/log_grid.jsp" params="<%=params%>"/>
      </div>
    </v:tab-item-embedded>
  <% } %>
</v:tab-group>
  
<script>
$(document).ready(function() {
  var dlg = $("#voucher_details_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {<v:itl key="@Common.Close" encode="JS"/>: doCloseDialog};
  });
});
</script>

</v:dialog>

