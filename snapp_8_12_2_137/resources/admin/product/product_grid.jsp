<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Product.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_Product.class)
    .addSelect(
        Sel.CommonStatus,
        Sel.IconName,
        Sel.IconAlias,
        Sel.ForegroundColor,
        Sel.BackgroundColor,
        Sel.ProductId,
        Sel.ProductStatus,
        Sel.ProductType,
        Sel.ProductCode,
        Sel.ProductName,
        Sel.DefaultPrice,
        Sel.VariablePrice,
        Sel.CategoryRecursiveName,
        Sel.AttributeNames,
        Sel.TagNames,
        Sel.ProfilePictureId,
        Sel.ParentEntityType,
        Sel.ParentEntityId,
        Sel.ParentEntityName,
        Sel.ProductCodeAliases);

// Where
String[] categoryIDs = pageBase.getBL(BLBO_Product.class).getFilterCategoryIDs(pageBase.getNullParameter("CategoryId"));
if (categoryIDs != null)
  qdef.addFilter(Fil.CategoryId, categoryIDs);

if ((pageBase.getNullParameter("ProductStatus") != null))
  qdef.addFilter(Fil.ProductStatus, JvArray.stringToArray(pageBase.getNullParameter("ProductStatus"), ","));

if ((pageBase.getNullParameter("FullText") != null))
  qdef.addFilter(Fil.FullText, pageBase.getNullParameter("FullText"));

if (pageBase.hasParameter("ParentEntityId"))
  qdef.addFilter(Fil.ParentEntityId, pageBase.getNullParameter("ParentEntityId"));

if ((pageBase.getNullParameter("TagId") != null))
  qdef.addFilter(Fil.TagId, JvArray.stringToArray(pageBase.getNullParameter("TagId"), ","));

if ((pageBase.getNullParameter("LinkProductId") != null))
  qdef.addFilter(Fil.LinkProductId, pageBase.getNullParameter("LinkProductId"));

if ((pageBase.getNullParameter("AssociationId") != null))
  qdef.addFilter(Fil.AssociationId, pageBase.getNullParameter("AssociationId"));

if ((pageBase.getNullParameter("ProductType") != null))
  qdef.addFilter(Fil.ProductType, JvArray.stringToArray(pageBase.getNullParameter("ProductType"), ","));
else{
  int[] productTypefilter = LkSN.ProductType.getItemCodes();
  productTypefilter = JvArray.remove(productTypefilter, LkSNProductType.PromoRule.getCode());
  productTypefilter = JvArray.remove(productTypefilter, LkSNProductType.SystemPromo.getCode());
  qdef.addFilter(Fil.ProductType, productTypefilter);
}


// Sort
qdef.addSort(Sel.ProductName);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid id="prod-grid-table" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.ProductType%>">
  <tr class="header">
    <td><v:grid-checkbox header="true" multipage="true"/></td>
    <td>&nbsp;</td>
    <td width="15%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Code"/>
    </td>
    <td width="25%">
      <v:itl key="@Common.Parent"/><br/>
      <v:itl key="@Category.Category"/>           
    </td>
    <td width="25%" valign="top">
      <v:itl key="@Product.Attributes"/><br/>         
      <v:itl key="@Common.Tags"/>         
    </td>
    <td width="20%" valign="top">
      <v:itl key="@Common.Type"/><%-- <br/>         
      <v:itl key="---"/>          --%>
    </td>
    <td width="15%" align="right">
      <v:itl key="@Product.DefaultPrice"/><br/>
      <v:itl key="@Common.Status"/>
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <% LookupItem productType = LkSN.ProductType.getItemByCode(ds.getField(Sel.ProductType)); %>
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="ProductId" dataset="ds" fieldname="ProductId"/></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName)%>" iconAlias="<%=ds.getField(Sel.IconAlias)%>" foregroundColor="<%=ds.getField(Sel.ForegroundColor)%>" backgroundColor="<%=ds.getField(Sel.BackgroundColor)%>" repositoryId="<%=ds.getField(Sel.ProfilePictureId)%>"/></td>
    <td>
      <% if (productType.isLookup(LkSNProductType.PromoRule)) {%>
        <a href="<v:config key="site_url"/>/admin?page=promorule&id=<%=ds.getField(Sel.ProductId).getEmptyString()%>" class="list-title"><%=ds.getField(Sel.ProductName).getHtmlString()%></a><br/>
      <%} else {%>
        <a href="<v:config key="site_url"/>/admin?page=product&id=<%=ds.getField(Sel.ProductId).getEmptyString()%>" class="list-title"><%=ds.getField(Sel.ProductName).getHtmlString()%></a><br/>
      <% } %>  
      <span class="list-subtitle"><%=ds.getField(Sel.ProductCode).getHtmlString()%>&nbsp;</span>
    </td>
    <td>
    <% if (ds.getField(Sel.ParentEntityId).isNull()) { %>
      <span class="list-subtitle"><v:itl key="@Common.None"/></span>
    <% } else { %>
      <% String hrefParent = BLBO_PagePath.getUrl(pageBase, ds.getField(Sel.ParentEntityType).getInt(), ds.getField(Sel.ParentEntityId).getString()); %>
      <a href="<%=hrefParent%>"><%=ds.getField(Sel.ParentEntityName).getHtmlString()%></a>
    <% } %>
      <br/>
      <span class="list-subtitle"><%=ds.getField(Sel.CategoryRecursiveName).getHtmlString()%>&nbsp;</span>
    </td>
    <td valign="top">
      <%=ds.getField(Sel.AttributeNames).getHtmlString()%><br/>
      <span class="list-subtitle"><%=ds.getField(Sel.TagNames).getHtmlString()%></span>
    </td>
    <td>
      <%=productType.getDescription(pageBase.getLang())%><br/>
      <%-- <span class="list-subtitle"><v:itl key="@Common.None"/></span> --%>&nbsp;
    </td>
    <td align="right">
      <% if (ds.getField(Sel.VariablePrice).getBoolean()) { %>
        <v:itl key="@Product.VariablePrice"/><br/>
      <% } else if (ds.getField(Sel.DefaultPrice).isNull()) { %>
        &mdash;<br/>
      <% } else { %>
        <%=pageBase.formatCurrHtml(ds.getField(Sel.DefaultPrice))%><br/>
      <% } %>
      <% LookupItem productStatus = LkSN.ProductStatus.getItemByCode(ds.getField(Sel.ProductStatus)); %>
      <span class="list-subtitle"><%=productStatus.getDescription(pageBase.getLang())%></span>
    </td>
  </v:grid-row>
</v:grid>

<script>

function showProductMultiEditDialog() {
  var ids = $("[name='ProductId']").getCheckedValues();
  var queryBase64 = null;
  if ($("#prod-grid-table").hasClass("multipage-selected")) {
    ids = "";            
    queryBase64 = $("#prod-grid-table").attr("data-QueryBase64");
  }

  asyncDialogEasy("product/product_multiedit_dialog", "ProductIDs=" + ids, {"QueryBase64": queryBase64});
}

</script>

