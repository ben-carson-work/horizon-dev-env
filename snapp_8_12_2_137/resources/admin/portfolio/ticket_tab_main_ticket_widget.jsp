<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.web.servlet.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTicket" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="ticket" class="com.vgs.snapp.dataobject.DOTicket" scope="request"/>

<v:widget caption="@Ticket.Ticket">
  <v:widget-block>
    <v:recap-item caption="@Common.Code"><%=ticket.TicketCode.getHtmlString()%></v:recap-item>
    <v:recap-item caption="@Common.Barcode" include="<%=rights.ShowAllMediaCodes.getBoolean() && !ticket.Barcode.isNull()%>"><%=ticket.Barcode.getHtmlString()%></v:recap-item>
    <v:recap-item caption="@Common.DateTime"><snp:datetime timestamp="<%=ticket.EncodeDateTime%>" format="shortdatetime" timezone="local"/></v:recap-item>

    <v:recap-item caption="@Sale.Transaction">
      <a href="javascript:asyncDialogEasy('portfolio/ticket_transaction_history_dialog', 'id=<%=ticket.TicketId.getHtmlString()%>')"><v:itl key="@Common.History"/></a>
      &mdash;
      <snp:entity-link entityId="<%=ticket.TransactionId%>" entityType="<%=LkSNEntityType.Transaction%>"><%=ticket.TransactionCode.getHtmlString()%></snp:entity-link>
    </v:recap-item>
    
    <v:recap-item valueColor="orange" include="<%=ticket.SaleTaxExempt.getBoolean()%>"><v:itl key="@Sale.TaxExempt"/></v:recap-item>
  </v:widget-block>

  <v:widget-block>
    <% String sStatusColor = ticket.TicketStatus.isLookup(LkSNTicketStatus.Active) ? null : (ticket.TicketStatus.getInt() > LkSNTicketStatus.GoodTicketLimit) ? "red" : "orange"; %>
    <v:recap-item caption="@Common.Status" valueColor="<%=sStatusColor%>"><v:label field="<%=ticket.TicketStatus%>"/></v:recap-item>
    <v:recap-item valueColor="<%=sStatusColor%>" include="<%=!ticket.PurgeLevel.isNull()%>"><%=ticket.PurgeLevel.getHtmlLookupDesc(pageBase.getLang())%></v:recap-item>
     
    <v:recap-item caption="@Common.ArchivedOn" valueColor="blue" include="<%=!ticket.ArchivedOnDateTime.isNull()%>"><snp:datetime timestamp="<%=ticket.ArchivedOnDateTime%>" format="shortdatetime" timezone="local"/></v:recap-item>
    <v:recap-item caption="@Common.Archivable" valueColor="orange" include="<%=!ticket.ArchivableOnDateTime.isNull()%>"><snp:datetime timestamp="<%=ticket.ArchivableOnDateTime%>" format="shortdatetime" timezone="local"/></v:recap-item>
    
    <v:recap-item caption="@Product.SuspendedTill" valueColor="<%=sStatusColor%>" include="<%=ticket.TicketStatus.isLookup(LkSNTicketStatus.Suspended)%>">
      <% if (ticket.SuspensionEndDate.isNull()) { %>
        <v:itl key="@Common.Unlimited"/>
      <% } else { %>
        <%=pageBase.format(ticket.SuspensionEndDate, pageBase.getShortDateFormat())%>
      <% } %>
    </v:recap-item>

    <v:recap-item caption="@Ticket.HostTicket" include="<%=!ticket.HostTicket.isEmpty()%>">
      <snp:entity-link entityId="<%=ticket.HostTicket.TicketId%>" entityType="<%=LkSNEntityType.Ticket%>"><%=ticket.HostTicket.TicketCode.getHtmlString()%></snp:entity-link>
    </v:recap-item>
    
    <v:recap-item caption="@Package.Package" include="<%=!ticket.PackageTicket.TicketId.isNull()%>">
      <snp:entity-link entityId="<%=ticket.PackageTicket.TicketId%>" entityType="<%=LkSNEntityType.Ticket%>"><%=ticket.PackageTicket.TicketCode.getHtmlString()%></snp:entity-link>
    </v:recap-item>

    <v:recap-item caption="@Ticket.RenewedTo" include="<%=!ticket.RenewDstTicket.TicketId.isNull()%>">
      <snp:entity-link entityId="<%=ticket.RenewDstTicket.TicketId%>" entityType="<%=LkSNEntityType.Ticket%>"><%=ticket.RenewDstTicket.TicketCode.getHtmlString()%></snp:entity-link>
    </v:recap-item>

    <v:recap-item caption="@Ticket.RenewedFrom" include="<%=!ticket.RenewSrcTicket.TicketId.isNull()%>">
      <snp:entity-link entityId="<%=ticket.RenewSrcTicket.TicketId%>" entityType="<%=LkSNEntityType.Ticket%>"><%=ticket.RenewSrcTicket.TicketCode.getHtmlString()%></snp:entity-link>
    </v:recap-item>
    
    <v:recap-item caption="@Ticket.OverriddenBy" include="<%=!ticket.OverrideSrcTicket.TicketId.isNull()%>">
      <snp:entity-link entityId="<%=ticket.OverrideSrcTicket.TicketId%>" entityType="<%=LkSNEntityType.Ticket%>"><%=ticket.OverrideSrcTicket.TicketCode.getHtmlString()%></snp:entity-link>
    </v:recap-item>
    
    <v:recap-item caption="@Ticket.Overrides" include="<%=!ticket.OverrideDstTicket.TicketId.isNull()%>">
      <snp:entity-link entityId="<%=ticket.OverrideDstTicket.TicketId%>" entityType="<%=LkSNEntityType.Ticket%>"><%=ticket.OverrideDstTicket.TicketCode.getHtmlString()%></snp:entity-link>
    </v:recap-item>

    <% String sSettled = ticket.Settled.getBoolean() ? "@Common.Settled" : "@Common.Unsettled"; %>
    <v:recap-item caption="@Common.Settlement"><v:itl key="<%=sSettled%>"/></v:recap-item>
  </v:widget-block>

  <v:widget-block>
    <v:recap-item caption="@Common.ValidFrom">
      <% 
      String spanFromAttr = "";

      String validityFromColor = SnappUtils.findTicketValidityColor(pageBase.getFiscalDate(), ticket.ValidDateFrom.getDateTime(), null);
      if (validityFromColor != null)
        spanFromAttr += " style=\"color:" + validityFromColor + "\"";
      
      if (ticket.ManualStartValidity.getBoolean())
        spanFromAttr += " title=\"" + JvString.escapeHtml(pageBase.getLang().Ticket.StartValidityManuallyChanged.getText()) + "\"";
    
      %>
      <span class="recap-value hint-tooltip v-tooltip" <%=spanFromAttr%> title="@Ticket.ValidDateFromHint">
        <% if (ticket.ManualStartValidity.getBoolean()) { %>
          <i class="fa fa-hand-paper"></i>
        <% } %>
        <% if (ticket.ValidDateFrom.isNull()) { %>
          &mdash;
        <% } else { %>
          <%=pageBase.format(ticket.ValidDateFrom, pageBase.getShortDateFormat())%>
        <% } %>
      </span>
    </v:recap-item>

    <v:recap-item caption="@Common.ValidTo">
      <% 
      String spanToAttr = "";

      String validityToColor = SnappUtils.findTicketValidityColor(pageBase.getFiscalDate(), null, ticket.ValidDateTo.getDateTime());
      if (validityToColor != null)
        spanToAttr += " style=\"color:" + validityToColor + "\"";

      if (ticket.ManualExpiration.getBoolean())
        spanToAttr += " title=\"" + JvString.escapeHtml(pageBase.getLang().Ticket.ExpDateManuallyChanged.getText()) + "\"";
      %>
      <span class="recap-value hint-tooltip v-tooltip" <%=spanToAttr%> title="@Ticket.ValidDateToHint">
        <% if (ticket.ManualExpiration.getBoolean()) { %>
          <i class="fa fa-hand-paper"></i>
        <% } %>
        <% if (ticket.ValidDateTo.isNull()) { %>
          &mdash;
        <% } else { %>
          <%=pageBase.format(ticket.ValidDateTo, pageBase.getShortDateFormat())%>
        <% } %>
      </span>
    </v:recap-item>

    <v:recap-item caption="@Ticket.Breakage"><%if (ticket.BreakageDate.isNull()) {%>&mdash;<%} else {%><%=JvString.escapeHtml(pageBase.format(ticket.BreakageDate, pageBase.getShortDateFormat()))%><%}%></v:recap-item>
    
    <v:recap-item include="<%=!ticket.BreakageDate.isNull()%>">
      <% if (ticket.BreakageOnDateTime.isNull()) { %>
        <v:itl key="@Ticket.NotTriggered"/>
      <% } else { %>
        <snp:datetime timestamp="<%=ticket.BreakageOnDateTime%>" format="shortdatetime" timezone="local"/>
      <% } %>
    </v:recap-item>

    <v:recap-item caption="@Ticket.ExpiredOn">
      <% if (ticket.ExpiredOnDateTime.isNull()) { %>
        <v:itl key="@Ticket.NotTriggered"/>
      <% } else { %>
        <span style="color:var(--base-red-color)"><snp:datetime timestamp="<%=ticket.ExpiredOnDateTime%>" format="shortdatetime" timezone="local"/></span>
      <% } %>
    </v:recap-item>

    <v:recap-item caption="@Ticket.ClearedOn">
      <% if (ticket.ClearedOnDateTime.isNull()) { %>
        <v:itl key="@Ticket.NotTriggered"/>
      <% } else { %>
        <span style="color:var(--base-red-color)"><snp:datetime timestamp="<%=ticket.ClearedOnDateTime%>" format="shortdatetime" timezone="local"/></span>
      <% } %>
    </v:recap-item>
  </v:widget-block>

  <v:widget-block>
    <v:recap-item caption="@Ticket.ValidateDateTime">
      <% if (ticket.ValidateDateTime.isNull()) { %>
        <v:itl key="@Ticket.NotValidated"/>
      <% } else { %>
        <snp:datetime timestamp="<%=ticket.ValidateDateTime%>" format="shortdatetime" timezone="local"/>
      <% } %>
    </v:recap-item>

    <v:recap-item caption="@Ticket.FirstUsageDateTime">
      <% if (ticket.FirstUsageDateTime.isNull()) { %>
        <v:itl key="@Ticket.NotUsed"/>
      <% } else { %>
        <snp:datetime timestamp="<%=ticket.FirstUsageDateTime%>" format="shortdatetime" timezone="local"/>
      <% } %>
    </v:recap-item>
    
    <v:recap-item caption="@Ticket.EntryCount"><%=ticket.Entitlement.EntryCount.getInt()%></v:recap-item>
    
    <% if (!ticket.IgnoreCrossoverTimeUntilDate.isNull() && ticket.IgnoreCrossoverTimeUntilDate.getDateTime().isAfterOrEquals(pageBase.getFiscalDate())) { %>
      <v:recap-item caption="@Ticket.IgnoreCrossoverTimeUntilDate" valueColor="orange"><%=pageBase.format(ticket.IgnoreCrossoverTimeUntilDate, pageBase.getShortDateFormat())%></v:recap-item>
    <% } %>
  </v:widget-block>
</v:widget>
