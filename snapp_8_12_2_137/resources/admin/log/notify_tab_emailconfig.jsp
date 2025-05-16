<%@page import="com.vgs.snapp.library.SnappUtils"%>
<%@page import="com.vgs.snapp.dataobject.DOEmailConfig"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.bko.page.PageBO_Notify" scope="request" />
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
String logConfigPseudoId = SnappUtils.encodeLookupPseudoId(LkSN.EntityType, LkSNEntityType.EmailConfig);

DOEmailConfig emailcfg = pageBase.getBL(BLBO_Email.class).loadEmailConfig();
request.setAttribute("emailcfg", emailcfg);
%>

<div class="tab-toolbar">
  <v:button id="btn-save" fa="save" caption="@Common.Save" />
  <v:button id="btn-test" caption="Test" fa="paper-plane"/>
  <span class="divider"></span>
  <% String hrefHistory = "javascript:asyncDialogEasy('common/history_detail_dialog', 'id=" + logConfigPseudoId + "');"; %>
  <v:button caption="@Common.History" fa="history" href="<%=hrefHistory%>" enabled="<%=rights.History.getBoolean()%>"/>
</div>

<div class="tab-content">
  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="@SmtpSettings.SmtpHost">
        <v:input-text field="emailcfg.SmtpHost" />
      </v:form-field>

      <v:form-field caption="@SmtpSettings.SmtpPort">
        <v:input-text field="emailcfg.SmtpPort" />
      </v:form-field>

      <v:form-field caption="@SmtpSettings.SmtpStartTLS">
        <v:db-checkbox value="true" caption=""
          field="emailcfg.SmtpStartTLS" />
      </v:form-field>

      <v:form-field caption="@SmtpSettings.SmtpAuth">
        <v:db-checkbox value="true" caption="" field="emailcfg.SmtpAuth" />
      </v:form-field>
      
      <v:form-field caption="@SmtpSettings.SmtpSsl">
        <v:db-checkbox value="true" caption="" field="emailcfg.SmtpSsl" />
      </v:form-field>
      
      <v:form-field caption="@SmtpSettings.SmtpSslProtocols">
        <v:input-text field="emailcfg.SmtpSslProtocols" />
      </v:form-field>
      
      <v:form-field caption="@SmtpSettings.SmtpTimeout" hint="@SmtpSettings.SmtpTimeoutHint" >
       <v:input-text field="emailcfg.SmtpTimeout" placeholder="@SmtpSettings.SmtpTimeoutPlaceholder"/>
      </v:form-field>
      
      <v:form-field caption="@SmtpSettings.SmtpConnectionTimeout" hint="@SmtpSettings.SmtpConnectionTimeoutHint" >
       <v:input-text field="emailcfg.SmtpConnectionTimeout" placeholder="@SmtpSettings.SmtpConnectionTimeoutPlaceholder"/>
      </v:form-field>
      
      <v:form-field caption="@SmtpSettings.AddressSeparator">
        <v:input-text field="emailcfg.SmtpAddressSeparator" />
      </v:form-field>

      <v:form-field caption="Username">
        <v:input-text field="emailcfg.SmtpUserName" />
      </v:form-field>

      <v:form-field caption="Password">
        <v:input-text type="password" field="emailcfg.SmtpPassword" />
      </v:form-field>

      <v:form-field caption="@SmtpSettings.DefaultFrom">
        <v:input-text field="emailcfg.SmtpDefaultFrom" />
      </v:form-field>
    </v:widget-block>

    <v:widget-block>
      <v:form-field caption="@SmtpSettings.StripPlusAddresses" hint="@SmtpSettings.StripPlusAddressesHint">
        <v:db-checkbox value="true" caption="" field="emailcfg.StripPlusAddresses" />
      </v:form-field>
    </v:widget-block>
  </v:widget>
</div>

<script>

$(document).ready(function() {
  hidePasswordDOM();
  $("#btn-save").click(doSave);
  $("#btn-test").click(showEmailTestDialog);

  function doSave() {
    var reqDO = {
      Command : "SaveEmailConfig",
      SaveEmailConfig : {
        EmailConfig : {
          SmtpHost : $('#emailcfg\\.SmtpHost').val(),
          SmtpUserName : $('#emailcfg\\.SmtpUserName').val(),
          SmtpPassword : $('#emailcfg\\.SmtpPassword').val(),
          SmtpStartTLS : $('#emailcfg\\.SmtpStartTLS').isChecked(),
          SmtpSslProtocols : $('#emailcfg\\.SmtpSslProtocols').val(),
          SmtpAuth : $('#emailcfg\\.SmtpAuth').isChecked(),
          SmtpPort : $('#emailcfg\\.SmtpPort').val(),
          SmtpAddressSeparator : $('#emailcfg\\.SmtpAddressSeparator').val(),
          SmtpDefaultFrom : $('#emailcfg\\.SmtpDefaultFrom').val(),
          SmtpConnectionTimeout : $('#emailcfg\\.SmtpConnectionTimeout').val(),
          SmtpTimeout : $('#emailcfg\\.SmtpTimeout').val(),
          SmtpSsl :  $('#emailcfg\\.SmtpSsl').isChecked(),
          StripPlusAddresses :  $('#emailcfg\\.StripPlusAddresses').isChecked()
        }
      }
    };

    showWaitGlass();
    vgsService("System", reqDO, false, function() {
      hideWaitGlass();
      entitySaveNotification(<%=LkSNEntityType.EmailConfig.getCode()%>,null);
    });
  }

  function showEmailTestDialog() {
    var dlg = $("<div title='Email Test'/>");
    var txt = $("<input type='text' class='form-control' placeholder='Email address' />").appendTo(dlg);

    function _doSendTestEmail() {
      dlg.dialog("close");
      showWaitGlass();

      var reqDO = {
        Command : "SendTestEmail",
        SendTestEmail : {
          TestEmailAddress : txt.val(),
          SmtpHost : $('#emailcfg\\.SmtpHost').val(),
          SmtpPort : $('#emailcfg\\.SmtpPort').val(),
          SmtpStartTLS : $('#emailcfg\\.SmtpStartTLS').isChecked(),
          SmtpAuth : $('#emailcfg\\.SmtpAuth').isChecked(),
          SmtpUserName : $('#emailcfg\\.SmtpUserName').val(),
          SmtpPassword : $('#emailcfg\\.SmtpPassword').val(),
          SmtpAddressSeparator : $('#emailcfg\\.SmtpAddressSeparator').val(),
          SmtpDefaultFrom : $('#emailcfg\\.SmtpDefaultFrom').val(),
          SmtpConnectionTimeout : $('#emailcfg\\.SmtpConnectionTimeout').val(),
          SmtpTimeout : $('#emailcfg\\.SmtpTimeout').val(),
          SmtpSsl :  $('#emailcfg\\.SmtpSsl').isChecked()
        }
      };

      vgsService("Action", reqDO, false, function(ansDO) {
        hideWaitGlass();
        showMessage("Email sent");
      });
    }

    dlg.dialog({
      modal : true,
      width : 300,
      close : function() {
        dlg.remove();
      },
      buttons : {
        <v:itl key="@Common.Ok" encode="JS"/> : _doSendTestEmail,
        <v:itl key="@Common.Cancel" encode="JS"/> : doCloseDialog
      }
    }).keypress(function(e) {
      if (e.keyCode == KEY_ENTER)
        _doSendTestEmail();
    });
  }

});
</script>
