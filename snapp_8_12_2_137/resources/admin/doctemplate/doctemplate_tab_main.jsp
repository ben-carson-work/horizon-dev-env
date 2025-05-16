<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageDocTemplate" scope="request"/>
<jsp:useBean id="doc" class="com.vgs.web.dataobject.DOUI_DocTemplate" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
FtCRUD docRightCRUD = pageBase.getBLDef().getDocRightCRUD(doc);
request.setAttribute("docRightCRUD", docRightCRUD);

boolean canEdit = pageBase.isNewItem() ? docRightCRUD.canCreate() : docRightCRUD.canUpdate();
boolean readOnly = (!rights.VGSSupport.getBoolean() && (!doc.SystemCode.isNull() || (docRightCRUD.canRead() && !docRightCRUD.canUpdate() && !docRightCRUD.canDelete()))); 
String sReadOnly = canEdit ? "" : "disabled=\"disabled\"";

boolean showParams = (doc.DocTemplateType.isLookup(LkSNDocTemplateType.StatReport) || doc.DocEditorType.isLookup(LkSNDocEditorType.Report)) && !doc.DocTemplateType.isLookup(LkSNDocTemplateType.Invoice);
@SuppressWarnings("deprecation")
LookupItem lkMediaVirtual = LkSNDocEditorType.MediaVirtual;
boolean showDrivers = doc.DocEditorType.isLookup(LkSNDocEditorType.Receipt, LkSNDocEditorType.VoucherFGL, LkSNDocEditorType.MediaFGL, LkSNDocEditorType.MediaSNP, LkSNDocEditorType.MediaGift, LkSNDocEditorType.Phone, lkMediaVirtual);
boolean showGraphicEditor = pageBase.getBLDef().hasGraphicEditor(doc);
%>

<v:tab-toolbar>
  <v:button fa="save" caption="@Common.Save" href="javascript:doSave()" enabled="<%=canEdit%>"/>
  <% if (!pageBase.isNewItem()) { %>
    <% if (showGraphicEditor) {%>
      <span class="divider"></span>
      <v:button caption="@Common.Layout" fa="ruler-triangle" onclick="doOpenGraphicEditor()" enabled="<%=!readOnly%>"/>
    <% } %>
    <snp:notes-btn entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.Catalog%>"/>

    <v:button-group>
      <v:button caption="@Common.Import" fa="sign-in" onclick="showImportDialog()" enabled="<%=!readOnly%>"/>
      <% String hrefExport = ConfigTag.getValue("site_url") + "/admin?page=doctemplate&action=export&id=" + pageBase.getId(); %>
      <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" href="<%=hrefExport%>"/>
    </v:button-group>
    
    <% if (doc.DocTemplateType.isLookup(LkSNDocTemplateType.StatReport)) { %>
      <v:button caption="@Common.Generate" fa="download" onclick="showExecutorDialog()" />
    <% } %>
  <% } %>
</v:tab-toolbar>

