<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageEventList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% 
int[] defaultStatusFilter = LookupManager.getIntArray(LkSNEventStatus.Draft, LkSNEventStatus.OnSale, LkSNEventStatus.Suspended); 
int[] defaultTypeFilter = LookupManager.getIntArray(LkSNEventType.GenAdm, LkSNEventType.PerfEvent); 
boolean canCreate = rights.EventAdd_All.getBoolean() || (rights.EventAdd_Tags.getArray().length > 0);
boolean canDelete = rights.EventDelete_All.getBoolean() || (rights.EventDelete_Tags.getArray().length > 0); 
%>

<input type="hidden" id="CategoryId" name="CategoryId" value="<%=pageBase.getEmptyParameter("CategoryId")%>"/>

<script>
  var selCategoryId = <%=JvString.jsString(pageBase.getEmptyParameter("CategoryId"))%>;
  function search() {
    setGridUrlParam("#event-grid", "FullText", $("#full-text-search").val());
    setGridUrlParam("#event-grid", "EventStatus", $("[name='Status']").getCheckedValues());
    setGridUrlParam("#event-grid", "EventType", $("[name='EventType']").getCheckedValues());
    setGridUrlParam("#event-grid", "TagId", ($("#TagIDs").val() || ""), true);
  }

  function categorySelected(categoryId) {
	  selCategoryId = categoryId;
    setGridUrlParam("#event-grid", "CategoryId", categoryId);
    changeGridPage("#event-grid", "first");
  }
  
  function deleteEvents() {
    var ids = $("[name='EventId']").getCheckedValues();
    if (ids == "")
      showMessage(<v:itl key="@Common.NoElementWasSelected" encode="JS"/>);
    else {
      confirmDialog(null, function() {
        var reqDO = {
          Command: "DeleteEvents",
          DeleteEvents: {
            EventIDs: ids
          }
        };

        vgsService("EVENT", reqDO, false, function(ansDO) {
          triggerEntityChange(<%=LkSNEntityType.Event.getCode()%>);
        });
      });  
    }
  }
  
  function createSyncCrossEvent() {
		asyncDialogEasy("xpi/xpi_event_sync_create_dialog", "CategoryId=" + selCategoryId);
	}
  
  function showImportDialog() {
	  asyncDialogEasy("event/event_snapp_import_dialog", "");
	}
	          
	function exportTax() {
	  var bean = getGridSelectionBean("#event-grid-table", "[name='EventId']");
	  if (bean) 
	    window.location = BASE_URL + "/admin?page=export&EntityIDs=" + bean.ids + "&EntityType=<%=LkSNEntityType.Event.getCode()%> + &QueryBase64=" + bean.queryBase64;
	}
  
</script>

<div class="tab-toolbar">
  <v:button caption="@Common.Search" fa="search" href="javascript:search()"/>
  <span class="divider"></span>
  <div class="btn-group">
    <v:button caption="@Common.New" title="@Event.NewEventHint" fa="plus" href="admin?page=event&id=new" enabled="<%=canCreate%>"/>
    <% if (canCreate) { %>
      <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown"><span class="caret"></span></button>
      <v:popup-menu bootstrap="true">
        <v:popup-item caption="@Event.Event" icon="<%=LkSNEntityType.Event.getIconName()%>" href="admin?page=event&id=new"/>
        <v:popup-item caption="@XPI.CrossEvent" icon="crossplatform.png" href="javascript:createSyncCrossEvent()"/>
      </v:popup-menu>
    <% } %>
  </div>
  
  <v:button caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" href="javascript:deleteEvents()" enabled="<%=canDelete%>"/>
  
  <span class="divider"></span>
  <v:button caption="@Common.Import" fa="sign-in" onclick="showImportDialog()"/>
  <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" bindGrid="event-grid"  onclick="exportTax()"/>
  
  <span class="divider"></span>
  <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.Event.getCode() + ")";%>
  <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/>
  <v:pagebox gridId="event-grid"/>
</div>

<div class="tab-content">

<v:last-error/>

<input type="hidden" id="CategoryId" name="CategoryId" value="<%=pageBase.getEmptyParameter("CategoryId")%>"/>

  <div id="main-container">
    <div class="profile-pic-div">
      
      <v:widget caption="@Common.Search">
        <v:widget-block>
          <input type="text" id="full-text-search" class="form-control default-focus" placeholder="<v:itl key="@Common.FullSearch"/>" value="<%=pageBase.getEmptyParameter("FullText")%>"/>
          <script>
            $("#full-text-search").keypress(function(e) {
              if (e.keyCode == KEY_ENTER) {
                search();
                return false;
              }
            });
          </script>
            
          <div class="filter-divider"></div>
 
          <div><v:itl key="@Common.Tags"/></div>
          <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.Event); %>
          <v:multibox field="TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName"/>
        </v:widget-block>
      </v:widget>
      
      <v:widget caption="@Common.Status">
        <v:widget-block>
        <% for (LookupItem status : LkSN.EventStatus.getItems()) { %>
          <v:db-checkbox field="Status" caption="<%=status.getDescription()%>" value="<%=String.valueOf(status.getCode())%>" checked="<%=JvArray.contains(status.getCode(), defaultStatusFilter)%>" /><br/>
        <% } %>
        </v:widget-block>
      </v:widget>

      
      <v:widget caption="@Common.Type">
        <v:widget-block>
        <% for (LookupItem type : LkSN.EventType.getItems()) { %>
          <v:db-checkbox field="EventType" caption="<%=type.getDescription()%>" value="<%=String.valueOf(type.getCode())%>" checked="<%=JvArray.contains(type.getCode(), defaultTypeFilter)%>" /><br/>
        <% } %>
        </v:widget-block>
      </v:widget>
      
      <v:widget caption="@Category.Categories" editHRef="<%=pageBase.getCategoryEditLink(LkSNEntityType.Event)%>">
        <v:widget-block>
          <snp:category-tree-widget entityType="<%=LkSNEntityType.Event%>"/>
        </v:widget-block>
      </v:widget>
    </div>
    
    <div class="profile-cont-div">
      <% String params = "EventStatus=" + JvArray.arrayToString(defaultStatusFilter, ",") + "&EventType=" + JvArray.arrayToString(defaultTypeFilter, ","); %>
      <v:async-grid id="event-grid" jsp="event/event_grid.jsp" params="<%=params%>"/>
    </div>
  </div>

</div>