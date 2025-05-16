<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<jsp:useBean id="pageBase" class="com.vgs.web.page.PageEventList" scope="request"/>


<script>
  function search() {
    setGridUrlParam("#eventcat-grid", "EventCategoryType", $("[name='EventCategoryType']").getCheckedValues());
    setGridUrlParam("#eventcat-grid", "FullText", $("#full-text-search").val(), true);
  }
  
  $(document).on("OnEntityChange", search);
  
  function newEventCatDialog() {
    asyncDialogEasy("event/eventcat_dialog", "id=new"); 
  }
  
  function deleteEventCats() {
	  confirmDialog(null, function() {
	    var reqDO = {
	      Command: "DelEventCategory",
	      DelEventCategory: {
	    	  EventCategoryIDs: $("[name='EventCategoryId']").getCheckedValues()
	      }
	    };
	    vgsService("Event", reqDO, false, function(ansDO) {
	      triggerEntityChange(<%=LkSNEntityType.EventCategory.getCode()%>);
	    });
	  });
	}

</script>

<div class="tab-toolbar">
  <v:button caption="@Common.Search" fa="search" href="javascript:search()"/>
  <span class="divider"></span>
  <v:button caption="@Common.New" title="@Product.NewProductType" fa="plus" href="javascript:newEventCatDialog()"/>
  <v:button caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" href="javascript:deleteEventCats()"/>

  <v:pagebox gridId="eventcat-grid"/>
</div>

<div class="tab-content">
  <v:last-error/>

  <div id="main-container">
    <div class="profile-pic-div">
      <div class="form-toolbar">
        <input type="text" id="full-text-search" class="form-control default-focus" placeholder="<v:itl key="@Common.FullSearch"/>" value="<%=pageBase.getEmptyParameter("FullText")%>"/>
        <script>
          $("#full-text-search").keypress(function(e) {
            if (e.keyCode == KEY_ENTER) {
              search();
              return false;
            }
          });
        </script>
      </div>
  
      <v:widget caption="@Common.Type">
        <v:widget-block>
        <% for (LookupItem item : LkSN.EventCategoryType.getItems()) { %>
          <v:db-checkbox field="EventCategoryType" caption="<%=item.getDescription(pageBase.getLang())%>" value="<%=String.valueOf(item.getCode())%>" /><br/>
        <% } %>
        </v:widget-block>
      </v:widget>
    </div>
    
    <div class="profile-cont-div">
      <v:async-grid id="eventcat-grid" jsp="event/eventcat_grid.jsp"/>
    </div> 
  </div>
</div>
