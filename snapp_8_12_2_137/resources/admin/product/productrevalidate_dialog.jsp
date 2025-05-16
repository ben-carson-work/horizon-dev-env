<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.service.*"%>
<%@taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
boolean canEdit = !pageBase.getParameter("ReadOnly").equals("true");
DOProduct product = SrvBO_OC.getProduct(pageBase.getConnector(), pageBase.getId(), true).Product;
DOProduct.DOProductRevalidate productRevalidate = product.ProductRevalidate;
request.setAttribute("product", product);
request.setAttribute("productRevalidate", productRevalidate);
%>

<v:dialog id="productrevalidate_dialog" tabsView="true" title="@Product.Revalidation" width="800" height="650" autofocus="false">
  <v:tab-group name="tab" main="true">
    <v:tab-item-embedded tab="tabs-main" caption="@Common.Profile" default="true">
      <jsp:include page="productrevalidate_dialog_tab_main.jsp"/>
    </v:tab-item-embedded>
  </v:tab-group>
</v:dialog>

<script>

var product = <%=product.getJSONString()%>;
$(document).ready(function() {
  var dlg = $("#productrevalidate_dialog");
  dlg.dialog({
    modal: true,
    close: function() {
      dlg.remove();
    },
    buttons: {
      Save: {
        text: itl("@Common.Save"),
        click: doSaveProductRevalidate,
        disabled: <%=!canEdit%>
      },
      Cancel : {
        text: itl("@Common.Cancel"),
        click: doCloseDialog
      }
    }
  });
});

function isPositiveNumber(value) {
  return (/^\+?[1-9][\d]*$/.test(value) && $.isNumeric(value));
}

function showErrorMessage(element, fieldName, value) {
  var msg = itl("@Common.InvalidValue");
  showMessage(msg + " " + value + " : "+ fieldName, function focusText() {
  element.focus();
  element.select();
  });
}

function doSaveProductRevalidate() {
  var extDays = ""; 
  if($("#product\\.Revalidable").isChecked()){
    extDays = $("#productRevalidate\\.ExtensionDays").val();
    var startDays = $("#productRevalidate\\.WindowStartDays").val();
    var endDays = $("#productRevalidate\\.WindowEndDays").val();
    if (!isPositiveNumber(extDays)) {
      showErrorMessage($("#productRevalidate\\.ExtensionDays"), itl("@Product.ExtensionDays"), $("#productRevalidate\\.ExtensionDays").val());
      return;
    }
    if (startDays!="" && isNaN(parseInt(startDays))) {
      showErrorMessage($("#productRevalidate\\.WindowStartDays"), itl("@Product.RevalidationStartDays"), $("#productRevalidate\\.WindowStartDays").val());
      return;
    } 
    if (endDays!="" && isNaN(parseInt(endDays))) {
      showErrorMessage($("#productRevalidate\\.WindowEndDays"), itl("@Product.RevalidationEndDays"), $("#productRevalidate\\.WindowEndDays").val());
      return;
    }
    if (parseInt(startDays) > parseInt(endDays)){
      showErrorMessage(itl("@Product.RevalidationStartEndDaysErrorMessage"));
      return;
    }
  }
  
  var reqDO = {
    Command: "SaveProduct",
    SaveProduct: {
      Product: {
        ProductId: <%=JvString.jsString(pageBase.getId())%>,
        ProductRevalidate: {
          FeeProductId: $("#productRevalidate\\.FeeProductId").val(),
          ExtensionDays: extDays,
          WindowStartDays: $("#productRevalidate\\.WindowStartDays").val(),
          WindowEndDays: $("#productRevalidate\\.WindowEndDays").val()
        }
      }
    }
  }
  var dlg = $("#productrevalidate_dialog");
  
  vgsService("Product", reqDO, false, function(ansDO) {
    dlg.dialog("close");
  });
};


</script>