<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% List<DOPaymentData> list = pageBase.getBL(BLBO_Payment.class).getPaymentData(pageBase.getNullParameter("SaleId"), pageBase.getId()); %>

<v:dialog id="paymentdata_dialog" title="@Payment.PaymentData" width="1000" height="500">
  
  <v:grid>
    <thead>
      <tr>
        <td width="30%">
          <v:itl key="@Common.Name"/>
        </td>
        <td width="80%" valign="top">
          <v:itl key="@Common.Value"/>         
        </td>
      </tr>
    </thead>
    <tbody>
    <% for (DOPaymentData item : list) { %>
      <tr class="grid-row">
        <td><span class="list"><%=item.ParamName.getHtmlString()%></span></td>
        <td><span class="list"><%=item.ParamValue.getHtmlString()%></span></td>
      </tr>
    <% } %>
    </tbody>
  </v:grid>


<script>

$(document).ready(function() {
  $("#paymentdata_dialog").on("snapp-dialog", function(event, params) {
    params.buttons = [dialogButton("@Common.Close", doCloseDialog)];
  });
});

</script>

</v:dialog>
