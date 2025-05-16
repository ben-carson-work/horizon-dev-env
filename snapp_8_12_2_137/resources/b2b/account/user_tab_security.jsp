<%@page import="com.vgs.vcl.JvImageCache"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" scope="request" class="com.vgs.snapp.web.b2b.page.PageB2B_User"/>
<jsp:useBean id="account" scope="request" class="com.vgs.snapp.dataobject.DOAccount"/>
<jsp:useBean id="accountLogin" scope="request" class="com.vgs.snapp.dataobject.DOAccountLogin"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
boolean selfAccount = JvString.isSameString(account.AccountId.getString(), pageBase.getSession().getUserAccountId());
boolean canEditPersonalData = selfAccount && pageBase.getRights().B2BAgent_EditPersonalData.getBoolean();  
boolean canEdit = canEditPersonalData || pageBase.getRights().B2BAgent_ManageUsers.getBoolean();
boolean canEditSecurity = pageBase.getRights().B2BAgent_ManageUsers.getBoolean();

String emailCaption = pageBase.getLang().Common.Email.getText();
String emailIconName = null;
if (!accountLogin.LoginEmail.isNull()) {
  if (accountLogin.LoginEmailVerifyDate.isNull()) {
    emailCaption += " " + pageBase.getLang().Account.LoginEmailAwaitingVerification.getText();
    emailIconName = JvImageCache.ICON_WARNING;
  }
  else {
    emailCaption += " " + pageBase.getLang().Account.LoginVerifiedOn.getText(pageBase.format(accountLogin.LoginEmailVerifyDate, pageBase.getShortDateTimeFormat()));
    emailIconName = JvImageCache.ICON_SUCCESS;
  }
}
%>

<v:tab-toolbar>
  <v:button id="btn-security-save" caption="@Common.Save" fa="save" onclick="doSaveLogin()" include="<%=canEdit%>"/>
  <v:button id="btn-security-pwd" caption="@Common.ChangePassword" fa="star-of-life" enabled="<%=canEdit || selfAccount%>"/>
  <v:button id="btn-security-email" caption="@Login.ResendEmail" fa="envelope" enabled="<%=canEdit%>" include="<%=accountLogin.LoginEmailVerifyDate.isNull()%>"/>
</v:tab-toolbar>

<v:tab-content>
  <v:widget caption="@Common.Login">
    <v:widget-block>
      <v:form-field caption="@Common.UserName">
        <v:input-text field="accountLogin.UserName" enabled="<%=canEdit%>"  autocomplete="new-password"/>
      </v:form-field>
      <v:form-field caption="<%=emailCaption%>" iconName="<%=emailIconName%>">
          <v:input-text field="accountLogin.LoginEmail" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Common.SecurityRole">
        <snp:dyncombo field="accountLogin.B2B_RoleId" entityType="<%=LkSNEntityType.Role%>" filtersJSON="{\"Role\":{\"RoleType\":1}}" allowNull="false" showLinkButton="false" enabled="<%=canEditSecurity%>"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:db-checkbox field="cbActive" caption="@Common.Active" checked="<%=accountLogin.LoginStatus.isLookup(LkSNLoginStatus.Active)%>" value="true" enabled="<%=canEditSecurity%>"/>
    </v:widget-block>
  </v:widget>
</v:tab-content>

<script>
$(document).ready(function() {
  $("#btn-security-save").click(_save);
  $("#btn-security-pwd").click(_changePassword);
  $("#btn-security-email").click(_resendEmail);

  function _save() {
    snpAPI
      .cmd("Account", "SaveAccount", {
        AccountId: <%=account.AccountId.getJsString()%>,
        AccountLogin: {
          UserName: $("#accountLogin\\.UserName").val(),
          LoginEmail: $("#accountLogin\\.LoginEmail").val(),
          B2B_RoleId: $("#accountLogin\\.B2B_RoleId").val(),
          LoginStatus: $("#cbActive").isChecked() ? <%=LkSNLoginStatus.Active.getCode()%> : <%=LkSNLoginStatus.Blocked.getCode()%>
        }
      })
      .then(ansDO => window.location.reload());
  }

  function _changePassword() {
    asyncDialogEasy("account/changeotherpassword_dialog", "id=" + <%=account.AccountId.getJsString()%> + "&loginUserName=" + <%=accountLogin.UserName.getJsString()%>); 
  }

  function _resendEmail() {
    confirmDialog(itl("@Login.ResendEmailQuestion", <%=accountLogin.LoginEmail.getJsString()%>), function() {
      snpAPI
        .cmd("Login", "SendVerificationEmail", {
          AccountId:<%=account.AccountId.getJsString()%>
        })
        .then(function() {
          showMessage(itl("@Common.SaveSuccessMsg"), function() {
            window.location.reload();
          }); 
        });
    });
  }
});
</script>

<%-- 
<script>

function doSaveLogin() {
  var hasLogin = <%=!accountLogin.UserName.isNull() || !accountLogin.LoginEmail.isNull()%>;
  var userName = $('input[name=loginUserName]').val();
  var email = $('input[name=loginEmail]').val();
  var pwd = $("#password").val();
  var pwdConf = $("#passwordConfirm").val();
  var proceed = true;
  
  if (proceed && !hasLogin) {
    if (pwd) {
      if (pwd != pwdConf) {
        proceed = false;
        $("#passwordConfirm").focus();
        showMessage(itl("@Common.PasswordMismatch"));
      }
    }
    else {
      proceed = false;
      $("#password").focus();
      showMessage(itl("@Common.PasswordSpecification"));
    }
  }
  
  if (proceed) {
    var reqDO = {
      Command: "SaveLogin",
      SaveLogin: {
        AccountLogin: {
          AccountId: <%=account.AccountId.getJsString()%>,
          UserName: $("#accountLogin\\.UserName").val(),
          LoginEmail: $("#accountLogin\\.LoginEmail").val(),
          Password: hasLogin ? null : pwd, 
          PasswordConfirm: hasLogin ? null : pwdConf,
          B2B_RoleId: $("#accountLogin\\.B2B_RoleId").val(),
          LoginSNP: false,
          LoginB2B: $("#accountLogin\\.LoginB2B").isChecked() || !hasLogin,
          LoginB2C: <%=accountLogin.LoginB2C.getBoolean()%>,
          LoginStatus: <%=LkSNLoginStatus.Active.getCode()%>,
          ForcePasswordChange: (!hasLogin && $("#forcePasswordChange").isChecked())
        }
      }
    };
  
    vgsService("Account", reqDO, false, function(ansDO) {
      showMessage(itl("@Common.SaveSuccessMsg"), function() {
        window.location.reload();
      }); 
    });
  }
}

function unblock() {
  confirmDialog(null, function() {
    var reqDO = {
      LocateAccount: {AccountId: <%=JvString.jsString(pageBase.getId())%>},
      LoginStatus: <%=LkSNLoginStatus.Active.getCode()%>
    };
    
    showWaitGlass();
    snpAPI.cmd("Account", "ChangeLoginStatus", reqDO).then(()=> {
      hideWaitGlass();
      window.location = "<%=pageBase.getContextURL()%>?tab=security&page=user&id=" + <%=JvString.jsString(pageBase.getId())%>;
    });
  });
}

</script>
--%>
