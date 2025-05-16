<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeOrganizer"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSiaeEventList" scope="request"/>
<% int[] defaultStatusFilter = LookupManager.getIntArray(LkSNEventStatus.Draft, LkSNEventStatus.OnSale, LkSNEventStatus.Suspended); %>
<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
<%
BLBO_Siae bl = pageBase.getBLDef();
QueryDef qdef = new QueryDef(QryBO_SiaeOrganizer.class);
//Select
qdef.addSelect(QryBO_SiaeOrganizer.Sel.OrganizerId);
qdef.addSelect(QryBO_SiaeOrganizer.Sel.Denominazione);
//Sort
qdef.addSort(QryBO_SiaeOrganizer.Sel.Denominazione);
//Exec
JvDataSet organizersDs = pageBase.execQuery(qdef);
%>
<div id="main-container">
  <div class="mainlist-container">
    <jsp:include page="/resources/admin/siae/siae_alert.jsp" />
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
        <v:widget caption="@Common.Status" icon="flag.png">
          <v:widget-block>
          <% for (LookupItem status : LkSN.EventStatus.getItems()) { %>
            <v:db-checkbox field="Status" caption="<%=status.getDescription()%>" value="<%=String.valueOf(status.getCode())%>" checked="<%=JvArray.contains(status.getCode(), defaultStatusFilter)%>" /><br/>
          <% } %>
          </v:widget-block>
        </v:widget>
        
        <v:widget caption="Organizzatore">
          <v:widget-block>
            <v:combobox field="OrganizerId" lookupDataSet="<%=organizersDs%>" captionFieldName="Denominazione" idFieldName="OrganizerId" allowNull="true"/>
          </v:widget-block>
        </v:widget>
        
        <v:widget caption="@Common.Tags">
          <v:widget-block>
            <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.Event); %>
            <v:multibox field="TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName"/>
          </v:widget-block>
        </v:widget>
        
        <v:widget caption="@Category.Categories" editHRef="<%=pageBase.getCategoryEditLink(LkSNEntityType.Event)%>">
          <v:widget-block>
            <snp:category-tree-widget entityType="<%=LkSNEntityType.Event%>"/>
          </v:widget-block>
        </v:widget>
    </div>
   
    <div class="profile-cont-div">  
      <div class="form-toolbar">
        <v:button caption="@Common.Search" fa="search" href="javascript:search()"/>
        <span class="divider"></span>
        <v:button id="del-btn" caption="@Common.Delete" fa="trash" enabled="<%=bl.isSiaeEnabled() %>" href="javascript:doDelete()"/>
        <v:pagebox gridId="siae-event-grid"/>
      </div>
      
      <div>
        <v:last-error/>
        <v:async-grid id="siae-event-grid" jsp="siae/siae_event_grid.jsp" />
      </div>
    </div>
  </div>   
</div>
<script>

function search() {
  setGridUrlParam("#siae-event-grid", "FullText", $("#full-text-search").val());
  setGridUrlParam("#siae-event-grid", "EventStatus", $("[name='Status']").getCheckedValues());
  setGridUrlParam("#siae-event-grid", "OrganizerId", $("#OrganizerId").val());
  setGridUrlParam("#siae-event-grid", "TagId", ($("#TagIDs").val() || ""), true);
}

function categorySelected(categoryId) {
  setGridUrlParam("#siae-event-grid", "CategoryId", categoryId);
  changeGridPage("#siae-event-grid", "first");
}

function doDelete() {
  var ids = $("[name='EventId']").getCheckedValues();
  if (ids == "")
    showMessage("<v:itl key="@Common.NoElementWasSelected" encode="UTF-8"/>");
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteEvents",
        DeleteEvents: {
          Ids: ids
        }
      };
      
      vgsService("Siae", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.SiaeEvent.getCode()%>);
      });
    });
  }
}
</script>
<jsp:include page="/resources/common/footer.jsp"/>