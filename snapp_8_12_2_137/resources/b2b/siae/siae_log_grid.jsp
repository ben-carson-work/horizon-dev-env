<%@page import="com.vgs.web.library.BLBO_Siae.TitoloBase"%>
<%@page import="com.vgs.web.library.BLBO_Siae"%>
<%@page import="com.vgs.vcl.NvSubIcon"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeLog.Sel"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeLog.Fil"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<%
  QueryDef qdef = new QueryDef(QryBO_SiaeLog.class);
// Select

qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.LogId);
qdef.addSelect(Sel.Sigillo);
qdef.addSelect(Sel.EventId);
qdef.addSelect(Sel.SiaeEventTitle);
qdef.addSelect(Sel.EventTitle);
qdef.addSelect(Sel.TitoloBase);
qdef.addSelect(Sel.DataOraEmissione);
qdef.addSelect(Sel.PrezzoTitolo);
qdef.addSelect(Sel.IvaTitolo);
qdef.addSelect(Sel.DataOraEvento);
qdef.addSelect(Sel.CodiceCarta);
qdef.addSelect(Sel.ProgressivoCarta);
qdef.addSelect(Sel.TicketId);
qdef.addSelect(Sel.TicketStatus);
qdef.addSelect(Sel.MediaId);
qdef.addSelect(Sel.MediaCode);
qdef.addSelect(Sel.Operazione);
qdef.addSelect(Sel.MediaStatus);
qdef.addSelect(Sel.TicketCode);
qdef.addSelect(Sel.OriginaleSigillo);
qdef.addSelect(Sel.OriginalLogId);
qdef.addSelect(Sel.StatoCorrente);
qdef.addSelect(Sel.StatoDesc);
qdef.addSelect(Sel.TipoSupporto);
qdef.addSelect(Sel.TipoSupportoDesc);
qdef.addSelect(Sel.IsOrphan);
qdef.addSelect(Sel.PrezzoPrevendita);
qdef.addSelect(Sel.IvaPrevendita);
qdef.addSelect(Sel.ProductName);
qdef.addSelect(Sel.Smaterializzato);

String mainFilter = pageBase.getNullParameter("MainFilter");
if (mainFilter != null) {
  if (mainFilter.length() == 14) // length of codice media is 14
    qdef.addFilter(Fil.MediaCode, mainFilter);
  else // default Sigillo
    qdef.addFilter(Fil.Sigillo, mainFilter);
  
} else {
  if (pageBase.getNullParameter("FromDateTime") != null)
    qdef.addFilter(Fil.FromDateTime, pageBase.getNullParameter("FromDateTime"));
  
  if (pageBase.getNullParameter("ToDateTime") != null)
    qdef.addFilter(Fil.ToDateTime, pageBase.getNullParameter("ToDateTime"));
  
  if (pageBase.getNullParameter("PerformanceId") != null)
    qdef.addFilter(Fil.PerformanceId, pageBase.getNullParameter("PerformanceId"));
  
  if (pageBase.getNullParameter("CardId") != null)
    qdef.addFilter(Fil.CardId, pageBase.getNullParameter("CardId"));
  
  if (pageBase.getNullParameter("CounterFilter") != null)
    qdef.addFilter(Fil.ProgressivoCarta, pageBase.getNullParameter("CounterFilter"));
  
  if (pageBase.getNullParameter("AccountId") != null)
    qdef.addFilter(Fil.WksLocationId, pageBase.getNullParameter("AccountId"));

  if (pageBase.getNullParameter("OpAreaId") != null)
    qdef.addFilter(Fil.OpAreaId, pageBase.getNullParameter("OpAreaId"));
  
  if (pageBase.getNullParameter("WorkstationId") != null)
    qdef.addFilter(Fil.WorkstationId, pageBase.getNullParameter("WorkstationId"));
  
  if (pageBase.getNullParameter("PartnerAccountId") != null)
    qdef.addFilter(Fil.PartnerAccountId, pageBase.getNullParameter("PartnerAccountId"));
  
  if (pageBase.getNullParameter("TitoloBase") != null)
    qdef.addFilter(Fil.TitoloBase, pageBase.getNullParameter("TitoloBase"));
  
  if (pageBase.getNullParameter("Operazione") != null)
    qdef.addFilter(Fil.Operazione, pageBase.getNullParameter("Operazione"));
  
  if (pageBase.getNullParameter("OrdinePosto") != null)
    qdef.addFilter(Fil.OrdinePosto, pageBase.getNullParameter("OrdinePosto"));
}

BLBO_Siae bl = pageBase.getBL(BLBO_Siae.class);

//Sort
qdef.addSort(Sel.LogId, false);
qdef.addSort(Sel.ProgressivoCarta, false);
//Where
qdef.addFilter(Fil.PartnerAccountId, pageBase.getSession().getOrgAccountId());

// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.SiaeLog%>">
  <tr class="header">
    <td width="1%"><v:grid-checkbox header="true"/></td>
    <td width="1%">&nbsp;</td>
    <td>Sigillo<br />Id</td>
    <td>Operazione</td>
    <td>Date<br />emissione</td>
    <td>Evento</td>
    <td>Prodotto</td>
    <td>Date Evento</td>
    <td>Ticket</td>
    <td>Codice Media</td>
    <td>Titolo<br />base</td>
    <td>Prezzo<br />Taxes</td>
    <td>Prev.<br />Taxes</td>
    <td>Carta<br />Progressivo</td>
  </tr>
  <v:grid-row dataset="ds">
    <td><v:grid-checkbox dataset="ds" name="Sigillo" fieldname="Sigillo" /></td>
    <td>
      <% if (ds.getField(Sel.IsOrphan).getBoolean()) { %>
        <% String icon = ds.getString(Sel.IconName) + "|" + NvSubIcon.Cancel; %>
       <v:grid-icon name="<%=icon%>" title="is orphan" />
      <% } else { %>
        <v:grid-icon name="<%=ds.getString(Sel.IconName)%>"/>
      <% } %>
    </td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.Sigillo).getHtmlString()%>" entityType="<%=LkSNEntityType.SiaeLog%>" clazz="list-title">
        <%=ds.getField(Sel.Sigillo).getHtmlString()%>
      </snp:entity-link><br />
      <span class="list-subtitle"><%=ds.getField(Sel.LogId).getHtmlString()%></span>
    </td>
    <td>
      <%=LkSN.SiaeOperationType.getItemByCode(ds.getInt(Sel.Operazione))%>
      <%
        if (LkSNSiaeOperationType.VOID.getCode() == ds.getInt(Sel.Operazione)) {
      %>
        <br /><span class="list-subtitle"><%=ds.getField(Sel.OriginalLogId).getHtmlString()%></span>
      <% } %>
    </td>
    <td>
      <%=pageBase.format(ds.getField(Sel.DataOraEmissione), pageBase.getShortDateTimeFormat(), true)%>
    </td>
    <td>
      <%=ds.getField(Sel.SiaeEventTitle).getHtmlString()%> <br />
      <span class="list-subtitle"><%=ds.getField(Sel.EventTitle).getHtmlString()%></span>
    </td>
    <td>
      <%=ds.getField(Sel.ProductName).getHtmlString()%>
    </td>
    <td>
      <%=pageBase.format(ds.getField(Sel.DataOraEvento), pageBase.getShortDateTimeFormat(), true)%>
    </td>
    <td>
      <% 
      String ticketId = ds.getString(Sel.TicketId);
      String mediaId = ds.getString(Sel.MediaId);
      boolean isDigital = ds.getField(Sel.Smaterializzato).getBoolean();
      %>
      <% if (ticketId != null) { %>
        <%=ds.getField(Sel.TicketCode).getHtmlString()%> <br />
        <br/>
        <span class="list-subtitle" title="<%=ds.getField(Sel.StatoDesc).getHtmlString()%>">
          <%=ds.getField(Sel.StatoCorrente).getHtmlString()%>
          <% if (isDigital) { %>
            (Smaterializzato)
          <% } %>
        </span>
      <% } else if (isDigital) { %>
        <span class="list-subtitle">Smaterializzato</span>
      <% } else if (ds.getField(Sel.StatoCorrente).getString().startsWith("A")) { %>
        <span class="list-subtitle" title="<%=ds.getField(Sel.StatoDesc).getHtmlString()%>">
          <%=ds.getField(Sel.StatoCorrente).getHtmlString()%>
        </span>
      <% } %>
    </td>
    <td>
      <% if (mediaId != null) { %>
        <%=ds.getField(Sel.MediaCode).getHtmlString()%> <br />
        <br /><span class="list-subtitle" title="<%=ds.getField(Sel.TipoSupportoDesc).getHtmlString()%>"><%=ds.getField(Sel.TipoSupporto).getHtmlString()%></span>
      <% } %>
    </td>
    <td>
      <%=TitoloBase.fromCode(ds.getString(Sel.TitoloBase)).toString() %>
    </td>
    <td>
      <%=pageBase.formatCurrHtml(ds.getField(Sel.PrezzoTitolo)) %><br />
      <span class="list-subtitle"><%=pageBase.formatCurrHtml(ds.getField(Sel.IvaTitolo)) %></span>
    </td>
    <td>
      <%=pageBase.formatCurrHtml(ds.getField(Sel.PrezzoPrevendita)) %><br />
      <span class="list-subtitle"><%=pageBase.formatCurrHtml(ds.getField(Sel.IvaPrevendita)) %></span>
    </td>
    <td>
      <%=ds.getField(Sel.CodiceCarta).getHtmlString()%><br />
      <span class="list-subtitle"><%=ds.getField(Sel.ProgressivoCarta).getHtmlString()%></span>
    </td>
  </v:grid-row>
</v:grid>