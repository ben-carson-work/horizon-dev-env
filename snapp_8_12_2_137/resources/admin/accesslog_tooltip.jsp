<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.web.queue.outbound.*"%>
<%@page import="com.vgs.snapp.search.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_TicketUsage.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTooltip" scope="request"/>

<%
String ticketUsageId = pageBase.getNullParameter("TicketUsageId");

QueryDef qdef = new QueryDef(QryBO_TicketUsage.class)
    .addFilter(Fil.TicketUsageId, ticketUsageId)
    .addSelect(
        Sel.UsageType,
        Sel.BiometricType,
        Sel.BioEnrollmentType,
        Sel.BiometricGroup,
        Sel.SimulatedRedemption,
        Sel.Imported,
        Sel.Invalidated,
        Sel.InvalidOfflineValidateResult,
        Sel.AsyncFinalizeStatus,
        Sel.AsyncFinalize_CommonStatus,
        Sel.AsyncFinalize_ProcMS,
        Sel.AsyncFinalize_QueueMS,
        Sel.FlashAtTurnstile,
        Sel.PeopleOfDetermination,
        Sel.RotationsAllowed,
        Sel.ExtraEntry,
        Sel.ExtUsageRef,
        Sel.CrossPlatformId,
        Sel.DynamicEntitlementId);

JvDataSet ds = pageBase.execQuery(qdef);

LookupItem usageType = LkSN.TicketUsageType.findItemByCode(ds.getField(Sel.UsageType));
String bioTypeDesc = !ds.getField(Sel.BiometricType).isNull() ? LkSN.BiometricType.getItemByCode(ds.getField(Sel.BiometricType).getInt()).getHtmlDescription(pageBase.getLang()) : "&mdash;";
String bioEnrollmentDesc = !LkSN.BiometricEnrollmentType.getItemByCode(ds.getField(Sel.BioEnrollmentType).getInt()).isLookup(LkSNBioEnrollmentType.None) ? LkSN.BiometricEnrollmentType.getItemByCode(ds.getField(Sel.BioEnrollmentType).getInt()).getHtmlDescription(pageBase.getLang()) : "&mdash;";

String invalidOfflineValidateResultDesc = !ds.getField(Sel.InvalidOfflineValidateResult).isNull() ? LkSN.ValidateResult.getItemByCode(ds.getField(Sel.InvalidOfflineValidateResult).getInt()).getHtmlDescription(pageBase.getLang()) : "&mdash;";

boolean showOptions = ds.getBoolean(Sel.FlashAtTurnstile) || ds.getBoolean(Sel.PeopleOfDetermination) || (ds.getInt(Sel.RotationsAllowed) > 0) || ds.getBoolean(Sel.ExtraEntry) || ds.getBoolean(Sel.SimulatedRedemption) || ds.getBoolean(Sel.Imported) || ds.getBoolean(Sel.Invalidated);

%>
<style>
.result-flash-icon {
  color: orange;
  font-size:0.9em;
}
.result-wheelchair-icon {
  font-size:0.9em;
  color: black;
 }
.bold {
  font-weight: bold;
}
.result-icon {
  width: 16px;
}

</style>

