<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" scope="request" class="com.vgs.web.page.PageAccount"/>
<jsp:useBean id="account" scope="request" class="com.vgs.snapp.dataobject.DOAccount"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
String langISO = JvString.getEmpty(account.LangISO.isNull() ? account.DefaultLangISO.getString() : account.LangISO.getString()); 
Locale loc = new Locale(langISO); 
String langName = JvString.escapeHtml(JvString.getPascalCase(loc.getDisplayLanguage(pageBase.getLocale()))); 
FtCRUD rightCRUD = (FtCRUD)request.getAttribute("rightCRUD");
boolean canCreate = rightCRUD.canCreate();
canCreate = account.EntityType.isLookup(LkSNEntityType.OperatingArea) ? canCreate && rights.SystemSetupWorkstationDemographic.getBoolean() : canCreate;
boolean canEdit = rightCRUD.canUpdate() || (rightCRUD.canCreate() && pageBase.isNewItem());
canEdit = account.EntityType.isLookup(LkSNEntityType.OperatingArea) ? canEdit && rights.SystemSetupWorkstationDemographic.getBoolean() : canEdit;
boolean canBlock = pageBase.getRights().AccountBlock.getBoolean();
boolean canEditAccountCode = pageBase.getRights().EditAccountCode.getBoolean();
if (account.EntityType.isLookup(LkSNEntityType.CrossPlatform)) 
  canEdit = rights.SystemSetupCrossPlatform.canUpdate();
else if (account.EntityType.isLookup(LkSNEntityType.AssociationMember)) {
  canEdit = pageBase.getBL(BLBO_Account.class).canEditMember(account.ParentAccountId.getString());
  canCreate = canEdit;  
}
boolean canEditCategories = canEdit && rights.AccountCategorySelection.getBoolean();

String sDisabled = canEdit ? "" : " disabled=\"disabled\"";

LookupItem biometricOverride = LkSN.BiometricTicketOverrideType.getItemByCode(account.BiometricOverride.getInt(), LkSNBiometricTicketOverrideType.AsPerConfiguration);
boolean xpiOpArea = account.EntityType.isLookup(LkSNEntityType.OperatingArea) && pageBase.getBL(BLBO_Account.class).getEntityType(account.ParentAccountId.getString()).isLookup(LkSNEntityType.CrossPlatform);
String[] filterCategoryIDs = new String[]{};
if (canEditCategories)
  filterCategoryIDs = SnappUtils.getAccountRestrictedCategories(rights, account.EntityType.getLkValue(), pageBase.isNewItem() ? LkSNRightLevel.Create : LkSNRightLevel.Edit);

request.setAttribute("crossPlatform", account.CrossPlatform);
%>

<v:page-form id="account-form" trackChanges="true">
  <v:input-text field="account.AccountId" type="hidden" />
  <v:input-text field="account.EntityType" type="hidden" />
  <v:input-text field="account.ResourceTypeIDs" type="hidden"/>
  <v:input-text field="account.ResourceTypeId" type="hidden"/>
  <% if (!account.EntityType.isLookup(LkSNEntityType.Licensee, LkSNEntityType.Location, LkSNEntityType.Organization, LkSNEntityType.Person)) { %>
    <v:input-text field="account.ParentAccountId" type="hidden" />
  <% } %>
  <% if (account.EntityType.isLookup(LkSNEntityType.AccessArea)) { %>
    <v:input-text field="account.SpecialProductIDs" type="hidden" />
  <% } %>
  
<script>
  var metaFields = <%=pageBase.getBL(BLBO_MetaData.class).encodeItems(account.MetaDataList)%>;
</script>
  

<v:tab-toolbar>
  <v:button id="btn-save" caption="@Common.Save" fa="save" onclick="doSave()" enabled="<%=canEdit%>" bindSave="true"/>
  <% if (!pageBase.isNewItem() && account.EntityType.isLookup(LkSNEntityType.Organization, LkSNEntityType.Location, LkSNEntityType.OperatingArea, LkSNEntityType.AccessArea)) { %>
    <% String clickDup = "asyncDialogEasy('account/account_dup_dialog', 'id=" + account.AccountId.getHtmlString() + "')"; %>
    <v:button id="btn-duplicate" caption="@Common.Duplicate" fa="clone" onclick="<%=clickDup%>" enabled="<%=canCreate%>"/>
  <% } %>
  <snp:notes-btn entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.Person%>"/>
