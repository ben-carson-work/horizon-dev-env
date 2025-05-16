<%@page import="com.vgs.cl.document.JvDocument"%>
<%@page import="com.vgs.snapp.lookup.LkSN"%>
<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>
<%@ taglib uri="snp-tags" prefix="snp"%>

<jsp:useBean id="pageBase"
	class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request" />
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin"
	scope="request" />
<%
JvDocument settings = (JvDocument) request.getAttribute("settings");
%>

<v:widget>
	<v:widget-block>
		<v:button id="btn-add" caption="Add server" />
	</v:widget-block>
</v:widget>

<div id="web-config-grid"></div>

<div id="config-templates" class="hidden">
	<div id="config-templates-element">
		<v:widget caption="Server config" removeHRef="javascript:removeServerConfig()">
			<v:widget-block>
				<v:form-field caption="@Common.Server">
					<snp:dyncombo id="ServerId" entityType="<%=LkSNEntityType.Server%>" allowNull="false" enabled="false" />
				</v:form-field>
			</v:widget-block>
			<v:widget-block>
				<v:form-field caption="Network" multiCol="true">
					<v:multi-col caption="@Common.IPAddress">
						<v:input-text field="HostName" />
					</v:multi-col>
					<v:multi-col caption="@Common.HostPort">
						<v:input-text field="HostPort" type="number" />
					</v:multi-col>
				</v:form-field>
			</v:widget-block>
			<v:widget-block>
				<v:form-field caption="DB synch " hint="Force the DB synch with Opera on startup" checkBoxField="DbSynch" />
				<v:form-field caption="Ssl communication " hint="If checked communication with Opera is secured using ssl.Drag & drop or select the certificate file to be used to communicate with Opera" checkBoxField="Ssl">
					<v:input-upload-item field="CertificateFile" />
				</v:form-field>
			</v:widget-block>
			<v:widget-block>
				<v:form-field caption="Charset" hint="Define the charset to be use to communicate with Opera, it must be the same configured on Oper system">
					<v:lk-combobox lookup="<%=LkSN.Charset%>" field="Charset" allowNull="false" />
				</v:form-field>
			</v:widget-block>
			<v:widget-block>
				<v:form-field caption="Timeouts" multiCol="true">
					<v:multi-col caption="X Messages timeout" hint="Timeout, in seconds, for X type messages. Default value is  30">
						<v:input-text field="XMessagesTimeout" type="number" placeholder="30" />
					</v:multi-col>
					<v:multi-col caption="PR Messages timeout" hint="Timeout, in seconds, for PR type messages. Default value is  60">
						<v:input-text field="PRMessagesTimeout" type="number" placeholder="60" />
					</v:multi-col>
					<v:multi-col caption="Sanity check timeout" hint="It defines, in seconds, the inactive time after which a message should be sent to Oper to check the communication. Default value is 240">
						<v:input-text field="SanityCheckTimeout" type="number" placeholder="240" />
					</v:multi-col>
					<v:multi-col caption="Initialization timeout" hint="It defines, in seconds, the timeout for the communication init message (LS) from Opera system after which a sanity check thread is started. Default value is 60">
						<v:input-text field="InitializationTimeout" type="number" placeholder="60" />
					</v:multi-col>
				</v:form-field>
			</v:widget-block>
			<v:widget-block>
				<v:form-field caption="Opera payment method name" hint="Payment method configured on Opera system to be used for room charge command, this value must exist on Opera otherwise charge operation will be rejected. Default values is ROOM">
					<v:input-text field="PaymentMethodName" placeholder="ROOM" />
				</v:form-field>
			</v:widget-block>
		</v:widget>
	</div>
