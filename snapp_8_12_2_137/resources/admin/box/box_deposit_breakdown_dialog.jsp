<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
String boxDepositId = pageBase.getNullParameter("boxDepositId");
String pluginId = pageBase.getNullParameter("pluginId");
String paymentMethodName = pageBase.getNullParameter("paymentMethodName");
String currencyISO = pageBase.getNullParameter("currencyISO");
String totalAmount = pageBase.getNullParameter("totalAmount");

JvDataSet dsBreakdown = pageBase.getBL(BLBO_Box.class).getBoxDepositBreakdown(boxDepositId, pluginId, currencyISO);
%>

<v:dialog id="box_deposit_breakdown_dialog" icon="box.png" title="Breakdown" width="700" height="600" autofocus="false">
  <v:widget>
    <v:widget-block>
      <v:itl key="@Payment.PaymentMethod"/>
      <span class="recap-value"><%=paymentMethodName%></span><br/>
      <v:itl key="@Currency.Currency"/>
      <span class="recap-value"><%=currencyISO%></span><br/>
      <v:itl key="@Common.Amount"/>
      <span class="recap-value"><%=totalAmount%></span><br/>
    </v:widget-block>
  </v:widget>
	<v:grid id="depositbreakdown-grid">
	  <tr class="header">
	    <td width="10%">
	      <v:itl key="Denomination"/>
	    </td>
	    <td width="75%" align="right" nowrap>
	      <v:itl key="Quantity"/>
	    </td>
	    <td width="15%" align="right" nowrap>
	      <v:itl key="Total"/> 
	    </td>
	  
	  </tr>
	  <v:grid-row dataset="<%=dsBreakdown%>" groupFieldName="FundCategory" groupLabelFieldName="FundCategoryDesc">
	    <% JvCurrency currFormatter = new JvCurrency(dsBreakdown.getField("CurrencyFormat").getInt(), dsBreakdown.getField("CurrencySymbol").getString(), currencyISO, dsBreakdown.getField("RoundDecimals").getInt(), pageBase.getRights().DecimalSeparator.getString(), pageBase.getRights().ThousandSeparator.getString()); %>
	    <td align="right" nowrap><%=currFormatter.formatHtml(dsBreakdown.getField("Denomination").getMoney())%></td>
	    <td align="right" nowrap><%=dsBreakdown.getField("Quantity").getString()%></td>
	    <td align="right" nowrap><%=currFormatter.formatHtml(dsBreakdown.getField("TotalAmount").getMoney())%></td>
	  </v:grid-row>
	</v:grid>
	
<script>
	var dlg = $("#box_deposit_breakdown_dialog");
	dlg.on("snapp-dialog", function(event, params) {
	  params.buttons = {
	    <v:itl key="@Common.Close" encode="JS"/>: doCloseDialog
	  };
	});
</script>	
</v:dialog>