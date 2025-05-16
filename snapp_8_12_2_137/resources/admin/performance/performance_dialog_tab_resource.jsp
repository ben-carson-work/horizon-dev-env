<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="perf" class="com.vgs.snapp.dataobject.DOPerformance" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% boolean canEdit = rights.ResourceManagement.canUpdate(); %>

<% JvDataSet dsResource = pageBase.getBL(BLBO_Resource.class).getResourceDS(null); %>

<div class="tab-content">
  <% if (!perf.SaleItemDetailId.isNull()) { %>
	  <%
	  QueryDef qdef = new QueryDef(QryBO_Ticket.class);
	  qdef.addSelect(
	      QryBO_Ticket.Sel.TicketId,
	      QryBO_Ticket.Sel.TicketCode,
	      QryBO_Ticket.Sel.IconName,
	      QryBO_Ticket.Sel.CommonStatus,
	      QryBO_Ticket.Sel.TicketStatus,
	      QryBO_Ticket.Sel.ProductId,
        QryBO_Ticket.Sel.ProductName,
        QryBO_Ticket.Sel.PortfolioAccountId,
        QryBO_Ticket.Sel.PortfolioAccountEntityType,
        QryBO_Ticket.Sel.PortfolioAccountNameMasked,
        QryBO_Ticket.Sel.GroupQuantity,
	      QryBO_Ticket.Sel.UnitAmount);
	  qdef.addFilter(QryBO_Ticket.Fil.SaleItemDetailId, perf.SaleItemDetailId.getString());
	  JvDataSet dsTCK = pageBase.execQuery(qdef);
	  %>
  
    <v:grid style="margin-bottom:20px">
      <thead>
        <v:grid-title caption="Host product"/>
      </thead>
      <tbody>
        <v:ds-loop dataset="<%=dsTCK%>">
          <% LookupItem ticketStatus = LkSN.TicketStatus.getItemByCode(dsTCK.getField(QryBO_Ticket.Sel.TicketStatus)); %>
          <tr>
            <td style="<v:common-status-style status="<%=dsTCK.getField(QryBO_Ticket.Sel.CommonStatus)%>"/>"><v:grid-icon name="<%=dsTCK.getField(QryBO_Ticket.Sel.IconName).getString()%>"/></td>
            <td width="20%">
              <snp:entity-link entityId="<%=dsTCK.getField(QryBO_Ticket.Sel.TicketId)%>" entityType="<%=LkSNEntityType.Ticket%>" clazz="list-title"><%=dsTCK.getField(QryBO_Ticket.Sel.TicketCode).getString()%></snp:entity-link>
              <br/>
              <span class="list-subtitle"><%=ticketStatus.getHtmlDescription(pageBase.getLang())%></span>
            </td>
            <td width="40%">
              <snp:entity-link entityId="<%=dsTCK.getField(QryBO_Ticket.Sel.ProductId)%>" entityType="<%=LkSNEntityType.ProductType%>"><%=dsTCK.getField(QryBO_Ticket.Sel.ProductName).getString()%></snp:entity-link>
              <br/>
              <% if (dsTCK.getField(QryBO_Ticket.Sel.PortfolioAccountId).isNull()) { %>
                <span class="list-subtitle"><v:itl key="@Account.AnonymousAccount"/></span>
              <% } else { %>
                <snp:entity-link entityId="<%=dsTCK.getField(QryBO_Ticket.Sel.PortfolioAccountId)%>" entityType="<%=dsTCK.getField(QryBO_Ticket.Sel.PortfolioAccountEntityType)%>"><%=dsTCK.getField(QryBO_Ticket.Sel.PortfolioAccountNameMasked).getHtmlString()%></snp:entity-link>
              <% } %>
            </td>
            <td width="40%" align="right"><%=dsTCK.getField(QryBO_Ticket.Sel.GroupQuantity).getInt()%> x <%=pageBase.formatCurrHtml(dsTCK.getField(QryBO_Ticket.Sel.UnitAmount))%></td>
          </tr>
        </v:ds-loop>
      </tbody>
    </v:grid>
  <% } %>
  
  <div id="resource-types"></div>
</div>

<style>

#resource-types .resource-type .title {
  font-weight: bold;
  text-decoration: underline;
}

#resource-types .resource-type {
  margin-top: 20px;
}

#resource-types .resource-type:first-child {
  margin-top: 0px;
}

#resource-types .resource-type .resources,
#resource-types .resource-type .toolbar {
  margin-left: 20px;
}

#resource-types .resource-type .toolbar {
  margin-top: 4px;
}

#resource-types .resource {
  margin: 2px 0px 2px 0px;
}

#resource-types .resource .ResourceId,
#resource-types .resource .Quantity {
  margin-right: 6px;
}

#resource-types .resource .ResourceId {
  width: 150px;
}

#resource-types .resource .Quantity {
  width: 65px;
}

</style>


<script>

