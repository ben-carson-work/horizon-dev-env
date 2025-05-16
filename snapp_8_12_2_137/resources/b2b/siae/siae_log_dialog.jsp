<%@page import="com.vgs.snapp.dataobject.DODB.*"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeLog.*"%>
<%@page import="org.apache.poi.ss.formula.ptg.TblPtg"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="static com.vgs.snapp.lookup.LkSNSiaeCardStatus.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.BLBO_Siae"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
  QueryDef qdef = new QueryDef(QryBO_SiaeLog.class);
//Select

qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.LogId);
qdef.addSelect(Sel.Sigillo);
qdef.addSelect(Sel.WorkstationId);
qdef.addSelect(Sel.WorkstationName);
qdef.addSelect(Sel.WorkstationCode);
qdef.addSelect(Sel.EventId);
qdef.addSelect(Sel.SiaeEventTitle);
qdef.addSelect(Sel.EventTitle);
qdef.addSelect(Sel.TitoloBase);
qdef.addSelect(Sel.DataOraEmissione);
qdef.addSelect(Sel.PrezzoTitolo);
qdef.addSelect(Sel.IvaTitolo);
qdef.addSelect(Sel.DataOraEvento);
qdef.addSelect(Sel.CodiceSistema);
qdef.addSelect(Sel.CodiceCarta);
qdef.addSelect(Sel.ProgressivoCarta);
qdef.addSelect(Sel.MediaCode);
qdef.addSelect(Sel.MediaId);
qdef.addSelect(Sel.MediaPrintDate);
qdef.addSelect(Sel.StatoCorrente);
qdef.addSelect(Sel.Operazione);
qdef.addSelect(Sel.OrdinePosto);
qdef.addSelect(Sel.Posto);
qdef.addSelect(Sel.IvaPreassolta);
qdef.addSelect(Sel.TipoTurno);
qdef.addSelect(Sel.TipoTassazione);
qdef.addSelect(Sel.PrezzoPrevendita);
qdef.addSelect(Sel.IvaPrevendita);
qdef.addSelect(Sel.Rateo);
qdef.addSelect(Sel.IvaRateo);
qdef.addSelect(Sel.TipoTitolo);
qdef.addSelect(Sel.Smaterializzato);
qdef.addSelect(Sel.ImponibileIntrattenimenti);
qdef.addSelect(Sel.IvaIntrattenimenti);
qdef.addSelect(Sel.RateoIntrattenimenti);
qdef.addSelect(Sel.IvaRateoIntrattenimenti);
qdef.addSelect(Sel.OrganizerName);
qdef.addSelect(Sel.OrganizerCodiceFiscale);
qdef.addSelect(Sel.LocationName);
qdef.addSelect(Sel.PerformanceId);
qdef.addSelect(Sel.PerformanceFrom);
qdef.addSelect(Sel.OrganizerId);
qdef.addSelect(Sel.LocationId);
qdef.addSelect(Sel.LocationCode);
qdef.addSelect(Sel.TicketId);
qdef.addSelect(Sel.TicketCode);
qdef.addSelect(Sel.TipoSupporto);
qdef.addSelect(Sel.TipoSupportoDesc);
qdef.addSelect(Sel.CodiceAbbonamento);
qdef.addSelect(Sel.SerialeAbbonamento);
qdef.addSelect(Sel.ValiditaAbbonamento);
qdef.addSelect(Sel.EventiAbilitati);
qdef.addSelect(Sel.OriginalLogId);
qdef.addSelect(Sel.OriginaleSigillo);
qdef.addSelect(Sel.OriginaleCodiceCarta);
qdef.addSelect(Sel.OriginaleProgressivo);
qdef.addSelect(Sel.OriginaleDataEmissione);
qdef.addSelect(Sel.VoidSigillo);
qdef.addSelect(Sel.VoidCarta);
qdef.addSelect(Sel.VoidProgressivo);
qdef.addSelect(Sel.VoidStato);
qdef.addSelect(Sel.VoidDataEmissione);
qdef.addSelect(Sel.VoidReason);
qdef.addSelect(Sel.Smaterializzato);
qdef.addSelect(Sel.ProductName);

