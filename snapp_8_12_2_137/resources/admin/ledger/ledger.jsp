<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
  
<v:tab-group name="tab" main="true">
  <v:tab-item caption="@Ledger.LedgerRuleTemplates" icon="ledgerrule.png" tab="ledgerprofile" jsp="ledgerruletemplate_list.jsp" default="true"/>
  <% String hrefPluginTab = "/admin?page=webplugin_tab_widget&DriverType=" + LkSNDriverType.Ledger.getCode(); %>
  <v:tab-item caption="@Plugin.Plugins" icon="plugin.png" tab="ledgerplugin" jsp="<%=hrefPluginTab%>"/>
</v:tab-group>
 
<jsp:include page="/resources/common/footer.jsp"/>
