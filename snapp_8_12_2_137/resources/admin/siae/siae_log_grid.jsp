<%@page import="com.vgs.web.library.BLBO_Siae.SealStatus"%>
<%@page import="com.vgs.snapp.library.SnappUtils"%>
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
BLBO_Siae bl = pageBase.getBL(BLBO_Siae.class);

QueryDef qdef = new QueryDef(QryBO_SiaeLog.class);
// Select

qdef.addSelect(
    Sel.IconName,
    Sel.LogId,
    Sel.Sigillo,
    Sel.EventId,
    Sel.SiaeEventTitle,
    Sel.EventTitle,
    Sel.TitoloBase,
    Sel.DataOraEmissione,
    Sel.PrezzoTitolo,
    Sel.IvaTitolo,
    Sel.DataOraEvento,
    Sel.CodiceCarta,
    Sel.ProgressivoCarta,
    Sel.TicketId,
    Sel.TicketStatus,
    Sel.MediaId,
    Sel.MediaCode,
    Sel.Operazione,
    Sel.MediaStatus,
    Sel.TicketCode,
    Sel.OriginaleSigillo,
    Sel.OriginalLogId,
    Sel.StatoCorrente,
    Sel.StatoDesc,
    Sel.TipoSupporto,
    Sel.TipoSupportoDesc,
    Sel.IsOrphan,
    Sel.PrezzoPrevendita,
    Sel.IvaPrevendita,
    Sel.ProductName,
    Sel.Smaterializzato,
    Sel.PNR,
    Sel.SaleId,
    Sel.TipoTitolo,
    Sel.MediaTDSSN,
    Sel.Stato,
    Sel.CausaleAnnullamento);


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
  
  if (pageBase.getNullParameter("WksLocationId") != null)
    qdef.addFilter(Fil.WksLocationId, pageBase.getNullParameter("WksLocationId"));

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
  
  if (pageBase.getNullParameter("TipoTitolo") != null)
    qdef.addFilter(Fil.TipoTitolo, pageBase.getNullParameter("TipoTitolo"));
  
  if (pageBase.getNullParameter("CodiceRichiedente") != null) {
    qdef.addFilter(Fil.CodiceRichiedente, pageBase.getNullParameter("CodiceRichiedente"));
  }
  
}



