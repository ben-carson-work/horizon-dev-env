<%@page import="com.vgs.snapp.web.search.*"%>
<%@page import="com.vgs.snapp.web.query.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.web.servlet.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMedia" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="media" class="com.vgs.snapp.dataobject.media.DOMedia" scope="request"/>
<jsp:useBean id="rightCRUD" class="com.vgs.snapp.library.FtCRUD" scope="request"/>
<% boolean canEdit = rightCRUD.canUpdate(); %>

<style>

.pane-icon {
  float: left;
  width: 32px;
  height: 32px;
  background-size: 100%;
}

.pane-detail {
  margin-left: 42px;
}

.widget-block.group  {
  padding: 4px 10px 4px 10px;
  font-weight: bold;
  background-color: #F2F2F2;
}

.mediacode-icon {
  width: 18px;
  text-align: center;
}

</style>

<% 
  DOMediaCode firstMediaCode = media.MediaCodeList.findFirst();
  boolean manualRedemption = (rights.ManualRedemption.getBoolean() && (firstMediaCode != null) && canEdit); 
  String manualRedemptionOnClick = "asyncDialogEasy('portfolio/manual_redemption_dialog', 'mediacode=" + ((firstMediaCode != null) ? firstMediaCode.MediaCode.getString() : "") + "')";
  DOPortfolioRef portfolioRef = media.MainPortfolio.isEmpty() ? media.Portfolio : media.MainPortfolio;
  request.setAttribute("portfolio", portfolioRef);
  pageBase.setDefaultParameter("MediaPortfolioId", media.Portfolio.PortfolioId.getString());
%>

  <div class="tab-toolbar">
    <v:button caption="@Lookup.TransactionType.ManualRedemption" fa="scanner" onclick="<%=manualRedemptionOnClick%>" enabled="<%=manualRedemption%>"/>
    <% if (media.NoteCount.getInt() > 0) { %>
      <snp:notes-btn entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.Media%>"/>
    <% } %>
  </div>

