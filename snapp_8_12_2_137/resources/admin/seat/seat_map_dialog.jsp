<%@page import="com.vgs.web.library.seat.BLBO_SeatEnvelope"%>
<%@page import="java.util.*"%>
<%@page import="org.apache.catalina.startup.*"%>
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
<%
BLBO_Seat bl = pageBase.getBL(BLBO_Seat.class);
String performanceId = pageBase.getNullParameter("PerformanceId");
String accessAreaId = pageBase.getNullParameter("AccessAreaId");

DOSeatMapDialogInfo dialogInfo = bl.loadSeatMapDialogInfo(pageBase.getId(), performanceId, accessAreaId, pageBase.isNewItem());
DOSeatMap map = dialogInfo.SeatMap;
boolean canEdit = dialogInfo.CanEdit.getBoolean();
request.setAttribute("dialogMapInfo", dialogInfo);
request.setAttribute("map", map);
String rootSectorId = pageBase.isNewItem() ? JvUtils.newSqlStrUUID() : map.SeatSectorId.getString();
%>

<v:dialog id="seat_map_dialog" title="@Seat.Capacity" showTitlebar="false">
  <jsp:include page="seat_map_dialog_css.jsp"/>
  <jsp:include page="seat_map_dialog_js.jsp"/>

  <script>
  var dlg = $("#seat_map_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.dialogClass = "seat_map_dialog_class";
    params.closeOnEscape = false;
    params.editable = <%=canEdit%>;
  });
  </script>
  
  <style>
    <% JvDataSet dsCat1 = pageBase.getBL(BLBO_Seat.class).getSeatCategoryDS(); %>
    <% JvDataSet dsEnv1 = pageBase.getBL(BLBO_SeatEnvelope.class).getSeatEnvelopeDS(); %>
    <v:ds-loop dataset="<%=dsCat1%>">
      .vse-map[data-viewtype='cat'] .vse-seat[data-category='<%=dsCat1.getField("AttributeItemId").getHtmlString()%>'] {
        fill: <%=dsCat1.getField("SeatCategoryColor").getHtmlString()%>;
      }
    </v:ds-loop>
    <v:ds-loop dataset="<%=dsEnv1%>">
      .vse-map[data-viewtype='env'] .vse-seat[data-envelope='<%=dsEnv1.getField("SeatEnvelopeId").getHtmlString()%>'] {
        fill: #<%=dsEnv1.getField("SeatEnvelopeColor").getHtmlString()%>;
      }
    </v:ds-loop>
  </style>
  
  <style id="sector-style"></style>

  <div class="vse-editor">
    <div class="vse-toolbar">
      <v:button caption="@Common.Save" fa="save" href="javascript:saveMap()" enabled="<%=canEdit%>"/>
      <% String hrefExport = ConfigTag.getValue("site_url") + "/admin?page=account&action=export-seatmap&id=" + pageBase.getId(); %>
      <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" href="<%=hrefExport%>"/>
      <span class="divider"></span>
      <div class="btn-group">
        <% String sUndo = pageBase.getLang().Common.Undo.getText() + " (CTRL+Z)"; %>
        <v:button id="btn-undo" fa="undo" title="<%=sUndo%>" href="javascript:vseAction_Undo()" enabled="<%=canEdit%>"/>
        <% String sRedo = pageBase.getLang().Common.Redo.getText() + " (CTRL+Y)"; %>
        <v:button id="btn-redo" fa="redo" title="<%=sRedo%>" href="javascript:vseAction_Redo()" enabled="<%=canEdit%>"/>
      </div>
      <div class="btn-group">
        <v:button id="btn-newseat-up" fa="sort-numeric-up" title="@Seat.NewSeatUpHint" href="javascript:vseAction_CreateSeat(+1)" enabled="<%=canEdit%>"/>
        <v:button id="btn-newseat-down" fa="sort-numeric-down" title="@Seat.NewSeatDownHint" href="javascript:vseAction_CreateSeat(-1)" enabled="<%=canEdit%>"/>
        <v:button id="btn-newseat-rect" fa="plus-square" title="@Seat.NewSeatRect" href="javascript:$('#btn-newseat-rect').toggleClass('selected')" enabled="<%=canEdit%>"/>
        <% String sDelSeat = pageBase.getLang().Seat.RemoveSeat.getText() + " (DEL)"; %>
        <v:button id="btn-delseat" fa="trash" title="<%=sDelSeat%>" href="javascript:vseAction_DeleteSeat()" enabled="<%=canEdit%>"/>
        <% String sLasso = pageBase.getLang().Seat.LassoSelection.getText(); %>
        <v:button id="btn-lasso" fa="lasso" title="<%=sLasso%>" href="javascript:vseAction_Lasso()" enabled="<%=canEdit%>"/>
        <% String sSelect = pageBase.getLang().Seat.SimilarSelection.getText(); %>
        <v:button id="btn-select" fa="object-group" title="<%=sSelect%>" href="javascript:popupMenu('#similar-select-popup', '#btn-select', event)" enabled="<%=canEdit%>"/>
        <% String sBreakLink = pageBase.getLang().Seat.BreakLink.getText() + " (CTRL+B)"; %>
        <v:button id="btn-break" fa="unlink" title="<%=sBreakLink%>" href="javascript:vseAction_BreakLink()" enabled="<%=canEdit%>"/>
        <% String sJoinSeats = pageBase.getLang().Seat.JoinSeats.getText() + " (CTRL+J)"; %>
        <v:button id="btn-join" fa="link" title="<%=sJoinSeats%>" href="javascript:startLineDraw()" enabled="<%=canEdit%>"/>
        <% String sAlignSeats = pageBase.getLang().Seat.AlignSeats.getText() + " (CTRL+A)"; %>
        <v:button id="btn-align" fa="bezier-curve" title="<%=sAlignSeats%>" href="javascript:vseAction_AlignSeats()" enabled="<%=canEdit%>"/>
        <% String sInvert = pageBase.getLang().Seat.InvertDirection.getText() + " (CTRL+U)"; %>
        <v:button id="btn-invert" fa="exchange-alt" title="<%=sInvert%>" href="javascript:vseAction_InvertDirection()" enabled="<%=canEdit%>"/>
      </div>
      <v:button id="btn-sectors" caption="@Seat.Sectors" fa="chart-pie"  href="javascript:showSectorsDialog()" enabled="<%=canEdit%>"/>
      <span class="divider"></span>
      <div id="btnset-viewtype" class="btn-group" data-toggle="buttons">
        <label class="btn btn-default"><input type="radio" id="radio-viewtype-cat" name="radio-viewtype" value="cat"><label for="radio-viewtype-cat" class="no-select"><v:itl key="@Seat.Category"/></label></label>
        <label class="btn btn-default"><input type="radio" id="radio-viewtype-sec" name="radio-viewtype" value="sec"><label for="radio-viewtype-sec" class="no-select"><v:itl key="@Seat.Sector"/></label></label>
        <label class="btn btn-default"><input type="radio" id="radio-viewtype-env" name="radio-viewtype" value="env"><label for="radio-viewtype-env" class="no-select"><v:itl key="@Seat.Envelope"/></label></label>
        <label class="btn btn-default"><input type="radio" id="radio-viewtype-mis" name="radio-viewtype" value="mis"><label for="radio-viewtype-mis" class="no-select"><v:itl key="@Seat.MissingJoin"/></label></label>
        <% if (!map.PerformanceId.isNull()) { %>
          <label class="btn btn-default"><input type="radio" id="radio-viewtype-status" name="radio-viewtype" value="status"><label for="radio-viewtype-status" class="no-select"><v:itl key="@Common.Status"/></label></label>
        <% } %>
      </div>
      <span class="divider"></span>
      <div class="vse-slider-value">100%</div><div class="vse-slider"></div>
      
      <div class="zoom-value" style="display:inline-block; text-align:center; width:50px; margin-left:10px"></div>
      <div class="zoom-slider" style="display:inline-block; width:200px"></div>
      
      <div class="btn-close-dialog" onclick="closeMapEditorDialog()"><i class="fa fa-times"></i></div>
    </div>
    
    <v:popup-menu id="similar-select-popup">
      <v:popup-item caption="@Seat.Category" href="javascript:vseAction_Select('data-category')"/>
      <v:popup-item caption="@Seat.Sector" href="javascript:vseAction_Select('data-sector')"/>
      <v:popup-item caption="@Seat.Envelope" href="javascript:vseAction_Select('data-envelope')"/>
    </v:popup-menu>
    
    <div id="sectors-dialog" title="<v:itl key="@Seat.Sectors"/>" class="v-hidden">
      <table style="width:100%">
        <% JvDataSet dsSec1 = pageBase.getBL(BLBO_Seat.class).getSeatSectorDS(rootSectorId); %>
        <v:ds-loop dataset="<%=dsSec1%>">
          <tr data-sectorid="<%=dsSec1.getField("SeatSectorId").getHtmlString()%>">
            <td><div class="color-box"></div></td>
            <td><input type="text" class="sector-name" value="<%=dsSec1.getField("SeatSectorName").getHtmlString()%>"/></td>
            <td align="right"><a class="del-link" href="javascript:doDelSector('<%=dsSec1.getField("SeatSectorId").getHtmlString()%>')"><v:itl key="@Common.Delete"/></a></td>
          </tr>
        </v:ds-loop>
        <tr id="tr-newsector">
          <td></td> 
          <td width="100%"><input type="text" class="sector-name"/></td>
          <td width="100px" nowrap align="right"><v:button fa="plus" caption="@Common.Add" href="javascript:doAddSector()"/></td>
        </tr>
      </table>
    </div>
    
    <div id="nsrect-dialog" class="v-hidden" title="<v:itl key="@Seat.SeatMap"/>">
      <v:widget caption="@Common.Properties">
        <v:widget-block>
          <v:form-field caption="@Seat.Rows"><input type="number" id="nsrect-rows" class="form-control" value="10"/></v:form-field>
          <v:form-field caption="@Seat.Cols"><input type="number" id="nsrect-cols" class="form-control" value="10"/></v:form-field>
        </v:widget-block>
        <v:widget-block>
          <v:form-field caption="@Seat.RowLabelStart">
            <input type="text" class="form-control" id="nsrect-rowlabelstart" value="A"/>
          </v:form-field>
          <v:form-field caption="@Seat.RowDirection">
            <select id="nsrect-rdir" class="form-control">
              <option value="top-to-bottom"><v:itl key="@Seat.TopToBottom"/></option>
              <option value="bottom-to-top"><v:itl key="@Seat.BottomToTop"/></option>
            </select>
          </v:form-field>
          <v:form-field caption="@Seat.ColLabelStart">
            <input type="text" class="form-control" id="nsrect-collabelstart" value="1"/>
          </v:form-field>
          <v:form-field caption="@Seat.ColDirection">
            <select id="nsrect-cdir" class="form-control">
              <option value="left-to-right"><v:itl key="@Seat.LeftToRight"/></option>
              <option value="right-to-left"><v:itl key="@Seat.RightToLeft"/></option>
            </select>
          </v:form-field>
        </v:widget-block>
        <v:widget-block>
          <v:form-field caption="@Seat.WeightPattern">
            <select id="nsrect-wpattern" class="form-control">
              <option value="serpentine"><v:itl key="@Seat.WeightPattern_Serpentine"/></option>
              <option value="zigzag"><v:itl key="@Seat.WeightPattern_ZigZag"/></option>
            </select>
          </v:form-field>
          <v:form-field caption="@Seat.VerticalDirection"> 
            <select id="nsrect-vdir" class="form-control">
              <option value="top-to-bottom"><v:itl key="@Seat.TopToBottom"/></option>
              <option value="bottom-to-top"><v:itl key="@Seat.BottomToTop"/></option>
            </select>
          </v:form-field>
          <v:form-field caption="@Seat.HorizontalDirection">
            <select id="nsrect-hdir" class="form-control">
              <option value="left-to-right"><v:itl key="@Seat.LeftToRight"/></option>
              <option value="right-to-left"><v:itl key="@Seat.RightToLeft"/></option>
            </select>
          </v:form-field>
        </v:widget-block>
        <v:widget-block>
          <v:form-field caption="@Seat.Width"><input type="number" id="nsrect-width" class="form-control" value="15"/></v:form-field>
          <v:form-field caption="@Seat.Height"><input type="number" id="nsrect-height" class="form-control" value="15"/></v:form-field>
        </v:widget-block>
        <v:widget-block>
          <v:form-field caption="@Seat.Category"><select id="nsrect-category" class="form-control"></select></v:form-field>
          <v:form-field caption="@Seat.Sector"><select id="nsrect-sector" class="form-control"></select></v:form-field>
          <v:form-field caption="@Seat.Envelope"><select id="nsrect-envelope" class="form-control"></select></v:form-field>
        </v:widget-block>
      </v:widget>
    </div>
  
    <jsp:include page="seat_map_widget.jsp">
      <jsp:param name="RenderSeatLines" value="true"/>
    </jsp:include>
    
    <div class="vse-objinsp">
      <%-- PERFORMANCE INFO --%>
      <% if (!map.PerformanceId.isNull()) { %>
      <%
      QueryDef qdef = new QueryDef(QryBO_Performance.class);
      // Select
      qdef.addSelect(
          QryBO_Performance.Sel.PerformanceId,
          QryBO_Performance.Sel.DateTimeFrom,
          QryBO_Performance.Sel.EventId,
          QryBO_Performance.Sel.EventName,
          QryBO_Performance.Sel.IconName,
          QryBO_Performance.Sel.EventProfilePictureId);
      qdef.addFilter(QryBO_Performance.Fil.PerformanceId, map.PerformanceId.getString());
      JvDataSet dsPerf = pageBase.execQuery(qdef);
      %>
        <table id="perf-prop" class="vse-property-table">
          <tbody>
            <tr><td class="vse-property-section" colspan="100%"><v:itl key="@Performance.Performance"/></td></tr>
            <tr>
              <td rowspan="2" style="padding:4px 4px 0px 4px">
                <%
                String profilePictureId = dsPerf.getField(QryBO_Performance.Sel.EventProfilePictureId).getString();
                String iconName = dsPerf.getField(QryBO_Performance.Sel.IconName).getString();
                %>
                <v:grid-icon size="64" name="<%=iconName%>" repositoryId="<%=profilePictureId%>"/>
              </td>
              <td valign="bottom" width="100%"><strong><%=pageBase.format(dsPerf.getField(QryBO_Performance.Sel.DateTimeFrom), pageBase.getShortDateTimeFormat())%></strong></td>
            </tr>
            <tr>
              <td valign="top"><%=dsPerf.getField(QryBO_Performance.Sel.EventName).getHtmlString()%></td>
            </tr>
          </tbody>
        </table>
      <% } %>
      <%-- MAP PROPERTIES --%>
      <table id="doc-prop" class="vse-property-table">
        <tbody>
          <tr><td class="vse-property-section" colspan="100%">Chart</td></tr>
          <tr>
            <th><v:itl key="@Common.Name"/></th>
            <td><input type="text" class="vse-item-prop" id="prop-map-name" value="<%=map.SeatMapName.getHtmlString()%>"/></td>
          </tr>
          <tr>
            <th><v:itl key="@Seat.BackgroundImage"/></th>
            <% String hrefBG = "javascript:showRepositoryPickup(" + LkSNEntityType.AccessArea.getCode() + ", '" + map.AccessAreaId.getEmptyString() + "')"; %>
            <td><v:button caption="..." href="<%=hrefBG%>" enabled="<%=canEdit%>"/></td>
          </tr>
        </tbody>
      </table>
      
      <%-- SEAT PROPERTIES --%>
      <table id="item-prop" class="vse-property-table">
        <tbody>
          <tr><td class="vse-property-section" colspan="100%"><v:itl key="@Common.Info"/></td></tr>
          <tr>
            <th><v:itl key="@Seat.SelectedCount"/></th>
            <td><input type="text" class="vse-item-prop" id="prop-seat-selcount" disabled/></td>
          </tr>
        </tbody>
        <tbody>
          <tr><td class="vse-property-section" colspan="100%">Labels</td></tr>
          <tr>
            <th><v:itl key="@Seat.RowLabel"/></th>
            <td><input type="text" class="vse-item-prop" id="prop-seat-row" <%=(canEdit && map.PerformanceId.isNull()) ? "" : "disabled"%>/></td>
          </tr>
          <tr>
            <th><v:itl key="@Seat.ColLabel"/></th>
            <td><input type="text" class="vse-item-prop" id="prop-seat-col" <%=(canEdit && map.PerformanceId.isNull()) ? "" : "disabled"%>/></td>
          </tr>
        </tbody>
        <tbody>
          <tr><td class="vse-property-section" colspan="100%"><v:itl key="@Common.Properties"/></td></tr>
          <tr>
            <th><v:itl key="@Seat.Category"/></th>
            <td>
              <v:combobox 
                  field="prop-seat-category" 
                  lookupDataSet="<%=pageBase.getBL(BLBO_Seat.class).getSeatCategoryDS()%>" 
                  idFieldName="AttributeItemId" 
                  captionFieldName="AttributeItemName" 
                  groupFieldName="AttributeId" 
                  groupLabelFieldName="AttributeName"
                  clazz="vse-item-prop"
                  enabled="<%=canEdit%>"/>
              
              <script>    
              <% JvDataSet dsCat2 = pageBase.getBL(BLBO_Seat.class).getSeatCategoryDS(); %>
              <v:ds-loop dataset="<%=dsCat2%>">
                <% String id = dsCat2.getField("AttributeItemId").getString(); %>
                <% String col = dsCat2.getField("SeatCategoryColor").getString(); %>
                $("#prop-seat-category option[value='<%=id%>']").attr("data-color", "<%=col%>");
              </v:ds-loop>
              </script>
            </td>
          </tr>
          <tr>
            <th><v:itl key="@Seat.Sector"/></th>
            <td>
              <v:combobox 
                  field="prop-seat-sector" 
                  lookupDataSet="<%=pageBase.getBL(BLBO_Seat.class).getSeatSectorDS(pageBase.isNewItem() ? JvUtils.newSqlStrUUID() : map.SeatSectorId.getString())%>" 
                  idFieldName="SeatSectorId" 
                  captionFieldName="SeatSectorName" 
                  clazz="vse-item-prop"
                  enabled="<%=canEdit%>"/>
            </td>
          </tr>
          <tr>
            <th><v:itl key="@Seat.Envelope"/></th>
            <td>
              <v:combobox 
                  field="prop-seat-envelope" 
                  lookupDataSet="<%=pageBase.getBL(BLBO_SeatEnvelope.class).getSeatEnvelopeDS()%>" 
                  idFieldName="SeatEnvelopeId" 
                  captionFieldName="SeatEnvelopeName" 
                  clazz="vse-item-prop"
                  enabled="<%=canEdit%>"/>
            </td>
          </tr>
          <tr>
            <th><v:itl key="@Seat.AisleLeft"/></th>
            <td>
              <select class="vse-item-prop" id="prop-seat-aisleleft" <%=canEdit ? "" : "disabled"%>>
                <option value="false"><v:itl key="@Common.No"/></option>
                <option value="true"><v:itl key="@Common.Yes"/></option>
              </select>
            </td>
          </tr>
          <tr>
            <th><v:itl key="@Seat.AisleRight"/></th>
            <td>
              <select class="vse-item-prop" id="prop-seat-aisleright" <%=canEdit ? "" : "disabled"%>>
                <option value="false"><v:itl key="@Common.No"/></option>
                <option value="true"><v:itl key="@Common.Yes"/></option>
              </select>
            </td>
          </tr>
          <tr>
            <th><v:itl key="@Seat.BreakType"/></th>
            <td><v:lk-combobox lookup="<%=LkSN.SeatBreakType%>" field="prop-seat-break" clazz="vse-item-prop" allowNull="false" enabled="<%=canEdit%>"/></td>
          </tr>
        </tbody>
        <tbody>
          <tr><td class="vse-property-section" colspan="100%">Dimensions</td></tr>
          <tr>
            <th>Left</th>
            <td><input type="text" class="vse-item-prop" id="prop-seat-x" <%=canEdit ? "" : "disabled"%>/></td>
          </tr>
          <tr>
            <th>Top</th>
            <td><input type="text" class="vse-item-prop" id="prop-seat-y" <%=canEdit ? "" : "disabled"%>/></td>
          </tr>
          <tr>
            <th><v:itl key="@Seat.Width"/></th>
            <td><input type="text" class="vse-item-prop" id="prop-seat-width" <%=canEdit ? "" : "disabled"%>/></td>
          </tr>
          <tr>
            <th><v:itl key="@Seat.Height"/></th>
            <td><input type="text" class="vse-item-prop" id="prop-seat-height" <%=canEdit ? "" : "disabled"%>/></td>
          </tr>
          <tr>
            <th><v:itl key="@Seat.Rotation"/></th>
            <td><input type="text" class="vse-item-prop" id="prop-seat-rotation" <%=canEdit ? "" : "disabled"%>/></td>
          </tr>
        </tbody>
      </table>
      
      <%-- CATEGORIES --%>
      <table id="catstatus-prop" class="vse-property-table">
        <tbody>
          <tr><td class="vse-property-section" colspan="100%"><v:itl key="@Seat.Categories"/></td></tr>
        </tbody>
        <tbody id="catstatus-tbody">
        </tbody>
      </table>
      
      <%-- SEAT STATUS --%>
      <table id="seatstatus-prop" class="vse-property-table">
        <tbody>
          <tr><td class="vse-property-section" colspan="100%"><v:itl key="@Common.Status"/></td></tr>
        </tbody>
        <tbody id="seatstatus-tbody">
          <tr>
            <th>
              <div class="legend-color" style="background-color:white"></div>
              <v:itl key="@Seat.Counter_Avail"/>
            </th>
            <td></td>
          </tr>
          <tr>
            <th>
              <div class="legend-color" style="background-color:var(--base-orange-color)"></div>
              <v:itl key="@Seat.Counter_Held"/>
            </th>
            <td></td>
          </tr>
          <tr>
            <th>
              <div class="legend-color" style="background-color:var(--base-green-color)"></div>
              <v:itl key="@Seat.Counter_Reserved"/>
            </th>
            <td></td>
          </tr>
          <tr>
            <th>
              <div class="legend-color" style="background-color:var(--base-blue-color)"></div>
              <v:itl key="@Seat.Counter_Paid"/>
            </th>
            <td></td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>

</v:dialog>