</v:tab-toolbar>

<v:tab-content>

  <v:profile-recap>  
    <snp:profile-pic entityId="<%=pageBase.getId()%>" entityType="<%=account.EntityType.getLkValue()%>" field="account.ProfilePictureId" enabled="<%=canEdit%>"/>
    
    <% if (!pageBase.isNewItem() && (!biometricOverride.isLookup(LkSNBiometricTicketOverrideType.AsPerConfiguration)) && account.EntityType.isLookup(LkSNEntityType.Person)) { %>
    <v:widget caption="@Biometric.Biometric" style="margin-top:10px">
      <v:widget-block>
        <v:itl key="@Ticket.BiometricOverrideLevel"/><span class="recap-value"><%=biometricOverride.getDescription()%></span><br/>
      </v:widget-block>
    </v:widget>
    <% } %>
    
    <% int relationCount = pageBase.getDB().getInt("select Count(*) from tbRelation"); %>
    <% if (!pageBase.isNewItem() && (relationCount > 0) && account.EntityType.isLookup(LkSNEntityType.Person)) { %>
    <v:widget caption="@Account.Relations" icon="chain.png" style="margin-top:10px">
      <div id="accrel-widget"></div>
      <script>
        function refreshAccountRelation() {
          asyncLoad("#accrel-widget", "<%=pageBase.getContextURL()%>?page=widget&jsp=account/account_relation_widget&AccountId=<%=pageBase.getId()%>&readonly=<%=!canEdit%>");
        }
        
        $(document).on("OnEntityChange", function(event, bean) {
          if (bean.EntityType == <%=LkSNEntityType.AccountRelation.getCode()%>)
            refreshAccountRelation();
        });
        
        refreshAccountRelation();
      </script>
    </v:widget>
    <% } %>
  </v:profile-recap>
  
  <v:profile-main>
    <v:widget caption="@Common.General">
      <v:widget-block>
        <% if (pageBase.isMasterAccount()) { %>
          <v:form-field caption="@Common.Code">
            <v:input-text field="account.LicenseId" enabled="false" />
          </v:form-field>
        <% } else { %>
          <v:form-field caption="@Common.Code">
            <v:input-text field="account.AccountCode" enabled="<%=canEdit && canEditAccountCode && !BLBO_DBInfo.isSystemUser(account.AccountCode.getString())%>" />
          </v:form-field>
        <% } %>
        <% if (account.EntityType.isLookup(LkSNEntityType.AccessArea, LkSNEntityType.OperatingArea, LkSNEntityType.Resource, LkSNEntityType.CrossPlatform)) { %>
          <v:form-field caption="@Common.Name" mandatory="true">
            <v:input-text field="account.DisplayName" enabled="<%=canEdit%>"/>
          </v:form-field>
        <% } %>
        <% if (pageBase.isMasterAccount() || account.EntityType.isLookup(LkSNEntityType.Resource, LkSNEntityType.OperatingArea, LkSNEntityType.AccessArea, LkSNEntityType.CrossPlatform, LkSNEntityType.AssociationMember)) { %>
          <v:input-text type="hidden" field="account.CategoryIDs"/>
        <% } else { %>
          <v:form-field caption="@Category.Category">
            <% JvDataSet dsCat = pageBase.getBL(BLBO_Category.class).getCategoryAshedTreeDS(filterCategoryIDs, account.EntityType.getLkValue()); %>
            <v:multibox field="account.CategoryIDs" lookupDataSet="<%=dsCat%>" idFieldName="CategoryId" captionFieldName="AshedCategoryName" enabled="<%=canEdit && rights.AccountCategorySelection.getBoolean()%>"/>
          </v:form-field>
        <% } %>
        <% if (account.EntityType.isLookup(LkSNEntityType.Organization, LkSNEntityType.Person, LkSNEntityType.Association, LkSNEntityType.AssociationMember)) { %>
          <v:form-field caption="@Common.Status" mandatory="true">
            <% if (pageBase.isNewItem()) { %>
              <v:lk-combobox field="account.AccountStatus" lookup="<%=LkSN.AccountStatus%>" allowNull="false" enabled="<%=canEdit && canBlock%>"/>
            <% } else { %>
              <v:input-group>
                <input type="text" class="form-control" disabled value="<%=account.AccountStatus.getHtmlLookupDesc(pageBase.getLang())%>"/>
                <v:input-group-btn>
                  <% String onClickStatus = "asyncDialogEasy('account/account_change_status_dialog','id=" + pageBase.getId() + "')"; %>
                  <v:button id="btn-status" caption="@Common.Edit" onclick="<%=onClickStatus%>" enabled="<%=canBlock%>"/>
                </v:input-group-btn>
              </v:input-group>
            <% } %>
          </v:form-field>
        <% } %>
        <% if (account.EntityType.isLookup(LkSNEntityType.Licensee, LkSNEntityType.Location, LkSNEntityType.Organization, LkSNEntityType.Person)) { %>
          <v:form-field caption="@Common.Language">
            <select <%=sDisabled%> name="account.LangISO" class="form-control"><%=pageBase.getBL(BLBO_Lang.class).getLangOptions(account.LangISO.getString(), account.DefaultLangISO.getString(), true)%></select>
          </v:form-field>
          <% if (account.EntityType.isLookup(LkSNEntityType.Location, LkSNEntityType.Organization, LkSNEntityType.Person)) { %>
            <%
            LookupItem parentEntityType = account.ParentEntityType.getLkValue();
            if (parentEntityType == null) {
              if (account.ParentAccountId.isNull())
                parentEntityType = account.EntityType.getLkValue();
              else
                parentEntityType = pageBase.getBL(BLBO_Account.class).getEntityType(account.ParentAccountId.getString());
            }
            %>
            <v:form-field caption="@Common.Parent" mandatory="false">
              <snp:parent-pickup placeholder="@Common.NotAssigned" field="account.ParentAccountId" id="<%=pageBase.getId()%>" entityType="<%=account.EntityType.getLkValue().getCode() %>" parentEntityType="<%=parentEntityType.getCode()%>" enabled="<%=(!pageBase.isNewItem() && canEdit)%>"/>
            </v:form-field>
          <% } %>
        <% } %>
      
        <% if (account.EntityType.isLookup(LkSNEntityType.Resource)) { %>
          <v:form-field caption="@Common.Quantity">
            <v:input-text field="account.ResourceQuantity" enabled="<%=canEdit%>"/>
          </v:form-field>
        <% } %>
        <% if (account.EntityType.isLookup(LkSNEntityType.Organization, LkSNEntityType.Person, LkSNEntityType.Association, LkSNEntityType.AssociationMember)) { %>
          <% String hrefTag = "javascript:showTagPickupDialog_OLD(" + account.EntityType.getInt() + ",'account.TagIDs')"; %>
          <v:form-field caption="@Common.Tags" href="<%=hrefTag%>">
            <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(account.EntityType.getLkValue()); %>
            <v:multibox field="account.TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName" enabled="<%=canEdit%>"/>
          </v:form-field>
        <% } %>
      </v:widget-block>

      <% if (account.EntityType.isLookup(LkSNEntityType.OperatingArea) && !xpiOpArea) { %>
        <v:widget-block>
          <v:form-field caption="@Account.AccessAreas" hint="@Account.GateAccessAreasHint">
            <v:multibox 
                field="account.AccessAreaIDs"
                lookupDataSet="<%=pageBase.getBLDef().getAccessAreaDS(account.ParentAccountId.getString())%>" 
                idFieldName="AccountId" 
                captionFieldName="DisplayName"
                enabled="<%=canEdit%>"/>
          </v:form-field>
        </v:widget-block>          
        <v:widget-block>  
          <v:form-field caption="@Account.WaitersRoles" hint="@Account.WaitersRolesHint">
            <v:multibox field="account.WaiterRoleIDs" linkEntityType="<%=LkSNEntityType.Role%>" filtersJSON="{\"Role\":{\"RoleType\":0,\"ActiveOnly\":true}}" enabled="<%=canEdit%>"/>
          </v:form-field>
        </v:widget-block>
      <% } %>

      <% if (pageBase.isMasterAccount()) { %>
      <v:widget-block>
        <v:form-field caption="@Common.ClientMinVersion">
          <input type="text" class="form-control" readonly="readonly" value="<v:config key="client-min-version"/>">
        </v:form-field>
        <v:form-field caption="@Common.ClientReqVersion">
          <v:input-text field="account.ClientRequiredVersion" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.TestSystemURL">
          <v:input-text field="account.TestSystemURL" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
      <% } %>
      
      <% if (account.EntityType.isLookup(LkSNEntityType.AccessArea)) { %>
      <v:widget-block>
        <v:form-field caption="@Common.Options">
          <v:db-checkbox field="account.AllowSeatAllocation" caption="@Seat.LimitedCapacity" title="" value="true" enabled="<%=canEdit%>"/> &nbsp; &nbsp; &nbsp;
        </v:form-field>
      </v:widget-block>
      <v:widget-block>
        <v:form-field caption="@Common.FulfilmentArea" hint="@Common.FulfilmentAreaHint">
          <snp:dyncombo field="account.FulfilmentAreaTagId" id="FulfilmentAreaTagId" entityType="<%=LkSNEntityType.FulfilmentArea%>" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
      
      <% } %>
      
      <% if (account.EntityType.isLookup(LkSNEntityType.Organization)) { %>
        <v:widget-block>
          <div><v:db-checkbox field="account.TourOperator" value="true" caption="@Account.TourOperator" hint="@Account.TourOperatorHint" enabled="<%=canEdit%>"/></div>
        </v:widget-block>
      <% } %>
      
      <% if (account.EntityType.isLookup(LkSNEntityType.Person)) { %>
        <v:widget-block>
          <div class="form-field">
            <div class="form-field-caption">
              <v:button caption="@Resource.ResourceTypes" href="javascript:showResourceSkillDialog()" enabled="<%=canEdit%>"/>
            </div>
            <div class="form-field-value">
              <div id="skill-names"></div>
            </div>
          </div>
        </v:widget-block>
      
        <% JvDataSet dsResourceSkill = pageBase.getBL(BLBO_Resource.class).getResourceSkillDS(null, true); %>
        <div id="resource-skill-dialog" class="v-hidden" title="<v:itl key="@Resource.ResourceTypes"/>">
          <style>
            .resource-type {
              font-weight: bold;
              margin-top: 10px;
              margin-bottom: 2px;
              border-bottom: 1px #dfdfdf solid;
            }
          </style>
        
          <% String lastResourceTypeId = null; %>
          <% while (!dsResourceSkill.isEof()) { %>
            <% String resourceTypeId = dsResourceSkill.getField("ResourceTypeId").getHtmlString(); %>
            <% if (!JvString.isSameString(resourceTypeId, lastResourceTypeId)) { %>
              <% lastResourceTypeId = resourceTypeId; %>
              <div class="resource-type"><%=dsResourceSkill.getField("ResourceTypeName").getHtmlString()%></div>
            <% } %>
            <div class="resource-skill" 
                data-ResourceTypeName="<%=dsResourceSkill.getField("ResourceTypeName").getHtmlString()%>" 
                data-ResourceSkillName="<%=dsResourceSkill.getField("ResourceSkillName").getHtmlString()%>">
              <v:db-checkbox caption="<%=dsResourceSkill.getField(\"ResourceSkillName\").getHtmlString()%>" value="<%=dsResourceSkill.getField(\"ResourceSkillId\").getHtmlString()%>" field="skill-id"/>
            </div>
            <% dsResourceSkill.next(); %>
          <% } %>
        </div>
        
        <script>
        
          function renderResourceSkills() {
            var dlg = $("#resource-skill-dialog");
            $("#skill-names").empty();
  
            var ids = $("#account\\.ResourceSkillIDs").val();
            ids = (ids == "") ? [] : ids.split(",");
            
            var values = {};
            for (var i=0; i<ids.length; i++) {
              var item = dlg.find("[value='" + ids[i] + "']").closest(".resource-skill");
              var type = item.attr("data-ResourceTypeName");
              if (!values[type])
                values[type] = [];
              values[type].push(item.attr("data-ResourceSkillName"));
            }
            
            $.each(values, function(key, value) {
              $("#skill-names").append("<b>" + key + "</b>: " + value.join(", ") + "<br/>");
            });
          }
        
          function showResourceSkillDialog() {
            var dlg = $("#resource-skill-dialog");
            
            dlg.find("input[type='checkbox']").setChecked(false);
            var ids = ($("#account\\.ResourceSkillIDs").val() == "") ? [] : $("#account\\.ResourceSkillIDs").val().split(",");
            for (var i=0; i<ids.length; i++) 
              dlg.find("[value='" + ids[i] + "']").setChecked(true);
            
            dlg.dialog({
              modal: true,
              width: 300,
              height: 500,
              buttons: [
                {
                  "text": itl("@Common.Ok"),
                  "click": function() {
                    $("#account\\.ResourceSkillIDs").val(dlg.find("[name='skill-id']").getCheckedValues());
                    renderResourceSkills();
                    onFieldChanged(null, $("#account-form"));
                    dlg.dialog("close");
                  }
                },
                {
                  "text": itl("@Common.Cancel"),
                  "click": doCloseDialog
                }
              ] 
            });
          }
          
          $(document).ready(renderResourceSkills);
          
        </script>

        <v:widget-block>
          <div>
            <div><v:db-checkbox field="account.PrivacyPurgeLock" value="true" caption="@Account.PrivacyPurgeLock" hint="@Account.PrivacyPurgeLockHint" enabled="<%=canEdit%>"/></div>
            <div><v:db-checkbox field="account.TourGuide" value="true" caption="@Account.TourGuide" hint="@Account.TourGuideHint" enabled="<%=canEdit%>"/></div>
          </div>
          <v:form-field caption="@Account.RetentionDate" hint="@Account.RetentionDateHint">
            <% if (account.RetentionDate.isNull()) { %>
              &mdash;
            <% } else { %>
              <b><%=JvString.htmlEncode(pageBase.format(account.RetentionDate, pageBase.getShortDateFormat()))%></b>
            <% } %>
          </v:form-field>
        </v:widget-block>
      <% } %>
    </v:widget>
    
    <% if (account.EntityType.isLookup(LkSNEntityType.CrossPlatform)) { %>
      <jsp:include page="account_tab_main_xpi.jsp"></jsp:include>
    <% } %>
    
    <% if (account.EntityType.isLookup(LkSNEntityType.Association)) { %>
      <v:widget>
        <v:widget-block>
          <v:form-field caption="@Account.ActiveFrom">
          <v:input-text type="datepicker" field="account.AssociationActiveFrom" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
          <v:itl key="@Common.To" transform="lowercase"/>
          <v:input-text type="datepicker" field="account.AssociationActiveTo" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
          </v:form-field>
        </v:widget-block>
        <v:widget-block>
          <v:form-field caption="@Account.MemberForms">
            <% JvDataSet dsForms = pageBase.getBL(BLBO_Mask.class).getMaskDS(LkSNEntityType.Organization); %>
            <v:multibox field="account.MemberMaskIDs" lookupDataSet="<%=dsForms%>" idFieldName="MaskId" captionFieldName="MaskName" enabled="<%=canEdit%>"/>
          </v:form-field>
          
          <v:form-field caption="@Account.MemberGrid">
              <v:combobox 
                field="account.MemberGridId" 
                lookupDataSet="<%=pageBase.getBL(BLBO_Grid.class).getGridDS(LkSNEntityType.AssociationMember)%>" 
                idFieldName="GridId" 
                captionFieldName="GridName" 
                allowNull="true" 
                linkEntityType="<%=LkSNEntityType.Grid%>"
                enabled="<%=canEdit%>"/>
          </v:form-field>
          
          <v:form-field caption="@Account.MemberRequired" checkBoxField="account.MemberRequired">
            <v:lk-combobox field="account.MemberVerificationType" lookup="<%=LkSN.MemberVerificationType%>" allowNull="false" enabled="<%=canEdit%>"/>
          </v:form-field>
          
          <v:form-field id="member-validation-type" caption="@Account.MemberValidationType">
            <v:lk-combobox field="account.MemberValidationType" lookup="<%=LkSN.MemberValidationType%>" allowNull="false" enabled="<%=canEdit%>"/>
          </v:form-field>
          
          <v:form-field id="member-validation-plugin" caption="@Account.MemberValidationPlugin">
            <v:combobox 
              field="account.MemberValidationPluginId" 
              lookupDataSet="<%=pageBase.getBL(BLBO_Plugin.class).getPluginDS(null, LkSNDriverType.AssociationMemberValidator)%>" 
              captionFieldName="PluginDisplayName" 
              idFieldName="PluginId" 
              enabled="<%=canEdit%>"/>
          </v:form-field>
          
        </v:widget-block>
      </v:widget>
    <% } %>
    
    <% if (account.EntityType.isLookup(LkSNEntityType.AccessArea)) { %>
      <v:grid id="special-product-grid">
        <thead >
          <v:grid-title caption="@Product.SpecialProducts"/>
          <tr>
            <td><v:grid-checkbox header="true"/></td>
            <td width="100%"><v:itl key="@Product.ProductType"/></td>
          </tr>
        </thead>
        <tbody id="special-product-list-tbody">
        </tbody>
        <tbody id="special-product-tool-tbody">
          <tr>
            <td colspan="100%">
              <v:button caption="@Common.Add" fa="plus" href="javascript:showProductPickupDialog()" enabled="<%=canEdit%>"/>
              <v:button caption="@Common.Remove" fa="minus" href="javascript:removeSpecialProduct()" enabled="<%=canEdit%>"/>
            </td>
          </tr>
        </tbody>
      </v:grid>
         
      <script>
      
      <% if (!pageBase.isNewItem()) {%>
        $(document).ready(function() {
          <% JvDataSet ds = pageBase.getBLDef().getAccAreaSpecialProductDS(pageBase.getId()); %>
          <% while (!ds.isEof()) { %>
           addSpecialProduct(
                <%=JvString.jsString(ds.getField("ProductId").getString())%>,
                <%=JvString.jsString(ds.getField("ProductCode").getString())%>,
                <%=JvString.jsString(ds.getField("ProductName").getString())%>
                );
            <% ds.next(); %>
          <% } %>
        });
      <% } %>
      
        function addSpecialProduct(id, code, name) {
          var tr = $("<tr class='grid-row' data-ProductId='" + id + "'/>").appendTo("#special-product-list-tbody");
          var tdCB = $("<td/>").appendTo(tr);
          var tdProd = $("<td/>").appendTo(tr);
          tdCB.append("<input value='" + id + "' type='checkbox' class='cblist'>");
          tdProd.html("[" + code + "] <a href=\"admin?page=product&id=" + id + "\">" + name + "</a>");
        }
  
        function showProductPickupDialog() {
          showLookupDialog({
            EntityType: <%=LkSNEntityType.ProductType.getCode()%>,
            onPickup: function(item) {
              if ($("#produpgrade-grid tr[data-ProductId='" + item.ItemId + "']").length > 0) 
                showMessage(itl("@Product.ProductAlreadyExistsError"));
              else if (item.ItemId == "<%=pageBase.getId()%>")
                showMessage(itl("@Product.ProductSelfReferenceError")); 
              else {
                addSpecialProduct(item.ItemId, item.ItemCode, item.ItemName);
              }
            }
          });
        }
  
        function removeSpecialProduct() {
          $("#special-product-grid tbody .cblist:checked").closest("tr").remove();
        }
      </script>      
    <% } %>
        
    <v:input-text type="hidden" field="account.ResourceSkillIDs"/>
    <% if (account.EntityType.isLookup(LkSNEntityType.Resource)) { %>
      <% JvDataSet dsSkill = pageBase.getDB().executeQuery("select * from tbResourceSkill where ResourceTypeId=" + account.ResourceTypeId.getSqlString()); %>
      <% if (!dsSkill.isEmpty()) { %>
        <v:widget caption="@Resource.Skills">
          <v:widget-block>
            <v:ds-loop dataset="<%=dsSkill%>">
              <% String skillId = dsSkill.getField("ResourceSkillId").getString(); %>
              <% String skillName = dsSkill.getField("ResourceSkillName").getString(); %>
              <% boolean checked = account.ResourceSkillIDs.contains(skillId); %>
              <v:db-checkbox field="ResourceSkillId" caption="<%=skillName%>" value="<%=skillId%>" checked="<%=checked%>"/>
              <br/>
            </v:ds-loop>
          </v:widget-block>
        </v:widget>
      <% } %>
    <% } %>
    
    <div id="maskedit-container"></div>
  </v:profile-main>
