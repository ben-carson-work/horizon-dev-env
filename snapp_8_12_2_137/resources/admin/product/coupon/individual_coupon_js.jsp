<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="promo" class="com.vgs.snapp.dataobject.DOPromoRule" scope="request"/>

<script>
$(document).ready(function() {
  
  $("#blockStatus-btn").click(function(){
    setStatus(<%=LkSNIndividualCouponStatus.Blocked.getCode()%>);
  });
  
  $("#unblockStatus-btn").click(function(){
    setStatus(<%=LkSNIndividualCouponStatus.Active.getCode()%>);
  });
  
  $("#voidStatus-btn").click(function(){
    setStatus(<%=LkSNIndividualCouponStatus.Voided.getCode()%>);
  });
  
  $("#expdate-btn").click(function(event) {
    var ids = $("[name='IndividualCouponId']").getCheckedValues();
    if (ids == "")
      showMessage(<v:itl key="@Common.NoElementWasSelected" encode="JS"/>);
    else {
      $("#expdate-dialog").dialog({
        modal: true,
        width: 300,
        height: 350,
        buttons: {
          <v:itl key="@Common.Close" encode="JS"/>: function() {
            $(this).dialog("close");
          },
          <v:itl key="@Common.Ok" encode="JS"/>: function() {
            if (checkDateValidity()){
              $(this).dialog("close");
              setExpirationDate($("#NewExpDatePicker").val(), ids);
            }
          }
        }
      });
    }
  });
  
  function setStatus(status) {
    var ids = $("[name='IndividualCouponId']").getCheckedValues();
    if (ids == "")
      showMessage(<v:itl key="@Common.NoElementWasSelected" encode="JS"/>);
    else {
      confirmDialog(null, function() {
        var reqDO = {
          Command: "ChangeIndividualCouponStatus",
          ChangeIndividualCouponStatus: {
            IndividualCouponStatus: status,
            IndividualCouponIDs: ids
          }
        };
        
        if ($("#ind-coupon-grid-table").hasClass("multipage-selected")) {
          reqDO.ChangeIndividualCouponStatus.IndividualCouponIDs = null;            
          reqDO.ChangeIndividualCouponStatus.QueryBase64 = $("#ind-coupon-grid-table").attr("data-QueryBase64");            
        }
        
        vgsService("IndividualCoupon", reqDO, false, function(ansDO) {
          showAsyncProcessDialog(ansDO.Answer.ChangeIndividualCouponStatus.AsyncProcessId, function() {
            changeGridPage("#coupon-grid", "first");
          });
        });
      });  
    }
  } 

  /*
    this function return true if couponexpdate selected is between coupon valid dates   
  */
  function checkDateValidity(){
    <%String validityEnd = (promo.ValidityDateTo.isNull()) ? "" : promo.ValidityDateTo.getDateTime().getXMLDate();%> 
    <%String validityStart = (promo.ValidityDateFrom.isNull()) ? "" : promo.ValidityDateFrom.getDateTime().getXMLDate();%>
      var couponDateTo = new Date($("#NewExpDatePicker").val());
      var promoDateTo = new Date('<%=validityEnd%>');
      var promoDateFrom = new Date('<%=validityStart%>');
      
      if ( (<%=promo.ValidityDateTo.isNull()%> || couponDateTo <= promoDateTo ) &&
           (<%=promo.ValidityDateFrom.isNull()%> || couponDateTo >= promoDateFrom ) )
        return true;
      else{
        showMessage(<v:itl key="@Common.CouponExpDateError" encode="JS"/>);
        return false;
      }
  }
  
  function setExpirationDate(expDate, individualCouponIDs) {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "SetExpirationDate",
        SetExpirationDate: {
          ExpDate: expDate,
          IndividualCouponIDs: individualCouponIDs
        }
      };
      
      if ($("#ind-coupon-grid-table").hasClass("multipage-selected")) {
        reqDO.SetExpirationDate.IndividualCouponIDs = null;            
        reqDO.SetExpirationDate.QueryBase64 = $("#ind-coupon-grid-table").attr("data-QueryBase64");            
      }
      
      vgsService("IndividualCoupon", reqDO, false, function(ansDO) {
        showAsyncProcessDialog(ansDO.Answer.SetExpirationDate.AsyncProcessId, function() {
          changeGridPage("#coupon-grid", "first")
        });
      });
    });
  }
});

</script>