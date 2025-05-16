<%@page import="java.util.*"%>
<%@page import="java.net.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<v:dialog id="newpkg_dialog" title="@Plugin.ExtensionPackage" width="700" height="600" autofocus="false">  

  <% if (rights.SoftwareManualUpload.getBoolean() || (rights.VGSSupport.getBoolean() && BLBO_DBInfo.isTestMode())) { %>
    <div class="form-toolbar">
      <v:button fa="upload" caption="@Common.UploadFile" onclick="asyncDialogEasy('plugin/extpackage_upload_dialog')"/>
    </div>
  <% } %>
  
  <v:async-grid id="newpkgs-grid" jsp="system/newpkgs_grid.jsp"/>
  
</v:dialog>