</v:tab-content>

</v:page-form>

<script>

function showBiometricOverrideDialog() {
	var params = "AccountId=<%=pageBase.getId()%>" + "&BiometricOverride=" + <%=account.BiometricOverride.getInt()%>;
	asyncDialogEasy("account/account_biometric_override_dialog", params);
}

function doSave() {
  var metaDataList = prepareMetaDataArray("#account-form");
  
  <%if (account.EntityType.isLookup(LkSNEntityType.AccessArea)) {%>
    var trs = $("#special-product-list-tbody tr");
    var specIDs = trs.map(function(val, i){return $(this).attr("data-ProductId");}).get().join(",");
    $("#account\\.SpecialProductIDs").val(specIDs);
  <% } %>
  
  <%if (account.EntityType.isLookup(LkSNEntityType.Resource)) {%>
    $("#account\\.ResourceTypeIDs").val($("[name='ResourceTypeId']").val());
    $("#account\\.ResourceSkillIDs").val($("[name='ResourceSkillId']").getCheckedValues());
  <% } else { %>
    $("#account\\.ResourceTypeIDs").val($("[name='ResourceTypeId']").getCheckedValues());
  <% } %>
  
  var isAssociation = <%=account.EntityType.isLookup(LkSNEntityType.Association)%>;
    
  checkRequired("#account-form", function() {
    var reqDO = {
      Command: "SaveAccount",
      SaveAccount: {
        AccountId                : <%=account.AccountId.getJsString()%>,
        EntityType               : <%=account.EntityType.getJsString()%>,
        LicenseId                : <%=account.LicenseId.getJsString()%>,
        ResourceTypeId           : <%=account.ResourceTypeId.getJsString()%>,
        ProfilePictureId         : $("#account\\.ProfilePictureId").val(),
        AccountCode              : $("#account\\.AccountCode").val(),
        ParentAccountId          : $("#account\\.ParentAccountId").val(),
        CategoryIDs              : $("#account\\.CategoryIDs").val(),
        LangISO                  : $("[name='account.LangISO']").val(),
        DisplayName              : $("#account\\.DisplayName").val(),
        ClientRequiredVersion    : $('#account\\.ClientRequiredVersion').val(),
        TestSystemURL            : $('#account\\.TestSystemURL').val(),
        AllowSeatAllocation      : $('#account\\.AllowSeatAllocation').isChecked(),
        ResourceSkillIDs         : $("#account\\.ResourceSkillIDs").val(),    
        ResourceQuantity         : $('#account\\.ResourceQuantity').val(),
        AccessAreaIDs            : $("#account\\.AccessAreaIDs").val(),
        WaiterRoleIDs            : $("#account\\.WaiterRoleIDs").val(),
        SpecialProductIDs        : $("#account\\.SpecialProductIDs").val(),
        TagIDs                   : $("#account\\.TagIDs").val(),
        PrivacyPurgeLock         : $("#account\\.PrivacyPurgeLock").isChecked(),
        TourOperator             : $("#account\\.TourOperator").isChecked(),
        TourGuide                : $("#account\\.TourGuide").isChecked(),
        AssociationActiveFrom    : isAssociation ? $("#account\\.AssociationActiveFrom-picker").getXMLDate() : null,
        AssociationActiveTo      : isAssociation ? $("#account\\.AssociationActiveTo-picker").getXMLDate() : null,
        MemberVerificationType   : isAssociation ? $("#account\\.MemberVerificationType").val() : null,
        MemberValidationType     : isAssociation ? $("#account\\.MemberValidationType").val() : null,
        MemberValidationPluginId : isAssociation ? $("#account\\.MemberValidationPluginId").val() : null,        		
        MemberRequired           : isAssociation ? $("[name='account\\.MemberRequired']").isChecked() : null,
        MemberMaskIDs            : isAssociation ? $("#account\\.MemberMaskIDs").val() : null,
        MemberGridId             : isAssociation ? $("#account\\.MemberGridId").val() : null,
        FulfilmentAreaTagId      : $("[name='account\\.FulfilmentAreaTagId']").val(),
        MetaDataList             : metaDataList
      }
    };
    
    <% if (pageBase.isNewItem()) { %>
      reqDO.SaveAccount.AccountStatus = $('#account\\.AccountStatus').val();
    <% } %>
    
    $(document).trigger("accountBeforeSave", reqDO.SaveAccount);
    
    showWaitGlass();
    vgsService("Account", reqDO, false, function(ansDO) {
      hideWaitGlass();
      entitySaveNotification(<%=account.EntityType.getInt()%>, ansDO.Answer.SaveAccount.AccountId);
    });  
  });
}


