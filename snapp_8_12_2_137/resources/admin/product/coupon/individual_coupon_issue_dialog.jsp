<%@page import="com.vgs.web.library.BLBO_Account"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:dialog id="coupon_issue_dialog" icon="coupon.png" title="@Lookup.TransactionType.IndividualCouponIssue" autofocus="false" width="450" height="440">

<% 
String promotionId = pageBase.getId();
if (promotionId == null)
  throw new RuntimeException("Parameter PromotionId must be specified");

String dtXMLFrom = pageBase.getNullParameter("ValidFrom");
String dtXMLTo = pageBase.getNullParameter("ValidTo");
%>

<v:widget caption="@Common.General" icon="profile.png">
  <v:widget-block>
    <v:form-field caption="@Common.Quantity">
      <v:input-text type="text" field="coupon.Quantity"/>
    </v:form-field>
        <v:form-field caption="@Common.ValidFrom">
      <v:input-text type="datepicker" field="coupon.ValidFrom" placeholder="@Common.Unlimited"/>
    </v:form-field>
    <v:form-field caption="@Common.ValidTo">
      <v:input-text type="datepicker" field="coupon.ValidTo" placeholder="@Common.Unlimited"/>
    </v:form-field>
    <v:form-field caption="@Common.Organization">
      <v:combobox field="coupon.AccountId" lookupDataSet="<%=pageBase.getBL(BLBO_Account.class).getOrganizationDS()%>" idFieldName="AccountId" captionFieldName="DisplayName"/>
    </v:form-field>
    <v:form-field caption="@Coupon.CampaignCode">
      <v:input-text field="coupon.CampaignCode"/>
    </v:form-field>
    <v:form-field>      
      <v:db-checkbox field="coupon.Export" caption="Export coupon list" value="true" checked="false"/>
    </v:form-field>
  </v:widget-block>
</v:widget>


<script>
var dlg = $("#coupon_issue_dialog");
dlg.on("snapp-dialog", function(event, params) {
  params.buttons = [
    {
      text: <v:itl key="@Common.Generate" encode="JS"/>,
      click: doGenerate
    }, 
    {
      text: <v:itl key="@Common.Cancel" encode="JS"/>,
      click: doCloseDialog
    }                     
  ];
});

$(document).ready(function() {
  var dtFrom = $("#coupon\\.ValidFrom-picker").datepicker("setDate", xmlToDate("<%=dtXMLFrom%>"));
  var dtTo = $("#coupon\\.ValidTo-picker").datepicker("setDate", xmlToDate("<%=dtXMLTo%>"));
  $("#coupon\\.Quantity").val("1");

  dtFrom.change(function() {
    var xmlFrom = dtFrom.getXMLDate();
    var xmlTo = dtTo.getXMLDate();
    if (xmlFrom > xmlTo)
      dtTo.datepicker("setDate", dtFrom.datepicker("getDate"));
  });

  dtTo.change(function() {
    var xmlFrom = dtFrom.getXMLDate();
    var xmlTo = dtTo.getXMLDate();
    if ((xmlTo != "") && (xmlFrom > xmlTo))
      dtFrom.datepicker("setDate", dtTo.datepicker("getDate"));
  });
});


function doGenerate() {
  var qty = parseInt($("#coupon\\.Quantity").val());
  if (isNaN(qty) || (qty <= 0)) {
    showMessage("<v:itl key="@Common.InvalidQuantity" encode="UTF-8"/>", function() {
      $("#coupon\\.Quantity").focus();
    });
    
  }
  else if (!checkDates()){
    $("#coupon\\.ValidFrom-picker").datepicker("setDate", xmlToDate("<%=dtXMLFrom%>"));
    $("#coupon\\.ValidTo-picker").datepicker("setDate", xmlToDate("<%=dtXMLTo%>"));
  }
  else{
    var reqDO = {
      Command: "GenerateIndividualCoupons",
      GenerateIndividualCoupons: {
        PromoRuleId: <%=JvString.sqlStr(promotionId)%>, 
        Quantity: qty,
        ValidityFrom: $("#coupon\\.ValidFrom-picker").getXMLDateTime(),
        ValidityTo: $("#coupon\\.ValidTo-picker").getXMLDateTime(),
        AccountId: $("#coupon\\.AccountId").val(),
        CampaignCode: $("#coupon\\.CampaignCode").val()
      }
    };
    
    var exportCvs = $("#coupon\\.Export").isChecked();
    
    $("#coupon_issue_dialog").dialog("close");
    
    vgsService("Product", reqDO, false, function(ansDO) {
      var obj = {
          RefEntityType: null,
          RefEntityId: null
      };
      showAsyncProcessDialog(ansDO.Answer.GenerateIndividualCoupons.AsyncProcessId, function(obj){
        if (exportCvs)
          window.location = "<v:config key="site_url"/>" + "/admin?page=individual_coupon_list&action=csv-download&TransactionId=" + obj.RefEntityId;
        changeGridPage("#coupon-grid", "first");
      });
    });
  }
 
}
/*
 * this function verify that coupon dates are between promotion dates
 * return true if coupon dates are between promo dates
 */
function checkDates(){
  var promoFrom = new Date('<%=dtXMLFrom%>');
  var promoTo = new Date('<%=dtXMLTo%>');
  var couponTo = new Date( $("#coupon\\.ValidTo-picker").getXMLDate());
  var couponFrom = new Date( $("#coupon\\.ValidFrom-picker").getXMLDate());

  if ((<%=dtXMLFrom != null%> && (couponFrom < promoFrom) ) ||
      (<%=dtXMLTo != null%> && (couponTo > promoTo) )){
    showMessage(<v:itl key="@Common.CouponValidDateError" encode="JS"/>);
    return false
  }else
    return true;
}
</script>

</v:dialog>