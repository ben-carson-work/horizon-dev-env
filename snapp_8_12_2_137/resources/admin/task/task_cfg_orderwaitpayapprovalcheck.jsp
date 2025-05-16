<%@page import="java.text.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTask" scope="request"/>

<v:widget caption="@Common.Settings">
	<v:widget-block>
    <v:form-field caption="@Task.OrderWaitPayApprovalCheck_TimeoutMins" hint="@Task.OrderWaitPayApprovalCheck_TimeoutMinsHint"><v:input-text field="cfg.TimeoutMins" placeholder="20"/></v:form-field>
  </v:widget-block>
</v:widget>	

<script>

function saveTaskConfig(reqDO) {
  var config = {
    TimeoutMins: _getIntValue("#cfg\\.TimeoutMins")
	}
	reqDO.TaskConfig = JSON.stringify(config); 

  function _getIntValue(selector) {
    var value = $(selector).val();
    if (getNull(value) == null)
      return  null;
    else {
      var result = parseInt(value);
      if (isNaN(result))
        throw(itl("@Common.InvalidValue") + ": " + value);
      
      return result;
    }
  }
}

</script>

