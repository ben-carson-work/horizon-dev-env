<%@page import="com.vgs.snapp.library.FtCRUD"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTicket" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="ticket" class="com.vgs.snapp.dataobject.DOTicket" scope="request"/>
<jsp:useBean id="rightCRUD" class="com.vgs.snapp.library.FtCRUD" scope="request"/>
<% boolean canEdit = rightCRUD.canUpdate(); %>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<div id="main-container">
  <v:tab-group name="tab" main="true"> 
    <v:tab-item tab="main"        caption="@Common.Recap" icon="profile.png" jsp="ticket_tab_main.jsp" default="true"/>
    <v:tab-item tab="ent"         caption="@Common.Entitlements" icon="ticket.png" jsp="ticket_tab_entitlement.jsp" />
    <v:tab-item tab="performance" caption="@Performance.Performances" icon="performance.png" jsp="ticket_tab_performance.jsp" include="<%=ticket.PerformanceBeforeUsage.getBoolean() || ticket.TicketPerformanceList.contains(x -> x.ValidForAdmission.getBoolean())%>"/>
    <v:tab-item tab="guest"       caption="@Product.Guests" icon="<%=LkSNEntityType.ProductType.getIconName()%>" jsp="ticket_tab_guest.jsp" include="<%=(ticket.GuestProductTypeCount.getInt() > 0)%>"/>
    <v:tab-item tab="package"     caption="@Package.Package" icon="package.png" jsp="ticket_tab_package.jsp" include="<%=(ticket.PackageGroupItemCount.getInt() > 0)%>"/>
    <v:tab-item tab="transaction" caption="@Common.Transactions" icon="transaction.png" jsp="ticket_tab_transaction.jsp" include="<%=(ticket.TransactionCount.getInt() > 0)%>" />
    
    <% String paramsTicket = "PortfolioId=" + ticket.PortfolioId.getString(); %>
    <v:tab-item tab="pfticket"    caption="@Common.PortfolioTickets" icon="ticket-new.png" jsp="tab_portfolioticket.jsp" params="<%=paramsTicket%>" include="<%=(ticket.Portfolio.TicketCount.getInt() > 1)%>" />
    
    <% String paramsMedia = "PortfolioId=" + ticket.PortfolioId.getString(); %>
    <v:tab-item tab="pfmedia"     caption="@Common.PortfolioMedias" icon="media.png" jsp="tab_portfoliomedia.jsp" params="<%=paramsMedia%>" include="<%=(ticket.Portfolio.MediaCount.getInt() > 1)%>"/>

    <v:tab-item tab="revenue"     caption="@Product.RevenueAmortization" icon="coins.png" jsp="ticket_tab_revenue_amortization.jsp" include="<%=(ticket.AmortizationCount.getInt() > 1)%>"/>
    <v:tab-item tab="ticket_tab_activationgroup" caption="@ActivationGroup.ActivationGroup" fa="users" jsp="ticket_tab_activationgroup.jsp" include="<%=(ticket.ActivationGroupTicketCount.getInt() > 0)%>"/>
    <v:tab-item tab="metadata"    caption="@Common.Forms" icon="mask.png" jsp="ticket_tab_metadata.jsp" include="<%=(!ticket.MaskList.isEmpty() || !ticket.MetaDataList.isEmpty())%>"/>  
    
    <%-- REPOSITORY --%>
    <% if ((ticket.RepositoryCount.getInt() > 0) || pageBase.isTab("tab", "repository")) { %>
      <% String jsp_repository = pageBase.getContextURI() + "?page=repositorylist_widget&id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Ticket.getCode() + "&readonly=" + !canEdit; %>
      <v:tab-item tab="repository" caption="@Common.Documents" icon="attachment.png" jsp="<%=jsp_repository%>" />
    <% } %>
    
    <v:tab-item tab="log" caption="@Common.Logs" icon="<%=LkSNEntityType.Log.getIconName()%>" jsp="../common/page_tab_logs.jsp" include="<%=ticket.LogCount.getInt() > 0%>"/>
    
    <v:tab-plus>
      <%-- CODE ALIASES--%>  
      <% String hrefCodeAlias = "javascript:asyncDialogEasy('code_alias_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Ticket.getCode() + "')"; %>
      <v:popup-item caption="@Common.CodeAliases" fa="barcode" href="<%=hrefCodeAlias%>"/>

      <%-- EXTERNAL IDENTIFIERS--%>
      <% if (!ticket.ExternalIdentifierList.isEmpty()) { %>
        <% String hrefExternalIdentifiers = "javascript:asyncDialogEasy('external_identifiers_dialog', 'EntityTDSSN=" + ticket.TicketCode.getString() + "&EntityType=" + LkSNEntityType.Ticket.getCode() + "&TransactionType=" + ticket.TransactionType.getInt() + "')"; %> 
        <v:popup-item caption="@Common.ExternalIdentifiers" fa="external-link" href="<%=hrefExternalIdentifiers%>"/>
      <% } %>
      
      <% if (canEdit) { %>
      <%-- UPLOAD --%>
          <% String hrefUpload = "javascript:showUploadDialog(" + LkSNEntityType.Ticket.getCode() + ", '" + ticket.TicketId.getString() + "', " + (ticket.RepositoryCount.getInt() == 0) + ");"; %>
          <v:popup-item caption="@Common.UploadFile" title="@Common.UploadFileHint" fa="upload" href="<%=hrefUpload%>"/>
      <% } %>
      
      <%-- NOTES --%>
      <% String hrefNotes = "javascript:asyncDialogEasy('common/notes_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Ticket.getCode() + "');"; %>
      <v:popup-item caption="@Common.Notes" fa="comments" href="<%=hrefNotes%>"/>

      <%-- HISTORY --%>
      <% if (rights.History.getBoolean()) { %>
        <% String hrefHistory = "javascript:asyncDialogEasy('common/history_detail_dialog', 'id=" + pageBase.getId() + "');"; %>
        <v:popup-item caption="@Common.History" fa="history" href="<%=hrefHistory%>"/>
      <% } %>  
    </v:tab-plus>
  </v:tab-group>
</div>

<jsp:include page="/resources/common/footer.jsp"/>
