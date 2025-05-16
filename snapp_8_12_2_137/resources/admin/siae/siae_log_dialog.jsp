<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.dataobject.DODB.*"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeLog.*"%>
<%@page import="org.apache.poi.ss.formula.ptg.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="accountLogin" scope="request" class="com.vgs.snapp.dataobject.DOAccountLogin"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_SiaeLog.class);
//Select
qdef.addSelect(Sel.IconName,
  Sel.LogId,
  Sel.Sigillo,
  Sel.WorkstationId,
  Sel.WorkstationName,
  Sel.WorkstationCode,
  Sel.EventId,
  Sel.SiaeEventTitle,
  Sel.EventTitle,
  Sel.TitoloBase,
  Sel.DataOraEmissione,
  Sel.PrezzoTitolo,
  Sel.IvaTitolo,
  Sel.DataOraEvento,
  Sel.CodiceSistema,
  Sel.CodiceCarta,
  Sel.ProgressivoCarta,
  Sel.MediaCode,
  Sel.MediaId,
  Sel.MediaPrintDate,
  Sel.StatoCorrente,
  Sel.Operazione,
  Sel.OrdinePosto,
  Sel.Posto,
  Sel.IvaPreassolta,
  Sel.TipoTurno,
  Sel.TipoTassazione,
  Sel.PrezzoPrevendita,
  Sel.IvaPrevendita,
  Sel.Rateo,
  Sel.IvaRateo,
  Sel.TipoTitolo,
  Sel.Smaterializzato,
  Sel.ImponibileIntrattenimenti,
  Sel.IvaIntrattenimenti,
  Sel.RateoIntrattenimenti,
  Sel.IvaRateoIntrattenimenti,
  Sel.OrganizerName,
  Sel.OrganizerCodiceFiscale,
  Sel.LocationName,
  Sel.PerformanceId,
  Sel.PerformanceFrom,
  Sel.OrganizerId,
  Sel.LocationId,
  Sel.LocationCode,
  Sel.TicketId,
  Sel.TicketCode,
  Sel.TipoSupporto,
  Sel.TipoSupportoDesc,
  Sel.CodiceAbbonamento,
  Sel.SerialeAbbonamento,
  Sel.SerialeAbbonamentoOriginal,
  Sel.ValiditaAbbonamento,
  Sel.EventiAbilitati,
  Sel.OriginalLogId,
  Sel.OriginaleSigillo,
  Sel.OriginaleCodiceCarta,
  Sel.OriginaleProgressivo,
  Sel.OriginaleDataEmissione,
  Sel.VoidSigillo,
  Sel.VoidCarta,
  Sel.VoidProgressivo,
  Sel.VoidStato,
  Sel.VoidDataEmissione,
  Sel.VoidReason,
  Sel.ProductName,
  Sel.Stato,
  Sel.CodiceRichiedente);

String logId = pageBase.getEmptyParameter("id");
qdef.addFilter(Fil.Sigillo, logId);

//Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
//Exec
JvDataSet ds = pageBase.execQuery(qdef);

BLBO_Siae bl = pageBase.getBL(BLBO_Siae.class);
String titoloBase = ds.getString(Sel.TitoloBase);
String titoloBaseExt = BLBO_Siae.TitoloBase.fromCode(titoloBase).toString();

String stateCode = ds.getString(Sel.StatoCorrente);
String stateDesc = bl.getLookupItem(BLBO_Siae.SiaeLookup.STATO_DEL_TITOLO, stateCode);

String sectorCode = ds.getString(Sel.OrdinePosto);
String sectorDesc = bl.getLookupItem(BLBO_Siae.SiaeLookup.ORDINI_DI_POSTI, sectorCode);
String sectors = String.format("[%s] %s", sectorCode, sectorDesc);

String reductionCode = ds.getString(Sel.TipoTitolo);
String reductionDesc = bl.getLookupItem(BLBO_Siae.SiaeLookup.TIPO_TITOLO, reductionCode);
String reductions = String.format("[%s] %s", reductionCode, reductionDesc);

String mediaTypeCode = ds.getBoolean(Sel.Smaterializzato) ? BLBO_Siae.getCodiceSupportoDigitale() : BLBO_Siae.getCodiceSupportoTradizionale();  //ds.getString(Sel.TipoSupporto);
String mediaTypeDesc = ds.getBoolean(Sel.Smaterializzato) ? BLBO_Siae.getDescSupportoDigitale() : BLBO_Siae.getCodiceSupportoTradizionale();   //ds.getString(Sel.TipoSupportoDesc);
String mediaType = String.format("[%s] %s", mediaTypeCode, mediaTypeDesc);

