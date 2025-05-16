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
boolean canEditPerson = rights.AccountPRSs.getOverallCRUD().canUpdate();
boolean canCreatePerson = rights.AccountPRSs.getOverallCRUD().canCreate();
%>

<v:dialog id="owneraccount_search_dialog" title="@Account.B2B_Billing_Title" width="900" height="700" resizable="false" autofocus="true">
  <div id="owneraccount-search-box">
    <input id="owneraccount-fulltext" type="text" placeholder="<v:itl key="@Account.CLC_SearchTextHint"/>"/>
  </div>
  <div id="owneraccount-result-box">
    <v:grid id="owner-account-grid">
      <tbody>
      </tbody>
    </v:grid>
  </div>
  
  <div class="toolbar-block">
    <% if (canCreatePerson) { %>
      <div id="btn-owneraccountserach-create" class="v-button btn-float-right hl-green"><v:itl key="@Account.CLC_NewAccount"/></div>
    <% } %>
    <% if (stepToCheckout) { %> 
      <div id="btn-owneraccountserach-back" class="v-button btn-float-right hl-green"><v:itl key="@Common.Back"/></div>
    <% } else { %>
      <div id="btn-owneraccountserach-close" class="v-button btn-float-right hl-red"><v:itl key="@Common.Close"/></div>
    <% } %>
  </div>

  
<style>

#owneraccount_search_dialog {
  padding: 0;
}

#owneraccount-search-box {
  border-bottom: 1px solid var(--tab-border-color);
}

#owneraccount-fulltext {
  font-size: 1.3em;
  border: none;
  border-radius: 0;
  padding: 10px;
}

#owneraccount-fulltext:focus {
  outline: none;
  border: none;
}

#owneraccount-result-box {
  position: absolute;
  top: 41px;
  bottom: 0;
  left: 0;
  right: 0;
  overflow-y: auto;
}

#owner-account-grid {
  border: none;
}

#owner-account-grid .account-name {
  font-size: 1.3em;
  color: black;
}

#owner-account-grid .wait-row td {
  height: 50px;
}

</style>

  
<script>

var ownerRecPerPage = 50;

$(document).ready(function() {
  var dlg = $("#owneraccount_search_dialog");
  dlg.find(".tabs").tabs();
  
  dlg.find("#btn-owneraccountserach-back").click(function() {
    doCloseOwnerAccountSearchDialog(StepDir_Back);
  });
  
  dlg.find("#btn-owneraccountserach-close").click(doCloseDialog);
  
  dlg.find("#btn-owneraccountserach-create").click(function() {
    doOwnerAccountChoosed(null);
  });
});

function doOwnerAccountChoosed(account) {
  <% if (stepToCheckout) { %>
    doCloseOwnerAccountSearchDialog(StepDir_Next);
  <% } else { %>
    var accountId = (account == null) ? "" : account.AccountId;
    $("#owneraccount_search_dialog").dialog("close");
    
    if ((account == null) && <%=canCreatePerson%>)
      asyncDialogEasy("../clc/shopcart/owneraccount_dialog", "step-to-checkout=false");
  <% } %>
}

function doCloseOwnerAccountSearchDialog(stepDir) {
  $("#owneraccount_search_dialog").dialog("close");
  stepCallBack(Step_OwnerAccountSearch, stepDir);
}

$("#owneraccount-fulltext").keypress(function() {
  if (event.keyCode == KEY_ENTER) {
    doSearchOwnerAccounts(1, $(this).val());
    return false;
  }
});

function doSearchOwnerAccounts(pagePos, text) {
  var grid = $("#owner-account-grid");
  var tbody = grid.find("tbody");
  
  if (pagePos <= 1) {
    pagePos = 1;
    tbody.empty();
  }
  
  tbody.append("<tr class='wait-row'><td class='spinner32-bg' colspan='100%'/></tr>");

  var reqDO = {
    Command: "Search",
    Search: {
      PagePos: pagePos,
      RecordPerPage: ownerRecPerPage,
      EntityTypes: "<%=LkSNEntityType.Organization.getCode()%>,<%=LkSNEntityType.Person.getCode()%>",
      FullText: text
    }
  };
  
  vgsService("Account", reqDO, false, function(ansDO) {
    var total = ansDO.Answer.Search.TotalRecordCount;
    tbody.find(".wait-row").remove();
    grid.attr("data-FullText", text);
    grid.attr("data-PagePos", pagePos);
    grid.attr("data-Total", total);
    
    if (total > 0)
      renderAccounts(ansDO.Answer.Search.AccountList);
    else {
      var tr = $("<tr class='empty-row'><td colspan='100%'/></tr>").appendTo(tbody);
      tr.find("td").text("<v:itl key="@Common.NoItems" encode="UTF-8"/>");
    }
  });
}

$("#owneraccount-result-box").scroll(function() {
  var grid = $("#owner-account-grid");
  if (grid.find(".wait-row").length == 0) {
    var top = $(this).scrollTop();
    var ch = $(this).height();
    var gh = grid.height();
    
    if (gh - top <= ch + 100) {
      var text = grid.attr("data-FullText");
      var pagePos = parseInt(grid.attr("data-PagePos"));
      var total = parseInt(grid.attr("data-Total"));
      
      if (pagePos * ownerRecPerPage < total) 
        doSearchOwnerAccounts(pagePos + 1, text);
    }
  }
});

function renderAccounts(list) {
  if (list) {
    var tbody = $("#owner-account-grid tbody");
    for (var i=0; i<list.length; i++) {
      var item = list[i];
      var tr = $("<tr class='grid-row'/>").appendTo(tbody);
      tr.data(item);
      var tdIcon = $("<td><img class='list-icon' width='32' height='32'></td>").appendTo(tr);
      if (item.ProfilePictureId) 
        tdIcon.find("img").attr("src", "<v:config key="site_url"/>/repository?type=thumb&id=" + item.ProfilePictureId);
      else if (item.IconName)
        tdIcon.find("img").attr("src", "<v:config key="site_url"/>/imagecache?size=32&name=" + item.IconName);
      var tdName = $("<td width='50%'><div class='account-name'/><div class='account-code list-subtitle'/></td>").appendTo(tr);
      tdName.find(".account-name").text(((item.DisplayName == null) || (item.DisplayName == "")) ? "-" : item.DisplayName);
      tdName.find(".account-code").text(((item.CategoryRecursiveName == null) || (item.CategoryRecursiveName == "")) ? "-" : item.CategoryRecursiveName);
      var tdAddr = $("<td width='50%'><div class='account-address list-subtitle'/><div class='account-phones list-subtitle'/></td>").appendTo(tr);
      tdAddr.find(".account-address").text(item.CalcAddress);
      tdAddr.find(".account-phones").text(item.CalcPhones);
      
      tr.click(function() {
        var account = $(this).data();
        doSetOwnerAccount(account.AccountId, function() {
          doOwnerAccountChoosed(account);
        });
      });
    }
  }
}

</script>
  
</v:dialog>