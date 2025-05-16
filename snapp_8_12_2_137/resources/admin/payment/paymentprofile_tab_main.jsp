<%@page import="javax.swing.plaf.metal.MetalScrollPaneUI"%>
<%@page import="com.vgs.snapp.dataobject.DOPaymentProfile"%>
<%@page import="com.vgs.snapp.web.bko.library.BLBO_Installment"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PagePaymentProfile" scope="request"/>
<jsp:useBean id="paymentProfile" class="com.vgs.snapp.dataobject.DOPaymentProfile" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% boolean canEdit = rights.SettingsPayments.getBoolean(); %>

<v:page-form id="paymentprofile-form">
<v:input-text type="hidden" field="paymentProfile.PaymentProfileId"/>

<div class="tab-toolbar">
  <v:button caption="@Common.Save" fa="save" onclick="doSavePaymentProfile()" enabled="<%=canEdit%>"/>
  <% if (!pageBase.isNewItem()) {%>
    <span class="divider"></span>
    <v:button caption="@Common.Duplicate" fa="clone" href="javascript:doDuplicate()" enabled="<%=canEdit%>"/>
    <span class="divider"></span>
    <% String hrefExport = ConfigTag.getValue("site_url") + "/admin?page=export&EntityIDs=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.PaymentProfile.getCode(); %> 
    <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" href="<%=hrefExport%>"/>
  <%} %>
</div>

<div class="tab-content">
<v:last-error/>
  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="@Common.Code" mandatory="true">
        <v:input-text field="paymentProfile.PaymentProfileCode" enabled="<%=canEdit%>" />
      </v:form-field>
      <v:form-field caption="@Common.Name" mandatory="true">
        <v:input-text field="paymentProfile.PaymentProfileName" enabled="<%=canEdit%>" />
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:db-checkbox caption="@Common.Active" value="true" field="paymentProfile.Active" enabled="<%=canEdit%>"/>
    </v:widget-block>
  </v:widget>  
    
  <v:widget caption="@Payment.RewardPoints">
    <v:widget-block> 
      <v:form-field caption="@Common.Options">
        <select id="paymentProfile.MembershipPointOptions" class="form-control">
          <option value="notallowed"><v:itl key="@Common.NotAllowed"/></option>
          <option value="restricted"><v:itl key="@Common.Restricted"/></option>
          <option value="all"><v:itl key="@Common.All"/></option>
        </select>
      </v:form-field>
    </v:widget-block>
    
    <v:widget-block id="membershippoint-options"> 
    <v:form-field caption="@Payment.RestrictMembershipPoints"> 
        <v:multibox 
            field="paymentProfile.MembershipPointIDs" 
            lookupDataSet="<%=pageBase.getBL(BLBO_RewardPoint.class).getRewardPointDS()%>" 
            idFieldName="MembershipPointId" 
            captionFieldName="MembershipPointName" 
            enabled="<%=canEdit%>"/>
    </v:form-field>
    </v:widget-block>
  </v:widget>

  <v:widget caption="@Payment.PaymentMethods">
  <v:widget-block>
    <v:form-field caption="@Product.RestrictPaymentMethods" checkBoxField="paymentProfile.RestrictPaymentMethods" hint="@Product.RestrictPaymentMethodsHint">  
      <v:multibox 
          field="paymentProfile.PaymentMethodIDs" 
          lookupDataSet="<%=pageBase.getBL(BLBO_PayMethod.class).getPaymentMethodDS()%>" 
          idFieldName="PluginId" 
          captionFieldName="PluginDisplayName" 
          enabled="<%=canEdit%>"/>
    </v:form-field>
    </v:widget-block>
  </v:widget>

  <v:grid id="paymentprofile2instplan-grid">
    <thead>
      <v:grid-title caption="@Installment.InstallmentPlans"/>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="40%"><v:itl key="@Installment.InstallmentPlan"/></td>
        <td width="20%"><v:itl key="@Installment.DownPayment"/></td>
        <td width="20%"><v:itl key="@Installment.ProductFee"/></td>
        <td width="20%"><v:itl key="@Common.Calendar"/></td>
      </tr>
    </thead>
    <tbody id="instplan-grid-tbody">
    </tbody>
    <tbody>
      <tr>
        <td colspan="100%">
        <v:button fa="plus" caption="@Common.Add" onclick="showPlanPickupDialog()" enabled="<%=canEdit%>"/>
        <v:button fa="minus" caption="@Common.Remove" onclick="removePlans()" enabled="<%=canEdit%>"/>
        </td>
      </tr>
    </tbody>
  </v:grid>

  
  <div id="cal-combo-template" class="hidden">
    <% JvDataSet dsCalendar = pageBase.getBL(BLBO_Calendar.class).getCalendarDS((String)null); %>
    <v:combobox clazz="cal-combo" lookupDataSet="<%=dsCalendar%>" idFieldName="CalendarId" captionFieldName="CalendarName" linkEntityType="<%=LkSNEntityType.Calendar%>" enabled="<%=canEdit%>"/>
  </div>