String logId = pageBase.getEmptyParameter("id");
qdef.addFilter(Fil.Sigillo, logId);

//Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
//Exec
JvDataSet ds = pageBase.execQuery(qdef);

tbSiaeLog log = new tbSiaeLog();
log.assign(ds);
request.setAttribute("ds", ds);
request.setAttribute("log", log);

BLBO_Siae bl = pageBase.getBL(BLBO_Siae.class);
String titoloBase = log.TitoloBase.getString();
log.TitoloBase.setString(BLBO_Siae.TitoloBase.fromCode(titoloBase).toString());

String stateCode = log.StatoCorrente.getString();
String stateDesc = bl.getLookupItem(BLBO_Siae.SiaeLookup.STATO_DEL_TITOLO, stateCode);
String title = String.format("[%s] %s", stateCode, stateDesc);
log.Stato.setString(title);

String sectorCode = log.OrdinePosto.getString();
String sectorDesc = bl.getLookupItem(BLBO_Siae.SiaeLookup.ORDINI_DI_POSTI, sectorCode);
title = String.format("[%s] %s", sectorCode, sectorDesc);
log.OrdinePosto.setString(title);

String reductionCode = log.TipoTitolo.getString();
String reductionDesc = bl.getLookupItem(BLBO_Siae.SiaeLookup.TIPO_TITOLO, reductionCode);
title = String.format("[%s] %s", reductionCode, reductionDesc);
log.TipoTitolo.setString(title);

String eventTypeCode = log.TipoTassazione.getString();
String eventTypeDesc = bl.getLookupItem(BLBO_Siae.SiaeLookup.TAX_TYPE, eventTypeCode);
title = String.format("[%s] %s", eventTypeCode, eventTypeDesc);
log.TipoTassazione.setString(title);

String mediaTypeCode = ds.getString(Sel.TipoSupporto);
String mediaTypeDesc = ds.getString(Sel.TipoSupportoDesc);
String mediaType = String.format("[%s] %s", mediaTypeCode, mediaTypeDesc);

String voidReason = ds.getString(Sel.VoidReason);
if (voidReason != null) {
  String desc = bl.getLookupItem(BLBO_Siae.SiaeLookup.VOID_REASON, voidReason);
  voidReason = "[" + voidReason + "] " + desc;
}

String ivaTitolo = "[N] No";
if ("S".equals(log.IvaPreassolta.getString())) {
  ivaTitolo = "[S] Si";
}
log.IvaPreassolta.setString(ivaTitolo);

boolean isVoid = log.Operazione.getInt() == 1;
boolean isVoided = isVoid || !ds.getField(Sel.VoidSigillo).isNull();

String dialogTitle = String.format("Dati della transazione fiscale: %s %s %s", log.CodiceCarta.getString(), log.ProgressivoCarta.getString(), log.Sigillo.getString());
%>
<v:dialog id="log_dialog" icon="siae.png" title="<%=dialogTitle %>" width="800" height="600" autofocus="false">
<v:widget caption="Dati dell'emissione">
    <v:form-field caption="Workstation">
        <%=ds.getField(Sel.WorkstationName).getHtmlString()%> 
        <span class="list-subtitle">(<%=ds.getField(Sel.WorkstationCode).getHtmlString()%>)</span>
