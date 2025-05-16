<%@page import="java.util.ArrayList"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Voucher.*"%>
<%@page import="com.vgs.snapp.dataobject.DOVoucher.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>
<%@ taglib uri="snp-tags" prefix="snp"%>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<% boolean canEdit = false;%>

<% 
  QueryDef qdef = new QueryDef(QryBO_Voucher.class);
  //Select
  qdef.addSelect(QryBO_Voucher.Sel.VoucherId);
  qdef.addSelect(QryBO_Voucher.Sel.VoucherType);
  qdef.addSelect(QryBO_Voucher.Sel.VoucherStatus);
  qdef.addSelect(QryBO_Voucher.Sel.VoucherCode);
  qdef.addSelect(QryBO_Voucher.Sel.VoucherName);
  qdef.addSelect(QryBO_Voucher.Sel.VoucherDescription);
  qdef.addSelect(QryBO_Voucher.Sel.CreateDate);
  qdef.addSelect(QryBO_Voucher.Sel.ValidDateFrom);
  qdef.addSelect(QryBO_Voucher.Sel.ValidDateTo);
  qdef.addSelect(QryBO_Voucher.Sel.DocTemplateName);
  qdef.addSelect(QryBO_Voucher.Sel.QuantityMax);
  qdef.addSelect(QryBO_Voucher.Sel.AmountMax);
  qdef.addSelect(QryBO_Voucher.Sel.TotalAmount);
  qdef.addSelect(QryBO_Voucher.Sel.Active);
  qdef.addSelect(QryBO_Voucher.Sel.PartiallyRedeemable);
  qdef.addSelect(QryBO_Voucher.Sel.AccountName);
  qdef.addSelect(QryBO_Voucher.Sel.Printed);
  qdef.addSelect(QryBO_Voucher.Sel.PrintTransactionId);
  qdef.addSelect(QryBO_Voucher.Sel.PrintTransactionCode);
  //Where
  qdef.addFilter(QryBO_Voucher.Fil.VoucherId, pageBase.getId());
  JvDataSet ds = pageBase.execQuery(qdef);
  request.setAttribute("ds", ds); 
  
  ArrayList<DOVoucherItem> itemList = new ArrayList<DOVoucherItem>();
  
  int totRedeemedQty = 0;
  LookupItem voucherStatus = LkSN.VoucherStatus.getItemByCode(ds.getField(QryBO_Voucher.Sel.VoucherStatus));
  boolean showQty = !voucherStatus.isLookup(LkSNVoucherStatus.Issued);
  boolean showMinMax = voucherStatus.isLookup(LkSNVoucherStatus.Issued, LkSNVoucherStatus.PartiallyRedeemed);
  
  JvDataSet dsVoucherItems = pageBase.getDB().executeQuery(
      "select" + JvString.CRLF +
      "  VI.ProductId," + JvString.CRLF +
      "  P.ProductCode," + JvString.CRLF +
      "  P.ProductName," + JvString.CRLF +
      "  VI.QuantityMin," + JvString.CRLF +
      "  VI.QuantityMax," + JvString.CRLF +
      "  VI.Quantity," + JvString.CRLF +
      "  VI.UnitPrice" + JvString.CRLF +
      "from" + JvString.CRLF +
      "  tbVoucherItem VI left join" + JvString.CRLF +
      "  tbProduct P on P.ProductId=VI.ProductId" + JvString.CRLF +
      "where VI.VoucherId=" + JvString.sqlStr(pageBase.getId()));
  try {
    itemList.clear();
    while (!dsVoucherItems.isEof()) {
      DOVoucher.DOVoucherItem item = new DOVoucher.DOVoucherItem();
      item.ProductId.assign(dsVoucherItems.getField("ProductId"));
      item.ProductCode.assign(dsVoucherItems.getField("ProductCode"));
      item.ProductName.assign(dsVoucherItems.getField("ProductName"));
      item.QuantityMin.assign(dsVoucherItems.getField("QuantityMin"));
      item.QuantityMax.assign(dsVoucherItems.getField("QuantityMax"));
      item.Quantity.assign(dsVoucherItems.getField("Quantity"));
      item.UnitPrice.assign(dsVoucherItems.getField("UnitPrice"));
      itemList.add(item);
      
      if (!voucherStatus.isLookup(LkSNVoucherStatus.Committed))
        totRedeemedQty += item.Quantity.getInt();
      
      dsVoucherItems.next();
    }
  }
  finally {
    dsVoucherItems.dispose();
  }
