<%@page import="com.vgs.snapp.query.QryBO_SiaeTax"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeOrganizer"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeLookup"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeEvent"%>
<%@page import="com.vgs.snapp.dataobject.DOEvent"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeLookup.*"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeOrganizer"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
BLBO_Siae bl = pageBase.getBL(BLBO_Siae.class);
BLBO_Event eventBl = pageBase.getBL(BLBO_Event.class);
boolean isNewEvent = bl.isNewEvent(pageBase.getId());
DOSiaeEvent siaeEvent = isNewEvent ? bl.prepareNewEvent() : bl.loadEvent(pageBase.getId());
DOEvent snappEvent = eventBl.loadEvent(pageBase.getId());
request.setAttribute("siaeEvent", siaeEvent);
request.setAttribute("snappEvent", snappEvent);

QueryDef qdef = new QueryDef(QryBO_SiaeOrganizer.class);
//Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(QryBO_SiaeOrganizer.Sel.OrganizerId);
qdef.addSelect(QryBO_SiaeOrganizer.Sel.Denominazione);
//Sort
qdef.addSort(QryBO_SiaeOrganizer.Sel.Denominazione);
//Exec
JvDataSet organizersDs = pageBase.execQuery(qdef);

qdef = new QueryDef(QryBO_SiaeLookup.class);
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.LookupItemCode);
qdef.addSelect(Sel.CodeAndName);
qdef.addFilter(Fil.LookupTableId, 1);
qdef.addSort(Sel.LookupItemCode);
JvDataSet eventTypeDs = pageBase.execQuery(qdef);

qdef = new QueryDef(QryBO_SiaeLookup.class);
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.LookupItemCode);
qdef.addSelect(Sel.CodeAndName);
qdef.addFilter(Fil.LookupTableId, 7);
qdef.addSort(Sel.LookupItemCode);
JvDataSet showTypeDs = pageBase.execQuery(qdef);

qdef = new QueryDef(QryBO_SiaeTax.class);
qdef.addSelect(QryBO_SiaeTax.Sel.IconName);
qdef.addSelect(QryBO_SiaeTax.Sel.SiaeTaxId);
qdef.addSelect(QryBO_SiaeTax.Sel.TaxName);
qdef.addSelect(QryBO_SiaeTax.Sel.CurrentTaxValue);
qdef.addSort(QryBO_SiaeTax.Sel.TaxName);
JvDataSet taxDs = pageBase.execQuery(qdef);

JvDataSet siaeEvents = pageBase.getBL(BLBO_Siae.class).getMajorEvents(pageBase.getId());

boolean isEnabled = bl.isSiaeEnabled();
boolean isUsed = bl.isEventUsed(pageBase.getId());
boolean isMainEvent = !siaeEvent.MainEventId.isNull();
%>

<v:dialog id="event_dialog" icon="siae.png" title="Evento SIAE" width="800" height="780" autofocus="false">
<jsp:include page="/resources/admin/siae/siae_alert.jsp" />
<% if (isEnabled && isUsed) { %><div id="main-system-error" class="successbox">La modifica è limitata perché sono già stati venduti biglietti per questo evento.</div><% } %>
<div class="profile-pic-div">
  <snp:profile-pic entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.Event%>" field="snappEvent.ProfilePictureId" enabled="false"/>
</div>