<%--         <snp:entity-link entityId="<%=log.WorkstationId.getString()%>" entityType="<%=LkSNEntityType.Workstation%>"> --%>
<%--           <%=ds.getField(Sel.WorkstationName).getHtmlString()%>  --%>
<%--           <span class="list-subtitle">(<%=ds.getField(Sel.WorkstationCode).getHtmlString()%>)</span> --%>
<%--         </snp:entity-link> --%>
    </v:form-field>
    <v:form-field caption="Data ora emissione">
      <input type="text" readonly="readonly" value="<%=pageBase.format(ds.getField(Sel.DataOraEmissione), pageBase.getShortDateTimeFormat(), true)%>" />
    </v:form-field>
    <% if (isVoid) { %>
    <v:form-field caption="Causale">
      <v:input-text field="log.Stato" enabled="false" />
    </v:form-field>
    <% } %>
    <v:form-field caption="Tipo titolo">
      <v:input-text field="log.TipoTitolo" enabled="false" />
    </v:form-field>    
    <v:form-field caption="Operazione">
      <input type="text" value="<%=LkSN.SiaeOperationType.findItemByCode(ds.getInt(Sel.Operazione))%>" readonly="readonly" />
    </v:form-field>
    <v:form-field caption="Titolo base">
      <v:input-text field="log.TitoloBase" enabled="false" />
    </v:form-field>
</v:widget>
<v:widget caption="Dati Biglietto">
<% if (isVoid)  { %>
  <v:form-field caption="Carta Attivazione">
    <input type="text" readonly="readonly" value="<%=ds.getString(Sel.OriginaleCodiceCarta) %>" />
  </v:form-field>
  <v:form-field caption="Numero Progressivo">
    <input type="text" readonly="readonly" value="<%=ds.getString(Sel.OriginaleProgressivo) %>" />
  </v:form-field>
  <v:form-field caption="Sigilllo Fiscale">
    <input type="text" readonly="readonly" value="<%=ds.getString(Sel.OriginaleSigillo) %>" />
  </v:form-field>
  <v:form-field caption="Data ora Sigillo">
    <input type="text" readonly="readonly" value="<%=pageBase.format(ds.getField(Sel.OriginaleDataEmissione), pageBase.getShortDateTimeFormat(), true)%>" />
  </v:form-field>
<% } else { %>
  <v:form-field caption="Carta Attivazione">
    <v:input-text field="log.CodiceCarta" enabled="false" />
  </v:form-field>
  <v:form-field caption="Numero Progressivo">
    <v:input-text field="log.ProgressivoCarta" enabled="false" />
  </v:form-field>
  <v:form-field caption="Sigilllo Fiscale">
    <v:input-text field="log.Sigillo" enabled="false" />
  </v:form-field>
  <v:form-field caption="Data ora Sigillo">
    <input type="text" readonly="readonly" value="<%=pageBase.format(ds.getField(Sel.DataOraEmissione), pageBase.getShortDateTimeFormat(), true)%>" />
  </v:form-field>
<% } %>
<% if (!log.TicketId.isNull()) { %>
  <% if (!"F".equals(titoloBase)) { %>
    <v:form-field caption="Data ora di STAMPA">
      <input type="text" readonly="readonly" value="<%=pageBase.format(ds.getField(Sel.MediaPrintDate), pageBase.getShortDateTimeFormat(), true)%>" />
    </v:form-field>  
  <% } %>
  <v:form-field caption="Tipo di supporto">
    <input type="text" readonly="readonly" value="<%=mediaType%>" />
  </v:form-field>
  <v:form-field caption="BarCode">
    <%=ds.getField(Sel.MediaCode).getHtmlString()%>
<%--     <snp:entity-link entityId="<%=ds.getField(Sel.MediaId).getHtmlString()%>" entityType="<%=LkSNEntityType.Media%>"> --%>
<%--         <%=ds.getField(Sel.MediaCode).getHtmlString() %> --%>
<%--       </snp:entity-link> --%>
  </v:form-field>

  <v:form-field caption="Biglietto">
    <%=ds.getField(Sel.TicketCode).getHtmlString() %>
<%--     <snp:entity-link entityId="<%=log.TicketId.getString() %>" entityType="<%=LkSNEntityType.Ticket%>"> --%>
<%--         <%=ds.getField(Sel.TicketCode).getHtmlString() %> --%>
<%--     </snp:entity-link> --%>
  </v:form-field>
  <v:form-field caption="Stato titolo">
    <v:input-text field="log.Stato" enabled="false" />
  </v:form-field>
<% } %>
  <v:form-field caption="Smaterializzato">
    <input type="checkbox" readonly disabled <% if (log.Smaterializzato.getBoolean()) { %> checked<% } %> />
  </v:form-field>