</div>
</v:page-form>

<script>

$(document).ready(function() {
  $("#paymentProfile\\.MembershipPointOptions").change(refreshVisibility);
  
  if (<%=!paymentProfile.AllowMembershipPoints.getBoolean()%> && <%=!paymentProfile.RestrictMembershipPoints.getBoolean()%>) { 
   $('select>option:eq(0)').prop('selected', true); 
   $('select>option:eq(1)').prop('selected', false);
   $('select>option:eq(2)').prop('selected', false);
  }
  else
  {
   if (<%=paymentProfile.AllowMembershipPoints.getBoolean()%> && <%=paymentProfile.RestrictMembershipPoints.getBoolean()%>) {
     $('select>option:eq(0)').prop('selected', false);
     $('select>option:eq(1)').prop('selected', true); 
     $('select>option:eq(2)').prop('selected', false);
   }
   else
   {
     $('select>option:eq(1)').prop('selected', false);
     $('select>option:eq(0)').prop('selected', false);     
     $('select>option:eq(2)').prop('selected', true);
   }
  }    

  refreshVisibility();
 
  <% if (!pageBase.isNewItem()) {
  
      JvDataSet ds = pageBase.getBL(BLBO_Installment.class).getPaymentProfile2PlanDS(pageBase.getId());
        
      while (!ds.isEof()) { %>
        addPlan(
            <%=JvString.jsString(ds.getField("InstallmentPlanId").getString())%>,
            <%=JvString.jsString(ds.getField("InstallmentPlanCode").getString())%>,
            <%=JvString.jsString(ds.getField("InstallmentPlanName").getString())%>,
            encodePriceValue(<%=ds.getField("DownPaymentType").getInt()%>, <%=ds.getField("DownPaymentValue").getString()%>),
            encodePriceValue(<%=ds.getField("ProductFeeType").getInt()%>, <%=ds.getField("ProductFeeValue").getString()%>),
            <%=JvString.jsString(ds.getField("CalendarId").getString())%>
            );
        <% ds.next(); %>
      <% } %>
 <% } %>
});

function decodePriceValue(value) {
  var result = {
    type: null,
    value: null
  };
  value = value.replace(",", ".");
  if (value != "") {
    if (value.indexOf("%") < 0)
      result.type = <%=LkSNPriceValueType.Absolute.getCode()%>;
    else
      result.type = <%=LkSNPriceValueType.Percentage.getCode()%>;
    result.value = parseFloat(value.replace("%", ""));
    if (isNaN(result.value))
      result.value = 0;
  }
  return result;
}

function encodePriceValue(type, value) {
  if (type <= 0)
    return "";
  else 
    return value + ((type == <%=LkSNPriceValueType.Percentage.getCode()%>) ? "%" : "");
}

function refreshVisibility() {
  $("#membershippoint-options").setClass("hidden", $("#paymentProfile\\.MembershipPointOptions").val() != "restricted"); 
}

<%-- 
RestrictMembershipPoint is set to true when the restricted or the not allowed options are selected. 
The not allowed option forces the membership point list to be voided
If RestrictMembershipPoint is false then all the membership points are allowed
--%>

