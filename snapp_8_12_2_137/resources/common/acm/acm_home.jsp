<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.web.gencache.*"%>
<%@page import="com.vgs.snapp.web.plugin.*"%>
<%@page import="com.vgs.snapp.web.acm.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.jwt.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="java.net.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="rights" scope="request" class="com.vgs.snapp.dataobject.DORightRoot"/>
<!DOCTYPE html>
<html>
<%
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 
BOSessionBean boSession = (pageBase == null) ? null : (BOSessionBean)pageBase.getSession();

DORightRoot cleanRights = new DORightRoot();
cleanRights.assign(rights);
BLBO_Right.clearSensitiveInformation(cleanRights);

List<AcmViewBean> listView = new ArrayList<>();
listView.add(new AcmViewBean("acm-home", false, true, true));
listView.add(new AcmViewBean("acm-view-apt-main", true, true, true));
listView.add(new AcmViewBean("acm-view-apt-info", true, true, true));
listView.add(new AcmViewBean("acm-view-apt-manualinput", true, true, true));
listView.add(new AcmViewBean("acm-view-apt-specialproduct", true, true, true));
listView.add(new AcmViewBean("acm-view-apt-settings", true, true, true));
listView.add(new AcmViewBean("acm-view-apt-closed", true, true, true));
listView.add(new AcmViewBean("acm-view-apt-exit", true, true, true));
listView.add(new AcmViewBean("acm-view-apt-free", true, true, true));

List<PlgDocReaderWebBase> listDocReader = SrvBO_Cache_SystemPlugin.instance().findPluginInstanceOf(PlgDocReaderWebBase.class);
%>
<jsp:include page="../header-head.jsp"/>

<style>
<%
for (AcmViewBean bean : listView) {
  if (bean.css) {
    String fileName = bean.filePrefix + ".css";
    %><jsp:include page="<%=fileName%>" flush="true"/><%
  }
}
%>

.capslock-icon {
    position: absolute;
    font-size: 30px;
    top: 108px;
    right: 24px;
    color: var(--base-orange-color);
    visibility: hidden;
}

.login-field.capslock .capslock-icon {
    visibility: visible;
}
    
</style>

<script>
  var monitorWorkstationId = <%=JvString.jsString(pageBase.getId())%>;
  var rights = <%=cleanRights.getJSONString()%>;
  var rightsBackup = rights;
  var hasDocReader = <%=!listDocReader.isEmpty()%>;
  var supAccountId = null;
  
  function resetSupervisor() {
	  $("#acm-menu .menu-item-supervisor").setClass("selected", false);
	  supAccountId = null;
	  rights = rightsBackup;
	}
  
  function detectCapsLock(e) {
	    $("#Password").parent().setClass("capslock", e.getModifierState('CapsLock'));
	  }
  
  window.addEventListener('keydown', detectCapsLock);
  window.addEventListener('keyup', detectCapsLock);
  window.addEventListener('click', detectCapsLock);

</script>

<%
for (AcmViewBean bean : listView) {
  if (bean.js) {
    String fileName = bean.filePrefix + ".js";
    %>
<script>//# sourceURL=<%=fileName%>
  <jsp:include page="<%=fileName%>" flush="true"/>
</script>
    <%
  }
}
%>


