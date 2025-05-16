<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<%
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 
String defaultLangISO = pageBase.getLangISO();
String defaultLangIcon = SnappUtils.getFlagName(pageBase.getLangISO());
String defaultLangName = JvString.getPascalCase(pageBase.getLocale().getDisplayLanguage(pageBase.getLocale()));
%>
<div class="rich-desc-widget" data-defaultlangiso="<%=defaultLangISO%>" data-defaultlangicon="<%=defaultLangIcon%>" data-defaultlangname="<%=defaultLangName%>">
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/ckeditor/ckeditor.js"></script>
  <div id="lang-tabs-container" class="ui-tabs">
    <ul id="lang-tabs" class="ui-tabs-nav ui-corner-all ui-helper-reset ui-helper-clearfix ui-widget-header">
      <v:tab-plus id="plus_tab">
      <% for (String langISO : SnappUtils.getLangISOs()) { %>
        <% String icon = SnappUtils.getFlagName(langISO); %>
        <% if (icon != null) { %>
          <% Locale locale = new Locale(langISO); %>
          <% String langName = JvString.getPascalCase(locale.getDisplayLanguage(pageBase.getLocale())); %>
          <% String langDesc = langName + " | " + locale.getDisplayLanguage(locale); %>
          <% TagAttributeBuilder attr = TagAttributeBuilder.builder().put("data-langiso", langISO).put("data-langname", langName).put("data-iconname", icon); %>
          <v:popup-item clazz="menu-lang-item" icon="<%=icon%>" caption="<%=langDesc%>" attributes="<%=attr%>"/>
        <% } %>
      <% } %>
      </v:tab-plus>
    </ul>
  </div>
</div>