</div>
<script>
  $(document).ready(
      function() {
        var settings = <%=settings.getJSONString()%>;
        $("#btn-add").click(selectServer);

        doInitialize();

        function doInitialize() {
          if (settings && settings.PluginSettingList) {
            for (var i = 0; i < settings.PluginSettingList.length; i++)
              doAdd(settings.PluginSettingList[i]);
          }
        }

        function selectServer() {
          asyncDialogEasy('../../plugins/pkg-oracle/server_select_dialog');
        }

        function doAdd(item) {
          var $tr = $("#config-templates #config-templates-element").clone()
              .appendTo("#web-config-grid");

          item = (item) ? item : {};
          $tr.find(".widget-title-caption").text(item.ServerName);
          $tr.prop("id", 'Server-' + item.ServerId);
          $tr.attr("class", 'Server-row');
          $tr.find(".widget-title a").prop("href", "javascript:removeServerConfig(\'" + item.ServerId + "\')");
          $tr.find("#ServerId").val(item.ServerId);
          $tr.find("#HostName").val(item.HostName);
          $tr.find("#HostPort").val(item.HostPort);
          $tr.find('[name="Ssl"]').prop('checked', item.Ssl);
          formFieldCheckBoxClick($tr.find('[name="Ssl"]'));
          /* $tr.find("#Ssl").prop('checked', item.Ssl); */
          $tr.find("#Charset").val(item.Charset);
          $tr.find("#XMessagesTimeout").val(item.XMessagesTimeout);
          $tr.find("#PRMessagesTimeout").val(item.PRMessagesTimeout);
          $tr.find("#SanityCheckTimeout").val(item.SanityCheckTimeout);
          $tr.find("#InitializationTimeout").val(item.HostName);
          $tr.find('[name="DbSynch"]').prop('checked', item.DbSynch);
          /* $tr.find("#DbSynch").prop('checked', item.DbSynch); */
          $tr.find("#PaymentMethodName").val(item.PaymentMethodName);
          if (item.CertificateFile)
            $tr.find("#CertificateFile").valObject(JSON.stringify(item.CertificateFile));
          $tr.data("item", item);
        }

        function setMultibxoVal($sel, value) {
          $sel.attr('data-html', $sel.html());
          $sel.selectize({
            dropdownParent : "body",
            plugins : [ 'remove_button', 'drag_drop' ]
          })[0].selectize.setValue(value, true);
        }

      });

  function removeServerConfig(item) {
		confirmDialog(null, function() {
    	$("#web-config-grid").find("#Server-" + item).remove();
		});
  }

  function addServerConfiguration(dataSet) {
		if ( $("#Server-" + dataSet.itemid).length != 0) {
		  showIconMessage("warning", itl("@Common.AlreadyConfigured"));
			return;
		}
    var $tr = $("#config-templates #config-templates-element").clone().prependTo("#web-config-grid");
    $tr.find(".widget-title-caption").text(dataSet.itemname);
    $tr.prop("id", 'Server-' + dataSet.itemid);
    $tr.attr("class", 'Server-row');
    $tr.find(".widget-title a").prop("href", "javascript:removeServerConfig(\'" + dataSet.itemid + "\')");
    $tr.find("#ServerId").val(dataSet.itemid);
  }

  function getPluginSettings() {
    var result = {
      PluginSettingList : []
    }

    // Fill PluginSettingList
    $("#web-config-grid .Server-row").each(function(idx, elem) {
      var $tr = $(elem);
      result.PluginSettingList.push({
        ServerId : $tr.find("#ServerId").val(),
        ServerName : $tr.find("#ServerId").prop('dataset').itemname,
        HostName : $tr.find("#HostName").val(),
        HostPort : $tr.find("#HostPort").val(),
        Ssl : $tr.find('[name="Ssl"]').isChecked(),
        XMessagesTimeout : $tr.find("#XMessagesTimeout").val(),
        PRMessagesTimeout : $tr.find("#PRMessagesTimeout").val(),
        PaymentMethodName : $tr.find("#PaymentMethodName").val(),
        SanityCheckTimeout : $tr.find("#SanityCheckTimeout").val(),
        Charset : $tr.find("#Charset").val(),
        DbSynch : $tr.find('[name="DbSynch"]').isChecked(),
        CertificateFile : $tr.find("#CertificateFile").valObject(),
        InitializationTimeout : $tr.find("#InitializationTimeout").val(),
        BindingAddress : $tr.find("#BindingAddress").val(),
        BindingPort : $tr.find("#BindingPort").val()
      });
    });
    return result;
  }
</script>
