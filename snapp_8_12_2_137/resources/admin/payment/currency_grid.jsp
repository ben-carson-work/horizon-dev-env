<%@page import="com.sun.mail.imap.Rights.Right"%>
<%@page import="com.vgs.snapp.library.SnappUtils"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Currency.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_Currency.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.CommonStatus);
qdef.addSelect(Sel.CurrencyId);
qdef.addSelect(Sel.CurrencyType);
qdef.addSelect(Sel.ISOCode);
qdef.addSelect(Sel.ISOCodeNumeric);
qdef.addSelect(Sel.Symbol);
qdef.addSelect(Sel.CurrencyName);
qdef.addSelect(Sel.CurrencyFormatDesc);
qdef.addSelect(Sel.ExchangeRate);
qdef.addSelect(Sel.RoundDecimals);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Sort
qdef.addSort(Sel.CurrencyType);
qdef.addSort(Sel.ISOCode);
// Exec    
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid id="currency-grid-table" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Currency%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td></td>
      <td width="20%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Code"/>
      </td>
      <td width="20%">
        <v:itl key="@Currency.Symbol"/><br/>
        <v:itl key="@Currency.Format"/>
      </td>
      <td width="60%">
        <v:itl key="@Currency.ExchangeRate"/><br/>
        <v:itl key="@Currency.Decimals"/>
      </td>
    </tr>
  </thead>
  
  <tbody>
    <v:grid-row dataset="ds">
      <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="CurrencyId" dataset="ds" fieldname="CurrencyId"/></td>
      <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
      <td>
        <a class="list-title" href="<v:config key="site_url"/>/admin?page=currency&id=<%=ds.getField(Sel.CurrencyId).getEmptyString()%>"><%=ds.getField(Sel.CurrencyName).getHtmlString()%></a><br/>
        <span class="list-subtitle"><%=ds.getField(Sel.ISOCode).getHtmlString()%></span>
      </td>
      <td>
        <%=ds.getField(Sel.Symbol).getHtmlString()%><br/>
        <span class="list-subtitle"><%=ds.getField(Sel.CurrencyFormatDesc).getHtmlString()%></span>
      </td>
      <td>
        <%=ds.getField(Sel.ExchangeRate).getHtmlString()%><br/>
        <span class="list-subtitle"><%=ds.getField(Sel.RoundDecimals).getHtmlString()%></span>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>