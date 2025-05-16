<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageInvoice" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="invoice" class="com.vgs.snapp.dataobject.DOInvoice" scope="request"/>

<jsp:include page="../../common/header.jsp"/>

<v:page-title-box/>

<div id="main-container">
  <v:tab-group name="tab" main="true">
    <%-- PROFILE --%>
    <v:tab-item caption="@Common.Recap" icon="profile.png" jsp="invoice_tab_main.jsp" tab="main" default="true"/>
    
    <%-- TRANSACTIONS --%>
    <% if (invoice.TransactionCount.getInt() > 0) { %>
    <v:tab-item caption="@Common.Transactions" icon="transaction.png" jsp="invoice_tab_transaction.jsp" tab="transaction"/>
    <%}%>
              
    <%-- ACTION --%>
    <% if ((invoice.ActionCount.getInt() > 0) || pageBase.isTab("tab", "action")) { %>
      <v:tab-item caption="@Common.Email" fa="envelope" tab="action" jsp="../common/page_tab_actions.jsp" />
    <% } %>
    
    <%-- ADD --%>
    <v:tab-plus>
      <%-- NOTES --%>
      <% String hrefNotes = "javascript:asyncDialogEasy('common/notes_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Invoice.getCode() + "');"; %>
      <v:popup-item caption="@Common.Notes" fa="comments" href="<%=hrefNotes%>"/>
      <%-- HISTORY --%>
      <% if (rights.History.getBoolean()) {%>
        <% String onclickHistory = "asyncDialogEasy('common/history_detail_dialog', 'id=" + pageBase.getId() + "');"; %>
        <v:popup-item caption="@Common.History" fa="history" onclick="<%=onclickHistory%>"/>
      <% } %>  
    </v:tab-plus>
  </v:tab-group>
</div>

<jsp:include page="../../common/footer.jsp"/>
