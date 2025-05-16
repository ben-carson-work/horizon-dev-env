<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTranslate" scope="request"/>

<jsp:include page="../common/header.jsp"/>
<v:page-title-box/>
  
<v:tab-group name="tab" id="main-tab-group" main="true">
<% String defaultLang = (pageBase.getLangISO() == null) ? "en" : pageBase.getLangISO(); %>
<% for (String langISO : Locale.getISOLanguages()) { %>
  <% String icon = SnappUtils.getFlagName(langISO); %>
  <% Locale locale = new Locale(langISO); %>
  <% String langName = JvString.getPascalCase(locale.getDisplayLanguage(pageBase.getLocale())); %>
  <% if (icon != null) { %>
    <v:tab-item caption="<%=langName%>" icon="<%=icon%>" jsp="translate_tab_main.jsp" tab="<%=langISO%>" default="<%=langISO.equalsIgnoreCase(defaultLang)%>"/>
  <% } %>
<% } %>
</v:tab-group>
 
<jsp:include page="../common/footer.jsp"/>
