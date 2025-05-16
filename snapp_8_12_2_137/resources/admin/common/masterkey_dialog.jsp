<%@page import="com.vgs.snapp.web.gencache.SrvBO_Cache_MasterKey"%>
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
if (!rights.SuperUser.getBoolean() && !rights.Encryption.getBoolean())
  throw new RuntimeException("Insufficient rights");

request.setAttribute("masterKey", SrvBO_Cache_MasterKey.instance().getMasterKey());
  
boolean fileExists = false;
if (!rights.MasterKeyFileLocation.isNull()) 
  fileExists = JvIO.filedirExists(rights.MasterKeyFileLocation.getString());
%>

<v:dialog id="masterkey_dialog" title="@Common.Encryption" width="640" autofocus="false">

  <v:form-field caption="File location">
    <v:input-text field="rights.MasterKeyFileLocation" enabled="<%=rights.MasterKeyFileLocation.isNull()%>"/>
  </v:form-field>
  <v:form-field caption="@Common.LastUpdate">
    <v:input-text field="masterKey.CreateDateTime" enabled="false"/>
  </v:form-field>
  <v:form-field id="masterkey-location-error" clazz="<%=(rights.MasterKeyFileLocation.isNull() || fileExists) ? \"hidden\" : \"\" %>">
    <span style="font-weight:bold; color:var(--base-red-color)">WARN: File cannot be found</span>
  </v:form-field>

<script>
$(document).ready(function() {
  var dlg = $("#masterkey_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        "id": "btn-masterkey-save",
        "text": <v:itl key="@Common.Save" encode="JS"/>,
        "class": "<%=rights.MasterKeyFileLocation.isNull() ? "" : "hidden"%>",
        "click": doMasterKeySave
      },
      {
        "id": "btn-masterkey-cancel", 
        "text": <v:itl key="@Common.Cancel" encode="JS"/>, 
        "class": "hidden",
        "click": doMasterKeyCancel
      },
      {
        "id": "btn-masterkey-edit", 
        "text": <v:itl key="@Common.Edit" encode="JS"/>, 
        "class": "<%=rights.MasterKeyFileLocation.isNull() ? "hidden" : ""%>",
        "click": doMasterKeyEdit
      },
      {
        "id": "btn-masterkey-regenerate", 
        "text": <v:itl key="Regenerate" encode="JS"/>, 
        "class": "<%=rights.MasterKeyFileLocation.isNull() ? "hidden" : ""%>",
        "click": doMasterKeyRegenerate
      }
    ];
  });
});

function doMasterKeySave() {
  showWaitGlass();
  
  var reqDO = {
    Command: "SaveMasterKeyLocation",
    SaveMasterKeyLocation: {
      FullFileName: $("#rights\\.MasterKeyFileLocation").val()
    }
  };
  
  vgsService("System", reqDO, false, function(ansDO) {
    hideWaitGlass();
    $("#rights\\.MasterKeyFileLocation").attr("readonly", "readonly");
    $("#masterkey-location-error").addClass("hidden");
    $("#btn-masterkey-save").addClass("hidden");
    $("#btn-masterkey-cancel").addClass("hidden");
    $("#btn-masterkey-edit").removeClass("hidden");
    $("#btn-masterkey-regenerate").removeClass("hidden");

    ansDO = ansDO.Answer.SaveMasterKeyLocation;
    var createDateTime = xmlToDate(ansDO.MasterKey.CreateDateTime);
    $("#rights\\.MasterKeyFileLocation").val(ansDO.FullFileName);
    $("#masterKey\\.CreateDateTime").val(formatDate(createDateTime, <%=rights.ShortDateFormat.getInt()%>) + " " + formatTime(createDateTime, <%=rights.ShortTimeFormat.getInt()%>));
  });
}

var oldMasterKeyValue = "";
function doMasterKeyCancel() {
  $("#rights\\.MasterKeyFileLocation").attr("readonly", "readonly").val(oldMasterKeyValue);
  $("#btn-masterkey-save").addClass("hidden");
  $("#btn-masterkey-cancel").addClass("hidden");
  $("#btn-masterkey-edit").removeClass("hidden");
  $("#btn-masterkey-regenerate").removeClass("hidden");
}

function doMasterKeyEdit() {
  oldMasterKeyValue = $("#rights\\.MasterKeyFileLocation").val(); 
  $("#rights\\.MasterKeyFileLocation").removeAttr("readonly").focus();
  $("#btn-masterkey-save").removeClass("hidden");
  $("#btn-masterkey-cancel").removeClass("hidden");
  $("#btn-masterkey-edit").addClass("hidden");
  $("#btn-masterkey-regenerate").addClass("hidden");
}

function doMasterKeyRegenerate() {
  showWaitGlass();
  
  var reqDO = {
    Command: "RegenerateMasterKey"
  };
  
  vgsService("System", reqDO, false, function(ansDO) {
    hideWaitGlass();
    var createDateTime = xmlToDate(ansDO.Answer.RegenerateMasterKey.MasterKey.CreateDateTime);
    $("#masterKey\\.CreateDateTime").val(formatDate(createDateTime, <%=rights.ShortDateFormat.getInt()%>) + " " + formatTime(createDateTime, <%=rights.ShortTimeFormat.getInt()%>));
  });
}

</script>

</v:dialog>