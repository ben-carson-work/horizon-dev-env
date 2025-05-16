<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMeasureSetup" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<div class="tab-toolbar">
  <v:button caption="@Common.New" fa="plus" href="admin?page=measure&id=new"/>
  <v:button caption="@Common.Delete" fa="trash" onclick="deleteMeasures()"/>
  <span class="divider"></span>
  <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.Measure.getCode() + ")";%>
  <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/> 
  <v:pagebox gridId="measure-grid"/>
</div>
    
<v:last-error/>

<div class="tab-content">
  <v:async-grid id="measure-grid" jsp="inventory/measure_grid.jsp" />
</div>

<script>
  function deleteMeasures() {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteMeasure",
        DeleteMeasure: {
          MeasureIDs: $("[name='MeasureId']").getCheckedValues()
        }
      };
      
      vgsService("Measure", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.Measure.getCode()%>);      
      });
    });
  }
</script>