<body class="loading noselect">
  <div id="spinner-container" class="spinner-block"><i class="fas fa-circle-notch fa-spin"></i></div>

  <div id="acm-menu">
    <div class="menu-item menu-item-add" data-iconalias="plus"></div>
    <div class="menu-item menu-item-remove" data-iconalias="minus"></div>
    <div class="menu-item menu-item-select-all" data-iconalias="check-double"></div>
    <div class="menu-item menu-item-supervisor" data-iconalias="user-tie"></div>
    <div class="menu-item menu-item-logout" data-iconalias="door-open"></div>
  </div>
  <div id="apt-list"></div>
  
  
  
  <div id="acm-templates" class="templates">
  
    <!-- SIMPLE TEMPLATES -->
    <div class="acm-template-simple">
      <div class="spinner-block"><i class="fas fa-circle-notch fa-spin"></i></div>
      
      <div class="menu-item">
        <i class="menu-item-icon fa"></i>
        <div class="acm-iconvert"></div>
      </div>
    
      <div class="apt-line-function">
        <div class="apt-line-icon"><i class="fa"></i></div>
        <div class="apt-line-content"></div>
      </div>
      
      <div class="dlg-option-item">
        <div class="dlg-option-item-icon"><i class="fa"></i></div>
        <div class="dlg-option-item-content">
          <span class="dlg-option-item-title"></span>
        </div>
      </div>
    </div>
  
    <!-- COMPLEX TEMPLATES -->
    <div class="acm-template-complex">
      <div class="apt">
        <div class="apt-header">
          <div class="apt-header-selected"><i class="fa fa-check"></i></div>
          <span class="apt-header-title"></span> 
          <div class="apt-header-rot">
            <div class="apt-rot apt-rot-exit" title="<v:itl key="@Common.Exits"/>">
              <i class="apt-rot-icon fa fa-arrow-alt-down"></i>
              <span class="apt-rot-value" data-bind="status.TotalExits" data-nullvalue="0"></span>
            </div>
            <div class="apt-rot apt-rot-entry" title="<v:itl key="@Common.Entries"/>">
              <i class="apt-rot-icon fa fa-arrow-alt-up"></i>
              <span class="apt-rot-value" data-bind="status.TotalEntries" data-nullvalue="0"></span>
            </div>
          </div>
        </div>
        <div class="apt-body">
          <div class="apt-status-offline"><v:itl key="@Common.OffLine" transform="uppercase"/></div>
          <div class="apt-status-online">
            <%
            for (AcmViewBean bean : listView) {
              if (bean.html) {
                String fileName = bean.filePrefix + ".htm";
                %><jsp:include page="<%=fileName%>" flush="true"/><%
              }
            }
            %>
          </div>
        </div>
      </div>
      
      <div id="dlg-apt-changestatus">
        <v:widget caption="@AccessPoint.Control">
          <v:widget-block>
            <div>
              <v:itl key="@AccessPoint.EntryControl"/><br/>
              <v:lk-combobox field="EntryControl" lookup="<%=LkSN.AccessPointControl%>" allowNull="true"/>
            </div>
            <div>
              <v:itl key="@AccessPoint.ReentryControl"/><br/>
              <v:lk-combobox field="ReentryControl" lookup="<%=LkSN.AccessPointReentryControl%>" allowNull="true"/>
            </div>
            <div>
              <v:itl key="@AccessPoint.ExitControl"/><br/>
              <v:lk-combobox field="ExitControl" lookup="<%=LkSN.AccessPointControl%>" allowNull="true"/>
            </div>
          </v:widget-block>
        </v:widget>
        <v:widget caption="@Biometric.Biometric">
          <v:widget-block>
            <div>
              <v:itl key="@Right.BiometricCheckLevel"/><br/>
              <v:lk-combobox field="BiometricCheckLevel" lookup="<%=LkSN.BiometricCheckLevel%>" allowNull="true"/>
            </div>
            <div>
              <v:itl key="@Right.BiometricRedemptionTrigger"/><br/>
              <v:lk-combobox field="BiometricRedemptionTrigger" lookup="<%=LkSN.BiometricRedemptionTrigger%>" allowNull="true"/>
            </div>
          </v:widget-block>
        </v:widget>
      </div>
      
      <div id="dlg-apt-supervisor">
        <v:widget>
          <v:widget-block>
            <div>
              <v:itl key="User name"/><br/>
              <v:input-text field="Username"/>
            </div>
            <div class="login-field">
              <v:itl key="Password"/><br/>
              <v:input-text field="Password" type="password"/>
              <i class="capslock-icon fa fa-arrow-alt-square-up"></i>
            </div>
          </v:widget-block>
        </v:widget>
      </div>
    </div>
    
  </div>
</body>

</html>
