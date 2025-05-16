<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
  String productId = pageBase.getId();
  String crossPlatformId = pageBase.getNullParameter("CrossPlatformId");
  String crossProductId = pageBase.getNullParameter("CrossProductId");
  
  QueryDef qdef = new QueryDef(QryBO_ProductCrossSell.class);
  // Select
  qdef.addSelect(QryBO_ProductCrossSell.Sel.CrossProductId);
  qdef.addSelect(QryBO_ProductCrossSell.Sel.CrossPlatformName);
  qdef.addSelect(QryBO_ProductCrossSell.Sel.CrossProductName);
  qdef.addSelect(QryBO_ProductCrossSell.Sel.CrossProductCode);
  qdef.addSelect(QryBO_ProductCrossSell.Sel.CrossProductStatus);
  qdef.addSelect(QryBO_ProductCrossSell.Sel.Price);
  // Filter
  qdef.addFilter(QryBO_ProductCrossSell.Fil.ProductId, productId);
  qdef.addFilter(QryBO_ProductCrossSell.Fil.CrossPlatformId, crossPlatformId);
  qdef.addFilter(QryBO_ProductCrossSell.Fil.CrossProductId, crossProductId);
  
  JvDataSet ds = pageBase.execQuery(qdef);

  request.setAttribute("ds", ds);
%>


<v:dialog id="xpi-prodcrosssell-dialog" width="550" height="300" title="<%=ds.getField(QryBO_ProductCrossSell.Sel.CrossPlatformName).getHtmlString()%>">
  <v:form-field caption="@XPI.CrossProductId" mandatory="true"> 
    <input type="text" id="crossProductId" class="form-control" value="<%=ds.getField(QryBO_ProductCrossSell.Sel.CrossProductId).getHtmlString()%>" readonly="readonly">
  </v:form-field>
  <v:form-field caption="@XPI.CrossProductName" mandatory="true"> 
    <input type="text" id="crossProductName" class="form-control" value="<%=ds.getField(QryBO_ProductCrossSell.Sel.CrossProductName).getHtmlString()%>" autofocus>
  </v:form-field>
  <v:form-field caption="@XPI.CrossProductCode">
    <input type="text" id="crossProductCode" class="form-control" value="<%=ds.getField(QryBO_ProductCrossSell.Sel.CrossProductCode).getHtmlString()%>">
  </v:form-field>
  <v:form-field caption="@Product.Price" mandatory="true">
    <input type="text" id="price" class="form-control" value="<%=ds.getField(QryBO_ProductCrossSell.Sel.Price).getHtmlString()%>">
  </v:form-field>
  
<script>
var dlg = $("#xpi-prodcrosssell-dialog");
dlg.on("snapp-dialog", function(event, params) {
  params.buttons = {
    <v:itl key="@Common.Save" encode="JS"/>: doSave,
    <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
  };
});

dlg.keypress(function() {
  if (event.keyCode == KEY_ENTER)
    doSave();
});


function doSave(ansDO) {
  checkRequired("#xpi-prodcrosssell-dialog", function() {
    var price = encodeValue($("#price").val());
    if (!price)
      showMessage(<v:itl key="@XPI.PriceNotValid" encode="JS"/>);
    else {
    	showWaitGlass();
      var reqDO = {
          Command: "UpdateXPIProductCrossSell",
          UpdateXPIProductCrossSell: {
            ProductCrossSell: {
              ProductId: <%=JvString.jsString(productId)%>,
              CrossPlatformId: <%=JvString.jsString(crossPlatformId)%>,
              CrossProductId: <%=JvString.jsString(crossProductId)%>,
              CrossProductName: $("#crossProductName").val(),
              CrossProductCode: $("#crossProductCode").val(),
              Price: price
            }
          }
      };
      vgsService("Product", reqDO, false, function(ansDO) {
    	  hideWaitGlass();
        triggerEntityChange(<%=LkSNEntityType.ProductType.getCode()%>, <%=JvString.jsString(productId)%>);
        dlg.dialog("close");
        window.location.reload();
      });
    }
  });
}

function encodeValue(price) {
  var value = price;
  value = value.replace("%", "");
  value = value.replace(",", ".");
  value = parseFloat(value);
  return isNaN(value) ? null : value;
}

</script>

</v:dialog>