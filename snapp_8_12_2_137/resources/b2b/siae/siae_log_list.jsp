<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.snapp.query.QryBO_Account"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeLookup"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaePerformance"%>
<%@page import="com.vgs.web.library.BLBO_Siae"%>
<%@page import="com.vgs.cl.lookup.LookupItem"%>
<%@page import="com.vgs.snapp.query.QryBO_Workstation"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeCard"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.cl.QueryDef"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.b2b.page.PageB2B_SiaeLogList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_SiaePerformance.class);
qdef.addSelect(QryBO_SiaePerformance.Sel.PerformanceId);
qdef.addSelect(QryBO_SiaePerformance.Sel.Title);
JvDataSet performanceDs = pageBase.execQuery(qdef);

qdef = new QueryDef(QryBO_SiaeCard.class);
qdef.addSelect(QryBO_SiaeCard.Sel.CodiceCarta);
qdef.addSort(QryBO_SiaeCard.Sel.CodiceCarta);
JvDataSet cardDs = pageBase.execQuery(qdef);

qdef = new QueryDef(QryBO_Workstation.class);
qdef.addSelect(QryBO_Workstation.Sel.WorkstationId);
qdef.addSelect(QryBO_Workstation.Sel.WorkstationName);
qdef.addSort(QryBO_Workstation.Sel.WorkstationName);
JvDataSet workstationDs = pageBase.execQuery(qdef);

qdef = new QueryDef(QryBO_SiaeLookup.class);
qdef.addSelect(QryBO_SiaeLookup.Sel.LookupItemCode);
qdef.addSelect(QryBO_SiaeLookup.Sel.CodeAndName);
qdef.addFilter(QryBO_SiaeLookup.Fil.LookupTableId, 2);
JvDataSet ordinePostoDs = pageBase.execQuery(qdef);

%>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<snp:list-tab caption="@Common.Search" fa="search"/>
<div id="main-container">
  <jsp:include page="/resources/admin/siae/siae_alert.jsp" />
  <div class="mainlist-container">
    <div class="form-toolbar">
      <v:button caption="@Common.Search" fa="search" href="javascript:search()" />
      <v:pagebox gridId="log-grid"/>
    </div>
    <div class="profile-pic-div">
      <div class="form-toolbar">
        <input type="text" id="MainFilter" class="default-focus" placeholder="Sigillo o Codice media" onkeypress="if (event.keyCode == KEY_ENTER) {search();return false;}"/>
      </div>
      <v:widget caption="Intervallo Date Emissione" icon="calendar.png"><v:widget-block>
        <label for="FromDateTime"><v:itl key="@Common.From"/></label><br/>
        <v:input-text type="datetimepicker" field="FromDateTime" style="width:120px"/>
          
        <div class="filter-divider"></div>
          
        <label for="ToDateTime"><v:itl key="@Common.To"/></label><br/>
        <v:input-text type="datetimepicker" field="ToDateTime" style="width:120px"/>
      </v:widget-block></v:widget>
  
      <v:widget caption="@Common.Filters" icon="filter.png">
        <v:widget-block>
          <label for="PerformanceId">Performance</label><br/>
          <v:combobox field="PerformanceId" lookupDataSet="<%=performanceDs%>" captionFieldName="Title" idFieldName="PerformanceId" allowNull="true"/>

          <div class="filter-divider"></div>
          <label for="CardId">Carta</label><br/>
          <v:combobox field="CardId" lookupDataSet="<%=cardDs%>" captionFieldName="CodiceCarta" idFieldName="CodiceCarta" allowNull="true"/>

          <div class="filter-divider"></div>
          <label for="CounterFilter">Progressivo</label><br/>
          <input type="text" id="CounterFilter" />        
        </v:widget-block>
        
        <v:widget-block>
          <label for="TitoloBase">Tipologia di titolo</label>
          <select id="TitoloBase">
            <option value=""></option>
            <option value="A">Abbonamento</option>
            <option value="F">Figurativo</option>
            <option value="T">Titolo</option>
          </select>
       
          <div class="filter-divider"></div>
          <label for="Operazione">Operazione</label>
          <select id="Operazione">
            <option value=""></option>
            <% for (LookupItem item: LkSN.SiaeOperationType.getItems()) {%>
            <option value="<%=item.getCode()%>"><%=item.getDescription()%></option><% } %>
          </select>
       
          <div class="filter-divider"></div>
          <label for="OrdinePosto">Ordine di posto</label>
          <v:combobox field="OrdinePosto" lookupDataSet="<%=ordinePostoDs%>" captionFieldName="CodeAndName" idFieldName="LookupItemCode" allowNull="true"/>
        </v:widget-block>
      </v:widget>
      
    </div>
    <div class="profile-cont-div">
      <v:last-error/>
      <v:async-grid id="log-grid" jsp="siae/siae_log_grid.jsp"/>
    </div>
  </div>
</div>
<script>
  $("#FullText").keypress(function(e) {
    if (e.keyCode == KEY_ENTER) {
      search();
      return false;
    }
  });

  function search() {
    setGridUrlParam("#log-grid", "MainFilter", $("#MainFilter").val());
    setGridUrlParam("#log-grid", "FromDateTime", $("#FromDateTime-picker").getXMLDateTime());
    setGridUrlParam("#log-grid", "ToDateTime", $("#ToDateTime-picker").getXMLDateTime(true));
    setGridUrlParam("#log-grid", "PerformanceId", $("#PerformanceId").val());
    setGridUrlParam("#log-grid", "CardId", $("#CardId").val());
    setGridUrlParam("#log-grid", "CounterFilter", $("#CounterFilter").val());
    setGridUrlParam("#log-grid", "TitoloBase", $("#TitoloBase").val());
    setGridUrlParam("#log-grid", "Operazione", $("#Operazione").val());
    setGridUrlParam("#log-grid", "OrdinePosto", $("#OrdinePosto").val());
    changeGridPage("#log-grid", "first");
  };
</script>
<jsp:include page="/resources/common/footer.jsp"/>