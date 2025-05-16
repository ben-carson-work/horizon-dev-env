<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
DOAccount account = new DOAccount();
account.AccountCode.setString(pageBase.getBL(BLBO_Account.class).generateDuplicateAccountCode(pageBase.getId()));
account.DisplayName.setString(pageBase.getBL(BLBO_Account.class).generateDuplicateAccountName(pageBase.getId()));
request.setAttribute("account", account);
%>

<v:dialog id="account_dup_dialog" title="@Common.Duplicate" width="600" autofocus="false">

  <v:form-field caption="@Common.NewCode">
    <v:input-text field="account.AccountCode"/>
  </v:form-field>

  <v:form-field caption="@Common.NewName">
    <v:input-text field="account.DisplayName"/>
  </v:form-field>


<script>

$(document).ready(function() {
  var dlg = $("#account_dup_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
      <v:itl key="@Common.Ok" encode="JS"/>: doDuplicate,
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    };
  });

  function doDuplicate() {
    var reqDO = {
      Command: "DuplicateAccount",
      DuplicateAccount: {
        OriginalAccountId: <%=JvString.jsString(pageBase.getId())%>,
        NewCode: dlg.find("#account\\.AccountCode").val(),
        NewName: dlg.find("#account\\.DisplayName").val()
      }
    };
    
    showWaitGlass();
    vgsService("Account", reqDO, false, function(ansDO) {
      hideWaitGlass();
      var accountId = ansDO.Answer.DuplicateAccount.AccountId;
      openEntityLink(<%=LkSNEntityType.OperatingArea.getCode()%>, accountId);
    });
  }
});

</script>

</v:dialog>