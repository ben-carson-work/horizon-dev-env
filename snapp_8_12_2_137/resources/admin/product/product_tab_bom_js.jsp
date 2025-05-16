<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProduct" scope="request"/>
<jsp:useBean id="product" class="com.vgs.snapp.dataobject.DOProduct" scope="request"/>


<%
QueryDef qdef = new QueryDef(QryBO_MeasureProfile.class);
qdef.addSelect(QryBO_MeasureProfile.Sel.MeasureProfileId, QryBO_MeasureProfile.Sel.BaseMeasureId, QryBO_MeasureProfile.Sel.ConvertMeasureIDs);
JvDataSet ds = pageBase.execQuery(qdef);
%>

<script>

var mps = <%=ds.getDocJSON()%>;

$(document).ready(function() {
  $("#product_stock_dialog_tabs").tabs();
  
  var $groupItems = null;

  $("#bom-grid-body").sortable({
    handle: ".drag-handle",
    placeholder: "bom-placeholder",
    start: function(e, ui) {
      ui.placeholder.html("<td colspan='100%'><div class='bom-placeholder-item'><span class='alt-option'></span>&nbsp;</div></td>");
      ui.placeholder.find(".alt-option").text(<v:itl key="@Product.MaterialAlternativeOption" encode="JS"/>);
      ui.helper.width(600).css("opacity", "0.8");
      if (ui.item.hasClass("bom-group")) 
        $groupItems = getGroupItems(ui.item);
    },
    sort: function(e, ui) {
      var left = ui.position.left - ui.originalPosition.left;
      var $prev = ui.placeholder.prev();
      if (($prev.length > 0) && ($prev[0] == ui.item[0]))
        $prev = $prev.prev();
      var $next = ui.placeholder.next();
      if (($next.length > 0) && ($next[0] == ui.item[0]))
        $next = $next.next();
      ui.placeholder.setClass("indent", ui.item.hasClass("bom-row") && ($next.hasClass("indent") || ((left > 30) && ($prev.hasClass("bom-group") || $prev.hasClass("indent")))));
    },
    stop: function(e, ui) {
      ui.item.setClass("indent", ui.placeholder.hasClass("indent"));
      if (ui.item.hasClass("indent"))
        ui.item.find("[name='included']").setChecked(false);
      if (ui.item.hasClass("bom-group") && ($groupItems != null)) {
        $groupItems.remove();
        ui.item.after($groupItems);
      }
    }
  });
  
  $("#btn-del").click(function() {
    $("#bom-grid-body .cblist:checked").closest("tr").remove();
  });
  
  $("#btn-refreh-stock").click(function() {
    changeGridPage("#product-stock-grid", 1);
  });
  
  <% for (DOProduct.DOMaterial material : product.MaterialList) { %>
    addBomRow(<%=material.getJSONString()%>);
  <% } %>
});

function getGroupItems($group) {
  var result = [];
  var $next = $group.next();
  while (($next.length > 0) && ($next.hasClass("indent") || $next.hasClass("bom-placeholder"))) {
    if ($next.hasClass("bom-row"))
      result.push($next[0]);
    $next = $next.next();
  }
  return $(result);
}
  
