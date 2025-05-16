<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.search.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
DOTicketUsageSearchRequest reqDO = new DOTicketUsageSearchRequest();  

// Paging
reqDO.SearchRecapRequest.PagePos.setInt(pageBase.getQP());
reqDO.SearchRecapRequest.RecordPerPage.setInt(QueryDef.recordPerPageDefault);

// Where
reqDO.FromDateTime.setDateTime((pageBase.getNullParameter("FromDateTime") == null) ? null : pageBase.convertFromBrowserToServerTimeZone(pageBase.getNullParameter("FromDateTime")));
reqDO.ToDateTime.setDateTime((pageBase.getNullParameter("ToDateTime") == null) ? null : pageBase.convertFromBrowserToServerTimeZone(pageBase.getNullParameter("ToDateTime")));
reqDO.UsageType.setArray((pageBase.getNullParameter("UsageType") == null) ? null : JvArray.stringToIntArray(pageBase.getParameter("UsageType"), ","));
reqDO.LocationId.setString(pageBase.getNullParameter("LocationId"));
reqDO.AccessAreaId.setString(pageBase.getNullParameter("AccessAreaId"));
reqDO.AccessPointId.setString(pageBase.getNullParameter("AccessPointId"));
reqDO.TransactionId.setString(pageBase.getNullParameter("TransactionId"));
reqDO.GoodTicketOnly.setBoolean(pageBase.findBoolParameter("GoodTicketOnly"));
reqDO.BadTicketOnly.setBoolean(pageBase.findBoolParameter("BadTicketOnly"));
reqDO.Ticket.TicketId.setString(pageBase.getNullParameter("TicketId"));
reqDO.PortfolioMediaId.setString(pageBase.getNullParameter("PortfolioMediaId"));
reqDO.PortfolioId.setString(pageBase.getNullParameter("PortfolioId"));
reqDO.VoidableOnly.setString(pageBase.getNullParameter("VoidableOnly"));
reqDO.Reconciled.setString(pageBase.getNullParameter("Reconciled"));
if (reqDO.PortfolioId.isNull())
  reqDO.MediaId.setString(pageBase.getNullParameter("MediaId"));

// Exec
DOTicketUsageSearchAnswer ansDO = new DOTicketUsageSearchAnswer();  
pageBase.getBL(BLBO_TicketUsage.class).searchTicketUsage(reqDO, ansDO);
%>

<style>
  .strike-out {text-decoration: line-through}
</style>

<v:grid search="<%=ansDO%>" entityType="<%=LkSNEntityType.TicketUsage%>">
<% if (pageBase.isParameter("show-title", "true")) { %>
  <tr>
    <td class="widget-title" colspan="100%">
      <span class="widget-title-caption"><v:itl key="@Ticket.Usages"/></span>
      <v:pagebox gridId="accesslog-grid"/>
    </td>
  </tr>
<% } %>
  <tr class="header">
    <td>&nbsp;</td>
    <td width="125px" nowrap>
      <v:itl key="@Common.DateTime"/><br/>
      <v:itl key="@Ticket.ValidateResult"/>
    </td>
    <td width="160px" nowrap>
      <v:itl key="@Common.Media"/><br/>
      <v:itl key="@Ticket.Ticket"/>
    </td>
    <td width="25%">
      <v:itl key="@Account.Account"/><br/>
      <v:itl key="@Product.ProductType"/>
    </td>
    <td width="35%">
      <v:itl key="@Account.Location"/> &raquo; <v:itl key="@Account.AccessArea"/><br/>
      <v:itl key="@AccessPoint.AccessPoint"/>
    </td>
    <td width="30%">
      <v:itl key="@Event.Event"/> &raquo; <v:itl key="@Performance.Performance"/><br/>
      <v:itl key="@Common.Operator"/>
    </td>
    <td align="right" width="10%">
      <div><v:itl key="@Common.Quantity"/></div>
      <div><v:itl key="@Common.Value"/></div>
    </td>
    <% if (pageBase.getNullParameter("VoidableOnly") != null) {%>            
    <td>
    </td>
    <%}%>
  </tr>
  <v:grid-row search="<%=ansDO%>" dateGroupFieldName="UsageDateTime" idFieldName="ticketUsageId">
    <%
    DOTicketUsageRef tuDO = ansDO.getRecord();
    LookupItem lkTicketStatus = tuDO.TicketStatus.isNull() ? LkSNTicketStatus.Active : tuDO.TicketStatus.getLkValue();
    String ticketStatusDesc = lkTicketStatus.isLookup(LkSNTicketStatus.Active) ? "" : lkTicketStatus.getHtmlDescription(pageBase.getLang());
    String bioTypeDesc = (ticketStatusDesc.isEmpty() && !tuDO.BiometricType.isNull()) ? tuDO.BiometricType.getHtmlLookupDesc(pageBase.getLang()) : "";
    String bioEnrollmentDesc = !tuDO.BioEnrollmentType.isLookup(LkSNBioEnrollmentType.None) ? tuDO.BioEnrollmentType.getHtmlLookupDesc(pageBase.getLang()) : "";
    String bioDetails = null;
    
    boolean hasFlags = tuDO.SimulatedRedemption.getBoolean() || tuDO.Invalidated.getBoolean() || tuDO.Imported.getBoolean();

    boolean isSameTicket = reqDO.Ticket.TicketId.isNull() || tuDO.TicketId.isSameString(reqDO.Ticket.TicketId); 
    boolean isSameMedia = reqDO.PortfolioMediaId.isNull() || tuDO.MediaId.isSameString(reqDO.PortfolioMediaId);
    String sBorderStyle = (isSameTicket && isSameMedia) ? "" : "style=\"border-left: 4px solid var(--base-orange-color)\""; 
    String invalidOfflineValidateResultDesc = "";
