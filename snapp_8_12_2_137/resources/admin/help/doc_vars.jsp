<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.dataobject.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageDocTemplateVars" scope="request"/>

<%
List<LookupItem> docTemplateTypes = LookupManager.getArray(
    LkSNDocTemplateType.Media,
    LkSNDocTemplateType.TrnReceipt,
    LkSNDocTemplateType.CCReceipt,
    LkSNDocTemplateType.BoxReceipt,
    LkSNDocTemplateType.WalletReceipt,
    LkSNDocTemplateType.PaymentReceipt,
    LkSNDocTemplateType.GiftCardLookupReceipt,
    LkSNDocTemplateType.PortfolioSlotLogReceipt,
    LkSNDocTemplateType.PrintableErrorReceipt,
    LkSNDocTemplateType.OrderConfirmation, 
    LkSNDocTemplateType.InstallmentContract,
    LkSNDocTemplateType.Invoice,
    LkSNDocTemplateType.UserProfileNotification,
    LkSNDocTemplateType.AccountNotification,
    LkSNDocTemplateType.AutoGenDoc,
    LkSNDocTemplateType.PayByLinkPage,
    LkSNDocTemplateType.GridAccount
);
%>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<style>
.help-doc-paramname {
  font-weight: bold;
}
.help-doc-description {
  font-style: italic;
}
</style>

<v:tab-group id="doctemplate-vars" name="tab" main="true">
  <v:tab-item-embedded tab="templates" fa="print" caption="@DocTemplate.DocTemplates" default="true">
    <v:tab-content clazz="v-height-to-bottom">
      <v:tab-group name="" sideNav="true" clazz="sidenav-large">
        <% boolean first = true; %>
        <% for (LookupItem item : docTemplateTypes) { %>
          <%
          LkSNDocTemplateType.DocTemplateTypeItem docTemplateType = (LkSNDocTemplateType.DocTemplateTypeItem)item; 
          String tabId = "template-" + docTemplateType.getCode();
          String dynpage = "admin?page=widget&jsp=help/doc_vars_widget&DocTemplateType=" + docTemplateType.getCode();
          %>
          <v:tab-item-embedded 
              tab="<%=tabId%>" 
              caption="<%=docTemplateType.getRawDescription()%>" 
              icon="<%=docTemplateType.getIconName()%>" 
              dynpage="<%=dynpage%>" 
              default="<%=first%>">
          </v:tab-item-embedded>
          <% first = false; %>
        <% } %>
      </v:tab-group>
    </v:tab-content>
  </v:tab-item-embedded> 

  <v:tab-item-embedded tab="common" fa="info-circle" caption="@Common.General" dynpage="admin?page=widget&jsp=help/doc_vars_tab_main"></v:tab-item-embedded>
  
  <% String dynpageConfig = "admin?page=widget&jsp=help/doc_vars_widget&DocTemplateType=" + LkSNDocTemplateType.HelpDocConfig.getCode(); %>
  <v:tab-item-embedded tab="config" fa="cog" caption="@Common.Configuration" dynpage="<%=dynpageConfig%>"></v:tab-item-embedded>
  
  <% String dynpageITL = "admin?page=widget&jsp=help/doc_vars_widget&DocTemplateType=" + LkSNDocTemplateType.HelpDocITL.getCode(); %>
  <v:tab-item-embedded tab="itl" icon="<%=LkSNEntityType.Lang.getIconName()%>" caption="@Common.Translation" dynpage="<%=dynpageITL%>"></v:tab-item-embedded>
</v:tab-group>

<jsp:include page="/resources/common/footer.jsp"/>
