<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Merchant.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>


<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
  QueryDef qdef = new QueryDef(QryBO_Merchant.class)
      .setPaging(pageBase.getQP(), QueryDef.recordPerPageDefault)
      .addSelect(
          Sel.CommonStatus,
          Sel.MerchantId,
          Sel.MerchantCode,
          Sel.MerchantStatus,
          Sel.MerchantCategory,
          Sel.MerchantTerminalId,
          Sel.AccountId,
          Sel.AccountName,
          Sel.LocationId,
          Sel.LocationName,
          Sel.OperatingAreaId,
          Sel.OperatingAreaName,
          Sel.WorkstationId,
          Sel.WorkstationName,
          Sel.CardType);
  
  if (pageBase.getNullParameter("FullText") != null)
    qdef.addFilter(Fil.FullText, pageBase.getNullParameter("FullText"));
  
  if (pageBase.getNullParameter("MerchantStatus") != null)
    qdef.addFilter(Fil.MerchantStatus, JvArray.stringToArray(pageBase.getNullParameter("MerchantStatus"), ","));
  
  JvDataSet ds = pageBase.execQuery(qdef);
%>
 
<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Merchants%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td width="15%">
        <v:itl key="@Common.Code"/><br/>
        <v:itl key="@Account.Account"/>
      </td>
      <td width="15%">
        <v:itl key="@Common.MerchantCategory"/><br/>
        <v:itl key="@Common.TerminalId"/>
      </td>
      <td width="20%">
        <v:itl key="@Account.Location"/>
      </td>
      <td width="20%">
        <v:itl key="@Account.OpArea"/>
      </td>
      <td width="20%">
        <v:itl key="@Common.Workstation"/>
      </td>
      <td width="10%">
        <v:itl key="@Payment.CardType"/>
      </td>
    </tr>
  </thead>
  
  <tbody>
    <v:grid-row dataset="<%=ds%>">
      <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox dataset="ds" fieldname="MerchantId"/></td>
      <td>
        <% String hrefNew = "javascript:asyncDialogEasy('payment/merchant_dialog', 'id=" + ds.getField("MerchantId").getEmptyString() + "')";%>
        <a class="list-title" href="<%=hrefNew%>"><%=ds.getField("MerchantCode").getHtmlString()%></a><br/>
        <span class="list-subtitle"><%=ds.getField("AccountName").getHtmlString()%></span>
      </td>
      <td>
        <%=ds.getField("MerchantCategory").getHtmlString()%><br/>
        <span class="list-subtitle"><%=ds.getField("MerchantTerminalId").getHtmlString()%></span>
      </td>
      <td>
        <% if (!ds.getField("LocationId").isNull()) { %> 
          <%=ds.getField("LocationName").getHtmlString()%>
        <% } else { %>
          &mdash;
        <% } %>
      </td>
      <td>
        <% if (!ds.getField("OperatingAreaId").isNull()) { %> 
          <%=ds.getField("OperatingAreaName").getHtmlString()%>
        <% } else { %>
          &mdash;
        <% } %>
      </td>
      <td>
        <% if (!ds.getField("WorkstationId").isNull()) { %> 
          <%=ds.getField("WorkstationName").getHtmlString()%>
        <% } else { %>
          &mdash;
        <% } %>
      </td>
      <td>
        <% if (!ds.getField("CardType").isNull()) { %> 
          <% LookupItem cardType = LkSN.CreditCardType.getItemByCode(ds.getField("CardType")); %>
          <%=cardType.getDescription(pageBase.getLang())%>
        <% } else { %>
          &mdash;
        <% } %>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>