<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageCalendarList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
<v:last-error/>

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <v:tab-toolbar>
      <v:button caption="@Common.Search" fa="search" href="javascript:search()"/>
      <span class="divider"></span>
      
      <v:button-group>
        <v:button caption="@Common.New" fa="plus" href="admin?page=calendar&id=new" bindGrid="calendar-grid" bindGridEmpty="true"/>
        <v:button caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" bindGrid="calendar-grid" onclick="doDelete()"/>
      </v:button-group>

      <v:button-group>
        <v:button caption="@Common.Import" fa="sign-in" onclick="showImportDialog()"/>
        <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" bindGrid="calendar-grid"  onclick="exportCalendars()"/>
      </v:button-group>
      
      <span class="divider"></span>
      <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.Calendar.getCode() + ")";%>
      <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/>
      <v:pagebox gridId="calendar-grid"/>
    </v:tab-toolbar>
    
    <v:tab-content>
      <v:profile-recap>
      	<v:widget caption="@Common.Search">
          <v:widget-block>
            <input type="text" id="full-text-search" class="form-control default-focus" placeholder="<v:itl key="@Common.FullSearch"/>" value="<%=pageBase.getEmptyParameter("FullText")%>"/>
          </v:widget-block>
        </v:widget>
        <v:widget caption="@Common.Filters">
          <v:widget-block>
            <table style="width:100%">
              <tr>
                <td>
                  &nbsp;<v:itl key="@Common.From"/><br/>
                  <v:input-text type="datepicker" field="FromDate"/>
                </td>
                <td>&nbsp;</td>
                <td>
                  &nbsp;<v:itl key="@Common.To"/><br/>
                  <v:input-text type="datepicker" field="ToDate"/>
                </td>
              </tr>
            </table>
          </v:widget-block>
        </v:widget>
        <v:widget caption="@Common.Status">
          <v:widget-block>
            <v:db-checkbox field="Status" caption="@Common.Enabled" value="1" /><br/>
			      <v:db-checkbox field="Status" caption="@Common.Disabled" value="0" /><br/>          
          </v:widget-block>
        </v:widget>
        <v:widget caption="@Category.Categories" editHRef="<%=pageBase.getCategoryEditLink(LkSNEntityType.Calendar)%>">
          <v:widget-block>
            <snp:category-tree-widget entityType="<%=LkSNEntityType.Calendar%>"/>
          </v:widget-block>
        </v:widget>
      </v:profile-recap>
      
      <v:profile-main>
        <v:async-grid id="calendar-grid" jsp="calendar/calendar_grid.jsp" />
      </v:profile-main>
    </v:tab-content>
  </v:tab-item-embedded>
</v:tab-group>

<script>
function search() {
  setGridUrlParam("#calendar-grid", "FullText", $("#full-text-search").val());
  setGridUrlParam("#calendar-grid", "FromDate", $("#FromDate-picker").getXMLDate());
  setGridUrlParam("#calendar-grid", "ToDate", $("#ToDate-picker").getXMLDate());
  setGridUrlParam("#calendar-grid", "Enabled", $("[name='Status']").getCheckedValues(), true);
}

$("#full-text-search").keypress(function(e) {
  if (e.keyCode == KEY_ENTER) {
    search();
    return false;
  }
});

function doDelete() {
  confirmDialog(null, function() {
    var reqDO = {
      Command: "DeleteCalendar",
      DeleteCalendar: {
        CalendarIDs: $("[name='CalendarId']").getCheckedValues()
      }
    };
    
    vgsService("Calendar", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.Calendar.getCode()%>);
    });
  });
}

function showImportDialog() {
  asyncDialogEasy("calendar/calendar_snapp_import_dialog", "");
}
	  
function exportCalendars() {
  var bean = getGridSelectionBean("#calendar-grid-table", "[name='CalendarId']");
  if (bean) 
    window.location = BASE_URL + "/admin?page=export&EntityIDs=" + bean.ids + "&EntityType=<%=LkSNEntityType.Calendar.getCode()%> + &QueryBase64=" + bean.queryBase64;
}

var selCategoryId = <%=JvString.jsString(pageBase.getEmptyParameter("CategoryId"))%>;
function categorySelected(categoryId) {
  selCategoryId = categoryId;
  setGridUrlParam("#calendar-grid", "CategoryId", categoryId, true);
}

</script>
 
<jsp:include page="/resources/common/footer.jsp"/>
