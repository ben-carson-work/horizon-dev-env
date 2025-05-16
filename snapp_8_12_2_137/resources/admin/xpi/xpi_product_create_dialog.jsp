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
  QueryDef qdef = new QueryDef(QryBO_AccountCrossPlatform.class)
      .addFilter(QryBO_AccountCrossPlatform.Fil.CrossPlatformStatus, LkSNCrossPlatformStatus.Enabled.getCode())
      .addSelect(
          QryBO_AccountCrossPlatform.Sel.IconName,
          QryBO_AccountCrossPlatform.Sel.CommonStatus,
          QryBO_AccountCrossPlatform.Sel.CrossPlatformId,
          QryBO_AccountCrossPlatform.Sel.CrossPlatformType,
          QryBO_AccountCrossPlatform.Sel.CrossPlatformTypeDesc,
          QryBO_AccountCrossPlatform.Sel.CrossPlatformStatus,
          QryBO_AccountCrossPlatform.Sel.CrossPlatformURL,
          QryBO_AccountCrossPlatform.Sel.CrossPlatformName,
          QryBO_AccountCrossPlatform.Sel.CrossPlatformRef);
  JvDataSet dsCrossPlatform = pageBase.execQuery(qdef);
%>


<v:dialog id="xpi-prodcrosssell-create-dialog" width="550" height="350" title="@XPI.CrossProduct">
  <v:form-field caption="@XPI.CrossPlatformName" mandatory="true">
    <select name="productCrossSell.CrossPlatformId" id="productCrossSell.CrossPlatformId" class="form-control">
      <option></option>
      <v:ds-loop dataset="<%=dsCrossPlatform%>">
        <option value="<%=dsCrossPlatform.getField("CrossPlatformId").getString()%>" data-Desc="<%=dsCrossPlatform.getField("CrossPlatformTypeDesc").getString()%>" data-Ref="<%=dsCrossPlatform.getField("CrossPlatformRef").getString()%>" data-URL="<%=dsCrossPlatform.getField("CrossPlatformURL").getString()%>" data-Type="<%=dsCrossPlatform.getField("CrossPlatformType").getInt()%>" ><%=dsCrossPlatform.getField("CrossPlatformName").getHtmlString()%></option>
      </v:ds-loop>
    </select>
  </v:form-field>
  
  <v:form-field id="xpi-crossproductid" caption="@XPI.CrossProductId" clazz="v-hidden" mandatory="true">
    <v:input-text type="text" field="productCrossSell.CrossProductId"/>
  </v:form-field>
  <%-- SNAPP PRODUCT --%>
  <v:form-field id="snapp-prod" caption="@XPI.CrossProductName" clazz="v-hidden">   
    <select id="productCrossSell.CrossProductNameSnapp" class="form-control"></select>
  </v:form-field>
  <%-- ** --%>
  <%-- GENERIC PRODUCT --%>
  <v:form-field id="generic-prod" caption="@XPI.CrossProductName" clazz="v-hidden" mandatory="true"> 
    <v:input-text type="text" field="productCrossSell.CrossProductNameGeneric"/>
  </v:form-field>
  <%-- ** --%>
  <v:form-field caption="@XPI.CrossProductCode">
    <v:input-text type="text" field="productCrossSell.CrossProductCode"/>
  </v:form-field>
  <v:form-field caption="@Product.Price" mandatory="true">
    <v:input-text type="text" field="productCrossSell.Price"/>
  </v:form-field>
  
  
<script>
var dlg = $("#xpi-prodcrosssell-create-dialog");
dlg.on("snapp-dialog", function(event, params) {
  params.buttons = {
    <v:itl key="@Common.Ok" encode="JS"/>: doSelectProductCrossSell,
    <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
  };
});

dlg.keypress(function() {
  if (event.keyCode == KEY_ENTER)
    doSelectProductCrossSell();
});

$("#productCrossSell\\.CrossPlatformId").change(doRefreshUI);
$("#productCrossSell\\.CrossProductNameSnapp").change(refreshSnappProductUI);

function populateProductSelection(ansDO) {
  var select = $("#productCrossSell\\.CrossProductNameSnapp");
  $(select).empty();
  for (i=0; i<ansDO.Answer.GetSharedProducts.SharedProductList.length; i++) {
    if (i > 0)
      selected = "";
    var item = ansDO.Answer.GetSharedProducts.SharedProductList[i];
    select.append("<option value='" + item.EntityId + "' data-Code='" + item.EntityCode + "' data-Price='" + item.EntityPrice + "'>" + item.EntityName + "</option>")
  }
  refreshSnappProductUI();
}

