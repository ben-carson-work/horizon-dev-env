<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:dialog id="useractivity-dialog" width="700" height="600" title="@Account.UserActivity">
  <div class="form-toolbar" style="margin-top:10px">
    <v:pagebox gridId="useractivity-grid"/>
  </div>
  
  <% String params = "id=" + pageBase.getId();%>
  <v:async-grid id="useractivity-grid" jsp="account/useractivity_grid.jsp" params="<%=params%>"/>
    
<script>
  var dlg = $("#useractivity-dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    };
  });
</script>

</v:dialog>