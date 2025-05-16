<%@page import="com.vgs.snapp.dataobject.DOMeasureConversion"%>
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

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMeasureProfile" scope="request"/>
<jsp:useBean id="profile" class="com.vgs.snapp.dataobject.DOMeasureProfile" scope="request"/>
<% JvDataSet dsMeasure = pageBase.getBLDef().getMeasureDS(); %>

<div class="tab-toolbar">
  <v:button caption="@Common.Save" fa="save" onclick="doSaveMeasureProfile()"/>
</div>

<div class="tab-content">
  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="@Common.Code" mandatory="true">
        <v:input-text field="profile.MeasureProfileCode"/>
      </v:form-field>

      <v:form-field caption="@Common.Name" mandatory="true">
        <v:input-text field="profile.MeasureProfileName"/>
      </v:form-field>

      <v:form-field id="base-measure-field" caption="@Product.BaseMeasure" mandatory="true">
      </v:form-field>
    </v:widget-block>
    
    <v:widget-block>
      <v:db-checkbox field="profile.Enabled" value="true" caption="@Common.Active"/>
    </v:widget-block>
  </v:widget>
  
  <v:grid>
    <thead>
      <v:grid-title caption="@Product.MeasureConversionTable"/>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="50%"><v:itl key="@Product.MeasureAltUnit"/></td>
        <%-- <td width="33%"><v:itl key="@Product.MeasureBaseUnit"/></td> --%>
        <td width="50%"><v:itl key="@Product.MeasureBaseQuantity"/></td>
      </tr>
    </thead>
    <tbody id="conversion-body">
    </tbody>
    <tbody>
      <tr>
        <td colspan="100%">
          <v:button caption="@Common.Add" fa="plus" onclick="addConversionRow()"/> 
          <v:button caption="@Common.Remove" fa="minus" onclick="delConversionRows()"/> 
        </td>
      </tr>
    </tbody>
  </v:grid>
</div>

<div id="templates" class="hidden">
  <v:combobox 
      clazz="measure-combo"
      lookupDataSet="<%=dsMeasure%>"
      idFieldName="MeasureId"
      captionFieldName="MeasureName"
      codeFieldName="MeasureCode"
      enabledFieldName="Enabled"
      allowNull="false"/>
</div>

<script>

$(document).ready(function() {
  var cbBaseMeasure = $("#templates .measure-combo").clone().appendTo("#base-measure-field .form-field-value");
  cbBaseMeasure.attr("id", "profile.BaseMeasureId").val(<%=profile.BaseMeasureId.getJsString()%>);
  cbBaseMeasure.find("option.inactive").not("[value='" + cbBaseMeasure.val() + "']").remove();

  <% for (DOMeasureConversion item : profile.MeasureConversionList) { %>
    addConversionRow(<%=item.getJSONString()%>);
  <% } %>
});

function addConversionRow(obj) {
  function _createCombo($td, value) {
    var $combo = $("#templates .measure-combo").clone().appendTo($td);
    var $del = $combo.find("option.inactive");
    if (value) {
      $combo.val(value);
      $del = $del.not("[value='" + value + "']");
    }
    $del.remove();
    return $combo;
  }
  
  obj = (obj) ? obj : {};
  var $tr = $("<tr class='grid-row'/>").appendTo("#conversion-body");
  var $tdChk = $("<td/>").appendTo($tr);
  var $tdAlt = $("<td/>").appendTo($tr);
  //var $tdBas = $("<td/>").appendTo($tr);
  var $tdQty = $("<td/>").appendTo($tr);
  
  _createCombo($tdAlt, obj.AltMeasureId).attr("name", "AltMeasureId");
  //_createCombo($tdBas, obj.BaseMeasureId).attr("name", "BaseMeasureId");
  $("<input type='checkbox' class='cblist'/>").appendTo($tdChk);
  $("<input type='text' class='form-control' name='BaseQuantity'/>").appendTo($tdQty).val((obj.BaseQuantity) ? obj.BaseQuantity : 1);
}

function delConversionRows() {
  $("#conversion-body .cblist:checked").closest("tr").remove();
}

function doSaveMeasureProfile() {
  var reqDO = {
    Command: "SaveMeasureProfile",
    SaveMeasureProfile: {
      MeasureProfile: {
        MeasureProfileId: <%=profile.MeasureProfileId.getJsString()%>,
        MeasureProfileCode: $("#profile\\.MeasureProfileCode").val(),
        MeasureProfileName: $("#profile\\.MeasureProfileName").val(),
        BaseMeasureId: $("#profile\\.BaseMeasureId").val(),
        Enabled: $("#profile\\.Enabled").isChecked(),
        MeasureConversionList: []
      }
    }
  }; 
  
  $("#conversion-body tr").each(function(idx, tr) {
    var $tr = $(tr);
    reqDO.SaveMeasureProfile.MeasureProfile.MeasureConversionList.push({
      AltMeasureId: $tr.find("[name='AltMeasureId']").val(),
      //BaseMeasureId: $tr.find("[name='BaseMeasureId']").val(),
      BaseMeasureId: reqDO.SaveMeasureProfile.MeasureProfile.BaseMeasureId,
      BaseQuantity: $tr.find("[name='BaseQuantity']").val()
    });
  });

  showWaitGlass();
  vgsService("Measure", reqDO, false, function(ansDO) {
    hideWaitGlass();
    entitySaveNotification(<%=LkSNEntityType.MeasureProfile.getCode()%>, ansDO.Answer.SaveMeasureProfile.MeasureProfileId);
  });
}

</script>