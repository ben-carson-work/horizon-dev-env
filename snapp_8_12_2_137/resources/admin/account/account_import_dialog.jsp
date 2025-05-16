<%@page import="com.vgs.snapp.library.AsyncProcessUtils"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
LookupItem entityType = LkSN.EntityType.getItemByCode(JvUtils.getServletParameter(request, "EntityType"));
String firstNameFieldCode = pageBase.getBL(BLBO_MetaData.class).getMetaFieldCodeByFieldType(LkSNMetaFieldType.FirstName);

String rightMetaFieldId = "";
if (entityType.isLookup(LkSNEntityType.Organization))
  rightMetaFieldId = pageBase.getRights().AccImport_Organization_Search_MetaFieldId.getString();
else if (entityType.isLookup(LkSNEntityType.Person)) 
  rightMetaFieldId = pageBase.getRights().AccImport_Person_Search_MetaFieldId.getString();
else if (entityType.isLookup(LkSNEntityType.AssociationMember))
  rightMetaFieldId = pageBase.getRights().AccImport_AssociationMember_Search_MetaFieldId.getString();

%>

<v:dialog id="account-import-dialog" title="@Common.Import" width="800" autofocus="false">
  <div id="step-input">
    <v:widget caption="@Common.Parameters">
      <%if (!entityType.isLookup(LkSNEntityType.AssociationMember)) {%>
      <v:widget-block>
        <v:form-field caption="@Category.Category" id="DefaultCategoryId">
          <v:combobox field="CategoryId" lookupDataSet="<%=pageBase.getBL(BLBO_Category.class).getCategoryAshedTreeDS(entityType)%>" idFieldName="CategoryId" captionFieldName="AshedCategoryName" allowNull="false"/>
        </v:form-field>
        <v:form-field>
          <v:db-checkbox field="ForcePasswordChange" caption="@Common.ForcePasswordChange" value="true" checked="true"/>
        </v:form-field>
      </v:widget-block>
      <%} %>
      <v:widget-block>
        <v:db-checkbox field="UseMetaField" caption="@Account.AccImportMatchByMetaField" hint="@Account.AccImportMatchByMetaFieldHint" value="true" checked="false"/>
        <div id="match-metafield" class="hidden">
	        <v:form-field caption="@Common.MetaField">
	          <v:combobox field="MatchMetaFieldId" lookupDataSet="<%=pageBase.getBL(BLBO_MetaData.class).getMetaFieldDS()%>" idFieldName="MetaFieldId" captionFieldName="MetaFieldName" allowNull="false"/>
	        </v:form-field>
        </div>
      </v:widget-block>
      <v:widget-block>
        <jsp:include page="../repository/file_upload_widget.jsp"/>
      </v:widget-block>
    </v:widget>
    
    <v:alert-box type="info" title="@Common.Info">
      <v:itl key="@Account.ImportWizard_Line1"/><br/>
      <v:itl key="@Account.ImportWizard_Line2"/>
      <ul>
        <li><strong>AccountCode</strong>: used for matching existing account and doing an update instead of an insert, ignored if matching metafield is specified.</li>
        <%if (entityType.isLookup(LkSNEntityType.Organization)) {%>
          <li><strong>ParentAccountCode</strong>: the code of the location/organization this account is supposed to belong to</li>
        <%} %>  
        <%if (!entityType.isLookup(LkSNEntityType.AssociationMember)) {%>
          <li><strong>CategoryCode</strong>: the code of the category where this account is supposed to be inserted. If the code doesn't match an existing category, it will be added without category</li>
        <%} %>  
        <li><strong>MF:<i>{CODE}</i></strong>: where {CODE} matches a <span class="metafield-tooltip-link">metafield code</span>; ie: <b>MF:<%=JvString.escapeHtml(firstNameFieldCode)%></b> for first name</li>
        <li><strong>MF$<i>{NUMBER}</i></strong>: where {NUMBER} matches the <span class="lk-tooltip-link" data-LookupTable="<%=LkSN.MetaFieldType.getCode()%>">Meta Field Type</span> lookup item; ie: <b>MF$1</b> for first name</li>
       <%if (entityType.isLookup(LkSNEntityType.Person)) {%>
          <li><strong>UserName</strong>: login username</li>
          <li><strong>Password</strong>: login password</li>
          <li><strong>RelationName</strong>: code of the relation the account has with the RelationAccountCode</li>
          <li><strong>RelationAccountCode</strong>: code of the Account it will be related. The account must exist in SnApp in order to be related.</li>
          <li><strong>SecurityRoles</strong>: codes of the security roles assigned to this account, separated by | (no spaces)</li>
       <%} else if (entityType.isLookup(LkSNEntityType.Organization)) {%>
          <li><strong>SaleChannelCode</strong>: code of the sale channel this account is supposed to belong to</li>
          <li><strong>CommissionCode</strong>: code of the commission rule applied to this account</li>
          <li><strong>AgentAccountCode</strong>: code of agent assigned to the organization (for commission purposes)</li>
          <li><strong>B2BWorkstationCode</strong>: code of the B2B workstation associated with this account</li>
          <li><strong>MainCatalogCode</strong>: main catalog code of the B2B workstation</li>
          <li><strong>ResPurgeLock</strong>: prevent reservations auto-purge, when 1 reservation created on this account will have AutoPurge flag set to false</li>
          <li><strong>B2BRoleLimit</strong>: limit B2B users per profile, values has to be roleCode=quantity separate by | (no space)</li>
          <li><strong>TotalCredit</strong>: total credit limit applied to this organization</li>
          <li><strong>CreditDays</strong>: number of days after purchase, to calculate credit due date</li>
          <li><strong>GracePeriodDays</strong>: number of days, after the due date, when the account is blocked if payment remains outstanding</li>
          <li><strong>VoidWindowDays</strong>: number of days, before visit date, when it is still possible to void an order</li>
          <li><strong>CreditPerTransaction</strong>: maximum credit available for every transaction</li>
          <li><strong>ItemsPerTransaction</strong>: maximum items per transaction</li>
          <li><strong>AutoPayCredits</strong>: determines if deposit on account should be used to pay orders when sufficient. 1=Use deposit 0=Always credit</li>
          <li><strong>PayMethods</strong>: payment methods codes, separated by | (no spaces) , on which payment restrictions are applied</li>
       <%} %>
       <li><strong>NoteType</strong>: the note type code [Standard: 10 (default), Highlighted: 100].</li>
       <li><strong>Note</strong>: the note that you want link to the account. The note cannot contain commas or carriage returns.</li>
      </ul>
    </v:alert-box>
  </div>

  <div id="step-preview" class="step-item v-hidden">
    <jsp:include page="../csv_import_widget.jsp">
      <jsp:param name="AsyncProcessClassAlias" value="<%=AsyncProcessUtils.CLASS_ALIAS_IMPORT_ACCOUNT%>"/>
    </jsp:include>
  </div>

