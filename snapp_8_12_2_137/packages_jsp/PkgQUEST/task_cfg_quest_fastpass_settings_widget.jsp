<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<v:widget caption="@Common.Configuration">
  <v:widget-block>
    <v:alert-box type="info">The inventory of the fast pass event will be dynamically adjusted based on in-park attendance</v:alert-box>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="Fast pass event" hint="The capacity of this event will be adjusted according to in-park attendance" mandatory="true">
      <snp:dyncombo field="cfg.FastPassEventId" entityType="<%=LkSNEntityType.Event%>"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="Attendance location" hint="The location considered for calculating the in-park attendance (redemptions - exit rotations)" mandatory="true">
      <snp:dyncombo field="cfg.AttendanceLocationId" entityType="<%=LkSNEntityType.Location%>"/>
    </v:form-field>
    <v:form-field caption="Attendance percentage" hint="The percentage of the in-park attendance used as capacity for the fast pass event" mandatory="true">
      <v:input-text field="cfg.AttendancePercentage"/>
    </v:form-field>
    <v:form-field caption="Minimum capacity" hint="Used insteand of the attendance percencentage when in-park attendance is low" mandatory="true">
      <v:input-text field="cfg.MinimumCapacity"/>
    </v:form-field>
  </v:widget-block>
</v:widget>
<script>

$(document).ready(function() {
	var $percField = $("#cfg\\.AttendancePercentage"); 
	$percField.val(formatPercValue($percField.val()));
});
	
function convertValue(value) {
  var result = null;
  value = value.replace("%", "");
  value = value.replace(",", ".");
  if (value != "") {
    result = parseFloat(value);
    if (isNaN(result))
      result = null;
  }
  return result;
}	

function formatPercValue(value) {
  var result = value;
	if (value) 
	  if (value.indexOf("%") == -1) 
	    result = value + "%";
  return result;
}

function saveTaskConfig(reqDO) {
	var attendancePerc = convertValue($("#cfg\\.AttendancePercentage").val());
  var config ={
      FastPassEventId      : $("#cfg\\.FastPassEventId").val(),
      AttendanceLocationId : $("#cfg\\.AttendanceLocationId").val(),
      AttendancePercentage : attendancePerc,
      MinimumCapacity      : $("#cfg\\.MinimumCapacity").val()
  };
  
  reqDO.TaskConfig = JSON.stringify(config);
}
</script>
