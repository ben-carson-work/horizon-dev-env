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
BLBO_Siae bl = pageBase.getBL(BLBO_Siae.class);
DOSiaeCard card = bl.loadCard(pageBase.getEmptyParameter("id"));
request.setAttribute("card", card);
boolean existsMainSystem = bl.existsMainSystem();
boolean isMainSystem = false;
DOSiaeSystem main;
if (existsMainSystem) {
  main = bl.loadMainSystem();
  isMainSystem = main.CodiceSistema.equals(card.CodiceSistema);
}
%>

<v:dialog id="card_dialog" icon="siae.png" title="Carta SIAE" width="800" height="600" autofocus="false">
<% if (existsMainSystem && !isMainSystem) {%>
  <div class="errorbox">Codice sistema SIAE differente.</div>
<% } else { %>
  <jsp:include page="/resources/admin/siae/siae_alert.jsp" />
  <%
    if (card.DataScadenza.getDateTime().isBefore(new JvDateTime())) {
  %>
    <div class="errorbox">Carta scaduta.</div>
  <% } %>
<% } %>
<v:widget caption="@Common.General" icon="profile.png">
  <v:widget-block>
      <v:form-field caption="Codice carta" mandatory="true">
      <v:input-text field="card.CodiceCarta" placeholder="<%=card.CodiceCarta.getHtmlString()%>" enabled="false" />
    </v:form-field>
    <v:form-field caption="Stato della carta SIAE" mandatory="true">
      <%=card.CardStatus.getLookupDesc() %>
    </v:form-field>
    <v:form-field caption="Login date">
      <v:input-text field="card.LoginDateTime" enabled="false"/>
    </v:form-field>
    <v:form-field caption="Contatore" mandatory="true">
      <v:input-text field="card.Contatore" enabled="false"/>
    </v:form-field>
    <v:form-field caption="Balance" mandatory="true">
      <input class="form-control" type="text" readonly="readonly" value="<%=pageBase.formatCurr(card.Balance.getFloat())%>"/>
    </v:form-field>
    <v:form-field caption="Titolare">
      <v:input-text field="card.Titolare" enabled="false"/>
    </v:form-field>
    <v:form-field caption="Firmatario">
      <v:input-text field="card.Firmatario" enabled="false" />
    </v:form-field>
    <v:form-field caption="Contact type">
      <v:input-text field="card.ContactType" enabled="false" />
    </v:form-field>
    <v:form-field caption="Data scadenza">
      <v:input-text field="card.DataScadenza" enabled="false" />
    </v:form-field>
  </v:widget-block>
</v:widget>
<v:widget caption="Sistema" icon="account_tree.png">
  <v:widget-block>
      <v:form-field caption="Codice sistema" mandatory="true">
      <% if (isMainSystem) { %>
        <snp:entity-link entityId="<%=card.CodiceSistema.getString()%>" entityType="<%=LkSNEntityType.SiaeSystem%>">
          <%=card.CodiceSistema.getHtmlString()%>
        </snp:entity-link>
      <% } else { %>
        <v:input-text field="card.CodiceSistema" enabled="false" />
      <% } %>
    </v:form-field>
    <v:form-field caption="Denominazione" mandatory="true">
      <v:input-text field="card.Titolare" enabled="false" />
    </v:form-field>
    <v:form-field caption="CodiceFiscale" mandatory="true">
      <v:input-text field="card.CodiceFiscaleSistema" enabled="false"/>
    </v:form-field>
    <v:form-field caption="Ubicazione">
      <v:input-text field="card.Indirizzo" enabled="false"/>
    </v:form-field>
    <v:form-field caption="Email mittente">
      <v:input-text field="card.EmailMittente" enabled="false"/>
    </v:form-field>
    <v:form-field caption="Email destinazione">
      <v:input-text field="card.EmailDestinazione" enabled="false"/>
    </v:form-field>
    <v:form-field caption="REA">
      <v:input-text field="card.REA" enabled="false" />
    </v:form-field>
    <v:form-field caption="Nazione">
      <v:input-text field="card.Nazione" enabled="false" />
    </v:form-field>
    <v:form-field caption="Codice provvedimento">
      <v:input-text field="card.NumeroDelibera" enabled="false" />
    </v:form-field>
    <v:form-field caption="Data provvedimento">
      <v:input-text field="card.DataDelibera" enabled="false" />
    </v:form-field>
  </v:widget-block>