function doAddToMerge() {
  const COOKIE_NAME = <%=JvString.jsString(PageAccount.COOKIENAME_ACCOUNT_MERGE)%>;
  
  function _saveMergeCookie(value) {
    document.cookie = COOKIE_NAME + "=" + value + "; maxAge=0";
  }
  
  var list = getCookie(COOKIE_NAME) || "";
  var accountId = <%=JvString.jsString(pageBase.getId())%>;
  if ((list == "") || (list == accountId)) {
    _saveMergeCookie(accountId);
    showMessage(itl("@Account.MergeListCreated"));
  }
  else {
    if (list.indexOf(accountId) < 0)
      list += "," + accountId;
    _saveMergeCookie(list);
    var count = (list.match(/,/g) || []).length + 1;
    confirmDialog(itl("@Account.MergeAddedConfirm", count), function() {
      asyncDialogEasy("account/account_merge_dialog");
    });
  }
}

function doSyncronizeCrossPlatform() {
  showWaitGlass();
  var reqDO = {
    Command: "SyncXPIAccount",
    SyncXPIAccount: {
      CrossPlatformURL: <%=account.CrossPlatform.CrossPlatformURL.getJsString()%>,
      CrossPlatformRef: <%=account.CrossPlatform.CrossPlatformRef.getJsString()%>
    }
  };
  
  vgsService("Account", reqDO, false, function(ansDO) {
    hideWaitGlass();
    showAsyncProcessDialog(ansDO.Answer.SyncXPIAccount.AsyncProcessId, null, true);
  });
}

