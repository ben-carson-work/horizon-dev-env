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

<div class="tab-toolbar">
  <v:button id="btn-pkg-settings-save" fa="save" caption="@Common.Save"/>
</div>

<div class="tab-content">
  <% String jsp = "/plugins/" + pkg.ExtensionPackageCode.getString() + "/" + pkg.PackageInfo.SettingsJSP.getString(); %>
  <jsp:include page="<%=jsp%>"></jsp:include>
</div>

<script>
$(document).ready(function() {
  $("#btn-pkg-settings-save").click(function() {
    var reqDO = {
      Command: "SaveExtensionPackageConfig",
      SaveExtensionPackageConfig: {
        ExtensionPackageId: <%=pkg.ExtensionPackageId.getJsString()%>,
        ConfigDoc: (functionExists("getExtensionPackageConfigDoc")) ? JSON.stringify(getExtensionPackageConfigDoc()) : null
      }
    };
    
    showWaitGlass();
    vgsService("Plugin", reqDO, false, function() {
      hideWaitGlass();
    });
  });
});
</script>
