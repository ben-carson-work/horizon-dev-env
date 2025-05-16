<%@page import="com.vgs.snapp.library.FtCRUD"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.servlet.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% 
boolean canEdit = pageBase.getRights().SuperUser.getBoolean() || pageBase.getRights().DataSources.canUpdate();

DODataSource dsrc;
if (pageBase.isNewItem()) {
  LookupItem dataSourceType = LkSN.DataSourceType.getItemByCode(pageBase.getParameter("DataSourceType"));
  dsrc = pageBase.getBL(BLBO_DataSource.class).prepareNewDataSource(dataSourceType);
}
else {
  dsrc = pageBase.getBL(BLBO_DataSource.class).loadDataSource(pageBase.getId()).clone(DODataSource.class);
  if (!dsrc.DBPassword.isNull())
    dsrc.DBPassword.setString("********");
}
request.setAttribute("dsrc", dsrc);
%> 

<v:dialog id="datasource_dialog" tabsView="true" title="@Common.DataSource" width="900" height="700">

<v:tab-group name="tabs" main="true">
  <v:tab-item-embedded tab="tabs-profile" caption="@Common.Profile" default="true">
    <v:tab-content>
      <v:widget caption="@Common.Profile">
        <v:widget-block>
          <v:form-field caption="@Common.Type">
            <input type="text" class="form-control" value="<%=dsrc.DataSourceType.getLkValue().getHtmlDescription(pageBase.getLang())%>" disabled="disabled"/>
          </v:form-field>
          <v:form-field caption="@Common.Code" mandatory="true">
            <v:input-text field="dsrc.DataSourceCode"/>
          </v:form-field>
          <v:form-field caption="@Common.Name" mandatory="true">
            <v:input-text field="dsrc.DataSourceName"/>
          </v:form-field>
        </v:widget-block>
      </v:widget>
    </v:tab-content>
  </v:tab-item-embedded>

  <v:tab-item-embedded tab="tabs-connection" caption="@Common.Connection">
    <v:tab-toolbar>
      <v:button id="btn-test" caption="@Common.Test" fa="bolt" title="Test is performed on saved data. Save your changes prior to test."/>
    </v:tab-toolbar>
    <v:tab-content>
      <v:widget caption="@Common.General">
        <v:widget-block>
          <v:form-field caption="@Common.HostName" mandatory="true">
            <v:input-text field="dsrc.DBHostName"/>
          </v:form-field>
          <v:form-field caption="@Common.DatabaseName" mandatory="true">
            <v:input-text field="dsrc.DBDatabaseName"/>
          </v:form-field>
          <v:form-field caption="@Common.UserName" mandatory="true">
            <v:input-text field="dsrc.DBUserName"/>
          </v:form-field>
          <v:form-field caption="@Common.Password" mandatory="true">
            <v:input-text type="password" field="dsrc.DBPassword"/>
          </v:form-field>
          <v:form-field>
            <v:db-checkbox field="dsrc.DBReadOnlyIntent" value="true" caption="Read Only Intent"/>
          </v:form-field>
        </v:widget-block>
        
        <% if (dsrc.DataSourceType.isLookup(LkSNDataSourceType.Log)) { %>
          <v:widget-block>
            <v:form-field caption="Table URI" hint="Full path of the linked logging server (used to view data). Ie: [SERVER].[DATABASE NAME].[dbo].[tbLog]" mandatory="true">
              <v:input-text field="dsrc.LogTableURI"/>
            </v:form-field>
          </v:widget-block>
        <% } %>
      </v:widget>

      <v:widget caption="@Common.Parameters">
        <v:widget-block>
          <v:form-field caption="Pool min" hint="Min connections in the pool">
            <v:input-text field="dsrc.PoolMin" placeholder="<%=String.valueOf(BLBO_DataSource.DEFAULT_POOL_MIN)%>"/>
          </v:form-field>
          <v:form-field caption="Pool max" hint="Max connections in the pool">
            <v:input-text field="dsrc.PoolMax" placeholder="<%=String.valueOf(BLBO_DataSource.DEFAULT_POOL_MAX)%>"/>
          </v:form-field>
          <v:form-field caption="Wait timeout" hint="Max allowed time (in milliseconds) to wait for a connection">
            <v:input-text field="dsrc.WaitTimeoutMS" placeholder="<%=String.valueOf(BLBO_DataSource.DEFAULT_WAIT_TIMEOUT)%>"/>
          </v:form-field>
          <v:form-field caption="Idle timeout" hint="Time (in milliseconds) after which an unused connection is closed and thrown away (for connections between min and max pool size)">
            <v:input-text field="dsrc.IdleTimeoutMS" placeholder="<%=String.valueOf(BLBO_DataSource.DEFAULT_IDLE_TIMEOUT)%>"/>
          </v:form-field>
        </v:widget-block>
      </v:widget>
    </v:tab-content>
  </v:tab-item-embedded>

  <% if (!pageBase.isNewItem()) { %>
    <v:tab-item-embedded tab="tabs-history" caption="@Common.History">
      <jsp:include page="../common/page_tab_historydetail.jsp"/>
    </v:tab-item-embedded>
  <% } %>
