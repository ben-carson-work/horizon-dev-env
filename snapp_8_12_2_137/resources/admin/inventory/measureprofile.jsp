<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Measure.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMeasureProfile" scope="request"/>
<jsp:useBean id="measure" class="com.vgs.snapp.dataobject.DOMeasureProfile" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% boolean canEdit = true; %>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<div id="main-container">
  <v:tab-group name="tab" id="main-tab-group" main="true">
    <v:tab-item caption="@Common.Recap" icon="profile.png" jsp="measureprofile_tab_main.jsp" tab="main" default="true"/>

    <%-- ADD --%>
    <% if (!pageBase.isNewItem()) { %>
      <v:tab-plus>
        <%-- NOTES --%>
        <% String hrefNotes = "javascript:asyncDialogEasy('common/notes_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.MeasureProfile.getCode() + "');"; %>
        <v:popup-item caption="@Common.Notes" fa="comments" href="<%=hrefNotes%>"/>
        
        <%-- HISTORY --%>
        <% if (rights.History.getBoolean()) {%>
          <% String hrefHistory = "javascript:asyncDialogEasy('common/history_detail_dialog', 'id=" + pageBase.getId() + "');"; %>
          <v:popup-item caption="@Common.History" fa="history" href="<%=hrefHistory%>"/>
        <% } %>  
      </v:tab-plus>
    <% } %>
  </v:tab-group>
</div>


<jsp:include page="/resources/common/footer.jsp"/>
