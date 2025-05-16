<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProductFamily" scope="request"/>
<jsp:useBean id="prodFamily" class="com.vgs.snapp.dataobject.DOProductFamily" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% boolean canEdit = pageBase.getRightCRUD().canUpdate(); %>
<% boolean canDelete = pageBase.getRightCRUD().canDelete(); %>
<% String sReadOnly = canEdit ? "" : " readonly=\"readonly\""; %>

<v:page-form id="prodfamily-form">
<v:input-text type="hidden" field="prodFamily.ProductFamilyId"/>

<div class="tab-toolbar">
  <v:button caption="@Common.Save" fa="save" href="javascript:doSave()" enabled="<%=canEdit%>"/>
  <snp:notes-btn entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.ProductFamily%>"/>
</div>

<script>
  var metaFields = <%=pageBase.getBL(BLBO_MetaData.class).encodeItems(prodFamily.MetaDataList)%>;
</script>

<div class="tab-content">
<v:last-error/>
  <div class="profile-pic-div">
    <snp:profile-pic entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.ProductFamily%>" field="prodFamily.ProfilePictureId" enabled="<%=canEdit%>"/>
  </div>
  <div class="profile-cont-div">
    <v:widget caption="@Common.General" icon="profile.png">
      <v:widget-block>
        <v:form-field caption="@Common.Code" mandatory="true">
          <v:input-text field="prodFamily.ProductFamilyCode" enabled="<%=canEdit%>" />
        </v:form-field>
        <v:form-field caption="@Common.Name" mandatory="true">
          <snp:itl-edit field="prodFamily.ProductFamilyName" entityType="<%=LkSNEntityType.ProductFamily%>" entityId="<%=prodFamily.ProductFamilyId.getString()%>" langField="<%=LkSNHistoryField.ProductFamily_Name%>" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Category.Category" mandatory="true">
          <v:combobox field="prodFamily.CategoryId" lookupDataSetName="dsCategoryTree" idFieldName="CategoryId" captionFieldName="AshedCategoryName" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.Description" checkBoxField="prodFamily.ShowNameExt">
          <snp:itl-edit field="prodFamily.ProductFamilyNameExt" entityType="<%=LkSNEntityType.ProductFamily%>" entityId="<%=pageBase.getId()%>" langField="<%=LkSNHistoryField.ProductFamily_NameExt%>" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.Parent" mandatory="false">
          <snp:parent-pickup field="prodFamily.ParentEntityId" id="<%=prodFamily.ProductFamilyId.getString()%>" entityType="<%=LkSNEntityType.ProductFamily.getCode()%>" parentEntityType="<%=prodFamily.ParentEntityType.getInt()%>" placeholder="@Common.NotAssigned" enabled="<%=canDelete%>"/>
        </v:form-field>
      </v:widget-block>
      
      <v:widget-block>
        <v:form-field caption="@Common.Status">
          <v:lk-combobox field="prodFamily.ProductFamilyStatus" lookup="<%=LkSN.ProductStatus%>" allowNull="false" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Product.UpgradeProductFamily">
          <snp:dyncombo field="prodFamily.TargetProductFamilyId" entityType="<%=LkSNEntityType.ProductFamily%>"/>
        </v:form-field>
        <% String hrefTag = "javascript:showTagPickupDialog_OLD(" + LkSNEntityType.ProductFamily.getCode() + ",'prodFamily.TagIDs')"; %>
        <v:form-field caption="@Common.Tags" href="<%=hrefTag%>">
          <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductFamily); %>
          <v:multibox field="prodFamily.TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName"/>
        </v:form-field>
      </v:widget-block>
      
      <v:widget-block>
        <v:form-field caption="@Common.Colors">
          <v:color-picker field="prodFamily.ForegroundColor" caption="@Common.Foreground" enabled="<%=canEdit%>"/>
          <v:color-picker field="prodFamily.BackgroundColor" caption="@Common.Background" enabled="<%=canEdit%>"/> 
        </v:form-field>
      </v:widget-block>
    </v:widget>
    <div id="maskedit-container"></div>
  </div>
  
</div>
</v:page-form>

<script>
$(document).ready(refreshNameExt);
$("#prodFamily\\.ProductFamilyName").keyup(refreshNameExt);

//Data Masks
function reloadMaskEdit(categoryId) {
  asyncLoad("#maskedit-container", "admin?page=maskedit_widget&id=<%=pageBase.getId()%>&EntityType=<%=LkSNEntityType.ProductType.getCode()%>&CategoryId=" + categoryId + "&readonly=<%=!canEdit%>");
}

reloadMaskEdit(document.getElementById("prodFamily.CategoryId").value);
$("#prodFamily\\.CategoryId").change(function() {
  reloadMaskEdit(this.value);
});

function refreshNameExt() {
  $("#prodFamily\\.ProductFamilyNameExt").attr("placeholder", $("#prodFamily\\.ProductFamilyName").val());
}

function doSave() {
  checkRequired("#prodfamily-form", function() {
    doSaveProductFamily();
  });
}

function doSaveProductFamily() {
  var metaDataList = prepareMetaDataArray("#prodfamily-form");
  if (!(metaDataList)) 
    showIconMessage("warning", <v:itl key="@Common.CheckRequiredFields" encode="JS"/>);
  else {
    var targetItemId = $("#prodFamily\\.TargetProductFamilyId").val();
    if (targetItemId == "<%=pageBase.getId()%>")
      showMessage(<v:itl key="@Product.ProductFamilySelfReferenceError" encode="JS"/>); 
    else {
      var reqDO = {
        Command: "SaveProductFamily",
        SaveProductFamily: {
          ProductFamily: {
            ProductFamilyId: $("#prodFamily\\.ProductFamilyId").val(),
            CategoryId: $("#prodFamily\\.CategoryId").val(),
            ProductFamilyStatus: $("#prodFamily\\.ProductFamilyStatus").val(),
            ProductFamilyCode: $("#prodFamily\\.ProductFamilyCode").val(),
            ProductFamilyName: $("#prodFamily\\.ProductFamilyName").val(),
            ProductFamilyNameExt: $("#prodFamily\\.ProductFamilyNameExt").val(),
            ProfilePictureId: $("#prodFamily\\.ProfilePictureId").val(),
            ShowNameExt: $("[name='prodFamily\\.ShowNameExt']").isChecked(),
            TargetProductFamilyId: targetItemId,
            ParentEntityType: $("#prodFamily\\.ParentEntityType").val(),  
            ParentEntityId: $("#prodFamily\\.ParentEntityId").val(),
            TagIDs: $("#prodFamily\\.TagIDs").val(),
            BackgroundColor: $("[name='prodFamily\\.BackgroundColor']").val(),
            ForegroundColor: $("[name='prodFamily\\.ForegroundColor']").val(),
            MetaDataList: metaDataList
          }
        }
      };
      
      showWaitGlass();
      vgsService("ProductFamily", reqDO, false, function(ansDO) {
        hideWaitGlass();
        entitySaveNotification(<%=LkSNEntityType.ProductFamily.getCode()%>, ansDO.Answer.SaveProductFamily.ProductFamilyId);
      });  
    }
  }
}
</script>