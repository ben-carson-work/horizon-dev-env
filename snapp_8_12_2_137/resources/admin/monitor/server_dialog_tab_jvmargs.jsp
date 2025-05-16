<%@page import="com.vgs.cl.JvString"%>
<%@page import="java.util.List"%>
<%@page import="java.lang.management.*"%>
<%@page import="java.lang.management.*"%>
<%@page import="com.vgs.snapp.dataobject.DOServer.*"%>
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
%>
<script type="text/javascript">
$(document).ready(function() {
	vgsService("Service", {Command:"GetJvmCfg", ForwardToServerId:<%=id%>}, true, function(ansDO) {
		var good = (ansDO.Answer) && (ansDO.Answer.GetJvmCfg);
		if (good) 
			ansDO.Answer.GetJvmCfg.JvmCfgList.forEach((cfg, index) => {
				$("#jvminfoId").append("<div>" + cfg + "</div>")  	
			});
		});
});
</script>

<div class="tab-content">
  <v:widget caption="@Common.Parameters">
    <v:widget-block id="jvminfoId">
    </v:widget-block>
  </v:widget>
</div>