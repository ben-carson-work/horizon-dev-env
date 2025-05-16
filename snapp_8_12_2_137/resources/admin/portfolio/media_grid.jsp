<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
DOMediaSearchRequest reqDO = new DOMediaSearchRequest();

reqDO.MediaCode.setString(pageBase.getNullParameter("MediaCode"));
if (reqDO.MediaCode.isNull()) {
  reqDO.FullText.setString(pageBase.getNullParameter("FullText"));
  reqDO.SaleId.setString(pageBase.getNullParameter("SaleId"));
  reqDO.TransactionIDs.setString(pageBase.getNullParameter("TransactionId"));
  reqDO.TransferTransactionId.setString(pageBase.getNullParameter("TransferTransactionId"));
  reqDO.PortfolioId.setString(pageBase.getNullParameter("PortfolioId"));
  reqDO.AccountId.setString(pageBase.getNullParameter("AccountId"));
  reqDO.StationSerial.setString(pageBase.getNullParameter("StationSerial"));
  reqDO.EncodeFiscalDate.setString(pageBase.getNullParameter("EncodeFiscalDate"));
  reqDO.GoodMediaOnly.setBoolean(pageBase.isParameter("ActiveMedia", "1"));
  reqDO.BadMediaOnly.setBoolean(pageBase.isParameter("ActiveMedia", "2"));
}

reqDO.SearchRecap.PagePos.setInt(pageBase.getQP());
reqDO.SearchRecap.RecordPerPage.setInt(QueryDef.recordPerPageDefault);

reqDO.SearchRecap.addSortField("EncodeFiscalDate", true);
reqDO.SearchRecap.addSortField("EncodeDateTime", true);
reqDO.SearchRecap.addSortField("MediaSerial", true);

DOMediaSearchAnswer ansDO = pageBase.getBL(BLBO_Media.class).searchMedia(reqDO);

boolean multiPage = true;
if (pageBase.getNullParameter("MultiPage") != null)
  multiPage = pageBase.findBoolParameter("MultiPage");
%>

<v:grid id="media-grid-table" search="<%=ansDO%>">
  <tr class="header">
    <td><v:grid-checkbox header="true" multipage="<%=multiPage%>"/></td>
    <td>&nbsp;</td>
    <td width="15%">
      <v:itl key="@Common.Code"/><br/>
      <v:itl key="@Common.Status"/>
    </td>
    <td width="15%">
      <v:itl key="@DocTemplate.DocTemplate"/><br/>
      <v:itl key="@Reservation.Flag_Printed"/>
    </td>
    <td width="20%">
      <v:itl key="@Account.Account"/><br/>
      <v:itl key="@Ticket.Balance"/>
    </td>
    <td width="20%">
      <v:itl key="@Media.LastUsageDateTime"/>
    </td>
    <td width="30%">
      <v:itl key="@Common.MediaCodes"/>
    </td>
  </tr>
  <v:grid-row search="<%=ansDO%>" dateGroupFieldName="EncodeFiscalDate">
    <% DOMediaRef mediaDO = ansDO.getRecord(); %>
    <td style="<v:common-status-style status="<%=mediaDO.CommonStatus%>"/>">
      <v:grid-checkbox name="MediaId" fieldname="MediaId" value="<%=mediaDO.MediaId.getString()%>"/>
      <snp:grid-note entityType="<%=LkSNEntityType.Media%>" entityId="<%=mediaDO.MediaId.getString()%>" noteCountField="<%=mediaDO.NoteCount%>"/>
    </td>
    <td><v:grid-icon name="<%=mediaDO.IconName.getString()%>"/></td>
    <td>
      <snp:entity-link entityId="<%=mediaDO.MediaId%>" entityType="<%=LkSNEntityType.Media%>" clazz="list-title">
        <%=mediaDO.MediaCalcCode.getHtmlString()%>
      </snp:entity-link>
      <br/>
      <span class="list-subtitle"><%=mediaDO.MediaStatusDesc.getHtmlString()%></span>
    </td>
    <td>
      <% if (mediaDO.DocTemplateId.isNull()) { %>
      <span class="list-subtitle">-</span>
      <% } else { %>
        <snp:entity-link entityId="<%=mediaDO.DocTemplateId%>" entityType="<%=LkSNEntityType.DocTemplate%>"><%=mediaDO.DocTemplateName%></snp:entity-link>
      <% } %>
      <br/>
      <span class="list-subtitle">
      <% if (mediaDO.PrintDateTime.isNull()) { %>
        <v:itl key="@Common.NotPrinted"/>
      <% } else { %>
        <snp:datetime timestamp="<%=mediaDO.PrintDateTime%>" format="shortdatetime" timezone="local"/>
      <% } %>
      </span>
    </td>
    <td>
      <% if (mediaDO.AccountId.isNull()) { %>
        <span class="list-subtitle"><v:itl key="@Account.AnonymousAccount"/></span>
      <% } else { %>
        <snp:entity-link entityId="<%=mediaDO.AccountId%>" entityType="<%=mediaDO.AccountEntityType%>">
          <%=mediaDO.AccountName.getHtmlString()%>
        </snp:entity-link>
      <% } %>
      <br/>
      <span class="list-subtitle"><%=pageBase.formatCurrHtml(mediaDO.WalletBalance)%></span>
    </td>
    <td>
      <% if (!mediaDO.LastUsageDateTime.isNull()) { %>
        <snp:datetime timestamp="<%=mediaDO.LastUsageDateTime%>" format="shortdatetime" timezone="local"/>
      <% } else { %>
        &mdash;
      <% } %>
    </td>
    <td>
      <% if (mediaDO.MediaCodeList.isEmpty()) { %>
        <span class="list-subtitle"><v:itl key="@Common.None"/></span>
      <% } else { %>
        <% for (DOMediaCode mcDO : mediaDO.MediaCodeList) { %>
          <div style="display:inline-block; margin-right: 10px; white-space:nowrap;"><i class="fa fa-<%=mcDO.IconAlias.getHtmlString()%>"></i> <%= mcDO.MediaCode.getHtmlString() %></div>
        <% } %>
      <% } %>
    </td>
  </v:grid-row>
</v:grid>

<script>

function UpdateMediaStatus(statusCode) {
  var ids = $("[name='MediaId']").getCheckedValues();
  if (ids == "")
    showMessage(itl("@Common.NoElementWasSelected"));
  else {
    confirmDialog(null, function() {
      snpAPI.cmd("Media", "UpdateMediaStatus"{
        MediaStatus: statusCode,
        MediaIDs: ids
      }).then(() => window.location.reload());
    });
  }
}

</script>
