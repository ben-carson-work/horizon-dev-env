<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_DocTemplate.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<% boolean canEdit = true; %>

<v:dialog id="account_dialog" title="@Account.Account" icon="account_prs.png" width="800" height="600" autofocus="false">

<div id="maskedit-container"></div>

<script>

<%
String categoryId = pageBase.getRights().AccountPRS_DefaultCategoryId.getString();
if (categoryId == null)
  categoryId = pageBase.getBL(BLBO_Category.class).getRootCategoryId(LkSNEntityType.Person);
%>

var categoryId = <%=JvString.jsString(categoryId)%>;
var metaFields = {};
<% if (!pageBase.isNewItem()) { %>
  metaFields = <%=pageBase.getBL(BLBO_MetaData.class).encodeItems(LkSNEntityType.Person, pageBase.getId())%>; 
<% } %>

asyncLoad("#maskedit-container", "b2b?page=maskedit_widget&id=<%=pageBase.getId()%>&EntityType=<%=LkSNEntityType.Person.getCode()%>&CategoryId=" + categoryId + "&readonly=<%=!canEdit%>");

var dlg = $("#account_dialog");
dlg.on("snapp-dialog", function(event, params) {
  params.buttons = [
    {
      text: itl("@Common.Cancel"),
      click: doCloseDialog,
      "class": "hl-red"
      
    },
    {
      text: itl("@Common.Save"),
      click: doSave,
      "class": "hl-green"
    }
  ];
});

function doSave() {
  var list = prepareMetaDataArray("#account_dialog");
  if (!(list)) 
    showMessage(itl("@Common.CheckRequiredFields"));
  else {
	  var reqDO = {
	    Command: "SaveAccount",
	    SaveAccount: {
	      AccountId: <%=pageBase.isNewItem() ? null : JvString.jsString(pageBase.getId())%>,
	      EntityType: <%=LkSNEntityType.Person.getCode()%>,
	      CategoryId: categoryId,
	      MetaDataList: list
	    }
	  };

    showWaitGlass();
	  vgsService("Account", reqDO, false, function(ansDO) {
      hideWaitGlass();
      dlg.dialog("close");
      
      triggerEntityChange(<%=LkSNEntityType.Person.getCode()%>, ansDO.Answer.SaveAccount.AccountId);

      <% String callbackId = pageBase.getNullParameter("CallbackId"); %>
      <% if (callbackId != null) { %> 
        $(document).trigger(<%=JvString.jsString(callbackId)%>, {
          AccountId: ansDO.Answer.SaveAccount.AccountId,
          AccountCode: ansDO.Answer.SaveAccount.AccountCode,
          AccountName: ansDO.Answer.SaveAccount.DisplayName,
          AccountEmail: ansDO.Answer.SaveAccount.EmailAddress
        });
      <% } %>
    });
  }
}

</script>
</v:dialog>