var doc = <%=perf.getJSONString()%>;
var reslist = <%=dsResource.getDocJSON()%>;

$(document).ready(function() {
  if (doc.ResourceTypeList) {
    for (var i=0; i<doc.ResourceTypeList.length; i++) 
      addResourceType(doc.ResourceTypeList[i]);
  }
  recalcAll();
});

function addResourceType(rt) {
  var divRT = $("<div class='resource-type' data-ResourceTypeId='" + rt.ResourceTypeId + "'/>").appendTo("#resource-types");
  divRT.data(rt);
  
  $("<div class='title'/>").appendTo(divRT);
  $("<div class='resources'/>").appendTo(divRT);
  var divToolbar = $("<div class='toolbar'/>").appendTo(divRT);
  
  <% if (canEdit) { %>
	  var btnAdd = $("<button class='add-btn btn btn-default'></button>").appendTo(divToolbar);
	  btnAdd.text(<v:itl key="@Common.Add" encode="JS"/>);
	  btnAdd.prepend("<i class='fa fa-plus'></i>&nbsp;");
	  btnAdd.click(function() {
	    addResource(divRT, null, "");
	  });
  <% } %>
  
  if (rt.ResourceList)
    for (var i=0; i<rt.ResourceList.length; i++) 
      addResource(divRT, rt.ResourceList[i].EntityType, rt.ResourceList[i].EntityId, rt.ResourceList[i].Quantity);
}

function addResource(divRT, entityType, entityId, quantity) {
  var divResource = $("<div class='resource'/>").appendTo(divRT.find(".resources"));
  var rt = divRT.data();
  
  var combo = createResourceCombo(divRT.attr("data-ResourceTypeId")).appendTo(divResource).change(function() {
    var res = $(this).find("option:selected").data();
    var res_qty = isNaN(res.Quantity) ? 0 : res.Quantity;
    txtQuantity = divResource.find(".Quantity");
    txtQuantity.val(Math.min(res_qty, rt.Quantity));
    txtQuantity.setEnabled(res_qty > 1);  
    recalcAll();
  });
  combo.val(entityId);
  
  var txtQuantity = $("<input type='text' class='Quantity form-control' placeholder='<v:itl key="@Common.Quantity"/>'/>").appendTo(divResource);
  txtQuantity.val(quantity);
  txtQuantity.setEnabled(false);
  txtQuantity.keyup(recalcAll);
  
  var btn = $("<button class='btn btn-default'></button>").appendTo(divResource);
  btn.text(<v:itl key="@Common.Remove" encode="JS"/>);
  btn.prepend("<i class='fa fa-minus'></i>&nbsp;");
  btn.click(function() {
    $(this).closest(".resource").remove();
    recalcAll();
  });
  
  return divResource;
}

function createResourceCombo(resourceTypeId) {
  var combo = $("<select class='ResourceId form-control'><option/></select>");
  for (var i=0; i<reslist.length; i++) {
    reslist[i].Quantity = parseInt(reslist[i].Quantity);
    if (reslist[i].ResourceTypeIDs.indexOf(resourceTypeId) >= 0) {
      var option = $("<option value='" + reslist[i].EntityId + "'/>").appendTo(combo);
      option.html(reslist[i].EntityName);
      option.data(reslist[i]);
    }
  }
  return combo;
}

function recalcAll() {
  var divRTs = $("#resource-types .resource-type");
  for (var i=0; i<divRTs.length; i++) {
    var divRT = $(divRTs[i]);
    var rt = divRT.data();
    var divRs = divRT.find(".resource");
    var tot_qty = 0;
    for (var k=0; k<divRs.length; k++) {
      var divR = $(divRs[k]);
      if (divR.find(".ResourceId").val()) {
        var res_qty = parseInt(divR.find(".Quantity").val());
        tot_qty += isNaN(res_qty) ? 0 : res_qty;
      }
    } 
    divRT.find(".title").html(rt.ResourceTypeName + " (" + tot_qty + "/" + rt.Quantity + ")");
    divRT.find(".add-btn").setEnabled(tot_qty < rt.Quantity);
  }
}

function getResourcesForSave() {
  var result = [];
  var divRTs = $("#resource-types .resource-type");
  for (var i=0; i<divRTs.length; i++) {
    var divRT = $(divRTs[i]);
    var divRs = divRT.find(".resource");
    var rtDO = {
      ResourceTypeId: divRT.attr("data-ResourceTypeId"),
      ResourceList: []
    };
    for (var k=0; k<divRs.length; k++) {
      var divR = $(divRs[k]);
      if (divR.find(".ResourceId").val() != "") {
        var qty = parseInt(divR.find(".Quantity").val());
        rtDO.ResourceList.push({
          EntityType: divR.find(".ResourceId option:selected").data().EntityType,
          EntityId: divR.find(".ResourceId").val(),
          Quantity: isNaN(qty) ? 1 : qty
        });
      }
    }
    result.push(rtDO);
  }
  return result;
}

</script>
