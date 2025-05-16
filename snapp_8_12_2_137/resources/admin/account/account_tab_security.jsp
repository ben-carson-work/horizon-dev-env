<%@page import="com.vgs.snapp.lookup.LkSNEntityType.EntityTypeItem"%>
<%@page import="com.vgs.snapp.library.FtCRUD"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>
<jsp:useBean id="account" scope="request" class="com.vgs.snapp.dataobject.DOAccount"/>
<jsp:useBean id="accountLogin" scope="request" class="com.vgs.snapp.dataobject.DOAccountLogin"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
FtCRUD securityCRUD = pageBase.getBLDef().getEntityRightCRUD(rights.SecurityEdit, rights, pageBase.getBLDef().findAccountLocationIDs(account.AccountId.getString())); 
if (account.EntityType.isLookup(LkSNEntityType.Person)) 
  securityCRUD = pageBase.getBL(BLBO_Account.class).applyCategoryRestrictions(LkSNEntityType.User, account.AccountId.getString(), securityCRUD);  

boolean canEdit = accountLogin.UserName.isSameString("vgs-support") ? securityCRUD.canUpdate() && rights.VGSSupport.getBoolean() : securityCRUD.canUpdate();  
boolean canEditRights = canEdit && rights.RightsEdit.getBoolean();
boolean canBlock = accountLogin.UserName.isSameString("vgs-support") ? securityCRUD.canUpdate() && (rights.VGSSupport.getBoolean() || rights.SuperUser.getBoolean()) : canEdit;
boolean canEditPassword = accountLogin.UserName.isSameString("vgs-support") ? securityCRUD.canUpdate() && rights.VGSSupport.getBoolean() : canEdit;
String readOnly = (canEdit) ? "" : "readonly=\"readonly\"";
%>
  
<style>
  .form-field-email-verified, 
  .form-field-email-not-verified {
    font-size: 1.6em;
    vertical-align: middle;
    margin-left: 5px;
  }
  
  .form-field-email-verified {
    color: var(--base-green-color);
  }
  
  .form-field-email-not-verified {
    color: var(--base-orange-color);
  }
</style>

