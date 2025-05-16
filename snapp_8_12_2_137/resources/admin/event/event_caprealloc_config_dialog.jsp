<%@page import="com.vgs.web.library.seat.BLBO_SeatEnvelope"%>
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

<% 
String[] seatCategoryIDs = JvArray.stringToArray(pageBase.getNullParameter("SeatCategoryIDs"), ",");
String[] seatEnvelopeIDs = JvArray.stringToArray(pageBase.getNullParameter("SeatEnvelopeIDs"), ",");

JvDataSet dsCat = pageBase.getBL(BLBO_Seat.class).getSeatCategoryDS(); 
JvDataSet dsEnv = pageBase.getBL(BLBO_SeatEnvelope.class).getSeatEnvelopeDS();
%>

<v:dialog id="event_caprealloc_config_dialog" tabsView="true" title="@Event.CapacityReallocation" width="800" height="600" autofocus="false">
   
<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-main" caption="@Common.Settings" default="true">
    <v:tab-content>
      <table id="config-table" style="width:100%">
        <tr>
          <td width="50%" valign="top">
            <v:widget caption="@Seat.Categories">
              <v:widget-block>
                <% String lastAttributeId = null; %>
                <v:ds-loop dataset="<%=dsCat%>">
                  <% 
                  if (!dsCat.getField("AttributeId").isSameString(lastAttributeId)) {
                    if (lastAttributeId != null)
                      %><div>&nbsp;</div><%
                    lastAttributeId = dsCat.getString("AttributeId");
                    %><div class="cat-group"><%=dsCat.getField("AttributeName").getHtmlString()%></div><%
                  }
                  %>
                  <div class="cat-item"><v:db-checkbox field="SeatCategoryId" value="<%=dsCat.getField(\"AttributeItemId\").getHtmlString()%>" caption="<%=dsCat.getField(\"AttributeItemName\").getHtmlString()%>" checked="<%=JvArray.contains(dsCat.getString(\"AttributeItemId\"), seatCategoryIDs)%>"/></div>
                </v:ds-loop>
              </v:widget-block>
            </v:widget>
          </td> 

          <td>&nbsp;&nbsp;</td>

          <td width="50%" valign="top">
            <v:widget caption="@Seat.Envelopes">
              <v:widget-block>
                <v:ds-loop dataset="<%=dsEnv%>">
                  <div><v:db-checkbox field="SeatEnvelopeId" value="<%=dsEnv.getField(\"SeatEnvelopeId\").getHtmlString()%>" caption="<%=dsEnv.getField(\"SeatEnvelopeName\").getHtmlString()%>" checked="<%=JvArray.contains(dsEnv.getString(\"SeatEnvelopeId\"), seatEnvelopeIDs)%>"/></div>
                </v:ds-loop>
              </v:widget-block>
            </v:widget>
          </td>
        </tr>
      </table>
    </v:tab-content>
  </v:tab-item-embedded>
</v:tab-group>

<style>
#event_caprealloc_config_dialog .cat-group {font-weight:bold}
#event_caprealloc_config_dialog .cat-item {margin-left: 20px}
</style>

<script>

$(document).ready(function() {
  var $dlg = $("#event_caprealloc_config_dialog");
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      dialogButton("@Common.Save", _save),
      dialogButton("@Common.Cancel", doCloseDialog)
    ];
  });
  
  function _getCheckedValues(htmlFieldName, idFieldName, captionFieldName) {
    var result = [];
    
    $dlg.find("[name='" + htmlFieldName + "']:checked").each(function() {
      var item = {};
      item[idFieldName] = $(this).val();
      item[captionFieldName] = $(this).closest("label").find("span").text();
      result.push(item);
    });
    
    return result;
  }

  function _save() {
    $(document).trigger("caprealloc-config", {
      "SeatCategoryList": _getCheckedValues("SeatCategoryId", "SeatCategoryId", "SeatCategoryName"),
      "SeatEnvelopeList": _getCheckedValues("SeatEnvelopeId", "SeatEnvelopeId", "SeatEnvelopeName")
    });

    $dlg.dialog("close");
  }
});
</script>

</v:dialog>


