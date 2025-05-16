<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.web.library.BLBO_Category"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.bko.page.PageBO_Ledger" scope="request"/>

<div class="tab-toolbar">
  <v:button caption="@Common.Search" fa="search" href="javascript:search()"/>
  <span class="divider"></span>
	<v:button caption="@Common.New" fa="plus" href="admin?page=ledgerruletemplate&id=new" enabled="<%=rights.SettingsLedgerAccounts.canCreate()%>"/>
	<v:button caption="@Common.Delete" fa="trash" href="javascript:deleteLedgerRuleTemplates()" title="@Common.DeleteSelectedItems" enabled="<%=rights.SettingsLedgerAccounts.canDelete()%>"/>
	<span class="divider"></span>
  <v:button caption="@Common.Import" fa="sign-in" onclick="showImportDialog()"/>
  <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" bindGrid="ledgerruletemplate-grid"  onclick="exportLedgerProfiles()"/>
  <span class="divider"></span>
  <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.LedgerRuleTemplate.getCode() + ")";%>
  <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/>
	 
	<v:pagebox gridId="ledgerruletemplate-grid"/>  
</div>
<div class="tab-content">
	<div class="profile-pic-div">
	  <v:widget caption="@Common.Search">
	    <v:widget-block>
	      <input type="text" id="full-text-search" class="form-control default-focus" placeholder="<v:itl key="@Common.FullSearch"/>" value="<%=pageBase.getEmptyParameter("FullText")%>"/>
	    </v:widget-block>
	  </v:widget>
    <v:widget caption="@Category.Categories" editHRef="<%=pageBase.getCategoryEditLink(LkSNEntityType.LedgerRuleTemplate)%>">
      <v:widget-block>
        <snp:category-tree-widget entityType="<%=LkSNEntityType.LedgerRuleTemplate%>"/>
      </v:widget-block>
    </v:widget>
	</div>
  <div class="profile-cont-div">
 	  <v:last-error/>
 	 	<v:async-grid id="ledgerruletemplate-grid" jsp="ledger/ledgerruletemplate_grid.jsp" />
  </div>
</div>
      
<script>
 function search() {
	  setGridUrlParam("#ledgerruletemplate-grid", "FullText", $("#full-text-search").val(), true);
	}

	$("#full-text-search").keypress(function(e) {
	  if (e.keyCode == KEY_ENTER) {
	    search();
	    return false;
	  }
	});

  function deleteLedgerRuleTemplates() {
    var ids = $("[name='cbLedgerRuleTemplateId']").getCheckedValues();
    if (ids == "")
      showMessage(<v:itl key="@Common.NoElementWasSelected" encode="JS"/>);
    else {
      confirmDialog(null, function() {
        var reqDO = {
          Command: "DeleteLedgerRuleTemplates",
          DeleteLedgerRuleTemplates: {
            LedgerRuleTemplateIDs: ids
          }
        };
       
        showWaitGlass();
        vgsService("Ledger", reqDO, false, function(ansDO) {
          hideWaitGlass();
          triggerEntityChange(<%=LkSNEntityType.LedgerRuleTemplate.getCode()%>);
          
          if ((ansDO) && (ansDO.Answer) && (ansDO.Answer.DeleteLedgerRuleTemplates)) {
            var skipped = ansDO.Answer.DeleteLedgerRuleTemplates.SkippedCount;
            if (skipped > 0)
              showIconMessage("warning", skipped + " items skipped");
          } 
        });
      });  
    }
  }
  
  function showImportDialog() {
    asyncDialogEasy("ledger/ledger_profile_snapp_import_dialog", "");
  }
  
  function exportLedgerProfiles() {
	  var bean = getGridSelectionBean("#ledger-profile-grid-table", "[name='cbLedgerRuleTemplateId']");
	  if (bean) 
	    window.location = BASE_URL + "/admin?page=export&EntityIDs=" + bean.ids + "&EntityType=<%=LkSNEntityType.LedgerRuleTemplate.getCode()%> + &QueryBase64=" + bean.queryBase64;
	}
  
  var selCategoryId = <%=JvString.jsString(pageBase.getEmptyParameter("CategoryId"))%>;
  function categorySelected(categoryId) {
    selCategoryId = categoryId;
    setGridUrlParam("#ledgerruletemplate-grid", "CategoryId", categoryId, true);
  }
  
</script>