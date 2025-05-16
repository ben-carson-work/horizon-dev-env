<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageLangPickupWidget" scope="request"/>

<style>

.listcontainer tr {
  cursor: pointer;
}

</style>

<v:grid id="lang-grid">
  <% if (pageBase.isParameter("ShowDefault", "true")) { %>
    <tr id="default" data-LangName="<v:itl key="@Common.Default"/>" data-IconName="">
      <td></td>
      <td></td>
      <td width="100%">
        <v:itl key="@Common.Default"/>
      </td>
    </tr>
  <% } %>

  <% for (String langISO : SnappUtils.getLangISOs()) { %>
    <% String icon = SnappUtils.getFlagName(langISO); %>
    <% Locale locale = new Locale(langISO); %>
    <% String langName = JvString.getPascalCase(locale.getDisplayLanguage(pageBase.getLocale())); %>
    <% if (icon != null) { %>
      <tr id="<%=langISO%>" data-LangName="<%=JvString.escapeHtml(langName)%>" data-IconName="<%=icon%>">
        <td><img src="<v:image-link name="<%=icon%>" size="32"/>"/></td>
        <td><%=langISO%></td>
        <td width="100%">
          <%=JvString.escapeHtml(langName)%><br/>
          <span class="list-subtitle"><%=JvString.escapeHtml(locale.getDisplayLanguage(locale))%></span>
        </td>
      </tr>
    <% } %>
  <% } %>
</v:grid>

<script>
  $("#lang-grid tr").mouseenter(function() {
    $(this).addClass("selected-row");
  }).mouseleave(function() {
    $(this).removeClass("selected-row");
  }).click(function() {
    languagePickupCallback($(this).attr("id"), $(this).attr("data-LangName"), $(this).attr("data-IconName"));
    $(this).closest(".ui-dialog-content").dialog("close");
  });
</script>