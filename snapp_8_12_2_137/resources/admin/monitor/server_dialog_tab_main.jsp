<%@page import="com.vgs.snapp.lookup.LkSNServerParamType"%>
<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@page import="com.vgs.snapp.dataobject.DOServer.DOServerParam"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
String idString = pageBase.getParameter("serverId");
int id = Integer.parseInt(idString);

boolean masked = !rights.VGSSupport.getBoolean();
DOServer server = pageBase.getBL(BLBO_Server.class).getServer(id, masked);

String autoServerURL = null;
String confServerURL = null;

for (DOServerParam param: server.SystemParamList) {
  if(param.ParamName.isSameString("AutoServerURL")) {
    autoServerURL = param.ParamValue.getString();
  }
}

for (DOServerParam param: server.CustomParamList) {
  if(param.ParamName.isSameString("ConfServerURL")) {
    confServerURL = param.ParamValue.getString();
  }
}

request.setAttribute("server", server);
%>
<div class="tab-toolbar">
  <v:button id="SaveServer" caption="@Common.Save" fa="save"/>
</div>
<div class="tab-content">
  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="ID">
        <input type="text" readonly="readonly" class="form-control" value="<%=server.ServerId.getInt()%>" />
      </v:form-field>
      <v:form-field caption="Code">
        <input type="text" readonly="readonly" class="form-control" value="<%=server.ServerCode.getHtmlString()%>" />
      </v:form-field>
      <v:form-field caption="Name">
        <input type="text" readonly="readonly" class="form-control" value="<%=server.ServerName.getHtmlString()%>" />
      </v:form-field>
      <v:form-field caption="WAR Version">
        <input type="text" readonly="readonly" class="form-control" value="<%=server.WarVersion.getHtmlString()%>" />
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="Check date/time">
        <snp:datetime timestamp="<%=server.CheckDateTime.getDateTime()%>" format="ShortDateTime" timezone="server"/>
      </v:form-field>
      <v:form-field caption="Startup date/time">
        <snp:datetime timestamp="<%=server.StartupDateTime.getDateTime()%>" format="ShortDateTime" timezone="server"/>
      </v:form-field>
      <v:form-field caption="Shutdown date/time">
        <snp:datetime timestamp="<%=server.ShutdownDateTime.getDateTime()%>" format="ShortDateTime" timezone="server"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="Server URL">
        <input type="text" id="serverURL" class="form-control" placeholder="<%=autoServerURL %>" value="<%=confServerURL!=null ? confServerURL : ""%>" />
      </v:form-field>
      <v:form-field caption="@ServerProfile.ServerProfile">
        <snp:dyncombo field="server.ServerProfileId" entityType="<%=LkSNEntityType.ServerProfile%>"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
</div>


<script>
$(document).ready(function() {
  $("#SaveServer").click(doSaveServer);
  
  function doSaveServer() {
    paramObj = {};
    var reqDO = {
      Command: "SaveServer",
      SaveServer: {
        Server: {
          ServerId : <%=server.ServerId%>,
          ServerProfileId : $('#server\\.ServerProfileId').val(),
          CustomParamList : []
        }
      }
    };

    paramObj.ParamName= "ConfServerURL";
    paramObj.ParamValue = $('#serverURL').val() != "" ? $('#serverURL').val() : null;
    reqDO.SaveServer.Server.CustomParamList.push(paramObj);
    
    vgsService("SYSTEM", reqDO, false, function(ansDO) {
      $("#server_dialog").dialog("close");
      javascript:changeGridPage('#server-grid', 1)
    });
   }
});
</script>