<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Tax.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_Tax.class)
    .addSelect(
        Sel.IconName,
        Sel.TaxId,
        Sel.TaxCode,
        Sel.TaxName,
        Sel.TaxType,
        Sel.CurrentTaxValue,
        Sel.RoundingType,
        Sel.Remboursable,
        Sel.BearedTax,
        Sel.Exemptible,
        Sel.ExemptibleExplicit)
    .setPaging(pageBase.getQP(), QueryDef.recordPerPageDefault)
    .addSort(Sel.TaxName);

JvDataSet ds = pageBase.execQuery(qdef);
%>

<v:grid id="tax-grid-table" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Tax%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td width="40%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Code"/>
      </td>
      <td width="30%">
        <v:itl key="@Common.Options"/>
      </td>
      <td width="30%" align="right">
        <v:itl key="@Common.Value"/><br/>
        <v:itl key="@Common.Rounding"/>
      </td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row dataset="<%=ds%>">
      <% 
      LookupItem taxType = LkSN.TaxType.getItemByCode(ds.getField(Sel.TaxType));
      LookupItem roundingType = LkSN.RoundingType.getItemByCode(ds.getField(Sel.RoundingType));
      
      String[] optionsHtml = {};
      if (ds.getBoolean(Sel.Remboursable))
        optionsHtml = JvArray.add(pageBase.getLang().Product.TaxRemboursable.getHtmlText(), optionsHtml);
      if (ds.getBoolean(Sel.BearedTax))
        optionsHtml = JvArray.add(pageBase.getLang().Product.BearedTax.getHtmlText(), optionsHtml);
      if (ds.getBoolean(Sel.Exemptible))
        optionsHtml = JvArray.add(pageBase.getLang().Product.TaxExemptible.getHtmlText(), optionsHtml);
      if (ds.getBoolean(Sel.ExemptibleExplicit))
        optionsHtml = JvArray.add(pageBase.getLang().Product.TaxExemptibleExplicitFull.getHtmlText(), optionsHtml);
      %>
      
      <td><v:grid-checkbox name="TaxId" dataset="<%=ds%>" fieldname="TaxId"/></td>
      <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
      <td>
        <snp:entity-link entityId="<%=ds.getField(Sel.TaxId).getString()%>" entityType="<%=LkSNEntityType.Tax%>" clazz="list-title">
          <%=ds.getField(Sel.TaxName).getHtmlString()%>
        </snp:entity-link>
        <br/>
        <span class="list-subtitle"><%=ds.getField(Sel.TaxCode).getHtmlString()%></span>&nbsp;
      </td>
      <td>
        <div class="list-subtitle"><%=JvArray.arrayToString(optionsHtml, ", ")%></div>
      </td>
      <td align="right">
        <% if (ds.getField(Sel.CurrentTaxValue).isNull()) { %>
          <v:itl key="@Common.OutsideValidityPeriod"/>
        <% } else { %>
	        <% if (taxType.isLookup(LkSNTaxType.Absolute)) { %>
	          <%=pageBase.formatCurrHtml(ds.getField(Sel.CurrentTaxValue))%>
	        <% } else { %>
	          <%=ds.getField(Sel.CurrentTaxValue).getString()%>
	        <% } %>
        <% } %>
        <br/>
        <span class="list-subtitle"><%=roundingType.getHtmlDescription(pageBase.getLang())%></span>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
    