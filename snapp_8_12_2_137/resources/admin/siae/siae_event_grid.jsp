<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.web.library.BLBO_Siae"%>
<%@page import="com.vgs.web.library.BLBO_Siae.SiaeLookup"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeEvent.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<%
QueryDef qdef = new QueryDef(QryBO_SiaeEvent.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.CommonStatus);
qdef.addSelect(Sel.EventId);
qdef.addSelect(Sel.TipoGenere);
qdef.addSelect(Sel.EventType);
qdef.addSelect(Sel.TitoloEvento);
qdef.addSelect(Sel.Incidenza);
qdef.addSelect(Sel.ProfilePictureId);
qdef.addSelect(Sel.EventName);
qdef.addSelect(Sel.EventCode);
qdef.addSelect(Sel.CategoryRecursiveName);
qdef.addSelect(Sel.TagNames);
qdef.addSelect(Sel.OrganizerId);
qdef.addSelect(Sel.OrganizerName);
qdef.addSelect(Sel.SiaeTax);
//Where
if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getNullParameter("FullText"));

if ((pageBase.getNullParameter("EventStatus") != null))
  qdef.addFilter(Fil.EventStatus, JvArray.stringToArray(pageBase.getNullParameter("EventStatus"), ","));

if ((pageBase.getNullParameter("TagId") != null))
  qdef.addFilter(Fil.TagId, JvArray.stringToArray(pageBase.getNullParameter("TagId"), ","));


if ((pageBase.getNullParameter("CategoryId") != null) && !pageBase.isParameter("CategoryId", "all"))
  qdef.addFilter(Fil.CategoryId, pageBase.getNullParameter("CategoryId"));

if ((pageBase.getNullParameter("OrganizerId") != null))
  qdef.addFilter(Fil.OrganizerId, pageBase.getNullParameter("OrganizerId"));

// Sort
qdef.addSort(Sel.TitoloEvento);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
BLBO_Siae bl = pageBase.getBL(BLBO_Siae.class);
%>
<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.SiaeEvent%>">
  <tr class="header">
    <td width="1%"><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td>
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Code"/>
    </td>
    <td>
      Titolo<br/>
      <v:itl key="@Category.Category"/>
    </td>
    <td>Organizzatore<br/>
      <v:itl key="@Common.Tags"/>
    </td>
    <td width="20%">Tipo Evento<br/>
      Tipo IVA
    </td>
    
    <td width="10%">Tipo genere</td>
    <td width="5%">Incidenza</td>
    
  </tr>
  <v:grid-row dataset="ds">
<%
  String code = ds.getString(Sel.EventType);
  String desc = bl.getLookupItem(SiaeLookup.TAX_TYPE, code);
  String tipoEvento = String.format("[%s] %s", code, desc);

  code = ds.getString(Sel.TipoGenere);
  desc = bl.getLookupItem(SiaeLookup.TIPO_GENERE, code);
  String tipoGenere = String.format("[%s] %s", code, desc);
%>
    <% LookupItem eventStatus = LkSN.EventStatus.getItemByCode(ds.getField(Sel.EventStatus)); %>
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox dataset="ds" name="EventId" fieldname="EventId" /></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>" repositoryId="<%=ds.getField(Sel.ProfilePictureId).getString()%>"/></td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.EventId).getString()%>" entityType="<%=LkSNEntityType.SiaeEvent%>" clazz="list-title">
        <%=ds.getField(Sel.EventName).getHtmlString()%>
      </snp:entity-link><br />
     <span class="list-subtitle"><%=ds.getField(Sel.EventCode).getHtmlString()%></span>
    </td>
    <td>
      <%=ds.getField(Sel.TitoloEvento).getHtmlString() %><br/>
      <span class="list-subtitle"><%=ds.getField(Sel.CategoryRecursiveName).getHtmlString()%>&nbsp;</span>
    </td>
    <td>
      <snp:entity-link entityId="<%=ds.getString(Sel.OrganizerId)%>" entityType="<%=LkSNEntityType.SiaeOrganizer%>">
        <%=ds.getField(Sel.OrganizerName).getHtmlString()%>
      </snp:entity-link><br/>
      <span class="list-subtitle"><%=ds.getField(Sel.TagNames).getHtmlString()%></span>&nbsp;
    </td>
    <td>
      <%=tipoEvento %><br/>
      <span class="list-subtitle"><%=ds.getField(Sel.SiaeTax).getHtmlString()%>&nbsp;</span>
    </td>
    <td>
      <%=tipoGenere %>
    </td>
    <td>
      <%=ds.getField(Sel.Incidenza).getHtmlString() %>
    </td>
  </v:grid-row>
</v:grid>
<script>
</script>
