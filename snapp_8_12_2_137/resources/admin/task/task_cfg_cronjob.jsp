<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTask" scope="request"/>

<v:widget caption="@Common.Configuration">
	<v:widget-block>
	  <v:form-field caption="URL">
	    <v:input-text field="cfg.URL"/>
	  </v:form-field>
	</v:widget-block>
</v:widget>

<script>
function saveTaskConfig(reqDO) {
  var config ={
		  URL: $("#cfg\\.URL").val()
	};
	reqDO.TaskConfig = JSON.stringify(config); 
}
</script>