<div class="profile-cont-div">
<v:widget caption="@Common.General">
  <v:widget-block>
    <v:form-field caption="Sotto evento">
      <input type="checkbox" value="true" id="sotto-evento" <% if (!isEnabled || isUsed) {%>disabled="disabled"<% } %>>
    </v:form-field>
    <v:form-field caption="Evento maggiore">
      <v:combobox enabled="<%=isEnabled && !isUsed%>" field="siaeEvent.MainEventId" lookupDataSet="<%=siaeEvents%>" captionFieldName="TitoloEvento" idFieldName="EventId" allowNull="false"/>
    </v:form-field>
    <v:form-field caption="@Common.Code" mandatory="true">
      <v:input-text field="account.AccountCode" placeholder="<%=snappEvent.EventCode.getHtmlString()%>" enabled="false" />
    </v:form-field>
    <v:form-field caption="@Common.Name" mandatory="true">
      <snp:entity-link entityId="<%=snappEvent.EventId.getString()%>" entityType="<%=LkSNEntityType.Event%>">
        <%=snappEvent.EventName%>
      </snp:entity-link>
    </v:form-field>
    <v:form-field caption="Organizzatore" mandatory="true">
      <v:combobox enabled="<%=isEnabled && !isUsed%>" field="siaeEvent.OrganizerId" lookupDataSet="<%=organizersDs%>" captionFieldName="Denominazione" idFieldName="OrganizerId" allowNull="false"/>
    </v:form-field>
    <v:form-field caption="Tipo genere" mandatory="true">
      <v:combobox enabled="<%=isEnabled && !isUsed%>" field="siaeEvent.TipoGenere" lookupDataSet="<%=eventTypeDs%>" captionFieldName="CodeAndName" idFieldName="LookupItemCode" allowNull="false"/>
    </v:form-field>
    <v:form-field caption="Tipo evento" mandatory="true">
      <v:combobox enabled="<%=isEnabled && !isUsed%>" field="siaeEvent.EventType" lookupDataSet="<%=showTypeDs%>" captionFieldName="CodeAndName" idFieldName="LookupItemCode" allowNull="false"/>
    </v:form-field>
    <v:form-field caption="Titolo" mandatory="true">
      <v:input-text enabled="<%=isEnabled && !isUsed%>" field="siaeEvent.TitoloEvento" required="" clazz="default-focus" />
    </v:form-field>
    <v:form-field caption="Tipo IVA" mandatory="true">
      <v:combobox enabled="<%=isEnabled && !isUsed%>" field="siaeEvent.SiaeTaxId" lookupDataSet="<%=taxDs%>" captionFieldName="TaxName" idFieldName="SiaeTaxId" allowNull="false"/>
    </v:form-field>
    <%-- <v:form-field caption="Tipo IVA prevendita">
      <v:combobox enabled="<%=isEnabled && !isUsed%>" field="siaeEvent.SiaePrevenditaTaxId" lookupDataSet="<%=taxDs%>" captionFieldName="TaxName" idFieldName="SiaeTaxId" allowNull="true"/>
    </v:form-field> --%>
    <v:form-field caption="Incidenza (%)">
      <v:input-text enabled="false" type="number" field="siaeEvent.Incidenza" placeholder="0" defaultValue="0" required="" min="0" step="1" max="100" />
    </v:form-field>
    <v:form-field caption="Data inizio">
      <v:input-text enabled="<%=isEnabled && !isUsed%>" type="datetimepicker" field="siaeEvent.DataInizio" placeholder="@Common.Unlimited" />
    </v:form-field>
    <v:form-field caption="Data fine">
      <v:input-text enabled="<%=isEnabled && !isUsed%>" type="datetimepicker" field="siaeEvent.DataFine" placeholder="@Common.Unlimited" />
    </v:form-field>

    <v:form-field caption="Autore">
      <v:input-text enabled="<%=isEnabled && !isUsed%>" field="siaeEvent.Autore"/>
    </v:form-field>
    <v:form-field caption="Esecutore">
      <v:input-text enabled="<%=isEnabled && !isUsed%>" field="siaeEvent.Esecutore"/>
    </v:form-field>
    <v:form-field caption="Numero opere">
      <v:input-text type="number" field="siaeEvent.NumeroOpere" placeholder="0" defaultValue="0" required="" min="0" max="2147483647" />
    </v:form-field>
    <v:form-field caption="Evento a inviti">
      <v:db-checkbox enabled="<%=isEnabled && !isUsed%>" caption="" value="true" field="siaeEvent.EventoInviti"/>
    </v:form-field>
    <%-- 
    <v:form-field caption="Capienza">
      <v:input-text enabled="<%=isEnabled%>" type="number" field="siaeEvent.Capienza" placeholder="0" defaultValue="0" required="" min="0" max="2147483647" />
    </v:form-field>
    <v:form-field caption="IVA omaggio titolo">
      <v:input-text enabled="<%=isEnabled%>" type="number" field="siaeEvent.IvaOmaggioTitolo" placeholder="0" defaultValue="0" required="" min="0" step="0.01" max="900000000000000" pattern="[0-9]*\.?[0-9]*" />
    </v:form-field>
    <v:form-field caption="IVA omaggio abbonamento fisso">
      <v:input-text enabled="<%=isEnabled%>" type="number" field="siaeEvent.IvaOmaggioAbbFisso" placeholder="0" defaultValue="0" required="" min="0" step="0.01" max="900000000000000" pattern="[0-9]*\.?[0-9]*" />
    </v:form-field>
        <v:form-field caption="IVA omaggio abbonamento libero">
      <v:input-text enabled="<%=isEnabled%>" type="number" field="siaeEvent.IvaOmaggioAbbLibero" placeholder="0" defaultValue="0" required="" min="0" step="0.01" max="900000000000000" pattern="[0-9]*\.?[0-9]*" />
    </v:form-field>--%>
  </v:widget-block>
</v:widget>

<v:widget caption="Produttore cinema">
  <v:widget-block>
    <v:form-field caption="Distributore">
      <v:input-text enabled="<%=isEnabled && !isUsed%>" field="siaeEvent.Distributore" />
    </v:form-field>
    <v:form-field caption="NazionalitaFilm">
      <v:input-text enabled="<%=isEnabled && !isUsed%>" field="siaeEvent.NazionalitaFilm"/>
    </v:form-field>
  </v:widget-block>