%>

<div class="tab-content">
<table class="recap-table" style="width:100%">
  <tr>
    <td width="50%" valign="top">
      <v:widget caption="@Common.Recap">
        <v:widget-block>
          <v:itl key="@Account.Credit.IssuedFrom"/><span class="recap-value"><%=ds.getField(QryBO_Voucher.Sel.AccountName).getHtmlString()%></span><br/>
          <v:itl key="@Common.Code"/><span class="recap-value"><%=ds.getField(QryBO_Voucher.Sel.VoucherCode).getHtmlString()%></span><br/>
          <v:itl key="@Common.Name"/><span class="recap-value"><%=ds.getField(QryBO_Voucher.Sel.VoucherName).getHtmlString()%></span><br/>
          <v:itl key="@Common.Description"/><span class="recap-value"><%=ds.getField(QryBO_Voucher.Sel.VoucherDescription).getHtmlString()%></span><br/>
        </v:widget-block>
        <v:widget-block>
          <v:itl key="@Common.Type"/><span class="recap-value"><%=LkSN.VoucherType.getItemByCode(ds.getField(QryBO_Voucher.Sel.VoucherType)).getDescription(pageBase.getLang())%></span><br/>
          <v:itl key="@Common.Status"/><span class="recap-value"><%=LkSN.VoucherStatus.getItemByCode(ds.getField(QryBO_Voucher.Sel.VoucherStatus)).getDescription(pageBase.getLang())%></span><br/>
          <% if (ds.getField(QryBO_Voucher.Sel.Active).getBoolean()) { %>      
            <span class="recap-value"><v:itl key="@Common.Active"/></span><br/>
          <% } else { %>
            <span class="recap-value" style="color:var(--base-red-color)"><v:itl key="@Common.Blocked"/></span><br/>
          <% } %>
          <v:itl key="@Common.Printed"/>
          <span class="recap-value">
          <% if (ds.getField(QryBO_Voucher.Sel.Printed).getBoolean()) { %>
            <% if (!ds.getField(QryBO_Voucher.Sel.PrintTransactionId).isNull()) { %>
              <snp:entity-link entityId="<%=ds.getField(QryBO_Voucher.Sel.PrintTransactionId).getString()%>" entityType="<%=LkSNEntityType.Transaction%>">
                <%=ds.getField(QryBO_Voucher.Sel.PrintTransactionCode).getHtmlString()%>
              </snp:entity-link>
            <% } else { %>
              <v:itl key="@Common.Yes"/>
            <% } %>
          <% } else { %>
            <v:itl key="@Common.No"/>
          <% } %>
          </span><br/>
          <v:itl key="@Voucher.PartiallyRedeemable"/>
          <span class="recap-value">
          <% if (ds.getField(QryBO_Voucher.Sel.PartiallyRedeemable).getBoolean()) { %>
            <v:itl key="@Common.Yes"/>
          <% } else { %>
            <v:itl key="@Common.No"/>
          <% } %>
          </span><br/>
          <v:itl key="@Voucher.RedeemedQty"/><span class="recap-value">
          <% if (!ds.getField(QryBO_Voucher.Sel.QuantityMax).isNull()) { %>
          <%=totRedeemedQty%>&nbsp;/&nbsp;<%=ds.getField(QryBO_Voucher.Sel.QuantityMax).getHtmlString()%>
          <% } else { %>
          <%=totRedeemedQty%>&nbsp;/&nbsp;<v:itl key="@Common.Unlimited"/>
          <% } %>
          </span><br/>
          <v:itl key="@Voucher.CommittedAmount"/><span class="recap-value">
          <% if (!ds.getField(QryBO_Voucher.Sel.AmountMax).isNull()) { %>
          <%=pageBase.formatCurrHtml(ds.getField(QryBO_Voucher.Sel.TotalAmount))%>&nbsp;/&nbsp;<%=pageBase.formatCurrHtml(ds.getField(QryBO_Voucher.Sel.AmountMax))%>
          <% } else { %>
          <%=pageBase.formatCurrHtml(ds.getField(QryBO_Voucher.Sel.TotalAmount))%>&nbsp;/&nbsp;<v:itl key="@Common.Unlimited"/>
          <% } %>
          </span><br/>
        </v:widget-block>
        <v:widget-block>
          <v:itl key="@Common.Template"/><span class="recap-value"><%=ds.getField(QryBO_Voucher.Sel.DocTemplateName).getHtmlString()%></span><br/>
        </v:widget-block>
      </v:widget>
    </td>
    <td width="50%">
      <v:widget caption="@Common.Validity">
        <v:widget-block>
          <v:itl key="@Common.CreationDate"/> <span class="recap-value"><%=pageBase.format(ds.getField(QryBO_Voucher.Sel.CreateDate), pageBase.getShortDateFormat())%></span><br/>
        </v:widget-block>
        <v:widget-block>    
          <v:itl key="@Common.ValidFrom"/> <span class="recap-value"><%=pageBase.format(ds.getField(QryBO_Voucher.Sel.ValidDateFrom), pageBase.getShortDateFormat())%></span><br/>
          <v:itl key="@Common.ValidTo"/> <span class="recap-value"><%=pageBase.format(ds.getField(QryBO_Voucher.Sel.ValidDateTo), pageBase.getShortDateFormat())%></span><br/>        
        </v:widget-block>
      </v:widget>
    </td>
  </tr>
