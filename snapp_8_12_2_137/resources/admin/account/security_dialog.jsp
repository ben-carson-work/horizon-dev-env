<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="java.util.*"%>

<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%String loginUserName = pageBase.getParameter("loginUserName"); %>
<%boolean defaultB2B = JvString.isSameString(pageBase.getParameter("DefaultB2B"), "true"); %>
<%boolean isNew = loginUserName.isEmpty(); %>
<%String sTitle = (isNew) ? "@Account.SecuritySetup" : "@Common.ChangePassword"; %>
<%String passwordRuleInfo = rights.PwdRulesInfo.getHtmlString(); %>

<v:dialog id="security-dialog" width="600" height="520" title="<%=sTitle%>">
  <v:widget caption="@Common.Login">
    <% if (isNew) { %>
    <v:widget-block>
      <v:form-field caption="@Common.UserName">
        <input type="text" class="form-control" name="loginUserName" value=""/>
      </v:form-field>
      <v:form-field caption="@Common.Email">
        <input type="text" class="form-control" name="loginEmail" value=""/>
      </v:form-field>
      <v:form-field caption="@Common.RFID">
        <input type="text" class="form-control" name="loginRfid" value=""/>
      </v:form-field>
      <div id="field-username" class="form-field">
        <div class="form-field-caption"><v:itl key="@Common.Platform"/>
        </div>
        <div class="form-field-value">
          <v:db-checkbox field="account.LoginSNP" caption="SnApp" clazz="mutual-checkbox" checked="<%=!defaultB2B%>" value="true"/>
          <v:db-checkbox field="account.LoginB2B" caption="B2B" clazz="mutual-checkbox" checked="<%=defaultB2B%>" value="true"/>
          <v:db-checkbox field="account.LoginB2C" caption="B2C" value="true"/>
        </div>
      </div>
      <div id="snp-user-section" class="v-hidden">
        <v:form-field caption="@Common.SecurityRole">
        <v:multibox field="accountLogin.RoleIDs" linkEntityType="<%=LkSNEntityType.Role%>" filtersJSON="{\"Role\":{\"RoleType\":0,\"ActiveOnly\":true}}"/>
        </v:form-field>
      </div>
      <div id="b2b-user-section" class="v-hidden">
        <v:form-field caption="@Common.SecurityRole">
          <snp:dyncombo field="B2B_RoleId" entityType="<%=LkSNEntityType.Role%>" allowNull="false" filtersJSON="{\"Role\":{\"RoleType\":1,\"ActiveOnly\":true}}"/>
        </v:form-field>
      </div>
    </v:widget-block>
    <% } else {%>
    <input type="hidden" id="loginUserName" name="loginUserName" value="<%=loginUserName%>">
    <% } %>
    <v:widget-block>
      <% if (!passwordRuleInfo.isEmpty()) { %>
        <v:alert-box type="info" title="@Common.Info"><%=passwordRuleInfo%></v:alert-box>
      <% } %>
      <v:form-field caption="@Common.Password">
        <input type="password" id="password" class="form-control" name="password" value="" autocomplete="new-password">
      </v:form-field>
      <v:form-field caption="@Common.PasswordConfirmation">
        <input type="password" id="passwordConfirm" class="form-control" name="passwordConfirm" value="" autocomplete="new-password">
      </v:form-field>
      <v:form-field>
        <label title="" class="checkbox-label">
          <input type="checkbox" id="forcePasswordChange" class="form-control" name="forcePasswordChange" checked>&nbsp;<v:itl key="@Common.ForcePasswordChange"/>
        </label>
      </v:form-field>
    </v:widget-block>
  </v:widget>
  
<script>

var dlg = $("#security-dialog");
dlg.on("snapp-dialog", function(event, params) {
  params.buttons = [
    dialogButton("@Common.Save", doSaveSecurity),
    dialogButton("@Common.Cancel", doCloseDialog)
  ];
});

dlg.keypress(function() {
  if (event.keyCode == KEY_ENTER)
    doSaveSecurity();
});

