<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMeasure" scope="request"/>
<jsp:useBean id="measure" class="com.vgs.snapp.dataobject.DOMeasure" scope="request"/>

<%
boolean systemCode = measure.MeasureCode.getEmptyString().startsWith("#");
boolean canEdit = !systemCode;
%>

<% if (!systemCode) { %>
	<div class="tab-toolbar">
	  <v:button caption="@Common.Save" fa="save" onclick="doSaveMeasure()"/>
	</div>
<% } %>

<div class="tab-content">
  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="@Common.Code" mandatory="true">
        <v:input-text field="measure.MeasureCode" enabled="<%=canEdit%>"/>
      </v:form-field>

      <v:form-field caption="@Common.Name" mandatory="true">
        <v:input-text field="measure.MeasureName" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:db-checkbox field="measure.Enabled" value="true" caption="@Common.Active" enabled="<%=canEdit%>"/>
    </v:widget-block>
  </v:widget>
</div>

<script>

function doSaveMeasure() {
  var reqDO = {
    Command: "SaveMeasure",
    SaveMeasure: {
      Measure: {
        MeasureId: <%=measure.MeasureId.getJsString()%>,
        MeasureCode: $("#measure\\.MeasureCode").val(),
        MeasureName: $("#measure\\.MeasureName").val(),
        Enabled: $("#measure\\.Enabled").isChecked()
      }
    }
  }; 

  showWaitGlass();
  vgsService("Measure", reqDO, false, function(ansDO) {
    entitySaveNotification(<%=LkSNEntityType.Measure.getCode()%>, ansDO.Answer.SaveMeasure.MeasureId);
  });
}

</script>