<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSaleChannel" scope="request"/>
<jsp:useBean id="saleChannel" class="com.vgs.snapp.dataobject.DOSaleChannel" scope="request"/>

<v:input-text type="hidden" field="saleChannel.SaleChannelId"/>

<v:tab-toolbar>
  <v:button id="btn-salechannel-save" fa="save" caption="@Common.Save"/>
  <v:button id="btn-salechannel-export" caption="@Common.Export" fa="sign-out" include="<%=!pageBase.isNewItem()%>"/>
</v:tab-toolbar>

<v:tab-content id="salechannel-settings">  
  <v:input-text type="hidden" clazz="salechannel-field" field="saleChannel.SaleChannelId"/>
  
  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="@Common.Code" mandatory="true">
        <v:input-text clazz="salechannel-field" field="saleChannel.SaleChannelCode"/>
      </v:form-field>
      <v:form-field caption="@Common.Name" mandatory="true">
        <v:input-text clazz="salechannel-field" field="saleChannel.SaleChannelName"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="@Common.Validity">
        <v:input-text type="datepicker" clazz="salechannel-field" field="saleChannel.ValidFrom" placeholder="@Common.Unlimited"/>
        &nbsp;<v:itl key="@Common.To" transform="lowercase"/>&nbsp; 
        <v:input-text type="datepicker" clazz="salechannel-field" field="saleChannel.ValidTo" placeholder="@Common.Unlimited"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="@SaleChannel.OutstandingSaleChannel" hint="@SaleChannel.OutstandingSaleChannelHint">
        <% JvDataSet dsSaleChannel = pageBase.getBL(BLBO_SaleChannel.class).getSaleChannelLookupDS(pageBase.isNewItem() ? null : pageBase.getId()); %>
        <v:combobox clazz="salechannel-field" field="saleChannel.OutstandingSaleChannelId" lookupDataSet="<%=dsSaleChannel%>" idFieldName="SaleChannelId" captionFieldName="SaleChannelName"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="@SaleChannel.Distribution" clazz="form-field-optionset">
        <v:lk-radio field="saleChannel.SaleChannelType" lookup="<%=LkSN.SaleChannelType%>" clazz="salechannel-field" allowNull="false" inline="true"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="@Common.Options" clazz="form-field-optionset">      
        <div><v:db-checkbox clazz="salechannel-field" field="saleChannel.RestrictOpenOrder" caption="@Common.RestrictOpenOrder" hint="@Common.RestrictOpenOrderHint" value="true"/></div>
        <div><v:db-checkbox clazz="salechannel-field" field="saleChannel.Upgradable" caption="@SaleChannel.Upgradable" hint="@SaleChannel.UpgradableHint" value="true"/></div>
        <div><v:db-checkbox clazz="salechannel-field" field="saleChannel.Downgradable" caption="@SaleChannel.Downgradable" hint="@SaleChannel.DowngradableHint" value="true"/></div>
        <div><v:db-checkbox clazz="salechannel-field" field="saleChannel.UpgradeFromFacePrice" caption="@SaleChannel.UpgradeFromFacePrice" hint="@SaleChannel.UpgradeFromFacePriceHint" value="true"/></div>
        <div><v:db-checkbox clazz="salechannel-field" field="saleChannel.Refundable" caption="@SaleChannel.Refundable" hint="@SaleChannel.RefundableHint" value="true"/></div>
      </v:form-field>
    </v:widget-block>
  </v:widget>
  
  <v:widget caption="@Product.PriceRule">
    <v:widget-block id="PriceValueType-widget">
      <v:form-field caption="@SaleChannel.Variance" hint="@SaleChannel.VarianceHint">
        <v:input-text field="saleChannel.PriceValue" clazz="salechannel-field" placeholder="@Common.Value"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>

  <v:grid id="pricegroup-grid">
    <thead>
      <v:grid-title caption="@Product.PriceGroups" hint="@SaleChannel.PriceGroupsHint"/>
      <tr>
        <td width="25px"><v:grid-checkbox header="true"/></td>
        <td width="50%"><v:itl key="@Product.PriceGroup"/></td>
        <td width="50%"><v:itl key="@SaleChannel.Variance"/><v:hint-handle hint="@SaleChannel.VarianceHint"/></td>
      </tr>
    </thead>
    <tbody id="pricegroup-tbody"> 
    </tbody>
    <tbody> 
      <tr>
        <td colspan="100%">
          <v:button id="btn-pricegroup-add" fa="plus" caption="@Common.Add"/>
          <v:button id="btn-pricegroup-del" fa="minus" caption="@Common.Remove"/>
        </td>
    </tbody>
  </v:grid>
 
  <div id="pricegroup-templates" class="hidden">
    <table>
      <tr class="grid-row pricegroup-row">
        <td><v:grid-checkbox/></td>
        <td><snp:dyncombo name="PriceGroupTagId" clazz="pricegroup-field" entityType="<%=LkSNEntityType.PriceGroup%>"  enabled="<%=true%>"/></td>
        <td><v:input-text clazz="pricegroup-field" field="PriceValue"/></td>
      </tr>
    </table>
  </div>
</v:tab-content>

<script>

$(document).ready(function() {
  var saleChannelId = <%=saleChannel.SaleChannelId.getJsString()%>;
  var doc = <%=saleChannel.getJSONString()%>;
  var $settings = $("#salechannel-settings");
  var $tbody = $("#pricegroup-tbody");
  var $template = $("#pricegroup-templates .pricegroup-row");
  
  $("#btn-salechannel-save").click(_save);
  $("#btn-salechannel-export").click(_export);
  
  $("#saleChannel\\.PriceValue").val(encodePriceVariance(doc.PriceActionType, doc.PriceValueType, doc.PriceValue));
  for (const item of doc.PriceGroupList || [])
    item.PriceValue = encodePriceVariance(item.PriceActionType, item.PriceValueType, item.PriceValue);
  
  $tbody.docToGrid({
    "doc": doc.PriceGroupList,
    "template": $template,
    "addButtonHandler": $("#btn-pricegroup-add"),
    "delButtonHandler": $("#btn-pricegroup-del")
  });
  
  function _save() {
    checkRequired("#salechannel-form", function () {
      var doc = $settings.find(".salechannel-field").viewToDoc();
      
      _assignDecodedPrice(doc);
      doc.PriceGroupList = $tbody.find("tr").gridToDoc({"fieldSelector": ".pricegroup-field"});
      doc.PriceGroupList.forEach(_assignDecodedPrice);
      
      snpAPI.cmd("SaleChannel", "SaveSaleChannel", {SaleChannel: doc})
      .then(ansDO => entitySaveNotification(<%=LkSNEntityType.SaleChannel.getCode()%>, ansDO.SaleChannelId));
    });
  }
  
  function _assignDecodedPrice(item) {
    let decodedPrice = decodePriceVariance(item.PriceValue);
    item.PriceActionType = decodedPrice.PriceActionType; 
    item.PriceValueType = decodedPrice.PriceValueType;
    item.PriceValue = decodedPrice.PriceValue;
  }

  function _export() {
    var urlo = BASE_URL + "/admin?page=export&EntityIDs=" + saleChannelId + "&EntityType=" + <%=LkSNEntityType.SaleChannel.getCode()%> + "&ts=" + (new Date()).getTime();
    window.open(urlo, "_black");
  }
}); 
</script>
