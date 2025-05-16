<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageEvent" scope="request"/>
<jsp:useBean id="event" class="com.vgs.snapp.dataobject.DOEvent" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
boolean canEdit = pageBase.getRightCRUD().canUpdate();
boolean canCreate = pageBase.getRightCRUD().canCreate();
boolean canDelete = pageBase.getRightCRUD().canDelete();

if (!canEdit && pageBase.isNewItem()) {
  canEdit = canCreate;
}
%>

<v:page-form id="event-form">
<v:input-text type="hidden" field="event.EventId"/>

<script>
  var metaFields = <%=pageBase.getBL(BLBO_MetaData.class).encodeItems(event.MetaDataList)%>;
</script>

<v:tab-toolbar>
  <v:button caption="@Common.Save" fa="save" onclick="doSave()" enabled="<%=canEdit%>"/>
  <snp:notes-btn entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.Event%>"/>
  <% if (!pageBase.isNewItem()) {%>
    <span class="divider"></span>
    <v:button caption="@Common.Duplicate" fa="clone" onclick="doDuplicate()" enabled="<%=canCreate%>"/>
    <span class="divider"></span>
    <% String hrefExport = ConfigTag.getValue("site_url") + "/admin?page=export&EntityIDs=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Event.getCode(); %> 
    <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" href="<%=hrefExport%>"/>
  <% } %>
  <%-- <% if (xpiEvent) { %>
    <span class="divider"></span>
    <v:button caption="@XPI.CrossPlatformSync" fa="sync-alt" href="javascript:doSync()"/>
  <% } %> --%>
</v:tab-toolbar>


