<%@page import="com.vgs.snapp.dataobject.transaction.*"%>
<%@page import="com.vgs.snapp.api.voucher.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
APIDef_Voucher_Search.DORequest reqDO = new APIDef_Voucher_Search.DORequest();
reqDO.SearchRecap.PagePos.setInt(pageBase.getQP());
reqDO.SearchRecap.RecordPerPage.setInt(QueryDef.recordPerPageDefault);
reqDO.Filters.FullText.setString(pageBase.getNullParameter("FullText"));
reqDO.Filters.VoucherStatus.setArray(JvArray.stringToIntArray(pageBase.getNullParameter("VoucherStatus"), ","));
reqDO.Filters.Active.setBoolean(pageBase.isParameter("Active", "true"));
reqDO.Filters.DateFrom.setString(pageBase.getNullParameter("FromDate"));
reqDO.Filters.DateTo.setString(pageBase.getNullParameter("ToDate"));
reqDO.Filters.Transaction.TransactionId.setString(pageBase.getNullParameter("TransactionId"));
reqDO.Filters.Sale.SaleId.setString(pageBase.getNullParameter("SaleId"));
reqDO.Filters.Account.AccountId.setString(pageBase.getNullParameter("AccountId"));

APIDef_Voucher_Search.DOResponse ansDO = pageBase.getBL(API_Voucher_Search.class).execute(reqDO); 
%>

<v:grid id="voucher-grid" search="<%=ansDO%>" entityType="<%=LkSNEntityType.Voucher%>">
  <thead>
    <tr class="header">
      <td><v:grid-checkbox header="true" multipage="true"/></td>
      <td>&nbsp;</td>
      <td width="20%">
        <v:itl key="@Common.Code"/><br/>
        <v:itl key="@Common.Status"/>
      </td>
      <td width="20%">
        <v:itl key="@Account.Credit.IssueTransaction"/><br/>
      </td>
      <td width="20%">
        <v:itl key="@DocTemplate.DocTemplate"/><br/>
        <v:itl key="@Common.Printed"/>
      </td>
      <td width="10%">
        <v:itl key="@Common.ValidFrom"/><br/>
        <v:itl key="@Common.ValidTo"/>
      </td>
      <td width="30%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Description"/>
      </td>
    </tr>
  </thead>
  <body>
    <v:grid-row search="<%=ansDO%>">
      <% DOVoucherRef voucher = ansDO.getRecord(); %>
      <% String blocked = voucher.Active.getBoolean() ? "" : " (" + pageBase.getLang().Common.Blocked.getText() + ")"; %>
      <td style="<v:common-status-style status="<%=voucher.CommonStatus%>"/>">
        <v:grid-checkbox name="cbVoucherId" value="<%=voucher.VoucherId.getHtmlString()%>"/>
      </td>
      <td><v:grid-icon name="<%=voucher.IconName.getString()%>"/></td>
      <td>
        <snp:entity-link entityId="<%=voucher.VoucherId%>" entityType="<%=LkSNEntityType.Voucher%>" clazz="list-title">
          <%=voucher.VoucherCode.getHtmlString()%>
        </snp:entity-link>
        <br/>
        <span class="list-subtitle"><%=voucher.VoucherStatus.getHtmlLookupDesc(pageBase.getLang())%><%=blocked%></span>
      </td>
      <td>
        <% if (!voucher.IssueTransactionId.isNull()) { %>
          <snp:entity-link entityId="<%=voucher.IssueTransactionId%>" entityType="<%=LkSNEntityType.Transaction%>">
            <%=voucher.IssueTransactionCode.getHtmlString()%>
          </snp:entity-link>
        <% } %>
        <br/>
        <span class="list-subtitle"><snp:datetime timezone="local" timestamp="<%=voucher.CreateDateTime%>" format="shortdatetime"/> </span>
      </td>
      <td>
        <% if (voucher.DocTemplateId.isNull()) { %>
          &mdash;
        <% } else { %>
          <snp:entity-link entityId="<%=voucher.DocTemplateId%>" entityType="<%=LkSNEntityType.DocTemplate%>">
            <%=voucher.DocTemplateName.getHtmlString()%>
          </snp:entity-link>
        <% } %>
        <br/>
        <span class="list-subtitle">
        <% if (voucher.Printed.getBoolean()) { %>
          <v:itl key="@Common.Yes"/>
          <% if (!voucher.PrintTransactionId.isNull()) { %>
            &nbsp;&nbsp;&nbsp;
            <snp:entity-link entityId="<%=voucher.PrintTransactionId%>" entityType="<%=LkSNEntityType.Transaction%>">
              <%=voucher.PrintTransactionCode.getHtmlString()%>
            </snp:entity-link>
          <% } %>
        <% } else { %>
          <v:itl key="@Common.No"/>
        <% } %>
        </span>
      </td>
      <td>
        <%=voucher.ValidDateFrom.formatHtml(pageBase.getShortDateFormat())%>
        <br/>
        <%=voucher.ValidDateTo.formatHtml(pageBase.getShortDateFormat())%>
      </td>
      <td>
        <%=voucher.VoucherName.getHtmlString()%>
        <br/>
        <%=voucher.VoucherDescription.getHtmlString()%>
      </td>
    </v:grid-row>
  </body>
</v:grid>
