<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:include page="/resources/common/header.jsp"/>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<v:page-title-box/>

<% 
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 
String[] roleCodes = pageBase.getBL(BLBO_Account.class).getRoleCodes(pageBase.getSession().getUserAccountId());
boolean canHandleVersion = JvArray.contains("STORE_VER", roleCodes) || rights.SuperUser.getBoolean();
boolean canHandlePassword = JvArray.contains("STORE_PWD", roleCodes) || rights.SuperUser.getBoolean();
%>

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="Tools" default="true">
    <div class="tab-content">
      <div class="storetool" id="tool-version">
        <div class="storetool-icon"><i class="fa fa-ship"></i></div>
        <div class="storetool-title">Create Jira version</div>
      </div>
    
      <div class="storetool" id="tool-freeze">
        <div class="storetool-icon"><i class="fa fa-code"></i></div>
        <div class="storetool-title">Code freeze generation</div>
      </div>
    
      <div class="storetool" id="tool-password">
        <div class="storetool-icon"><i class="fa fa-key"></i></div>
        <div class="storetool-title">"vgs-support" password</div>
      </div>
    
      <div class="storetool" id="tool-pkgwiz">
        <div class="storetool-icon"><i class="fa fa-box-circle-check"></i></div>
        <div class="storetool-title">Create package</div>
      </div>
    </div>
  </v:tab-item-embedded>
</v:tab-group>
    
    
<style>
.storetool {
  float: left;
  width: 220px;
  background-color: var(--base-gray-color);
  border-radius: 4px;
  padding: 10px;
  text-align: center;
  font-size: 1.2em;
  font-weight: bold;
  margin-right: 10px;
  margin-bottom: 10px;
}
.storetool:not(.disabled) {
  cursor: pointer;
}
.storetool:not(.disabled):hover {
  background-color: var(--highlight-color);
}
.storetool.disabled {
  opacity: 0.4;
}
.storetool-icon {
  font-size: 2em;
  margin: 10px;
}
.storetool-title {
  margin-top: 10px;
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
}
</style>


<script>
$(document).ready(function() {
  var $toolVersion = $("#tool-version")
  var $toolFreeze = $("#tool-freeze");
  var $toolPassword = $("#tool-password");
  var $toolPkgWiz = $("#tool-pkgwiz");
  
  if (<%=canHandleVersion%>) {
    $toolVersion.click(_toolVersionClick);
    $toolFreeze.click(_toolFreezeClick);
    $toolPkgWiz.click(_toolPkgWizClick);
  }
  else {
    $toolVersion.addClass("disabled");
    $toolFreeze.addClass("disabled");
    $toolPkgWiz.addClass("disabled");
  }

  if (<%=canHandlePassword%>) 
    $toolPassword.click(_toolPasswordClick);
  else
    $toolPassword.addClass("disabled");
  
  
  function _toolVersionClick() {
    asyncDialogEasy('../../plugins/pkg-vgs-store/version_builder_create_dialog');
  }
  
  function _toolFreezeClick() {
    asyncDialogEasy('../../plugins/pkg-vgs-store/code_freeze_generation_dialog');
  }
  
  function _toolPasswordClick() {
    asyncDialogEasy('../../plugins/pkg-vgs-store/vgssupport_password_dialog');
  }
  
  function _toolPkgWizClick() {
    asyncDialogEasy('../../plugins/pkg-vgs-store/pkgwiz_dialog');
  }
});
</script>


<jsp:include page="/resources/common/footer.jsp"/>