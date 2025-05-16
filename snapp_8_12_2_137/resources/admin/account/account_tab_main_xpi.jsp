<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" scope="request" class="com.vgs.web.page.PageAccount"/>
<jsp:useBean id="account" scope="request" class="com.vgs.snapp.dataobject.DOAccount"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
FtCRUD rightCRUD = (FtCRUD)request.getAttribute("rightCRUD");
boolean canCreate = rightCRUD.canCreate();
boolean canEdit = rightCRUD.canUpdate() || (rightCRUD.canCreate() && pageBase.isNewItem());
%>

<v:widget id="xpi-widget" caption="@XPI.CrossPlatform">
  <% if (!pageBase.isNewItem()) { %>
    <v:widget-block>
      <v:form-field caption="@Common.Status">
        <v:input-group>
          <input type="text" id="account.CrossPlatform.CrossPlatformStatus" class="form-control" readonly="readonly" value="<%=account.CrossPlatform.CrossPlatformStatus.getHtmlLookupDesc(pageBase.getLang())%>"/>
          <v:input-group-btn>
            <v:button id="btn-xpi-handshake" caption="@XPI.Handshake" bindSave="false" enabled="<%=canEdit && !account.CrossPlatform.CrossPlatformStatus.isLookup(LkSNCrossPlatformStatus.Disabled)%>"/>
            <% if (account.CrossPlatform.CrossPlatformStatus.isLookup(LkSNCrossPlatformStatus.Disabled)) { %>
              <v:button id="btn-xpi-enable" caption="@Common.Enable" enabled="<%=canEdit%>"/>
            <% } else  { %>
              <v:button id="btn-xpi-disable" caption="@Common.Disable" enabled="<%=canEdit%>"/>
            <% } %>
          </v:input-group-btn>
        </v:input-group>
      </v:form-field>
      <v:form-field caption="Workstation ID">
        <v:input-group>
          <% String wksDesc = account.CrossPlatform.WorkstationId.getEmptyString() + "   " + JvString.MDASH + "   APIKey: " + account.CrossPlatform.WorkstationAPIKey.getEmptyString(); %>
          <input type="text" class="form-control" readonly="readonly" value="<%=wksDesc%>"/>
          <v:input-group-btn>
            <% String clickWorkstation = account.CrossPlatform.WorkstationId.isNull() ? null : "window.open('" + EntityLinkManager.instance().getLink(false, LkSNEntityType.Workstation, account.CrossPlatform.WorkstationId.getString()) + "','_blank')"; %>
            <v:button fa="external-link" href="" onclick="<%=clickWorkstation%>"/>
          </v:input-group-btn>
        </v:input-group>
      </v:form-field>
      <v:form-field caption="@Account.OpArea" mandatory="true">
        <snp:dyncombo field="account.CrossPlatform.OpAreaId" entityType="<%=LkSNEntityType.OperatingArea%>" enabled="<%=canEdit%>" ancestorEntityType="<%=LkSNEntityType.Location%>" ancestorEntityId="<%=account.AccountId.getString()%>"/>
      </v:form-field>
    </v:widget-block>
  <% } %>
  
  <v:widget-block>
    <v:form-field caption="@XPI.CrossPlatformURL" hint="@XPI.CrossPlatformURLHint" mandatory="true">
      <v:input-text field="account.CrossPlatform.CrossPlatformURL" enabled="<%=canEdit%>"/>
    </v:form-field>
    <v:form-field caption="@Common.Type">
      <v:lk-combobox field="account.CrossPlatform.CrossPlatformType" lookup="<%=LkSN.CrossPlatformType%>" allowNull="false" enabled="<%=canEdit%>"/>
    </v:form-field>
  </v:widget-block>
  
  <v:widget-block clazz="<%=\"xpi-param-block xpi-param-block-\" + LkSNCrossPlatformType.SnApp.getCode()%>">
    <v:form-field caption="@XPI.CrossPlatformRef" hint="@XPI.CrossPlatformRefHint">
      <v:input-text field="account.CrossPlatform.CrossPlatformRef" enabled="<%=canEdit%>"/>
    </v:form-field>
    <v:form-field caption="@XPI.ApiKey" hint="@XPI.ApiKeyHint">
      <v:input-text field="account.CrossPlatform.CrossPlatformSecret" enabled="<%=canEdit%>"/>
    </v:form-field>
  </v:widget-block>

  <v:widget-block clazz="<%=\"xpi-param-block xpi-param-block-\" + LkSNCrossPlatformType.Generic.getCode()%>">
  </v:widget-block>
  
</v:widget>


<script>
$(document).ready(function() {
  const CROSS_PLATFORM_ID = <%=account.AccountId.getJsString()%>;
  
  $("#btn-xpi-handshake").click(_handshake);
  $("#btn-xpi-disable").click(_disable);
  $("#btn-xpi-enable").click(_enable);
  
  var $type = $("#account\\.CrossPlatform\\.CrossPlatformType").click(_refreshVisibility);
  _refreshVisibility();
  
  function _refreshVisibility() {
    $(".xpi-param-block").addClass("hidden").filter(".xpi-param-block-" + $type.val()).removeClass("hidden");
  }
  
  $(document).von("#xpi-widget", "accountBeforeSave", _accountBeforeSave);
  
  function _accountBeforeSave(event, account) {
    var xp = account.CrossPlatform || {};
    xp.CrossPlatformType = $type.val();
    xp.OpAreaId = $("#account\\.CrossPlatform\\.OpAreaId").val();
    xp.CrossPlatformURL = $("#account\\.CrossPlatform\\.CrossPlatformURL").val();
    xp.CrossPlatformRef = $("#account\\.CrossPlatform\\.CrossPlatformRef").val();
    xp.CrossPlatformSecret = $("#account\\.CrossPlatform\\.CrossPlatformSecret").val();
    account.CrossPlatform = xp;
  }
  
  function _handshake() {
    if ($("#account-form").hasClass("data-changed"))
      showMessage(itl("@Common.SaveFirstError"));
    else {
      var reqDO = {
        Command: "SendHandshake",
        SendHandshake: {
          CrossPlatformId: CROSS_PLATFORM_ID
        }
      };

      showWaitGlass();
      vgsService("XPI", reqDO, false, function(ansDO) {
        hideWaitGlass();
        entitySaveNotification(<%=LkSNEntityType.CrossPlatform.getCode()%>, CROSS_PLATFORM_ID);
        showMessage(itl("@XPI.HandshakeSuccess"));
      });
    }
  }
  
  function _doChangeStatus(xpStatus) {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "SaveAccount",
        SaveAccount: {
          AccountId: CROSS_PLATFORM_ID,
          CrossPlatform: {
            CrossPlatformStatus: xpStatus
          }
        }
      };
        
      showWaitGlass();
      vgsService("Account", reqDO, false, function(ansDO) {
        hideWaitGlass();
        entitySaveNotification(<%=LkSNEntityType.CrossPlatform.getCode()%>, CROSS_PLATFORM_ID);
      });
    });
  }

  function _disable() {
    _doChangeStatus(<%=LkSNCrossPlatformStatus.Disabled.getCode()%>);
  }

  function _enable() {
    _doChangeStatus(<%=LkSNCrossPlatformStatus.Enabled.getCode()%>);
  }
});
</script>
