<%@page import="com.vgs.service.dataobject.DOCmd_Ledger"%>
<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="ledgerRuleTemplate" class="com.vgs.snapp.dataobject.DOLedgerRuleTemplate" scope="request"/>

<%
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");
boolean canEdit = !pageBase.isParameter("Readonly", "true"); 
LookupItem entityType = LkSN.EntityType.findItemByCode(pageBase.getParameter("EntityType"));
String entityId = pageBase.getNullParameter("EntityId");

DOLedgerRuleTemplate template = null;
DOLedgerRuleTemplateDate templateDate = null;
boolean enoughTabs = false;
if (entityType.isLookup(LkSNEntityType.LedgerRuleTemplateDate)) {
  String tabDateId = pageBase.getNullParameter("tab_date");
  if ((JvString.getNull(tabDateId) != null) && !JvString.isSameString(entityId, tabDateId)) 
    pageBase.getReq().setAttribute("EntityId", tabDateId);
  
  template = (DOLedgerRuleTemplate)request.getAttribute("ledgerRuleTemplate");
  templateDate = template.LedgerRuleTemplateDateList.getFirst(it -> it.LedgerRuleTemplateDateId.isSameString(JvString.coalesce(tabDateId, entityId)), "template-date");
  enoughTabs = template.LedgerRuleTemplateDateList.getSize() > 1;
}
%>

<v:tab-toolbar>
  <v:button-group>
    <v:button id="btn-rule-new" fa="plus" caption="@Common.New" enabled="<%=canEdit%>"/>
    <v:button id="btn-rule-del" fa="trash" caption="@Common.Delete" enabled="<%=canEdit%>"/>
  </v:button-group>
  
  <% if (entityType.isLookup(LkSNEntityType.ProductType)) {%>
    <span class="divider"></span>
    <v:button id="btn-rule-createprofile" fa="magic" caption="@Ledger.CreateProfileFromRules" title="@Ledger.CreateProfileFromRulesHint" enabled="<%=canEdit && rights.SettingsLedgerAccounts.canCreate()%>" onclick="_showCreateProfileDialog()"  />
  <% }%>
  
  
  <% if (templateDate != null) { %>
    <v:button-group>
      <v:button id="btn-tab" caption="Date Tab" dropdown="true" fa="calendar" enabled="<%=canEdit%>"/>
      <v:popup-menu bootstrap="true">
        <v:popup-item id="btn-date-new" fa="plus" caption="@Common.New" enabled="<%=canEdit%>"/>
        <v:popup-item id="btn-date-edit" fa="pencil" caption="@Common.Edit" enabled="<%=canEdit%>"/>
        <v:popup-item id="btn-date-delete" fa="trash" caption="@Common.Delete" enabled="<%=canEdit && enoughTabs%>"/>
      </v:popup-menu>
    </v:button-group>
  <% } %>

  <v:pagebox gridId="ledgerrule-grid"/>
</v:tab-toolbar>

<v:tab-content>
   <% String params = "EntityType=" + pageBase.getEmptyParameter("EntityType") + "&EntityId=" + pageBase.getEmptyParameter("EntityId") + "&Readonly=" + !canEdit; %>
   <v:async-grid id="ledgerrule-grid" jsp="ledger/ledgerrule_grid.jsp" params="<%=params%>"/>
   
  <div id="create-profile-dialog" class="v-hidden">
    <% DOCmd_Ledger.DORequest.DOCreateTemplateFromRulesRequest dummy = new DOCmd_Ledger.DORequest.DOCreateTemplateFromRulesRequest(); %>
    <v:form-field caption="@Common.Code">
      <input type="text" class="form-control" name="profile-code" maxlength="<%=dummy.LedgerRuleTemplateCode.getSize()%>"/>
    </v:form-field>
    <v:form-field caption="@Common.Name">
      <input type="text" class="form-control" name="profile-name" maxlength="<%=dummy.LedgerRuleTemplateName.getSize()%>"/>
    </v:form-field>
  </div>
   
</v:tab-content>

<script>