//Sort
qdef.addSort(Sel.LogId, false);
qdef.addSort(Sel.ProgressivoCarta, false);
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
    <td>&nbsp;</td>
    
    <td>Sigillo<br/>Data emissione</td>
    <td>Operazione<br />Titolo base - tipo</td>
    <td>PNR<br/>Stato</td>
    <td><v:itl key="@Event.Event"/></td>
    <td><v:itl key="@Ticket.Ticket"/></td>
    <td><v:itl key="@Common.Media"/></td>
    <td align="right"> Carta<br/>Progressivo</td>
    <td align="right">
      <v:itl key="@Product.Price"/><br/>
      <v:itl key="@Product.Taxes"/>
    </td>
    <td align="right">
      <v:itl key="@Product.Presale"/><br/>
      <v:itl key="@Product.Taxes"/>
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <%
    SealStatus actualStatus = bl.findSealStatus(ds.getString(Sel.TicketId), ds.getString(Sel.MediaId), ds.getString(Sel.SaleId), ds.getString(Sel.Stato), ds.getString(Sel.StatoCorrente), ds.getString(Sel.OriginalLogId), ds.getField("DataOraEmissione").getDateTime());
    %>
    <td style="<%=bl.getStatusStyle(actualStatus)%>"><v:grid-checkbox dataset="ds" name="Sigillo" fieldname="Sigillo" /></td>
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
         <span title="<%=ds.getField(Sel.LogId).getHtmlString()%>"><%=ds.getField(Sel.Sigillo).getHtmlString()%></span>
      </snp:entity-link><br />
      <span class="list-subtitle"><%=pageBase.format(ds.getField(Sel.DataOraEmissione), pageBase.getShortDateTimeFormat(), true)%> </span>
    </td>
    <td nowrap>
      <% if (LkSNSiaeOperationType.VOID.getCode() == ds.getInt(Sel.Operazione)) { %>
           <snp:entity-link entityId="<%=ds.getField(Sel.OriginaleSigillo).getHtmlString()%>" entityType="<%=LkSNEntityType.SiaeLog%>" clazz="list-title">
             <span title="<%=ds.getField(Sel.OriginalLogId).getHtmlString()%>"><%=LkSN.SiaeOperationType.getItemByCode(ds.getInt(Sel.Operazione))%></span>
           </snp:entity-link>
      <% } else { %>
        <%=LkSN.SiaeOperationType.getItemByCode(ds.getInt(Sel.Operazione))%>
      <% } %>
      <br /><span class="list-subtitle"><%=TitoloBase.fromCode(ds.getString(Sel.TitoloBase)).toString()%> &mdash; <%=ds.getString(Sel.TipoTitolo).toString()%></span>
    </td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.SaleId).getHtmlString()%>" entityType="<%=LkSNEntityType.Sale%>">
        <%=ds.getField(Sel.PNR).getHtmlString()%>
      </snp:entity-link><br />
      <span class="list-subtitle"><%=bl.getStatusDescription(actualStatus)%> &nbsp; <%=ds.getField(Sel.CausaleAnnullamento).getHtmlString() %>  </span>
    </td>
    <td>
      <%=ds.getField(Sel.SiaeEventTitle).getHtmlString()%> <br />
      <span class="list-subtitle"><%=pageBase.format(ds.getField(Sel.DataOraEvento), pageBase.getShortDateTimeFormat(), true)%></span> 
    </td>
    <td nowrap>
      <% 
      String ticketId = ds.getString(Sel.TicketId);
      String mediaId = ds.getString(Sel.MediaId);
      boolean isDigital = ds.getField(Sel.Smaterializzato).getBoolean();
      %>
      <% if (ticketId != null) { %>
        <snp:entity-link entityId="<%=ds.getField(Sel.TicketId).getHtmlString()%>" entityType="<%=LkSNEntityType.Ticket%>">
          <%=ds.getField(Sel.TicketCode).getHtmlString()%>
        </snp:entity-link>
        &mdash;
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
      <br /> <span class="list-subtitle"><%=ds.getField(Sel.ProductName).getHtmlString()%></span>
    </td>
    <td nowrap>
      <% if (mediaId != null) { %>
        <snp:entity-link entityId="<%=ds.getField(Sel.MediaId).getHtmlString()%>" entityType="<%=LkSNEntityType.Media%>">
        <%=ds.getField(Sel.MediaTDSSN).getHtmlString()%>
        </snp:entity-link>
        &mdash;
<%--         <span class="list-subtitle" title="<%=ds.getField(Sel.TipoSupportoDesc).getHtmlString()%>"><%=ds.getField(Sel.TipoSupporto).getHtmlString()%></span> --%>
        <% String mediaTypeCode = ds.getBoolean(Sel.Smaterializzato) ? BLBO_Siae.getCodiceSupportoDigitale() : BLBO_Siae.getCodiceSupportoTradizionale();%>
        <%String mediaTypeDesc = ds.getBoolean(Sel.Smaterializzato) ? BLBO_Siae.getDescSupportoDigitale() : BLBO_Siae.getDescSupportoTradizionale();%>
        <span class="list-subtitle" title="<%=mediaTypeDesc%>"><%=mediaTypeCode%></span>
        <br /> <span class="list-subtitle"><%=ds.getField(Sel.MediaCode).getHtmlString()%></span>
      <% } %>
    </td>
    <td align="right">
      <%=ds.getField(Sel.CodiceCarta).getHtmlString()%><br />
      <span class="list-subtitle"><%=ds.getField(Sel.ProgressivoCarta).getHtmlString()%></span>
    </td>
    <td  align="right">
      <%=pageBase.formatCurrHtml(ds.getField(Sel.PrezzoTitolo)) %><br />
      <span class="list-subtitle"><%=pageBase.formatCurrHtml(ds.getField(Sel.IvaTitolo)) %></span>
    </td>
    <td  align="right">
      <%=pageBase.formatCurrHtml(ds.getField(Sel.PrezzoPrevendita)) %><br />
      <span class="list-subtitle"><%=pageBase.formatCurrHtml(ds.getField(Sel.IvaPrevendita)) %></span>
    </td>
  </v:grid-row>
</v:grid>