<script>

$(document).ready(function() {
  var id = $("#category-tree li.selected").attr("data-id");
  if (id != "all")
    $("#account-import-dialog [name='CategoryId']").val(id);
  
  $("#UseMetaField").change(refreshConfig);
  
  var $matchMetaFieldId = $("#MatchMetaFieldId");
  $matchMetaFieldId.val("<%=rightMetaFieldId%>").change();
  
});

function getImportParams() {
  return {
    Account: {
      EntityType: <%=entityType.getCode()%>,
      DefaultCategoryId: $("#account-import-dialog [name='CategoryId']").val(),
      ForcePwdChangeFirstLogin: $("#ForcePasswordChange").isChecked(),
      ParentAccountId: <%=JvString.jsString(JvUtils.getServletParameter(request, "ParentAccountId"))%>,
      MatchMetaFieldId: $("#UseMetaField").isChecked() ? $("#MatchMetaFieldId").val() : null
    }
  }
}

function refreshConfig() {
  $("#match-metafield").setClass("hidden", !$("#UseMetaField").isChecked());
}

function doUploadFinish(obj) {
  $("#step-input").addClass("v-hidden");
  $("#step-preview").removeClass("v-hidden");
  doCsvImport(obj.RepositoryId);
}

function csvImportCallback(proc) {
  triggerEntityChange(<%=LkSNEntityType.Account_All.getCode()%>);
}

</script>

</v:dialog>