<v:page-form trackChanges="true">
  <div class="tab-toolbar">
    <v:button caption="@Common.Save" fa="save" onclick="saveAccount()" enabled="<%=canEdit%>" bindSave="true"/>
    
    <span class="divider"></span>
    
    <div class="btn-group">
      <% if (!accountLogin.LoginStatus.isLookup(LkSNLoginStatus.Active)) { %>
        <v:button caption="@Common.Unblock" fa="user" onclick="activate()" enabled="<%=canBlock%>"/>
      <% } else if (accountLogin.LoginStatus.isLookup(LkSNLoginStatus.Active)) { %>
        <v:button caption="@Common.Block" fa="lock" onclick="block()" enabled="<%=canBlock%>"/>
      <% } %>
      <% if (!accountLogin.UserName.isSameString("vgs-support")) { %>
        <v:button caption="@Common.Remove" fa="trash" onclick="deleteLogin()" title="@Account.SecurityRemoveHint" enabled="<%=securityCRUD.canDelete()%>"/>
      <% } %>
    </div>
  
    <% if (!accountLogin.UserName.isNull()) { %>
      <div class="btn-group">
        <v:button caption="@Common.Password" dropdown="true" fa="star-of-life" enabled="<%=canEditPassword%>"/>
        <v:popup-menu bootstrap="true">
          <% String onclickPassword = "asyncDialogEasy('account/security_dialog', 'id=" + account.AccountId.getString() + "&loginUserName=" + accountLogin.UserName.getString() + "')"; %>
          <v:popup-item caption="@Common.ChangePassword" fa="star-of-life" onclick="<%=onclickPassword%>" enabled="<%=canEditPassword%>"/>
          <% if (rights.ResetPassword.isDefined()) { %>
            <v:popup-item caption="@Common.ResetPassword" fa="star-of-life" onclick="resetPassword()" enabled="<%=canEditPassword%>"/>
          <% } %>
        </v:popup-menu>
      </div>
    <% } %>
    
    <span class="divider"></span>
    
    <v:button caption="@Common.Rights" fa="key" onclick="showRights()" enabled="<%=canEditRights%>"/>
  </div>
  
  <div class="tab-content">
    <v:last-error/>
    <%-- USER --%>
    <v:widget caption="@Account.User">
      <v:widget-block>
        <v:form-field caption="@Common.UserName" id="field-username">
          <v:input-text field="accountLogin.UserName" enabled="<%=canEdit%>"/>
        </v:form-field>
        <div id="field-username" class="form-field">
          <div class="form-field-caption"><v:itl key="@Common.Email"/>
            <% if (!accountLogin.LoginEmail.isNull()) { %>
              <% if (accountLogin.LoginEmailVerifyDate.isNull()) { %>
                <span title="<v:itl key="@Account.LoginEmailAwaitingVerification"/>" class="form-field-email-not-verified fa fa-exclamation-circle"></span>
              <% } else { %>
                <span title="<v:itl key="@Account.LoginVerifiedOn" param1="<%=pageBase.format(accountLogin.LoginEmailVerifyDate, pageBase.getShortDateTimeFormat())%>"/>" class="form-field-email-verified fa fa-check-circle"></span>
              <% } %>
            <% } %>
          </div>
          <div class="form-field-value">
            <div class="input-group">          
              <v:input-text field="accountLogin.LoginEmail" enabled="<%=canEdit%>"/>
              <span class="input-group-btn">
                <v:button caption="@Login.ResendEmail" fa="envelope" onclick="resendEmail()" enabled="<%=canEdit && !accountLogin.LoginEmail.isNull() && accountLogin.LoginEmailVerifyDate.isNull()%>"/>
              </span>
            </div>
          </div>
        </div>
        <v:form-field caption="@Login.ExternalUserNames" hint="@Login.ExternalUserNamesHint">
          <v:input-text field="accountLogin.LoginExternals" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.RFID" id="field-username">
          <v:input-text field="accountLogin.LoginRfid" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.Status">
          <input type="text" id="accountLogin.LoginStatus" name="accountLogin.LoginStatus" class="form-control" readonly="readonly" value="<%=accountLogin.LoginStatus.getLkValue().getHtmlDescription(pageBase.getLang())%>"/> 
        </v:form-field>
      </v:widget-block>
      <v:widget-block>
        <v:form-field caption="@Common.Platform">
          <v:db-checkbox field="accountLogin.LoginSNP" caption="SnApp" onclick="javascript:setUIPlatform(true)" value="true" enabled="<%=canEditRights%>"/>
          <v:db-checkbox field="accountLogin.LoginB2B" caption="B2B" onclick="javascript:setUIPlatform(false)" value="true" enabled="<%=canEditRights%>"/>
          <v:db-checkbox field="accountLogin.LoginB2C" caption="B2C" value="true" enabled="<%=canEditRights%>"/>
        </v:form-field>
        <%-- OPERATOR ROLES --%>
        <div class="snp-user-section v-hidden">
          <v:form-field caption="@Common.SecurityRole">
            <v:multibox field="accountLogin.RoleIDs" linkEntityType="<%=LkSNEntityType.Role%>" filtersJSON="{\"Role\":{\"RoleType\":0,\"ActiveOnly\":true}}" enabled="<%=canEditRights%>"/>
          </v:form-field>
        </div>
        <%-- B2B AGENT ROLE --%>
        <div class="b2b-user-section v-hidden">
          <v:form-field caption="@Common.SecurityRole">
            <snp:dyncombo field="accountLogin.B2B_RoleId" entityType="<%=LkSNEntityType.Role%>"  filtersJSON="{\"Role\":{\"RoleType\":1,\"ActiveOnly\":true}}" allowNull="false" enabled="<%=canEditRights%>"/>
          </v:form-field>
        </div>
      </v:widget-block>
      <v:widget-block>
        <v:form-field caption="@Account.LastLogin">
          <% if (!accountLogin.LastLoginDateTime.isNull()) { %>
  	        <a href="javascript:asyncDialogEasy('account/useractivity_dialog', 'id=<%=pageBase.getId()%>')">
  	          <strong><%=pageBase.format(accountLogin.LastLoginDateTime, pageBase.getLongDateTimeFormat())%></strong>
  	        </a>
          <% } else { %>
            <strong><v:itl key="@Account.NeverLoggedIn"/></strong>
          <% } %>
        </v:form-field>
        <v:form-field caption="@Account.PasswordChangeDate">
          <strong><%=pageBase.format(accountLogin.PasswordChangeDate, pageBase.getShortDateFormat())%></strong>
        </v:form-field>
      </v:widget-block>
    </v:widget>
  
    <div class="snp-user-section v-hidden">
      <%-- SESSION POOLS --%>
      <v:widget caption="@Common.SessionPools">
        <v:widget-block id="role-operator-block">
          <v:form-field caption="@Account.BKO_SessionPool">
            <v:combobox field="accountLogin.BKO_SessionPoolId" idFieldName="SessionPoolId" captionFieldName="SessionPoolName" lookupDataSet="<%=pageBase.getBL(BLBO_Session.class).getSessionPoolDS(LkSNWorkstationType.BKO)%>" enabled="<%=securityCRUD.canUpdate()%>"/>
          </v:form-field>
          <v:form-field caption="@Account.B2B_SessionPool">
            <v:combobox field="accountLogin.B2B_SessionPoolId" idFieldName="SessionPoolId" captionFieldName="SessionPoolName" lookupDataSet="<%=pageBase.getBL(BLBO_Session.class).getSessionPoolDS(LkSNWorkstationType.B2B)%>" enabled="<%=securityCRUD.canUpdate()%>"/>
          </v:form-field>
        </v:widget-block>
      </v:widget>
    </div>
  </div>
