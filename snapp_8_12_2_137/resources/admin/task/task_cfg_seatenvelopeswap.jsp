<%@page import="com.vgs.snapp.task.TaskSeatEnvelopeSwap"%>
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


<v:widget caption="@Common.Settings">
	<v:widget-block>
    <v:form-field caption="@Task.SeatEnvelopeSwap_RetryMins" hint="@Task.SeatEnvelopeSwap_RetryMinsHint"><v:input-text field="cfg.RetryMins" placeholder="<%=String.valueOf(TaskSeatEnvelopeSwap.getDefault_RetryMins())%>"/></v:form-field>
  </v:widget-block>
</v:widget>	

<script>

function saveTaskConfig(reqDO) {
  var config = {
    RetryMins: _getIntValue("#cfg\\.RetryMins")
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

