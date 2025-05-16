<%@page import="com.vgs.web.library.BLBO_Portfolio"%>
<%@page import="java.io.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Portfolio.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
QueryDef qdef = new QueryDef(QryBO_Portfolio.class);
// Select
qdef.addSelect(
    Sel.IconName,
    Sel.PortfolioId,
    Sel.AccountId,
    Sel.AccountName,
    Sel.AccountCategoryNames,
    Sel.AccountProfilePictureId,
    Sel.Inside,
    Sel.InsideFirstEntry,
    Sel.InsideLastEntry,
    Sel.InsideLastExit);

// Where
qdef.addFilter(Fil.InsidePerformanceId, pageBase.getNullParameter("PerformanceId"));

if (pageBase.isParameter("InsideOnly", "true"))
  qdef.addFilter(Fil.InsideOnly, "true");

// Sort
qdef.addSort(Sel.AccountName);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
long walletBalance = pageBase.getBL(BLBO_Portfolio.class).getPortfolioBalance(ds.getString(Sel.PortfolioId));
request.setAttribute("ds", ds);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Performance%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true" multipage="true"/></td>
      <td>&nbsp;</td>
      <td width="50%">
        <v:itl key="@Account.Account"/><br/>
        <v:itl key="@Category.Category"/>
      </td>
      <td width="130px" nowrap>
        <v:itl key="@Entitlement.Entry"/><br/>
        <v:itl key="@Entitlement.ReEntry"/>
      </td>
      <td width="130px" nowrap>
        <v:itl key="@Common.Exit"/><br/>
        &nbsp;
      </td>
      <td width="50%" align="right">
        <v:itl key="@Common.Balance"/><br/>
        <v:itl key="@Common.Status"/>
      </td>
    </tr>
  </thead>
  <tbody>
  <v:grid-row dataset="ds">
    <td><v:grid-checkbox name="cbPortfolioId" dataset="ds" fieldname="PortfolioId"/></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>" repositoryId="<%=ds.getField(Sel.AccountProfilePictureId).getString()%>"/></td>
    <td>
      <%
      if (ds.getField(Sel.AccountId).isNull()) {
      %>
        <span class="list-subtitle"><v:itl key="@Account.AnonymousAccount"/></span>
      <%
      } else {
      %>
        <a href="" class="list-title"><%=ds.getField(Sel.AccountName).getHtmlString()%></a>
      <%
      }
      %>
      <br/>
      <span class="list-subtitle"><%=ds.getField(Sel.AccountCategoryNames).getHtmlString()%>&nbsp;</span>
    </td>
    <td nowrap>
      <%=pageBase.format(ds.getField(Sel.InsideFirstEntry).getDateTime(), pageBase.getShortDateTimeFormat())%><br/>
      <span class="list-subtitle"><%=pageBase.format(ds.getField(Sel.InsideLastEntry).getDateTime(), pageBase.getShortDateTimeFormat())%></span>
    </td>
    <td nowrap>
      <%=pageBase.format(ds.getField(Sel.InsideLastExit).getDateTime(), pageBase.getShortDateTimeFormat())%><br/>
      &nbsp;
    </td>
    <td align="right">
      <%=pageBase.formatCurrHtml(walletBalance)%><br/>
      <% String sStatus = ds.getField(Sel.Inside).getBoolean() ? "@Common.Settled" : "@Common.Unsettled"; %>
      <span class="list-subtitle"><v:itl key="<%=sStatus%>"/></span>
    </td>
  </v:grid-row>
  </tbody>
</v:grid>