</v:tab-group>
  
  
<script>

$(document).ready(function() {
  var dlg = $("#datasource_dialog");
  var initialPassword = dlg.find("[name='dsrc\\.DBPassword']").val();

  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      <% if (canEdit) { %>
        dialogButton("@Common.Save", doSave), 
      <% } %>
      dialogButton("@Common.Close", doCloseDialog)                     
    ];
  });
  
  dlg.find("#btn-test").click(doTest);
  
  dlg.keypress(function() {
    if (event.keyCode == KEY_ENTER)
      doSave();
  });

  function doSave() {
    var reqDO = {
      DataSource: {
        DataSourceId: <%=dsrc.DataSourceId.getJsString()%>,
        DataSourceType: <%=dsrc.DataSourceType.getInt()%>,
        DataSourceCode: dlg.find("[name='dsrc\\.DataSourceCode']").val(),
        DataSourceName: dlg.find("[name='dsrc\\.DataSourceName']").val(),
        DBHostName: dlg.find("[name='dsrc\\.DBHostName']").val(),
        DBDatabaseName: dlg.find("[name='dsrc\\.DBDatabaseName']").val(),
        DBUserName: dlg.find("[name='dsrc\\.DBUserName']").val(),
        DBReadOnlyIntent: dlg.find("[name='dsrc\\.DBReadOnlyIntent']").isChecked(),
        LogTableURI: dlg.find("[name='dsrc\\.LogTableURI']").val(),
        PoolMin: dlg.find("[name='dsrc\\.PoolMin']").val(),
        PoolMax: dlg.find("[name='dsrc\\.PoolMax']").val(),
        WaitTimeoutMS: dlg.find("[name='dsrc\\.WaitTimeoutMS']").val(),
        IdleTimeoutMS: dlg.find("[name='dsrc\\.IdleTimeoutMS']").val()
      }
    };
    
    var actualPassword = dlg.find("[name='dsrc\\.DBPassword']").val();
    if (actualPassword != initialPassword)
      reqDO.DataSource.DBPassword = actualPassword;

    snpAPI.cmd("System", "SaveDataSource", reqDO).then(ansDO => {
      triggerEntityChange(<%=LkSNEntityType.DataSource.getCode()%>);
      dlg.dialog("close");
    });
  }

  function doTest() {
    snpAPI.cmd("System", "TestDataSource", {DataSourceId:<%=dsrc.DataSourceId.getJsString()%>}).then(ansDO => {
      var msg = "Connection successful!";
      if ((ansDO) && (ansDO.TableCreated))
        msg += "\n\n" + "Table [tbLog] was missing and has been created.";
      showMessage(msg);
    });
  }
});

</script>

</v:dialog>