</v:widget>
</div>
<script src="<v:config key="resources_url"/>/admin/script/siae.js"></script>
<script>

$(document).ready(function() {
  var dlg = $("#event_dialog");  

  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        text: "Ordini di posto",
        click: function() {
          asyncDialogEasy('siae/siae_sector_dialog', 'id=<%=pageBase.getId() %>')
        },
        disabled: <%=!isEnabled || isNewEvent %>
      },
      {
        text: <v:itl key="@Common.Save" encode="JS"/>,
        click: doSaveDialog,
        disabled: <%=!isEnabled %>
      }, 
      {
        text: <v:itl key="@Common.Cancel" encode="JS"/>,
        click: doCloseDialog
      }
    ];
    setTimeout(function() {
      $(".default-focus").focus();
    }, 1);
  });

  
  var formElements = dlg.find(':input');
  monitorFormChange(formElements);
  var $mainEventSelect = $('#siaeEvent\\.MainEventId').closest('.form-field').hide();
  $('#sotto-evento').click(function() {
    var active = $(this).is(':checked');
    if (active) {
      $('.postbox', '#event_dialog').hide();
      $('.form-field', '#event_dialog').hide();
      $(this).closest('.form-field').show();
      $(this).closest('.postbox').show();
      $mainEventSelect.show();
    } else {
      $('.postbox', '#event_dialog').show();
      $('.form-field', '#event_dialog').show();
      $mainEventSelect.hide();
    }
  });
  <% if (!siaeEvent.MainEventId.isNull()) { %>
  $('#sotto-evento').click();
  <% } %>
  
  function getDateTime(field) {
    var date = $(field).val();
    if (!date)
      return null;
    var hh = $(field + '-HH').val();
    if (hh == 'HH')
      hh = '00';
    var mm = $(field + '-MM').val();
    if (mm == 'MM')
      mm = '00';
    return '{0}T{1}:{2}'.format(date, hh, mm);
  };

  function doSaveDialog() {
    var formElements = dlg.find(':input');
    var isSubEvent = $('#sotto-evento').is(':checked');
    var isDirty = formIsDirty(formElements);
    if (isDirty) {
      if (!isSubEvent && !formValidate(formElements)) {
        return;
      }
      if (isSubEvent && !$('#siaeEvent\\.Incidenza').val()) {
        $('#siaeEvent\\.Incidenza').val(0);
        $('#siaeEvent\\.NumeroOpere').val(0);
        <%-- 
        $('#siaeEvent\\.Capienza').val(0);
        $('#siaeEvent\\.IvaOmaggioTitolo').val(0);
        $('#siaeEvent\\.IvaOmaggioAbbFisso').val(0);
        $('#siaeEvent\\.IvaOmaggioAbbLibero').val(0);
       --%>
      }
      var taxId = $('#siaeEvent\\.SiaeTaxId').val();
      // var prevenditaTaxId = $('#siaeEvent\\.SiaePrevenditaTaxId').val() || taxId;

      var reqDO = {
        Command: "SaveEvent",
        SaveEvent: {
          Event: {
            EventId: <%=JvString.jsString(pageBase.getId())%>,
            OrganizerId: $('#siaeEvent\\.OrganizerId').val(),
            TipoGenere: $('#siaeEvent\\.TipoGenere').val(),
            EventType: $('#siaeEvent\\.EventType').val(),
            TitoloEvento: $('#siaeEvent\\.TitoloEvento').val(),
            /*Incidenza: $('#siaeEvent\\.Incidenza').val(),*/
            Autore: $('#siaeEvent\\.Autore').val(),
            Esecutore: $('#siaeEvent\\.Esecutore').val(),
            NazionalitaFilm: $('#siaeEvent\\.NazionalitaFilm').val(),
            NumeroOpere: $('#siaeEvent\\.NumeroOpere').val(),
            DataInizio: getDateTime('#siaeEvent\\.DataInizio'),
            DataFine: getDateTime('#siaeEvent\\.DataFine'),
            /*
            Capienza: 0,
            IvaOmaggioTitolo: "0.0",
            IvaOmaggioAbbFisso: "0.0",
            IvaOmaggioAbbLibero: "0.0",
            */
            Distributore: $('#siaeEvent\\.Distributore').val(),
            MainEventId: $('#sotto-evento').is(':checked') ? $('#siaeEvent\\.MainEventId').val() : '',
            SiaeTaxId: taxId,
            SiaePrevenditaTaxId: taxId,
            EventoInviti: $("#siaeEvent\\.EventoInviti").isChecked()
          }
        }
      };
      
      vgsService("siae", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.SiaeEvent.getCode()%>);
        dlg.dialog("close");
      });
    } else {
      dlg.dialog("close");
    }
  };
  
  
});

</script>
</v:dialog>
<%
siaeEvents.dispose();
%>