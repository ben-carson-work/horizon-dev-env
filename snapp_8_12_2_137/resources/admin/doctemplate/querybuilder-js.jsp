<%@page import="java.util.Map.Entry"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageQueryBuilder" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>


<script>
$(document).ready(function() {
  $("#column-list").sortable({
    handle: ".move-handle"
  });
  
  var $drag = null;
  var dragOrigWidth = null;
  var dragStartX = null;
  $("#qb-tab-content")
    .mousedown(function(e) {
      $(this).addClass("in-column-resizing");
      var $target = $(e.target);
      if ($target.is(".vert-split")) {
        e.stopPropagation();
        e.preventDefault();
        $drag = $target.prev();
        dragOrigWidth = $drag.width();
        dragStartX = e.screenX;
      }
    })
    .mouseup(function(e) {
      $(this).removeClass("in-column-resizing");
      e.stopPropagation();
      e.preventDefault();
      $drag = null;
    })
    .mousemove(function(e) {
      if ($drag) {
        e.stopPropagation();
        e.preventDefault();
        $drag.css("width", (dragOrigWidth + e.screenX - dragStartX) + "px");
      }
    });
  
  function handleResize() {
    var $cont = $("#qb-tab-content");
    $cont.css("height", ($(window).innerHeight() - $cont.position().top) + "px");
  }
  $(window).resize(handleResize);
  handleResize();
  
  $(".property-box-header .explode-btn").click(function() {
    $(this).closest(".property-box").addClass("exploded").removeClass("collapsed");    
  });
  
  $(".property-box-header .collapse-btn").click(function() {
    $(this).closest(".property-box").addClass("collapsed").removeClass("exploded");    
  });

  $(".collection-field").draggable({
    helper: "clone",
    appendTo: "body"
  });

  $("#select-box .property-box-body").sortable({
    containment: "#select-box",
    handle: ".column-move-icon"
  });
  
  $("#select-box .property-box-body").droppable({
    accept: function(helper) {
      if (helper.is(".collection-field")) {
        var fieldAlias = helper.attr("data-fieldalias");
        var $existing = $(this).find("[data-fieldalias='" + fieldAlias + "']");
        if ($existing.length == 0)
          return true;
      }
      return false;
    },
    drop: function(event, ui) { 
      var $col = $("#qb-templates .column-item").clone().appendTo(this);
      $col.attr("data-collectionname", ui.helper.attr("data-collectionname"));
      $col.attr("data-fieldtype", ui.helper.attr("data-fieldtype"));
      $col.attr("data-fieldname", ui.helper.attr("data-fieldname"));
      $col.attr("data-fieldalias", ui.helper.attr("data-fieldalias"));
      $col.attr("data-fieldname", ui.helper.attr("data-fieldname"));
      $col.attr("data-datatype", ui.helper.attr("data-datatype"));
      $col.find(".column-alias").text($col.attr("data-fieldalias"));
      
      $col.find(".column-remove-icon")
        .click(function(e) {
          $(this).closest(".column-item").remove();
        });
    }
  });
  
  $("#btn-collection-explode-all").click(function() {
    $("#datasource-container .property-box").removeClass("collapsed").addClass("exploded");
  });
  
  $("#btn-collection-collapse-all").click(function() {
    $("#datasource-container .property-box").removeClass("exploded").addClass("collapsed");
  });
  
  $("#txt-collection-search").keyup(function() {
    var keys = $(this).val().toLowerCase().split(" ");
    
    var doSearch = false;
    if (keys) {
      for (var i=0; i<keys.length; i++) {
        var key = keys[i];
        if ((key) && (key.trim() != "")) {
          doSearch = true;
          break;
        }
      }
    }
    
    $("#datasource-container .search-hide").removeClass("search-hide");
    if (doSearch) { 
      $("#datasource-container .property-box").removeClass("collapsed").addClass("exploded").addClass("search-hide");
      $("#datasource-container .collection-field").addClass("search-hide");
    
      function _txtSearchMatch(text) {
        if (text) {
          for (var i=0; i<keys.length; i++) {
            var key = keys[i].trim();
            if ((key != "") && (text.toLowerCase().indexOf(key) < 0))
              return false;
          }
          return true;
        }
        return false;
      }
      
      $("#datasource-container .collection-field").each(function(idx, item) {
        var $item = $(item);
        if (_txtSearchMatch($item.attr("data-fieldalias"))) 
          $item.removeClass("search-hide");
      });

      $("#datasource-container .collection-field:not(.search-hide)").closest(".property-box").removeClass("search-hide");
    }
  });
  
});


