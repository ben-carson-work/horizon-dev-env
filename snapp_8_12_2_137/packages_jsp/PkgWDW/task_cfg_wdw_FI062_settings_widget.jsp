<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="java.text.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTask" scope="request"/>

<v:widget caption="@Common.Configuration">
	<v:widget-block>
	  <v:form-field caption="Local folder">
	    <v:input-text field="cfg.LocalFolder"/>
	  </v:form-field>
	</v:widget-block>
	<v:widget-block>
	  <v:form-field caption="User field code" hint="Metafield code to be used for user identification (for users mask)">
	    <v:input-text field="cfg.UserMetaFieldCode"/>
	  </v:form-field>
	  <v:form-field caption="Profile Center field code" hint="Metafield code to be used for location's profile centers (for locations mask)">
	    <v:input-text field="cfg.ProfitCenterMetaFieldCode"/>
	  </v:form-field>
	</v:widget-block>
</v:widget>

<script>

function saveTaskConfig(reqDO) {
  var config = {
    LocalFolder: $("#cfg\\.LocalFolder").val(),
    UserMetaFieldCode: $("#cfg\\.UserMetaFieldCode").val(),
    ProfitCenterMetaFieldCode: $("#cfg\\.ProfitCenterMetaFieldCode").val()
  }
  reqDO.TaskConfig = JSON.stringify(config); 
}

</script>

