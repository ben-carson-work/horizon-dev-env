<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_PromoRule.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%

QueryDef qdef = new QueryDef(QryBO_PromoRule.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.CommonStatus);
qdef.addSelect(Sel.ProductId);
qdef.addSelect(Sel.ProductStatus);
qdef.addSelect(Sel.PromoSelectionType);
qdef.addSelect(Sel.ProductName);
qdef.addSelect(Sel.ProductCode);
qdef.addSelect(Sel.CategoryRecursiveName);
qdef.addSelect(Sel.ProfilePictureId);
qdef.addSelect(Sel.PromoRuleType);
qdef.addSelect(Sel.Combinable);
qdef.addSelect(Sel.PromoActionTarget);
qdef.addSelect(Sel.TagNames);

// Where
if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getNullParameter("FullText"));

if ((pageBase.getNullParameter("TagId") != null))
  qdef.addFilter(Fil.TagId, JvArray.stringToArray(pageBase.getNullParameter("TagId"), ","));

if (pageBase.getNullParameter("PromoRuleType") != null)
  qdef.addFilter(Fil.PromoRuleType, JvArray.stringToIntArray(pageBase.getNullParameter("PromoRuleType"), ","));

if (pageBase.getNullParameter("PromoSelectionType") != null)
  qdef.addFilter(Fil.PromoSelectionType, JvArray.stringToIntArray(pageBase.getNullParameter("PromoSelectionType"), ","));

if (pageBase.getNullParameter("PromoActionTarget") != null)
  qdef.addFilter(Fil.PromoActionTarget, JvArray.stringToIntArray(pageBase.getNullParameter("PromoActionTarget"), ","));

if (pageBase.getNullParameter("ProductStatus") != null)
  qdef.addFilter(Fil.ProductStatus, JvArray.stringToIntArray(pageBase.getNullParameter("ProductStatus"), ","));

if ((pageBase.getNullParameter("CategoryId") != null) && !pageBase.isParameter("CategoryId", "all"))
  qdef.addFilter(Fil.CategoryId, pageBase.getNullParameter("CategoryId"));

// Sort
qdef.addSort(Sel.ProductName);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.PromoRule%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="25%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Code"/>
    </td>
    <td width="25%">
      <v:itl key="@Category.Category"/><br/>
      <v:itl key="@Common.Tags"/>         
    </td>
    <td width="25%">
      <v:itl key="@Common.Type"/><br/>           
      <v:itl key="@Product.PromoActionTarget"/>
    </td>
    <td width="25%">
      <v:itl key="@Product.PromoSelection"/><br/>
      <v:itl key="@Product.PromoCombinable"/>           
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <% LookupItem promoRuleType = LkSN.PromoRuleType.getItemByCode(ds.getField(Sel.PromoRuleType)); %>
    <% LookupItem promoSelectionType = LkSN.PromoSelectionType.getItemByCode(ds.getField(Sel.PromoSelectionType)); %>
    <% LookupItem promoActionTarget = LkSN.PromoActionTarget.getItemByCode(ds.getField(Sel.PromoActionTarget)); %>
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="ProductId" dataset="ds" fieldname="ProductId"/></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>" repositoryId="<%=ds.getField(Sel.ProfilePictureId).getString()%>"/></td>
    <td>
      <a href="<v:config key="site_url"/>/admin?page=promorule&id=<%=ds.getField(Sel.ProductId).getEmptyString()%>" class="list-title"><%=ds.getField(Sel.ProductName).getHtmlString()%></a><br/>
      <span class="list-subtitle"><%=ds.getField(Sel.ProductCode).getHtmlString()%>&nbsp;</span>
    </td>
    <td>
      <%=ds.getField(Sel.CategoryRecursiveName).getHtmlString()%>
      <br/>
      <span class="list-subtitle"><%=ds.getField(Sel.TagNames).getHtmlString()%></span>
    </td>
    <td>
      <%=promoRuleType.getDescription(pageBase.getLang())%><br/>
      <span class="list-subtitle"><%=promoActionTarget.getDescription(pageBase.getLang())%>&nbsp;</span>
    </td>
    <td>
      <%=promoSelectionType.getDescription(pageBase.getLang())%><br/>
      <span class="list-subtitle">
	    <%if (ds.getField(Sel.Combinable).getBoolean()) {%>
	      <v:itl key="@Product.PromoCombinable"/>  
	    <%} else {%>
	      <v:itl key="@Product.PromoNotCombinable"/>  
	    <%} %>         
      &nbsp;</span>
    </td>
  </v:grid-row>
</v:grid>

<script>

function showPromoMultiEditDialog() {
  var ProductIDs = $("[name='ProductId']:checked").map(function () {return this.value;}).get().join(",");
  if (ProductIDs.length == 0)
    showMessage("<v:itl key="@Common.NoElementWasSelected"/>");
  else
    asyncDialogEasy("product/promorule/promo_multiedit_dialog", "ProductIDs=" + ProductIDs);
}

</script>

