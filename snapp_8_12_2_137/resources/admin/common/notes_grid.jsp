<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Note.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
boolean canEdit = !pageBase.isParameter("ReadOnly", "true");
boolean canDelete = canEdit && rights.NoteDelete.getBoolean();
boolean canCreateNoteType = canEdit && LkSNHighlightedNoteRightLevel.Create.check(rights.HighlightedNote);
boolean canEditNoteType = canEdit && LkSNHighlightedNoteRightLevel.Edit.check(rights.HighlightedNote);
int highlightedCount = 0;

QueryDef qdef = new QueryDef(QryBO_Note.class);
// Select
qdef.addSelect(
    Sel.NoteId,
    Sel.EntityType,
    Sel.EntityId,
    Sel.NoteDateTime,
    Sel.UserAccountId,
    Sel.UserAccountName,
    Sel.UserProfilePictureId,
    Sel.WorkstationId,
    Sel.WorkstationName,
    Sel.LocationId,
    Sel.LocationName,
    Sel.OpAreaId,
    Sel.OpAreaName,
    Sel.TransactionId,
    Sel.TransactionCode,
    Sel.NoteType,
    Sel.Note);
// Where
qdef.addFilter(Fil.EntityId, pageBase.getNullParameter("EntityId"));
// Sort 
qdef.addSort(Sel.NoteDateTime, false);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
%>

<style>
#notes_grid .note-type-icon {
  text-align: center;
}

#notes_grid .note-type-standard .note-type-icon {
  display: none;
}

#notes_grid tr:not(:hover) .btn-note-type {
  display: none;
}

#notes_grid .note-type-highlighted .btn-set-as-highlighted {
  display: none;
}

#notes_grid .note-type-standard .btn-set-as-standard {
  display: none;
}

#notes_grid .highlighted-only .note-type-standard {
  display: none;
}

#notes_grid .note-type-highlighted .note-area td {
  color: var(--base-red-color);
}

</style>

<v:grid style="margin-top:10px">
  <thead>
    <tr>
      <td colspan="100%" class="widget-title">
        <v:button id="btn-highlighted-only" caption="@Common.ShowOnlyHighlightedNotes" title="@Common.ShowOnlyHighlightedNotesHint" fa="exclamation-triangle" enabled="false"/>
        
        <div class="btn-group">
          <div class="btn-group">
            <v:button caption="@Common.Status" title="@Product.NewProductType" dropdown="true" fa="flag" enabled="<%=canEditNoteType%>"/>
            <v:popup-menu bootstrap="true">
              <v:popup-item id="menu-note-type-standard" caption="Set as standard" fa="horizontal-rule"/>
              <v:popup-item id="menu-note-type-highlighted" caption="Set as highlighted" fa="exclamation-triangle"/>
            </v:popup-menu>
          </div>
          <v:button id="btn-note-delete" caption="@Common.Delete" fa="trash" enabled="<%=canDelete%>"/>
        </div>
      </td>
    </tr>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td></td>
      <td width="70%">
        <v:itl key="@Common.Workstation"/><br/>
        <v:itl key="@Common.DateTime"/>
      </td>
      <td width="30%" align="right">
        <v:itl key="@Common.Transaction"/>
      </td>
    </tr>
  </thead>
  <v:ds-loop dataset="<%=ds%>">
    <%
    LookupItem noteType = LkSN.NoteType.findItemByCode(ds.getField(Sel.NoteType));
    String sNoteTypeClass = "note-type-standard";
    LookupItem commonStatus = null;
    if (noteType.isLookup(LkSNNoteType.Highlighted)) {
      sNoteTypeClass = "note-type-highlighted";
      commonStatus = LkCommonStatus.Deleted;
      highlightedCount++;
    }
    %>
    <tbody class="notes-tbody <%=sNoteTypeClass%>" data-noteid="<%=ds.getField(Sel.NoteId).getHtmlString()%>">
      <tr class="grid-row">
        <td style="<v:common-status-style status="<%=commonStatus%>"/>">
          <div><v:grid-checkbox name="cbNoteId"/></div>
          <div class="note-type-icon"><i class="fas fa-exclamation-triangle"></i></div>  
        </td>
        <td><v:grid-icon name="account_prs.png" repositoryId="<%=ds.getField(Sel.UserProfilePictureId).getString()%>"/></td>
        <td>
          <% if (!ds.getField(Sel.UserAccountId).isNull()) { %>
            <snp:entity-link entityId="<%=ds.getField(Sel.UserAccountId)%>" entityType="<%=LkSNEntityType.Person%>">
              <%=ds.getField(Sel.UserAccountName).getHtmlString()%>
            </snp:entity-link>
          <% } %>
        
          <%=pageBase.getLang().Common.On.getText()%>
        
          <snp:entity-link entityId="<%=ds.getField(Sel.LocationId)%>" entityType="<%=LkSNEntityType.Location%>">
            <%=ds.getField(Sel.LocationName).getHtmlString()%>
          </snp:entity-link>
          &raquo;
          <snp:entity-link entityId="<%=ds.getField(Sel.OpAreaId)%>" entityType="<%=LkSNEntityType.OperatingArea%>">
            <%=ds.getField(Sel.OpAreaName).getHtmlString()%>
          </snp:entity-link>
          &raquo;
          <snp:entity-link entityId="<%=ds.getField(Sel.WorkstationId)%>" entityType="<%=LkSNEntityType.Workstation%>">
            <%=ds.getField(Sel.WorkstationName).getHtmlString()%>
          </snp:entity-link>
        
          <br/>
        
          <snp:datetime timestamp="<%=ds.getField(Sel.NoteDateTime)%>" format="shortdatetime" timezone="local"/>
        </td>
        <td align="right">
          <% if (!ds.getField(Sel.TransactionId).isNull()) { %>
            <snp:entity-link entityId="<%=ds.getField(Sel.TransactionId).getString()%>" entityType="<%=LkSNEntityType.Transaction%>"><%=ds.getField(Sel.TransactionCode).getHtmlString()%></snp:entity-link>
          <% } else { %>
            &mdash;
          <% } %>
        </td>
      </tr>
      <tr class="note-area" noteId="<%=ds.getField(Sel.NoteId).getString()%>">
        <td style="<v:common-status-style status="<%=commonStatus%>"/>"></td>
     		<td colspan="4">
     		  <span style="word-break: break-all;">
             <%=ds.getField(Sel.Note).getHtmlString()%>
           </span>
     		</td>
      </tr>
    </tbody>
  </v:ds-loop> 
