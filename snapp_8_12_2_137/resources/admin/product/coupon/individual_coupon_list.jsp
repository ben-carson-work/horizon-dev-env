<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageIndividualCouponList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
String defaultLocationId = null;
if (!rights.AuditLocationFilter.isLookup(LkSNAuditLocationFilter.All)) 
  defaultLocationId = rights.MasterLocationId.isNull(pageBase.getSession().getLocationId()); 

String defaultFromToDate = pageBase.getBrowserFiscalDate().getXMLDate();
pageBase.setDefaultParameter("FromDate", defaultFromToDate);
pageBase.setDefaultParameter("ToDate", defaultFromToDate);
%>

<jsp:include page="/resources/common/header.jsp"/>
<jsp:include page="/resources/admin/product/coupon/individual_coupon_js.jsp"/>
<v:page-title-box/>

<v:last-error/>

<script>
  function search() {
    var couponCode = $("#CouponCode").val();
  	var dateFrom = $("#FromDate-picker").datepicker("getDate");
  	var dateTo = $("#ToDate-picker").datepicker("getDate");
	
    if (couponCode!="" || checkMaxDateRange(dateFrom, dateTo, <%=rights.SearchesMaxDateRange.getInt()%>)) {
      setGridUrlParam("#coupon-grid", "CouponCode", couponCode);
      setGridUrlParam("#coupon-grid", "FromDate", $("#FromDate-picker").getXMLDate());
      setGridUrlParam("#coupon-grid", "ToDate", $("#ToDate-picker").getXMLDate());
      setGridUrlParam("#coupon-grid", "LocationId", $("#LocationId").val());
      changeGridPage("#coupon-grid", "first");
    }
  }
</script>

<div id="expdate-dialog" class="v-hidden" title="<v:itl key="@Coupon.IndividualCouponChangeExpDate"/>">
  <v:input-text type="datepicker" field="NewExpDatePicker" style="width:105px"/>
</div>

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <v:button caption="@Common.Search" fa="search" href="javascript:search()" />
      <span class="divider"></span>
      <v:button caption="@Common.Issue" fa="plus" href="javascript:showPromotionPickupDialog()" enabled="<%=rights.Coupons.getOverallCRUD().canCreate()%>"/>
      <div class="btn-group">
        <v:button id="action-btn" caption="@Common.Actions" fa="flag" dropdown="true"/>
        <v:popup-menu bootstrap="true">
          <v:popup-item id="blockStatus-btn" caption="@Common.Block" enabled="<%=rights.Coupons.getOverallCRUD().canUpdate()%>"/>
          <v:popup-item id="unblockStatus-btn" caption="@Common.Unblock" enabled="<%=rights.Coupons.getOverallCRUD().canUpdate()%>"/>
          <v:popup-item id="voidStatus-btn" caption="@Common.Void" enabled="<%=rights.Coupons.getOverallCRUD().canDelete()%>"/>
          <v:popup-item id="expdate-btn" caption="@Account.Credit.ExptDate" enabled="<%=rights.Coupons.getOverallCRUD().canUpdate()%>"/>
        </v:popup-menu>
      </div>
      <span class="divider"></span>
      <v:button caption="@Common.Import" fa="sign-in" href="javascript:asyncDialogEasy('product/coupon/individual_coupon_import_dialog')" enabled="<%=rights.Coupons.getOverallCRUD().canCreate()%>" />
      
      <v:pagebox gridId="coupon-grid"/>
    </div>
  
    <div class="tab-content">
      <div class="profile-pic-div">
        <div class="v-filter-container">
          <div class="form-toolbar">
            <input type="text" id="CouponCode" class="form-control default-focus v-filter-code" placeholder="<v:itl key="@Coupon.CouponCode"/>" onkeypress="if (event.keyCode == KEY_ENTER) {search();return false;}"/>     
          </div>
  
          <div class="v-filter-all-condition">
            <v:widget caption="@Common.DateRange">
              <v:widget-block>
                <table style="width:100%">
                  <tr>
                    <td>
                      &nbsp;<v:itl key="@Account.Credit.IssuedFrom"/><br/>
                      <v:input-text type="datepicker" field="FromDate"/>
                    </td>
                    <td>&nbsp;</td>
                    <td>
                      &nbsp;<v:itl key="@Account.Credit.IssuedTo"/><br/>
                      <v:input-text type="datepicker" field="ToDate"/>
                    </td>
                  </tr>
                </table>
              </v:widget-block>
            </v:widget>
            <v:widget caption="@Account.Location">
              <v:widget-block>
                <v:itl key="@Account.Location"/><br/>
                <snp:dyncombo id="LocationId" entityType="<%=LkSNEntityType.Location%>" auditLocationFilter="true" allowNull="<%=rights.AuditLocationFilter.isLookup(LkSNAuditLocationFilter.All)%>" entityId="<%=defaultLocationId%>"/>
              </v:widget-block>
            </v:widget>
          </div>
        </div>
        
      </div>
      
      <div class="profile-cont-div">
        <% String params = "FromDate=" + defaultFromToDate + "&ToDate=" + defaultFromToDate + ((defaultLocationId == null) ? "" : "&LocationId=" + defaultLocationId); %>
        <v:async-grid id="coupon-grid" jsp="product/coupon/individual_coupon_grid.jsp" params="<%=params%>"/>
      </div>
    </div>
  </v:tab-item-embedded>
</v:tab-group>

<script>
  $("#LocationId").change(function() {
    search();
  });
  
  function showPromotionPickupDialog() {
    showLookupDialog({
      EntityType: <%=LkSNEntityType.PromoRule.getCode()%>,
      PromoRuleParams: {
        PromoRuleType: <%=LkSNPromoRuleType.IndividualCoupon.getCode()%>
      },
      onPickup: function(item) {
        asyncDialogEasy('product/coupon/individual_coupon_issue_dialog', 'id=' + item.ItemId);
      }
    });
  }
</script>

<jsp:include page="/resources/common/footer.jsp"/>
