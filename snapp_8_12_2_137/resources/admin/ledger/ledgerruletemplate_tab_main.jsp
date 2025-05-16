<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageLedgerRuleTemplate" scope="request"/>
<jsp:useBean id="ledgerRuleTemplate" class="com.vgs.snapp.dataobject.DOLedgerRuleTemplate" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% boolean canEdit = rights.SettingsLedgerAccounts.canUpdate(); %>
<% boolean canCreate = rights.SettingsLedgerAccounts.canCreate(); %>
<% String sReadOnly = canEdit ? "" : " readonly=\"readonly\""; %>

<v:page-form id="ledgerruletemplate-form">
<v:input-text type="hidden" field="ledgerRuleTemplate.LedgerRuleTemplateId"/>

<div class="tab-toolbar">
  <v:button caption="@Common.Save" fa="save" onclick="doSave()" enabled="<%=canEdit%>"/>
  <% if (!pageBase.isNewItem()) {%>
    <span class="divider"></span>
    <% String onclickDuplicate = "asyncDialogEasy('ledger/ledgerruletemplate_duplicate_dialog', 'id=" + pageBase.getId() + "')"; %>
    <v:button caption="@Common.Duplicate" fa="clone" onclick="<%=onclickDuplicate%>" enabled="<%=canCreate%>"/>
    <span class="divider"></span>
    <% String hrefExport = ConfigTag.getValue("site_url") + "/admin?page=export&EntityIDs=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.LedgerRuleTemplate.getCode(); %> 
    <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" href="<%=hrefExport%>"/> 
  <% } %>
</div>

<script>

</script>

<div class="tab-content">
<v:last-error/>
  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="@Common.Code" mandatory="true">
        <v:input-text field="ledgerRuleTemplate.LedgerRuleTemplateCode" enabled="<%=canEdit%>" />
      </v:form-field>
      <v:form-field caption="@Common.Name" mandatory="true">
        <v:input-text field="ledgerRuleTemplate.LedgerRuleTemplateName" enabled="<%=canEdit%>" />
      </v:form-field>
      <v:form-field caption="@Category.Category">
        <v:combobox field="ledgerRuleTemplate.CategoryId" lookupDataSet="<%=pageBase.getBL(BLBO_Category.class).getCategoryAshedTreeDS(LkSNEntityType.LedgerRuleTemplate)%>" idFieldName="CategoryId" captionFieldName="AshedCategoryName" linkEntityType="<%=LkSNEntityType.Category%>" enabled="<%=canEdit%>"/>
      </v:form-field>
      <% String hrefTag = "javascript:showTagPickupDialog_OLD(" + LkSNEntityType.ProductType.getCode() + ",'ledgerRuleTemplate.TagIDs')"; %>
      <v:form-field caption="@Ledger.ProductTags" hint="@Ledger.ProductTagsHint" href="<%=hrefTag%>">
        <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
        <v:multibox field="ledgerRuleTemplate.TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:db-checkbox caption="@Common.Enabled" value="true" field="ledgerRuleTemplate.Enabled" enabled="<%=canEdit%>" />
    </v:widget-block>
  </v:widget>
</div>
</v:page-form>

<script>

function doSave() {
  checkRequired("#ledgerruletemplate-form", function() {
    doSaveLedgerRuleTemplate();
  });
}

function doSaveLedgerRuleTemplate() {
  var reqDO = {
    Command: "SaveLedgerRuleTemplate",
    SaveLedgerRuleTemplate: {
      LedgerRuleTemplate: {
        LedgerRuleTemplateId: $("#ledgerRuleTemplate\\.LedgerRuleTemplateId").val(),
        LedgerRuleTemplateCode: $("#ledgerRuleTemplate\\.LedgerRuleTemplateCode").val(),
        LedgerRuleTemplateName: $("#ledgerRuleTemplate\\.LedgerRuleTemplateName").val(),
        Enabled: $("#ledgerRuleTemplate\\.Enabled").isChecked(),
        CategoryId: $("#ledgerRuleTemplate\\.CategoryId").val(),
        TagIDs: $("#ledgerRuleTemplate\\.TagIDs").val()
      }
    }
  };

  showWaitGlass();
  vgsService("Ledger", reqDO, false, function(ansDO) {
    hideWaitGlass();
    entitySaveNotification(<%=LkSNEntityType.LedgerRuleTemplate.getCode()%>, ansDO.Answer.SaveLedgerRuleTemplate.LedgerRuleTemplateId);
  });  
}

</script>