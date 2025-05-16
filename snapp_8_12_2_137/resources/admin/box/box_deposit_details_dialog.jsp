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
List<DOBox.DOBoxDetail> list = pageBase.getBL(BLBO_Box.class).loadBoxDepositDetails(boxDepositId);
request.setAttribute("BoxDetailList", list);
%>

<v:dialog id="box_deposit_details_dialog" icon="box.png" title="@Box.DepositDetails" width="800" height="700" autofocus="false">
 
  <jsp:include page="/resources/admin/box/box_detail_grid.jsp"></jsp:include>
  
  <script>
    $(document).ready(function() {
    	var $dlg = $("#box_deposit_details_dialog");
  	  $dlg.on("snapp-dialog", function(event, params) {
  	    params.buttons = [
  	      {
  	        text: itl("@Common.Close"),
  	        click: doCloseDialog
  	      }
  	    ];
  	  });
    	
      $dlg.find(".box-detail-grid > tbody > tr").click(function() {
        var $row = $(this);
        var paymentMethodId = $row.attr("data-paymentmethodid");
        if (paymentMethodId)
          showBreakdown(paymentMethodId, $row.attr("data-currencyiso"), $row.attr("data-paymentmethodname"), $row.attr("data-totalamount"));
      });
  
      function showBreakdown(pluginId, currencyISO, paymentMethodName, totalAmount) {
        asyncDialogEasy("box/box_deposit_breakdown_dialog", "boxDepositId=<%=boxDepositId%>&pluginId=" + pluginId + "&currencyISO=" + currencyISO + "&paymentMethodName=" + paymentMethodName + "&totalAmount=" + totalAmount);
      }
    });
  </script>

</v:dialog>