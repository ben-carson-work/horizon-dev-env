<%@page import="com.vgs.web.tag.ConfigTag"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Product.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_Product.class);
// Select
qdef.addSelect(Sel.ProductId);
qdef.addSelect(Sel.ProductCode);
qdef.addSelect(Sel.ProductName);
qdef.addSelect(Sel.ProductNameExt);
qdef.addSelect(Sel.ShowNameExt);
qdef.addSelect(Sel.ProfilePictureId);
// Filter
qdef.addFilter(Fil.ProductId, pageBase.getId());
// Exec
JvDataSet ds = pageBase.execQuery(qdef);

String picStyle = "";
if (!ds.getField(Sel.ProfilePictureId).isNull()) 
  picStyle = "background-image:url(" + ConfigTag.getValue("site_url") + "/repository?type=small&id=" + ds.getField(Sel.ProfilePictureId).getHtmlString() + ")";

String richDesc = pageBase.getBL(BLBO_RichDesc.class).getRichDescDefault(pageBase.getId());
%>

<style>
.shopcart-tooltip {
  overflow: hidden;
  min-width: 400px;
  max-width: 700px;
}

.shopcart-tooltip-pic {
  float: left;
  width: 150px;
  height: 150px;
  background-repeat: no-repeat;
  background-position: center center;
  background-size: cover;
  border: 1px solid rgba(0,0,0,0.1);
}

.shopcart-tooltip-body {
  margin-left: 160px;
}

.shopcart-tooltip-title {
  font-size: 20px;
}

.shopcart-tooltip-subtitle {
  font-size: 16px;
  color: var(--menu-bg-color);
}

</style>

<div class="shopcart-tooltip">
  <div class="shopcart-tooltip-pic" style="<%=picStyle%>"></div>
  <div class="shopcart-tooltip-body">
    <div class="shopcart-tooltip-title"><%=ds.getField(Sel.ProductName).getHtmlString()%></div>
    <% if (ds.getField(Sel.ShowNameExt).getBoolean() && !ds.getField(Sel.ProductNameExt).isNull()) { %>
      <div class="shopcart-tooltip-subtitle"><%=ds.getField(Sel.ProductNameExt).getHtmlString()%></div>
    <% } %>
    <% if (richDesc != null) { %>
      <div class="shopcart-tooltip-richdesc"><%=richDesc%></div>
    <% } %>
  </div>
</div>