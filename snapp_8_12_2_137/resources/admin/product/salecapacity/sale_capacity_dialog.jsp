<%@page import="com.vgs.snapp.dataobject.DOSaleCapacity"%>
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
DOSaleCapacity saleCapacity = pageBase.isNewItem() ? bl.prepareNewSaleCapacity(pageBase.getNullParameter("ProductId")) : bl.loadSaleCapacity(pageBase.getId());

if (saleCapacity.ProductId.isNull())
  saleCapacity.ProductId.setString(pageBase.getNullParameter("ProductId"));
JvDataSet dsSaleCapacityTree = bl.getSaleCapacityTreeDS(saleCapacity.ProductId.getString());
if (saleCapacity.ParentSaleCapacityId.isNull())
  saleCapacity.ParentSaleCapacityId.setString(pageBase.getNullParameter("ParentSaleCapacityId"));

String[] saleCapacityIDs = pageBase.getParameters("SaleCapacityIDs");
boolean add = JvString.isSameString(pageBase.getNullParameter("Operation"), "add"); 
boolean move = JvString.isSameString(pageBase.getNullParameter("Operation"), "move"); 
boolean canEdit = rights.PromotionRules.canUpdate();
boolean active = saleCapacity.SaleCapacityStatus.isLookup(LkSNSaleCapacityStatus.Active);
String checked = active ? " checked" : "";

request.setAttribute("saleCapacity", saleCapacity);
request.setAttribute("dsSaleCapacityTree", dsSaleCapacityTree);

String title = pageBase.getLang().SaleCapacity.SaleCapacity.getText();
if (!pageBase.isNewItem())
  title += " #" + saleCapacity.Serial.getHtmlString();

%>

<v:dialog id="sale-capacity-dialog" tabsView="true" width="800" title="<%=title%>">

    <div class="tab-content">
      <v:widget caption="@Common.General">
        <v:widget-block id="parent-sale-capacity-id-block">
          <v:form-field caption="@SaleCapacity.ParentSaleCapacity">
            <v:combobox field="saleCapacity.ParentSaleCapacityId" lookupDataSetName="dsSaleCapacityTree" idFieldName="SaleCapacityId" captionFieldName="SerialName" allowNull="true"/>
          </v:form-field>
        </v:widget-block>
        <%if (!move) {%>
          <v:widget-block>
            <v:form-field caption="@Common.Priority">
              <v:input-text field="saleCapacity.PriorityOrder" enabled="<%=canEdit%>"/>
            </v:form-field>
            <v:form-field caption="@Common.Quantity" mandatory="true">
              <v:input-text field="saleCapacity.Quantity" enabled="<%=canEdit%>"/>
            </v:form-field>
            <v:form-field caption="@SaleCapacity.TimeSlotType" mandatory="true">
              <v:lk-combobox field="saleCapacity.TimeSlotType" lookup="<%=LkSN.SaleCapacityTimeSlotType%>" allowNull="false" enabled="<%=canEdit%>"/>
            </v:form-field>
            <v:form-field caption="@SaleCapacity.TimeSlotStep" mandatory="true" id="time-slot-step-field">
              <v:input-text field="saleCapacity.TimeSlotStep" enabled="<%=canEdit%>"/>
            </v:form-field>
          </v:widget-block>
          <v:widget-block>
            <v:form-field caption="@SaleChannel.SaleChannel">
              <snp:dyncombo field="saleCapacity.SaleChannelId" id="SaleChannelId" entityType="<%=LkSNEntityType.SaleChannel%>" enabled="<%=canEdit%>"/>
            </v:form-field>
            <v:form-field caption="@Common.FromDate">
              <v:input-text type="datepicker" field="saleCapacity.ValidDateFrom" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
              &nbsp;&nbsp;&nbsp;&nbsp;<v:itl key="@Common.ToDate"/>&nbsp;&nbsp;&nbsp;&nbsp;
              <v:input-text type="datepicker" field="saleCapacity.ValidDateTo" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
            </v:form-field>
          </v:widget-block>
          <v:widget-block>
            <div><label><input type="checkbox" id="saleCapacity.Active" name="saleCapacity.Active" <%=checked%>> <v:itl key="@Common.Active"/></label></div>
          </v:widget-block>
        <% } %>
  
      </v:widget>
    </div>

<script>
$(document).ready(function() {
  <% boolean parentCapacityVisible = move || (add && saleCapacity.ParentSaleCapacityId.isNull()); %>
  var parentCapacityVisible = <%=parentCapacityVisible%>;
  if (!parentCapacityVisible)
    $("#parent-sale-capacity-id-block").addClass("hidden");
  
  $("#time-slot-step-field").addClass("hidden");
  
  var dlg = $("#sale-capacity-dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
      <% if (canEdit) { %>    
        <v:itl key="@Common.Save" encode="JS"/>: saveSaleCapacity,
      <% } %>
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    };
  });
  
  function saveSaleCapacity() {
    if (<%=move%>)
      doMoveSaleCapacity();
    else
      doSaveSaleCapacity();
  }
  
  function doSaveSaleCapacity() {
    var reqDO = {
        Command: "SaveSaleCapacity",
        SaveSaleCapacity: {
          SaleCapacityId: <%=saleCapacity.SaleCapacityId.getJsString()%>,
          ProductId: <%=saleCapacity.ProductId.getJsString()%>,
          ParentSaleCapacityId: $("#saleCapacity\\.ParentSaleCapacityId").val(),
          PriorityOrder: $("#saleCapacity\\.PriorityOrder").val(),
          SaleCapacityStatus: $("#saleCapacity\\.Active").isChecked() ? <%=LkSNSaleCapacityStatus.Active.getCode()%> : <%=LkSNSaleCapacityStatus.Inactive.getCode()%>,
          ValidDateFrom: $("#saleCapacity\\.ValidDateFrom-picker").getXMLDateTime(),
          ValidDateTo: $("#saleCapacity\\.ValidDateTo-picker").getXMLDateTime(),
          SaleChannelId: $("#SaleChannelId").val(),
          TimeSlotType: $("#saleCapacity\\.TimeSlotType").val(),
          TimeSlotStep: $("#saleCapacity\\.TimeSlotStep").val(),
          Quantity: $("#saleCapacity\\.Quantity").val()
        }
      }
     
      vgsService("SaleCapacity", reqDO, false, function(ansDO) {
        $("#sale-capacity-dialog").dialog("close");
        triggerEntityChange(<%=LkSNEntityType.SaleCapacity.getCode()%>);
      });
  }
  
  function doMoveSaleCapacity() {
    var ids = <%=JvString.jsString(JvArray.arrayToString(pageBase.getParameters("SaleCapacityIDs"), ","))%>;
    var reqDO = {
      Command: "MoveSaleCapacity",
      MoveSaleCapacity: {
        ParentSaleCapacityId: $("#saleCapacity\\.ParentSaleCapacityId").val(),
        SaleCapacityIDs: ids
      }
    };
    
    vgsService("SaleCapacity", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.SaleCapacity.getCode()%>);
      $("#sale-capacity-dialog").dialog("close");
    });
  }
});
</script>  

</v:dialog>