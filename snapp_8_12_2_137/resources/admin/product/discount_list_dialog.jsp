<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
String sql =
    "select" + JvString.CRLF +
    " (case" + JvString.CRLF +
    "   when SID.PromoProductId = "+ JvString.sqlStr(BLBO_DBInfo.getSytemPromoId_MembershipPointDisc()) + JvString.CRLF +
    "   then 'membershippoint.png'" + JvString.CRLF +
    "   else 'promorule.png'" + JvString.CRLF +
    " end) as IconName," + JvString.CRLF +
    "  SID.PromoProductId," + JvString.CRLF +
    "  P.ProductName as PromoProductName," + JvString.CRLF +
    "  Coalesce(SIDP.DiscountAmount, SID.DiscountAmount) as DiscountAmount," + JvString.CRLF +
    "  SID.DiscountAmount," + JvString.CRLF +
    "  SIDP.DiscountPoints," + JvString.CRLF +
    "  SIDP.MembershipPointId," + JvString.CRLF +
    "  ACC.AccountId," + JvString.CRLF +
    "  ACC.EntityType," + JvString.CRLF +
    "  Coalesce(ACC.DisplayName, " + JvString.sqlStr(pageBase.getLang().Account.AnonymousAccount.getText()) + ") as AccountName" + JvString.CRLF +
    "from" + JvString.CRLF +
	"  tbSaleItemDiscount SID left join" + JvString.CRLF +
	"  tbProduct P on P.ProductId=SID.PromoProductId left join" + JvString.CRLF +
	"  tbSaleItemDiscountPoint SIDP on SIDP.SaleItemId=SID.SaleItemId and SIDP.PromoProductId=SID.PromoProductId left join" + JvString.CRLF +
	"  tbTicketMediaMatch TMM on TMM.TicketMediaMatchId=SIDP.PortfolioId left join" + JvString.CRLF +
	"  tbAccount ACC on ACC.AccountId=TMM.AccountId" + JvString.CRLF +   
	"where" + JvString.CRLF +
	"SID.SaleItemId=" + JvString.sqlStr(pageBase.getNullParameter("SaleItemId"));
JvDataSet ds = pageBase.getDB().executeQuery(sql);
request.setAttribute("ds", ds);
%>

<v:dialog id="discount_list_dialog" title="@Product.Discounts" width="800" autofocus="false">
  
<v:grid>
  <thead>
    <tr>
      <td>&nbsp;</td>
      <td width="50%"><v:itl key="@Common.Name"/><br/>
         <v:itl key="@Account.Account"/></td>
      <td width="50%"><v:itl key="@Common.Amount"/><br/>
         <v:itl key="@Product.MembershipPoints"/></td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row dataset="ds">
	  <td><v:grid-icon name='<%=ds.getField("IconName").getString()%>'/></td>
      <td>
        <a href="<v:config key="site_url"/>/admin?page=promorule&id=<%=ds.getField("PromoProductId").getHtmlString()%>"><%=ds.getField("PromoProductName").getHtmlString()%></a><br/>
        <span class="list-subtitle">
	      <% if (ds.getField("AccountId").isNull()) { %>
	        <v:itl key="@Account.AnonymousAccount"/>
	      <% } else { %>
	        <snp:entity-link entityType="<%=ds.getField(\"EntityType\")%>" entityId="<%=ds.getField(\"AccountId\")%>"><%=ds.getField("AccountName").getHtmlString()%></snp:entity-link>
	      <% } %>
        </span>
      </td>
      <td>
      	<%=pageBase.formatCurrHtml(ds.getField("DiscountAmount"))%><br/>
        <span class="list-subtitle">
	      <% if (ds.getField("MembershipPointId").isNull()) { %>
	        &mdash;
	      <% } else { %>
      	  <%=pageBase.getBL(BLBO_RewardPoint.class).formatRewardPointAmount(ds.getField("MembershipPointId").getString(), ds.getField("DiscountPoints").getMoney())%>
	      <% } %>
        </span>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>

<script>
var dlg = $("#discount_list_dialog");
dlg.on("snapp-dialog", function(event, params) {
  params.buttons = {
    <v:itl key="@Common.Close" encode="JS"/>: doCloseDialog
  };
});
</script>

</v:dialog>