//     if (!tuDO.InvalidOfflineValidateResult.isNull() && tuDO.ValidateResult.isLookup(LkSNValidateResult.OK_Offline, LkSNValidateResult.OK_OperOverride))
    if (!tuDO.InvalidOfflineValidateResult.isNull())
      invalidOfflineValidateResultDesc = tuDO.InvalidOfflineValidateResult.getHtmlLookupDesc(pageBase.getLang());
    String sClassInvalidated = tuDO.Invalidated.getBoolean() ? "strike-out" : "";
    %>
    <td <%=sBorderStyle%>><v:grid-icon name="<%=tuDO.IconName.getString()%>" title="<%=tuDO.UsageType.getLookupDesc()%>"/></td>
    <td>
      <% String jspTicketUsageDetails = "accesslog_tooltip&TicketUsageId=" + tuDO.TicketUsageId.getHtmlString(); %>
      <div class="v-tooltip" data-jsp="<%=jspTicketUsageDetails %>"><span class="list-title tz-datetime <%=sClassInvalidated%>" title="<%=JvString.escapeHtml(pageBase.format(tuDO.UsageDateTime, pageBase.getShortDateTimeFormat()+":ss.SSS"))%>"><i class="fa fa-map-marker"></i> <%=JvString.escapeHtml(pageBase.format(tuDO.UsageDateTime, pageBase.getShortDateTimeFormat()))%></span></div>
      <div class="list-subtitle">
        <%=tuDO.ValidateResult.getHtmlLookupDesc(pageBase.getLang())%>
        <% if (tuDO.Invalidated.getBoolean()) { %>
          <br/>
          <span style="color:var(--base-red-color)"><v:itl key="@Ticket.UsageInvalidated"/></span>
        <% } %>
        <% if (ticketStatusDesc.length() > 0) { %>
          <br/><v:itl key="Product status"/>: <%=ticketStatusDesc%>
        <% } %>
      </div>
    </td>
    <td>
      <% if (tuDO.MediaId.isNull() && tuDO.TicketId.isNull() && !tuDO.MissingMediaCode.isNull()) { %>
        <%=tuDO.MissingMediaCode.getHtmlString()%><br/>
        <span class="list-subtitle"><%=tuDO.UnknownMediaCode.getHtmlLookupDesc(pageBase.getLang())%></span>
      <% } else { %>
        <snp:entity-link entityId="<%=tuDO.MediaId.getString()%>" entityType="<%=LkSNEntityType.Media%>">
          <%=tuDO.MediaCalcCode.getHtmlString()%>
        </snp:entity-link>
        <br/>
        <snp:entity-link entityId="<%=tuDO.TicketId.getString()%>" entityType="<%=LkSNEntityType.Ticket%>">
          <%=tuDO.TicketCode.getHtmlString()%>
        </snp:entity-link>
      <% } %>
    </td> 
    <td>
      <% if (tuDO.AccountId.isNull()) { %>
        <span class="list-subtitle"><v:itl key="@Account.AnonymousAccount"/></span>
      <% } else { %>
        <snp:entity-link entityId="<%=tuDO.AccountId%>" entityType="<%=tuDO.AccountEntityType%>">
          <%=tuDO.AccountName.getHtmlString()%>
        </snp:entity-link>
      <% } %>
      <br/>
      <snp:entity-link entityId="<%=tuDO.ProductId%>" entityType="<%=LkSNEntityType.ProductType%>">
        <%=tuDO.ProductName.getHtmlString()%>
      </snp:entity-link>
    </td>
    <td>
      <snp:entity-link entityId="<%=tuDO.AptLocationId%>" entityType="<%=LkSNEntityType.Location%>">
        <%=tuDO.AptLocationName.getHtmlString()%>
      </snp:entity-link>
      <% if (!tuDO.AccessAreaAccountId.isNull()) { %>
        &raquo;
        <snp:entity-link entityId="<%=tuDO.AccessAreaAccountId%>" entityType="<%=LkSNEntityType.AccessArea%>">
          <%=tuDO.AccessAreaName.getHtmlString()%>
        </snp:entity-link>
      <% } %>
      <br/>
      <snp:entity-link entityId="<%=tuDO.AptWorkstationId%>" entityType="<%=LkSNEntityType.Workstation%>">
        <%=tuDO.AptWorkstationName.getHtmlString()%>
      </snp:entity-link>
    </td>
    <td>
      <div>
        <% if (!tuDO.EventId.isNull()) { %>
          <snp:entity-link entityId="<%=tuDO.EventId%>" entityType="<%=LkSNEntityType.Event%>">
            <%=tuDO.EventName.getHtmlString()%>
          </snp:entity-link> 
          &raquo;
          <snp:entity-link entityId="<%=tuDO.PerformanceId%>" entityType="<%=LkSNEntityType.Performance%>">
            <snp:datetime timestamp="<%=tuDO.PerfDateTimeFrom%>" format="shortdatetime" timezone="location" convert="false"/>
          </snp:entity-link>
        <% } else if (!tuDO.IncProductId.isNull()) { %>
          <snp:entity-link entityId="<%=tuDO.IncProductId%>" entityType="<%=LkSNEntityType.ProductType%>">
            [<%=tuDO.IncProductCode.getHtmlString()%>] <%=tuDO.IncProductName.getHtmlString()%>
          </snp:entity-link>
        <% } else { %>
          &nbsp;
        <% } %>
      </div>
      <div>
        <% if (!tuDO.UsageUserAccountId.isNull()) { %>
          <snp:entity-link entityId="<%=tuDO.UsageUserAccountId%>" entityType="<%=tuDO.UsageUserAccountEntityType%>">
            <%=tuDO.UsageUserAccountName.getHtmlString()%>
          </snp:entity-link>        
          <% if (!tuDO.UsageSupAccountId.isNull()) { %>
          <span class="list-subtitle">&nbsp;(<v:itl key="@Common.Supervisor"/>:
            <snp:entity-link entityId="<%=tuDO.UsageSupAccountId%>" entityType="<%=LkSNEntityType.User%>"><%=tuDO.UsageSupAccountName.getHtmlString()%></snp:entity-link>)
          </span>    
          <% } %>
        <% } %>
        
        <% if (!tuDO.UsageUserType.isNull()) { %>
          <span class="list-subtitle">&nbsp;(<%=tuDO.UsageUserType.getHtmlLookupDesc(pageBase.getLang())%>)</span>
        <% } %>
        
        <% if (!tuDO.UsageUserMediaId.isNull()) { %>
          <br/>
          <snp:entity-link entityId="<%=tuDO.UsageUserMediaId.getString()%>" entityType="<%=LkSNEntityType.Media%>">
            <%=tuDO.UsageUserMediaCalcCode.getHtmlString()%>
          </snp:entity-link>
        <% } %>
        
        <% if (!tuDO.Transaction.TransactionId.isNull()) { %>
          <snp:entity-link entityId="<%=tuDO.Transaction.UserAccountId%>" entityType="<%=LkSNEntityType.User%>">
            <%=tuDO.Transaction.UserAccountName.getHtmlString()%>
          </snp:entity-link> 
          <span class="list-subtitle">(        
          <snp:entity-link entityId="<%=tuDO.Transaction.TransactionId%>" entityType="<%=LkSNEntityType.Transaction%>">
            <%=tuDO.Transaction.TransactionCode.getHtmlString()%>
          </snp:entity-link> 
          )</span>
        <% } %>
      </div>
    </td>
    <td align="right">
        <div><%=tuDO.GroupQuantity.getHtmlString()%></div>
      <% if (tuDO.WalletCharge.getMoney() != 0) { %>
        <div><%=pageBase.formatCurrHtml(tuDO.WalletCharge)%></div>
      <% } %>

      <% for (DOTicketUsageRef.DOPayPerUse ppu: tuDO.PPUList) { %>
        <div>
          <snp:entity-link entityId="<%=ppu.MembershipPointId.getString()%>" entityType="<%=LkSNEntityType.RewardPoint%>"><%=ppu.MembershipPointName.getHtmlString()%></snp:entity-link>
          <%=pageBase.getBL(BLBO_RewardPoint.class).formatRewardPointAmount(ppu.MembershipPointId.getString(), ppu.PPUAmount.getMoney())%>
        </div>
      <% } %>
    </td>
    <% if ((pageBase.getNullParameter("VoidableOnly") != null) && tuDO.Voidable.getBoolean()) {%>            
    <%   String onClick="voidRedemption('" + tuDO.TicketUsageId.getEmptyString() + "')";%>
    <td>
      <v:button clazz="btn-voidable-only" caption="@Common.Void" title="@Media.VoidRedemptionHint"/>
    </td>
    <%}%>
  </v:grid-row>
</v:grid>

<script>
$(document).ready(function() {
  $(".btn-voidable-only").click(function() {
    var $btn = $(this);
    var ticketUsageId = $btn.closest("tr").attr("data-recordid");
    asyncDialogEasy("accesslog_voidredemption_dialog", "ticketUsageId=" + ticketUsageId);
  });  
});

</script>