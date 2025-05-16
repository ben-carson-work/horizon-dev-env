<%@page import="com.vgs.snapp.dataobject.DOTaxProfile"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
boolean canEdit = rights.SettingsTaxes.getBoolean();
BLBO_Tax bl = pageBase.getBL(BLBO_Tax.class);
DOTaxProfile taxProfile = pageBase.isNewItem() ? bl.prepareNewTaxProfile() : bl.loadTaxProfile(pageBase.getId());
request.setAttribute("taxProfile", taxProfile);
%>

<v:dialog id="taxprofile-dialog" tabsView="true" width="800" height="600" title="@Product.TaxProfile">

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-profile" caption="@Common.Profile" default="true">
    <div class="tab-content">
      <v:widget caption="@Common.General">
        <v:widget-block>
          <v:form-field caption="@Common.Code" mandatory="true">
            <v:input-text field="taxProfile.TaxProfileCode" enabled="<%=canEdit%>"/>
          </v:form-field>
          <v:form-field caption="@Common.Name" mandatory="true">
            <v:input-text field="taxProfile.TaxProfileName" enabled="<%=canEdit%>"/>
          </v:form-field>
        </v:widget-block>
      </v:widget>
      
      <v:grid>
        <thead>
          <tr>
            <td><v:grid-checkbox header="true"/></td>
            <td width="70%"><v:itl key="@Common.Name"/></td>
            <td width="30%"><v:itl key="@Product.TaxablePerc"/></td>
          </tr>
        </thead>
        <tbody id="tax-detail-tbody">
        </tbody>
        <tbody>
          <tr>
            <td colspan="100%">
              <v:button id="btn-add" caption="@Common.Add" fa="plus" enabled="<%=canEdit%>"/>
              <v:button id="btn-del" caption="@Common.Remove" fa="minus" enabled="<%=canEdit%>"/>
            </td>
          </tr>
        </tbody>
      </v:grid>
    </div>
  </v:tab-item-embedded>

  <% if (!pageBase.isNewItem() && rights.History.getBoolean()) { %>
    <v:tab-item-embedded tab="tabs-history" caption="@Common.History">
      <jsp:include page="common/page_tab_historydetail.jsp"/>
    </v:tab-item-embedded>
  <% } %>
</v:tab-group>

  
  
  <div id="tax-profile-templates" class="hidden">
    <table>
      <tr class="grid-row tax-item">
        <td><v:grid-checkbox/></td>
        <td><v:combobox name="TaxId" lookupDataSet="<%=pageBase.getBL(BLBO_Tax.class).getTaxDS()%>" captionFieldName="TaxName" idFieldName="TaxId" linkEntityType="<%=LkSNEntityType.Tax%>" allowNull="false" enabled="<%=canEdit%>"/></td>
        <td><input type="text" name="TaxablePerc" class="form-control" placeholder="100%"/></td>
      </tr>
    </table>
  </div>
    
<script>

$(document).ready(function() {
  var $dlg = $("#taxprofile-dialog");
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
    <% if (canEdit) { %>
      {
        text: itl("@Common.Save"),
        click: doSaveTaxProfile
      },
    <% } %>
      {
        text: itl("@Common.Cancel"),
        click: doCloseDialog
      }
    ];
  });
  
  $dlg.find("#btn-add").click(addTax); 
  
  $dlg.find("#btn-del").click(function() {
    $dlg.find("#tax-detail-tbody .cblist:checked").closest("tr").remove();
  }); 
  
  <% for (DOTaxProfile.DOTaxProfileItem tax : taxProfile.TaxList) { %>
    addTax(<%=tax.getJSONString()%>);
  <% } %>
  
  function addTax(tax) {
    var $tr = $dlg.find("#tax-profile-templates .tax-item").clone().appendTo($dlg.find("#tax-detail-tbody"));
    if (tax) {
      $tr.find("[name='TaxId']").val(tax.TaxId);
      $tr.find("[name='TaxablePerc']").val(tax.TaxablePerc);
      $tr.find("select").change();
    }
  }
  
  function doSaveTaxProfile() {
    checkRequired($dlg, function() {
      var reqDO = {
        Command: "SaveTaxProfile",
        SaveTaxProfile: {
          TaxProfile: {
            TaxProfileId: <%=taxProfile.TaxProfileId.getJsString()%>,
            TaxProfileCode: $dlg.find("#taxProfile\\.TaxProfileCode").val(),
            TaxProfileName: $dlg.find("#taxProfile\\.TaxProfileName").val(),
            TaxList: []
          }
        }
      };
      
      $dlg.find("#tax-detail-tbody tr").each(function(index, item) {
        var $tr = $(item);
        reqDO.SaveTaxProfile.TaxProfile.TaxList.push({
          TaxId: $tr.find("[name='TaxId']").val(),
          TaxablePerc: strToFloatDef($tr.find("[name='TaxablePerc']").val(), null)
        });
      });
      
      vgsService("Product", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.TaxProfile.getCode()%>);
        $dlg.dialog("close");
      }); 
    }) ;
  }
  
});
  
</script>

</v:dialog>