<div class="tab-content">
  <v:last-error/>

  <table class="recap-table" style="width:100%">
    <tr>
      <% // Encoding %>
      <td width="33%">
        <v:widget caption="@Common.Encoding">
          <v:widget-block>
            <v:recap-item caption="@Common.Code"><%=media.MediaCalcCode.getHtmlString()%></v:recap-item>
            <v:recap-item caption="@Common.Status"><%=media.MediaStatusDesc.getHtmlString()%></v:recap-item>
            <v:recap-item caption="@Common.Type"><%=media.MediaTypeDesc.getHtmlString()%></v:recap-item>
            <v:recap-item caption="@DocTemplate.DocTemplate"><snp:entity-link entityId="<%=media.DocTemplateId%>" entityType="<%=LkSNEntityType.DocTemplate%>"><%=media.DocTemplateName.getHtmlString()%></snp:entity-link></v:recap-item>
            <v:recap-item caption="@Sale.Transaction">
              <snp:entity-link entityId="<%=media.Transaction.TransactionId%>" entityType="<%=LkSNEntityType.Transaction%>"><%=media.Transaction.TransactionCode.getHtmlString()%></snp:entity-link>
            </v:recap-item>
            <v:recap-item caption="@Common.Workstation">
              <% if (media.Transaction.WorkstationId.isNull()) { %>
                <%=media.LicenseId.getHtmlString()%>/<%=media.StationSerial.getHtmlString()%>
              <% } else { %>
                <snp:entity-link entityId="<%=media.Transaction.LocationId%>" entityType="<%=LkSNEntityType.Location%>">
                  <%=media.Transaction.LocationName.getHtmlString()%>
                </snp:entity-link>
                &raquo;
                <snp:entity-link entityId="<%=media.Transaction.OpAreaId%>" entityType="<%=LkSNEntityType.OperatingArea%>">
                  <%=media.Transaction.OpAreaName.getHtmlString()%>
                </snp:entity-link>
                &raquo;
                <snp:entity-link entityId="<%=media.Transaction.WorkstationId%>" entityType="<%=LkSNEntityType.Workstation%>">
                  <%=media.Transaction.WorkstationName.getHtmlString()%>
                </snp:entity-link>
              <% } %>
            </v:recap-item>

            <v:recap-item caption="@Common.ExtSystem" include="<%=!media.ExtSystemType.isNull()%>"><%=media.ExtSystemType.getHtmlLookupDesc(pageBase.getLang())%></v:recap-item>
          </v:widget-block>

          <v:widget-block include="<%=!media.OfflineDummyMediaId.isNull()%>">
            <v:recap-item caption="@Media.OfflineDummyMedia">
              <snp:entity-link entityId="<%=media.OfflineDummyMediaId%>" entityType="<%=LkSNEntityType.Media%>">
                <%=media.OfflineDummyMediaTDSSN.getHtmlString()%>
              </snp:entity-link>
            </v:recap-item>
          </v:widget-block>

          <v:widget-block include="<%=!media.OfflineRealMediaId.isNull()%>">
            <v:recap-item caption="@Media.OfflineRealMedia">
              <snp:entity-link entityId="<%=media.OfflineRealMediaId%>" entityType="<%=LkSNEntityType.Media%>">
                <%=media.OfflineRealMediaTDSSN.getHtmlString()%>
              </snp:entity-link>
            </v:recap-item>
          </v:widget-block>

          <v:widget-block>
            <v:recap-item caption="@Reservation.Flag_Printed">
              <% if (media.PrintDateTime.isNull()) { %>
                <v:itl key="@Common.No"/>
              <% } else { %>
                <snp:datetime timestamp="<%=media.PrintDateTime%>" format="shortdatetime" timezone="local"/>
              <% } %>
            </v:recap-item>

            <v:recap-item caption="@Common.ExclusiveUse">
              <% if (media.ExclusiveUse.getBoolean()) { %> <v:itl key="@Common.Yes"/> <% } else { %> <v:itl key="@Common.No"/> <% } %>
            </v:recap-item>

            <v:recap-item caption="@Common.PrintAtHome">
              <% if (media.PrintAtHome.getBoolean()) { %> <v:itl key="@Common.Yes"/> <% } else { %> <v:itl key="@Common.No"/> <% } %>
            </v:recap-item>
          </v:widget-block>
        </v:widget>
      </td>

      <td width="34%">
        <v:widget caption="@Common.MediaCodes">
          <v:widget-block>
            <% for (DOMediaCode mcDO : media.MediaCodeList) { %>
              <div>
                <span><i class="mediacode-icon fa fa-<%=mcDO.IconAlias.getEmptyString()%>"></i></span>
                <% if (mcDO.TestMode.getBoolean()) { %>
                  <i class="fa fa-bug" title="<%=JvString.escapeHtml(SnappUtils.TEST_MODE_LABEL_DEFAULT)%>"></i>
                <% } %>
                <% if (mcDO.OfflineMode.getBoolean()) { %>
                  <i class="fa fa-wifi-slash" title="<%="OFFLINE"%>"></i>
                <% } %>
                <span><%=mcDO.MediaCode.getHtmlString()%></span>
              </div>
            <% } %>
          </v:widget-block>
        </v:widget>
      </td>
      
      <td width="33%">
        <%-- PORTFOLIO --%>
        <v:widget caption="@Common.Portfolio">
          <jsp:include page="portfolio_accountwallet_widget.jsp"/>
          <% if (!media.MainTicket.TicketId.isNull()) { %>
          <v:widget-block clazz="group"><v:itl key="@Ticket.Tickets"/></v:widget-block>
            <v:widget-block>
              <span class="pane-icon" style="background-image:url('<v:image-link name="<%=media.MainTicket.IconName.getString()%>" size="32"/>')"></span>
              <div class="pane-detail">
                <% if (media.MainTicket.TicketId.isSameString(pageBase.getParameter("TicketId"))) { %>
                  <strong><%=media.MainTicket.TicketCode.getHtmlString()%></strong>
                <% } else { %>
                  <snp:entity-link entityId="<%=media.MainTicket.TicketId%>" entityType="<%=LkSNEntityType.Ticket%>" clazz="list-title">
                    <%=media.MainTicket.TicketCode.getHtmlString()%>
                  </snp:entity-link>
                <% } %>
                <span class="recap-value">
                  <% if (media.MainTicket.BindWalletRewardToProduct.getBoolean()) { %>
				          <%   String params = "PortfolioId=" + media.MainTicket.MainPortfolioId.getHtmlString() + "&TicketId=" + media.MainTicket.TicketId.getHtmlString(); %>
				               <a href="javascript:asyncDialogEasy('portfolio/portfolio_binded_product_wallet_reward_dialog', '<%=params%>')">(<i class="fa-solid fa-wallet"></i>&nbsp;<%=pageBase.formatCurr(media.MainTicket.PortfolioBindedBalance.getMoney())%>)</a>&nbsp;<%=pageBase.formatCurr(media.MainTicket.UnitAmount.getMoney() * media.MainTicket.GroupQuantity.getInt())%>
				          <% } else { %>
				            <%=pageBase.formatCurr(media.MainTicket.UnitAmount.getMoney())%>
				          <% } %>
                </span><br/>
                
                <% if (!media.MainTicket.ProductId.isNull()) { %>
                  <snp:entity-link entityId="<%=media.MainTicket.ProductId%>" entityType="<%=LkSNEntityType.ProductType%>">
                    <%=media.MainTicket.ProductName.getHtmlString()%>
                  </snp:entity-link>
                  <br/>  
                  <% if (media.MainTicket.PerformanceList.getSize() > 1) { %>
                    <v:itl key="@Performance.MultiplePerformance"/>
                  <% } else if (!media.MainTicket.PerformanceList.isEmpty()) { %>
                    <% DOPerformanceRef performance = media.MainTicket.PerformanceList.findFirst().Performance; %>
                    <snp:entity-link entityId="<%=performance.EventId%>" entityType="<%=LkSNEntityType.Event%>">
                      <%=performance.EventName.getHtmlString()%>
                    </snp:entity-link>
                    &raquo;
                    <snp:entity-link entityId="<%=performance.PerformanceId%>" entityType="<%=LkSNEntityType.Performance%>">
                      <snp:datetime timestamp="<%=performance.DateTimeFrom%>" format="shortdatetime" timezone="location" convert="false"/>
                    </snp:entity-link>
                  <% } %>
                <% } %>
              </div>
            </v:widget-block>  

            <%String href=ConfigTag.getValue("site_url") + "/admin?page=media&id=" + pageBase.getId() + "&tab=pfticket&portfolioid=" + media.Portfolio.PortfolioId.getHtmlString();%>
            <v:widget-block include="<%=media.Portfolio.TicketCount.getInt() > 1%>">
              <div style=text-align:center><a href="<%=href%>"><v:itl key="@Common.FullList" param1="<%=media.Portfolio.TicketCount.getString()%>"/></a></div>
            </v:widget-block>
          <% } %>
        </v:widget>

        <%-- LOCK --%>
        <v:widget caption="@Common.LockInfo" icon="lock.png" include="<%=media.Portfolio.LockCount.getInt() > 0%>">
          <div id="lock-widget2"></div>
          <script>asyncLoad("#lock-widget2", "<%=pageBase.getContextURL()%>?page=lock_widget&id=<%=media.Portfolio.PortfolioId.getString()%>&EntityType=<%=LkSNEntityType.Portfolio.getCode()%>");</script>
        </v:widget>
      </td>     
    </tr>
  </table>

  <% if (rights.RedemptionLog.getBoolean()) { %>
    <div>
      <v:widget caption="@Ticket.Usages">
        <v:widget-block> 
          <v:button id="btn-direct-only" caption="@Media.ShowDirectScanOnly" title="@Media.ShowDirectScanOnlyHint"/>
          <v:button id="btn-voidable-only" caption="@Media.ShowVoidableScanOnly" title="@Media.ShowVoidableScanOnlyHint"/>
          <v:pagebox gridId="accesslog-grid"/>
        </v:widget-block>
      </v:widget>
  
      <% String params = "PortfolioMediaId=" + pageBase.getId(); %>
      <v:async-grid id="accesslog-grid" jsp="accesslog_grid.jsp" params="<%=params%>"/>
    </div>
    <% } %>
  
  <% request.setAttribute("listTimedTicketStatement", media.TimedTicketStatementList.getItems()); %>
  <jsp:include page="../product/timedticket/timedticketstatement_widget.jsp"></jsp:include>
</div>

<script>

$(document).ready(function() {
  $("#btn-direct-only").click(function() {
    var $btn = $(this);
    var active = !$btn.is(".active");
    var mediaId = <%=JvString.jsString(pageBase.getId())%>;
    $btn.setClass("active", active);
    setGridUrlParam("#accesslog-grid", "MediaId", active ? mediaId : "");
    setGridUrlParam("#accesslog-grid", "PortfolioMediaId", active ? "" : mediaId, true);
  });
  
  $("#btn-voidable-only").click(function() {
    var $btn = $(this);
    var active = !$btn.is(".active");
    var mediaId = <%=JvString.jsString(pageBase.getId())%>;
    $btn.setClass("active", active);
    setGridUrlParam("#accesslog-grid", "VoidableOnly", active ? true : "");
    setGridUrlParam("#accesslog-grid", "MediaId", mediaId, true);
  });  

});

</script>