String voidReason = ds.getString(Sel.VoidReason);
if (voidReason != null) {
  String desc = bl.getLookupItem(BLBO_Siae.SiaeLookup.VOID_REASON, voidReason);
  voidReason = "[" + voidReason + "] " + desc;
}

String ivaTitolo = "[S] Si"; 
if ("N".equals(ds.getString(Sel.IvaPreassolta))) {
  ivaTitolo = "[N] No";
}

JvDataSet dsVoidReasons = bl.getSiaeLookupItemsDS(BLBO_Siae.SiaeLookup.VOID_REASON);

boolean isVoid =  ds.getInt(Sel.Operazione) == 1;
boolean isVoided = isVoid || !ds.getField(Sel.VoidSigillo).isNull();

tbSiaeLog siaeLog = new tbSiaeLog();
siaeLog.assign(ds);
boolean isSealVoidable = !isVoid && !isVoided && bl.isVoidAllowed(siaeLog) && rights.SuperUser.getBoolean();

String dialogTitle = String.format("Dati della transazione fiscale: %s %s %s", ds.getString(Sel.CodiceCarta), ds.getString(Sel.ProgressivoCarta), ds.getString(Sel.Sigillo));
%>



<v:dialog id="log_dialog" icon="siae.png" title="<%=dialogTitle %>" width="800" height="600" autofocus="false">
<v:widget caption="Dati dell'emissione">
  <v:widget-block>
    <v:form-field caption="Log ID">
      <input class="form-control" type="text" readonly="readonly" value="<%= ds.getString(Sel.LogId) %>" />
    </v:form-field>
    <v:form-field caption="Workstation">
	    <snp:entity-link entityId="<%=ds.getField(Sel.WorkstationId)%>" entityType="<%=LkSNEntityType.Workstation%>">
	      <%=ds.getField(Sel.WorkstationName).getHtmlString()%> 
	      <span class="list-subtitle">(<%=ds.getField(Sel.WorkstationCode).getHtmlString()%>)</span>
	    </snp:entity-link>
    </v:form-field>
    <v:form-field caption="Codice richiedente emissione sigillo">
      <input input class="form-control" type="text" readonly="readonly" value="<%= ds.getString(Sel.CodiceRichiedente) %>" />
    </v:form-field>    
    
    <v:form-field caption="Data ora emissione">
      <input class="form-control" type="text" readonly="readonly" value="<%=pageBase.format(ds.getField(Sel.DataOraEmissione), pageBase.getShortDateTimeFormat(), true)%>" />
    </v:form-field>
    <% if (isVoid) { %>
    <v:form-field caption="Causale">
      <%=JvString.escapeHtml(String.format("[%s] %s", stateCode, stateDesc))%>
    </v:form-field>
    <% } %>
    <v:form-field caption="Tipo titolo">
      <input input class="form-control" type="text" readonly="readonly" value="<%= reductions %>" />
    </v:form-field>    
    <v:form-field caption="Operazione">
      <v:lk-combobox field="<%= ds.getString(Sel.Operazione) %>" lookup="<%=LkSN.SiaeOperationType%>" allowNull="false" enabled="false"/>
    </v:form-field>
    <v:form-field caption="Titolo base">
      <input class="form-control" type="text" readonly="readonly" value="<%=titoloBaseExt%>" />
    </v:form-field>
  </v:widget-block>
