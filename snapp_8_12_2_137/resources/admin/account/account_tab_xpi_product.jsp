<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>

<%
  QueryDef qdef = new QueryDef(QryBO_ProductCrossSell.class);
  // Select
  qdef.addSelect(QryBO_ProductCrossSell.Sel.ProductIconName);
  qdef.addSelect(QryBO_ProductCrossSell.Sel.ProductId);
  qdef.addSelect(QryBO_ProductCrossSell.Sel.ProductName);
  qdef.addSelect(QryBO_ProductCrossSell.Sel.ProductCode);
  qdef.addSelect(QryBO_ProductCrossSell.Sel.CrossProductName);
  qdef.addSelect(QryBO_ProductCrossSell.Sel.CrossProductCode);
  qdef.addSelect(QryBO_ProductCrossSell.Sel.CrossProductStatusDesc);
  qdef.addSelect(QryBO_ProductCrossSell.Sel.Price);
  // Where
  qdef.addFilter(QryBO_ProductCrossSell.Fil.CrossPlatformId, pageBase.getId());
  // Sort
  qdef.addSort(QryBO_ProductCrossSell.Sel.ProductName);
  // Exec
  JvDataSet ds = pageBase.execQuery(qdef);
  request.setAttribute("ds", ds);
%>

<div class="tab-content">
  <v:grid id="xpi_productsell_grid" dataset="<%=ds%>">
    <tr class="header">
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td width="45%">
        <v:itl key="@XPI.CrossProductName"/><br/>
        <v:itl key="@XPI.CrossProductCode"/>
      </td>
      <td width="40%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Code"/>
      </td>
      <td width="15%" align="right">
        <v:itl key="@XPI.CrossProductPrice"/><br/>
        <v:itl key="@Common.Status"/>
      </td>
    </tr>
    <tbody id="xpi_productcrosssell-body">
      <v:grid-row dataset="ds">
        <td><v:grid-checkbox name="ProductId" dataset="ds" fieldname="ProductId"/></td>
        <td><v:grid-icon name="<%=ds.getField(QryBO_ProductCrossSell.Sel.ProductIconName).getString()%>"/></td>
        <td>
          <%=ds.getField(QryBO_ProductCrossSell.Sel.CrossProductName).getHtmlString()%><br/>
          <span class="list-subtitle"><%=ds.getField(QryBO_ProductCrossSell.Sel.CrossProductCode).getHtmlString()%></span>
        </td>
        <td>
          <a href="<v:config key="site_url"/>/admin?page=product&id=<%=ds.getField(QryBO_ProductCrossSell.Sel.ProductId).getEmptyString()%>" class="list-title"><%=ds.getField(QryBO_ProductCrossSell.Sel.ProductName).getHtmlString()%></a><br/>
          <span class="list-subtitle"><%=ds.getField(QryBO_ProductCrossSell.Sel.ProductCode).getHtmlString()%>&nbsp;</span>
        </td>
        <td align="right">
          <%=pageBase.formatCurrHtml(ds.getField(QryBO_ProductCrossSell.Sel.Price))%><br/>
          <span><%=ds.getField(QryBO_ProductCrossSell.Sel.CrossProductStatusDesc).getHtmlString()%></span>
        </td>
      </v:grid-row>
    </tbody>
  </v:grid>
</div>