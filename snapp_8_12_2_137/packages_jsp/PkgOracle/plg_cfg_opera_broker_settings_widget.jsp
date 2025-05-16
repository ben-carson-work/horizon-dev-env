<%@page import="com.vgs.snapp.lookup.LkSN"%>
<%@page import="com.vgs.vcl.JvImageCache"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

	<v:widget caption="Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
		<v:widget-block>
      <v:form-field caption="@Common.IPAddress" mandatory="true">
        <v:input-text field="HostName"/>
      </v:form-field>
      <v:form-field caption="@Common.HostPort" mandatory="true">
        <v:input-text field="HostPort" type="number"/>
      </v:form-field>
		</v:widget-block>
		<v:widget-block>
			<v:db-checkbox field="Ssl" caption="Ssl communication " hint="If checked communication with Opera is secured using ssl" value="true"/>
			<div class="v-hidden upload-file-drop" id="ssl-config">
				<v:form-field caption="Certificate file" hint="Drag & drop or select the certificate file to be used to communicate with Opera">
					<v:input-upload-item field="CertificateFile"/>
      	</v:form-field>
    	</div>
		</v:widget-block>
		<v:widget-block>
		  <v:form-field caption="Charset" hint="Define the charset to be use to communicate with Opera, it must be the same configured on Oper system">
				<v:lk-combobox lookup="<%=LkSN.Charset%>" field="Charset" allowNull="false"/>
			</v:form-field>
		</v:widget-block>
		<v:widget-block>
      <v:form-field caption="X Messages timeout" hint="Timeout, in seconds, for X type messages. Default value is  30">
        <v:input-text field="XMessagesTimeout" type="number"  placeholder="30"/>
      </v:form-field>
      <v:form-field caption="PR Messages timeout" hint="Timeout, in seconds, for PR type messages. Default value is  60">
        <v:input-text field="PRMessagesTimeout" type="number"  placeholder="60"/>
      </v:form-field>
      <v:form-field caption="Sanity check timeout" hint="It defines, in seconds, the inactive time after which a message should be sent to Oper to check the communication. Default value is 240">
        <v:input-text field="SanityCheckTimeout" type="number"  placeholder="240"/>
      </v:form-field>
      <v:form-field caption="Initialization timeout" hint="It defines, in seconds, the timeout for the communication init message (LS) from Opera system after which a sanity check thread is started. Default value is 60">
        <v:input-text field="InitializationTimeout" type="number"  placeholder="60"/>
      </v:form-field>
      <v:db-checkbox field="DbSynch" caption="DB synch" hint="Force the DB synch with Opera on startup" value="true"/>
		</v:widget-block>
		<v:widget-block>
			<v:form-field caption="Opera payment method name" hint="Payment method configured on Opera system to be used for room charge command, this value must exist on Opera otherwise charge operation will be rejected. Default values is ROOM">
        <v:input-text field="PaymentMethodName" placeholder="ROOM"/>
    	</v:form-field>
		</v:widget-block>
	</v:widget>