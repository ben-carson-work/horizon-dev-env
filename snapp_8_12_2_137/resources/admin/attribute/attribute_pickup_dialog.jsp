<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
String[] parentIDs = new String[0];
LookupItem parentEntityType = LkSN.EntityType.findItemByCode(pageBase.getParameter("ParentEntityType"));
if (parentEntityType != null)
  parentIDs = (new EntityTree(pageBase.getConnector(), parentEntityType, pageBase.getNullParameter("ParentEntityId"))).getIDs();

QueryDef qdef = new QueryDef(QryBO_AttributeItem.class);
// Select
qdef.addSelect(QryBO_AttributeItem.Sel.AttributeItemId);
qdef.addSelect(QryBO_AttributeItem.Sel.AttributeId);
qdef.addSelect(QryBO_AttributeItem.Sel.AttributeCode);
qdef.addSelect(QryBO_AttributeItem.Sel.AttributeName);
qdef.addSelect(QryBO_AttributeItem.Sel.AttributeItemCode);
qdef.addSelect(QryBO_AttributeItem.Sel.AttributeItemName);
qdef.addSelect(QryBO_AttributeItem.Sel.SeatCategoryColor);
qdef.addSelect(QryBO_AttributeItem.Sel.SeatCategory);
// Where
qdef.addFilter(QryBO_AttributeItem.Fil.ForAttributeParentEntityId, parentIDs);
qdef.addFilter(QryBO_AttributeItem.Fil.Active, "true");
// Sort
qdef.addSort(QryBO_AttributeItem.Sel.AttributeWeight); 
qdef.addSort(QryBO_AttributeItem.Sel.AttributeName); 
qdef.addSort(QryBO_AttributeItem.Sel.PriorityOrder);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
%>

<v:dialog id="attribute_pickup_dialog" icon="attribute.png" title="@Product.Attributes" width="600" height="600">
  <input type="text" id="attr-search-box" placeholder="<v:itl key="@Common.Search"/>" onkeyup="doSearchAttribute()"/>
  <div id="attr-container">
  <% String lastAttributeId = null; %>
  <v:ds-loop dataset="<%=ds%>">
    <% String attributeId = ds.getField(QryBO_AttributeItem.Sel.AttributeId).getString(); %>
    <% if ((lastAttributeId == null) || !attributeId.equalsIgnoreCase(lastAttributeId)) { %>
      <% if (lastAttributeId != null) { %>
        <%="</div></div>"%>
      <% } %>
      <% lastAttributeId = attributeId; %>
      <%="<div class='attribute-container' data-attributeId='" + attributeId + "' data-SeatCategory='" + ds.getField(QryBO_AttributeItem.Sel.SeatCategory).getBoolean() + "'>"%>
      <div class="attribute-caption no-select" onClick="attributeClick('<%=attributeId%>')"><%=ds.getField(QryBO_AttributeItem.Sel.AttributeName).getHtmlString()%></div>
      <%="<div class='attribute-item-list hidden'>"%>
    <% } %>
    <% String attributeItemId = ds.getField(QryBO_AttributeItem.Sel.AttributeItemId).getString(); %>
    <div data-AttributeItemId="<%=attributeItemId%>">
      <div class="attribute-item-caption no-select" onClick="attributeItemClick('<%=attributeItemId%>')">
        <div class="attribute-item-color" style="background-color:<%=ds.getField(QryBO_AttributeItem.Sel.SeatCategoryColor).getHtmlString()%>"></div>
        <%=ds.getField(QryBO_AttributeItem.Sel.AttributeItemName).getHtmlString()%></div>
    </div>
  </v:ds-loop>
  
  <% if (lastAttributeId != null) { %>
    <%="</div></div>"%>
  <% } %>
  </div>

  <div id="attr-item-container">
  </div>

<style>

#attribute_pickup_dialog {
  margin: 0;
  padding: 0;
}

#attr-search-box {
  border: 0;
  border-bottom: 1px var(--border-color) solid;
  border-radius: 0;
  margin: 0;
  padding: 8px;
  line-height: 16px;
}

