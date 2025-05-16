<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeOrganizer.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<%
QueryDef qdef = new QueryDef(QryBO_SiaeOrganizer.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.OrganizerId);
qdef.addSelect(Sel.Denominazione);
qdef.addSelect(Sel.CodiceFiscale);
qdef.addSelect(Sel.TipoOrganizzatore);
qdef.addSelect(Sel.AccountPictureId);
qdef.addSelect(Sel.AccountCode);
qdef.addSelect(Sel.AccountName);
//Where
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

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.SiaeOrganizer%>">
  <tr class="header">
    <td width="1%"><v:grid-checkbox header="true"/></td>
    <td width="1%">&nbsp;</td>
    <td width="20%">Organizzatore</td>
    <td>Denominazione</td>
    <td>Codice fiscale</td>
    <td width="1%">Tipo organizzatore</td>
  </tr>
  <v:grid-row dataset="ds">
    <td><v:grid-checkbox dataset="ds" name="OrganizerId" fieldname="OrganizerId" /></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>" repositoryId="<%=ds.getField(Sel.AccountPictureId).getString()%>"/></td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.OrganizerId).getString()%>" entityType="<%=LkSNEntityType.SiaeOrganizer%>" clazz="list-title">
        <%=ds.getField(Sel.AccountName).getHtmlString()%>
      </snp:entity-link><br />
     <span class="list-subtitle"><%=ds.getField(Sel.AccountCode).getHtmlString()%></span>
    </td>
    <td>
      <%=ds.getField(Sel.Denominazione).getHtmlString() %>
    </td>
    <td>
      <%=ds.getField(Sel.CodiceFiscale).getHtmlString() %>
    </td>
    <td>
       <%=ds.getField(Sel.TipoOrganizzatore).getHtmlString() %>
    </td>
  </v:grid-row>
</v:grid>
<script>
</script>
