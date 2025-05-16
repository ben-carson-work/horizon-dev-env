<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_ExtProductType.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_ExtProductType.class);
// Select
qdef.addSelect(Sel.ExtProductTypeId);
qdef.addSelect(Sel.ExtProductCode);
qdef.addSelect(Sel.ExtProductName);
qdef.addSelect(Sel.ExtProductPrice);
qdef.addSelect(Sel.ExtMediaGroupCode);
qdef.addSelect(Sel.ExtMediaGroupName);
qdef.addSelect(Sel.ExtMediaGroupId);

// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Where

if (pageBase.getNullParameter("AccountId") != null)
  qdef.addFilter(Fil.AccountId, pageBase.getNullParameter("AccountId"));

// Sort
qdef.addSort(Sel.ExtProductName, false);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid id="extmedia-grid" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.ExtProductType%>">
  <thead>
    <tr>
      <td width="34%">
        <v:itl key="@ExtMediaBatch.ExtProductName"/><br/>
        <v:itl key="@Common.Code"/>
      </td>
      <td width="33%">
        <v:itl key="@Product.ExtMediaGroup"/><br/>
        <v:itl key="@Common.Code"/>
      </td>
      <td align="right" width="33%">
        <v:itl key="@ExtMediaBatch.ExtProductPrice"/><br/>
      </td>
    </tr>
  </thead>
  
  <tbody>
    <v:grid-row dataset="ds">
      <td>
        <% String onClick = "javascript:asyncDialogEasy('account/ext_product_type_dialog', 'id=" + ds.getField(Sel.ExtProductTypeId).getString() + "')"; %>
        <span class="list-title"><a href="<%=onClick%>"><%=ds.getField(Sel.ExtProductName).getHtmlString()%></a></span><br/>
        <span class="list-subtitle"><%=ds.getField(Sel.ExtProductCode).getHtmlString()%></span>
      </td>
      <td>
        <span class="list-title"><%=ds.getField(Sel.ExtMediaGroupName).getHtmlString()%></span><br/>
        <span class="list-subtitle"><%=ds.getField(Sel.ExtMediaGroupCode).getHtmlString()%></span><br/>
      </td>
      <td align="right" >
        <span class="list-title"><%=pageBase.formatCurrHtml(ds.getField(Sel.ExtProductPrice))%></span><br/>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>