function encodeTemplateColumn(col) {
  var colDO = {
    CollectionName: col.attr("data-collectionname"),
    FieldAlias: col.attr("data-fieldalias"),
    AggregateType: strToIntDef($(col).find(".aggregate-type").val(), null),
    SubTotal: col.find("#cb-subtotal").isChecked(),
    FilterOnly: col.find("#cb-filteronly").isChecked()
  };

  var dataType = parseInt(col.attr("data-DataType"));
  if (dataType < 1000) {
    var oper = parseInt(col.find(".filter-oper").val());
    if (oper != <%=LkSNQueryBuilderFilterOperator.None.getCode()%>) {
      colDO.FilterOperator = oper;
      colDO.FilterValueFrom = $(col).find(".filter-value-from").val();
      colDO.FilterValueTo = $(col).find(".filter-value-to").val();
    }
  }
  else {
    var value = col.find(".filter-combo-value").val();
    if ((value) && (value != "")) {
      colDO.FilterOperator = <%=LkSNQueryBuilderFilterOperator.Equals.getCode()%>;
      colDO.FilterValueFrom = value;
    }
  }
  
  return colDO;
}

function execute(format, forceDownload) {
  var template = {ColumnList: []};
  $("#select-container .column-item").each(function(idx, elem) {
    template.ColumnList.push(encodeTemplateColumn($(elem)));
  });
  
  var form = $("#docproc-form");
  form.find("[name='QueryBuilder']").val(JSON.stringify(template));
  form.find("[name='OutputFormat']").val(format);
  form.find("[name='ForceDownload']").val(forceDownload);
  form.submit();
}



<%--
$(document).on("querybuilder-addfield", function(event, collection, field) {
  var existing = $("#column-list .column-block[data-CollectionName='" + collection.CollectionName + "'][data-FieldAlias='" + field.FieldAlias + "']");
  if (existing.length == 0) {
    var wblock = $("#column-block-template .column-block").clone().appendTo("#column-list");
    wblock.attr("data-CollectionName", collection.CollectionName);
    wblock.attr("data-FieldAlias", field.FieldAlias);
    wblock.attr("data-DataType", field.DataType);
    wblock.find(".field-name").text(collection.CollectionName + "." + field.FieldAlias);

    if (field.DataType > 1000) {
      wblock.find(".filter-block").empty();
      
      if (field.DataType == <%=LkSNQueryBuilderDataType.Location.getCode()%>) {
        $("<select class='form-control filter-combo-value combo-location'/>").appendTo(wblock.find(".filter-block")).asyncCombo({
          EmptyOption: <%=rights.AuditLocationFilter.isLookup(LkSNAuditLocationFilter.All)%>,
          EntityType: <%=LkSNEntityType.Location.getCode()%>,
          Params: "AuditLocationFilter=true"
        }).change(filterComboChange);
      }
      else if (field.DataType == <%=LkSNQueryBuilderDataType.OpArea.getCode()%>) {
        $("<select class='form-control filter-combo-value combo-oparea'/>").appendTo(wblock.find(".filter-block")).setEnabled(false).change(filterComboChange);
      }
      else if (field.DataType == <%=LkSNQueryBuilderDataType.AccessArea.getCode()%>) {
        $("<select class='form-control filter-combo-value combo-acarea'/>").appendTo(wblock.find(".filter-block")).setEnabled(false).change(filterComboChange);
      }
      else if (field.DataType == <%=LkSNQueryBuilderDataType.Workstation.getCode()%>) {
        $("<select class='form-control filter-combo-value combo-workstation'/>").appendTo(wblock.find(".filter-block")).setEnabled(false).change(filterComboChange);
      }
      else if (field.DataType == <%=LkSNQueryBuilderDataType.User.getCode()%>) {
        $("<select class='form-control filter-combo-value combo-user'/>").appendTo(wblock.find(".filter-block"));
      }
    }

    if ((field.DataType >= 20) && (field.DataType < 30))
      wblock.find(".aggregate-type").val(<%=LkSNAggregateType.Sum.getCode()%>);
    
    wblock.find(".field-name").click(function() {
      wblock.toggleClass("collapsed");
    });

    wblock.find(".filter-oper").change(function() {
      refreshColummVisibility(wblock);
    });
    
    wblock.find(".btn-remove").click(function() {
      wblock.remove();
    });

    refreshColummVisibility(wblock);
  }
});

