<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" scope="request" class="com.vgs.snapp.web.common.page.PageCommonWidget"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="task" class="com.vgs.snapp.dataobject.DOTask" scope="request"/>
<jsp:useBean id="cfg" class="com.vgs.snapp.dataobject.task.DOTask_DataExport" scope="request"/>
<% LookupItem docEditorType = pageBase.getBL(BLBO_DocTemplate.class).getDocEditorType(cfg.DocTemplateId.getString()); %>

<div class="tab-content">

  <v:widget caption="@Common.Options">
    <v:widget-block>
      <v:form-field caption="@Task.PurgeDays" hint="@Task.PurgeDaysHint">
        <v:input-text field="task.PurgeDays" placeholder="@Task.AsDefault"/>
      </v:form-field>
      <v:form-field caption="@Common.Language">
        <select id="cfg.LangISO" name="cfg.LangISO" class="form-control"><%=pageBase.getBL(BLBO_Lang.class).getLangOptions(cfg.LangISO.getString(), rights.LangISO.getString(), true)%></select>
      </v:form-field>
    </v:widget-block>
    <% if (docEditorType.isLookup(LkSNDocEditorType.DataExport)) { %>
      <v:widget-block>
        <v:form-field caption="@Common.Format">
          <label class="checkbox-label"><input type="radio" name="OutputFormat" value="<%=SnappUtils.DOC_FORMAT_CSV%>"/> CSV</label>
          &nbsp;&nbsp;&nbsp;
          <label class="checkbox-label"><input type="radio" name="OutputFormat" value="<%=SnappUtils.DOC_FORMAT_EXCEL%>"/> Excel</label>
        </v:form-field>
      </v:widget-block>
      <v:widget-block id="csv-options" clazz="hidden">
        <v:form-field caption="@DocTemplate.CSV_FieldDelimiter" hint="@DocTemplate.CSV_FieldDelimiterHint">
          <v:input-text field="cfg.FieldDelimiter"/>
        </v:form-field>
        <v:form-field caption="@DocTemplate.CSV_QuoteCharacter" hint="@DocTemplate.CSV_QuoteCharacterHint">
          <v:input-text field="cfg.QuoteCharacter"/>
        </v:form-field>
        <v:form-field>
          <v:db-checkbox field="cfg.IncludeHeaderLine" value="true" caption="@DocTemplate.CSV_IncludeHeaderLine"/>
          <v:db-checkbox field="cfg.IncludeBOM" value="true" caption="@DocTemplate.CSV_IncludeBOM" hint="@DocTemplate.CSV_IncludeBOMHint"/>
        </v:form-field>
      </v:widget-block>
    <% } %>
    <v:widget-block>
      <v:form-field caption="MD5" hint="@Task.GenerateMD5Hint">
        <v:db-checkbox field="cfg.GenerateMD5" caption="@Task.GenerateMD5" value="true"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="@Task.NotifyOnData" hint="@Task.NotifyOnDataHint">
        <v:db-checkbox field="cfg.NotifyOnData" caption="" value="true"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>

  <v:widget caption="@Common.FileName">
    <v:widget-block>
      <v:form-field checkBoxField="cfg.UseFileNameFormula" caption="@Task.FileNameFormula" hint="@Task.FileNameFormulaHint">
        <v:input-text field="cfg.FileNameFormula" placeholder="@Common.Default"/>
      </v:form-field>
    </v:widget-block>
    
    <v:widget-block id="export_filename_options" clazz="hidden">
      <strong><v:itl key="@Common.Options"/></strong> <v:hint-handle hint="@Task.FileNameRulesHint"/>
      <v:form-field caption="@Common.FileName" hint="@Task.FileNameOptionHint" >
        <v:input-text field="cfg.FileName" placeholder="@Common.Default"/>
      </v:form-field>
      <v:form-field caption="@Task.FilterDateOption" hint="@Task.FilterDateOptionHint" multiCol="true"> 
        <v:multi-col caption="Value">
	        <v:combobox 
	           field="cfg.FileNameParamId"
	           lookupDataSet="<%=pageBase.getBL(BLBO_DocTemplate.class).getDateDocParamsDS(cfg.DocTemplateId.getString())%>"
	           idFieldName="DocParamId"
	           captionFieldName="DocParamCaptionITL"
	         />
        </v:multi-col>
        <v:multi-col caption="@Common.Format" id="filter-date-format">
          <v:lk-combobox allowNull="false" field="cfg.FileNameDateFormat" lookup="<%=LkSN.ExportFileNameDateFormat%>"/>
        </v:multi-col>
      </v:form-field>
      <v:form-field caption="@Task.AddExecutionDateTime" hint="@Task.AddExecutionDateTimeHint">
        <v:lk-combobox field="cfg.FileNameOption" lookup="<%=LkSN.ExportFileNameOption%>"/>
      </v:form-field>
      <v:form-field caption="@Task.SequenceDigits" hint="@Task.SequenceDigitsHint">
        <v:input-text field="cfg.SequenceDigits" placeholder="@Task.SequenceDigitsPlaceholder"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>

</div>

<script>
$(document).ready(function() {
  var $outputFormat = $("[name='OutputFormat']");
  var $useFileNameFormula = $("[name='cfg\\.UseFileNameFormula']");
  var $fileNameParamId = $("#cfg\\.FileNameParamId");
  
  setRadioChecked($outputFormat, <%=JvString.jsString(cfg.OutputFormat.isNull(SnappUtils.DOC_FORMAT_CSV))%>);
  
  $outputFormat.click(enableDisable);
  $useFileNameFormula.click(enableDisable);
  $fileNameParamId.change(enableDisable);
  
  enableDisable();
  
  function enableDisable() {
    $("#csv-options").setClass("hidden", $outputFormat.filter(":checked").val() != "<%=SnappUtils.DOC_FORMAT_CSV%>");
    $("#export_filename_options").setClass("hidden", $useFileNameFormula.isChecked());
    $("#filter-date-format").setClass("hidden", getNull($fileNameParamId.val()) == null);
  }
});
</script>