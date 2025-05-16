<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.web.library.BLBO_Siae.SiaeLookup"%>
<%@page import="com.vgs.web.library.BLBO_Siae"%>
<%@page import="com.vgs.web.library.BLBO_PagePath"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeProduct.*"%>
<%@page import="com.vgs.cl.lookup.LookupItem"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<%
  QueryDef qdef = new QueryDef(QryBO_SiaeProduct.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.ProductId);
qdef.addSelect(Sel.ProductName);
qdef.addSelect(Sel.ProductCode);
qdef.addSelect(Sel.ParentEntityType);
qdef.addSelect(Sel.ParentEntityId);
qdef.addSelect(Sel.ParentEntityName);
qdef.addSelect(Sel.CategoryRecursiveName);
qdef.addSelect(Sel.TipoTitolo);
qdef.addSelect(Sel.OrdinePosto);
qdef.addSelect(Sel.EventiAbilitati);
qdef.addSelect(Sel.OrganizerId);
qdef.addSelect(Sel.OrganizerName);
qdef.addSelect(Sel.ProfilePictureId);
qdef.addSelect(Sel.ProductType);
qdef.addSelect(Sel.DefaultPrice);
qdef.addSelect(Sel.CommonStatus);
qdef.addSelect(Sel.TagNames);
qdef.addSelect(Sel.SiaeTax);
// Where
if ((pageBase.getNullParameter("CategoryId") != null) && !pageBase.isParameter("CategoryId", "all"))
  qdef.addFilter(Fil.CategoryId, pageBase.getNullParameter("CategoryId"));

if ((pageBase.getNullParameter("ProductStatus") != null))
  qdef.addFilter(Fil.ProductStatus, JvArray.stringToArray(pageBase.getNullParameter("ProductStatus"), ","));

if ((pageBase.getNullParameter("FullText") != null))
  qdef.addFilter(Fil.FullText, pageBase.getNullParameter("FullText"));

if ((pageBase.getNullParameter("TagId") != null))
  qdef.addFilter(Fil.TagId, JvArray.stringToArray(pageBase.getNullParameter("TagId"), ","));

if ((pageBase.getNullParameter("OrganizerId") != null))
  qdef.addFilter(Fil.OrganizerId, pageBase.getNullParameter("OrganizerId"));
// Sort
qdef.addSort(Sel.ProductName); 
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
BLBO_Siae bl = pageBase.getBL(BLBO_Siae.class);
%>
<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.SiaeProduct%>">
  <thead>
    <tr>
      <td width="1%"><v:grid-checkbox header="true" multipage="true"/></td>
      <td>&nbsp;</td>
      <td>
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Code"/>
      </td>
      <td>
        <v:itl key="@Common.Parent"/><br/>
        <v:itl key="@Category.Category"/>
      </td>
      <td>
        Organizzatore<br/>
        <v:itl key="@Common.Tags"/>
      </td>
      <td>
        Ordine di posto
      </td>
      <td>
        Tipo titolo<br/>
        Tipo IVA
      </td>
      <td>
        Eventi abilitati
      </td>
      <td>Type</td>
      <td  align="right"><v:itl key="@Product.DefaultPrice"/></td>
    </tr>
  </thead>
  <v:grid-row dataset="ds">
  <%
    String code = ds.getString(Sel.OrdinePosto);
    String desc = bl.getLookupItem(SiaeLookup.ORDINI_DI_POSTI, code);
    String sector = String.format("[%s] %s", code, desc);
    
    code = ds.getString(Sel.TipoTitolo);
    desc = bl.getLookupItem(SiaeLookup.TIPO_TITOLO, code);
    String ticketType = String.format("[%s] %s", code, desc);
    String tipoIva = ds.getField(Sel.SiaeTax).getHtmlString();
  %>
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox dataset="ds" name="ProductId" fieldname="ProductId" /></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>" repositoryId="<%=ds.getField(Sel.ProfilePictureId).getString()%>"/></td>
    <td>
     <snp:entity-link entityId="<%=ds.getField(Sel.ProductId).getString()%>" entityType="<%=LkSNEntityType.SiaeProduct%>" clazz="list-title">
        <%=ds.getField(Sel.ProductName).getHtmlString()%>
      </snp:entity-link>
      <br/>
      <span class="list-subtitle"><%=ds.getField(Sel.ProductCode).getHtmlString()%>&nbsp;</span>
    </td>
    <td>
      <%
        if (ds.getField(Sel.ParentEntityId).isNull()) {
      %>
        <span class="list-subtitle"><v:itl key="@Common.None"/></span>
      <%
        } else {
      %>
        <%
          String hrefParent = BLBO_PagePath.getUrl(pageBase, ds.getField(Sel.ParentEntityType).getInt(), ds.getField(Sel.ParentEntityId).getString());
        %>
        <a href="<%=hrefParent%>"><%=ds.getField(Sel.ParentEntityName).getHtmlString()%></a>
      <%
        }
      %>
      <br/>
      <span class="list-subtitle"><%=ds.getField(Sel.CategoryRecursiveName).getHtmlString()%>&nbsp;</span>
    </td>
    <td>
      <snp:entity-link entityId="<%=ds.getString(Sel.OrganizerId)%>" entityType="<%=LkSNEntityType.SiaeOrganizer%>">
          <%=ds.getField(Sel.OrganizerName).getHtmlString()%>
      </snp:entity-link><br/>
      <span class="list-subtitle"><%=ds.getField(Sel.TagNames).getHtmlString()%></span>&nbsp;
    </td>
    <td><%=sector%></td>
    <td><%=ticketType%><br/>
      <span class="list-subtitle"><%=tipoIva%>&nbsp;</span>
    </td>
    <td><%=ds.getField(Sel.EventiAbilitati).getInt()%></td>
    <td><%=LkSN.SiaeProductType.getItemDescription(ds.getInt(Sel.ProductType))%></td>
        <td align="right"> 
     <% if (ds.getField(Sel.DefaultPrice).isNull()){ %>
          &mdash;
     <% } else {%>
        <%=pageBase.formatCurrHtml(ds.getField(Sel.DefaultPrice))%>
     <%} %>   
    </td>
  </v:grid-row>
</v:grid>
<script>
</script>
