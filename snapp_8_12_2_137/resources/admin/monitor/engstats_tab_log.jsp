<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.database.*"%>
<%@page import="java.util.Map.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<style>
.download-btn {
  color: rgba(0,0,0,0.2);
  font-size: 32px;
  cursor: pointer;
}

.download-btn:hover {
  color: var(--base-red-color);
}

</style>

<div class="tab-toolbar">
</div>

<div class="tab-content">
  <div class="profile-pic-div">
    <jsp:include page="server_grid_widget.jsp"/>
  </div>

  <div class="profile-cont-div">
    <v:grid id="log-list-grid">
      <thead>
        <td width="50%">
          <v:itl key="@Common.Name"/><br/>
          <v:itl key="Path"/>
        </td>
        <td width="50%" align="right">
          <v:itl key="@Common.LastUpdate"/><br/>
          <v:itl key="@Common.Size"/>
        </td>
        <td></td>
      </thead>
      <tbody></tbody>
    </v:grid>
  </div>
</div>

<div id="templates" class="hidden">
  <table>
    <tr class="log-item">
      <td>
        <strong><span class='item-filename'></span></strong>
        <br/>
        <span class='item-filepath list-subtitle'></span>
      </td>
      <td align="right">
        <span class='item-lastupd'></span>
        <br/>
        <span class='item-filesize list-subtitle'></span>
      </td>
      <td align="right"><i class="fa fa-download download-btn row-hover-visible"></i></td>
    </tr>
  </table>
</div>


<script>

$(document).ready(function() {

  function refresh() {
    var serverId = $("#server-grid tr.selected").attr("data-serverid");
    showWaitGlass();
    vgsService("System", {Command:"GetLogFileNames", ForwardToServerId:serverId}, false, function(ansDO) {
      hideWaitGlass();
      var $tbody = $("#log-list-grid tbody");
      $tbody.empty();
      
      if ((ansDO.Answer) && (ansDO.Answer.GetLogFileNames)) {
        var list = ansDO.Answer.GetLogFileNames.LogFileList;
        if (list) {
          for (var i=0; i<list.length; i++) {
            var item = list[i];
            var $tr = $("#templates tr.log-item").clone().appendTo($tbody);
            $tr.attr("data-filename", encodeURIComponent(item.FileName));
            $tr.find(".item-filename").text(item.FileName);
            $tr.find(".item-filepath").text(item.FilePath);
            $tr.find(".item-filesize").text(getSmoothSize(item.FileSize));
            
            var dt = xmlToDate(item.LastModified); 
            $tr.find(".item-lastupd").text(formatDate(dt) + " " + formatTime(dt));
            
            $tr.find(".download-btn").click(function() {
              window.location = <%=JvString.jsString(pageBase.getContextURL())%> + "?page=tomcat_log&FileName=" + $(this).closest("tr").attr("data-filename") + "&ForwardToServerId=" + serverId; 
            });
          }
        }
      }
    });
  };
  
  $("#server-grid tr.grid-row").click(refresh);
  
  refresh();
});

</script>