<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% LookupItem entityType = LkSN.EntityType.getItemByCode(pageBase.getParameter("EntityType")); %>
<% boolean canEdit = !pageBase.getParameter("ReadOnly").equals("true");%>

<div class="tab-toolbar">
  <v:button fa="plus" caption="@Common.Add" href="javascript:showLocationPickupDialog()" enabled="<%=canEdit%>"/>
  <v:button fa="minus" caption="@Common.Remove" href="javascript:removeLocations()" enabled="<%=canEdit%>"/>
</div>

<div class="tab-content">
  <v:grid id="crosslocpgrade-grid" style="margin-bottom:10px">
    <thead>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="100%"><v:itl key="@Common.Name"/></td>           
      </tr>
    </thead>
    <tbody>      
    </tbody>
  </v:grid>
</div>

<script>

//Init
function initCrossLoc() {
  if ((productUpgrade) && (productUpgrade.LocationList)) {
    for (var i=0; i<productUpgrade.LocationList.length; i++) {
      addLocation(productUpgrade.LocationList[i].LocationAccountId, 
        productUpgrade.LocationList[i].LocationCode,
        productUpgrade.LocationList[i].LocationName);
    }
  }
}

function addLocation(id, code, name) {
  var tr = $("<tr class='grid-row' data-LocationId='" + id + "'/>").appendTo("#crosslocpgrade-grid tbody");
  var tdCB = $("<td/>").appendTo(tr);
  var tdLocation = $("<td/>").appendTo(tr);
  var hrefURL = <%=JvString.jsString(ConfigTag.getValue("site_url"))%> + "/admin?page=account&id=" + id;

  tdCB.append("<input value='" + id + "' type='checkbox' class='cblist'>");
  tdLocation.html("<a href=" + hrefURL + ">" + name + "</a>");
}

function showLocationPickupDialog() {
  showLookupDialog({
    EntityType: <%=LkSNEntityType.Location.getCode()%>,
    onPickup: function(item) {
      if ($("#crosslocpgrade-grid tr[data-LocationId='" + item.ItemId + "']").length > 0) 
        showMessage("<v:itl key="@Product.LocationAlreadyExistsError" encode="UTF-8"/>");
      else
        addLocation(item.ItemId, item.ItemCode, item.ItemName, "");
    }
  });
}

function getLocationList() {
  var list = [];
  var trs = $("#crosslocpgrade-grid tbody tr");
  for (var i=0; i<trs.length; i++) {
    var tr = $(trs[i]);
    list.push({
      LocationAccountId: tr.attr("data-LocationId"),
    });
  }
  return list;
}

function removeLocations() {
  $("#crosslocpgrade-grid tbody .cblist:checked").closest("tr").remove();
}

</script>