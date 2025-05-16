<%@page import="com.vgs.vcl.JvImageCache"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget id="pay-nec-settings" caption="Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
 <v:widget-block>
	  <v:alert-box type="info"><b>*Payment method configuration*</b></br></br>
			Payment methods, except credit/debit card, have to be configured with an "Alias".</br>
				Accepted alias are:</br>
				<ul>
					<li>UNION_PAY</li>
		    	<li>ID_PAYMENT</li>
		    	<li>WAON_PAYMENT</li>
		    	<li>QP_PAYMENT</li>
	    	</ul>
		</v:alert-box>
  </v:widget-block>
  <v:widget-block>
		<v:form-field caption="Customer Code" mandatory="true">
      <v:input-text field="CustomerCode"/>
    </v:form-field>
		<v:form-field caption="Head office code" mandatory="true">
      <v:input-text field="HeadOfficeCode"/>
    </v:form-field>
		<v:form-field caption="Store code" mandatory="true">
      <v:input-text field="StoreCode"/>
    </v:form-field>
		<v:form-field caption="Pos number" mandatory="true">
      <v:input-text field="PosNo"/>
    </v:form-field>
		<v:form-field caption="RW number" mandatory="true">
      <v:input-text field="RwNo"/>
    </v:form-field>
		<v:form-field caption="Machine type" mandatory="true">
      <v:input-text field="MachineType"/>
    </v:form-field>
		<v:form-field caption="Retry flag" mandatory="true">
      <v:input-text field="RetryFlag"/>
    </v:form-field>
		<v:form-field caption="Active password" mandatory="true">
      <v:input-text field="ActivePW"/>
    </v:form-field>
		<v:form-field caption="Remote host real" mandatory="true">
      <v:input-text field="RemoteHostReal"/>
    </v:form-field>
		<v:form-field caption="Remote port real" mandatory="true">
      <v:input-text field="RemotePortReal"/>
    </v:form-field>
		<v:form-field caption="Remote host CD" mandatory="true">
      <v:input-text field="RemoteHostCD"/>
    </v:form-field>
		<v:form-field caption="Remote port CD" mandatory="true">
      <v:input-text field="RemotePortCD"/>
    </v:form-field>
		<v:form-field caption="Remote host TMS" mandatory="true">
      <v:input-text field="RemoteHostTMS"/>
    </v:form-field>
		<v:form-field caption="Remote port TMS" mandatory="true">
      <v:input-text field="RemotePortTMS"/>
    </v:form-field>
        <v:form-field caption="Timeout TMS" >
      <v:input-text field="TimeoutTMS" placeholder="20"/>
    </v:form-field>
		<v:form-field caption="Remote host credit" mandatory="true">
      <v:input-text field="RemoteHostCredit"/>
    </v:form-field>
		<v:form-field caption="Remote port credit" mandatory="true">
      <v:input-text field="RemotePortCredit"/>
    </v:form-field>
		<v:form-field caption="Remote host CA" mandatory="true">
      <v:input-text field="RemoteHostCA"/>
    </v:form-field>
		<v:form-field caption="Remote port CA" mandatory="true">
      <v:input-text field="RemotePortCA"/>
    </v:form-field>
		<v:form-field caption="Timeout CA" mandatory="true">
      <v:input-text field="TimeoutCA"/>
    </v:form-field>
		<v:form-field caption="Remote host CA check" mandatory="true">
      <v:input-text field="RemoteHostCACheck"/>
    </v:form-field>
		<v:form-field caption="Remote port CA check" mandatory="true">
      <v:input-text field="RemotePortCACheck"/>
    </v:form-field>
    <v:form-field caption="Operate environment" mandatory="true">
      <v:input-text field="OperateEnvironment"/>
    </v:form-field>
		<v:form-field caption="Route ID" mandatory="true">
      <v:input-text field="RouteID"/>
    </v:form-field>
    <v:form-field caption="Deal data" hint="CRE.CreateDealData">
      <v:input-text field="CreateDealData" placeholder="1"/>
    </v:form-field>
		<v:form-field caption="Destination decision">
      <v:input-text field="DestinationDecision" placeholder="1"/>
    </v:form-field>
    <v:form-field caption="Retry interval">
      <v:input-text field="RetryInterval" placeholder="5"/>
    </v:form-field>
    <v:form-field caption="Retry count">
      <v:input-text field="RetryCount" placeholder="1"/>
    </v:form-field>
    <v:form-field caption="Fail Timeout" hint="RW Setup AP FailCancelTimeout">
      <v:input-text field="FailCancelTimeout" placeholder="70"/>
    </v:form-field>
    <v:form-field caption="Check Timeout" hint="RW Setup AP TimeoutCACheck">
      <v:input-text field="TimeoutCACheck" placeholder="20"/>
    </v:form-field>
    <v:form-field caption="Creadit Timeout" hint="RW Setup AP TimeoutCredit">
      <v:input-text field="TimeoutCredit" placeholder="85"/>
    </v:form-field>
    <v:form-field caption="CD Timeout" hint="RW Setup AP TimeoutCD">
      <v:input-text field="TimeoutCD" placeholder="20"/>
    </v:form-field>
    <v:form-field caption="Real Timeout" hint="RW Setup AP TimeoutReal">
      <v:input-text field="TimeoutReal" placeholder="20"/>
    </v:form-field>
    <v:form-field caption="Setup password" mandatory="true">
      <v:input-text field="SetupPW"/>
    </v:form-field>
    <v:form-field caption="CL Threshold" hint="Amount threshold over which contactless cannot be used">
      <v:input-text field="ContactlessThreshold" placeholder="0" type="numeric"/>
    </v:form-field>
    <v:form-field caption="Start retry" hint="Define the number of retries for the plugin startup procedure">
      <v:input-text field="InitializationRetry" placeholder="0" type="numeric"/>
    </v:form-field>    
    <v:db-checkbox field="PerformInit" caption="init device" hint="Flag it run the intialization NEC device process. It should be used when termianl has been changed or at first usage" value="true"/>
  </v:widget-block>
  <v:widget-block>
		<v:form-field caption="Remote host auth iD" mandatory="true">
      <v:input-text field="RemoteHostAuthId"/>
    </v:form-field>
		<v:form-field caption="Remote port auth iD" mandatory="true">
      <v:input-text field="RemotePortAuthId"/>
    </v:form-field>
        <v:form-field caption="Timeout auth iD" mandatory="true">
      <v:input-text field="TimeoutAuthId"/>
    </v:form-field>
		<v:form-field caption="iD Pin threshold" hint="Pin request threshold limit for iD payments. If the payment amount is bigger then the threshold defined here pin will be reuired, a zero value means no threshold. Default values is zero">
      <v:input-text field="IdPinThreshold" placeholder="0" type="number"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
		<v:form-field caption="Remote host auth Qp" mandatory="true">
      <v:input-text field="RemoteHostAuthQp"/>
    </v:form-field>
		<v:form-field caption="Remote port auth Qp" mandatory="true">
      <v:input-text field="RemotePortAuthQp"/>
    </v:form-field>
    <v:form-field caption="Timeout auth Qp" mandatory="true">
      <v:input-text field="TimeoutAuthQp"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
		<v:form-field caption="Remote host auth Waon" mandatory="true">
      <v:input-text field="RemoteHostAuthWaon"/>
    </v:form-field>
		<v:form-field caption="Remote port auth Waon" mandatory="true">
      <v:input-text field="RemotePortAuthWaon"/>
    </v:form-field>
		<v:form-field caption="Remote host charge" mandatory="true">
      <v:input-text field="RemoteHostChargeRes"/>
    </v:form-field>
		<v:form-field caption="Remote port charge" mandatory="true">
      <v:input-text field="RemotePortChargeRes"/>
    </v:form-field>
		<v:form-field caption="Remote host Online" mandatory="true">
      <v:input-text field="RemoteHostOnlineAuth"/>
    </v:form-field>
		<v:form-field caption="Remote port Online" mandatory="true">
      <v:input-text field="RemotePortOnlineAuth"/>
    </v:form-field>
		<v:form-field caption="Affiliated Store Code" mandatory="true">
      <v:input-text field="AffiliatedStoreCode"/>
    </v:form-field>
    <v:form-field caption="Authorization Exists" mandatory="true">
      <v:input-text field="AuthorizationExists"/>
    </v:form-field>
    <v:form-field caption="Timeout Auth WAON" mandatory="true">
      <v:input-text field="TimeoutAuthWaon"/>
    </v:form-field>
		<v:form-field caption="Timeout Charge Res" mandatory="true">
      <v:input-text field="TimeoutChargeRes"/>
    </v:form-field>
		<v:form-field caption="Timeout Online Auth" mandatory="true">
      <v:input-text field="TimeoutOnlineAuth"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  var $cfg = $("#pay-nec-settings");
  
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    /*Generci parameters*/
    $cfg.find("#CustomerCode").val(params.settings.CustomerCode);
    $cfg.find("#HeadOfficeCode").val(params.settings.HeadOfficeCode);
    $cfg.find("#StoreCode").val(params.settings.StoreCode);
    $cfg.find("#PosNo").val(params.settings.PosNo);
    $cfg.find("#RwNo").val(params.settings.RwNo);
    $cfg.find("#MachineType").val(params.settings.MachineType);
    $cfg.find("#RetryFlag").val(params.settings.RetryFlag);
    $cfg.find("#ActivePW").val(params.settings.ActivePW);
    $cfg.find("#RemoteHostReal").val(params.settings.RemoteHostReal);
    $cfg.find("#RemotePortReal").val(params.settings.RemotePortReal);
    $cfg.find("#RemoteHostCD").val(params.settings.RemoteHostCD);
    $cfg.find("#RemotePortCD").val(params.settings.RemotePortCD);
    $cfg.find("#RemoteHostTMS").val(params.settings.RemoteHostTMS);
    $cfg.find("#RemotePortTMS").val(params.settings.RemotePortTMS);
    $cfg.find("#RemoteHostCredit").val(params.settings.RemoteHostCredit);
    $cfg.find("#RemotePortCredit").val(params.settings.RemotePortCredit);
    $cfg.find("#RemoteHostCA").val(params.settings.RemoteHostCA);
    $cfg.find("#RemotePortCA").val(params.settings.RemotePortCA);
    $cfg.find("#RemoteHostCACheck").val(params.settings.RemoteHostCACheck);
    $cfg.find("#RemotePortCACheck").val(params.settings.RemotePortCACheck);
    $cfg.find("#RouteID").val(params.settings.RouteID);
    $cfg.find("#TimeoutCD").val(params.settings.TimeoutCD);
    $cfg.find("#TimeoutTMS").val(params.settings.TimeoutTMS);
    $cfg.find("#TimeoutCA").val(params.settings.TimeoutCA);
    $cfg.find("#OperateEnvironment").val(params.settings.OperateEnvironment);
    $cfg.find("#CreateDealData").val(params.settings.CreateDealData);
    $cfg.find("#DestinationDecision").val(params.settings.DestinationDecision);
		$cfg.find("#RetryInterval").val(params.settings.RetryInterval);
		$cfg.find("#RetryCount").val(params.settings.RetryCount);
		$cfg.find("#FailCancelTimeout").val(params.settings.FailCancelTimeout);
		$cfg.find("#TimeoutCACheck").val(params.settings.TimeoutCACheck);
		$cfg.find("#TimeoutCredit").val(params.settings.TimeoutCredit);
		$cfg.find("#TimeoutReal").val(params.settings.TimeoutReal);
    $cfg.find("#SetupPW").val(params.settings.SetupPW);
    $cfg.find("#ContactlessThreshold").val(params.settings.ContactlessThreshold);
    $cfg.find("#InitializationRetry").val(params.settings.InitializationRetry);
    $cfg.find("#PerformInit").prop('checked', (params.settings.PerformInit));
    /*iD payment*/
    $cfg.find("#RemoteHostAuthId").val(params.settings.RemoteHostAuthId);
    $cfg.find("#RemotePortAuthId").val(params.settings.RemotePortAuthId);
    $cfg.find("#TimeoutAuthId").val(params.settings.TimeoutAuthId);
    $cfg.find("#IdPinThreshold").val(params.settings.IdPinThreshold);
    /*QUICPay payment*/
    $cfg.find("#RemoteHostAuthQp").val(params.settings.RemoteHostAuthQp);
    $cfg.find("#RemotePortAuthQp").val(params.settings.RemotePortAuthQp);
    $cfg.find("#TimeoutAuthQp").val(params.settings.TimeoutAuthQp);
    /*WAON payment*/
    $cfg.find("#RemoteHostAuthWaon").val(params.settings.RemoteHostAuthWaon);
    $cfg.find("#RemotePortAuthWaon").val(params.settings.RemotePortAuthWaon);
    $cfg.find("#RemoteHostChargeRes").val(params.settings.RemoteHostChargeRes);
    $cfg.find("#RemotePortChargeRes").val(params.settings.RemotePortChargeRes);
    $cfg.find("#RemoteHostOnlineAuth").val(params.settings.RemoteHostOnlineAuth);
    $cfg.find("#RemotePortOnlineAuth").val(params.settings.RemotePortOnlineAuth);
    $cfg.find("#AffiliatedStoreCode").val(params.settings.AffiliatedStoreCode);
    $cfg.find("#AuthorizationExists").val(params.settings.AuthorizationExists);
    $cfg.find("#TimeoutAuthWaon").val(params.settings.TimeoutAuthWaon);
    $cfg.find("#TimeoutChargeRes").val(params.settings.TimeoutChargeRes);
    $cfg.find("#TimeoutOnlineAuth").val(params.settings.TimeoutOnlineAuth);
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
  					CustomerCode : $cfg.find("#CustomerCode").val(),
            HeadOfficeCode : $cfg.find("#HeadOfficeCode").val(),
            StoreCode : $cfg.find("#StoreCode").val(),
            PosNo : $cfg.find("#PosNo").val(),
            RwNo  : $cfg.find("#RwNo").val(),
            MachineType : $cfg.find("#MachineType").val(),
            RetryFlag : $cfg.find("#RetryFlag").val(),
            ActivePW : $cfg.find("#ActivePW").val(),
            RemoteHostReal : $cfg.find("#RemoteHostReal").val(),
            RemotePortReal : $cfg.find("#RemotePortReal").val(),
            RemoteHostCD : $cfg.find("#RemoteHostCD").val(),
            RemotePortCD : $cfg.find("#RemotePortCD").val(),
            RemoteHostTMS : $cfg.find("#RemoteHostTMS").val(),
            RemotePortTMS : $cfg.find("#RemotePortTMS").val(),
            RemoteHostCredit : $cfg.find("#RemoteHostCredit").val(),
            RemotePortCredit : $cfg.find("#RemotePortCredit").val(),
            RemoteHostCA : $cfg.find("#RemoteHostCA").val(),
            RemotePortCA : $cfg.find("#RemotePortCA").val(),
            RemoteHostCACheck : $cfg.find("#RemoteHostCACheck").val(),
            RemotePortCACheck : $cfg.find("#RemotePortCACheck").val(),
            RouteID : $cfg.find("#RouteID").val(),
            TimeoutCD : $cfg.find("#TimeoutCD").val(),
            TimeoutTMS : $cfg.find("#TimeoutTMS").val(),
            TimeoutCA : $cfg.find("#TimeoutCA").val(),
            OperateEnvironment : $cfg.find("#OperateEnvironment").val(),
            CreateDealData : $cfg.find("#CreateDealData").val(),
            DestinationDecision : $cfg.find("#DestinationDecision").val(),
            RetryInterval : $cfg.find("#RetryInterval").val(),
            RetryCount : $cfg.find("#RetryCount").val(),
            FailCancelTimeout : $cfg.find("#FailCancelTimeout").val(),
            TimeoutCACheck : $cfg.find("#TimeoutCACheck").val(),
            TimeoutCredit : $cfg.find("#TimeoutCredit").val(),
            TimeoutReal : $cfg.find("#TimeoutReal").val(),
            SetupPW : $cfg.find("#SetupPW").val(),
            ContactlessThreshold: $cfg.find("#ContactlessThreshold").val(),
            InitializationRetry: $cfg.find("#InitializationRetry").val(),
            PerformInit : $("#PerformInit").isChecked(),
            RemoteHostAuthId : $cfg.find("#RemoteHostAuthId").val(),
            RemotePortAuthId : $cfg.find("#RemotePortAuthId").val(),
            TimeoutAuthId : $cfg.find("#TimeoutAuthId").val(),
            IdPinThreshold				: $cfg.find("#IdPinThreshold").val(),
            RemoteHostAuthQp : $cfg.find("#RemoteHostAuthQp").val(),
            RemotePortAuthQp : $cfg.find("#RemotePortAuthQp").val(),
            TimeoutAuthQp : $cfg.find("#TimeoutAuthQp").val(),
            RemoteHostAuthWaon : $cfg.find("#RemoteHostAuthWaon").val(),
            RemotePortAuthWaon : $cfg.find("#RemotePortAuthWaon").val(),
            RemoteHostChargeRes : $cfg.find("#RemoteHostChargeRes").val(),
            RemotePortChargeRes : $cfg.find("#RemotePortChargeRes").val(),
            RemoteHostOnlineAuth : $cfg.find("#RemoteHostOnlineAuth").val(),
            RemotePortOnlineAuth : $cfg.find("#RemotePortOnlineAuth").val(),
            AffiliatedStoreCode : $cfg.find("#AffiliatedStoreCode").val(),
            AuthorizationExists : $cfg.find("#AuthorizationExists").val(),
            TimeoutAuthWaon : $cfg.find("#TimeoutAuthWaon").val(),
            TimeoutChargeRes : $cfg.find("#TimeoutChargeRes").val(),
            TimeoutOnlineAuth : $cfg.find("#TimeoutOnlineAuth").val()
          };
        });
      });
</script>