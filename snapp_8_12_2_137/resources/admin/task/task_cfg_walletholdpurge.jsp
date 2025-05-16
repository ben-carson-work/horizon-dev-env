<%@page import="com.vgs.web.library.bean.*"%>
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
<jsp:useBean id="task" class="com.vgs.snapp.dataobject.DOTask" scope="request"/>

<v:widget caption="@Common.Settings">
	<v:widget-block>
    <v:form-field caption="@Right.WalletReleaseAfter"><v:input-text field="cfg.ReleaseAfterMins" placeholder="60"/></v:form-field>
  </v:widget-block>
</v:widget>	

<script>

function saveTaskConfig(reqDO) {
  var config = {
      ReleaseAfterMins: _getAllowedValues("#cfg\\.ReleaseAfterMins")
	}
  
  reqDO.TaskConfig = JSON.stringify(config);
  
  function _getAllowedValues(selector) {
    var value = $(selector).val();
    if (getNull(value) == null)
      return null;
    else {
      var result = parseInt(value);
      if (isNaN(result) || (result<1))
        throw(itl("@Task.ReleaseFrozenSeats") + " - " + itl("@Common.InvalidValue") + ": " + value);
      
      return result;
    }
  }
}

</script>

