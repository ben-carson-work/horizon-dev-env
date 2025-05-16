<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
  String maskerableFieldId = pageBase.getNullParameter("FieldId");
  boolean isNew = maskerableFieldId == null;

  BLBO_Masking bl = pageBase.getBL(BLBO_Masking.class);
  DOMaskingFieldConfig maskingItem;
  
  if (isNew)
    maskingItem = new DOMaskingFieldConfig();
  else
    maskingItem = bl.loadMetaFieldMasking(maskerableFieldId); 

  request.setAttribute("maskingItem", maskingItem);
  request.setAttribute("masking", maskingItem.Masking);
  
  List<DOMaskerableField> maskerableFieldList = MaskingUtils.getMaskerableFieldList();
%>

<v:dialog id="maskerable_field_dialog" title="@Masking.Masking" width="600" height="500" autofocus="false">
  <v:widget caption="@Masking.Masking">
    <v:widget-block>
      <v:form-field caption="@Common.Field">
        <%
          String sDisabled = "";
          if (!isNew)
            sDisabled = " disabled";
        %>
        <select id="maskingItem.FieldId" class="form-control" <%=sDisabled%>>
        <% for (DOMaskerableField field : maskerableFieldList) { %>
          <% String com = field.FieldDescription.getHtmlString(); %>
          <% String value = field.FieldId.getString() + "";%>
          <% String sel = JvString.isSameText(value, maskingItem.FieldId.getString()) ? "selected" : ""; %>
          <option value="<%=value%>" <%=sel%>><%=com%></option>
        <% } %>
        </select>
      </v:form-field>
    </v:widget-block>
  
    <v:widget-block>
      <v:form-field caption="@Masking.MaskingRule" hint="@Masking.MaskingRuleHint">
        <v:lk-combobox field="masking.MaskingRule" lookup="<%=LkSN.TextMaskingType%>" allowNull="false"/>
      </v:form-field>
      <v:form-field caption="@Masking.UnmaskedStartChars" hint="@Masking.UnmaskedStartCharsHint" mandatory="false" id="unmasked-start-chars">
        <v:input-text field="masking.UnmaskedStartChars" type="number" min="1"/>
      </v:form-field>
      <v:form-field caption="@Masking.UnmaskedEndChars" hint="@Masking.UnmaskedEndCharsHint" mandatory="false" id="unmasked-end-chars">
        <v:input-text field="masking.UnmaskedEndChars" type="number" min="1"/>
      </v:form-field>
      <v:form-field caption="@Masking.SplitWords" hint="@Masking.SplitWordsHint" mandatory="false" id="masked-split-words">
        <v:db-checkbox field="masking.SplitWords" caption="" value="true"/>
      </v:form-field>
      <v:form-field caption="@Masking.MaskedMinChars" hint="@Masking.MaskedMinCharsHint" mandatory="false" id="masked-min-chars">
        <v:input-text field="masking.MaskedMinChars" type="number" min="1"/>
      </v:form-field>
      <v:form-field caption="@Masking.MaskedMinCharsAlign" hint="@Masking.MaskedMinCharsAlignHint" id="masked-min-chars-align">
        <v:lk-combobox field="masking.MaskedMinCharsAlign" lookup="<%=LkSN.TextMaskingAlignType%>" allowNull="false"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>


<script>
var dlg = $("#maskerable_field_dialog");

$("#masking\\.MaskingRule").change(refreshMasking);
refreshMasking();

$(document).ready(function() {
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
      <v:itl key="@Common.Save" encode="JS"/>: doSaveMaskerableField,
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    };
  });

});

function refreshMasking() {
  var mr = $("#masking\\.MaskingRule").val();

  $("#unmasked-start-chars").addClass("hidden");
  $("#unmasked-end-chars").addClass("hidden");
  $("#masked-split-words").addClass("hidden");
  $("#masked-min-chars").addClass("hidden");
  $("#masked-min-chars-align").addClass("hidden");

  if (mr == <%=LkSNTextMaskingType.General.getCode()%>) {
    $("#unmasked-start-chars").removeClass("hidden");
    $("#unmasked-end-chars").removeClass("hidden");
    $("#masked-split-words").removeClass("hidden");
    $("#masked-min-chars").removeClass("hidden");
    $("#masked-min-chars-align").removeClass("hidden");
  }
}

function doSaveMaskerableField() {
  var reqDO = {
      Command: "SaveFieldMasking",
      SaveFieldMasking: {
        FieldId: $("#maskingItem\\.FieldId").val(),
        Masking: {
            MaskingRule: $("#masking\\.MaskingRule").val(),
            UnmaskedStartChars: $("#masking\\.UnmaskedStartChars").val(),
            UnmaskedEndChars: $("#masking\\.UnmaskedEndChars").val(),
            SplitWords: $("#masking\\.SplitWords").isChecked(),
            MaskedMinChars: $("#masking\\.MaskedMinChars").val(),
            MaskedMinCharsAlign: $("#masking\\.MaskedMinCharsAlign").val()
        }
    }
  };

  vgsService("MetaData", reqDO, false, function(ansDO) {
    triggerEntityChange(<%=LkSNEntityType.FieldMaskingRule.getCode()%>);
    dlg.dialog("close");
  });
}

</script>

</v:dialog>

