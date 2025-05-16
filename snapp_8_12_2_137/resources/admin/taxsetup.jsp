<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTaxSetup" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
  
<v:tab-group name="tab" main="true">
  <% boolean first = true; %>
  <% if (rights.SettingsTaxes.getBoolean()) { %>
    <v:tab-item caption="@Product.TaxProfiles" icon="tax.png" tab="taxprofile" jsp="taxsetup_tab_taxprofile.jsp" default="<%=first%>"/>
    <% first = false; %>
  <% } %>
  <% if (rights.SettingsTaxes.getBoolean()) { %>
    <v:tab-item caption="@Product.Taxes" icon="tax.png" tab="tax" jsp="taxsetup_tab_tax.jsp" default="<%=first%>"/>
    <% first = false; %>
  <% } %>
  
</v:tab-group>
 
<jsp:include page="/resources/common/footer.jsp"/>