function doSavePaymentProfile() {
  checkRequired("#paymentprofile-form", function() {
    var restrictMemPoints = (($("#paymentProfile\\.MembershipPointOptions").val() == "restricted") && (($("#paymentProfile\\.MembershipPointIDs").val() != "")));

    var reqDO = {
        Command: "SavePaymentProfile",
        SavePaymentProfile: {
          PaymentProfile: {
            PaymentProfileId: <%=pageBase.isNewItem() ? null : "\"" + paymentProfile.PaymentProfileId.getHtmlString() + "\""%>,
            PaymentProfileCode: $("#paymentProfile\\.PaymentProfileCode").val(),
            PaymentProfileName: $("#paymentProfile\\.PaymentProfileName").val(),
            AllowMembershipPoints:  ($("#paymentProfile\\.MembershipPointOptions").val() == "all") || restrictMemPoints, 
            RestrictMembershipPoints:  restrictMemPoints, 
            RestrictPaymentMethods: $("[name='paymentProfile\\.RestrictPaymentMethods']").isChecked(),
            Active: $("#paymentProfile\\.Active").isChecked(),
            PaymentMethodIDs: $("[name='paymentProfile\\.RestrictPaymentMethods']").isChecked() ? $("#paymentProfile\\.PaymentMethodIDs").val() : [],
            MembershipPointIDs: $("#paymentProfile\\.MembershipPointOptions").val() == "restricted" ? $("#paymentProfile\\.MembershipPointIDs").val() : [],
            InstallmentPlanList: []
          }
        }
      };
    
    var trs = $("#instplan-grid-tbody tr");
    for (var i=0; i<trs.length; i++) {
      var tr = $(trs[i]);
      var downPayment = decodePriceValue(tr.find(".txt-downpayment").val());
      var productFee = decodePriceValue(tr.find(".txt-productfee").val());
      reqDO.SavePaymentProfile.PaymentProfile.InstallmentPlanList.push({
        InstallmentPlanId: tr.attr("data-InstallmentPlanId"),
        DownPaymentType: downPayment.type,
        DownPaymentValue: downPayment.value,
        ProductFeeType: productFee.type,
        ProductFeeValue: productFee.value,
        CalendarId: tr.find(".cal-combo").val()
      });
    }
    
    showWaitGlass();
    vgsService("PayMethod", reqDO, false, function(ansDO) {
      hideWaitGlass();
      entitySaveNotification(<%=LkSNEntityType.PaymentProfile.getCode()%>, ansDO.Answer.SavePaymentProfile.PaymentProfileId);
    });
  });
}

function showDuplicateResultDialog(id, code, name) {
  var dlgRes = $("<div class='duplicate-dialog'/>");
  dlgRes.append("Code or Name already used, new code and name are the ones below.<br/><br/>")
  dlgRes.append("<div><v:itl key="@Common.Code"/><span class='recap-value'>" + code + "</span><br/>")
  dlgRes.append("<v:itl key="@Common.Name"/><span class='recap-value'>" + name + "</span><br/></div>")

  dlgRes.dialog({
    title: <v:itl key="@Payment.NewPaymentProfileCreated" encode="JS"/>,
    modal: true,
    width: 450,
    height: 250,
    close: function() {
      dlgInput.remove()
    },
    buttons: {
      <v:itl key="@Common.Close" encode="JS"/>: function() {
        dlgRes.dialog("close");
        window.location = "<%=pageBase.getContextURL()%>?page=paymentprofile&id=" + id;
      }
    }
  });
}

