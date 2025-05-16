<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>


<script>  
function showGateCategoryPickupDialog() {
    showLookupDialog({
      EntityType: <%=LkSNEntityType.GateCategory.getCode()%>,
      onPickup: function(item) {
        if ($("#" + item.ItemId).length > 0) 
          showMessage("<v:itl key="@Product.GateCatAlreadyExists" encode="UTF-8"/>");
        else
          addGateCategoryBox(item.ItemId, item.ItemCode, item.ItemName);
      }
    });
  }

function addGateCategoryBox(entityId, entityCode, entityName) {
  var existCount = $(".gatecategory-item-box[data-entityid='" + entityId + "']").length;
  if (existCount > 0)
    showMessage(<v:itl key="@Common.DuplicatedItem" encode="JS"/>);
  else {
    var divBox = $("<div class='gatecategory-item-box'/>").appendTo(".gatecategory-box-container");
    divBox.attr("data-EntityId", entityId);
    divBox.attr("data-EntityType", entityCode);
    divBox.attr("onclick", "$(this).remove()");
    
    $("<div class='item-name'/>").appendTo(divBox).html(entityName);
    $("<div class='item-code'/>").appendTo(divBox).html(entityCode);
    
  }
}
</script>