</v:widget>

<% 
String blockTitle = "Dati Spettacolo";
boolean isIngress = "F".indexOf(titoloBase) != -1;
boolean isAbbonamento = "AF".indexOf(titoloBase) != -1;
boolean hasPerformance = "TF".indexOf(titoloBase) != -1;
if (isAbbonamento) {
  blockTitle = "Dati Abbonamento";
}
%>
<v:widget caption="<%=blockTitle%>">
  <% if (isAbbonamento) { %>
    <v:form-field caption="Turno">
      <input type="text" value="<%=LkSN.SiaeTipoTurno.findItemByCode(ds.getInt(Sel.TipoTurno)) %>" readonly="readonly" />
    </v:form-field>
    <v:form-field caption="Codice abbonamento">
      <input type="text" disabled value="<%=ds.getField(Sel.CodiceAbbonamento).getHtmlString()%>:<%=ds.getField(Sel.SerialeAbbonamento).getHtmlString()%>" />
    </v:form-field>
    <v:form-field caption="Validita">
      <input type="text" disabled value="<%=ds.getField(Sel.ValiditaAbbonamento).getHtmlString()%>" />
    </v:form-field>
    <v:form-field caption="Eventi abilitati">
      <input type="text" disabled value="<%=ds.getField(Sel.EventiAbilitati).getHtmlString()%>" />
    </v:form-field>
    <% } %>
    <% if (hasPerformance) { %>
      <v:form-field caption="Titolo evento">
        <% if (ds.getField(Sel.PerformanceId).isNull()) {%>
          <input type="text" readonly="readonly" value="" />
        <% } else { %>
          <%=ds.getField(Sel.EventTitle).getHtmlString() + " — " + pageBase.format(ds.getField(Sel.PerformanceFrom), 
                pageBase.getShortDateTimeFormat(), true) %>
<%--           <snp:entity-link entityId="<%=log.PerformanceId.getString()%>" entityType="<%=LkSNEntityType.Performance%>"> --%>
<%--             <%=ds.getField(Sel.EventTitle).getHtmlString() + " — " + pageBase.format(ds.getField(Sel.PerformanceFrom),  --%>
<%--                 pageBase.getShortDateTimeFormat(), true) %> --%>
<%--           </snp:entity-link> --%>
        <% }%>
      </v:form-field>
      <v:form-field caption="Data evento">
        <input type="text" readonly="readonly" value="<%=pageBase.format(ds.getField(Sel.DataOraEvento), pageBase.getShortDateTimeFormat(), true)%>" />
      </v:form-field>
      <v:form-field caption="Locale">
        <%if (!log.LocationId.isNull()) {%>
          <%=ds.getField(Sel.LocationName).getHtmlString() %>
<%--         <snp:entity-link entityId="<%=log.LocationId.getString()%>" entityType="<%=LkSNEntityType.SiaeLocation%>"> --%>
<%--             <%=ds.getField(Sel.LocationName).getHtmlString() %>  --%>
<%--             <span class="list-subtitle">(<%=ds.getField(Sel.LocationCode).getHtmlString() %>)</span> --%>
<%--         </snp:entity-link> --%>
        <% } %>
      </v:form-field>
  <% } %>
  <v:form-field caption="Organizzatore">
    <%=ds.getField(Sel.OrganizerName).getHtmlString()%>