function addBomRow(obj, indent) {
  obj = (obj) ? obj : {};
  obj.Included = (obj.Included == null) ? true : obj.Included;
  obj.Optional = (obj.Optional == null) ? !obj.Included : obj.Optional;
  var group = (obj.GroupItem === true);
  
  if (indent == "smart") {
    var $trLast = $("#bom-grid-body tr").last();
    if ($trLast.hasClass("indent") || $trLast.hasClass("bom-group"))
      indent = true;
  }
  
  var $tr = $("#templates ." + (group ? "bom-group" : "bom-row")).clone().appendTo($("#bom-grid-body"));
  $tr.setClass("indent", (indent === true));
  
  var $cbOpt = $tr.find("[name='optional']").setChecked(obj.Optional);
  var $cbInc = $tr.find("[name='included']").setChecked(obj.Included);
  
  if (group) 
    $tr.find("[name='group-name']").val(obj.GroupName);
  else {
    $tr.find("[name='quantity']").val((obj.Quantity) ? obj.Quantity : "1");

    var $cbMeasure = $tr.find("[name='measure-combo']");
    $cbMeasure.val(obj.MeasureId);
    $cbMeasure.trigger("change");
    
    var $cbMaterial = $tr.find("[name='material-combo']");
    $cbMaterial.val(obj.MaterialProductId);
    $cbMaterial.trigger("change");

    $cbMaterial.removeInactiveOptions().change(function() {
      refreshMeasures($cbMaterial);
    })
    refreshMeasures($cbMaterial);
  }
  
  if (obj.AltMaterialList) 
    for (var i=0; i<obj.AltMaterialList.length; i++) 
      addBomRow(obj.AltMaterialList[i], true);
  
  function _refreshIncCombo(inc) {
    var $inc = $(inc);
    var $tr = $inc.closest("tr");
    
    if (!$tr.hasClass("indent")) {
      var $opt = $tr.find("[name='optional']");  
      $opt.attr("disabled", !$inc.isChecked());
      if (!$inc.isChecked())
        $opt.setChecked(true);
    }
    else if ($inc.isChecked()) {
      var $group = $tr.prev();
      while ($group.hasClass("indent"))
        $group = $group.prev();
      
      var $alt = $group.next();
      while ($alt.hasClass("indent")) {
        $alt.find("[name='included']").setChecked(false);
        $alt = $alt.next();
      }
      
      $inc.setChecked(true);
    }
  }

  _refreshIncCombo($cbInc);
  $cbInc.click(function() {
    _refreshIncCombo(this);
  });
}

function refreshMeasures(cbMaterial) {
  var $cbMaterial = $(cbMaterial);
  var measureProfileId = $cbMaterial.find("option:selected").attr("data-measureprofileid");

  var measureIDs = [];
  for (var i=0; i<mps.length; i++) {
    var conv = mps[i];
    if (conv.MeasureProfileId == measureProfileId) {
      if (conv.ConvertMeasureIDs)
        measureIDs = conv.ConvertMeasureIDs.split(",");
      if (conv.BaseMeasureId)
        measureIDs.push(conv.BaseMeasureId);
      break;
    }
  }
  
  var $cbMeasure = $cbMaterial.closest("tr").find("[name='measure-combo']");
  var $template = $("#templates [name='measure-combo']");
  var measureId = $cbMeasure.val();
  $cbMeasure.empty();
  
  for (var i=0; i<measureIDs.length; i++) 
    $template.find("option[value='" + measureIDs[i] + "']").clone().appendTo($cbMeasure);
  
  if ($cbMeasure.find("option[value='" + measureId + "']").length == 0) 
    $template.find("option[value='" + measureId + "']").clone().appendTo($cbMeasure);
  
  $cbMeasure.val(measureId);
  $cbMeasure.removeInactiveOptions();
}

function doSaveBOM() {
  var reqDO = {
    Command: "SaveProduct",
    SaveProduct: {
      Product: {
        ProductId: <%=product.ProductId.getJsString()%>,
        PreparationMins: strToIntDef($("#product\\.PreparationMins").val(), null),
        MaterialList: []
      }
    }
  };
  
  $("#bom-grid-body tr").each(function(idx, tr) {
    var $tr = $(tr);
    var list = reqDO.SaveProduct.Product.MaterialList;
    if ($tr.hasClass("indent") && (list.length > 0))
      list = list[list.length - 1].AltMaterialList;
      
    list.push({
      GroupItem: $tr.hasClass("bom-group"),  
      GroupName: $tr.find("[name='group-name']").val(),
      MaterialProductId: $tr.find("[name='material-combo']").val(),
      MeasureId: $tr.find("[name='measure-combo']").val(),
      Quantity: $tr.find("[name='quantity']").val(),
      Optional: $tr.find("[name='optional']").isChecked(),
      Included: $tr.find("[name='included']").isChecked(),
      AltMaterialList: []
    });
  });
  
  showWaitGlass();
  vgsService("Product", reqDO, false, function(ansDO) {
    hideWaitGlass();
    entitySaveNotification(<%=LkSNEntityType.ProductType.getCode()%>, ansDO.Answer.SaveProduct.ProductId, "tab=bom");
  });
}

</script>