dlg.find(".mutual-checkbox").click(function() {
  var cbSNP = $("#account\\.LoginSNP");
  var cbB2B = $("#account\\.LoginB2B");
  if (this == cbSNP[0])
    cbB2B.setChecked(false);
  else
    cbSNP.setChecked(false);
  refreshUI();
});

refreshUI();

function refreshUI() {
  $("#snp-user-section").setClass("v-hidden", !$("#account\\.LoginSNP").isChecked());  
  $("#b2b-user-section").setClass("v-hidden", !$("#account\\.LoginB2B").isChecked());
}

function setUIPlatform(SnApp) {
  if (SnApp) {
    $("#account\\.LoginSNP").attr("checked", "chekced");
    $("#account\\.LoginB2B").removeAttr("checked");
  }
  else {
    $("#account\\.LoginSNP").removeAttr("checked");
    $("#account\\.LoginB2B").attr("checked", "chekced");
  }
  
  refreshUI();
}


function addOperatorRole(roleId, roleCode, roleName, iconName) {
  var tr = $("<tr class='grid-row' data-RoleId='" + roleId + "'/>").appendTo("#roles-grid .grid-items");
  $("<td><input name='RoleId' value='" + roleId + "' type='checkbox' class='cblist'></td>").appendTo(tr);
  $("<td><img class='list-icon' src='<v:config key="site_url"/>/imagecache?name=" + iconName + "&size=32' width='32' height='32'></td>").appendTo(tr);
  var tdName = $("<td width='100%'><a class='list-title'/><br/><span class='list-subtitle'/></td>").appendTo(tr);
  tdName.find(".list-title").text(roleName);
  tdName.find(".list-subtitle").text(roleCode);
}

function doSaveSecurity() {
  userName = $("input[name=loginUserName]").val();
  email = $("input[name=loginEmail]").val();
  pwd = $("#password").val();
  pwdConf = $("#passwordConfirm").val();
  
  if (userName || email) {
    if (pwd) {
      if (pwd === pwdConf) {
        if (<%=isNew%>) {
          var reqLoginDO = {
            Command: "SaveLogin",
            SaveLogin: {
              AccountLogin: {
                AccountId: <%=JvString.jsString(pageBase.getId())%>,
                UserName: $("[name='loginUserName']").val(),
                LoginEmail: $("[name='loginEmail']").val(),
                LoginRfid: $("[name='loginRfid']").val(),
                Password: pwd,
                PasswordConfirm: pwdConf,
                RoleIDs: $("#accountLogin\\.RoleIDs")[0].selectize.getValue(), 
                B2B_RoleId: $("#B2B_RoleId").val(),
                LoginSNP: $("#account\\.LoginSNP").isChecked(),
                LoginB2B: $("#account\\.LoginB2B").isChecked(),
                LoginB2C: $("#account\\.LoginB2C").isChecked(),
                LoginStatus: <%=LkSNLoginStatus.Active.getCode()%>,
                ForcePasswordChange: $("#forcePasswordChange").isChecked()
              }
            }
          };
          
          showWaitGlass();
          vgsService("Account", reqLoginDO, false, function(ansDO) {
            window.location = '<%=pageBase.getContextURL() %>?id=<%=pageBase.getId()%>&page=account&tab=security';
          });
        }
        else {
          var reqPasswordDO = {
            Command: "UpdatePassword",
            UpdatePassword: {
              AccountId: <%=JvString.jsString(pageBase.getId())%>,
              Password: pwd,
              ForcePasswordChange: $("#forcePasswordChange").isChecked()
            }
          };

          showWaitGlass();
          vgsService("Account", reqPasswordDO, false, function(ansDO) {
            hideWaitGlass();
            dlg.dialog("close");
          });
        }
      }
      else {
        $("#passwordConfirm").focus();
        showMessage(<v:itl key="@Common.PasswordMismatch" encode="JS"/>)
      }
    }
    else {
      $("#password").focus();
      showMessage(<v:itl key="@Common.PasswordSpecification" encode="JS"/>)
    }
  }
  else {
    $("#loginUserName").focus();
    showMessage(<v:itl key="@Account.LoginAliasEmptyError" encode="JS"/>)
  }
}

</script>  

</v:dialog>