function inputPaymentProfileDetails(paymentProfileCode, paymentProfileName) {
  var dlgInput = $("<div class='duplicate-input-dialog'/>");
  dlgInput.append("<div class='form-field'><div class='form-field-caption'><v:itl key='@Common.NewCode'/></div><div class='form-field-value'><input type='text' class='form-control' id='paymentProfile.CandidatePaymentProfileCode' name='paymentProfile.CandidateProductCode' value='" + paymentProfileCode + "'/></div></div>");
  dlgInput.append("<div class='form-field'><div class='form-field-caption'><v:itl key='@Common.NewName'/></div><div class='form-field-value'><input type='text' class='form-control' id='paymentProfile.CandidatePaymentProfileName' name='paymentProfile.CandidateProductName' value='" + paymentProfileName + "'/></div></div>");
  
  dlgInput.dialog({
    title: <v:itl key="@Payment.PaymentProfile" encode="JS"/>,
    modal: true,
    width: 550,
    height: 250,
    close: function() {
      dlgInput.remove()
    },
    buttons: {
      <v:itl key="@Common.Ok" encode="JS"/>: function() {
        var reqDODup = {
          Command: "DuplicatePaymentProfile",
          DuplicatePaymentProfile: {
            PaymentProfileId: <%=JvString.jsString(pageBase.getId())%>,
            CandidatePaymentProfileCode: $("#paymentProfile\\.CandidatePaymentProfileCode").val(),
            CandidatePaymentProfileName: $("#paymentProfile\\.CandidatePaymentProfileName").val(),
          }
        };
        dlgInput.dialog("close");

        vgsService("PayMethod", reqDODup, false, function(ansDODup) {
          if (ansDODup.Answer.DuplicatePaymentProfile.CandidatePaymentProfileCodeNameDifferent == true)
            showDuplicateResultDialog(ansDODup.Answer.DuplicatePaymentProfile.PaymentProfileId, ansDODup.Answer.DuplicatePaymentProfile.PaymentProfileCode, ansDODup.Answer.DuplicatePaymentProfile.PaymentProfileName);
          else
            window.location = "<v:config key="site_url"/>/admin?page=paymentprofile&id=" + ansDODup.Answer.DuplicatePaymentProfile.PaymentProfileId;
        });
      },
      <v:itl key="@Common.Cancel" encode="JS"/>: function() {
        dlgInput.dialog("close");
      }
    }
  });
}

function doDuplicate() {
  var reqDO = {
      Command: "GeneratePaymentProfileDuplicateCodeName",
      GeneratePaymentProfileDuplicateCodeName: {
        PaymentProfileCode: $("#paymentProfile\\.PaymentProfileCode").val(),
        PaymentProfileName: $("#paymentProfile\\.PaymentProfileName").val()
      }
  }
  
  vgsService("PayMethod", reqDO, false, function(ansDO) {
    inputPaymentProfileDetails(ansDO.Answer.GeneratePaymentProfileDuplicateCodeName.CandidatePaymentProfileCode, ansDO.Answer.GeneratePaymentProfileDuplicateCodeName.CandidatePaymentProfileName);
  });
}

function addPlan(id, code, name, downPayment, productFee, calendarId) {
  var sDisabled = <%=canEdit%> ? "" : " disabled='disabled'";

  var tr = $("<tr class='grid-row' data-InstallmentPlanId='" + id + "'/>").appendTo("#instplan-grid-tbody");
  var tdCB = $("<td/>").appendTo(tr);
  var tdPlan = $("<td/>").appendTo(tr);
  var tdDown = $("<td/>").appendTo(tr);
  var tdFee = $("<td/>").appendTo(tr);
  var tdCal = $("<td/>").appendTo(tr);
  tdCB.append("<input value='" + id + "' type='checkbox' class='cblist'>");
  tdPlan.html("[" + code + "] <a href=\"javascript:asyncDialogEasy('installment/plan_dialog', 'id=" + id + "')\">" + name + "</a>");
  tdDown.append("<input type='text' class='txt-downpayment form-control'" + sDisabled + "/>");
  tdFee.append("<input type='text' class='txt-productfee form-control'" + sDisabled + "/>");
  tdCal.append($("#cal-combo-template").html());
  
  if (downPayment)
    tdDown.find("input").val(downPayment);
  
  if (productFee)
    tdFee.find("input").val(productFee);
  
  if (calendarId)
    tdCal.find("select").val(calendarId);
  
  tr.find("input").attr("placeholder", "<v:itl key="@Common.Default" encode="utf-8"/>");
}

function showPlanPickupDialog() {
  showLookupDialog({
    EntityType: <%=LkSNEntityType.InstallmentPlan.getCode()%>,
    onPickup: function(item) {
      if ($("#paymentprofile2instplan-grid tr[data-InstallmentPlanId='" + item.ItemId + "']").length > 0) 
        showMessage("<v:itl key="@Installment.PlanAlreadyExistsError" encode="UTF-8"/>");
      else
        addPlan(item.ItemId, item.ItemCode, item.ItemName, "", "");
    }
  });
}

function removePlans() {
  $("#paymentprofile2instplan-grid tbody .cblist:checked").closest("tr").remove();
}








</script>