</table>

<v:grid id="voucher-item-grid">
  <thead>
  <v:grid-title caption="@Common.Items"/>
    <tr>
      <td><v:itl key="@Product.ProductType"/></td>
      <% if (showMinMax) { %>
      <td align="right"><v:itl key="@Common.QuantityMin"/></td>
      <td align="right"><v:itl key="@Common.QuantityMax"/></td>
      <% } %>
      <% if (showQty) { %>
      <td align="right">
        <% if (voucherStatus.isLookup(LkSNVoucherStatus.PartiallyRedeemed)) { %>
        <v:itl key="@Voucher.RedeemedQty"/>
        <% } else {%>
        <v:itl key="@Common.Quantity"/>
        <% } %>
      </td>
      <% } %>
      <td align="right"><v:itl key="@Reservation.UnitAmount"/></td>
    </tr>
  </thead>
  <tbody id="voucher-item-body">
    <% for (DOVoucher.DOVoucherItem item : itemList) { %>
      <tr>
        <td valign="top">
          <snp:entity-link entityId="<%=item.ProductId.getString()%>" entityType="<%=LkSNEntityType.ProductType%>"><%=item.ProductName.getHtmlString()%></snp:entity-link>
        </td>
        <% if (showMinMax) { %>
        <td align="right"><%=item.QuantityMin.getHtmlString()%></td>
        <td align="right"><%=item.QuantityMax.getHtmlString()%></td>
        <% } %>
        <% if (showQty) { %>
        <td align="right"><%=item.Quantity.getHtmlString()%></td>
        <% } %>
        <td align="right"><%=pageBase.formatCurrHtml(item.UnitPrice)%></td>
      </tr>
    <% } %>
  </tbody>
</v:grid>
<br/>
</div>