</v:widget>
<v:widget caption="Dati Biglietto">
  <v:widget-block>
  <% if (isVoid)  { %>
    <v:form-field caption="Carta Attivazione">
      <input input class="form-control" type="text" readonly="readonly" value="<%= ds.getString(Sel.OriginaleCodiceCarta)%>"/>
    </v:form-field>
    <v:form-field caption="Numero Progressivo">
      <input input class="form-control" type="text" readonly="readonly" value="<%= ds.getString(Sel.OriginaleProgressivo) %>"/>  
    </v:form-field>
    <v:form-field caption="Sigillo Fiscale">
      <input input class="form-control" type="text" readonly="readonly" value="<%= ds.getString(Sel.OriginaleSigillo) %>"/>
    </v:form-field>
    <v:form-field caption="Data ora Sigillo">
      <input class="form-control" type="text" readonly="readonly" value="<%=pageBase.format(ds.getField(Sel.OriginaleDataEmissione), pageBase.getShortDateTimeFormat(), true)%>" />
    </v:form-field>
  <% } else { %>
    <v:form-field caption="Carta Attivazione">
      <input input class="form-control" type="text" readonly="readonly" value="<%= ds.getString(Sel.CodiceCarta) %>"/>
    </v:form-field>
    <v:form-field caption="Numero Progressivo">
      <input input class="form-control" type="text" readonly="readonly" value="<%= ds.getString(Sel.ProgressivoCarta) %>"/>
    </v:form-field>
    <v:form-field caption="Sigilllo Fiscale">
      <input input class="form-control" type="text" readonly="readonly" value="<%= ds.getString(Sel.Sigillo) %>"/>
    </v:form-field>
    <v:form-field caption="Data ora Sigillo">
      <input class="form-control" type="text" readonly="readonly" value="<%=pageBase.format(ds.getField(Sel.DataOraEmissione), pageBase.getShortDateTimeFormat(), true)%>" />
    </v:form-field>
  <% } %>
  </v:widget-block>
  <v:widget-block>
  <% if (!ds.getField(Sel.TicketId).isNull()) { %>
    <% if (!"F".equals(titoloBase)) { %>
      <v:form-field caption="Data ora di STAMPA">
        <input class="form-control" type="text" readonly="readonly" value="<%=pageBase.format(ds.getField(Sel.MediaPrintDate), pageBase.getShortDateTimeFormat(), true)%>" />
      </v:form-field>  
    <% } %>
    <v:form-field caption="Tipo di supporto">
      <input class="form-control" type="text" readonly="readonly" value="<%=mediaType%>" />
    </v:form-field>
    <v:form-field caption="BarCode">
      <snp:entity-link entityId="<%=ds.getField(Sel.MediaId).getHtmlString()%>" entityType="<%=LkSNEntityType.Media%>">
          <%=ds.getField(Sel.MediaCode).getHtmlString() %>
        </snp:entity-link>
    </v:form-field>
  
    <v:form-field caption="Biglietto">
      <snp:entity-link entityId="<%=ds.getString(Sel.TicketId)%>" entityType="<%=LkSNEntityType.Ticket%>">
          <%=ds.getField(Sel.TicketCode).getHtmlString() %>
      </snp:entity-link>
    </v:form-field>
    <v:form-field caption="Stato titolo iniziale">
      <input input class="form-control" type="text" readonly="readonly" value="<%= ds.getString(Sel.Stato) %>"/>
    </v:form-field>
        <v:form-field caption="Stato titolo corrente">
      <input input class="form-control" type="text" readonly="readonly" value="<%= ds.getString(Sel.StatoCorrente) %>"/>
    </v:form-field>
    <% if (("ZT".equals(stateCode)) || ("ZD".equals(stateCode))) {%>
      <v:form-field caption="Data ora di utilizzo">
        <input class="form-control" type="text" readonly="readonly" value="<%=pageBase.format(bl.getFirstUsageDateTime(ds.getString(Sel.TicketId)), pageBase.getShortDateTimeFormat(), true)%>" />
      </v:form-field>  
    <% } %>  
    
  <% } %>
    <v:form-field caption="Smaterializzato">
      <input class="form-control" type="checkbox" readonly disabled <% if (ds.getField(Sel.Smaterializzato).getBoolean()) { %> checked<% } %> />
    </v:form-field>
  </v:widget-block>
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
  <v:widget-block>
  <% if (isAbbonamento) { %>
    <v:form-field caption="Turno">
      <input class="form-control" type="text" value="<%=LkSN.SiaeTipoTurno.findItemByCode(ds.getInt(Sel.TipoTurno)) %>" readonly="readonly" />
    </v:form-field>
    <v:form-field caption="Codice abbonamento">
    <% if (isVoid || isIngress) { %>
      <input class="form-control" type="text" disabled value="<%=ds.getField(Sel.CodiceAbbonamento).getHtmlString()%>"/>
    <% } else { %>
      <input class="form-control" type="text" disabled value="<%=ds.getField(Sel.CodiceAbbonamento).getHtmlString()%>"/>
    <% } %>
    </v:form-field>
    <v:form-field caption="Seriale abbonamento">
    <% if (isVoid || isIngress) { %>
      <% String serialeAbbOrig = JvString.htmlEncode(JvString.leadZero(ds.getString(Sel.SerialeAbbonamentoOriginal), 8)); %>
      <input class="form-control" type="text" disabled value="<%=serialeAbbOrig%>"/>
    <% } else { %>
      <% String serialeAbb = JvString.htmlEncode(JvString.leadZero(ds.getString(Sel.SerialeAbbonamento), 8)); %>
      <input class="form-control" type="text" disabled value="<%=serialeAbb%>"/>
    <% } %>
    </v:form-field>
    <v:form-field caption="Validita">
      <input class="form-control" type="text" disabled value="<%=ds.getField(Sel.ValiditaAbbonamento).getHtmlString()%>" />
    </v:form-field>
    <v:form-field caption="Eventi abilitati">
      <input class="form-control" type="text" disabled value="<%=ds.getField(Sel.EventiAbilitati).getHtmlString()%>" />
    </v:form-field>
    <% } %>
    <% if (hasPerformance) { %>
      <v:form-field caption="Titolo evento">
        <% if (ds.getField(Sel.PerformanceId).isNull()) {%>
          <input class="form-control" type="text" readonly="readonly" value="" />
        <% } else { %>
          <snp:entity-link entityId="<%=ds.getString(Sel.PerformanceId)%>" entityType="<%=LkSNEntityType.Performance%>">
            <%=ds.getField(Sel.EventTitle).getHtmlString() + " — " + pageBase.format(ds.getField(Sel.PerformanceFrom), 
                pageBase.getShortDateTimeFormat(), true) %>
          </snp:entity-link>
        <% }%>
      </v:form-field>
      <v:form-field caption="Data evento">
        <input class="form-control" type="text" readonly="readonly" value="<%=pageBase.format(ds.getField(Sel.DataOraEvento), pageBase.getShortDateTimeFormat(), true)%>" />
      </v:form-field>
      <v:form-field caption="Locale">
        <%if (!ds.getField(Sel.LocationId).isNull()) {%>
        <snp:entity-link entityId="<%=ds.getString(Sel.LocationId)%>" entityType="<%=LkSNEntityType.SiaeLocation%>">
            <%=ds.getField(Sel.LocationName).getHtmlString() %> 
            <span class="list-subtitle">(<%=ds.getField(Sel.LocationCode).getHtmlString() %>)</span>
        </snp:entity-link>
        <% } %>
      </v:form-field>
  <% } %>
  <v:form-field caption="Organizzatore">
    <snp:entity-link entityId="<%=ds.getString(Sel.OrganizerId)%>" entityType="<%=LkSNEntityType.SiaeOrganizer%>">
        <%=ds.getField(Sel.OrganizerName).getHtmlString()%>
    </snp:entity-link>
    <span class="list-subtitle"> C.F.: <%=ds.getField(Sel.OrganizerCodiceFiscale).getHtmlString()%></span>
  </v:form-field>
  <v:form-field caption="Prodotto">
    <input class="form-control" type="text" readonly="readonly" value="<%=ds.getField(Sel.ProductName).getHtmlString()%>" />
  </v:form-field>
  <v:form-field caption="Importo Titolo">
    <input class="form-control" type="text" readonly="readonly" value="<%=ds.getField(Sel.PrezzoTitolo) %> (IVA: <%=ds.getField(Sel.IvaTitolo) %>) <%=reductionDesc%>" />
  </v:form-field>
  <v:form-field caption="Importo Prevendita">
    <input class="form-control" type="text" readonly="readonly" value="<%=ds.getField(Sel.PrezzoPrevendita) %> (IVA: <%=ds.getField(Sel.IvaPrevendita) %>)" />
  </v:form-field>
  <v:form-field caption="Importo Totale">
  <% FtCurrency importoTotale = new FtCurrency(); 
    importoTotale.setMoney(ds.getField(Sel.PrezzoTitolo).getMoney() + ds.getField(Sel.PrezzoPrevendita).getMoney());  
  %>
    <input class="form-control" type="text" readonly="readonly" value="<%=importoTotale%> (Prezzo+Prevendita+Commissioni))" />
  </v:form-field>
  <v:form-field caption="IVA preassolta">
    <input class="form-control" type="text" readonly="readonly" value="<%=ivaTitolo %>" />
  </v:form-field>
  <v:form-field caption="Importi figurativo">
    <% if ("F".indexOf(titoloBase) != -1) { %>
      <input class="form-control" type="text" readonly="readonly" value="<%=ds.getField(Sel.Rateo) %> (IVA: <%=ds.getField(Sel.IvaRateo) %>)" />
    <% } else { %>
      <input class="form-control" type="text" readonly="readonly" value="0 (IVA: 0)" />
    <% } %>
  </v:form-field>
  <v:form-field caption="Ordine di posto (settore)">
    <input input class="form-control" type="text" readonly="readonly" value="<%= sectors %>"/>
  </v:form-field>
  <v:form-field caption="Posto / Fila">
    <input input class="form-control" type="text" readonly="readonly" value="<%= JvString.getEmpty(ds.getString(Sel.Posto)) %>"/>
  </v:form-field>
  </v:widget-block>
