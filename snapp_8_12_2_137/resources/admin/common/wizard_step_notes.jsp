<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
boolean canCreateNoteType = LkSNHighlightedNoteRightLevel.Create.check(rights.HighlightedNote);
%>

<v:wizard-step id="wizard-step-notes" title="@Common.Notes">
  <v:input-txtarea field="Note" rows="16"/>
  <% if (canCreateNoteType) { %>
    <v:widget>
      <v:widget-block>
        <v:db-checkbox field="NoteHighlighted" value="true" caption="@Common.Highlighted"/>
      </v:widget-block>
    </v:widget>
  <% } %>

<script>
//# sourceURL=wizard_step_notes.jsp

$(document).ready(function() {
  const $step = $("#wizard-step-notes");
  const $wizard = $step.closest(".wizard");

  $step.vWizard("step-validate", function(callback) {
    // TODO: When "highlightd" is flagged, we should check that the note is filled in
    callback();
  });
  
  $(document).von($step, "wizard-transaction-fillrequest", function(event, transactionDO) {
    transactionDO.Note     = $step.find("#Note").val(),
    transactionDO.NoteType = $step.find("#NoteHighlighted").isChecked() ? <%=LkSNNoteType.Highlighted.getCode()%> : <%=LkSNNoteType.Standard.getCode()%>
  });
});

</script>
    
</v:wizard-step>