function refreshSnappProductUI() {
  var optionSelected = $("#productCrossSell\\.CrossProductNameSnapp").find('option:selected');
  $("#productCrossSell\\.CrossProductId").val(optionSelected.val());
  $("#productCrossSell\\.CrossProductCode").val(optionSelected.attr("data-Code"));
  $("#productCrossSell\\.Price").val(optionSelected.attr("data-Price"));
}

function doRefreshUI() {
  const optionSelected = $("#productCrossSell\\.CrossPlatformId").find('option:selected');
  const crossPlatformSnApp = <%=LkSNCrossPlatformType.SnApp.getCode()%>;
  const crossPlatformType = optionSelected.attr("data-Type");
  
  $("#productCrossSell\\.CrossProductId").val("");
  $("#productCrossSell\\.CrossProductCode").val("");
  $("#productCrossSell\\.CrossProductNameGeneric").val("");
  $("#productCrossSell\\.CrossProductNameSnapp").val("");
  $("#productCrossSell\\.Price").val("");
  
  $("#snapp-prod").setClass("v-hidden", crossPlatformSnApp != crossPlatformType);
  $("#xpi-crossproductid").setClass("v-hidden", crossPlatformSnApp == crossPlatformType);
  $("#generic-prod").setClass("v-hidden", crossPlatformSnApp == crossPlatformType);
  
  if (crossPlatformSnApp == crossPlatformType) {
    $("#productCrossSell\\.CrossProductCode").attr("readonly", "readonly");
    $("#productCrossSell\\.Price").attr("readonly", "readonly");
    
    showWaitGlass();
    var reqDO = {
      Command: "GetSharedProducts",
      GetSharedProducts: {
        CrossPlatformId: optionSelected.val()
      }
    };
      
    vgsService("Product", reqDO, false, function(ansDO) {
      hideWaitGlass();
      if (ansDO.Answer && (ansDO.Answer.GetSharedProducts.SharedProductList.length > 0))
        populateProductSelection(ansDO);
      else 
        showMessage(itl("@XPI.CrossProductListEmpty"));
    });
    
  }
  else {
    $("#productCrossSell\\.CrossProductCode").removeAttr("readonly");
    $("#productCrossSell\\.Price").removeAttr("readonly");
  }
}

function doSelectProductCrossSell() {
  var optionSelected = $("#productCrossSell\\.CrossPlatformId").find('option:selected');
  var crossPlatformSnApp = <%=LkSNCrossPlatformType.SnApp.getCode()%>;
  var crossPlatformType = optionSelected.attr("data-Type");
  
  <%-- This if avoid the "checkRequired" error in case of SnApp products --%>
  if (crossPlatformSnApp == crossPlatformType) 
    $("#productCrossSell\\.CrossProductNameGeneric").val($("#productCrossSell\\.CrossProductNameSnapp").find('option:selected').text());
  
  checkRequired("#xpi-prodcrosssell-create-dialog", function() {
    var optionSelected = $("#productCrossSell\\.CrossPlatformId").find('option:selected');
    var crossPlatformSnApp = <%=LkSNCrossPlatformType.SnApp.getCode()%>;
    var crossPlatformType = optionSelected.attr("data-Type");
    var crossPlatformTypeDesc = optionSelected.attr("data-Desc");
    var crossProductName = ""; 
    
    if (crossPlatformSnApp == crossPlatformType) 
      crossProductName = $("#productCrossSell\\.CrossProductNameSnapp").find('option:selected').text();
    else 
      crossProductName = $("#productCrossSell\\.CrossProductNameGeneric").val();
    
    var price = encodeValue($("#productCrossSell\\.Price").val());
    if (!price)
      showMessage(<v:itl key="@XPI.PriceNotValid" encode="JS"/>);
    else {
      var obj = {
              ProductId: <%=JvString.jsString(pageBase.getId())%>,
              CrossPlatformId: $("#productCrossSell\\.CrossPlatformId").val(),
              CrossPlatformName: optionSelected.text(),
              CrossPlatformType: crossPlatformType,
              CrossPlatformTypeDesc: crossPlatformTypeDesc,
              CrossProductId: $("#productCrossSell\\.CrossProductId").val(),
              CrossProductCode: $("#productCrossSell\\.CrossProductCode").val(),
              CrossProductName: crossProductName,
              CrossProductStatus: <%=LkSNCrossProductStatus.Enabled.getCode()%>,
              CrossProductStatusDesc: <%=JvString.jsString(LkSNCrossProductStatus.Enabled.getHtmlDescription())%>,
              Price: price
        };
      productCrossSellPickupCallback(obj);
      dlg.dialog("close");
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

$(document).ready(function() {
  doRefreshUI();
});

</script>

</v:dialog>