</v:widget>


<% if (isVoided) {%>
<v:widget caption="Dati Titolo di accesso ANNULLATO">
  <v:widget-block>
  <% if (isVoid) { %>
    <v:form-field caption="Data ora di annullamento">
      <input class="form-control" type="text" disabled value="<%=pageBase.format(ds.getField(Sel.DataOraEmissione), pageBase.getShortDateTimeFormat(), true)%>" />
    </v:form-field>
    <v:form-field caption="Codice carta">
      <input input class="form-control" type="text" readonly="readonly" value="<%= ds.getString(Sel.CodiceCarta) %>"/>
    </v:form-field>
    <v:form-field caption="Sigillo annullo">
      <input input class="form-control" type="text" readonly="readonly" value="<%= ds.getString(Sel.Sigillo) %>"/>
    </v:form-field>
    <v:form-field caption="Progressivo">
      <input input class="form-control" type="text" readonly="readonly" value="<%= ds.getString(Sel.ProgressivoCarta) %>"/>
    </v:form-field>
    <v:form-field caption="Causale">
      <input class="form-control" type="text" disabled value="<%=voidReason %>" />
    </v:form-field>
  <% } else { %>
    <v:form-field caption="Data ora di annullamento">
      <input class="form-control" type="text" disabled value="<%=pageBase.format(ds.getField(Sel.VoidDataEmissione), pageBase.getShortDateTimeFormat(), true)%>" />
    </v:form-field>
    <v:form-field caption="Codice carta">
      <input class="form-control" type="text" disabled value="<%=ds.getString(Sel.VoidCarta) %>" />
    </v:form-field>
    <v:form-field caption="Sigillo annullo">
      <input class="form-control" type="text" disabled value="<%=ds.getString(Sel.VoidSigillo) %>" />
    </v:form-field>
    <v:form-field caption="Progressivo">
      <input class="form-control" type="text" disabled value="<%=ds.getString(Sel.VoidProgressivo) %>" />
    </v:form-field>
    <v:form-field caption="Causale">
      <input class="form-control" type="text" disabled value="<%=voidReason %>" />
    </v:form-field>
  <% } %>
  </v:widget-block>
</v:widget>
<% } %>

