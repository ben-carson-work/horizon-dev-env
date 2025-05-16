<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSaleCancellationDialog" scope="request"/>

<% String saleId = pageBase.getNullParameter("SaleId"); %>
<% float amount = pageBase.calcAmountDue(saleId); %>
<% PageSaleCancellationDialog.PayMethodList payMethods = pageBase.getAllowedPaymentMethods(saleId); %>

<div id="void-as-dialog">

  
<% if (amount == 0) { %>
  <v:itl key="@Payment.TotalDue"/>: <%=pageBase.formatCurrHtml(amount)%>
<% } else { %>
<v:grid>
  <thead>
    <tr class="header">
      <td width="50%"><v:itl key="@Payment.TotalDue"/></td>
      <td width="50%" align="right"><%=pageBase.formatCurrHtml(amount)%></td>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td colspan="100%">
        <select id="PaymentMethodId" class="form-control">
        <% for (PageSaleCancellationDialog.PayMethodBean payMethod : payMethods) { %>
          <option value="<%=JvString.escapeHtml(payMethod.paymentMethodId)%>" data-PaymentType="<%=payMethod.paymentType%>" data-AccountId="<%=JvString.getEmpty(payMethod.accountId)%>"><%=JvString.escapeHtml(JvMultiLang.translate(pageBase.getLang(), payMethod.paymentMethodName))%></option>
        <% } %>
        </select>
      </td>
    </tr>
  </tbody>
</v:grid>

<% } %>

&nbsp;<br/>
<v:itl key="@Common.Notes"/>
<textarea id="Notes" rows="5" class="form-control"></textarea>

<script>

$(document).ready(function() {
  var dlg = $("#void-as-dialog");
  
  dlg.dialog({
    title: <v:itl key="@Lookup.TransactionType.SaleCancellation" encode="JS"/>,
    modal: true,
    width: 500,
    close: function() {
      dlg.remove();
    },
    buttons: {
      <v:itl key="@Common.Save" encode="JS"/>: doSave,
      <v:itl key="@Common.Cancel" encode="JS"/>: doClose
    }
  });
  
  dlg.find(".tabs").tabs();
  
  function doClose() {
    dlg.dialog("close");
  }
  
  function doSave() {
    dlg.find(".ui-dialog-buttonpane .btn").addClass("disabled");    
    
    var reqDO = {
      Command: "SaleCancellation",
      SaleCancellation: {
        SaleId: "<%=saleId%>",
        PaymentMethodId: $("#PaymentMethodId").val(),
        PaymentAccountId: $("#PaymentMethodId option[value='" + $("#PaymentMethodId").val() + "']").attr("data-AccountId"),
        PaymentAmount: <%=amount%>,
        Notes: $("#Notes").val()
      }
    };
    
    $("#void-as-dialog").html("<div class='spinner32-bg' style='height:90px'></div>");
    dlg.dialog({height:200,resizable:false});

    vgsService("Sale", reqDO, true, function(ansDO) {
      if (ansDO.Header.StatusCode != 200) {
        doClose();
        showMessage(ansDO.Header.ErrorMessage);
      }
      else {
        doClose();
        showMessage(<v:itl key="@Common.SaveSuccessMsg" encode="JS"/>, function() {
          window.open("<v:config key="site_url"/>/docproc?DocTemplateId=<%=pageBase.getRights().TrnReceipt_DocTemplateId.getHtmlString()%>&p_TransactionId=" + ansDO.Answer.SaleCancellation.TransactionId);
          window.location.reload();
        });
      }
    });
  }
});

</script>


</div>
