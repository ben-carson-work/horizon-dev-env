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

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
String version = BLBO_DBInfo.getWebInit().getServletInit().Version.getEmptyString();
int licenseId = BLBO_DBInfo.getLicenseId();
String url = BLBO_DBInfo.getStoreURL() + "/service2?format=json&cmd=STORE&Command=PackageInfo&LicenseId=" + licenseId + "&SnappVersion=" + version;
String json = JvHttpClient.getText(url);
DOSTCmd_Store ansStore = new DOSTCmd_Store();
ansStore.setDocSmart(json);

List<DOPackageInfoItem> updList = new ArrayList<>(); 
List<DOPackageInfoItem> newList = new ArrayList<>();

for (DOPackageInfoItem item : ansStore.Answer.PackageInfo.PackageInfoList) {
  String installedVersion = pageBase.getBL(BLBO_Plugin.class).findExtensionPackageVersion(item.PackageCode.getString());
  if (installedVersion == null)
    newList.add(item);
  else if (!item.PackageVersion.isSameString(installedVersion))
    updList.add(item);
}

ArrayList<List<DOPackageInfoItem>> allList = new ArrayList<>();
if (!updList.isEmpty())
  allList.add(updList);
if (!newList.isEmpty())
  allList.add(newList);
%>

<v:dialog id="extpackage_update_dialog" title="@Plugin.ExtensionPackage" width="800" height="600" autofocus="false">

<style>
.install-button {
  font-weight: bold;
  opacity: 0.4;
  cursor: pointer;
  float: right;
}
.install-button:hover {
  opacity: 1;
}
.install-icon {
  display: inline-block;
  width: 16px;
  height: 16px;
  margin-right: 4px;
  vertical-align: middle;
}
</style>

<% if (allList.isEmpty()) { %>
  &nbsp;<p>
  <center><strong><v:itl key="@System.SoftwareUpToDate" encode="UTF-8"/></strong></center>
<% } else { %>
  <% for (List<DOPackageInfoItem> list : allList) { %>
    <%
    list.sort(new Comparator<DOPackageInfoItem>() {
      @Override
      public int compare(DOPackageInfoItem o1, DOPackageInfoItem o2) {
        return o1.PackageCode.getEmptyString().compareTo(o2.PackageCode.getEmptyString());
      }
    });
    
    String group = (list == updList) ? "@Plugin.ExtPackageUpdates" : "@Plugin.ExtPackageNew"; 
    %> 
    <v:grid>
      <thead>
        <v:grid-title caption="<%=group%>"/>
      </thead>
      <tbody>
        <% for (DOPackageInfoItem item : list) { %>
          <tr class="grid-row">
            <td width="250px" nowrap="nowrap"><strong><%=item.PackageCode.getHtmlString()%></strong></td> 
            <td width="100%"><%=item.PackageVersion.getHtmlString()%></td>
            <td nowrap="nowrap">
              <div class="install-button row-hover-visible" onclick="downloadPackage('<%=item.DownloadURL.getHtmlString()%>')">
                <span class="install-icon"></span><v:itl key="@Common.Download"/>
              </div>
            </td>
          </tr>
        <% } %>
      </tbody>
    </v:grid>
  <% } %>
<% } %>


<script>
function downloadPackage(urlo) {
	$("#extpackage_update_dialog").dialog("close");

	var reqDO = {
		Command: "InstallExtensionPackageFromURL",
		InstallExtensionPackageFromURL: {
			DownloadURL: urlo
		}
	};
	
	showWaitGlass();
	vgsService("Plugin", reqDO, false, function(ansDO) {
		hideWaitGlass();
		triggerEntityChange(<%=LkSNEntityType.ExtensionPackage.getCode()%>);
		showMessage(itl("@Common.SaveSuccessMsg"));
	});
}
</script>

</v:dialog>