<div style="min-width:300px; max-height:300px; overflow-y:auto">
  <% if (!ds.getField(Sel.InvalidOfflineValidateResult).isNull()) {%>
    <div class="tooltip-section">
      <div class="tooltip-title"><v:itl key="@Common.Details"/></div>
      <div class="recap-value-item">
        <v:itl key="@Ticket.InvalidOfflineResult"/>
        <span class="recap-value">
          <%=invalidOfflineValidateResultDesc%>
        </span>
      </div>
    </div>
  <%}%>
  
  <% if (!ds.getField(Sel.BiometricType).isNull()) {%>
    <div class="tooltip-section">
      <div class="tooltip-title"><v:itl key="@Biometric.Biometric"/></div>
      <div class="recap-value-item">
        <v:itl key="@Biometric.BiometricType"/>
        <span class="recap-value">
          <%=bioTypeDesc%>
        </span>
      </div>
      <div class="recap-value-item">
        <v:itl key="@Biometric.BiometricEnrollmentType"/>
        <span class="recap-value">
          <%=bioEnrollmentDesc%>
        </span>
      </div>
      <div class="recap-value-item">
        <v:itl key="@Biometric.BiometricGroup"/>
        <span class="recap-value">
          <%=ds.getField(Sel.BiometricGroup).getBoolean()%>
        </span>
      </div>
    </div>
  <%}%>
  
  <% if (showOptions) {%>
    <div class="tooltip-section">
      <div class="tooltip-title"><v:itl key="@Common.Options"/></div>
      
      <% if (ds.getBoolean(Sel.FlashAtTurnstile)) {%>
      <div class="recap-value-item">
        <i class="fa fas fa-lightbulb-on result-flash-icon result-icon"></i>
        <v:itl key="@Entitlement.FlashAtAPT"/>
      </div>
      <%}%>
      
      <% if (ds.getBoolean(Sel.PeopleOfDetermination)) {%>
      <div class="recap-value-item">
        <i class="fa fas fa-wheelchair result-wheelchair-icon result-icon"></i>
        <v:itl key="@Product.PeopleOfDetermination"/>
      </div>
      <%}%>
      
      <% if (ds.getBoolean(Sel.ExtraEntry)) {%>
      <div class="recap-value-item">
        <i class="fa fas fa-minus result-icon"></i>
        <v:itl key="@Entitlement.ExtraEntryAvailable"/>
      </div>
      <%}%>
      
      <% if (ds.getInt(Sel.RotationsAllowed) > 0) {%>
      <div class="recap-value-item">
        <i class="fa fas fa-sync-alt result-icon"></i>
        <v:itl key="@ManualRedemption.RotationsAllowed"/> <%=ds.getInt(QryBO_TicketUsage.Sel.RotationsAllowed)%>
      </div>
      <%}%>
    
      <% if (ds.getBoolean(Sel.SimulatedRedemption)) {%>
      <div class="recap-value-item bold">
        <i class="fa fas fa-minus result-icon"></i>
        <v:itl key="@Ticket.UsageSimulated"/>
      </div>
      <%}%>
      
      <% if (ds.getBoolean(Sel.Imported)) {%>
      <div class="recap-value-item bold">
        <i class="fa fas fa-minus result-icon"></i>
        <v:itl key="@Ticket.UsageImported"/>
      </div>
      <%}%>
      
      <% if (ds.getBoolean(Sel.Invalidated)) {%>
      <div class="recap-value-item bold">
        <i class="fa fas fa-minus result-icon"></i>
        <v:itl key="@Ticket.UsageInvalidated"/>
      </div>
      <%}%>
      
    </div> 
  <%}%>
          
  <div class="tooltip-section">
    <div class="tooltip-title"><v:itl key="@Common.Entitlements"/></div>
      <div class="recap-value-item">
        <% String entIcon = ds.getField(Sel.DynamicEntitlementId).isNull() ? "ticket" : "atom-simple"; %>
        <i class="fa fa-<%=entIcon%> result-icon"></i>
        <a href="javascript:asyncDialogEasy('portfolio/ticketusage_entitlement_dialog', 'id=<%=JvString.htmlEncode(ticketUsageId)%>')"><v:itl key="@Common.Entitlements"/></a>
      </div>
    </div>
  </div>
  
  <% if ((usageType != null) && usageType.isLookup(LkSNTicketUsageType.XPI)) { %>
    <%
    String crossPlatformId = ds.getString(Sel.CrossPlatformId);
    String extUsageRef = ds.getString(Sel.ExtUsageRef);
    %>
    
    <% if ((crossPlatformId != null) && (extUsageRef != null)) { %>
      <div class="tooltip-section">
        <div class="tooltip-title"><v:itl key="@XPI.CrossPlatform"/></div>
        
        <%
        try {
          DOTicketUsageRef tuDO = pageBase.getBL(BLBO_XPI.class).getWS(crossPlatformId).xpi_FindTicketUsage(extUsageRef); 
          %>
          <v:grid-icon name="<%=tuDO.IconName%>"/>
          <%=tuDO.EventName.getHtmlString() %>
          <%
        }
        catch (Throwable t) {
          %><v:alert-box type="danger">Unable to connect to partner system</v:alert-box><%
        }
        %>
      </div>
    <% } %>
  <% } else { %>
    <div class="tooltip-section">
      <div class="tooltip-title"><v:itl key="@Stats.PostProcess"/></div>
      <%
      String asyncFinalizeColor = LkCommonStatus.findColorHex(LkSN.CommonStatus.findItemByCode(ds.getField(Sel.AsyncFinalize_CommonStatus))); 
      LookupItem asyncFinalizeStatus = LkSN.AsyncFinalizeStatus.findItemByCode(ds.getField(Sel.AsyncFinalizeStatus)); 
      long asyncFinalizeQueueMS = ds.getLong(Sel.AsyncFinalize_QueueMS);
      long asyncFinalizeProcMS = ds.getLong(Sel.AsyncFinalize_ProcMS);
      %>
      <i class="fa fa-circle" style="font-size:0.9em;color:<%=asyncFinalizeColor%>"></i>
      <% if (asyncFinalizeStatus == null) { %>
        <v:itl key="@Common.Missing"/>
      <% } else { %>
        <%=asyncFinalizeStatus.getHtmlDescription(pageBase.getLang())%>
        <% if (asyncFinalizeQueueMS != 0) { %>
          &mdash; <v:itl key="@System.AsyncFinalize_QueueTimeShort"/> <%=JvString.htmlEncode(JvDateUtils.getSmoothTime(asyncFinalizeQueueMS))%>
        <% } %>
        <% if (asyncFinalizeProcMS != 0) { %>
          &mdash; <v:itl key="@System.AsyncFinalize_ExecTimeShort"/> <%=JvString.htmlEncode(JvDateUtils.getSmoothTime(asyncFinalizeProcMS))%>
        <% } %>
      <% } %>
    </div>
  <% } %>

  <%
  DOOutboundQueueSearchRequest obqReqDO = new DOOutboundQueueSearchRequest();
  obqReqDO.EntityId.setString(ticketUsageId);
  DOOutboundQueueSearchAnswer obqAnsDO = pageBase.getBL(BLBO_Outbound.class).searchOutboundQueue(obqReqDO);
  
  boolean externalQueue = pageBase.getRights().ExternalQueue.getBoolean();
  String queueContextURL = pageBase.getBL(BLBO_Outbound.class).calcExternalContextURL();
  %>
  <% if (!obqAnsDO.OutboundQueueList.isEmpty()) { %>
    <div class="tooltip-section">
      <div class="tooltip-title"><v:itl key="@Outbound.OutboundQueue"/></div>
      <% for (DOOutboundQueueRef obq : obqAnsDO.OutboundQueueList) { %>
        <% String color = LkCommonStatus.findColorHex(LkSN.CommonStatus.findItemByCode(obq.CommonStatus)); %>
        <div>
          <i class="fa fa-circle" style="font-size:0.9em;color:<%=color%>"></i>
          <snp:entity-link entityId="<%=obq.OutboundQueueId%>" entityType="<%=LkSNEntityType.OutboundQueue%>" contextURL="<%=queueContextURL%>" openOnNewTab="<%=externalQueue%>">
            <%=obq.OutboundMessageName.getHtmlString()%>
          </snp:entity-link>
        </div> 
      <% } %>
    </div>
  <% } %>

</div>