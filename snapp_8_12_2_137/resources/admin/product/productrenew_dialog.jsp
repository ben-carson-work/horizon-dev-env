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
request.setAttribute("product", product);
%>

<v:dialog id="productrenewal_dialog" tabsView="true" title="@Common.Renewal" width="800" height="650" autofocus="false">
  <v:tab-group name="tab" main="true">
    <v:tab-item-embedded tab="tabs-main" caption="@Common.Profile" default="true">
      <jsp:include page="productrenewal_dialog_tab_main.jsp"/>
    </v:tab-item-embedded>
  
    <v:tab-item-embedded tab="tabs-quickrenew" caption="@Product.SourceProducts">
      <jsp:include page="productrenewal_dialog_tab_renewal.jsp"/>
    </v:tab-item-embedded>
  </v:tab-group>
</v:dialog>

<script>

var product = <%=product.getJSONString()%>;
$(document).ready(function() {
  initRenewalProd();
	
  var dlg = $("#productrenewal_dialog");
  dlg.dialog({
    modal: true,
    close: function() {
      dlg.remove();
    },
    buttons: {
      Save: {
      	text: itl("@Common.Save"),
      	click: doSaveProductRenewal,
      	disabled: <%=!canEdit%>
      },
      Cancel : {
      	text: itl("@Common.Cancel"),
      	click: doCloseDialog
      }
    }
  });
});

function doSaveProductRenewal() {
  var startDate = $("#product\\.RenewalWindowStartDays").val();
  var endDate = $("#product\\.RenewalWindowEndDays").val();
  
  if (((startDate!= "") && isNaN(parseInt(startDate))) || ((endDate!= "") && isNaN(parseInt(endDate)))) {
    showMessage(itl("@Common.InvalidValue"));  
  } else {
    var reqDO = {
	    Command: "SaveProduct",
	    SaveProduct: {
	      Product: {
	        ProductId: <%=JvString.jsString(pageBase.getId())%>,
	        RenewalWindowStartDays: startDate,
	        RenewalWindowEndDays: endDate,
            RenewableFromAny: $("#product\\.RenewableFromAny").isChecked(),
            RenewableToAny: $("#product\\.RenewableToAny").isChecked(),
	        ProductRenewalList: getProductList()
	      }
	    }
	  };
	  
	  var dlg = $("#productrenewal_dialog");
	  
	  vgsService("Product", reqDO, false, function(ansDO) {
	    dlg.dialog("close");
	  });
  }
}

</script>