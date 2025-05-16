<%@page import="java.util.*"%>
<%@page import="java.net.*"%>
<%@page import="com.vgs.store.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
boolean canEdit = pageBase.getRights().SuperUser.getBoolean() || pageBase.getRights().ExtensionPackages.canUpdate();
List<DOPackageInfoItem> newList = new ArrayList<>();

try {
  DOSTCmd_Store ansStore = new DOSTCmd_Store();
  String url = BLBO_DBInfo.getStoreURL() + "/service2?format=json&cmd=STORE&Command=PackageInfo&LicenseId=" + BLBO_DBInfo.getLicenseId() + "&SnappVersion=" + BLBO_DBInfo.getWebInit().getServletInit().Version.getEmptyString();
  
  ansStore.setDocSmart(JvHttpClient.getText(url, null, 30000, 60000));

  for (DOPackageInfoItem item : ansStore.Answer.PackageInfo.PackageInfoList) {
    String installedVersion = pageBase.getBL(BLBO_Plugin.class).findExtensionPackageVersion(item.PackageCode.getString());
    if (installedVersion == null)
      newList.add(item);
  }
  // Sort the list
  newList.sort(new Comparator<DOPackageInfoItem>() {
    @Override
    public int compare(DOPackageInfoItem item1, DOPackageInfoItem item2) {
      return item1.FileName.getString().compareTo(item2.FileName.getString()); 
    }
  });
}
catch (Throwable t) {
  %>
  <v:widget caption="Could not connect to VGS-STORE / PackageInfo" icon="[font-awesome]exclamation-triangle|ColorizeOrange">
    <v:widget-block>
      <span style="font-weight: bold">Error message:</span> <%=t.getMessage()%>
    </v:widget-block>
  </v:widget>
  <%
}
%>

<% if (canEdit && !newList.isEmpty()) { %>
  <v:grid id="newpkgs">  
    <thead>
      <tr class="header">
        <td></td>
        <td width="50%"><v:itl key="Module"/></td>
        <td width="30%"><v:itl key="Version"/></td>
        <td width="20%"></td>
      </tr>
    </thead>
    <tbody>
      <% for (DOPackageInfoItem item : newList) { %>
        <tr class="grid-row">
          <td><i class="icon fas fa-puzzle-piece"></i></td>
          <td>
            <div class="list-title"><%=item.PackageCode.getHtmlString()%></div>
            <div class="list-subtitle"><%=item.PackageName.getHtmlString() %></div>
          </td> 
          <td>
            <div class="list-title"><%=item.PackageVersion.getHtmlString()%></div>
            <div class="list-subtitle"><%=item.FileSize.getLong()>0?JvString.getSmoothSize(item.FileSize.getLong()):"&nbsp;"%></div>
          </td>
          <td align="right">
            <% String onclick = "downloadNewPackage('" + item.DownloadURL.getString() + "')"; %>
            <v:button fa="download" caption="@System.Install" onclick="<%=onclick %>" clazz="install-btn row-hover-visible" />
          </td>
        </tr>
      <% } %>
    </tbody>
  </v:grid>
<% } %>

<style>
#newpkg_dialog .grid-row .icon {
  width: 32px;
  text-align: center;
  font-size: 2em;
}

#newpkg_dialog .grid-row .icon {
  opacity: 0.4;
}
</style>

<% if (canEdit) { %>
  <script>
  function downloadNewPackage(urlo) {
    $("#newpkg_dialog").dialog("close");
  
    var reqDO = {
      Command: "InstallExtensionPackageFromURL",
      InstallExtensionPackageFromURL: {
        DownloadURL: urlo
      }
    };
    
    showWaitGlass();
    vgsService("Plugin", reqDO, false, function(ansDO) {
      hideWaitGlass();
      showMessage("<v:itl key="@Common.SaveSuccessMsg" encode="UTF-8"/>", function() {
        location.reload();
      });
    });
  }
  </script>
<% } %>