<v:tab-content id="doctemplate-tab-main">
  <% if (doc.DocTemplateType.isLookup(LkSNDocTemplateType.AdvancedNotification)) { %>
    <v:alert-box type="info">
      <p>An <b>advanced notification</b> allows to send an email to a list of recipients dynamically obtained through e query.</p>
      <p>
        The <b>queries</b> tab is expected to have 1 query only.<br/>
        If the query contains the field <b>AccountId</b> (optional), the email will be linked to that account and will be visible on the account's back-office page.<br/>
      </p> 
      <p>
        Any other field returned by the query can be used to fill the template.<br/>
        The syntax for using query's field in the template is: <b>[@<i>QueryName</i>.<i>FieldName</i>]</b> (example: [@Default.EmailAddress].)
        
      </p>
    </v:alert-box>
  <% } %>
  
  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="@Common.Code" mandatory="true">
        <v:input-text field="doc.DocTemplateCode" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Common.Name" mandatory="true">
        <v:input-text field="doc.DocTemplateName" enabled="<%=canEdit%>"/>
      </v:form-field>
      <% if (doc.DocTemplateType.isLookup(LkSNDocTemplateType.StatReport)) { %>
        <v:form-field caption="@Category.Category"><v:combobox field="doc.CategoryId" idFieldName="CategoryId" captionFieldName="AshedCategoryName" lookupDataSet="<%=pageBase.getBL(BLBO_Category.class).getCategoryAshedTreeDS(LkSNEntityType.DocTemplate)%>" allowNull="false" enabled="<%=canEdit%>"/></v:form-field>
        <v:form-field caption="@Common.MaxDateRangeDays" hint="@Common.MaxDateRangeDaysHint">
        <v:input-text field="doc.MaxDateRangeDays" placeholder="@Common.Unlimited" enabled="<%=canEdit%>" />
      </v:form-field>
      <% } %>
      <% if (doc.DocTemplateType.isLookup(LkSNDocTemplateType.Media) && !doc.DocEditorType.isLookup(LkSNDocEditorType.MediaGift)) { %>
        <v:form-field caption="@Common.MediaCashoutInvalidate">
          <v:lk-combobox field="doc.MediaCashoutOption" lookup="<%=LkSN.MediaCashoutOption%>" allowNull="false" enabled="<%=rights.DocMedias.canUpdate()%>"/>
        </v:form-field>
        <v:form-field caption="@Common.MediaRfidOptionType">
          <v:lk-combobox field="doc.MediaRfidOptionType" lookup="<%=LkSN.MediaRfidOptionType%>" allowNull="false" hideItems="<%=doc.DocEditorType.isLookup(LkSNDocEditorType.MediaInput) ? null : LookupManager.getArray(LkSNMediaRfidOptionType.UseOnlyRfid)%>" enabled="<%=rights.DocMedias.canUpdate()%>"/>
        </v:form-field>
        <v:form-field caption="@Common.MediaEncoderPlugin">
          <v:combobox field="doc.MediaEncoderPluginId" lookupDataSet="<%=pageBase.getBL(BLBO_Plugin.class).getPluginDS(null, LkSNDriverType.MediaEncoder)%>" captionFieldName="PluginDisplayName" idFieldName="PluginId" linkEntityType="<%=LkSNEntityType.Plugin%>" enabled="<%=canEdit%>"/>
        </v:form-field>
      <% } %>
    </v:widget-block>
    <v:widget-block>
      <v:form-field>
        <div><v:db-checkbox field="doc.DocEnabled" caption="@Common.Enabled" value="true" enabled="<%=canEdit%>"/></div>
      </v:form-field>
    </v:widget-block>
    
    <% if (doc.DocTemplateType.isLookup(LkSNDocTemplateType.StatReport)) { %>
      <v:widget-block>
        <div class="form-field">
          <div class="form-field-caption">
          <% if (readOnly) { %>
            Contexts
          <% } else { %>
            <v:button caption="Contexts" href="javascript:showContextDialog()"/>
          <% } %>
          </div>
          <div id="doc-context-container" class="form-field-value"></div>
        </div>
      </v:widget-block>

      <% JvDataSet dsDataSource = pageBase.getBL(BLBO_DataSource.class).getDataSourceDS(LkSNDataSourceType.Reporting); %>
      <% if (!dsDataSource.isEmpty()) { %>
	      <v:widget-block>
	        <v:form-field caption="@DocTemplate.DefaultDataSource">
	          <v:combobox field="doc.DataSourceId" lookupDataSet="<%=dsDataSource%>" captionFieldName="DataSourceName" idFieldName="DataSourceId" allowNull="true" enabled="<%=canEdit%>"/>
	        </v:form-field>
	        <v:form-field>
	          <v:db-checkbox field="doc.DataSourceSelection" value="true" caption="@DocTemplate.DataSourceSelection" enabled="<%=canEdit%>"/>
	        </v:form-field>
	      </v:widget-block>
      <% } %> 

      <v:widget-block>
        <v:form-field clazz="form-field-optionset">
          <v:db-checkbox field="doc.ExecRequireLogin" caption="@DocTemplate.UserAuthRequired" value="true" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
    <% } %>

    <% if (doc.DocEditorType.isLookup(LkSNDocEditorType.MediaInput)) { %>
      <v:widget-block>
        <v:form-field clazz="form-field-optionset">
          <% DODocTemplateMediaInput mediainput = JvDocument.createByJSON(DODocTemplateMediaInput.class, doc.DocData.getString()); %>
          <v:db-checkbox field="AllowMediaGeneration" caption="@Common.AllowMediaGeneration" value="true" checked="<%=mediainput.AllowMediaGeneration.getBoolean()%>" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
    <% } %>
  </v:widget>
    
  <% if (doc.DocTemplateType.isLookup(LkSNDocTemplateType.OrderConfirmation) && doc.DocEditorType.isLookup(LkSNDocEditorType.Email)) { %>
    <v:widget caption="@Common.Options">
      <v:widget-block>
        <v:form-field caption="@DocTemplate.ProductDocumentTags" hint="@DocTemplate.ProductDocumentTagsHint">
          <% JvDataSet dsDocTags = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.Repository); %>
          <v:multibox field="doc.ProductDocumentTagIDs" lookupDataSet="<%=dsDocTags%>" idFieldName="TagId" captionFieldName="TagName"/>
        </v:form-field>
        <v:form-field caption="@DocTemplate.AttachReports" hint="@DocTemplate.AttachReportsHint">
          <% JvDataSet dsRPT = pageBase.getBL(BLBO_DocTemplate.class).getDocTemplateDS(LkSNDocTemplateType.StatReport); %>
          <v:multibox field="doc.AttachDocTemplateIDs"  lookupDataSet="<%=dsRPT%>" idFieldName="DocTemplateId" captionFieldName="DocTemplateName"/>
        </v:form-field>
      </v:widget-block>
      <v:widget-block>
        <v:form-field caption="@DocTemplate.OrderStatus" clazz="form-field-optionset">
          <div><v:db-checkbox field="doc.SaleForApproval" caption="@Reservation.Status_ForApproval" value="true" enabled="<%=canEdit%>"/></div>
          <div><v:db-checkbox field="doc.SaleOpen" caption="@Reservation.Status_Open" value="true" enabled="<%=canEdit%>"/></div>
          <div><v:db-checkbox field="doc.SalePaid" caption="@Reservation.Status_Paid" value="true" enabled="<%=canEdit%>"/></div>
          <div><v:db-checkbox field="doc.SaleCompleted" caption="@Reservation.Status_Completed" value="true" enabled="<%=canEdit%>"/></div>
        </v:form-field>
      </v:widget-block>
      <v:widget-block>
        <v:form-field clazz="form-field-optionset">
          <div><v:db-checkbox field="doc.PayByLink" caption="@DocTemplate.PayByLink" hint="@DocTemplate.PayByLinkHint" value="true" enabled="<%=canEdit%>"/></div>
          <div data-visibilitycontroller="#doc\.PayByLink">
            <v:db-checkbox field="doc.AutoCompleteOnPayment" caption="@DocTemplate.AutoCompleteOnPayment" hint="@DocTemplate.AutoCompleteOnPaymentHint" value="true" enabled="<%=canEdit%>"/>
            <div data-visibilitycontroller="#doc\.AutoCompleteOnPayment">
              <snp:dyncombo field="doc.AutoCompleteDocTemplateId" entityType="<%=LkSNEntityType.DocTemplate%>" filtersJSON="{\"DocTemplate\":{\"DocTemplateType\":4}}" enabled="<%=canEdit%>"/>
            </div>
          </div>
        </v:form-field>
			</v:widget-block>
      <v:widget-block>
        <v:form-field clazz="form-field-optionset">
        	<div><v:db-checkbox field="doc.IndividualPAH" caption="@DocTemplate.IndividualPAH" hint="@DocTemplate.IndividualPAHHint" value="true" enabled="<%=canEdit%>"/></div>
        </v:form-field>
      </v:widget-block>
    </v:widget>      
  <% } %>
    
  <% if (doc.DocTemplateType.isLookup(LkSNDocTemplateType.StatReport) && doc.DocEditorType.isLookup(LkSNDocEditorType.DataExport)) { %>
    <v:widget caption="@Common.Options">
      <v:widget-block>
        <v:form-field caption="@DocTemplate.DataExportOutputFormat">
          <v:lk-radio field="doc.DataExportOutputFormat" lookup="<%=LkSN.DataExportOutputFormat%>" allowNull="false" inline="true" enabled="<%=canEdit%>"/>
        </v:form-field>
        
        <div id="doc-csv-options">
          <v:form-field caption="@DocTemplate.CSV_FieldDelimiter">
            <v:input-text field="doc.CsvFieldSeparator" enabled="<%=canEdit%>"/>
          </v:form-field>
          <v:form-field caption="@DocTemplate.CSV_QuoteCharacter">
            <v:input-text field="doc.CsvQuoteCharacter" enabled="<%=canEdit%>"/>
          </v:form-field>
          <v:form-field>
            <div><v:db-checkbox field="doc.CsvIncludeHeaderLine" caption="@DocTemplate.CSV_IncludeHeaderLine" value="true" enabled="<%=canEdit%>"/></div>
            <div><v:db-checkbox field="doc.CsvIncludeBOM" caption="@DocTemplate.CSV_IncludeBOM" hint="@DocTemplate.CSV_IncludeBOMHint" value="true" enabled="<%=canEdit%>"/></div>
          </v:form-field>
        </div>
      </v:widget-block>
    </v:widget>
  <% } %>

  <% if (doc.DocTemplateType.isLookup(LkSNDocTemplateType.Waiver)) { %>
    <jsp:include page="doctemplate_tab_main_waiver.jsp"></jsp:include>
  <% } %>

  <% if (showParams) { %>
    <v:widget caption="@Common.Parameters">
      <v:widget-block style="position:relative; min-height:250px">
        <div>
          <div style="position:absolute; left:0; top:0; bottom:0; width:200px; background-color:#f9f9f9; border-right:1px #dfdfdf solid; overflow:auto">
            <ul id="param-list" class="v-listview">
              <li class="add">
              <% if (!readOnly) { %>
                <a href="javascript:setSelectedParam(addParam())"><v:itl key="@Common.Add"/></a>
              <% } %>
              </li>
            </ul>
          </div>
          <div id="params-detail" class="v-hidden" style="margin-left:201px">
            <v:form-field caption="@Common.Name">
              <input type="text" name="DocParamName" class="form-control" <%=readOnly?"disabled=\"disabled\"":""%>/>
            </v:form-field>
            <v:form-field caption="@Common.Type">
              <v:lk-combobox field="DocParamType" lookup="<%=LkSN.MetaFieldDataType%>" allowNull="false" limitItems="<%=BLBO_DocTemplate.getReportParamDataTypes()%>" enabled="<%=!readOnly%>"/>
            </v:form-field>
            <v:form-field caption="@Common.Caption">
              <input type="text" name="DocParamCaption" class="form-control" <%=readOnly?"disabled=\"disabled\"":""%>>
            </v:form-field>
            <v:form-field caption="@Common.Default">
              <input type="text" name="DocParamDefault" class="form-control" <%=readOnly?"disabled=\"disabled\"":""%>>
            </v:form-field>
      			<v:form-field caption="@Common.Mandatory">
      				<input type="checkbox" name="Mandatory" class="form-control" <%=readOnly?"disabled=\"disabled\"":""%>>
      			</v:form-field>
            
          </div>
        </div>
      </v:widget-block>
    </v:widget>
  <% } %>
  
  <% if (showDrivers) { %>
    <v:grid id="driver-items">
      <thead>
        <v:grid-title caption="@Common.Drivers"/>
        <tr>
          <td><v:grid-checkbox header="true"/></td>
          <td>&nbsp;</td>
          <td width="30%"><v:itl key="@Common.Name"/></td>
          <td width="70%"><v:itl key="@Common.Alias"/></td>
          <td></td>
        </tr>
      </thead>
      <tbody id="driver-items-body">
      </tbody>
      <tbody>
        <tr><td colspan="100%"  style="padding:10px">
          <v:button caption="@Common.Add" fa="plus" href="javascript:showDriverPickupDialog()" enabled="<%=rights.DocMedias.canUpdate()%>"/>
          <v:button caption="@Common.Remove" fa="minus" href="javascript:doRemoveDrivers()" enabled="<%=rights.DocMedias.canUpdate()%>"/>
        </td></tr>
      </tbody>
    </v:grid>
  <% } %>
