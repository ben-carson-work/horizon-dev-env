<%@page import="com.vgs.snapp.query.QryBO_SiaeLocation.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<%
QueryDef qdef = new QueryDef(QryBO_SiaeLocation.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.LocationId);
qdef.addSelect(Sel.CodiceLocale);
qdef.addSelect(Sel.Denominazione);
qdef.addSelect(Sel.Indirizzo);
qdef.addSelect(Sel.Citta);
qdef.addSelect(Sel.Provincia);
qdef.addSelect(Sel.Capienza);
qdef.addSelect(Sel.AccountCode);
qdef.addSelect(Sel.AccountName);
qdef.addSelect(Sel.AccountPictureId);
// Where
if ((pageBase.getNullParameter("FullText") != null))
  qdef.addFilter(Fil.FullText, pageBase.getNullParameter("FullText"));
// Sort
qdef.addSort(Sel.AccountName);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.SiaeLocation%>">
  <tr class="header">
    <td width="1%"><v:grid-checkbox header="true"/></td>
    <td width="1%">&nbsp;</td>
    <td width="20%">Locale</td>
    <td width="15%">Codice locale SIAE</td>
    <td width="20%">Denominazione</td>
    <td width="20%">Indirizzo</td>
    <td width="20%">Citta</td>
    <td width="1%">Provincia</td>
    <td width="3%">Capienza</td>
  </tr>
  <v:grid-row dataset="ds">
    <td><v:grid-checkbox dataset="ds" name="LocationId" fieldname="LocationId" /></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>" repositoryId="<%=ds.getField(Sel.AccountPictureId).getString()%>"/></td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.LocationId).getString()%>" entityType="<%=LkSNEntityType.SiaeLocation%>" clazz="list-title">
        <%=ds.getField(Sel.AccountName)%>
      </snp:entity-link><br />
      <span class="list-subtitle"><%=ds.getField(Sel.AccountCode).getHtmlString()%></span>
    </td>
    <td>
      <%=ds.getField(Sel.CodiceLocale).getHtmlString() %>
    </td>
    <td>
      <%=ds.getField(Sel.Denominazione).getHtmlString() %>
    </td>
    <td>
      <%=ds.getField(Sel.Indirizzo).getHtmlString() %>
    </td>
    <td>
       <%=ds.getField(Sel.Citta).getHtmlString() %>
    </td>
    <td>
       <%=ds.getField(Sel.Provincia).getHtmlString() %>
    </td>
        <td>
       <%=ds.getField(Sel.Capienza).getInt() %>
    </td>
  </v:grid-row>
</v:grid>
