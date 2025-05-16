<%@page import="com.vgs.snapp.query.QryBO_Category"%>
<%@page import="com.vgs.web.tag.IvDBComboTagHandler"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
boolean stepToCheckout = pageBase.isParameter("step-to-checkout", "true");
String accountId = pageBase.isNewItem() ? null : pageBase.getId();
String categoryId = rights.AccountPRS_DefaultCategoryId.isNull(pageBase.getBL(BLBO_Category.class).getRootCategoryId(LkSNEntityType.Person));
DOAccount account = new DOAccount();
if (accountId != null) {
  account = pageBase.getBL(BLBO_Account.class).loadAccount(accountId);
  if (!account.CategoryIDs.isEmpty())
    categoryId = account.CategoryIDs.findFirstValue();
}

IvDBComboTagHandler handler = new IvDBComboTagHandler() {
  public boolean isEnabled(JvDataSet ds) {
    return ds.getField(QryBO_Category.Sel.OrderOwner).getBoolean();
  }
};
%>

<v:dialog id="owneraccount_dialog" title="@Account.B2B_Billing_Title" width="900" height="700" resizable="false" autofocus="false">
  <v:widget caption="@Category.Category">
    <v:widget-block>
      <v:form-field caption="@Category.Category">
        <% JvDataSet dsCat = pageBase.getBL(BLBO_Category.class).getCategoryAshedTreeDS(LkSNEntityType.Person); %>
        <v:combobox id="OwnerCategoryId" lookupDataSet="<%=dsCat%>" idFieldName="CategoryId" captionFieldName="AshedCategoryName" allowNull="false" handler="<%=handler%>"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>

  <div id="owneraccount-newaccount-container"></div>
  
<script>

$(document).ready(function() {
  var dlg = $("#owneraccount_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      <% if (stepToCheckout) { %>                      
        dialogButton("@Common.Back", () => doCloseOwnerAccountDialog(StepDir_Back)),
        dialogButton("@Common.Next", () => doSaveOwnerAccount(() => doCloseOwnerAccountDialog(StepDir_Next)))
      <% } else { %>
        dialogButton("@Common.Save", () => doSaveOwnerAccount(function() {dlg.dialog("close")})),
        dialogButton("@Common.Close", doCloseDialog)
      <% } %>
    ];
  });
  
  $('#OwnerCategoryId').change(ownerCategoryChanged).children('option:enabled').eq(0).prop('selected',true);
  ownerCategoryChanged();
});

function doCloseOwnerAccountDialog(stepDir) {
  $("#owneraccount_dialog").dialog("close");
  stepCallBack(Step_OwnerAccount, stepDir);
}

function ownerCategoryChanged() {
  ownerEntityType = <%=LkSNEntityType.Person.getCode()%>;
  ownerCategoryId = $("#OwnerCategoryId").val();
  
  if (ownerCategoryId != null) {
    var urlo = "<%=pageBase.getContextURL()%>?page=maskedit_widget&LoadData=true&EntityType=" + ownerEntityType;
    <% if (accountId == null) { %>
      urlo += "&CategoryId=" + ownerCategoryId;
    <% } else { %>
      urlo += "&id=<%=accountId%>"; 
    <% } %>
  
    asyncLoad("#owneraccount-newaccount-container", urlo);
  }
}

function doSaveOwnerAccount(callback) {
  var list = prepareMetaDataArray("#owneraccount-newaccount-container");

  if (!(list)) 
    showMessage(itl("@Common.CheckRequiredFields"));
  else {
    var reqDO = <%=account.getJSONString()%>;
    <% if (accountId == null) { %>
      reqDO.EntityType = ownerEntityType;
    <% } %>
    reqDO.CategoryId = ownerCategoryId;
    reqDO.MetaDataList = list;
    
    snpAPI.cmd("Account", "SaveAccount", reqDO)
      .then(ansDO => doSetOwnerAccount(ansDO.AccountId, callback));
  }
}

</script>
  
</v:dialog>