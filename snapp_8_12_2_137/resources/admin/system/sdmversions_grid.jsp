<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<jsp:useBean id="rights" scope="request" class="com.vgs.snapp.dataobject.DORightRoot"/>

<%
List<DOSdmInfoItem> clientVersions = BLBO_DBInfo.getStoreSdmVersions(BLBO_DBInfo.getWebInit().getWarVersion());
%>

<v:grid>
  <thead>
    <tr class="header">
      <td></td>
      <td width="33%"><v:itl key="@Common.Version"/></td>
      <td width="33%"><v:itl key="@Common.Size"/></td>
      <td width="34%"></td>
    </tr>
  </thead>
  <tbody>
    <% for (DOSdmInfoItem item : clientVersions) { %>
      <tr class="grid-row">
        <td><i class="icon fas fa-desktop"></i></td>
        <td>
          <div class="list-title"><%=item.SdmVersion.getHtmlString()%></div>
        </td>
        <td>
          <div><%=item.FileSize.getLong()>0?JvString.getSmoothSize(item.FileSize.getLong()):"&nbsp;"%></div>
        </td>
        <td align="right">
          <% String onclick="doUpdateClientVersion('" + item.SdmVersion.getHtmlString() + "')"; %>
          <v:button fa="download" caption="@System.Download" onclick="<%=onclick %>" clazz="install-btn row-hover-visible" />
        </td>
      </tr>
    <% } %>
  </tbody>
</v:grid>

<style>
#sdm_versions_dialog .grid-row .icon {
  width: 32px;
  text-align: center;
  font-size: 2em;
}

#sdm_versions_dialog .grid-row .icon {
  opacity: 0.4;
}
</style>

<script>
function doDownloadSdmVersionVersion(version) {
  $("#sdm_versions_dialog").dialog("close");  
  showWaitGlass();

}
</script>