<%--     <snp:entity-link entityId="<%=log.OrganizerId.getString()%>" entityType="<%=LkSNEntityType.SiaeOrganizer%>"> --%>
<%--         <%=ds.getField(Sel.OrganizerName).getHtmlString()%> --%>
<%--     </snp:entity-link> --%>
    <span class="list-subtitle"> C.F.: <%=ds.getField(Sel.OrganizerCodiceFiscale).getHtmlString()%></span>
  </v:form-field>
  <v:form-field caption="Prodotto">
    <input type="text" readonly="readonly" value="<%=ds.getField(Sel.ProductName).getHtmlString()%>" />
  </v:form-field>
  <v:form-field caption="Importo Titolo">
    <input type="text" readonly="readonly" value="<%=log.PrezzoTitolo %> (IVA: <%=log.IvaTitolo %>) <%=reductionDesc%>" />
  </v:form-field>
  <v:form-field caption="Importo Prevendita">
    <input type="text" readonly="readonly" value="<%=log.PrezzoPrevendita %> (IVA: <%=log.IvaPrevendita %>)" />
  </v:form-field>
  <v:form-field caption="Importo Totale">
    <input type="text" readonly="readonly" value="<%=log.PrezzoTitolo %> (Prezzo+Prevendita+Commissioni))" />
  </v:form-field>
  <v:form-field caption="IVA preassolta">
    <input type="text" readonly="readonly" value="<%=ivaTitolo %>" />
  </v:form-field>
  <v:form-field caption="Importi figurativo">
    <% if ("F".indexOf(titoloBase) != -1) { %>
      <input type="text" readonly="readonly" value="<%=log.Rateo %> (IVA: <%=log.IvaRateo %>)" />
    <% } else { %>
      <input type="text" readonly="readonly" value="0 (IVA: 0)" />
    <% } %>
  </v:form-field>
  <v:form-field caption="Ordine di posto (settore)">
    <v:input-text field="log.OrdinePosto" enabled="false" />
  </v:form-field>
  <v:form-field caption="Posto / Fila">
    <v:input-text field="log.Posto" enabled="false" />
  </v:form-field>
</v:widget>


<% if (isVoided) {%>
<v:widget caption="Dati Titolo di accesso ANNULLATO">
  <% if (isVoid) { %>
    <v:form-field caption="Data ora di annullamento">
      <input type="text" disabled value="<%=pageBase.format(ds.getField(Sel.DataOraEmissione), pageBase.getShortDateTimeFormat(), true)%>" />
    </v:form-field>
    <v:form-field caption="Codice carta">
      <v:input-text field="log.CodiceCarta" enabled="false" />
    </v:form-field>
    <v:form-field caption="Sigillo annullo">
      <v:input-text field="log.Sigillo" enabled="false" />
    </v:form-field>
    <v:form-field caption="Progressivo">
      <v:input-text field="log.ProgressivoCarta" enabled="false" />
    </v:form-field>
    <v:form-field caption="Causale">
      <input type="text" disabled value="<%=voidReason %>" />
    </v:form-field>
  <% } else { %>
    <v:form-field caption="Data ora di annullamento">
      <input type="text" disabled value="<%=pageBase.format(ds.getField(Sel.VoidDataEmissione), pageBase.getShortDateTimeFormat(), true)%>" />
    </v:form-field>
    <v:form-field caption="Codice carta">
      <input type="text" disabled value="<%=ds.getString(Sel.VoidCarta) %>" />
    </v:form-field>
    <v:form-field caption="Sigillo annullo">
      <input type="text" disabled value="<%=ds.getString(Sel.VoidSigillo) %>" />
    </v:form-field>
    <v:form-field caption="Progressivo">
      <input type="text" disabled value="<%=ds.getString(Sel.VoidProgressivo) %>" />
    </v:form-field>
    <v:form-field caption="Causale">
      <input type="text" disabled value="<%=voidReason %>" />
    </v:form-field>
  <% } %>
</v:widget>
<% } %>
<script>

$(document).ready(function() {
  var dlg = $("#log_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        text: <v:itl key="@Common.Cancel" encode="JS"/>,
        click: doCloseDialog
      }
    ];
  });
});
</script>
</v:dialog>