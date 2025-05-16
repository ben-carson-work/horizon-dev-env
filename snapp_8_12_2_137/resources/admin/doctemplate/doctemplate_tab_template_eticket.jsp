<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.web.plugin.*"%>
<%@page import="com.vgs.snapp.web.gencache.*"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageDocTemplate" scope="request"/>
<jsp:useBean id="doc" class="com.vgs.web.dataobject.DOUI_DocTemplate" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
BLBO_DocTemplate bl = pageBase.getBLDef();
String templateDataString = doc.DocData.getNullString();
%>

<div class="tab-toolbar">
<v:button caption="@Common.Save" fa="save" href="javascript:doSave()" enabled="true"/>
</div>


<div class="tab-content">
	<v:tab-group name="Mobile wallets">
			<%
			List<PlgMobileWalletBase> plugins = SrvBO_Cache_SystemPlugin.instance().findPluginInstanceOf(PlgMobileWalletBase.class);
						if (plugins != null && !plugins.isEmpty()) {
						  boolean firstTab = true;
						  for (PlgMobileWalletBase plg : plugins) {
						    String jspPluginPage = "../../../"+plg.getTemplateConfigurationPageName();
						    String tabId = "tabs-eticket-"+plg.getClassAlias();
			%>
			    <v:tab-item tab="<%=tabId%>" caption="<%=plg.getDescription()%>" jsp="<%=jspPluginPage%>" default="<%=firstTab %>"/>
			    <% 
			    firstTab = false;
			  }
			}
			%>
	</v:tab-group>
</div>

 <%--
<div class="tab-content">
  <v:tab-group name="ETickets">
    <v:tab-item tab="tab_apple" caption="Apple" jsp="apple-temp.jsp" default="true"/>
    <v:tab-item tab="tab_google" caption="Google" jsp="google-temp.jsp"/>
  </v:tab-group>
</div>
--%>
<script type="text/javascript">

var templateConfig = <%=templateDataString%>;

$(document).ready(function() {
  console.log("Main doc ready");
  console.log("main doctemplate-eticket-load sending");
  $(document).trigger("doctemplate-eticket-load", templateConfig);
  console.log("main doctemplate-eticket-load sent");

});

function doSave() {
  if (!templateConfig)
    templateConfig = {"PluginList":[]};
  
  console.log("main before");
  console.log(templateConfig);
  $(document).trigger("doctemplate-eticket-save", templateConfig);
  console.log("main after");
  console.log(templateConfig);

  var reqDO = {
    Command: "SaveDocData",
    SaveDocData: {
      DocTemplateId: <%=doc.DocTemplateId.getJsString()%>,
      DocData: JSON.stringify(templateConfig)
    }
  };
  
  vgsService("DocTemplate", reqDO, false, function(ansDO) {
    showMessage(itl("@Common.SaveSuccessMsg"), function() {
      window.location.reload();
    });
  });
} 
  
</script>

 
 







