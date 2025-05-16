<%@page import="com.vgs.web.library.seat.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
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
BLBO_SeatEnvelope bl = pageBase.getBL(BLBO_SeatEnvelope.class);
DOSeatEnvelope envelope = pageBase.isNewItem() ? bl.prepareNewEnvelope() : bl.loadEnvelope(pageBase.getId());
request.setAttribute("envelope", envelope);

boolean canEdit = true; 
request.setAttribute("EntityRight_CanEdit", canEdit);
request.setAttribute("EntityRight_RightList", envelope.RightList);
request.setAttribute("EntityRight_EntityTypes", new LookupItem[] {LkSNEntityType.Workstation, LkSNEntityType.Person, LkSNEntityType.Organization});
request.setAttribute("EntityRight_ShowRightLevelAutofill", false);
request.setAttribute("EntityRight_ShowRightLevelEdit", false);
request.setAttribute("EntityRight_ShowRightLevelDelete", false);
%>

<v:dialog id="seat_envelope_dialog" tabsView="true" title="@Seat.Envelope" width="800" height="620" autofocus="false">
  <v:tab-group name="tab" main="true">
    <v:tab-item-embedded tab="tabs-main" caption="@Common.Profile" default="true">
      <jsp:include page="seat_envelope_dialog_tab_main.jsp"/>
    </v:tab-item-embedded>
  
    <v:tab-item-embedded tab="tabs-right" caption="@Common.Rights">
      <jsp:include page="../common/page_tab_rights.jsp"/>
    </v:tab-item-embedded>
    
    <% if (!pageBase.isNewItem() && rights.History.getBoolean()) { %>
      <v:tab-item-embedded tab="tabs-history" caption="@Common.History">
        <jsp:include page="../common/page_tab_historydetail.jsp"/>
      </v:tab-item-embedded>
    <% } %>
  </v:tab-group>

<script>
var dlg = $("#seat_envelope_dialog");
dlg.on("snapp-dialog", function(event, params) {
  params.buttons = [
    <% if (canEdit) { %>
      {
        "text": itl("@Common.Save"),
        "click": doSaveEnvelope
      },
    <% } %>
    {
      "text": itl("@Common.Cancel"),
      "click": doCloseDialog
      }
  ];


});

function doSaveEnvelope() {
  var reqDO = {
    Command: "SaveEnvelope",
    SaveEnvelope: {
      SeatEnvelope: {
        SeatEnvelopeId: <%=envelope.SeatEnvelopeId.getJsString()%>,
        SeatEnvelopeCode: $("#envelope\\.SeatEnvelopeCode").val(),
        SeatEnvelopeName: $("#envelope\\.SeatEnvelopeName").val(),
        SeatEnvelopeColor: $("[name='envelope\\.SeatEnvelopeColor']").val(),
        ExclusiveUse: $("#envelope\\.ExclusiveUse").isChecked(),
        Extra: $("#envelope\\.Extra").isChecked(),
        SwapHours: $("#envelope\\.SwapHours").val(),
        SwapSeatEnvelopeId: $("#envelope\\.SwapSeatEnvelopeId").val(),
        SeatEnvelopePriority: $("#envelope\\.SeatEnvelopePriority").val(),
        RightList: []
      }
    }
  };
  
  var rows = $("#entityright-grid tbody tr").not(".group");
  for (var i=0; i<rows.length;  i++) {
    reqDO.SaveEnvelope.SeatEnvelope.RightList.push({
      UsrEntityType: $(rows[i]).attr("data-EntityType"),  
      UsrEntityId: $(rows[i]).attr("data-EntityId"),
      RightLevel: <%=LkSNRightLevel.Read.getCode()%>
    });
  }
  
  vgsService("Seat", reqDO, false, function(ansDO) {
    triggerEntityChange(<%=LkSNEntityType.SeatEnvelope.getCode()%>);
    dlg.dialog("close");
  });
}

</script>

</v:dialog>