</v:tab-content>

<% if (doc.DocTemplateType.isLookup(LkSNDocTemplateType.StatReport)) { %>
  <div id="dlg-context" class="v-hidden" title="Contexts">
    <% for (LookupItem item : LkSN.ContextType.getItems()) { %>
      <label class="checkbox-label">
        <% String checked = doc.DocContexts.contains(item.getCode()) ? "checked" : ""; %>
        <input type="checkbox" value="<%=item.getCode()%>" <%=checked%>/> 
        <span class="context-name"><%=item.getHtmlDescription(pageBase.getLang())%></span>
      </label>
      <br/>
    <% } %>
  </div>
<% } %>

<script>
$(document).ready(function() {
  var $format = $("[name='doc\\.DataExportOutputFormat']").change(refreshDataExportOptions);
  refreshDataExportOptions();
  
  function refreshDataExportOptions() {
    var format = parseInt($format.filter(":checked").val());
    $("#doc-csv-options").setClass("hidden", format != <%=LkSNDataExportOutputFormat.CSV.getCode()%>);
  }  
});

<% if (showParams) { %>
  function setSelectedParam(li) {
    flushParam();
    
    $("#param-list li.item").removeClass("selected");
    if (li != null) {
      $(li).addClass("selected");
      initParam();
    }
    
    $("#params-detail").setClass("v-hidden", li == null);
  }
  
  $("#params-detail [name='DocParamName']").keyup(function() {
    $("#param-list li.item.selected .name").text($(this).val());
  });
  
  function addParam(param) {
    param = (param) ? param : {DocParamName: itl("@Common.Default")};
    
    var li = $("<li class='item'/>");
    li.data("param", param);
    $("<span class='name'/>").appendTo(li).text(param.DocParamName);
    
    <% if (!readOnly) { %>
      $("<i class='del fa fa-lg fa-trash'></i>").appendTo(li).click(function() {
        confirmDialog(null, function() {
          li.remove();
        });
      });
    <% } %>
    
    li.click(function() {
      setSelectedParam(li);
    });
    
    return li.insertBefore($("#param-list li.add"));
  }
  
  function initParam() {
    var param = $("#param-list li.item.selected").data("param");
    $("#params-detail [name='DocParamName']").val(param.DocParamName);
    $("#params-detail [name='DocParamType']").val(param.DocParamType);
    $("#params-detail [name='DocParamCaption']").val(param.DocParamCaption);
    $("#params-detail [name='DocParamDefault']").val(param.DocParamDefault);
    $("#params-detail [name='Mandatory']").prop('checked', param.Mandatory);
  }
  
  function flushParam() {
    var param = $("#param-list li.item.selected").data("param");
    if (param) {
      param.DocParamName = $("#params-detail [name='DocParamName']").val();
      param.DocParamType = $("#params-detail [name='DocParamType']").val();
      param.DocParamCaption = $("#params-detail [name='DocParamCaption']").val();
      param.DocParamDefault = $("#params-detail [name='DocParamDefault']").val();
      param.Mandatory = $("#params-detail [name='Mandatory']").isChecked();
    }
  }
  
  <% if (!pageBase.isNewItem()) { %>
    <% for (DODocTemplate.DODocParam docParam : pageBase.getBL(BLBO_DocTemplate.class).getDocTemplateParams(pageBase.getId())) { %>
      addParam(<%=docParam.getJSONString()%>);
    <% } %>
  <% } %>
<% } %>

