<%@page import="com.vgs.web.library.BLBO_DBInfo"%>
<%@page import="com.vgs.web.library.VgsWebInit"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageInstall" scope="request"/>

<!DOCTYPE html>
<html>
<head>
  <title>SnApp Database Setup</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <link rel="shortcut icon" href="<v:config key="resources_url"/>/admin/images/favicon.ico"/>
  <link type="text/css" href="<v:config key="site_url"/>/libraries/jquery-ui-1.14.1/jquery-ui.min.css" rel="stylesheet" />
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery/jquery-3.6.0.min.js"></script>
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery-ui-1.14.1/jquery-ui.min.js"></script>
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/commonmark-0.29/commonmark.min.js"></script>
  
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/bootstrap_3.4.1/css/bootstrap.min.css">
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/bootstrap_3.4.1/css/bootstrap-theme.min.css">
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/font-awesome-6.4.2/css/fontawesome.min.css"> 
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/font-awesome-6.4.2/css/solid.min.css"> 
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/font-awesome-6.4.2/css/brands.min.css"> 

  <link type="text/css" href="<v:config key="site_url"/>/admin?page=admin-css" rel="stylesheet" media="all" />
  <script type="text/javascript" src="<v:config key="site_url"/>/admin?page=admin-js"></script>
  

    <style type="text/css">
      .form-field {
        margin:4px auto;
      }
      .form-field-caption {
        width: 200px;
      }
      .form-field-value {
        margin-left: 203px;
      }
      #db-install-widget {
        width: 700px;
        margin: 100px auto;
      }
      .margin-10 {
        margin:10px;
      }
      .float-right {
        float:right;
      }
      #progressbar-ext {
       height: 6px;
       background-color:#CECECE;
      }
      #progressbar-int {
        float:left; 
        background-color:#30B513; 
        height: 6px;
      }
      .step-container {
        min-height:240px;
      }
    </style>
  <% boolean databaseEmpty = BLBO_DBInfo.isDatabaseEmpty(); %>
  <% if(databaseEmpty) { %>
    <script type="text/javascript">
      vgsSession = <%=JvString.jsString(pageBase.getSession().getSessionId())%>;
      var installTimer;
      
      function doInstall() {
        if($("#CacheDirectory").val()==""){
          showMessage("Please define a cache folder location.");
          return false;
        }
        installTimer = 0;
        
        var reqDO = {
        Command: "InitDatabase",
          InitDatabase: {
            LicenseId: parseInt($("#LicenseId").val()),
            ISOCode: $("#ISOCode").val(),
            CurrencyName: $("#CurrencyName").val(),
            Symbol: $("#Symbol").val(),
            CurrencyFormat: $("#CurrencyFormat").val(),
            RoundDecimals: $("#RoundDecimals").val(),
            TimeZone: $("#TimeZone").val(),
            FiscalDateSwitchHour: $("#FiscalDateSwitchHour").val(),
            VGSSupportPassword: $("#VGSSupportPassword").val(),
            AdminPassword: $("#AdminPassword").val(),
            CacheDirectory: $("#CacheDirectory").val(),
            SendDebugNotifications: $("#SendDebugNotifications").isChecked(),
            SetReadCommitted: $("#SetReadCommitted").isChecked()
          }
        };
        
        updateStatus();
        $("#data-input").addClass("v-hidden");
        $("#wait-spinner").removeClass("v-hidden");
        
        vgsService("InitDatabase", reqDO, false, function(ansDO) {
          $("#wait-spinner").addClass("v-hidden");
          $("#success-box").removeClass("v-hidden");
        });
      }
  
      //check numbers as they are typed (event-based) 
      function numbersOnly(e) {
         e = (e) ? e : window.event;
         var charCode = (e.which) ? e.which : e.keyCode;
         if (charCode > 31 && (charCode < 48 || charCode > 57)) {
             return false;
         }
         return true;
      }
      
      function textOnly(e){
        var code;
        if (!e) var e = window.event;
        if (e.keyCode) code = e.keyCode;
        else if (e.which) code = e.which;
        var character = String.fromCharCode(code);
           var AllowRegex  = /^[\ba-zA-Z\s-]$/;
           if (AllowRegex.test(character)) return true;     
           return false; 
      }
      
      function toStep1() {
         $("#install-step1").removeClass("v-hidden");
         $("#install-step2").addClass("v-hidden");
      }
      
      function toStep2() {
        if($("#LicenseId").val() && $("#ISOCode").val()!="" && $("#CurrencyName").val()!="" && $("#Symbol").val()!="" && $("#RoundDecimals").val()!=""){
          if(!($("#RoundDecimals").val()==0 || $("#RoundDecimals").val()==1 || $("#RoundDecimals").val()==2 || $("#RoundDecimals").val()==3 || $("#RoundDecimals").val()==4)){
            showMessage("Round decimals could be 0 to 4. Please change the value you entered.");  
            return false;
           }
          $("#install-step1").addClass("v-hidden");
           $("#install-step2").removeClass("v-hidden");
           $("#install-step3").addClass("v-hidden");
        } else {
          showMessage("Please fill all required fields.");
        }
      }
      
      function toStep3() {
        if($("#AdminPassword").val()!="" && $("#AdminPassword2").val()!="" && $("#VGSSupportPassword").val()!="" && $("#VGSSupportPassword2").val()!=""){
          if($("#AdminPassword").val()!=$("#AdminPassword2").val()){
            showMessage("Admin passwords does not match.");
            return false;
          }
          if($("#VGSSupportPassword").val()!=$("#VGSSupportPassword2").val()){
            showMessage("VGS Support passwords does not match.");
            return false;
          }
          $("#install-step2").addClass("v-hidden");
          $("#install-step3").removeClass("v-hidden");
        } else {
          showMessage("Please fill all required fields.");
        }
      }
      
      function FormatNumberLength(num, length) {
          var r = "" + num;
          while (r.length < length) {
              r = "0" + r;
          }
          return r;
      }
      
      function updateStatus() {
        var reqDO = {
          Command: "UpdateProgress"
        };
        vgsService("InitDatabase", reqDO, false, function(ansDO) {
          var statusPercentage = ansDO.Answer.UpdateProgress.StatusPercentage;
          var statusMessage = ansDO.Answer.UpdateProgress.StatusMessage;
          var statusTimestamp = ansDO.Answer.UpdateProgress.StatusTimestamp;
          var min = Math.floor(installTimer/60);
          var sec = installTimer%60;
          var timerText = "(" + FormatNumberLength(min,2) + ":" + FormatNumberLength(sec,2) + ")";
          installTimer += 1;
          $("#progressbar-int").animate({"width": statusPercentage + "%"},"slow");
          $("#percent-counter").text(statusTimestamp + " " + timerText + " " + statusPercentage + "% - " + statusMessage);
          if(statusPercentage < 100) setTimeout(updateStatus, 1000); 
        });
      }
      
      $(document).ready(function() {
        $("#TimeZone").val(getTimezoneCode());
      });
    </script>
  <% } %>
