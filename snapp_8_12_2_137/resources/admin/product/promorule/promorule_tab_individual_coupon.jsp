<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PagePromoRule" scope="request"/>
<jsp:useBean id="promo" class="com.vgs.snapp.dataobject.DOPromoRule" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/admin/product/coupon/individual_coupon_js.jsp"/>

<% int[] defaultStatusFilter = LookupManager.getIntArray(LkSNIndividualCouponStatus.Active, LkSNIndividualCouponStatus.Redeemed, LkSNIndividualCouponStatus.RedeemedStatic, LkSNIndividualCouponStatus.Blocked);%>

<script>
  function search() {
    setGridUrlParam("#coupon-grid", "CouponCode", $("#CouponCode").val());
    setGridUrlParam("#coupon-grid", "FromDate", $("#FromDate-picker").getXMLDate());
    setGridUrlParam("#coupon-grid", "ToDate", $("#ToDate-picker").getXMLDate());
    setGridUrlParam("#coupon-grid", "CouponStatus", $("[name='Status']").getCheckedValues());
    changeGridPage("#coupon-grid", "first");
  }
</script>

<div id="expdate-dialog" class="v-hidden" title="<v:itl key="@Coupon.IndividualCouponChangeExpDate"/>">
  <v:input-text type="datepicker" field="NewExpDatePicker" style="width:105px"/>
</div>

<div class="tab-toolbar">
  <v:button caption="@Common.Search" fa="search" href="javascript:search()" />
  <span class="divider"></span>
  
  <%
      String validityStart = (promo.ValidityDateFrom.isNull()) ? "" : "&ValidFrom=" + promo.ValidityDateFrom.getDateTime().getXMLDate();
    %>
  <%
    String validityEnd = (promo.ValidityDateTo.isNull()) ? "" : "&ValidTo=" + promo.ValidityDateTo.getDateTime().getXMLDate();
  %>
  <% String hrefCouponIssue = "javascript:asyncDialogEasy('product/coupon/individual_coupon_issue_dialog', 'id=" + pageBase.getId() + validityStart + validityEnd + "');"; %>
  <v:button caption="@Common.Issue" fa="plus" href="<%=hrefCouponIssue%>" enabled="<%=rights.Coupons.getOverallCRUD().canCreate()%>" />
  <div class="btn-group">
    <v:button id="action-btn" caption="@Common.Actions" fa="flag" dropdown="true"/>
    <v:popup-menu bootstrap="true">
      <v:popup-item id="blockStatus-btn" caption="@Common.Block"/>
      <v:popup-item id="unblockStatus-btn" caption="@Common.Unblock"/>
      <v:popup-item id="voidStatus-btn" caption="@Common.Void"/>
      <v:popup-item id="expdate-btn" caption="@Account.Credit.ExptDate"/>
    </v:popup-menu>
  </div>
  
  <v:pagebox gridId="coupon-grid"/>
</div>

<div class="tab-content">
  <div class="profile-pic-div">
    <div class="form-toolbar">
      <input type="text" id="CouponCode" class="form-control default-focus" placeholder="<v:itl key="@Coupon.CouponCode"/>" onkeypress="if (event.keyCode == KEY_ENTER) {search();return false;}"/>     
    </div>

    <v:widget caption="@Common.Filter" icon="filter.png">
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
    
    <v:widget caption="@Common.Status">
        <v:widget-block>
          <% for (LookupItem status : LkSN.IndividualCouponStatus.getItems()) { %>
          <v:db-checkbox field="Status" caption="<%=status.getDescription(pageBase.getLang())%>" value="<%=String.valueOf(status.getCode())%>" checked="<%=JvArray.contains(status.getCode(), defaultStatusFilter)%>" /><br/>
          <% } %>
        </v:widget-block>
      </v:widget>
    
  </div>
  
  <div class="profile-cont-div">
    <% String params = "ProductId=" + pageBase.getId()+"&CouponStatus="+JvArray.arrayToString(defaultStatusFilter, ",") ; %>
     <v:async-grid id="coupon-grid" jsp="product/coupon/individual_coupon_grid.jsp" params="<%=params%>"/> 
  </div>
</div>

