<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<jsp:useBean id="settings" class="com.vgs.entity.dataobject.DOPlgSettings_EpsonWinPrinter" scope="request"/>
                                                          
<v:widget caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
    <v:form-field caption="@Common.Name">
      <v:input-text field="settings.PrinterName"/>
    </v:form-field>
    <v:form-field caption="Timeout (sec.)" hint="Print job timeout in seconds">
      <v:input-text field="settings.JobTimeout" placeholder="30" type="number"/>
    </v:form-field>
    <v:form-field caption="Unit of Measure">
      <select id="settings.UnitOfMeasure" class="form-control">
        <option value=0>Inch</option>
        <option value=1>mm</option>
      </select>        
    </v:form-field>
    <v:form-field caption="Receipt width" hint="Paper width size in the selected unit of measure, it must be a valid printer driver paper width value">
      <v:input-text field="settings.ReceiptWidth" placeholder="2.84inch" type="number" />
    </v:form-field>
    <v:form-field caption="Receipt height" hint="Paper height size in the selected unit of measure, it must be a valid printer driver paper height value">
      <v:input-text field="settings.ReceiptHeight" placeholder="120.00inch" type="number" />
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>

$(document).ready(function() {
	$("#settings\\.UnitOfMeasure").val(<%=settings.getChildField("UnitOfMeasure").getInt()%>);
	enableDisableMeasure();
});

$("#settings\\.UnitOfMeasure").change(enableDisableMeasure);

function enableDisableMeasure() {
  var inter = $("#settings\\.UnitOfMeasure").val();
  if (inter == 0){//inch
	$("#settings\\.ReceiptWidth").attr("placeholder", "2.84inch");
	$("#settings\\.ReceiptHeight").attr("placeholder", "120.00inch");
  }
  else{//mm
	$("#settings\\.ReceiptWidth").attr("placeholder", "80mm");
	$("#settings\\.ReceiptHeight").attr("placeholder", "3276mm");
  }
}

function getPluginSettings() {
  return {
    PrinterName: $("#settings\\.PrinterName").val(),
    ReceiptWidth: $("#settings\\.ReceiptWidth").val(),
    ReceiptHeight: $("#settings\\.ReceiptHeight").val(),
    UnitOfMeasure: $("#settings\\.UnitOfMeasure").val(),
    JobTimeout: $("#settings\\.JobTimeout").val()
  };
}

</script>