</v:grid>


<script>
  $(document).ready(function() {
    var $grid = $("#notes_grid");
    _refreshEnabled();
   
    $grid.find("#btn-highlighted-only").click(function() {
      var $this = $(this);
      _setHighlighted($this, !$this.is(".active"));
    });
    
    //If at least an highlighted note is present the note list is filtered by highlighted as default
    <% if ((highlightedCount > 0) && rights.ShowOnlyHighlightedNotesByDefault.getBoolean()) { %>
      _setHighlighted("#btn-highlighted-only", true);
    <% } %>
    
    $grid.find("#menu-note-type-standard").click(function() {
      _changeNoteType(<%=LkSNNoteType.Standard.getCode()%>);
    });
    
    $grid.find("#menu-note-type-highlighted").click(function() {
      _changeNoteType(<%=LkSNNoteType.Highlighted.getCode()%>);
    });
    
    $grid.find("#btn-note-delete").click(function() {
      var noteIDs = _getCheckedNoteIDs();
      if (noteIDs.length <= 0)
        showMessage(itl("@Common.NoElementWasSelected"));
      else {
        confirmDialog(itl("@Common.NoteDeleteConfirm"), function() {
          var reqDO = {
            Command: "DeleteNote",
            DeleteNote: {
              NoteIDs: noteIDs
            }
          };

          showWaitGlass();
          vgsService("Note", reqDO, false, function(ansDO) {
            hideWaitGlass();
            changeGridPage("#notes_grid", 1);
          });
        });
      }
    });
    
    function _refreshEnabled() {
      $("#btn-highlighted-only").setEnabled($grid.find(".notes-tbody.note-type-highlighted").length > 0);
    }
    
    function _setHighlighted(selector, value) {
      var active = (value === true);
      $(selector).setClass("active", active).closest(".listcontainer").setClass("highlighted-only", active);
    }
    
    function _getCheckedNoteIDs() {
      var noteIDs = [];
      $grid.find("[name='cbNoteId']:checked").closest("tbody").each(function(index, elem) {
        noteIDs.push($(elem).attr("data-noteid"));
      });
      return noteIDs;
    }
    
    function _changeNoteType(noteType) {
      var noteIDs = _getCheckedNoteIDs();
      if (noteIDs.length <= 0)
        showMessage(itl("@Common.NoElementWasSelected"));
      else {
        var reqDO = {
          Command: "ChangeNoteType",
          ChangeNoteType: {
            NoteIDs: noteIDs,
            NoteType: noteType
          }
        };
  
        showWaitGlass();
        vgsService("Note", reqDO, false, function(ansDO) {
          hideWaitGlass();
          changeGridPage("#notes_grid", 1);
        });
      }
    }
  });
</script>