<% if (showDrivers) { %>
  function doAddDrivers(id, name, alias, icon) {
    var tr = $("<tr class='grid-row' data-DriverId='" + id + "'/>").appendTo("#driver-items-body");
    var tdCB = $("<td/>").appendTo(tr);
    var tdImage = $("<td/>").appendTo(tr);
    var tdDriverName = $("<td/>").appendTo(tr);    
    var tdAlias = $("<td/>").appendTo(tr);
    var tdMove = $("<td align='right'></td>").appendTo(tr);   
  
    tdCB.append("<input value='" + id + "' type='checkbox' class='cblist'><input type='hidden' name='DriverId' value='" + id +"'/>");
    tdImage.append("<img src='" + calcIconName(icon, 32) + "'>");
    tdDriverName.append("<a href= javascript:driverPickupCallback('"+ id +"')>" + name + "</a><br/>");    
    tdAlias.append("<input type='text' class='form-control txt-alias' name='DeviceAlias'/>");
    tdMove.append("<span class='row-hover-visible'><a id='btn-move' style='cursor:move' title='<v:itl key="@Common.Move"/>' href='#'><img src='" + calcIconName("move_item.png", 16) + "'</a></span>");
    
  
    if (alias)
      tdAlias.find("input").val(alias);
    $("#newDriverId").prop('selectedIndex', 0);
  }
  
  function driverPickupCallback(driverId) {
	 asyncDialogEasy("plugin/driver_dialog", "id=" + driverId );
  }
  
  function doRemoveDrivers() {
    $("#driver-items tbody .cblist:checked").closest("tr").remove();
  }
  
  $("table#driver-items tbody").sortable({
    handle: "a#btn-move",
    helper: fixHelper
  });  

  $("a#btn-move").click(function(e) {
    e.stopPropagation();
  });

  <% if (!pageBase.isNewItem()) {%>
    <% JvDataSet ds = pageBase.getBL(BLBO_DocTemplate.class).getSelDriverDS(pageBase.getId()); %>
    <v:ds-loop dataset="<%=ds%>">
      doAddDrivers(
          <%=ds.getField("DriverId").getJsString()%>,
          <%=ds.getField("DriverName").getJsString()%>,
          <%=ds.getField("DeviceAlias").getJsString()%>,
          <%=ds.getField("IconName").getJsString()%>
          );
    </v:ds-loop>
  <% } %>

  function showDriverPickupDialog() {
	  var entityType = <%=LkSNEntityType.DriverPrinter.getCode()%>;
	  <% if (doc.DocEditorType.isLookup(LkSNDocEditorType.MediaGift)) { %>
	    entityType = <%=LkSNEntityType.ExtGiftCardDevice.getCode()%>;  
	  <% } %>
    showLookupDialog({
      EntityType: entityType,
      onPickup: function(item) {
        doAddDrivers(item.ItemId, item.ItemName, null, item.IconName);
      }
    });
  }

<% } %>

