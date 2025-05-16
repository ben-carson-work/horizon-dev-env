<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<%
String field = JvUtils.getServletParameter(request, "iconAlias-Field");
String foregroundField = JvUtils.getServletParameter(request, "iconAlias-ForegroundField");
String backgroundField = JvUtils.getServletParameter(request, "iconAlias-BackgroundField");
boolean canEdit = JvString.isSameText(JvUtils.getServletParameter(request, "iconAlias-CanEdit"), "true");
%>
<v:widget>
  <v:widget-block clazz="icon-color-block">
    <v:icon-alias field="<%=field%>" fieldForegroundColor="<%=foregroundField%>" fieldBackgroundColor="<%=backgroundField%>" enabled="<%=canEdit%>"/>
    <div class="colors-block">
      <div class="color-line">
        <div class="color-line-caption"><v:itl key="@Common.Foreground"/></div>
        <v:color-picker field="<%=foregroundField%>" clazz="color-line-picker color-line-picker-foreground" enabled="<%=canEdit%>"/>
      </div>          
      <div class="color-line">
        <div class="color-line-caption"><v:itl key="@Common.Background"/></div>
        <v:color-picker field="<%=backgroundField%>" clazz="color-line-picker color-line-picker-background" enabled="<%=canEdit%>"/>
      </div>          
    </div>
  </v:widget-block>
</v:widget>
