<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMedia" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="media" class="com.vgs.snapp.dataobject.media.DOMedia" scope="request"/>
<jsp:useBean id="rightCRUD" class="com.vgs.snapp.library.FtCRUD" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<div id="main-container">
  <v:tab-group name="tab" main="true">
    <v:tab-item tab="main" caption="@Common.Recap" icon="profile.png" jsp="media_tab_main.jsp" default="true"/>
    <v:tab-item tab="transaction" caption="@Common.Transactions" icon="transaction.png" jsp="media_tab_transaction.jsp" include="<%=(media.TransactionCount.getInt() > 0)%>"/>

    <% String paramsTicket = "PortfolioId=" + media.Portfolio.PortfolioId.getString(); %>
    <v:tab-item tab="pfticket" caption="@Common.PortfolioTickets" icon="ticket-new.png" jsp="tab_portfolioticket.jsp" params="<%=paramsTicket%>" include="<%=(media.Portfolio.TicketCount.getInt() > 1)%>"/>
    
    <%-- PORTFOLIO MEDIA --%>
    <% String paramsMedia = "PortfolioId=" + media.Portfolio.PortfolioId.getString(); %>
    <v:tab-item tab="pfmedia" caption="@Common.PortfolioMedias" icon="media.png" jsp="tab_portfoliomedia.jsp" params="<%=paramsMedia%>" include="<%=(media.Portfolio.MediaCount.getInt() > 1)%>"/>
        
    <%-- METADATA --%>
    <%
    boolean masks = !media.MaskList.isEmpty();
    String paramMD = masks ? "" : "FlatMetaData=true"; 
    %>
    <v:tab-item tab="metadata" caption="@Common.Forms" icon="mask.png" jsp="media_tab_metadata.jsp" params="<%=paramMD%>" include="<%=masks || !media.MetaDataList.isEmpty()%>"/>  
    
    <%-- LOGS --%>
    <% if (pageBase.isTab("tab", "logs") || pageBase.getBLDef().hasLogs(pageBase.getId())) { %>
      <v:tab-item caption="@Common.Logs" icon="<%=LkSNEntityType.Log.getIconName()%>" tab="logs" jsp="../log/log_tab_widget.jsp" />
    <% } %>
  
    <%-- ADD --%>
    <% if (!pageBase.isNewItem()) { %>
      <v:tab-plus>
			  <% 
			  LookupItem mediaStatus = media.MediaStatus.getLkValue();
			  boolean canBlock = pageBase.getRights().MediaBlock.getBoolean() && (LkSNTicketStatus.isGood(mediaStatus) || LkSNTicketStatus.isMediaBlocked(mediaStatus));
			  if (canBlock) {
			    String onclick = "asyncDialogEasy('portfolio/media_change_status_dialog', 'mediaIDs=" + pageBase.getId() + "')";
			    %><v:popup-item caption="@Common.ChangeStatus" fa="lock" onclick="<%=onclick%>"/><%
			  }
			  if (pageBase.isVgsContext("BKO") && pageBase.getRights().TicketCancellation.getBoolean() && rightCRUD.canDelete()) { 
			    %><v:popup-item caption="@Lookup.TransactionType.TicketCancellation" fa="times" onclick="showTicketCancellationDialog()"/><%
			  }
			  %>
        <%-- CODE ALIASES--%>  
        <% if (pageBase.isVgsContext("BKO") ) { %>
          <% String onclick = "asyncDialogEasy('code_alias_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Media.getCode() + "')"; %>
          <v:popup-item caption="@Common.CodeAliases" fa="barcode" onclick="<%=onclick%>"/>
        <% } %>
        
			  <v:popup-divider/>
			  
			  <%-- NOTES --%>
			  <% String onclickNotes = "asyncDialogEasy('common/notes_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Media.getCode() + "');"; %>
			  <v:popup-item caption="@Common.Notes" fa="comments" onclick="<%=onclickNotes%>"/>
      
        <%-- HISTORY --%>
        <% if (rights.History.getBoolean()) {%>
          <% String onclickHistory = "asyncDialogEasy('common/history_detail_dialog', 'id=" + pageBase.getId() + "');"; %>
          <v:popup-item caption="@Common.History" fa="history" onclick="<%=onclickHistory%>"/>
        <% } %>
      </v:tab-plus>
    <% } %>
  </v:tab-group>
</div>

<script>

function showTicketCancellationDialog() {
  asyncDialog({
    url : "<%=pageBase.getContextURL()%>?page=ticket_cancellation_dialog&EntityType=<%=LkSNEntityType.Media.getCode()%>&EntityId=<%=pageBase.getEmptyParameter("id")%>"});
}

</script>

<jsp:include page="/resources/common/footer.jsp"/>