</head>

<body>

    <% if(!databaseEmpty) { %>
    <v:widget id="db-install-widget" caption="Horizon DB Installation Message" icon="[font-awesome]exclamation-triangle|ColorizeOrange">
      <v:widget-block>
        <label>Horizon database has already been installed or the database is not empty.</label>
      </v:widget-block>
    </v:widget>
  
  <% } else { %>
  
    <v:widget id="db-install-widget" caption="Accesso Horizon Database Installation" icon="settings_small.png">
    <div id="data-input">
      <div id="install-step1">
       <div class="step-container">
        <v:widget-block>
          <v:form-field caption="License ID">
            <input type="number" required id="LicenseId" class="default-focus form-control" value="" />
          </v:form-field>
        </v:widget-block>
        <v:widget-block>

          <v:form-field caption="Currency Code" mandatory="true"><input type="text" id="ISOCode" class="form-control" maxlength="3" title="3 character Currency ISO Code" value="USD" onkeypress="return textOnly(event)"/></v:form-field>
          <v:form-field caption="Currency Name" mandatory="true"><input type="text" id="CurrencyName" class="form-control" maxlength="30" value="US Dollar"/></v:form-field>
          <v:form-field caption="Currency Symbol" mandatory="true"><input type="text" id="Symbol" class="form-control" maxlength="10" value="$"/></v:form-field>
          <v:form-field caption="Currency Format" mandatory="true"><v:lk-combobox field="CurrencyFormat" lookup="<%=LkSN.CurrencyFormat%>" allowNull="false" /></v:form-field>
          <v:form-field caption="Round Decimals" mandatory="true"><input type="text" id="RoundDecimals" class="form-control" maxlength="1" value='2' onkeypress="return numbersOnly(event)"/></v:form-field>
        </v:widget-block>
        <v:widget-block>
          <v:form-field caption="Time Zone" mandatory="true"><v:lk-combobox field="TimeZone" lookup="<%=LkSN.TimeZone%>" allowNull="false" /></v:form-field>
          <v:form-field caption="Fiscal date start time (hh)" mandatory="true"><input type="text" id="FiscalDateSwitchHour" class="form-control" maxlength="2" value="5" onkeypress="return numbersOnly(event)"/></v:form-field>
        </v:widget-block>
        </div>
        <v:button id="nextToStep2" caption="Next" fa="caret-right" href="javascript:toStep2()" clazz="margin-10 float-right"/>
        <div style="clear:both;"></div>
        
      </div>
      <div id="install-step2" class="v-hidden">
       <div class="step-container">
        <v:widget-block>
          <v:form-field caption="Admin Password" mandatory="true"><v:input-text field="AdminPassword" type="password" /></v:form-field>
          <v:form-field caption="Retype Admin Password" mandatory="true"><v:input-text field="AdminPassword2" type="password" /></v:form-field>
        </v:widget-block>
        <v:widget-block>
          <v:form-field caption="VGS Support Password" mandatory="true"><v:input-text field="VGSSupportPassword"  type="password"/></v:form-field>
          <v:form-field caption="Retype VGS Support Password" mandatory="true"><v:input-text field="VGSSupportPassword2"  type="password"/></v:form-field>
        </v:widget-block>
        </div>
        <v:button caption="Back" fa="caret-left" href="javascript:toStep1()" clazz="margin-10"/>
        <v:button id="nextToStep3" caption="Next" fa="caret-right" href="javascript:toStep3()" clazz="margin-10 float-right"/>
      </div>
      <div id="install-step3" class="v-hidden">
        <div class="step-container">
          <v:widget-block>
            <div><v:db-checkbox field="SendDebugNotifications" value="true" caption="@Right.SendDebugNotifications" checked="true"/></div>
            <div><v:db-checkbox field="SetReadCommitted" value="true" caption="Set mssql transaction isolation to READ-COMMITTED (mandatory)" checked="true"/></div>
          </v:widget-block>
          <v:widget-block>
            <v:form-field caption="SnApp Cache Directory" mandatory="true"><input type="text" id="CacheDirectory" class="form-control" value="<%= JvIO.getAppDataPath() + "/Vgs/SnappCache"%>"/></v:form-field>
          </v:widget-block>
        </div>
         <v:widget-block>
           <v:button caption="Back" fa="caret-left" href="javascript:toStep2()"/>
          <v:button caption="Install" fa="save" href="javascript:doInstall()" clazz="float-right"/>
        </v:widget-block>
      </div>
    </div>
    <div id="wait-spinner" class="v-hidden step-container">
      <v:widget-block>
        <div id="percent-counter"></div>
      </v:widget-block>
      <v:widget-block>
      <div id="progressbar-ext">
        <div id="progressbar-int"></div>
      </div>
      </v:widget-block>
    </div>
    <div id="success-box" class="v-hidden">
      <v:widget-block>
        Congratulations! Database successfully created.&nbsp;
        <a href="<v:config key="site_url"/>/admin" class="no-ajax">Go to Login page.</a>
      </v:widget-block>
    </div>
    <div id="error-box" class="v-hidden">
      <span id="error-message"></span>
    </div>
  </v:widget>
<% } %>
</body>

</html>


