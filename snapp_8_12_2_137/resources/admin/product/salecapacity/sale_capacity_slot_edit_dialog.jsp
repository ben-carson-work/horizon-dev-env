<%@page import="com.vgs.snapp.dataobject.DOSaleCapacitySlot"%>
<%@page import="com.vgs.web.library.BLBO_SaleCapacity"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
BLBO_SaleCapacity bl = pageBase.getBL(BLBO_SaleCapacity.class);
DOSaleCapacitySlot saleCapacitySlot = bl.loadSaleCapacitySlot(pageBase.getNullParameter("SaleCapacitySlotId"));

request.setAttribute("saleCapacitySlot", saleCapacitySlot);

String title = saleCapacitySlot.SaleCapacitySerialName.getHtmlString();
boolean canEdit = rights.PromotionRules.canUpdate();

%>
  <style>
    #sale-capacity-slot-edit-dialog .sale-capacity-slot-table {
      width: 100%;
    }
</style>

<v:dialog id="sale-capacity-slot-edit-dialog" tabsView="true" width="800" title="<%=title%>">

    <div class="tab-content">
      <v:widget caption="@Common.General">
        <v:widget-block>
          <table class="sale-capacity-slot-table">
            <tr>
              <td><v:itl key="@Common.FromDate"/></td>
              <%saleCapacitySlot.ValidDateFrom.setDisplayFormat(pageBase.getShortDateFormat());%>
              <td><span id="valid-date-from" class="recap-value"><%=saleCapacitySlot.ValidDateFrom.getHtmlString()%></span></td>
            </tr>
            <tr>
              <td><v:itl key="@Common.ToDate"/></td>
              <%saleCapacitySlot.ValidDateTo.setDisplayFormat(pageBase.getShortDateFormat());%>
              <td><span id="valid-date-to" class="recap-value"><%=saleCapacitySlot.ValidDateTo.getHtmlString()%></span></td>
            </tr>
            <tr>
              <td><v:itl key="@SaleCapacity.QuantityUsed"/></td>
              <td><span id="quantity-free" class="recap-value"><%=saleCapacitySlot.QuantityUsed.getHtmlString()%></span></td>
            </tr>
            <tr>
              <td><v:itl key="@SaleCapacity.QuantityFree"/></td>
              <td><span id="quantity-free" class="recap-value"><%=saleCapacitySlot.QuantityFree.getHtmlString()%></span></td>
            </tr>
          </table>
        </v:widget-block>
        <v:widget-block>
          <v:form-field caption="@SaleCapacity.QuantityMax" mandatory="true">
            <v:input-text field="saleCapacitySlot.QuantityMax" enabled="<%=canEdit%>"/>
          </v:form-field>
        </v:widget-block>
      </v:widget>
    </div>

<script>
$(document).ready(function() { 
  var dlg = $("#sale-capacity-slot-edit-dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
      <% if (canEdit) { %>    
        <v:itl key="@Common.Save" encode="JS"/>: saveSaleCapacitySlot,
      <% } %>
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    };
  });
  
  function saveSaleCapacitySlot() {
    var reqDO = {
        Command: "SaveSaleCapacitySlot",
        SaveSaleCapacitySlot: {
          SaleCapacitySlotId: <%=saleCapacitySlot.SaleCapacitySlotId.getJsString()%>,
          QuantityMax: $("#saleCapacitySlot\\.QuantityMax").val()
        }
      }
     
      vgsService("SaleCapacity", reqDO, false, function(ansDO) {
        $("#sale-capacity-slot-edit-dialog").dialog("close");
        triggerEntityChange(<%=LkSNEntityType.SaleCapacity.getCode()%>);
      });
  }
});
</script>  

</v:dialog>