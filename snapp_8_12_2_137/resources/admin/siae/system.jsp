<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@page import="com.vgs.snapp.dataobject.DOSiaeSystem"%>
<%@page import="com.vgs.web.library.BLBO_Siae"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSiaeSystem" scope="request"/>
<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
<%
BLBO_Siae bl = pageBase.getBLDef();
boolean canReset = bl.canReset(); 
%>
<div class="mainlist-container">
  <% if (canReset) {%>
  <div class="form-toolbar">
    <% String clickReset = "asyncDialogEasy('siae/system_reset_dialog')"; %>
    <v:button id="reset-btn" caption="@Common.Reset" fa="eraser" enabled="<%=canReset%>" onclick="<%=clickReset%>"/>
  </div>
  <% } %>

  <jsp:include page="/resources/admin/siae/siae_alert.jsp" />
  <% if (bl.existsMainSystem()) {
    DOSiaeSystem system = bl.loadMainSystem();
    request.setAttribute("system", system);
  %>

  <v:widget caption="@Common.General" icon="profile.png">
    <v:widget-block>
        <v:form-field caption="Codice sistema" mandatory="true">
        <v:input-text field="system.CodiceSistema" enabled="false" />
      </v:form-field>
      <v:form-field caption="Denominazione" mandatory="true">
        <v:input-text field="system.Denominazione" enabled="false" />
      </v:form-field>
      <v:form-field caption="CodiceFiscale" mandatory="true">
        <v:input-text field="system.CodiceFiscale" enabled="false"/>
      </v:form-field>
      <v:form-field caption="Ubicazione">
        <v:input-text field="system.Ubicazione" enabled="false"/>
      </v:form-field>
      <v:form-field caption="Email mittente">
        <v:input-text field="system.EmailMittente" enabled="false"/>
      </v:form-field>
      <v:form-field caption="Email destinazione">
        <v:input-text field="system.EmailDestinazione" enabled="false"/>
      </v:form-field>
      <v:form-field caption="REA">
        <v:input-text field="system.REA" enabled="false" />
      </v:form-field>
      <v:form-field caption="Nazione">
        <v:input-text field="system.Nazione" enabled="false" />
      </v:form-field>
      <v:form-field caption="Codice provvedimento">
        <v:input-text field="system.CodiceProvvedimento" enabled="false" />
      </v:form-field>
      <v:form-field caption="Data provvedimento">
        <v:input-text field="system.DataProvvedimento" enabled="false" />
      </v:form-field>
      <v:form-field caption="SIAE competenza">
        <v:input-text field="system.SiaeCompetenza" enabled="false" />
      </v:form-field>
    </v:widget-block>
  </v:widget>
<% } %>
</div>

<jsp:include page="/resources/common/footer.jsp"/>


