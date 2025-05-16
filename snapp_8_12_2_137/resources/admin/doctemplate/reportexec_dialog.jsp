<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" scope="request" class="com.vgs.snapp.web.common.page.PageCommonWidget"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% DOReportExecDialog model = pageBase.getBL(BLBO_DocTemplate.class).getReportExecDialogDO(pageBase.getId()); %>

<v:dialog id="reportexec_dialog" title="<%=model.DialogTitle.getString()%>" autofocus="false"  width="600">
<form id="docproc_form" action="<%=pageBase.getContextURL()%>?page=docproc" method="post" target="_blank">
  <input type="hidden" name="DocTemplateId" value="<%=pageBase.getId()%>" />
  
  <v:widget>
    <v:widget-block include="<%=model.DataSourceSelectionVisible.getBoolean()%>">
      <v:form-field caption="@Common.DataSource">
        <snp:dyncombo 
            name="DataSourceId"
            entityType="<%=LkSNEntityType.DataSource%>" 
            entityId="<%=model.DocTemplate.DataSourceId.getString()%>"
            allowNull="false"  
            enabled="<%=model.DocTemplate.DataSourceSelection.getBoolean()%>"/>
      </v:form-field>
    </v:widget-block>

    <v:widget-block include="<%=model.DocTemplate.ParamList.isEmpty()%>">
      <div class="list-subtitle">No parameters</div>
    </v:widget-block>  

    <v:widget-block include="<%=!model.DocTemplate.ParamList.isEmpty()%>">
    <% for (DODocTemplate.DODocParam paramDO : model.DocTemplate.ParamList) { %>
      <%
      String paramCaption = paramDO.DocParamCaption.isNull(paramDO.DocParamName.getString()); 
      String defaultValue = pageBase.getBL(BLBO_DocTemplate.class).decodeParamDefaultValue(paramDO.DocParamDefault.getString());
      LookupItem dynComboEntityType = MetaDataUtils.findEntityTypeByFieldDataType(paramDO.DocParamType.getLkValue());
      boolean mandatory = paramDO.Mandatory.getBoolean();
      boolean readOnly = false;
      boolean visible = true;
      String paramName = "p_" + paramDO.DocParamName.getHtmlString();
      if (paramDO.DocParamType.isLookup(LkSNMetaFieldDataType.EntityChangeId, LkSNMetaFieldDataType.LastUpdate) && !rights.VGSSupport.getBoolean())
        visible = false;
      else if (paramDO.DocParamType.isLookup(LkSNMetaFieldDataType.Organization) && pageBase.isVgsContext("B2B")) {
        readOnly = true;
        defaultValue = pageBase.getSession().getOrgAccountId();
      }
      else if (pageBase.hasParameter(paramName)) {
        readOnly = pageBase.isParameter("lock_in_params", "true");
        defaultValue = pageBase.getParameter(paramName);
        visible = !paramDO.DocParamType.isLookup(LkSNMetaFieldDataType.Text) || !JvUtils.isValidUUID(defaultValue);
      }
      else {
        for (Cookie c : request.getCookies()) {
          if (paramName.equalsIgnoreCase(c.getName())) {
            defaultValue = JvString.urlDecode(c.getValue());
            break;
          }
        }
      }
      request.setAttribute(paramName, defaultValue);
      
      String sReadOnly = readOnly ? " readonly=\"readonly\"" : "";
      String sDisabled = readOnly ? " disabled=\"disabled\"" : "";
      %>
      <div class="<%=visible?"":"v-hidden"%>">
        <v:form-field caption="<%=paramCaption%>" mandatory="<%=(paramDO.DocParamType.isLookup(LkSNMetaFieldDataType.Date) && (model.DocTemplate.MaxDateRangeDays.getInt() > 0)) ?  true : mandatory%>">
          <% if (paramDO.DocParamType.isLookup(LkSNMetaFieldDataType.Text, LkSNMetaFieldDataType.Numeric, LkSNMetaFieldDataType.EntityChangeId)) { %>
            <input type="text" class="param-item form-control" name="<%=paramName%>" value="<%=JvString.getEmpty(defaultValue)%>" <%=sReadOnly%>>
          <% } else if (paramDO.DocParamType.isLookup(LkSNMetaFieldDataType.Date)) { %>
            <%
            String datePickerClass = "param-item ";
            datePickerClass += paramName.indexOf("DateFrom") >= 0 ? "range-field-from" : paramName.indexOf("DateTo") >= 0 ? "range-field-to" : ""; 
            %>
            <v:input-text type="datepicker" clazz="<%=datePickerClass%>" field="<%=paramName%>" enabled="<%=!readOnly%>" />
          <% } else if (paramDO.DocParamType.isLookup(LkSNMetaFieldDataType.DateTime, LkSNMetaFieldDataType.LastUpdate)) { %>
            <v:input-text type="datetimepicker" clazz="param-item" field="<%=paramName%>" enabled="<%=!readOnly%>"/>
          <% } else if (paramDO.DocParamType.isLookup(LkSNMetaFieldDataType.Boolean)) { %>
            <label><input type="radio" class="param-item" name="<%=paramName%>" value="true" <%=sReadOnly%>/> <v:itl key="@Common.Yes"/></label>
            &nbsp;
            <label><input type="radio" class="param-item" name="<%=paramName%>" value="false" <%=sReadOnly%>/> <v:itl key="@Common.No"/></label>
          <% } else if (paramDO.DocParamType.isLookup(LkSNMetaFieldDataType.Location)) { %>
            <snp:dyncombo 
                entityType="<%=LkSNEntityType.Location%>"
                entityId="<%=defaultValue%>" 
                auditLocationFilter="true" 
                allowNull="<%=rights.AuditLocationFilter.isLookup(LkSNAuditLocationFilter.All) && !mandatory%>"
                field="<%=paramName%>" 
                enabled="<%=!readOnly%>"
                clazz="param-item"
            />
          <% } else if (paramDO.DocParamType.isLookup(LkSNMetaFieldDataType.OpArea)) { %>
            <snp:dyncombo 
                entityType="<%=LkSNEntityType.OperatingArea%>"
                entityId="<%=defaultValue%>" 
                auditLocationFilter="true" 
                allowNull="<%=!mandatory%>"
                field="<%=paramName%>" 
                enabled="<%=!readOnly%>"
                parentComboId="p_LocationId"
                clazz="param-item"
            />
          <% } else if (paramDO.DocParamType.isLookup(LkSNMetaFieldDataType.AccessArea)) { %>
            <snp:dyncombo 
                entityType="<%=LkSNEntityType.AccessArea%>"
                entityId="<%=defaultValue%>" 
                auditLocationFilter="true" 
                allowNull="<%=!mandatory%>"
                field="<%=paramName%>" 
                enabled="<%=!readOnly%>"
                parentComboId="p_LocationId"
                clazz="param-item"
            />
          <% } else if (paramDO.DocParamType.isLookup(LkSNMetaFieldDataType.Workstation)) { %>
            <snp:dyncombo 
                entityType="<%=LkSNEntityType.Workstation%>"
                entityId="<%=defaultValue%>" 
                auditLocationFilter="true" 
                allowNull="<%=!mandatory%>"
                field="<%=paramName%>" 
                enabled="<%=!readOnly%>"
                parentComboId="p_OpAreaId"
                clazz="param-item"
            />
          <% } else if (dynComboEntityType != null) { %>
            <snp:dyncombo 
                entityType="<%=dynComboEntityType%>"
                entityId="<%=defaultValue%>" 
                allowNull="<%=!mandatory%>"
                field="<%=paramName%>" 
                enabled="<%=!readOnly%>"
                clazz="param-item"
            />
          <% } else if (paramDO.DocParamType.isLookup(LkSNMetaFieldDataType.SiaePerformance)) { %>
            <snp:dyncombo 
                entityType="<%=LkSNEntityType.SiaePerformance%>"
                entityId="<%=defaultValue%>" 
                auditLocationFilter="true" 
                allowNull="<%=!mandatory%>"
                field="<%=paramName%>" 
                enabled="<%=!readOnly%>"
                clazz="param-item"
            />
          <% } else { %>
            <I>   [<%=paramDO.DocParamType.getInt()%>] <%=paramDO.DocParamType.getHtmlLookupDesc(pageBase.getLang())%></I>
          <% } %>
        </v:form-field>
      </div>
    <% } %>
    </v:widget-block>
    
    <v:widget-block include="<%=model.DocTemplate.DocEditorType.isLookup(LkSNDocEditorType.DataExport)%>">
      <v:form-field caption="@Common.Format">
        <label class="checkbox-label"><input type="radio" name="OutputFormat" value="<%=SnappUtils.DOC_FORMAT_CSV%>"/> CSV</label>
        &nbsp;&nbsp;&nbsp;
        <label class="checkbox-label"><input type="radio" name="OutputFormat" value="<%=SnappUtils.DOC_FORMAT_EXCEL%>"/> Excel</label>
        &nbsp;&nbsp;&nbsp;
        <label class="checkbox-label"><input type="radio" name="OutputFormat" value="<%=SnappUtils.DOC_FORMAT_PDF%>"/> PDF</label>
      </v:form-field>
      <div id="csv-options" class="hidden">
        <v:form-field caption="@DocTemplate.CSV_FieldDelimiter" hint="@DocTemplate.CSV_FieldDelimiterHint">
          <input type="text" id="CSV_FieldDelimiter"name="CSV_FieldDelimiter" class="form-control"/>
        </v:form-field>
        <v:form-field caption="@DocTemplate.CSV_QuoteCharacter" hint="@DocTemplate.CSV_QuoteCharacterHint">
          <input type="text" id="CSV_QuoteCharacter" name="CSV_QuoteCharacter" class="form-control"/>
        </v:form-field>
        <v:form-field clazz="form-field-optionset">
          <div><v:db-checkbox field="CSV_IncludeHeaderLine" value="true" caption="@DocTemplate.CSV_IncludeHeaderLine"/></div>
          <div><v:db-checkbox field="CSV_IncludeBOM" value="true" caption="@DocTemplate.CSV_IncludeBOM" hint="@DocTemplate.CSV_IncludeBOMHint"/></div>
        </v:form-field>
      </div>

      <script>
        var outputFormat = getCookie("ReportExecOutputFormat");
        var radio = $("[name='OutputFormat'][value='" + outputFormat + "']");
        if (radio.length == 0)
          radio = $("[name='OutputFormat'][value='CSV']");
        radio.setChecked(true);
        
        $("#CSV_FieldDelimiter").val(getCookie("CSV_FieldDelimiter"));
        $("#CSV_QuoteCharacter").val(getCookie("CSV_QuoteCharacter"));
        $("#CSV_IncludeHeaderLine").setChecked(getCookie("CSV_IncludeHeaderLine") != "false");
        
        function enableDisableCsvOptions() {
          $("#csv-options").setClass("hidden", !$("[name='OutputFormat'][value='CSV']").isChecked());
        }
        
        $("[name='OutputFormat']").click(enableDisableCsvOptions);
        enableDisableCsvOptions();
      </script>
    </v:widget-block>  
  </v:widget>
  
