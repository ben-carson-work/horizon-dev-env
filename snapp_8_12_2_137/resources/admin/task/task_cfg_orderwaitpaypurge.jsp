<%@page import="com.vgs.web.library.dynpatch.*"%>
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

<v:alert-box type="info"><v:itl key="@Task.TaskType_OrderWaitPayPurgeInfo" encode="common-mark"/></v:alert-box>

<v:alert-box type="warning" include="<%=NMissingIndex.IX_Sale_WaitingForPayment.isMissing(pageBase.getDB())%>"><%=JvString.getCommonMarkDIV(NMissingIndex.IX_Sale_WaitingForPayment.getCommonMarkRawWarn())%></v:alert-box>

<v:widget caption="@Task.OrderWaitPayPurge_WebPayments" hint="@Task.OrderWaitPayPurge_WebPaymentsHint">
  <v:widget-block>
    <v:form-field caption="@Task.OrderWaitPayPurge_TimeoutMins" hint="@Task.OrderWaitPayPurge_TimeoutMinsHint">
      <v:input-text field="cfg.TimeoutMins" placeholder="@Common.None"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="@Task.OrderWaitPayPurge_PayByLink" hint="@Task.OrderWaitPayPurge_PayByLinkHint">
  <v:widget-block>
    <v:db-checkbox field="cfg.ExpiredTokensVoidOrder" value="true" caption="@Task.OrderWaitPayPurge_VoidOrderOnTokenExpiration"/>
  </v:widget-block>
</v:widget>

<%-- 
<v:widget caption="@Common.Settings">
	<v:widget-block>
    <v:form-field caption="@Task.OrderWaitPayPurge_OrderVoid" hint="@Task.OrderWaitPayPurge_OrderVoidHint" clazz="form-field-optionset">
			<div><v:db-checkbox field="cfg.SaleVoidOrder" value="true" caption="@Task.OrderWaitPayPurge_VoidOrderOnSalePurge"/></div>
      <div><v:db-checkbox field="cfg.ExpiredTokensVoidOrder" value="true" caption="@Task.OrderWaitPayPurge_VoidOrderOnTokenExpiration"/></div>
     </v:form-field>
  </v:widget-block>
</v:widget>
--%>	

<script>

function saveTaskConfig(reqDO) {
  var config = {
    TimeoutMins: _getIntValue("#cfg\\.TimeoutMins"),
    SaleVoidOrder: $("#cfg\\.SaleVoidOrder").isChecked(),
    ExpiredTokensVoidOrder: $("#cfg\\.ExpiredTokensVoidOrder").isChecked()
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

