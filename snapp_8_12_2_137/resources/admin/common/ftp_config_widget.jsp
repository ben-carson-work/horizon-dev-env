<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="cfgftp" class="com.vgs.snapp.dataobject.DOFtpConfig" scope="request"/>
<%
PageBO_Base<?> pagetBase = (PageBO_Base<?>)request.getAttribute("pageBase");
%>
 
<div id="ftp-config-widget">
  <v:form-field caption="@Common.Type">
    <label class="checkbox-label"><input type="radio" name="cfgftp.ExportFileType" class="ftp-type-radio-btn" value="1"> <strong>FTP</strong> &mdash; <i><v:itl key="@Task.FTPDesc_FTP"/></i></label><br/> 
    <label class="checkbox-label"><input type="radio" name="cfgftp.ExportFileType" class="ftp-type-radio-btn" value="2"> <strong>FTPS</strong> &mdash; <i><v:itl key="@Task.FTPDesc_FTPS"/></i></label><br/>
    <label class="checkbox-label"><input type="radio" name="cfgftp.ExportFileType" class="ftp-type-radio-btn" value="3"> <strong>SFTP</strong> &mdash; <i><v:itl key="@Task.FTPDesc_SFTP"/></i></label><br/>
    <label class="checkbox-label"><input type="radio" name="cfgftp.ExportFileType" class="ftp-type-radio-btn" value="4"> <strong>Local Folder</strong> &mdash; <i><v:itl key="@Task.FTPDesc_Local"/></i></label>
  </v:form-field>
  <div id="ftp-host-config">
	  <v:form-field caption="@Common.HostName">
	    <v:input-text field="cfgftp.HostName"/>
	  </v:form-field>
	  <v:form-field caption="@Common.HostPort">
	    <v:input-text type="number" field="cfgftp.HostPort"/>
	  </v:form-field>
  </div>
  <v:form-field id="FTP_AuthenticationModeField" caption="@Common.FTPAuthenticationMode" hint="@Common.FTPAuthenticationModeHint">
    <v:lk-combobox field="cfgftp.AuthenticationMode" lookup="<%=LkSN.FTPauthenticationMode%>" allowNull="false"/>
  </v:form-field>
  <v:form-field id="FTP_UserField" caption="@Common.UserName">
    <v:input-text field="cfgftp.UserName" autocomplete="new-password" autocorrect="false"/>
  </v:form-field>
  <v:form-field id="FTP_PasswordField" caption="@Common.Password">
    <v:input-text field="cfgftp.Password" type="password" autocomplete="new-password" autocorrect="false"/>
  </v:form-field>
  <v:form-field id="FTP_SecretKeyField" caption="@Common.SecretKey">
    <v:input-txtarea field="cfgftp.SecretKey" rows="8"/>
  </v:form-field>
  <v:form-field caption="@Common.Folder" hint="Insert absolute or relative path, relative path doesn't need the initial '/' or ' \ ' char">
    <v:input-text field="cfgftp.Folder"/>
  </v:form-field>
  <v:form-field>
  	<v:db-checkbox field="cfgftp.DisableTmpFileUsage" caption="@Common.DirectFile" hint="Standard behavior is to copy the file with a .tmp name and then rename it with the final file name.
  																				Enabling this flag the usage of temporary file will be disabled and file will be copied directly with the final name" value="true" />
  </v:form-field>
</div>

<script>
  $(document).ready(function () {
    var $div = $("#ftp-config-widget");
    $div.find("input[type=radio][name=cfgftp\\.ExportFileType]").change(_refreshVisibility);
    $div.find("#cfgftp\\.AuthenticationMode").change(_refreshVisibility);
    <%if (cfgftp.ExportFileType.isLookup(LkSNFTPExportFileType.FTPS)) { %>
      $div.find(".ftp-type-radio-btn[value=2]").attr("checked", true);
    <% } else if (cfgftp.ExportFileType.isLookup(LkSNFTPExportFileType.SFTP)) { %>
      $div.find(".ftp-type-radio-btn[value=3]").attr("checked", true);
	<%} else if (cfgftp.ExportFileType.isLookup(LkSNFTPExportFileType.LOCAL)) { %>
      $div.find(".ftp-type-radio-btn[value=4]").attr("checked", true);
    <% } else { %>
    	$div.find(".ftp-type-radio-btn[value=1]").attr("checked", true);
    <% } %>
    
    _refreshVisibility();
    
    function _refreshVisibility() {
      var FTPType = parseInt($div.find(".ftp-type-radio-btn:checked").val());
      var FTPAuthenticationMode = $div.find("#cfgftp\\.AuthenticationMode").val();
      $("#ftp-host-config").setClass("v-hidden", FTPType == <%=LkSNFTPExportFileType.LOCAL.getCode()%>);
      $("#FTP_UserField").setClass("v-hidden", FTPType == <%=LkSNFTPExportFileType.LOCAL.getCode()%>);
      $("#FTP_AuthenticationModeField").setClass("v-hidden", FTPType != <%=LkSNFTPExportFileType.SFTP.getCode()%>);
      $("#FTP_SecretKeyField").setClass("v-hidden", (FTPType != <%=LkSNFTPExportFileType.SFTP.getCode()%> || FTPAuthenticationMode == <%=LkSNFTPAuthenticationMode.Password.getCode()%>));
      $("#FTP_PasswordField").setClass("v-hidden", (FTPType == <%=LkSNFTPExportFileType.LOCAL.getCode()%> || (<%=LkSNFTPExportFileType.SFTP.getCode()%> && FTPAuthenticationMode == <%=LkSNFTPAuthenticationMode.SecretKey.getCode()%>)));
    }
  });
  
  function getFtpConfig() {
    var $div = $("#ftp-config-widget");
    var FTPAuthenticationMode = $div.find("#cfgftp\\.AuthenticationMode").val();
    var password = null;
    var secretKey = null;
    
    if (FTPAuthenticationMode == <%=LkSNFTPAuthenticationMode.Password.getCode()%>)
      password = $div.find("#cfgftp\\.Password").val();
    else if (FTPAuthenticationMode == <%=LkSNFTPAuthenticationMode.SecretKey.getCode()%>)
      secretKey = $div.find("#cfgftp\\.SecretKey").val();
    else if (FTPAuthenticationMode == <%=LkSNFTPAuthenticationMode.PasswordAndSecretKey.getCode()%>) {
      password = $div.find("#cfgftp\\.Password").val();
      secretKey = $div.find("#cfgftp\\.SecretKey").val();
    }

    return {
      "HostName": $div.find("#cfgftp\\.HostName").val(),
      "HostPort": $div.find("#cfgftp\\.HostPort").val(),
      "UserName": $div.find("#cfgftp\\.UserName").val(),
      "AuthenticationMode": FTPAuthenticationMode,
      "Password": password,
      "SecretKey": secretKey,
      "Folder": $div.find("#cfgftp\\.Folder").val(),
      "ExportFileType": parseInt($div.find(".ftp-type-radio-btn:checked").val()),
      "DisableTmpFileUsage" : $div.find("#cfgftp\\.DisableTmpFileUsage").isChecked()
    };
  }
</script>
