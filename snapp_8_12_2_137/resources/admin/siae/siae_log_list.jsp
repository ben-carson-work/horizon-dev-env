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

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSiaeLogList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
String defaultLocationId = pageBase.getSession().getLocationId();

QueryDef qdef = new QueryDef(QryBO_SiaeCard.class);
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

JvDataSet partnerAccountDs = pageBase.getDB().executeQuery(
    "select" + JvString.CRLF + 
    "  AccountId as PartnerAccountId," + JvString.CRLF +
    "  DisplayName as PartnerAccountName" + JvString.CRLF +
    "from" + JvString.CRLF + 
    "  tbAccount" + JvString.CRLF +
    "where" + JvString.CRLF + 
    "  EntityType=" + LkSNEntityType.Organization.getCode());

BLBO_Siae bl = pageBase.getBL(BLBO_Siae.class);
int gaps = bl.countGaps();
boolean isSiaeEnabled = bl.isSiaeEnabled();

%>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<snp:list-tab caption="@Common.Search" fa="search"/>
<div id="main-container">
  <div class="mainlist-container">
    <jsp:include page="/resources/admin/siae/siae_alert.jsp" />
    <% if (gaps > 0) { %>
      <div class="errorbox">E' stato riscontrato un disallineamento dei numeri progressivi</div>
    <% } %>
    <div class="form-toolbar">
      <v:button caption="@Common.Search" fa="search" href="javascript:search()" />
      <v:button caption="@Common.Delete" fa="trash" enabled="<%=isSiaeEnabled%>"  href="javascript:doDelete()" />
      <% if (rights.VGSSupport.getBoolean()) { %>
        <% String hrefImport = "javascript:asyncDialogEasy('siae/siae_seal_import_dialog')"; %>
        <v:button caption="@Common.Import" fa="sign-in" href="<%=hrefImport%>" enabled="<%=isSiaeEnabled%>"/>
      <% } %>
      <v:pagebox gridId="log-grid"/>
    </div>
    <div class="profile-pic-div">
      <div class="form-toolbar">
        <input type="text" id="MainFilter" class="form-control default-focus" placeholder="Sigillo o Codice media" onkeypress="if (event.keyCode == KEY_ENTER) {search();return false;}"/>
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
          <snp:dyncombo field="PerformanceId" id="PerformanceId" entityType="<%=LkSNEntityType.SiaePerformance%>"/>
          <div class="filter-divider"></div>
          <label for="CardId">Carta</label><br/>
          <v:combobox field="CardId" lookupDataSet="<%=cardDs%>" captionFieldName="CodiceCarta" idFieldName="CodiceCarta" allowNull="true"/>

          <div class="filter-divider"></div>
          <label for="CounterFilter">Progressivo</label><br/>
          <input type="text" id="CounterFilter" class="form-control"/>        
        </v:widget-block>
        
        <v:widget-block>
          <label for="TitoloBase">Titolo base</label>
          <select id="TitoloBase" class="form-control">
            <option value=""></option>
            <option value="A">Abbonamento</option>
            <option value="F">Figurativo</option>
            <option value="T">Titolo</option>
          </select>
       
          <div class="filter-divider"></div>
          <label for="Operazione">Operazione</label>
          <select id="Operazione" class="form-control">
            <option value=""></option>
            <% for (LookupItem item: LkSN.SiaeOperationType.getItems()) {%>
              <% if (item.isLookup(LkSNSiaeOperationType.EMIT, LkSNSiaeOperationType.VOID)) { %>  
                <option value="<%=item.getCode()%>"><%=item.getDescription()%></option>
              <% } %>
            <% } %>
          </select>
       
          <div class="filter-divider"></div>
          <label for="OrdinePosto">Ordine di posto</label>
          <v:combobox field="OrdinePosto" lookupDataSet="<%=ordinePostoDs%>" captionFieldName="CodeAndName" idFieldName="LookupItemCode" allowNull="true"/>
          
          <div class="filter-divider"></div>
          <label for="TipoTitolo">Tipo titolo</label>
          <snp:dyncombo id="TipoTitolo" entityType="<%=LkSNEntityType.SiaeLKTipoTitolo%>"/>
        </v:widget-block>
      </v:widget>
        
      <v:widget caption="@Common.Filters" icon="filter.png">
        <v:widget-block>
          <v:itl key="@Account.Location"/><br/>
          <snp:dyncombo id="LocationId" entityType="<%=LkSNEntityType.Location%>"/>
          
          <div class="filter-divider"></div>
          
          <v:itl key="@Account.OpArea"/><br/>
          <snp:dyncombo id="OpAreaId" entityType="<%=LkSNEntityType.OperatingArea%>" parentComboId="LocationId"/>
          
          <div class="filter-divider"></div>
          
          <v:itl key="@Common.Workstation"/><br/>
          <snp:dyncombo id="WorkstationId" entityType="<%=LkSNEntityType.Workstation%>" parentComboId="OpAreaId"/>
          
          <div class="filter-divider"></div>
          
          <label for="CodiceRichiedente">Codice richiedente emissione sigillo</label><br/>
          <input type="text" id="CodiceRichiedente" class="form-control"/>        
        </v:widget-block>
  
        <v:widget-block>
          <label for="PartnerAccountId">Partner</label><br/>
          <snp:dyncombo id="PartnerAccountId" entityType="<%=LkSNEntityType.Organization%>"/>
        </v:widget-block>
      </v:widget>
    </div>
    <div class="profile-cont-div">
      <v:last-error/>
      <% String params = "";//"WksLocationId=" + JvString.getEmpty(defaultLocationId); %>
      <v:async-grid id="log-grid" jsp="siae/siae_log_grid.jsp" params="<%=params%>"/>
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
    setGridUrlParam("#log-grid", "TipoTitolo", $("#TipoTitolo").val());
    setGridUrlParam("#log-grid", "WksLocationId", ($("#LocationId").getComboIndex() < 0) ? "" : $("#LocationId").val());
    setGridUrlParam("#log-grid", "OpAreaId", ($("#OpAreaId").getComboIndex() <= 0) ? "" : $("#OpAreaId").val());
    setGridUrlParam("#log-grid", "WorkstationId", ($("#WorkstationId").getComboIndex() <= 0) ? "" : $("#WorkstationId").val());
    setGridUrlParam("#log-grid", "CodiceRichiedente", $("#CodiceRichiedente").val());
    setGridUrlParam("#log-grid", "PartnerAccountId", ($("#PartnerAccountId").getComboIndex() <= 0) ? "" : $("#PartnerAccountId").val());  
    changeGridPage("#log-grid", "first");
  };
  
  function doDelete() {
    var ids = $("[name='Sigillo']").getCheckedValues();
    if (ids == "")
      showMessage("<v:itl key="@Common.NoElementWasSelected" encode="UTF-8"/>");
    else {
      confirmDialog(null, function() {
        var reqDO = {
          Command: "DeleteLogs",
          DeleteLogs: {
            Ids: ids
          }
        };
        
        vgsService("Siae", reqDO, false, function(ansDO) {
          triggerEntityChange(<%=LkSNEntityType.SiaeLog.getCode()%>);
        });
      });
    }
  }

</script>
<jsp:include page="/resources/common/footer.jsp"/>