<v:tab-content>
  
  <v:profile-recap>
    <snp:profile-pic entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.Event%>" field="event.ProfilePictureId" enabled="<%=canEdit%>"/>

    <jsp:include page="../common/icon-alias-widget.jsp">
      <jsp:param name="iconAlias-Field" value="event.IconAlias"/>
      <jsp:param name="iconAlias-ForegroundField" value="event.ForegroundColor"/>
      <jsp:param name="iconAlias-BackgroundField" value="event.BackgroundColor"/>
      <jsp:param name="iconAlias-CanEdit" value="<%=canEdit%>"/>
    </jsp:include>
  </v:profile-recap>
  
  <v:profile-main>
    <v:widget caption="@Common.General">
      <v:widget-block>
        <v:form-field caption="@Common.Code" mandatory="true">
          <v:input-text field="event.EventCode" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.Name" mandatory="true">
          <snp:itl-edit field="event.EventName" entityType="<%=LkSNEntityType.Event%>" entityId="<%=event.EventId.getString()%>" langField="<%=LkSNHistoryField.Event_Name%>" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.Type" mandatory="true">
          <% if (event.EventType.isLookup(LkSNEventType.DatedEvent)) { %>
            <v:input-text type="hidden" field="event.EventType"/> 
            <input type="text" class="form-control" disabled="disabled" value="<v:itl key="@Lookup.EventType.DatedEvent"/>"/>
          <% } else { %>
            <v:lk-combobox field="event.EventType" lookup="<%=LkSN.EventType%>" hideItems="<%=LookupManager.getArray(LkSNEventType.DatedEvent)%>" allowNull="false" enabled="<%=canEdit%>"/>
          <% } %>
        </v:form-field>
        <v:form-field caption="@Category.Category" mandatory="true">
          <v:combobox field="event.CategoryId" lookupDataSetName="dsCategoryTree" idFieldName="CategoryId" captionFieldName="AshedCategoryName" linkEntityType="<%=LkSNEntityType.Category%>" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.Parent" mandatory="false">
          <snp:parent-pickup placeholder="@Common.NotAssigned" field="event.AccountId" id="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.Event.getCode()%>" parentEntityType="<%=LkSNEntityType.Location.getCode()%>" enabled="<%=canDelete%>"/>
        </v:form-field>
        <v:form-field caption="@Common.Description" checkBoxField="event.ShowNameExt">
          <snp:itl-edit field="event.EventNameExt" entityType="<%=LkSNEntityType.Event%>" entityId="<%=event.EventId.getString()%>" langField="<%=LkSNHistoryField.Event_NameExt%>" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
      
      <v:widget-block>
        <v:form-field caption="@Common.Status">
          <v:lk-combobox field="event.EventStatus" lookup="<%=LkSN.EventStatus%>" allowNull="false" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.OnSaleFrom">
          <v:input-text type="datepicker" field="event.OnSaleFrom" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
          <v:itl key="@Common.To" transform="lowercase"/>
          <v:input-text type="datepicker" field="event.OnSaleTo" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
        </v:form-field>
        <% String hrefTag = "javascript:showTagPickupDialog_OLD(" + LkSNEntityType.Event.getCode() + ",'event.TagIDs')"; %>
        <v:form-field caption="@Common.Tags" href="<%=hrefTag%>">
          <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.Event); %>
          <v:multibox field="event.TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
      
      <v:widget-block>
        
        <v:form-field caption="@Event.BookingWindowDays" multiCol="true">
          <v:multi-col caption="@Event.StartBooking" hint="@Event.BookingWindowDaysHint">
            <v:input-text field="event.BookingWindowDays" enabled="<%=canEdit%>"/>
          </v:multi-col>
          <v:multi-col caption="@Event.StopBooking" hint="@Event.StopBookingMinutesHint">
            <v:input-text field="event.StopBookingWindowMinutes" enabled="<%=canEdit%>"/>
          </v:multi-col>
        </v:form-field>
        <v:form-field caption="@Event.UncountCalendar" hint="@Event.UncountCalendarHint">
          <snp:dyncombo field="event.UncountCalendarId" entityType="<%=LkSNEntityType.Calendar%>" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Event.RedemptionCacheDeltaHours" hint="@Event.RedemptionCacheDeltaHoursHint">
          <v:input-text field="event.RedemptionCacheDeltaHours" placeholder="2" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Event.WaiverTemplate" hint="@Event.WaiverTemplateHint">
          <snp:dyncombo field="event.WaiverDocTemplateId" entityType="<%=LkSNEntityType.DocTemplate%>" filtersJSON="{\"DocTemplate\":{\"DocTemplateType\":32}}" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
      
      <v:widget-block>
        <v:form-field caption="@Common.Options" clazz="form-field-optionset">      
          <div><v:db-checkbox field="event.RestrictOpenOrder" caption="@Common.RestrictOpenOrder" hint="@Common.RestrictOpenOrderHint" value="true" enabled="<%=canEdit%>"/></div> 
          <div><v:db-checkbox field="event.ShowAccountBooking" caption="@Event.ShowAccountBooking" hint="@Event.ShowAccountBookingHint" value="true" enabled="<%=canEdit%>"/></div>
          <div><v:db-checkbox field="event.TracePortfolioInPerformance" caption="@Event.TracePortfolioInPerformance" hint="@Event.TracePortfolioInPerformanceHint" value="true" enabled="<%=canEdit%>"/></div>
          <div><v:db-checkbox field="event.PerfOnDemand" caption="@Event.PerformanceOnDemand" value="true" enabled="<%=canEdit%>"/></div>
          <div><v:db-checkbox field="event.PreventAnonymousPortfolioRedemption" caption="@Event.PreventAnonymousPortfolioRedemption" value="true" enabled="<%=canEdit%>"/></div>
          <div><v:db-checkbox field="event.PerformanceSellableUntilStartOnly" caption="@Event.PerformanceSellableUntilStartOnly" hint="@Event.PerformanceSellableUntilStartOnlyHint" value="true" enabled="<%=canEdit%>"/></div>
          <div><v:db-checkbox field="event.SingleOrder" caption="@Event.SingleOrder" hint="@Event.SingleOrderHint" value="true" enabled="<%=canEdit%>"/></div>
          <div><v:db-checkbox field="event.DistinctPerformancePerAccount" caption="@Event.DistinctPerformancePerAccount" hint="@Event.DistinctPerformancePerAccountHint" value="true" enabled="<%=canEdit%>"/></div>
          <div><v:db-checkbox field="event.ReleaseSeatOnExit" caption="@Event.ReleaseSeatOnExit" hint="@Event.ReleaseSeatOnExitHint" value="true" enabled="<%=canEdit%>"/></div>
        </v:form-field>
      </v:widget-block>
    </v:widget>
    
    <v:widget caption="@Event.PerformanceDefaults">
      <v:widget-block>
        <v:form-field caption="@Account.Location">
          <v:combobox field="event.LocationAccountId" lookupDataSet="<%=pageBase.getBL(BLBO_Account.class).getLocationDS()%>" idFieldName="AccountId" captionFieldName="DisplayName" linkEntityType="<%=LkSNEntityType.Location%>" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Account.AccessArea">
          <% JvDataSet dsAcArea = pageBase.getBL(BLBO_Account.class).getAccessAreaDS(event.LocationAccountId.getString()); %>
          <v:combobox field="event.AccessAreaAccountId" lookupDataSet="<%=dsAcArea%>" idFieldName="AccountId" captionFieldName="DisplayName" clazz="v-hidden" linkEntityType="<%=LkSNEntityType.AccessArea%>" enabled="<%=canEdit%>"/>
          <span id="SelectLocationHint" class="description v-hidden"><v:itl key="@Performance.SelectLocationHint"/></span>
          <div id="LocationLoadingSpinner" class="v-hidden"><img src="<v:config key="site_url" />/resources/admin/images/spinner.gif"/></div>
        </v:form-field>
      </v:widget-block>
      
      <v:widget-block>
        <v:form-field caption="@Common.Calendar">
          <v:combobox field="event.CalendarId" lookupDataSet="<%=pageBase.getBL(BLBO_Calendar.class).getCalendarDS(event.CalendarId)%>" idFieldName="CalendarId" captionFieldName="CalendarName" linkEntityType="<%=LkSNEntityType.Calendar%>" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field id="perf-auto-create" caption="@Event.AutoCreatePerfDays" hint="@Event.AutoCreatePerfDaysHint">
          <v:input-text field="event.AutoCreatePerfDays" enabled="<%=canEdit%>"/>
        </v:form-field>
        
        <v:form-field caption="@Product.GateCategory">
	        <v:multibox 
	            field="event.GateCategoryIDs" 
	            lookupDataSet="<%=pageBase.getBL(BLBO_GateCategory.class).getGateCategoriesDS()%>" 
	            idFieldName="GateCategoryId" 
	            captionFieldName="GateCategoryName" 
	            linkEntityType="<%=LkSNEntityType.GateCategory%>" 
	            enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
      
      <v:widget-block id="perf-manual">
        <v:form-field caption="@Performance.DurationMins">
          <v:input-text field="event.DefaultPerformanceDuration" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Event.AdmissionOpenMins" hint="@Event.AdmissionOpenMinsHint">
          <v:input-text field="event.AdmissionOpenMins" placeholder="@Event.AdmissionOpenMinsPlaceholder" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Event.AdmissionCloseMins" hint="@Event.AdmissionCloseMinsHint">
          <v:input-text field="event.AdmissionCloseMins" placeholder="@Event.AdmissionCloseMinsPlaceholder" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
      
      <v:widget-block>
        <v:form-field caption="@Event.SoldOutWarnLimit" hint="@Event.SoldOutWarnLimitHint">
          <v:input-text field="event.SoldOutWarnLimit" placeholder="20%" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Event.PotentialResourceTypes" hint="@Event.PotentialResourceTypesHint">
          <v:multibox field="event.PotentialResourceTypeIDs" lookupDataSet="<%=pageBase.getBL(BLBO_Resource.class).getResourceTypeDS(pageBase.getId())%>" idFieldName="ResourceTypeId" captionFieldName="ResourceTypeName" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
    </v:widget>
    
    <v:widget caption="@Event.QueueControl">
      <v:widget-block>
        <v:db-checkbox field="event.QueueControl" caption="@Event.QueueControl" value="true" enabled="<%=canEdit%>"/>
      </v:widget-block>
      <v:widget-block id="queue-control-block" clazz="v-hidden">
        <v:form-field caption="@Event.QueueSlotFrequency">
          <v:input-text field="event.QueueSlotFrequency" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Event.QueueSlotCapacity">
          <v:input-text field="event.QueueSlotCapacity" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
    </v:widget>
    
    <script>
    function refreshAutoCreateVisibility() {
      var gad = $("#event\\.EventType").val() == "<%=LkSNEventType.GenAdm.getCode()%>";
      $("#perf-auto-create").setClass("hidden", !gad);
      $("#perf-manual").setClass("hidden", gad);
    }
    $("#event\\.EventType").click(refreshAutoCreateVisibility);

    
    function refreshQueueControl() {
      $("#queue-control-block").setClass("v-hidden", !$("#event\\.QueueControl").isChecked());
    }
    $("#event\\.QueueControl").click(refreshQueueControl);
    $(document).ready(refreshQueueControl);
    </script>
    
    <v:widget caption="@Common.Other">
      <v:widget-block>
        <table class="form-table">
          <tr>
            <th valign="top"><v:button caption="@Event.EventCategories"  onclick="showEventCategoryDialog()" enabled="<%=canEdit%>"/></th>
            <td>
              <v:input-text type="hidden" field="event.EventCategoryIDs"/>
              <div id="event-cat-names"></div>
            </td>
          </tr>
        </table>
      </v:widget-block>
      
      <v:widget-block>
        <v:form-field caption="@Common.Weight">
          <v:input-text field="event.Weight" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.PositionLat">
          <v:input-text field="event.PositionLat" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.PositionLong">
          <v:input-text field="event.PositionLong" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Event.AverageVisitTime">
          <v:input-text field="event.AverageVisitTime" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Event.ReferencePrice">
          <v:input-text field="event.ReferencePrice" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field>
           <v:db-checkbox field="event.PerformanceSelection" caption="@Event.PerformanceSelection" value="true" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
      
      <v:widget-block>
        <v:form-field caption="@Common.FromDate">
          <v:input-text type="datepicker" field="event.ActiveDateFrom" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.ToDate">
          <v:input-text type="datepicker" field="event.ActiveDateTo" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.FromTime">
          <v:input-text type="timepicker" field="event.ActiveTimeFrom" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.ToTime">
          <v:input-text type="timepicker" field="event.ActiveTimeTo" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Entitlement.WeekDays">
          <v:db-checkbox field="event.ActiveMON" caption="@Common.WeekMON" value="true" enabled="<%=canEdit%>"/>&nbsp;&nbsp;&nbsp;
          <v:db-checkbox field="event.ActiveTUE" caption="@Common.WeekTUE" value="true" enabled="<%=canEdit%>"/>&nbsp;&nbsp;&nbsp;
          <v:db-checkbox field="event.ActiveWED" caption="@Common.WeekWED" value="true" enabled="<%=canEdit%>"/>&nbsp;&nbsp;&nbsp;
          <v:db-checkbox field="event.ActiveTHU" caption="@Common.WeekTHU" value="true" enabled="<%=canEdit%>"/>&nbsp;&nbsp;&nbsp;
          <v:db-checkbox field="event.ActiveFRI" caption="@Common.WeekFRI" value="true" enabled="<%=canEdit%>"/>&nbsp;&nbsp;&nbsp;
          <v:db-checkbox field="event.ActiveSAT" caption="@Common.WeekSAT" value="true" enabled="<%=canEdit%>"/>&nbsp;&nbsp;&nbsp;
          <v:db-checkbox field="event.ActiveSUN" caption="@Common.WeekSUN" value="true" enabled="<%=canEdit%>"/>&nbsp;&nbsp;&nbsp;
        </v:form-field>
      </v:widget-block>
    </v:widget>
    
    <% JvDataSet dsEventCat = pageBase.getBLDef().getEventCategoryDS(event.EventCategoryIDs.getArray()); %>
    <div id="event-cat-dialog" class="v-hidden">
      <style>
        .event-cat-type {
          font-weight: bold;
          margin-top: 10px;
          margin-bottom: 2px;
          border-bottom: 1px #dfdfdf solid;
        }
      </style>
    
      <% LookupItem lastType = null; %>
      <% while (!dsEventCat.isEof()) { %>
        <% LookupItem catType = LkSN.EventCategoryType.getItemByCode(dsEventCat.getField("EventCategoryType")); %>
        <% if (!catType .isLookup(lastType)) { %>
          <% lastType = catType; %>
          <div class="event-cat-type"><%=catType.getDescription(pageBase.getLang())%></div>
        <% } %>
        <div class="event-cat-item" 
            data-TypeName="<%=catType.getDescription(pageBase.getLang())%>" 
            data-EventCategoryName="<%=dsEventCat.getField("EventCategoryName").getHtmlString()%>">
          <v:db-checkbox caption="<%=dsEventCat.getField(\"EventCategoryName\").getHtmlString()%>" value="<%=dsEventCat.getField(\"EventCategoryId\").getHtmlString()%>" field="event-cat-id"/>
        </div>
        <% dsEventCat.next(); %>
      <% } %>
    </div>
    
    <div id="maskedit-container"></div>
    <script>
      // Data Masks
      function reloadMaskEdit(categoryId) {
        asyncLoad("#maskedit-container", "admin?page=maskedit_widget&id=<%=pageBase.getId()%>&EntityType=<%=LkSNEntityType.Event.getCode()%>&CategoryId=" + categoryId + "&readonly=<%=!canEdit%>");
      }
      reloadMaskEdit(document.getElementById("event.CategoryId").value);
      
      $("#event\\.CategoryId").change(function() {
        reloadMaskEdit(this.value);
      });
      
      var loadingAA = false;
      function refreshAccessArea() {
        var setted = ($("#event\\.LocationAccountId").val() != "");
        setVisible("#event\\.AccessAreaAccountId", setted && !loadingAA);
        setVisible("#SelectLocationHint", !setted && !loadingAA);
        setVisible("#LocationLoadingSpinner", loadingAA);
      }
      refreshAccessArea();

      
      $("#event\\.LocationAccountId").change(function() {
        if ($("#event\\.LocationAccountId").val() == "") {
          $("#event\\.AccessAreaAccountId").val("");
          refreshAccessArea();
        }
        else {
          loadingAA = true;
          refreshAccessArea();
          $.ajax({
            url: "<v:config key="site_url"/>/admin?page=account_tab_acarea&action=get_accessarea_options&LocationId=" + $("#event\\.LocationAccountId").val(),
            dataType:'html',
            cache: false
          }).done(function(html) {
            $("#event\\.AccessAreaAccountId").html(html);
            loadingAA = false;
            refreshAccessArea();
          }).fail(function() {
            loadingAA = false;
            refreshAccessArea();
            alert("<v:itl key="@Common.GenericError"/>");
          });
        }
      });

      
      function refreshNameExt() {
        $("#event\\.EventNameExt").attr("placeholder", $("#event\\.EventName").val());
      }
      $("#event\\.EventName").keyup(refreshNameExt);
      
      function renderEventCategories() {
        var dlg = $("#event-cat-dialog");
        $("#event-cat-names").empty();

        var ids = $("#event\\.EventCategoryIDs").val();
        ids = (ids == "") ? [] : ids.split(",");
        
        var values = {};
        for (var i=0; i<ids.length; i++) {
          var item = dlg.find("[value='" + ids[i] + "']").closest(".event-cat-item");
          var type = item.attr("data-TypeName");
          if (!values[type])
            values[type] = [];
          values[type].push(item.attr("data-EventCategoryName"));
        }
        
        $.each(values, function(key, value) {
          $("#event-cat-names").append("<b>" + key + "</b>: " + value.join(", ") + "<br/>");
        });
      }
      
      function showEventCategoryDialog() {
        var dlg = $("#event-cat-dialog");
        
        dlg.find("input[type='checkbox']").setChecked(false);
        var ids = ($("#event\\.EventCategoryIDs").val() == "") ? [] : $("#event\\.EventCategoryIDs").val().split(",");
        for (var i=0; i<ids.length; i++) 
          dlg.find("[value='" + ids[i] + "']").setChecked(true);
        
        dlg.dialog({
          modal: true,
          title: "<v:itl key="@Event.EventCategories"/>",
          width: 300,
          height: 500,
          buttons: {
            <v:itl key="@Common.Ok" encode="JS"/>: function() {
              $("#event\\.EventCategoryIDs").val(dlg.find("[name='event-cat-id']").getCheckedValues());
              renderEventCategories();
              dlg.dialog("close");
            },
            <v:itl key="@Common.Cancel" encode="JS"/>: function() {
              dlg.dialog("close");
            }
          }
        });
      }
      
      function doSave() {
        var metaDataList = prepareMetaDataArray("#event-form");
        if (!(metaDataList)) 
          showIconMessage("warning", <v:itl key="@Common.CheckRequiredFields" encode="JS"/>);
        else {
          var activeTimeFrom = null;
          if (($("#event\\.ActiveTimeFrom-HH").getComboIndex() > 0) || ($("#event\\.ActiveTimeFrom-MM").getComboIndex() > 0))
            activeTimeFrom = "1970-01-01T" + $("#event\\.ActiveTimeFrom").getXMLTime();
          
          var activeTimeTo = null;
          if (($("#event\\.ActiveTimeTo-HH").getComboIndex() > 0) || ($("#event\\.ActiveTimeTo-MM").getComboIndex() > 0))
            activeTimeTo = "1970-01-01T" + $("#event\\.ActiveTimeTo").getXMLTime();

          var reqDO = {
            Command: "SaveEvent",
            SaveEvent: {
              Event: {
                EventId                             : <%=event.EventId.getJsString()%>,
                EventType                           : $("#event\\.EventType").val(),
                EventCode                           : $("#event\\.EventCode").val(),
                EventName                           : $("#event\\.EventName").val(),
                ShowNameExt                         : $("[name='event\\.ShowNameExt']").isChecked(),
                EventNameExt                        : $("#event\\.EventNameExt").val(),
                CategoryId                          : $("#event\\.CategoryId").val(),
                AccountId                           : $("#event\\.AccountId").val(),
                ProfilePictureId                    : $("#product\\.ProfilePictureId").val(),
                LocationAccountId                   : $("#event\\.LocationAccountId").val(),
                AccessAreaAccountId                 : $("#event\\.AccessAreaAccountId").val(),
                CalendarId                          : $("#event\\.CalendarId").val(),
                GateCategoryIDs                     : $("#event\\.GateCategoryIDs").val(),
                AutoCreatePerfDays                  : $("#event\\.AutoCreatePerfDays").val(),
                ProfilePictureId                    : $("#event\\.ProfilePictureId").val(),
                EventStatus                         : $("#event\\.EventStatus").val(),
                OnSaleFrom                          : $("#event\\.OnSaleFrom-picker").getXMLDate(),
                OnSaleTo                            : $("#event\\.OnSaleTo-picker").getXMLDateTime(),
                TagIDs                              : $("#event\\.TagIDs").val(),
                DefaultPerformanceDuration          : $("#event\\.DefaultPerformanceDuration").val(),
                AdmissionOpenMins                   : $("#event\\.AdmissionOpenMins").val(),
                AdmissionCloseMins                  : $("#event\\.AdmissionCloseMins").val(),
                ActiveDateFrom                      : $("#event\\.ActiveDateFrom-picker").getXMLDateTime(),
                ActiveDateTo                        : $("#event\\.ActiveDateTo-picker").getXMLDateTime(),
                ActiveTimeFrom                      : activeTimeFrom,
                ActiveTimeTo                        : activeTimeTo,
                ActiveMON                           : $("#event\\.ActiveMON").isChecked(),
                ActiveTUE                           : $("#event\\.ActiveTUE").isChecked(),
                ActiveWED                           : $("#event\\.ActiveWED").isChecked(),
                ActiveTHU                           : $("#event\\.ActiveTHU").isChecked(),
                ActiveFRI                           : $("#event\\.ActiveFRI").isChecked(),
                ActiveSAT                           : $("#event\\.ActiveSAT").isChecked(),
                ActiveSUN                           : $("#event\\.ActiveSUN").isChecked(),
                QueueControl                        : $("#event\\.QueueControl").isChecked(),
                QueueSlotFrequency                  : $("#event\\.QueueSlotFrequency").val(),
                QueueSlotCapacity                   : $("#event\\.QueueSlotCapacity").val(),
                ShowAccountBooking                  : $("#event\\.ShowAccountBooking").isChecked(),
                TracePortfolioInPerformance         : $("#event\\.TracePortfolioInPerformance").isChecked(),
                PerfOnDemand                        : $("#event\\.PerfOnDemand").isChecked(),
                PreventAnonymousPortfolioRedemption : $("#event\\.PreventAnonymousPortfolioRedemption").isChecked(),
                PerformanceSellableUntilStartOnly   : $("#event\\.PerformanceSellableUntilStartOnly").isChecked(),
                SingleOrder                         : $("#event\\.SingleOrder").isChecked(),
                DistinctPerformancePerAccount       : $("#event\\.DistinctPerformancePerAccount").isChecked(),
                ReleaseSeatOnExit                   : $("#event\\.ReleaseSeatOnExit").isChecked(),
                CapacityReallocationByTask          : $("#event\\.CapacityReallocationByTask").isChecked(),
                SoldOutWarnLimit                    : $("#event\\.SoldOutWarnLimit").val(),
                PositionLat                         : $("#event\\.PositionLat").val() == "" ? null : $("#event\\.PositionLat").val(),
                PositionLong                        : $("#event\\.PositionLong").val() == "" ? null : $("#event\\.PositionLong").val(),
                Weight                              : $("#event\\.Weight").val(), 
                AverageVisitTime                    : $("#event\\.AverageVisitTime").val(),
                EventCategoryIDs                    : $("#event\\.EventCategoryIDs").val(),
                ReferencePrice                      : $("#event\\.ReferencePrice").val() == "" ? null : $("#event\\.ReferencePrice").val(), 
                PerformanceSelection                : $("#event\\.PerformanceSelection").isChecked(),
                BackgroundColor                     : $("[name='event\\.BackgroundColor']").val(),
                ForegroundColor                     : $("[name='event\\.ForegroundColor']").val(),
                IconAlias                           : $("#event\\.IconAlias").attr("data-alias"),
                RestrictOpenOrder                   : $("#event\\.RestrictOpenOrder").isChecked(),
                BookingWindowDays                   : $("#event\\.BookingWindowDays").val(),
                StopBookingWindowMinutes            : $("#event\\.StopBookingWindowMinutes").val(),
                UncountCalendarId                   : $("#event\\.UncountCalendarId").val(),
                RedemptionCacheDeltaHours           : $("#event\\.RedemptionCacheDeltaHours").val(),
                WaiverDocTemplateId                 : $("#event\\.WaiverDocTemplateId").val(),
                PotentialResourceTypeIDs            : $("#event\\.PotentialResourceTypeIDs").val(),
                MetaDataList                        : metaDataList
              }
            }
          };
          
          showWaitGlass();
          vgsService("Event", reqDO, false, function(ansDO) {
            hideWaitGlass();
            entitySaveNotification(<%=LkSNEntityType.Event.getCode()%>, ansDO.Answer.SaveEvent.EventId);
          });  
        }
      }
      
      function doDuplicate() {
        var reqDO = {
            Command: "GenerateDuplicateCodeName",
            GenerateDuplicateCodeName: {
              EventCode: <%=event.EventCode.getJsString()%>,
              EventName: <%=event.EventName.getJsString()%>
            }
        }
        
        vgsService("Event", reqDO, false, function(ansDO) {
          inputEventDetails(ansDO.Answer.GenerateDuplicateCodeName.CandidateEventCode, ansDO.Answer.GenerateDuplicateCodeName.CandidateEventName);
        });
      }
      
      function inputEventDetails(eventCode, eventName) {
        var dlgInput = $("<div class='duplicate-input-dialog'/>");
        dlgInput.append("<div class='form-field'><div class='form-field-caption'><v:itl key='@Common.NewCode'/></div><div class='form-field-value'><input type='text' id='event.CandidateEventCode' name='event.CandidateEventCode' class='form-control' value='" + eventCode + "'/></div></div>");
        dlgInput.append("<div class='form-field'><div class='form-field-caption'><v:itl key='@Common.NewName'/></div><div class='form-field-value'><input type='text' id='event.CandidateEventName' name='event.CandidateEventName' class='form-control' value='" + eventName + "'/></div></div>");
        
        dlgInput.dialog({
          title: <v:itl key="@Event.Event" encode="JS"/>,
          modal: true,
          width: 450,
          height: 220,
          close: function() {
            dlgInput.remove()
          },
          buttons: {
            <v:itl key="@Common.Ok" encode="JS"/>: function() {              
              var reqDODup = {
                Command: "DuplicateEvent",
                DuplicateEvent: {
                  EventId: '<%=pageBase.getId()%>',
                  CandidateEventCode: $("#event\\.CandidateEventCode").val(),
                  CandidateEventName: $("#event\\.CandidateEventName").val()
                }
              };
              dlgInput.dialog("close");
              
              showWaitGlass();
              vgsService("Event", reqDODup, false, function(ansDODup) {
                hideWaitGlass();
                if (ansDODup.Answer.DuplicateEvent.CandidateCodeNameDifferent == true)
                  showDuplicateResultDialog(ansDODup.Answer.DuplicateEvent.EventId, ansDODup.Answer.DuplicateEvent.EventCode, ansDODup.Answer.DuplicateEvent.EventName);
                else
                  window.location = "<v:config key="site_url"/>/admin?page=event&id=" + ansDODup.Answer.DuplicateEvent.EventId;
              });
            },
            <v:itl key="@Common.Cancel" encode="JS"/>: function() {
              dlgInput.dialog("close");
            }
          }
        });
      }
      
      function showDuplicateResultDialog(id, code, name) {
        var dlgRes = $("<div class='duplicate-dialog'/>");
        dlgRes.append("Code or Name already used, new code and name are the ones below.<br/><br/>")
        dlgRes.append("<div><v:itl key="@Common.Code"/><span class='recap-value'>" + code + "</span><br/>")
        dlgRes.append("<v:itl key="@Common.Name"/><span class='recap-value'>" + name + "</span><br/></div>")

        dlgRes.dialog({
          title: <v:itl key="@Event.NewEventCreated" encode="JS"/>,
          modal: true,
          width: 450,
          height: 200,
          close: function() {
            dlgInput.remove()
          },
          buttons: {
            <v:itl key="@Common.Close" encode="JS"/>: function() {
              dlgRes.dialog("close");
              window.location = "<v:config key="site_url"/>/admin?page=event&id=" + id;
            }
          }
        });
      }

      $(document).ready(function() {        
        refreshNameExt();
        renderEventCategories();
        $("#event\\.SoldOutWarnLimit").on("keypress keyup paste", function(e) {
          this.value = this.value.replace(/[^0-9]/g, '');
        });
      });
    </script>
  </v:profile-main>
</v:tab-content>

</v:page-form>