</v:widget>
<script>

var dlg = $("#card_dialog");
dlg.on("snapp-dialog", function(event, params) {
  params.buttons = [
    <% if (!existsMainSystem && card.CardStatus.getInt() == CardIn.getCode()) { %>
    {
      text: "Inizializzazione sistema SIAE",
      click: doSetSystem
    },
    <% } %>
    <% if (card.CardStatus.getInt() != NoCard.getCode()) {%>
      <% if (card.CardStatus.getInt() != Disabled.getCode()) {%>
        {
          text: "Disabilita",
          click: doDisable
        },
      <% } else {%>
        {
          text: "Abilita",
          click: doEnable
        },
      <% } %>
    <% } %>
    <% if (!bl.isBadCardInserted()) { %>
      <% if (card.CardStatus.getInt() == CardIn.getCode() || 
          card.CardStatus.getInt() == PINVerified.getCode()) { %>
          {
            text: "Modifica PIN",
            click: doChangePIN
          },
      <% } else if (card.CardStatus.getInt() == isBlocked.getCode()) { %>
          {
            text: "Sblocca PIN",
            click: doUnblockPIN
          },
      <% } %>
    <% } %>
    {
      text: "<v:itl key="@Common.Close" encode="UTF-8"/>",
      click: doCloseDialog
    }
  ];
  $(".default-focus").focus();
});

function doSetSystem() {
  confirmDialog('Vuoi iniziallizare il sistema SIAE con questa smart card?', function() {
    var reqDO = {
        Command: "SetMainSystem",
        SetMainSystem: {
          CodiceSistema: <%=JvString.jsString(card.CodiceSistema.getString()) %>
        }
      };
    vgsService("siae", reqDO, false, function(ansDO) {
      $('#main-system-error').hide();
      triggerEntityChange(<%=LkSNEntityType.SiaeCard.getCode()%>);
      $("#card_dialog").dialog("close");
    });
  });
};

function doChangePIN() {
  var cardCode = <%=JvString.jsString(card.CodiceCarta.getString())%>;
  asyncDialogEasy('siae/pin_dialog', 'cardCode={0}&view=change_pin'.format(cardCode));
};

function doUnblockPIN() {
  var cardCode = <%=JvString.jsString(card.CodiceCarta.getString())%>;
  asyncDialogEasy('siae/pin_dialog', 'cardCode={0}&view=unblock_pin'.format(cardCode));
};

function doDisable() {
  var cardCode = <%=JvString.jsString(card.CodiceCarta.getString())%>;
  var reqDO = {
      Command: "DisableCard",
      DisableCard: {
        CodiceCarta: <%=JvString.jsString(card.CodiceCarta.getString())%>
      }
  };
  vgsService('siae', reqDO, false, function() {
    $("#card_dialog").dialog("close");
    setTimeout(function() {
      triggerEntityChange(<%=LkSNEntityType.SiaeCard.getCode()%>);
    }, 1000);
  });
};

function doEnable() {
  var cardCode = <%=JvString.jsString(card.CodiceCarta.getString())%>;
  var reqDO = {
      Command: "EnableCard",
      EnableCard: {
        CodiceCarta: <%=JvString.jsString(card.CodiceCarta.getString()) %>
      }
  };
  vgsService('siae', reqDO, false, function() {
    $("#card_dialog").dialog("close");
    setTimeout(function() {
      triggerEntityChange(<%=LkSNEntityType.SiaeCard.getCode()%>);
    }, 1000);
    setTimeout(function() {
      triggerEntityChange(<%=LkSNEntityType.SiaeCard.getCode()%>);
    }, 15000);
  });
};
</script>

</v:dialog>