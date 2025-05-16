<%@page import="com.vgs.snapp.dataobject.DOCardType"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
boolean canEdit = rights.GenericSetup.getBoolean();
BLBO_CardType bl = pageBase.getBL(BLBO_CardType.class);
DOCardType cardType = pageBase.isNewItem() ? bl.prepareNewCardType() : bl.loadCardType(pageBase.getId());
request.setAttribute("cardType", cardType);

boolean active = cardType.CardTypeStatus.isLookup(LkSNCardTypeStatus.Active);
String checked = active ? " checked" : "";
%>

<v:dialog id="cardtype-dialog" tabsView="true" width="800" height="600" title="@Payment.CardType">

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-profile" caption="@Common.Profile" default="true">
    <div class="tab-content">
      <v:widget caption="@Common.General">
        <v:widget-block>
          <v:form-field caption="@Common.Code" mandatory="true">
            <v:input-text field="cardType.CardTypeCode" enabled="<%=canEdit%>"/>
          </v:form-field>
          <v:form-field caption="@Common.Name" mandatory="true">
            <v:input-text field="cardType.CardTypeName" enabled="<%=canEdit%>"/>
          </v:form-field>
        </v:widget-block>
        <v:widget-block>
          <div><label><input type="checkbox" id="cardType.Active" name="cardType.Active" <%=checked%>> <v:itl key="@Common.Active"/></label></div>
        </v:widget-block>
      </v:widget>
      
      <v:grid>
        <thead>
          <tr>
            <td><v:grid-checkbox header="true"/></td>
            <td width="50%"><v:itl key="@Common.From"/></td>
            <td width="50%"><v:itl key="@Common.To"/></td>
          </tr>
        </thead>
        <tbody id="card-range-tbody">
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
      <jsp:include page="../common/page_tab_historydetail.jsp"/>
    </v:tab-item-embedded>
  <% } %>
</v:tab-group>

  
  
  <div id="card-range-templates" class="hidden">
    <table>
      <tr class="grid-row card-range-item">
        <td><v:grid-checkbox/></td>
        <td><input type="text" name="RangeFrom" class="form-control"/></td>
        <td><input type="text" name="RangeTo" class="form-control"/></td>
        <v:db-checkbox field="cardType.Enabled" caption="@Common.Enabled" value="true" enabled="<%=canEdit%>"/>
      </tr>
    </table>
  </div>
    
<script>

$(document).ready(function() {
  var $dlg = $("#cardtype-dialog");
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
    <% if (canEdit) { %>    
      <v:itl key="@Common.Save" encode="JS"/>: doSaveCardType,
    <% } %>
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    };
  });
  
  $dlg.find("#btn-add").click(addCardRange); 
  
  $dlg.find("#btn-del").click(function() {
    $dlg.find("#card-range-tbody .cblist:checked").closest("tr").remove();
  }); 
  
  <% for (DOCardType.DOCardTypeRange cardRange : cardType.CardRangeList) { %>
    addCardRange(<%=cardRange.getJSONString()%>);
  <% } %>
    
  function addCardRange(cardRange) {
    var $tr = $dlg.find("#card-range-templates .card-range-item").clone().appendTo($dlg.find("#card-range-tbody"));
    if (cardRange) {
      $tr.find("[name='RangeFrom']").val(cardRange.RangeFrom);
      $tr.find("[name='RangeTo']").val(cardRange.RangeTo);
    }
  }
  
  function doSaveCardType() {
    checkRequired($dlg, function() {
      var reqDO = {
        Command: "SaveCardType",
        SaveCardType: {
          CardType: {
            CardTypeId: <%=cardType.CardTypeId.getJsString()%>,
            CardTypeCode: $dlg.find("#cardType\\.CardTypeCode").val(),
            CardTypeName: $dlg.find("#cardType\\.CardTypeName").val(),
            CardTypeStatus: $("#cardType\\.Active").isChecked() ? <%=LkSNCardTypeStatus.Active.getCode()%> : <%=LkSNCardTypeStatus.Inactive.getCode()%>,
            CardRangeList: []
          }
        }
      };
      
      $dlg.find("#card-range-tbody tr").each(function(index, item) {
        var $tr = $(item);
        reqDO.SaveCardType.CardType.CardRangeList.push({
          RangeFrom: $tr.find("[name='RangeFrom']").val(),
          RangeTo: $tr.find("[name='RangeTo']").val()
        });
      });
      
      vgsService("CardType", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.CardType.getCode()%>);
        $dlg.dialog("close");
      }); 
    }) ;
  }
  
});
  
</script>

</v:dialog>