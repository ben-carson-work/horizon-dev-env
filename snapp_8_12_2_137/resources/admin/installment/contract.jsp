<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.bko.page.PageBO_InstallmentContract" scope="request"/>
<jsp:useBean id="contract" class="com.vgs.snapp.dataobject.DOInstallmentContract" scope="request"/>
<jsp:useBean id="contractRights" class="com.vgs.snapp.dataobject.DOInstallmentContractRights" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<div id="main-container">
  <v:tab-group name="tab" main="true">
    <v:tab-item caption="@Common.Profile" icon="profile.png" jsp="contract_tab_main.jsp" tab="main" default="true"/>
    <v:tab-item caption="@Ticket.Tickets" icon="ticket.png" jsp="contract_tab_ticket.jsp" tab="ticket" include="<%=!contract.TicketList.isEmpty()%>"/>
    
    <% String jsp_repository = "/admin?page=repositorylist_widget&id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.InstallmentContract.getCode() + "&readonly=" + !contractRights.EditDocuments.getBoolean(); %>
    <v:tab-item caption="@Common.Documents" icon="attachment.png" tab="repository" jsp="<%=jsp_repository%>" include="<%=!contract.ContractDocList.isEmpty()%>"/>
    
    <v:tab-item caption="@Common.Emails" fa="envelope" jsp="contract_tab_action.jsp" tab="email" include="<%=contract.ActionCount.getInt()>0%>"/>
    <v:tab-item caption="@Common.Logs" icon="<%=LkSNEntityType.Log.getIconName()%>" jsp="../log/log_tab_widget.jsp" tab="log" include="<%=contract.LogCount.getInt()>0%>"/>
    <v:tab-item caption="@Common.Transaction" fa="calendar" jsp="contract_tab_transaction.jsp" tab="trn" include="<%=!contract.LinkedTransactionList.isEmpty()%>"/>
    
    <%-- ADD --%>
    <% if (contractRights.CRUD.canUpdate()) { %>
      <v:tab-plus>
        <% if (contractRights.EditDocuments.getBoolean()) { %>
    	    <%-- UPLOAD --%>
    	    <% String hrefUpload = "javascript:showUploadDialog(" + LkSNEntityType.InstallmentContract.getCode() + ", '" + pageBase.getId() + "', " + contract.ContractDocList.isEmpty() + ");"; %>
    	    <v:popup-item caption="@Common.UploadFile" title="@Common.UploadFileHint" fa="upload" href="<%=hrefUpload%>"/>
        <% } %>
	    <%-- HISTORY --%>
	    <% if (rights.History.getBoolean()) {%>
	      <% String hrefHistory = "javascript:asyncDialogEasy('common/history_detail_dialog', 'id=" + pageBase.getId() + "');"; %>
	      <v:popup-item caption="@Common.History" fa="history" href="<%=hrefHistory%>"/>
	    <% } %>
      <%-- NOTES --%>
      <% String hrefNotes = "javascript:asyncDialogEasy('common/notes_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.InstallmentContract.getCode() + "');"; %>
      <v:popup-item caption="@Common.Notes" fa="comments" href="<%=hrefNotes%>"/>
      <%-- AUTOMATIC BLOCK --%>        
      <% if (contractRights.AutoBlock.getBoolean()) { %> 
        <v:popup-item id="menu-contract-auto-block" caption="@Installment.AutomaticBlock" fa="lock"/>
      <% } %>  
      <%-- AUTOMATIC UNBLOCK --%>        
      <% if (contractRights.AutoUnblock.getBoolean()) { %> 
        <v:popup-item id="menu-contract-auto-unblock" caption="@Installment.AutomaticUnblock" fa="unlock"/>
      <% } %>  
      </v:tab-plus>
    <% } %>
     
  </v:tab-group>
</div>


<jsp:include page="/resources/common/footer.jsp"/>
