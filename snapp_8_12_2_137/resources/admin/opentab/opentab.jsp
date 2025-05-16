<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Opentab.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageOpentab" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="opentabRef" class="com.vgs.snapp.dataobject.DOOpentabRef" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<div id="main-container">
  <v:tab-group name="tab" main="true">
  	<%-- PROFILE --%>
    <v:tab-item caption="@Common.Recap" icon="profile.png" jsp="opentab_tab_main.jsp" tab="main" default="true"/>
    
    <v:tab-plus>
      <%-- NOTES --%>
      <% String hrefNotes = "javascript:asyncDialogEasy('common/notes_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Opentab.getCode() + "');"; %>
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