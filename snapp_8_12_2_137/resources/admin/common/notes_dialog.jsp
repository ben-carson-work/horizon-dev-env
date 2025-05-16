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

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<style>

#btn-new-note {
  position: sticky;
  left: 950px;
  margin-top: 5px;
}

</style>

<%
boolean canEdit = !pageBase.isParameter("ReadOnly", "true");
boolean canCreateNoteType = LkSNHighlightedNoteRightLevel.Create.check(rights.HighlightedNote);
boolean canEditNoteType = LkSNHighlightedNoteRightLevel.Edit.check(rights.HighlightedNote);
%>

<v:dialog id="notes_dialog" title="@Common.Notes" width="1024" height="700">
  <v:widget>
    <v:widget-block>
      <textarea id="txt-new-note" class="form-control" rows="5" cols="10" placeholder="<v:itl key="@Common.AddNoteHint"/>"/></textarea>
      <% if (canCreateNoteType || canEditNoteType) { %>
		    <v:db-checkbox field="NoteType" value="true" caption="@Common.Highlighted"/>
      <% } %>
      <v:button id="btn-new-note" caption="@Common.Add" fa="plus" enabled="<%=canEdit%>"/>
    </v:widget-block>
  </v:widget>

  <div>
    <% String params = "EntityId=" + pageBase.getId(); %>
    <v:async-grid id="notes_grid" jsp="common/notes_grid.jsp" params="<%=params%>" />
  </div>


<script>
  $(document).ready(function() {
    var $dlg = $("#notes_dialog");
    var entityType = <%=Integer.parseInt(pageBase.getParameter("EntityType"))%>;
    var entityId = <%=JvString.jsString(pageBase.getId())%>;
    var disableTriggerNotification = <%=pageBase.isParameter("DisableTriggerNotification", "true")%>;
    var notesChanged = false;
    
    $dlg.on("snapp-dialog", function(event, params) {
      params.buttons = [
        {
          "text": itl("@Common.Close"),
          "click": closeDialog
        }
      ];
      
      params.beforeClose = function(event, ui) {
        if (_getNewNoteTrimmedText() != "") {
          if ($dlg.attr("data-forceclose") == "true") {
            _reloadLocationIfNeeded();
            return true;
          }
          else {
            confirmDialog(itl("@Common.ContinueWithoutSaveConfirm"), _closeConfirmOK, null);
            return false;
          }
        }
        _reloadLocationIfNeeded();
      }
    });
   
    $dlg.find("#btn-new-note").click(_doAddNote);

    function closeDialog() {
      $dlg.dialog("close");
    }
    
    function _closeConfirmOK() {
      $dlg.attr("data-forceclose", "true");
      $dlg.dialog("close");
    }
    
    function _getNewNoteTrimmedText() {
      return $dlg.find("#txt-new-note").val().trim();
    }
    
    function _doAddNote() {
      var txt = _getNewNoteTrimmedText();
      if (txt != "") {
        
        noteType = $("#NoteType").isChecked() ? <%=LkSNNoteType.Highlighted.getCode()%> : <%=LkSNNoteType.Standard.getCode()%>;
        noteTypeClass = $("#NoteType").isChecked() ? "higlighted" : "standard";
        
        var reqDO = {
          Command: "AddNote",
          AddNote: {
            EntityType: entityType,
            EntityId: entityId,
            NoteType: noteType,
            Message: txt
          }
        };
        
        vgsService("Note", reqDO, false, function(ansDO) {
          $dlg.find(".no-items").remove();
          $dlg.find("#txt-new-note").val("");
          $dlg.find("#NoteType").prop("checked", false );
          
          changeGridPage("#notes_grid", 1);
          notesChanged = true;
        });
      }
    }
    
    function _reloadLocationIfNeeded() {
      if ((notesChanged === true) && (disableTriggerNotification !== true))
        entitySaveNotification(entityType, entityId);
    }
  });
  
</script>

</v:dialog>