<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pkg" class="com.vgs.snapp.dataobject.DOExtensionPackage" scope="request"/>

<div id="settings-dialog">
	<div id="product-templates" class="hidden">
	  <snp:dyncombo name="config-ProductId-template" entityType="<%=LkSNEntityType.ProductType%>"/>
	</div>
	
	<v:widget caption="iVenture Settings">
	  <v:widget-block>
	    <v:form-field caption="@Common.WebServicesURL" mandatory="true">
	      <v:input-text field="iventure-config-Url"/>
	    </v:form-field>
	    <v:form-field caption="Merchant ID" mandatory="true">
	      <v:input-text field="iventure-config-MerchantId"/>
	    </v:form-field>
			<v:form-field caption="Secret Key" mandatory="true">
	      <v:input-text type="password" field="iventure-config-SecretKey"/>
	    </v:form-field>
	    <v:form-field caption="Code prefix"  mandatory="true" hint="Prefix used to identify external iVenture ticket during redeem process">
	      <v:input-text field="iventure-config-MediaCodePrefix"/>
	    </v:form-field>
	    <v:form-field caption="Prod.Number field" hint="Field containing the iVenture product number" mandatory="true">
	      <snp:dyncombo id="iventure-config-MetaFieldId" entityType="<%=LkSNEntityType.MetaField%>"/>
	    </v:form-field>
			<v:form-field caption="Def. Access Product"  mandatory="true" hint="Product used for validation process of the iVenture media code if not match with iVenture skuId is found. This product must have entitlements to allow customer to access the site"> 
	      <snp:dyncombo id="iventure-config-default-ProductId" entityType="<%=LkSNEntityType.ProductType%>"/>
	    </v:form-field>
	    <v:form-field caption="Organization"  hint="Oragnization where iVenture redeemed product will be charged"> 
	      <snp:dyncombo id="iventure-config-OrganizationId" entityType="<%=LkSNEntityType.Organization%>"/>
	    </v:form-field>
	    <v:form-field caption="Code alias type"><!--  hint="Product used for validation process of the iVenture media code if not match with iVenture skuId is found. This product must have entitlements to allow customer to access the site"> --> 
	      <snp:dyncombo id="iventure-config-CodeAliasTypeId" entityType="<%=LkSNEntityType.CodeAliasType%>"/>
	    </v:form-field>
	  </v:widget-block>
	</v:widget>
	<v:widget caption="Access Products" hint="Products used for validation process of the iVenture media code. These products must have entitlements to allow customer to access the site">
		  <v:widget-block>
		    <v:grid id="product-grid">
		      <thead>
		       	<tr>
		        	<td><v:grid-checkbox header="true"/></td>
		          <td width="50%"><v:itl key="Product"/></td>
		          <td width="50%"><v:itl key="iVenture skuId"/></td>
		        </tr>
		      </thead>
		      <tbody id="product-body">
		      
		      </tbody>
		      <tbody>
		        <tr>
		          <td colspan="100%">
		          <% String href="javascript:addDetail(true)"; %>
		          <v:button caption="@Common.Add" fa="plus" href="<%=href%>"/>
		        	<v:button caption="@Common.Remove" fa="minus" href="javascript:removeDetail()"/>
		      	</td>
		    	</tr>
		  	</tbody>
			</v:grid>
		</v:widget-block>
	</v:widget>
</div>

<script>
$(document).ready(function() {
  var doc = <%=pkg.ConfigDoc.getString()%>;
  doc = (doc) ? doc : {};
  $("#iventure-config-Url").val(doc.Url);
  $("#iventure-config-MerchantId").val(doc.MerchantId);
  $("#iventure-config-SecretKey").val(doc.SecretKey);
  $("#iventure-config-MediaCodePrefix").val(doc.MediaCodePrefix);
  $("#iventure-config-default-ProductId").val(doc.DefaulAccessProductId);
  $("#iventure-config-MetaFieldId").val(doc.MetaFieldId);
  $("#iventure-config-CodeAliasTypeId").val(doc.CodeAliasTypeId);
  $("#iventure-config-OrganizationId").val(doc.OrganizationId);
	for (var i=0; i<doc.AccessProductList.length; i++) {
		addDetail(doc.AccessProductList[i].ProductId, doc.AccessProductList[i].SkuId); 
 	}
});

function removeDetail() {
  $("#settings-dialog .cblist:checked").not(".header").closest("tr").remove();
}  

function addDetail(productId, skuId) {
  var trs = $("#product-body tr");
  var id = trs.length + 1;
  
  var tr = $("<tr class='grid-row'/>").appendTo("#product-body");
  var tdCB = $("<td/>").appendTo(tr);  
  var tdCombo = $("<td/>").appendTo(tr);
  var tdSkuId = $("<td/>").appendTo(tr);
  
  tdCB.append("<input value='" + id + "' type='checkbox' class='cblist'>");
  var combo = $("#product-templates").clone().removeClass("hidden").appendTo(tdCombo);
  console.log(combo.find("[name='config-ProductId-template']"));
  combo.find("[name='config-ProductId-template']").val(productId);
  tdSkuId.append("<input type='text' class='form-control' name='skuId'/>");
  tdSkuId.find("input").val(skuId);
}

function getAccessProductList() {
  var list = [];
  var trs = $("#product-body tr");
  
  for (var i=0; i<trs.length; i++) {
	  var tr = $(trs[i]);
	  list.push({
		  ProductId: tr.find("[name='config-ProductId-template']").val(),
		  SkuId: tr.find("[name='skuId']").val()
	  });
	}
	
	return list;
}

function getExtensionPackageConfigDoc() {
  return {
    Url: $("#iventure-config-Url").val(),
    MerchantId: $("#iventure-config-MerchantId").val(),
    SecretKey: $("#iventure-config-SecretKey").val(),
    MediaCodePrefix: $("#iventure-config-MediaCodePrefix").val(),
    DefaulAccessProductId: $("#iventure-config-default-ProductId").val(),
    MetaFieldId: $("#iventure-config-MetaFieldId").val(),
    CodeAliasTypeId: $("#iventure-config-CodeAliasTypeId").val(),
    OrganizationId: $("#iventure-config-OrganizationId").val(),
    AccessProductList: getAccessProductList()
  };
}

</script>