</v:page-form>

<script>

refreshUI();

function refreshUI() {
  $(".snp-user-section").setClass("v-hidden", !$("#accountLogin\\.LoginSNP").isChecked());  
  $(".b2b-user-section").setClass("v-hidden", !$("#accountLogin\\.LoginB2B").isChecked());
}

function setUIPlatform(SnApp) {
  $("#accountLogin\\.LoginSNP").setChecked(SnApp);
  $("#accountLogin\\.LoginB2B").setChecked(!SnApp);
  refreshUI();
}

function showRights() {
  if ($("#accountLogin\\.LoginB2B").isChecked()) 
    asyncDialogEasy("right/rights_dialog", "Filter=rightB2B&EntityType=<%=account.EntityType.getInt()%>&EntityId=<%=pageBase.getId()%>");
  else  
    asyncDialogEasy("right/rights_dialog", "Filter=right&EntityType=<%=account.EntityType.getInt()%>&EntityId=<%=pageBase.getId()%>");
}

function saveAccount() {
  var reqDO = {
    Command: "SaveAccount",
    SaveAccount: {
      AccountId : <%=account.AccountId.getJsString()%>,
      EntityType: <%=account.EntityType.getJsString()%>,
      AccountLogin: {
        AccountId        : <%=account.AccountId.getJsString()%>,
        UserName         : $("#accountLogin\\.UserName").val(),
        LoginExternals   : $("#accountLogin\\.LoginExternals").val(),
        LoginEmail       : $("#accountLogin\\.LoginEmail").val(),
        LoginRfid        : $("#accountLogin\\.LoginRfid").val(),
        BKO_SessionPoolId: $("#accountLogin\\.BKO_SessionPoolId").val(),
        B2B_SessionPoolId: $("#accountLogin\\.B2B_SessionPoolId").val(),
        RoleIDs          : $("#accountLogin\\.RoleIDs")[0].selectize.getValue(),
        B2B_RoleId       : $("#accountLogin\\.B2B_RoleId").val(),
        LoginSNP         : $("#accountLogin\\.LoginSNP").isChecked(),
        LoginB2B         : $("#accountLogin\\.LoginB2B").isChecked(),
        LoginB2C         : $("#accountLogin\\.LoginB2C").isChecked(),
        LoginStatus      : <%=accountLogin.LoginStatus.getInteger()%>,
        ForcePasswordChange: false
      }
    }
  };
  
  showWaitGlass();
  vgsService("Account", reqDO, false, function(ansDO) {
    hideWaitGlass();
    if (ansDO.Answer.SaveAccount.AccountLogin.UnableToSendEmailWarning) {
      showMessage(itl("@Login.SendEmailError"), function() {
        entitySaveNotification(<%=LkSNEntityType.Person.getCode()%>, reqDO.SaveAccount.AccountLogin.AccountId, "tab=security");
      });
    }
    else {
      if (emailAddressChanged && $("#accountLogin\\.LoginEmail").val())
        showMessage(itl("@Login.SendEmailOk"), function() {
          entitySaveNotification(<%=LkSNEntityType.Person.getCode()%>, reqDO.SaveAccount.AccountLogin.AccountId, "tab=security");
        });
      else
        entitySaveNotification(<%=LkSNEntityType.Person.getCode()%>, reqDO.SaveAccount.AccountLogin.AccountId, "tab=security");
    }
  });
}