#attr-container {
  position: absolute;
  left: 0;
  top: 33px;
  width: 300px;
  bottom: 0;
  overflow-y: auto; 
  border-right: 1px var(--border-color) solid;
}

#attr-item-container {
  position: absolute;
  left: 300px;
  top: 33px;
  right: 0;
  bottom: 0;
  overflow-y: auto; 
}

#attribute_pickup_dialog .attribute-caption,
#attribute_pickup_dialog .attribute-item-caption {
  position: relative;
  padding: 0 10px 0 30px;
  line-height: 32px;
  cursor: pointer;
  background-repeat: no-repeat;
  background-position: 5px center;
}

#attribute_pickup_dialog .attribute-caption:hover,
#attribute_pickup_dialog .attribute-item-caption:hover {
  background-color: rgba(0,0,0,0.1);
}
#attribute_pickup_dialog .attribute-caption.selected,
#attribute_pickup_dialog .attribute-item-caption.selected {
  background-color: var(--highlight-color);
}

#attribute_pickup_dialog .attribute-caption {
  background-image: url('<v:image-link name="attribute.png" size="20"/>');
}

#attribute_pickup_dialog .attribute-container[data-SeatCategory='true'] .attribute-caption {
  background-image: url('<v:image-link name="<%=LkSNEntityType.SeatMap.getIconName()%>" size="20"/>');
}

#attribute_pickup_dialog .attribute-item-caption {
  background-image: url('<v:image-link name="<%=LkSNEntityType.AttributeItem.getIconName()%>" size="20"/>');
}

#attribute_pickup_dialog .attribute-item-color {
  position: absolute;
  left: 5px;
  top: 5px;
  width: 20px;
  height: 20px;
}

</style>


<script>
var dlg = $("#attribute_pickup_dialog");
dlg.on("snapp-dialog", function(event, params) {
  params.buttons = [
    {
      text: <v:itl key="@Common.Ok" encode="JS"/>,
      click: doCloseDialog
    },
    {
      text: <v:itl key="@Common.Cancel" encode="JS"/>,
      click: doCloseDialog
    }
  ];
});

function attributeClick(attributeId) {
  var cont = $(".attribute-container[data-AttributeId='" + attributeId + "']");
  $("#attr-item-container").html(cont.find(".attribute-item-list").html());
  
  $(".attribute-container .attribute-caption").removeClass("selected");
  cont.find(".attribute-caption").addClass("selected");
}

function attributeItemClick(attributeItemId) {
  var dsJSON = <%=pageBase.execQuery(qdef).getDocJSON()%>;
  for (var i=0; i<dsJSON.length; i++) {
    if (dsJSON[i].AttributeItemId == attributeItemId) {
      var obj = dsJSON[i];
      obj.SeatCategory = parseBool(obj.SeatCategory);
      attributePickupCallback(obj);
      break;
    }
  }
  dlg.dialog("close");
}

function doSearchAttribute() {
  $("#attr-item-container").empty();
  $(".attribute-container .attribute-caption").removeClass("selected");
  var values = $("#attr-search-box").val().split(" ");
  if (values.length == 0)
    $(".attribute-container .attribute-caption").removeClass("v-hidden");
  else {
    $(".attribute-container .attribute-caption").addClass("v-hidden");
    var attrs = $(".attribute-container");
    for (var i=0; i<attrs.length; i++) {
      var show = true;
      for (var k=0; k<values.length; k++) {
        var match = ($(attrs[i]).find(".attribute-caption").text().toLowerCase().indexOf(values[k].toLowerCase()) >= 0);
        if (!match) {
          var items = $(attrs[i]).find(".attribute-item-caption");
          for (var j=0; j<items.length; j++) {
            if ($(items[j]).text().toLowerCase().indexOf(values[k].toLowerCase()) >= 0) {
              match = true;
              break;
            }
          }
          if (!match)
            show = false;
        }
      }
      $(attrs[i]).find(".attribute-caption").setClass("v-hidden", !show);
    }
  }
}
</script>
  
</v:dialog>