$(document).ready(function() {
  $("#btn-rule-new").click(_newLedgerRuleDialog);
  $("#btn-rule-del").click(_deleteLedgerRules);
  $("#btn-date-new").click(_newTemplateDate);

  $("#btn-date-edit").click(_editTemplateDate);
  $("#btn-date-delete").click(_deleteTemplateDate);

  function _newLedgerRuleDialog() {
    var triggerEntityId = <%=JvString.jsString(pageBase.getEmptyParameter("EntityId"))%>;
    var triggerEntityType = <%=pageBase.getEmptyParameter("EntityType")%>;
    asyncDialogEasy("ledger/ledgerrule_dialog", "id=new&EntityType=" + triggerEntityType + "&EntityId=" + triggerEntityId);
  }
  
  function _deleteLedgerRules() {
    confirmDialog(null, function() {
      snpAPI.cmd("Ledger", "DeleteLedgerRule", {
        LedgerRuleIDs: $("[name='LedgerRuleId']").getCheckedValues()
      })
      .then(ansDO => changeGridPage("#ledgerrule-grid", 1));
    });
  }

  function _newTemplateDate() {
    var ledgerRuleTemplateId = <%= ledgerRuleTemplate != null ? ledgerRuleTemplate.LedgerRuleTemplateId.getJsString() : null %>;
    if (ledgerRuleTemplateId) {
      var params = "new=true&"+"LedgerRuleTemplateId=" + ledgerRuleTemplateId + "&LedgerRuleTemplateDateId=" + <%=JvString.jsString(pageBase.getEmptyParameter("EntityId"))%>;
      asyncDialogEasy("ledger/ledgerruletemplatedate_dialog", params);
    }
  }

  function _editTemplateDate() {
    var ledgerRuleTemplateId = <%= template != null ? template.LedgerRuleTemplateId.getJsString() : null %>;
    if (ledgerRuleTemplateId) {
      var params = "LedgerRuleTemplateId=" + ledgerRuleTemplateId + "&LedgerRuleTemplateDateId=" + <%=JvString.jsString(pageBase.getEmptyParameter("EntityId"))%>;
      asyncDialogEasy("ledger/ledgerruletemplatedate_dialog", params);
    }
  }
  
  function _deleteTemplateDate() {
    var ledgerRuleTemplateId = <%= template != null ? template.LedgerRuleTemplateId.getJsString() : null %>;
    if (ledgerRuleTemplateId && <%=enoughTabs%>) {
      confirmDialog(null, function() {
        snpAPI.cmd("Ledger", "DeleteTemplateDate", {
          LedgerRuleTemplateDateId: <%=JvString.jsString(pageBase.getEmptyParameter("EntityId"))%>
        })
        .then(ansDO => entitySaveNotification(<%=LkSNEntityType.LedgerRuleTemplate.getCode()%>, ledgerRuleTemplateId, "tab=rules"))
      });
    }
  };
});

function _showCreateProfileDialog() {
  var dlg = $("#create-profile-dialog");
  
  dlg.dialog({
    modal: true,
    width: 500,
    title: <v:itl key="@Ledger.CreateProfileFromRules" encode="JS"/>,
    buttons: {
      <v:itl key="@Common.Create" encode="JS"/>: _doCreateProfile,
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    }
  });
  
  dlg.keypress(function(e) {
    if (e.keyCode == KEY_ENTER)
      _doCreateProfile();
  });
  
  function _doCreateProfile() {
    showWaitGlass();
    snpAPI.cmd("Ledger", "CreateTemplateFromRules", {
        EntityId: <%=JvString.jsString(pageBase.getId())%>,
        EntityType: <%=LkSNEntityType.ProductType.getCode()%>,
        LedgerRuleTemplateCode: dlg.find("[name='profile-code']").val(),
        LedgerRuleTemplateName: dlg.find("[name='profile-name']").val()
      })
      .then(ansDO => {
          entitySaveNotification(<%=LkSNEntityType.ProductType.getCode()%>, <%=JvString.jsString(pageBase.getId())%>);
          hideWaitGlass();
          dlg.dialog("close");
      });
  }
}


</script>