</form>


<script>
var $dlg = $("#reportexec_dialog");
$dlg.on("snapp-dialog", function(event, params) {
  params.buttons = [
    {
      text: itl("@Common.Generate"),
      click: function() {
        checkRequired("#docproc_form" , function() { 
          checkDateRange(function() {
            checkOrganizations(doGenerate)
          })
        });
      }
    },
    {
      text: itl("@Common.Cancel"),
      click: doCloseDialog
    }
  ]; 
});

function doGenerate() {
  $("#docproc_form").submit();
  $dlg.dialog("close");
}

function checkOrganizations(callback) {
  var $combos = $dlg.find(".param-item.v-dyncombo[data-entitytype='1']");
  checkOrganizationsLoop($combos, callback)
}

function checkOrganizationsLoop(elems, callback) {
  if (elems.length == 0) {
    hideWaitGlass();
    callback();
  }
  else {
    var $elem = $(elems[0]);
    if (getNull($elem.val()) == null) {
      elems.splice(0, 1);
      checkOrganizationsLoop(elems, callback);
    }
    else {
      var reqDO = {
        Command: "ActionInfo",
        ActionInfo: {
          AccountList: [{AccountId: $elem.val()}]
        }
      };
      
      vgsService("Account", reqDO, false, function(ansDO) {
        var info = ansDO.Answer.ActionInfo.AccountList[0];
        if (info.RightLevel < <%=LkSNRightLevel.Read.getCode()%>) {
          hideWaitGlass();
          showMessage(itl("@Common.InsufficientRights"));
        }
        else {
          elems.splice(0, 1);
          checkOrganizationsLoop(elems, callback);
        }
      }); 
    }
  }
}

function checkDateRange(callback) {
  var _MS_PER_DAY = 1000 * 60 * 60 * 24;
  var err = false;
  var stringFrom = null;
  var objTo = null;
  var maxDateRangeDays = <%=model.DocTemplate.MaxDateRangeDays.getInt()%>;

  if (maxDateRangeDays > 0) {
    stringFrom = $(".range-field-from").val();
    
    if (stringFrom != null && stringFrom.length > 0) {
      var dataFrom = new Date(stringFrom.split("/").reverse().join("-"));
      objTo = $(".range-field-to"); 
      if (objTo != null && objTo.val() != null && objTo.val().length > 0) {
        var dataTo = new Date(objTo.val().split("/").reverse().join("-"));
        
        var diff = ((dataTo.getTime() - dataFrom.getTime()) / _MS_PER_DAY) + 1;
        
        if(diff < 0)
          err = true;
        else if(diff > maxDateRangeDays)
          err = true;	
      }
      else
        err = true;
    }
    else 
      err = true;
  }
    	
  if (err) {
    showMessage(itl("@Common.MaxDateRangeDaysExceeded"), function() {
      objTo.focus();
    });
  } 
  else if (callback)
    callback();
}
	
</script>
</v:dialog>