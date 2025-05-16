<%@page import="static com.vgs.snapp.lookup.LkSNSiaeCardStatus.*"%>
<%@page import="com.vgs.cl.document.JvDBFieldNode"%>
<%@page import="com.vgs.vcl.NvSubIcon"%>
<%@page import="com.vgs.web.library.BLBO_Siae"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeCard.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<%
BLBO_Siae bl = pageBase.getBL(BLBO_Siae.class);
boolean existsMainSystem = bl.existsMainSystem();
QueryDef qdef = new QueryDef(QryBO_SiaeCard.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.CodiceCarta);
qdef.addSelect(Sel.CardStatus);
qdef.addSelect(Sel.Contatore);
qdef.addSelect(Sel.Balance);
qdef.addSelect(Sel.Titolare);
qdef.addSelect(Sel.Firmatario);
qdef.addSelect(Sel.CodiceFiscale);
qdef.addSelect(Sel.MainSystem);
qdef.addSelect(Sel.DataScadenza);

if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getNullParameter("FullText"));

if ((pageBase.getNullParameter("CardStatus") != null))
  qdef.addFilter(Fil.CardStatus, JvArray.stringToArray(pageBase.getNullParameter("CardStatus"), ","));


// Sort
qdef.addSort(Sel.DataScadenza, false);
qdef.addSort(Sel.CodiceCarta);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>
<style>
.fit-width {
  width: 1%;
  white-space: nowrap;
}
.vimg {
  margin: 0 4px -3px 0;
}
</style>
<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.SiaeCard%>">
  <tr class="header">
    <td width="1%"><v:grid-checkbox header="true"/></td>
    <td width="1%">&nbsp;</td>
    <td width="1%">Codice<br />Status</td>
    <td width="1%"> </td>
    <td>Codice fiscale</td>
    <td>Scadenza</td>
    <td>Titolare</td>
    <td>Firmatario</td>
    <td width="6%" align="right">Balance<br />Contatore</td>
  </tr>
  <v:grid-row dataset="ds">
    <td><v:grid-checkbox dataset="ds" name="CardCode" fieldname="CodiceCarta" /></td>
    <%
      String cardCode = ds.getField(Sel.CodiceCarta).getHtmlString();
        boolean isMainSystem = ds.getField(Sel.MainSystem).getBoolean();
        String icon = ds.getField(Sel.IconName).getString() + "|";
        LookupTable statusLookup = LookupManager.getTable(LkSNSiaeCardStatus.class);
        int statusCode = ds.getField(Sel.CardStatus).getInt();
        String status = statusLookup.getItemDescription(statusCode);
        if (isMainSystem) {
      if (statusCode == NoCard.getCode()) {
        icon += NvSubIcon.BlueExclamation;
      } else if (statusCode == Error.getCode() || statusCode == isBlocked.getCode()
          || statusCode == Disabled.getCode()) {
        icon += NvSubIcon.Cancel;
      } else if (ds.getField(Sel.DataScadenza).getDateTime().isBefore(new JvDateTime())) {
        icon += NvSubIcon.Warning;
      } else if (statusCode == CardIn.getCode()) {
        icon += NvSubIcon.Wait;
      } else if (statusCode == PINVerified.getCode()) {
        icon += NvSubIcon.Ok;
      } else {
        icon += NvSubIcon.None;
      }
        } else {
      icon += NvSubIcon.Cancel;
        }
    %>
    <td>
      <v:grid-icon name="<%=icon%>"/>
    </td>
    <td class="fit-width">
      <snp:entity-link entityId="<%=cardCode%>" entityType="<%=LkSNEntityType.SiaeCard%>" clazz="list-title">
        <%=cardCode%>
      </snp:entity-link><br />
     <span class="list-subtitle"><%=status%></span>
    </td>
    <td class="fit-width"><% if (isMainSystem && statusCode == LkSNSiaeCardStatus.CardIn.getCode()) { %>
      <button <% if (!bl.isSiaeEnabled()) { %>disabled="disabled" <% } %> onclick="return showDialog('<%=cardCode%>', event);">
        Log in smart card
      </button>
    <% } else if (!existsMainSystem) { %>
      <span class="list-subtitle">sistema SIAE non inizializzato</span>
    <% } else if (!isMainSystem) { %>
      <span class="list-subtitle">smart card appartemente ad altro sistema </span>
    <% } %></td>
    <td>
      <%=ds.getField(Sel.CodiceFiscale).getHtmlString() %>
    </td>
    <td>
      <%=ds.getDateTime(Sel.DataScadenza).format(pageBase.getShortDateFormat())%>
    </td>
    <td>
      <%=ds.getField(Sel.Titolare).getHtmlString() %>
    </td>
    <td>
       <%=ds.getField(Sel.Firmatario).getHtmlString() %>
    </td>
    <td align="right">
      <%=pageBase.formatCurrHtml(ds.getField(Sel.Balance)) %><br />
      <span class="list-subtitle"><%=ds.getField(Sel.Contatore).getHtmlString() %></span>
    </td>
  </v:grid-row>
</v:grid>
<script>
function showDialog(cardCode, e) {
  e = e || window.event;
  asyncDialogEasy('siae/pin_dialog', 'cardCode={0}&view=verify_pin'.format(cardCode));
  e.stopPropagation();
  return false;
};
</script>