<%@page import="com.vgs.web.library.product.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="org.apache.poi.util.*"%>
<%@page import="com.vgs.snapp.dataobject.DOProduct.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProduct" scope="request"/>
<jsp:useBean id="product" class="com.vgs.snapp.dataobject.DOProduct" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="rightCRUD" class="com.vgs.snapp.library.FtCRUD" scope="request"/>

<% 
boolean canEdit = rightCRUD.canUpdate(); 
BLBO_DocTemplate blDocTemplate = pageBase.getBL(BLBO_DocTemplate.class);
%>
    
<%! 
private String getSelectedDocTemplateIDs(FtList<DOProductDocTemplate> list) { 
  String[] result = new String[0];
  for (DOProductDocTemplate item : list)
    result = JvArray.add(item.DocTemplateId.getString(), result);
  return JvArray.arrayToString(result, ",");
} 
%>

<v:widget caption="@Common.Media" include="<%=!product.ProductType.isLookup(LkSNProductType.System, LkSNProductType.Material, LkSNProductType.Presale)%>">

  <v:widget-block>
    <v:form-field caption="@DocTemplate.POS_Template" checkBoxField="product.POS_AllowPrint">
      <v:multibox field="product.POS_DocTemplateIDs" value="<%=getSelectedDocTemplateIDs(product.POS_DocTemplateList)%>" lookupDataSet="<%=blDocTemplate.getDocTemplateDS(LkSNDocTemplateType.Media)%>" idFieldName="DocTemplateId" captionFieldName="DocTemplateName" linkEntityType="<%=LkSNEntityType.DocTemplate%>" enabled="<%=canEdit%>"/>
    </v:form-field>
    <v:form-field caption="@DocTemplate.CLC_Template" checkBoxField="product.CLC_AllowPrint">
      <snp:dyncombo field="product.CLC_DocTemplateId" entityType="<%=LkSNEntityType.DocTemplate%>" filtersJSON="{\"DocTemplate\":{\"DocTemplateType\":1}}" enabled="<%=canEdit%>"/>
    </v:form-field>
    <v:form-field caption="@DocTemplate.B2B_Template" checkBoxField="product.B2B_AllowPrint">
      <snp:dyncombo field="product.B2B_DocTemplateId" entityType="<%=LkSNEntityType.DocTemplate%>" filtersJSON="{\"DocTemplate\":{\"DocTemplateType\":1}}" enabled="<%=canEdit%>"/>
    </v:form-field>
    <v:form-field caption="@DocTemplate.B2C_Template" checkBoxField="product.B2C_AllowPrint">
      <snp:dyncombo field="product.B2C_DocTemplateId" entityType="<%=LkSNEntityType.DocTemplate%>" filtersJSON="{\"DocTemplate\":{\"DocTemplateType\":1}}" enabled="<%=canEdit%>"/>
    </v:form-field>
    <v:form-field caption="@DocTemplate.MOB_Template" checkBoxField="product.MOB_AllowPrint">
      <snp:dyncombo field="product.MOB_DocTemplateId" entityType="<%=LkSNEntityType.DocTemplate%>" filtersJSON="{\"DocTemplate\":{\"DocTemplateType\":1}}" enabled="<%=canEdit%>"/>
    </v:form-field>
    <v:form-field caption="@DocTemplate.MWLT_Template" checkBoxField="product.MWLT_AllowPrint">
      <snp:dyncombo field="product.MWLT_DocTemplateId" entityType="<%=LkSNEntityType.DocTemplate%>" filtersJSON="{\"DocTemplate\":{\"DocTemplateType\":1}}" enabled="<%=canEdit%>"/>
    </v:form-field>          
  </v:widget-block>

  <v:widget-block include="<%=!product.ProductType.isLookup(LkSNProductType.StaffCard)%>">
    <v:form-field caption="@Product.ExtMediaGroup" hint="@Product.ExtMediaGroupHint">
      <snp:dyncombo field="product.ExtMediaGroupId" entityType="<%=LkSNEntityType.ExtMediaGroup%>"/>
    </v:form-field>
    <v:form-field caption="@Product.GroupTicketOption" hint="@Product.GroupTicketOptionHint">
      <v:lk-combobox lookup="<%=LkSN.GroupTicketOption%>" field="product.GroupTicketOption" allowNull="false" enabled="<%=canEdit%>"/>
    </v:form-field>
  </v:widget-block>

  <v:widget-block include="<%=!product.ProductType.isLookup(LkSNProductType.StaffCard)%>">
    <v:form-field caption="@Product.MediaEncoderPlugin" hint="@Product.MediaEncoderPluginHint">
      <v:combobox field="product.MediaEncoderPluginId" lookupDataSet="<%=pageBase.getBL(BLBO_Plugin.class).getPluginDS(null, LkSNDriverType.MediaEncoder)%>" captionFieldName="PluginDisplayName" idFieldName="PluginId" linkEntityType="<%=LkSNEntityType.Plugin%>" enabled="<%=canEdit%>"/>
    </v:form-field>
    <v:form-field caption="@Product.MediaPrintCodeAliasType" hint="@Product.MediaPrintCodeAliasTypeHint">
      <snp:dyncombo field="product.MediaPrintCodeAliasTypeId" entityType="<%=LkSNEntityType.CodeAliasType%>" enabled="<%=canEdit%>"/>
    </v:form-field>
  </v:widget-block>      

  <jsp:include page="product_tab_main_media_constraints_widget.jsp"></jsp:include>

  <v:widget-block include="<%=!product.ProductType.isLookup(LkSNProductType.StaffCard)%>">
    <v:form-field caption="@Common.Options" clazz="form-field-optionset">
      <div><v:db-checkbox field="product.ForceMediaGeneration" caption="@Product.ForceMediaGeneration" hint="@Product.ForceMediaGenerationHint" value="true" enabled="<%=canEdit%>"/></div>
      <div><v:db-checkbox field="product.MediaExclusiveUse" caption="@Product.MediaExclusiveUse" hint="@Product.MediaExclusiveUseHint" value="true" enabled="<%=canEdit%>"/></div>
      <div><v:db-checkbox field="product.PahGenerateMedia" caption="@Product.PahGenerateMedia" hint="@Product.PahGenerateMediaHint" value="true" enabled="<%=canEdit%>"/></div>
      <div><v:db-checkbox field="product.MediaNotExisting" caption="@Product.MediaNotExisting" hint="@Product.MediaNotExistingHint" value="true" clazz="group-media-flag" enabled="<%=canEdit%>"/></div>
      <div><v:db-checkbox field="product.MediaAlreadyExisting" caption="@Product.MediaAlreadyExisting" hint="@Product.MediaAlreadyExistingHint" value="true" clazz="group-media-flag" enabled="<%=canEdit%>"/></div>
      <div><v:db-checkbox field="product.RequireOrganizeStep" caption="@Product.RequireOrganizeStep" hint="@Product.RequireOrganizeStepHint" value="true" enabled="<%=canEdit%>"/></div>
      <div><v:db-checkbox field="product.RequireMediaInputOnCLC" caption="@Product.RequireMediaInputOnCLC" hint="@Product.RequireMediaInputOnCLCHint" value="true" enabled="<%=canEdit%>"/></div>
    </v:form-field>
  </v:widget-block>

</v:widget>

<script>
$(document).ready(function() {
  var $groupedCheckBoxes = $(".group-media-flag");
  $groupedCheckBoxes.click(function() {
    if ($(this).isChecked()) 
      $groupedCheckBoxes.not(this).setChecked(false);
  });
});
</script>
