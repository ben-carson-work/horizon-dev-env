<%@page import="com.vgs.web.library.BLBO_Attribute"%>
<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
String productId = pageBase.getNullParameter("ProductId");
String optionSetId = pageBase.getNullParameter("OptionSetId");
if (JvString.isSameString("null", optionSetId))
  optionSetId = null;

JvDataSet ds = pageBase.getBL(BLBO_Attribute.class).getPackageEligibleProductAttributes(productId, optionSetId);
%>

<style>
  .prodpkg-attribute {
    margin-top: 10px;
    font-weight: bold;
  }

</style>

<v:dialog id="product-package-options-dialog" width="500" height="500" title="@Common.Options">
  <v:widget caption="@Product.Attributes">
    <v:widget-block>
        <% String lastAttributeId = null; %>
	      <v:ds-loop dataset="<%=ds%>">
	        <% if (!ds.getField("AttributeId").isSameString(lastAttributeId)) { %>
	        <%   lastAttributeId = ds.getField("AttributeId").getString(); %>
	          </select>
	          <div class="prodpkg-attribute"><%=ds.getField("AttributeName").getHtmlString()%></div>
            <select id="" class="form-control">
            <option value=""><v:itl key="@Common.None"/></option>
          <% } %>
	      
		        <% 
		        String caption = ds.getField("AttributeItemName").getHtmlString();
		        String selected = ds.getField("Checked").getBoolean() ? "selected" : "";
		        if (!ds.getField("OptionalPrice").isNull())
		          caption += "&nbsp;(" + pageBase.formatCurrHtml(ds.getField("OptionalPrice")) + ")";
		        %>
		        <option class="link-option" value="<%=ds.getField("AttributeItemId").getHtmlString()%>" <%=selected%>><%=caption%></option>
	      </v:ds-loop>
	      </select>
    </v:widget-block>
  </v:widget>
  
<script>  
$(document).ready(function() {
	
	var dlg = $("#product-package-options-dialog");
	dlg.on("snapp-dialog", function(event, params) {
	  params.buttons = {
	    Save : {
	      text: itl("@Common.Save"),
	      click: _saveProductPackageAttributes
	    },
	    Cancel : {
	      text: itl("@Common.Close"),
	      click: doCloseDialog
	    }
	  };
	});
	
	function _updateProductLine(options) {
		var $tr = $('tr[data-productid="<%=productId%>"]');
		var packageProduct = JSON.parse($tr.attr("data-product"));
	  packageProduct.OptionSetId = options.OptionSetId;
	  packageProduct.OptionSetDesc = options.OptionSetDesc;
	  $tr.attr("data-product", JSON.stringify(packageProduct));
	  $tr.find(".optionset-desc").html(packageProduct.OptionSetDesc);
	  $tr.find(".optionset-edit").attr("href", "javascript:asyncDialogEasy('product/product_package_options_dialog', 'ProductId=" + packageProduct.ProductId + "&OptionSetId=" + packageProduct.OptionSetId + "')");
	}

	function _saveProductPackageAttributes() {
		var reqDO = {
	      Command: "GetOrCreateOptionSet",
	      GetOrCreateOptionSet: {
	        AttributeItemIDs: $(".link-option:selected").map(function () {return this.value;}).get().join(",")
	      }
	    };
		
	  vgsService("Product", reqDO, false, function(ansDO) {
		  _updateProductLine(ansDO.Answer.GetOrCreateOptionSet);
		  $("#product-package-options-dialog").dialog("close");
	    
		  
	  });
	}
});
</script>
  
</v:dialog>

