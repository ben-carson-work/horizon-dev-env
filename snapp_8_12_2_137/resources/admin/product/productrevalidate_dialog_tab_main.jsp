<%@page import="com.vgs.web.library.BLBO_Product"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="product" class="com.vgs.snapp.dataobject.DOProduct" scope="request"/>

<% boolean canEdit = !pageBase.getParameter("ReadOnly").equals("true");%>

<div class="tab-content">
  <v:alert-box type="info" title="@Common.Info"><v:itl key="@Product.RevalidationHints"/></v:alert-box>
  <v:widget caption="@Common.General">
    <v:widget-block id="details-Main">
      <v:db-checkbox field="product.Revalidable" caption="@Product.Revalidable" value="true" enabled="<%=canEdit%>"/><br/>
    </v:widget-block>
  </v:widget>
  
  <v:widget id="revalidate-options" caption="@Common.Options">
    <v:widget-block id="details-Inherit" clazz="v-hidden">
      <v:form-field caption="@Lookup.ProductType.Fee" mandatory="false" hint="@Product.FeeProductIdHint">
	    <% JvDataSet dsFee = pageBase.getBL(BLBO_Product.class).getFeeLookupDS(product.ProductRevalidate.FeeProductId.getString()); %>
        <v:combobox field="productRevalidate.FeeProductId" lookupDataSet="<%=dsFee%>" idFieldName="ProductId" captionFieldName="ProductName" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Product.ExtensionDays" hint="@Product.ExtensionDaysHint">
        <v:input-text field="productRevalidate.ExtensionDays" placeholder="" enabled="<%=canEdit%>" />
      </v:form-field>
      <v:form-field caption="@Product.RevalidationStartDays" hint="@Product.RevalidationStartDaysHint">
        <v:input-text field="productRevalidate.WindowStartDays" placeholder="@Common.Always" enabled="<%=canEdit%>" />
      </v:form-field>
      <v:form-field caption="@Product.RevalidationEndDays" hint="@Product.RevalidationEndDaysHint">
        <v:input-text field="productRevalidate.WindowEndDays" placeholder="@Common.Always" enabled="<%=canEdit%>" />
      </v:form-field>
    </v:widget-block>
  </v:widget>
</div>

<script>

$(document).ready(function() {
  var $dlg = $("#productrevalidate_dialog");
  initFields();
});

function initFields() {
	console.log(product);
  $("#product\\.Revalidable").attr("checked", ((product.ProductRevalidate || {}).ExtensionDays != null));
  var reVal = $("#product\\.Revalidable").isChecked();                     
  $("#revalidate-options").setClass("v-hidden", !reVal );
  $("#details-Inherit").setClass("v-hidden", !reVal);  
}

$("[name='product.Revalidable']").change(initFields);
	
</script>