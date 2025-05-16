<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<div class="tab-toolbar">
  <v:button caption="@Common.New" fa="plus" bindGrid="envelope-grid"  bindGridEmpty="true" onclick="asyncDialogEasy('seat/seat_envelope_dialog', 'id=new')"/>
  <v:button caption="@Common.Delete" title="@Common.DeleteSelectedItems" fa="trash" bindGrid="envelope-grid" onclick="doDeleteSeatEnvelopes()"/>
  <v:pagebox gridId="envelope-grid"/>
</div>

<div class="tab-content">
  <v:last-error/>
  <v:async-grid id="envelope-grid" jsp="seat/seat_envelope_grid.jsp" />
</div>

<script>
function doDeleteSeatEnvelopes() {
  confirmDialog(null, function() {
    var reqDO = {
      Command: "DeleteEnvelope",
      DeleteEnvelope: {
        SeatEnvelopeIDs: $("[name='SeatEnvelopeId']").getCheckedValues()
      }
    };
    
    vgsService("Seat", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.SeatEnvelope.getCode()%>);
    });
  });
}
</script>

