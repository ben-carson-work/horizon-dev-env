<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="java.util.List"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Payment.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<% 
@SuppressWarnings("unchecked")
List<DOPaymentRef> list = (List<DOPaymentRef>)request.getAttribute("listPayment");
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");

String title = request.getParameter("title");
%>

<v:grid include="<%=(list != null) && !list.isEmpty()%>">
  <v:grid-title caption="<%=title%>" include="<%=title != null%>"/>

  <thead>
    <tr>
      <td>&nbsp;</td>
      <td width="30%">
        <v:itl key="@Payment.PaymentMethod"/><br/>
        <v:itl key="@Common.Description"/>
      </td>
      <td width="25%">
        <v:itl key="@Common.Transaction"/><br/>
        <v:itl key="@Payment.PaymentMethodMasks"/>
      </td>
      <td width="25%" valign="top">
        <v:itl key="@Common.Status"/><br/>
        <v:itl key="@Payment.AuthorizationCode"/>
      </td>
      <td width="20%" align="right">
        <v:itl key="@Common.Amount"/><br />
        <v:itl key="@Common.AdditionalData"/>
      </td>
    </tr>
  </thead>
  
  <tbody>
    <% for (DOPaymentRef pay : list) { %>
      <tr class="grid-row">
        <td style="<v:common-status-style status="<%=pay.CommonStatus%>"/>">
          <v:grid-icon name="<%=pay.IconName.getString()%>" iconAlias="<%=pay.IconAlias.getString()%>" foregroundColor="<%=pay.ForegroundColor.getString()%>" backgroundColor="<%=pay.BackgroundColor.getString()%>"/>
        </td>
        <td>
          <%=pay.PaymentMethodName.getHtmlString()%>
          <br/>
          <% if (pay.PaymentType.isLookup(LkSNPaymentType.Credit)) { %>
            <snp:entity-link entityId="<%=pay.CreditLine.AccountId%>" entityType="<%=LkSNEntityType.Account_All%>"><%=pay.PaymentDesc.getHtmlString()%></snp:entity-link>
          <% } else if (pay.PaymentType.isLookup(LkSNPaymentType.AdvancedPayment)) { %>
            <snp:entity-link entityId="<%=pay.AdvPayment.AccountId%>" entityType="<%=LkSNEntityType.Account_All%>"><%=pay.PaymentDesc.getHtmlString()%></snp:entity-link>
          <% } else { %>
            <% if (pay.PaymentDescHRef.isNull()) {%>
              <span class="list-subtitle"><%=pay.PaymentDesc.getHtmlString()%></span>
            <% } else {%>
              <span class="list-subtitle"><a href="<v:config key="site_url"/><%=pay.PaymentDescHRef.getString()%>"><%=pay.PaymentDesc.getHtmlString()%></a></span>
            <% } %>
          <% } %>
        </td>
        <td nowrap>
          <snp:entity-link entityId="<%=pay.TransactionId%>" entityType="<%=LkSNEntityType.Transaction%>"><%=pay.TransactionCode.getHtmlString()%></snp:entity-link><br/>
           
          <% if (pay.MetaDataCount.getInt() > 0) { %>
            <a href="javascript:asyncDialogEasy('payment/payment_dialog', 'id=<%=pay.PaymentId.getHtmlString()%>')">
              <v:itl key="@Payment.PaymentMethodMasks"/>
            </a>
          <% }  else { %>
            &mdash;
          <% } %> 
        </td>
        <td>
          <div><%=pay.PaymentStatusDesc.getHtmlString()%></div>
          <% if (pay.CreditCard.AuthorizationCode.isNull()) { %>
            &mdash;
          <% } else { %>
            <div class="list-subtitle"><%=pay.CreditCard.AuthorizationCode.getHtmlString()%></div>
          <% } %>
          
          <div class="list-subtitle">
            <%
            String[] values = new String[0];
            for (String key : pageBase.getRights().HighlightPaymentDataKeys.getArray()) { 
              DOPaymentData pd = pay.PaymentDataList.findChildItem("ParamName", key);
              if (pd != null) 
                values = JvArray.add(pd.ParamName.getHtmlString() + "=" + pd.ParamValue.getHtmlString(), values);
            }
            %>
            <%=JvArray.arrayToString(values, " &mdash; ")%>
          </div>
        </td>
        <td align="right" valign="top">
          <div>
            <% if (pay.Change.getBoolean()) { %>
              <span class="list-subtitle">(<v:itl key="@Payment.Change" transform="lowercase"/>)</span>
            <% } %>
          
            <% String style = pay.PaymentAmountStrikethrough.getBoolean() ? "text-decoration:line-through" : "";  %>
            <span style="<%=style%>"><%=pageBase.formatCurrHtml(pay.PaymentAmount)%></span>
          </div>
          <div class="list-subtitle"><%=pay.PaymentAmountExt.getHtmlString()%></div>
          <% if (pay.PaymentDataCount.getInt() > 0) { %>
            <a href="javascript:asyncDialogEasy('payment/paymentdata_dialog', 'id=<%=pay.PaymentId.getHtmlString()%>&SaleId=<%=pay.SaleId.getHtmlString()%>')">
              <v:itl key="@Common.AdditionalData"/>
            </a>
          <% } else { %>
            &mdash;
          <% } %>
        </td>
      </tr>
    <% } %>
  </tbody>
</v:grid>
