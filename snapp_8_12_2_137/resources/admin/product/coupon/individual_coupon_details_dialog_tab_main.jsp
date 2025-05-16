<%@page import="java.util.ArrayList"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%-- <%@page import="com.vgs.snapp.query.QryBO_Voucher.*"%>
<%@page import="com.vgs.snapp.dataobject.DOVoucher.*"%>
 --%><%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>
<%@ taglib uri="snp-tags" prefix="snp"%>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<% boolean canEdit = false;%>
<% 
  QueryDef qdef = new QueryDef(QryBO_IndividualCoupon.class);
  //Select
  qdef.addSelect(QryBO_IndividualCoupon.Sel.IndividualCouponCode);
  qdef.addSelect(QryBO_IndividualCoupon.Sel.IndividualCouponStatusDesc);
  qdef.addSelect(QryBO_IndividualCoupon.Sel.ProductName);
  qdef.addSelect(QryBO_IndividualCoupon.Sel.ProductCode);
  qdef.addSelect(QryBO_IndividualCoupon.Sel.ValidDateFrom);
  qdef.addSelect(QryBO_IndividualCoupon.Sel.ValidDateTo);
  qdef.addSelect(QryBO_IndividualCoupon.Sel.IssueFiscalDate);
  qdef.addSelect(QryBO_IndividualCoupon.Sel.CampaignCode);
  qdef.addSelect(QryBO_IndividualCoupon.Sel.AccountName);
  //Where
  qdef.addFilter(QryBO_IndividualCoupon.Fil.IndividualCouponId, pageBase.getId());
  JvDataSet ds = pageBase.execQuery(qdef);
  request.setAttribute("ds", ds); 
%>

<div class="tab-content">
<table class="recap-table" style="width:100%">
  <tr>
    <td width="50%" valign="top">
      <v:widget caption="@Common.Recap">
        <v:widget-block>
          <v:itl key="@Common.Code"/><span class="recap-value"><%=ds.getField(QryBO_IndividualCoupon.Sel.IndividualCouponCode).getHtmlString()%></span><br/>
          <v:itl key="@Common.Status"/><span class="recap-value"><%=ds.getField(QryBO_IndividualCoupon.Sel.IndividualCouponStatusDesc).getHtmlString()%></span><br/>
          <v:itl key="@Product.PromoRule"/><span class="recap-value"><%=ds.getField(QryBO_IndividualCoupon.Sel.ProductName).getHtmlString()%></span><br/>
          <span class="recap-value"><%=ds.getField(QryBO_IndividualCoupon.Sel.ProductCode).getHtmlString()%></span><br/>
        </v:widget-block>  
        <v:widget-block>
          <v:itl key="@Coupon.IssuedBy"/><span class="recap-value"><%=ds.getField(QryBO_IndividualCoupon.Sel.AccountName).isNull() ? "&mdash;" : ds.getField(QryBO_IndividualCoupon.Sel.AccountName).getHtmlString()%></span><br/>
          <v:itl key="@Coupon.CampaignCode"/><span class="recap-value"><%=ds.getField(QryBO_IndividualCoupon.Sel.CampaignCode).isNull() ? "&mdash;" : ds.getField(QryBO_IndividualCoupon.Sel.CampaignCode).getHtmlString()%></span><br/>
        </v:widget-block>  
      </v:widget>
    </td>
    <td width="50%">
      <v:widget caption="@Common.Validity">
        <v:widget-block>
          <v:itl key="@Common.CreationDate"/> <span class="recap-value"><%=pageBase.format(ds.getField(QryBO_IndividualCoupon.Sel.IssueFiscalDate), pageBase.getShortDateFormat())%></span><br/>
        </v:widget-block>
        <v:widget-block>    
          <v:itl key="@Common.ValidFrom"/> <span class="recap-value"><%=ds.getField(QryBO_IndividualCoupon.Sel.ValidDateFrom).isNull() ? "&mdash;" : pageBase.format(ds.getField(QryBO_IndividualCoupon.Sel.ValidDateFrom), pageBase.getShortDateFormat())%></span><br/>
          <v:itl key="@Common.ValidTo"/> <span class="recap-value"><%=ds.getField(QryBO_IndividualCoupon.Sel.ValidDateTo).isNull() ? "&mdash;" : pageBase.format(ds.getField(QryBO_IndividualCoupon.Sel.ValidDateTo), pageBase.getShortDateFormat())%></span><br/>        
        </v:widget-block>
      </v:widget>
    </td>
  </tr>
</table>
<br/>
</div>