function deleteLogin() {
  confirmDialog(null, function() {
    var reqDO = {
      Command: "DeleteLogin",
      DeleteLogin: {
        AccountId: <%=JvString.jsString(pageBase.getId())%>
      }
    };
    
    showWaitGlass();
    vgsService("Account", reqDO, false, function(ansDO) {
      hideWaitGlass();
      window.location = "<%=pageBase.getContextURL()%>?page=account&id=" + <%=JvString.jsString(pageBase.getId())%>;
    });
  });
}

function activate() {
  changeLoginStatus(<%=LkSNLoginStatus.Active.getCode()%>);
}

function block() {
  changeLoginStatus(<%=LkSNLoginStatus.Blocked.getCode()%>);
}

function changeLoginStatus(loginStatus) {
  confirmDialog(null, function() {
    var reqDO = {
      LocateAccount: {AccountId: <%=JvString.jsString(pageBase.getId())%>},
      LoginStatus: loginStatus
    };
    
    showWaitGlass();
    snpAPI.cmd("Account", "ChangeLoginStatus", reqDO).then(()=> {
      hideWaitGlass();
      window.location = "<%=pageBase.getContextURL()%>?tab=security&page=account&id=" + <%=JvString.jsString(pageBase.getId())%>;
    });
  });
}

function resendEmail() {
  confirmDialog(itl("@Login.ResendEmailQuestion", <%=accountLogin.LoginEmail.getJsString()%>), function() {
    var reqDO = {
      Command: "SendVerificationEmail",
      SendVerificationEmail: {
        AccountId: <%=JvString.jsString(pageBase.getId())%>
      }
    }
    
    showWaitGlass();
    vgsService("Login", reqDO, false, function(ansDO) {
      hideWaitGlass();
      showMessage(itl("@Common.SaveSuccessMsg"), function() {
        window.location.reload();
      }); 
    });
  });
}

function resetPassword() {
  confirmDialog(null, function() {
    var reqDO = {
      Command: "ResetPassword",
      ResetPassword: {
        AccountId: <%=JvString.jsString(pageBase.getId())%>,
      }
    };
    
    showWaitGlass();
    vgsService("Account", reqDO, false, function(ansDO) {
      hideWaitGlass();
      showMessage(itl("@Common.ResetPasswordSuccessMsg"), function() {
        window.location.reload();
      }); 
    });
  });
}

$(document).ready(function(){
  emailAddressChanged = false;
  
  $("#accountLogin\\.LoginEmail").change(function(){
    emailAddressChanged = true;
  });
  
});
</script>
