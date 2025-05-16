<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>
<%@page import="com.vgs.snapp.mongodb.plugin.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>

<v:widget id="archiver-mongo-settings" caption="Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
    <v:form-field caption="Connection string">
      <v:input-text field="MongoDBConnectionString" placeholder="mongodb://localhost:27017"/>
    </v:form-field>
    <v:form-field caption="Database name">
      <v:input-text field="DBName" placeholder="archive"/>
    </v:form-field>    
    <v:form-field caption="User name">
      <v:input-text field="UserName" placeholder=""/>
    </v:form-field>    
    <v:form-field caption="Password">
      <v:input-text field="Password" placeholder="" type="password"/>
    </v:form-field>       
  </v:widget-block>
</v:widget>
<script>

$(document).ready(function() {
  const TEST_BUTTON_ID = 'snp-test-mongo-button';
  $(document).on("snapp-dialog", _addTestButton);
  
  let CONNECTION_TEST_NAME = 'connection';  
  var $cfg = $("#archiver-mongo-settings");
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#MongoDBConnectionString").val(params.settings.MongoDBConnectionString);
    $cfg.find("#DBName").val(params.settings.DBName);    
    $cfg.find("#UserName").val(params.settings.UserName);
    $cfg.find("#Password").val(params.settings.Password);
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = _getSettings();
  });
  
  function _addTestButton(event, params) {
    let dlgBtn = dialogButton("Test", _onPerformTest, TEST_BUTTON_ID);
    params.buttons.unshift(dlgBtn);
    $(document).off("snapp-dialog", _addTestButton)    
  }
  
  function _getSettings() {
    return {
      MongoDBConnectionString : $cfg.find("#MongoDBConnectionString").val(),
      DBName : $cfg.find("#DBName").val(),        
      UserName : $cfg.find("#UserName").val(),
      Password : $cfg.find("#Password").val()
    };
  }
  
  function _onPerformTest() {
    var reqDO = {
        Command: "PerformTestOnPlugin",
        PerformTestOnPlugin: {
          PluginId: <%=JvString.jsString(plugin.PluginId.getString())%>,
          TestName: CONNECTION_TEST_NAME,
          PluginConfigData: JSON.stringify(_getSettings())
        }
      };
    
    showWaitGlass();
    vgsService("SERVICE", reqDO, false, function(ansDO) {
      hideWaitGlass();
      let message;
      if (ansDO.Answer.PerformTestOnPlugin.TestPassed == true)
        message = 'Test passed';
      else
        message = ansDO.Answer.PerformTestOnPlugin.ErrorMessage
        
      showMessage(message);
    });
  }
});

</script>
