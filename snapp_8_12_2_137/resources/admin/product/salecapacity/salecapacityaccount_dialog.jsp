<%@page import="com.vgs.web.library.right.controller.BOERC_SaleCapacityAccount"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.library.product.*"%>
<%@page import="com.vgs.snapp.dataobject.salecapacity.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
BLBO_SaleCapacityAccount bl = pageBase.getBL(BLBO_SaleCapacityAccount.class);
DOSaleCapacityAccount sca = pageBase.isNewItem() ? bl.prepareNew() : bl.ocSaleCapacityAccount(pageBase.getId());
FtCRUD rightCRUD = bl.getSaleCapacityAccountRightController().getCRUD(pageBase.getId());
boolean canEdit = pageBase.isNewItem() ? rightCRUD.canCreate() : rightCRUD.canUpdate();
request.setAttribute("sca", sca);
%>

<v:dialog id="salecapacityaccount-dialog" tabsView="true" width="800" height="600" title="@SaleCapacity.SaleCapacityAccount">

  <v:tab-group name="tab" main="true">
    <v:tab-item-embedded tab="tabs-main" caption="@Common.Profile" default="true">
      <v:tab-content>
        <v:widget>
          <v:widget-block>
            <v:form-field caption="@SaleCapacity.TimeSlotType">
              <v:lk-combobox field="sca.TimeSlotType" lookup="<%=LkSN.SaleCapacityTimeSlotType%>" allowNull="false" hideItems="<%=LookupManager.getArray(LkSNSaleCapacityTimeSlotType.Always)%>" enabled="<%=canEdit%>"/>
            </v:form-field>
            <v:form-field caption="@Common.FromDate">
              <v:input-text type="datepicker" field="sca.ValidDateFrom" placeholder="@Common.Always" enabled="<%=canEdit%>"/>
              &nbsp;&nbsp;&nbsp;<v:itl key="@Common.To" transform="lowercase"/>&nbsp;&nbsp;&nbsp;
              <v:input-text type="datepicker" field="sca.ValidDateTo" placeholder="@Common.Always" enabled="<%=canEdit%>"/>
            </v:form-field>
            <v:form-field caption="@SaleCapacity.AccountTags" hint="@SaleCapacity.AccountTagsHint">
              <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.Organization); %>
              <v:multibox field="sca.AccountTagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName" enabled="<%=canEdit%>"/>
            </v:form-field>
          </v:widget-block>
          <v:widget-block>
            <v:db-checkbox field="sca.Enabled" value="true" caption="@Common.Enabled" enabled="<%=canEdit%>"/>
          </v:widget-block>
        </v:widget>
        
        <v:grid>
          <thead>
            <tr>
              <td><v:grid-checkbox header="true"/></td>
              <td width="30%"><v:itl key="@Common.Quantity"/></td>
              <td width="70%"><v:itl key="@Product.ProductTags"/> <v:hint-handle hint="@SaleCapacity.ProductTagsHint"/></td>
              <td>&nbsp;</td>
            </tr>
          </thead>
          <tbody id="tbody-sca">
          </tbody>
          <tbody>
            <tr>
              <td colspan="100%">
                <v:button id="btn-sca-add" caption="@Common.Add" fa="plus" enabled="<%=canEdit%>"/>
                <v:button id="btn-sca-del" caption="@Common.Remove" fa="minus" enabled="<%=canEdit%>"/>
              </td>
            </tr>
          </tbody>
        </v:grid>
      </v:tab-content>
    </v:tab-item-embedded>
  
    <v:tab-item-embedded tab="tabs-history" caption="@Common.History" include="<%=!pageBase.isNewItem()%>">
      <jsp:include page="../../common/page_tab_historydetail.jsp"/>
    </v:tab-item-embedded>
  </v:tab-group>
    
  <template id="template-sca-row">
    <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
    <tr class="grid-row">
      <td><v:grid-checkbox/></td>
      <td><v:input-text clazz="sca-quantity" enabled="<%=canEdit%>"/></td>
      <td>
        <v:combobox clazz="sca-producttags" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName"/>
      </td>
      <td>
        <% if (canEdit) { %>
          <span class="row-hover-visible"><i class="fa fa-bars drag-handle"></i>
        <% } %>
      </td>
    </tr>
  </template>


<script>
$(document).ready(function() {
  var $dlg = $("#salecapacityaccount-dialog");
  var $tbody = $dlg.find("#tbody-sca");
  var sca = <%=sca.getJSONString()%>;

  $tbody.sortable({handle:".drag-handle", helper:fixHelper});

  $dlg.find("#btn-sca-add").click(_add);
  $dlg.find("#btn-sca-del").click(_remove);
  
  for (const detail of (sca.DetailList || [])) 
    _add(detail);
  
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      <% if (canEdit) { %>
        dialogButton("@Common.Save", _save),
      <% } %>
      dialogButton("@Common.Cancel", doCloseDialog)
    ];
  });
  
  function _add(item) {
    var template = $dlg.find("#template-sca-row")[0].content.firstElementChild;
    var $tr = $(template).clone().appendTo($tbody);
    var $tags = $tr.find(".sca-producttags").initMultiBox();

    if (item) {
      $tr.find(".sca-quantity").val(item.Quantity);
      $tags[0].selectize.setValue(item.ProductTagIDs);
    }
  }
  
  function _remove() {
    $tbody.find(".cblist:checked").closest("tr").remove();
  }
  
  function _save() {
    var reqDO = {
      SaleCapacityAccount: {
        SaleCapacityAccountId: <%=sca.SaleCapacityAccountId.getJsString()%>,
        TimeSlotType: $dlg.find("#sca\\.TimeSlotType").val(),
        ValidDateFrom: $dlg.find("#sca\\.ValidDateFrom-picker").getXMLDate(),
        ValidDateTo: $dlg.find("#sca\\.ValidDateTo-picker").getXMLDate(),
        Enabled: $dlg.find("#sca\\.Enabled").isChecked(),
        AccountTagIDs: $dlg.find("#sca\\.AccountTagIDs").val(),
        DetailList: []
      }  
    };
    
    $tbody.find("tr").each(function() {
      var $tr = $(this);
      reqDO.SaleCapacityAccount.DetailList.push({
        Quantity:  $tr.find(".sca-quantity").val(),
        ProductTagIDs:  $tr.find(".sca-producttags").val()
      });
    });
    
    snpAPI.cmd("SaleCapacity", "SaveSaleCapacityAccount", reqDO).then(ansDO => {
      triggerEntityChange(<%=LkSNEntityType.SaleCapacityAccount.getCode()%>);
      $dlg.dialog("close");
    });
  }
});
</script>  

</v:dialog>