function showContextDialog() {
  var dlg = $("#dlg-context");
  dlg.dialog({
    width: 400,
    height: 400,
    modal: true,
    buttons: [
      {
        "text": itl("@Common.Close"),
        "click": function() {
          dlg.dialog("close");
          refreshContextsValue();
        }
      }
    ]
  });
}

function refreshContextsValue() {
  var container = $("#doc-context-container");
  container.empty();
  var cbs = $("#dlg-context input[type='checkbox']:checked");
  for (var i=0; i<cbs.length; i++) {
    if (i > 0)
      container.append(" &nbsp; | &nbsp; ");
    container.append($(cbs[i]).siblings(".context-name").html());
  }
}
$(document).ready(refreshContextsValue);

function runAdvancedNotification() {
  if (confirmDialog()) {
    snpAPI.cmd("DocTemplate", "RunAdvancedNotification", {DocTemplateId:<%=JvString.jsString(pageBase.getId())%>});
  }
}

function doSave() {
	checkRequired("#doctemplate-form", function() {
	    doSaveDocTemplate();
	  });
}

function doSaveDocTemplate() {
  var orderConf = <%=doc.DocTemplateType.isLookup(LkSNDocTemplateType.OrderConfirmation)%>;
  var reqDO = {
    DocTemplateId: <%=doc.DocTemplateId.getJsString()%>,
    DocTemplateName: $("#doc\\.DocTemplateName").val(),
    DocTemplateCode: $("#doc\\.DocTemplateCode").val(),
    DocTemplateType: <%=doc.DocTemplateType.getInt()%>,
    DocEditorType: <%=doc.DocEditorType.getInt()%>,
    CategoryId: $("#doc\\.CategoryId").val(),
    MediaCashoutOption: $("#doc\\.MediaCashoutOption").val(),
    DocEnabled: $("#doc\\.DocEnabled").isChecked(),
    ExecRequireLogin: $("#doc\\.ExecRequireLogin").isChecked(),
    AllowMediaGeneration: $("#AllowMediaGeneration").isChecked(),
    MediaRfidOptionType: $("#doc\\.MediaRfidOptionType").val(),
    MediaEncoderPluginId: $("#doc\\.MediaEncoderPluginId").val(),
    MaxDateRangeDays:  $("#doc\\.MaxDateRangeDays").val(),
    DataSourceSelection: $("#doc\\.DataSourceSelection").isChecked(),
    DataSourceId: $("#doc\\.DataSourceId").val(),
    DocContexts: $("#dlg-context input[type='checkbox']:checked").getCheckedValues(),
    SaleForApproval: orderConf ? $("#doc\\.SaleForApproval").isChecked() : false,
    SaleOpen: orderConf ? $("#doc\\.SaleOpen").isChecked() : false,
    SalePaid: orderConf ? $("#doc\\.SalePaid").isChecked() : false,
    SaleCompleted: orderConf ? $("#doc\\.SaleCompleted").isChecked() : false,
    IndividualPAH: orderConf ? $("#doc\\.IndividualPAH").isChecked() : false,
    DataExportOutputFormat: $("[name='doc\\.DataExportOutputFormat']:checked").val(),
    CsvFieldSeparator: $("#doc\\.CsvFieldSeparator").val(),
    CsvQuoteCharacter: $("#doc\\.CsvQuoteCharacter").val(),
    CsvIncludeHeaderLine: $("#doc\\.CsvIncludeHeaderLine").isChecked(),
    CsvIncludeBOM: $("#doc\\.CsvIncludeBOM").isChecked(),
    ProductDocumentTagIDs: orderConf ? $("#doc\\.ProductDocumentTagIDs").val() : null,
    AttachDocTemplateIDs: orderConf ? $("#doc\\.AttachDocTemplateIDs").val() : null,
    PayByLink: orderConf ? $("[name='doc\\.PayByLink']").isChecked() : false,
    AutoCompleteOnPayment: orderConf ? $("#doc\\.AutoCompleteOnPayment").isChecked() : false,
    AutoCompleteDocTemplateId: $("#doc\\.AutoCompleteDocTemplateId").val(),
    MaskIDs: $("#doc\\.MaskIDs").val(),
    ParamList: [],
    DriverList: []
  };

  <% if (showParams) { %>
    flushParam();
    var params = $("#param-list li.item");
    for (var i=0; i<params.length; i++) 
      reqDO.ParamList.push($(params[i]).data("param"));
  <% } %>
  
  <% if (showDrivers) { %>
    var trs = $("#driver-items-body tr");
    for (var i=0; i<trs.length; i++) {
      reqDO.DriverList.push({
        DriverId: $(trs[i]).attr("data-DriverId"),
        DeviceAlias: $(trs[i]).find("[name='DeviceAlias']").val()
      });
    }
  <% } %>
  
  $("#doctemplate-tab-main").trigger("doctemplate-save", reqDO);

  snpAPI.cmd("DocTemplate", "SaveReportProps", reqDO).then(ansDO => {
    entitySaveNotification(<%=LkSNEntityType.DocTemplate.getCode()%>, ansDO.DocTemplateId);
  });
}


function doOpenGraphicEditor() {
  asyncDialogEasy('doctemplate/doctemplate_editor_dialog', 'id=<%=pageBase.getId()%>');
}
</script>