function filterComboAdded() {
  var loc = $(".combo-location");
  var opa = $(".combo-oparea");
  var wks = $(".combo-workstation");
}

function filterComboChange() {
  var select = $(this);
  var value = select.val();
  select.setEnabled(select.find("option").length > 0);
  
  var loc = $(".combo-location");
  var opa = $(".combo-oparea");
  var aca = $(".combo-acarea");
  var wks = $(".combo-workstation");
  
  if (select.is(".combo-location")) {
    opa.empty().setEnabled(false).trigger("change");
    aca.empty().setEnabled(false).trigger("change");
    wks.empty().setEnabled(false).trigger("change");
    if ((value) && (value != "")) {
      if (opa.length > 0) {
        opa.asyncCombo({
          EmptyOption: true,
          EntityType: <%=LkSNEntityType.OperatingArea.getCode()%>,
          Params: "LocationId=" + value
        });
      }
      if (aca.length > 0) {
        aca.asyncCombo({
          EmptyOption: true,
          EntityType: <%=LkSNEntityType.AccessArea.getCode()%>,
          Params: "LocationId=" + value
        });
      }
    }
  }
  else if (select.is(".combo-oparea")) {
    wks.empty().setEnabled(false).trigger("change");
    if ((value) && (value != "") && (wks.length > 0)) {
      wks.asyncCombo({
        EmptyOption: true,
        EntityType: <%=LkSNEntityType.Workstation.getCode()%>,
        Params: "OperatingAreaId=" + value
      });
    }
  }
}

function refreshColummVisibility(col) {
  var oper = parseInt(col.find(".filter-oper").val());
  col.find(".filter-value-from").setClass("hidden", (oper == <%=LkSNQueryBuilderFilterOperator.None.getCode()%>));
  col.find(".filter-value-to").setClass("hidden", (oper != <%=LkSNQueryBuilderFilterOperator.Between.getCode()%>));
}

function encodeTemplateColumn(col) {
  var colDO = {
    CollectionName: col.attr("data-CollectionName"),
    FieldAlias: col.attr("data-FieldAlias"),
    AggregateType: strToIntDef($(col).find(".aggregate-type").val(), null),
    SubTotal: col.find("#cb-subtotal").isChecked(),
    FilterOnly: col.find("#cb-filteronly").isChecked()
  };

  var dataType = parseInt(col.attr("data-DataType"));
  if (dataType < 1000) {
    var oper = parseInt(col.find(".filter-oper").val());
    if (oper != <%=LkSNQueryBuilderFilterOperator.None.getCode()%>) {
      colDO.FilterOperator = oper;
      colDO.FilterValueFrom = $(col).find(".filter-value-from").val();
      colDO.FilterValueTo = $(col).find(".filter-value-to").val();
    }
  }
  else {
    var value = col.find(".filter-combo-value").val();
    if ((value) && (value != "")) {
      colDO.FilterOperator = <%=LkSNQueryBuilderFilterOperator.Equals.getCode()%>;
      colDO.FilterValueFrom = value;
    }
  }
  
  return colDO;
}

function execute(format, forceDownload) {
  var template = {ColumnList: []};
  $("#column-list-widget .column-block").each(function(idx, elem) {
    template.ColumnList.push(encodeTemplateColumn($(elem)));
  });
  console.log(template);
  
  var form = $("#docproc-form");
  form.find("[name='QueryBuilder']").val(JSON.stringify(template));
  form.find("[name='OutputFormat']").val(format);
  form.find("[name='ForceDownload']").val(forceDownload);
  form.submit();
}

function renderResult(responseText) {
  console.log(responseText);
  var doc = $("#result-container")[0].contentWindow.document;
  console.log(doc);
  $(doc).html(responseText);
}

--%>

</script>