//Data Masks
function reloadMaskEdit(categoryIDs) {
  if (Array.isArray(categoryIDs))
    categoryIDs = categoryIDs.join(",");
  
  <% if (account.EntityType.isLookup(LkSNEntityType.AssociationMember)) { %>
    asyncLoad("#maskedit-container", "<%=pageBase.getContextURL()%>?page=maskedit_widget&id=<%=pageBase.getId()%>&EntityType=<%=account.EntityType.getInt()%>&CategoryIDs=" + categoryIDs + "&associationId=<%=account.ParentAccountId.getString()%>&readonly=<%=!canEdit%>");
  <% } else { %>
    asyncLoad("#maskedit-container", "<%=pageBase.getContextURL()%>?page=maskedit_widget&id=<%=pageBase.getId()%>&EntityType=<%=account.EntityType.getInt()%>&CategoryIDs=" + categoryIDs + "&readonly=<%=!canEdit%>");    
  <% } %>
}

reloadMaskEdit($("#account\\.CategoryIDs").val());

$("#account\\.CategoryIDs").change(function() {
  reloadMaskEdit($(this).val());
});

$("[name='account\\.MemberRequired']").change(function() {
  refreshMemberValidationTypeVisibility();
});


function refreshMemberValidationTypeVisibility() {
  var hidden = !$("[name='account\\.MemberRequired']").isChecked();
  $("#account\\.MemberValidationType").setClass("hidden", hidden);
  $("#member-validation-type").setClass("hidden", hidden);
  refreshMemberValidationPluginVisibility();
}

$(document).ready(refreshMemberValidationTypeVisibility);

$("#account\\.MemberValidationType").change(function() {
  refreshMemberValidationPluginVisibility();
});


function refreshMemberValidationPluginVisibility() {
  var hidden = $("#account\\.MemberValidationType").val() != <%=LkSNMemberValidationType.ExternalAPI.getCode()%>;
  $("#account\\.MemberValidationPluginId").setClass("hidden", hidden);
  $("#member-validation-plugin").setClass("hidden", hidden);
}

</script>