<%if (isSealVoidable) {%>
<v:widget caption="Annullo sigillo">
  <v:widget-block>
    <v:form-field caption="Causale annullamento">
      <v:combobox field="voidreason-id" idFieldName="LookupItemCode" captionFieldName="LookupItemName" lookupDataSet="<%=dsVoidReasons%>" allowNull="false" enabled="true" />
    </v:form-field>
  </v:widget-block>
</v:widget>
<%}%>



<script>

$(document).ready(function() {
  var dlg = $("#log_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
        <%if (isSealVoidable) {%> <v:itl key="Annulla sigillo" encode="JS"/>: doVoidSeal, <%}%>
        <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
      };
  });

  function doVoidSeal() {
    
    confirmDialog(null, function() {
      var reqDO = {
          Command: "VoidSeal",
          VoidSeal: { 
            Seal  :  <%= ds.getField(Sel.Sigillo).getJsString() %>,
            Reason: $("#voidreason-id").val() 
          }
      };
      
      showWaitGlass();
      vgsService("Siae", reqDO, false, function(ansDO){
        hideWaitGlass();
        if (ansDO.Answer.VoidSeal.SealVoided) {
          dlg.dialog("close");
          showMessage(<v:itl key="@Common.SaveSuccessMsg" encode="JS"/>);
        } else {
          showMessage(<v:itl key="Sigillo non annullabile" encode="JS"/>)
        }  
      });
    });  
  }
});


</script>
</v:dialog>