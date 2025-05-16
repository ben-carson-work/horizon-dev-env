<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="pkg" class="com.vgs.snapp.dataobject.DOExtensionPackage" scope="request"/>

<div class="tab-content">
  <v:grid>
    <% for (DOPluginDefinition.PluginDef item : pkg.PackageInfo.PlgDefList) { %>
      <tr class="grid-row">
        <td><v:grid-icon name="<%=item.DriverType.getLkValue().getIconName()%>"/></td>
        <td width="60%">
          <%=JvString.escapeHtml(item.DriverType.getLookupDesc(pageBase.getLang()))%><br/>
          <span class="list-subtitle"><%=item.ClassName.getHtmlString()%></span>
        </td>
        <td width="40%">
          <span class="list-subtitle"><%=item.ClassAlias.getHtmlString()%></span>
        </td>
      </tr>
    <% } %> 
    
    <% for (DOPluginDefinition.PluginDef item : pkg.PackageInfo.AptDefList) { %>
      <tr class="grid-row">
        <td><v:grid-icon name="<%=item.DriverType.getLkValue().getIconName()%>"/></td>
        <td width="60%">
          <%=JvString.escapeHtml(item.DriverType.getLookupDesc(pageBase.getLang()))%><br/>
          <span class="list-subtitle"><%=item.ClassName.getHtmlString()%></span>
        </td>
        <td width="40%">
          <span class="list-subtitle"><%=item.ClassAlias.getHtmlString()%></span>
        </td>
      </tr>
    <% } %>  
    <%-- 
    <% for (DOPluginDefinition.PluginDef item : pkg.PackageInfo.ServiceList) { %>
      <tr class="grid-row">
        <td><v:grid-icon name="<%=JvImageCache.ICON_SETTINGS%>"/></td>
        <td width="60%">
          Service<br/>
          <span class="list-subtitle"><%=item.ClassName.getHtmlString()%></span>
        </td>
        <td width="40%">
          <span class="list-subtitle"><%=item.ClassAlias.getHtmlString()%></span>
        </td>
      </tr>
    <% } %>
    --%>
    <% for (DOPluginDefinition.Task item : pkg.PackageInfo.TaskList) { %>
      <tr class="grid-row">
        <td><v:grid-icon name="<%=LkSNEntityType.Task.getIconName()%>"/></td>
        <td width="60%">
          <v:itl key="@Task.Task"/><br/>
          <span class="list-subtitle"><%=item.ClassName.getHtmlString()%></span>
        </td>
        <td width="40%">
          <span class="list-subtitle"><%=item.ClassAlias.getHtmlString()%></span>
        </td>
      </tr>
    <% } %>
    <% for (DOPluginDefinition.DOOutboundMessageDef item : pkg.PackageInfo.OutboundMessageList) { %>
      <tr class="grid-row">
        <td><v:grid-icon name="<%=LkSNEntityType.OutboundMessage.getIconName()%>"/></td> 
        <td width="60%">
          <v:itl key="@Outbound.OutboundMessage"/><br/>
          <span class="list-subtitle"><%=item.WorkerClassName.getHtmlString()%></span>
        </td>
        <td width="40%">
          <span class="list-subtitle"><%=item.ClassAlias.getHtmlString()%></span>
        </td>
      </tr>
    <% } %>
  </v:grid>
</div>