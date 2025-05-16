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
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
String saleItemId = pageBase.getNullParameter("SaleItemId");
List<DOSeatListDialogInfo> rows = pageBase.getBL(BLBO_Seat.class).loadSeatListDialogInfo(saleItemId);
%>

<v:dialog id="seat_list_dialog" title="@Seat.Seats" width="600" height="400" autofocus="false">
  
<v:grid>
  <thead>
    <tr>
      <td width="30%"><v:itl key="@Seat.Sector"/></td>
      <td width="30%"><v:itl key="@Seat.Category"/></td>
      <td width="20%"><v:itl key="@Seat.Row"/></td>
      <td width="20%"><v:itl key="@Seat.Col"/></td>
    </tr>
  </thead>
  <tbody>
    <% for (DOSeatListDialogInfo row : rows) { %>
    <tr>
      <td><%=row.SeatSectorName.getHtmlString()%></td>
      <td><%=row.SeatCategoryName.getHtmlString()%></td>
      <td><%=row.SeatRow.getHtmlString()%></td>
      <td><%=row.SeatCol.getHtmlString()%></td>
    </tr>
    <% } %>
  </tbody>
</v:grid>


<script>
var $dlg = $("#seat_list_dialog");
$dlg.on("snapp-dialog", function(event, params) {
  params.buttons = [
    dialogButton("@Common.Cancel", doCloseDialog)
  ];
});
</script>

</v:dialog>


