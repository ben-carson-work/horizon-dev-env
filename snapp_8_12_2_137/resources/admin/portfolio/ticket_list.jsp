<%@page import="com.vgs.snapp.web.gencache.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.library.bean.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTicketList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
String stationSerial = JvUtils.getCookieValue(request, "SNP-Audit-StationSerial");
StationBean ssb = SrvBO_Cache_Station.instance().findStationBySerial(JvString.strToIntDef(stationSerial, -1));
String defaultLocationId = (ssb != null) ? ssb.locationId : pageBase.getSession().getLocationId();
String defaultOpAreaId = (ssb != null) ? ssb.opAreaId : pageBase.getSession().getOpAreaId();
int defaultStationSerial = (ssb != null) ? ssb.stationSerial : pageBase.getSession().getStationSerial();

String defaultFiscalDate = JvUtils.getCookieValue(request, "SNP-Audit-FiscalDate");
if (defaultFiscalDate == null)
  defaultFiscalDate = pageBase.getBrowserFiscalDate().getXMLDate();
pageBase.setDefaultParameter("EncodeFiscalDate", defaultFiscalDate);
%>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>
<v:last-error/>

<script>
  function search() {
    if ($("#TicketCode").val()=="" && $("#StationSerial").val()=="")
      showMessage(itl("@Common.WorkstationIsMandatory"));
    else {
      setGridUrlParam("#ticket-grid", "TicketCode", $("#TicketCode").val());
      setGridUrlParam("#ticket-grid", "EncodeFiscalDate", $("#EncodeFiscalDate-picker").getXMLDate());
      setGridUrlParam("#ticket-grid", "StationSerial", $("#StationSerial").val() == "" ? "" : $("#StationSerial").val());
      setGridUrlParam("#ticket-grid", "TicketStatus", $("[name='Status']").getCheckedValues());
      changeGridPage("#ticket-grid", "first");
      
      setCookie("SNP-Audit-FiscalDate", $("#EncodeFiscalDate-picker").getXMLDate());
      setCookie("SNP-Audit-StationSerial", $("#StationSerial").val(), 30);
    }
  }

</script>

 
<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <v:button caption="@Common.Search" fa="search" onclick="search()" />
      <v:pagebox gridId="ticket-grid"/>
    </div>
    
    <div class="tab-content">
      <div class="profile-pic-div">
        <div class="v-filter-container">
          <div class="form-toolbar">
            <input type="text" id="TicketCode" class="form-control default-focus v-filter-code" placeholder="<v:itl key="@Common.Code"/>" onkeypress="if (event.keyCode == KEY_ENTER) {search();return false;}"/>     
          </div>
          
          <div class="v-filter-all-condition">
            <v:widget caption="@Common.Filters">
              <v:widget-block>
                <label for="EncodeFiscalDate"><v:itl key="@Common.FiscalDate"/></label><br/>
                <v:input-text type="datepicker" field="EncodeFiscalDate"/>
              </v:widget-block>
              <v:widget-block>
                <v:itl key="@Account.Location"/><br/>
                <snp:dyncombo id="LocationId" entityType="<%=LkSNEntityType.Location%>" entityId="<%=defaultLocationId%>" auditLocationFilter="true" allowNull="false"/>
                
                <div class="filter-divider"></div>
                
                <v:itl key="@Account.OpArea"/><br/>
                <snp:dyncombo id="OpAreaId" entityType="<%=LkSNEntityType.OperatingArea%>" entityId="<%=defaultOpAreaId%>" auditLocationFilter="true" allowNull="false" parentComboId="LocationId"/>
                
                <div class="filter-divider"></div>
                
                <v:itl key="@Common.Workstation"/><br/>
                <snp:dyncombo id="StationSerial" entityType="<%=LkSNEntityType.StationSerial%>" entityId="<%=String.valueOf(defaultStationSerial)%>" auditLocationFilter="true" allowNull="false" parentComboId="OpAreaId"/>
              </v:widget-block>
            </v:widget>  
            <v:widget caption="@Common.Status">
              <v:widget-block>
                <v:db-checkbox field="Status" caption="@Lookup.TicketStatusGroup.Active" value="<%=LkSNTicketStatusGroup.Active.getCode()%>" /><br/>
                <v:db-checkbox field="Status" caption="@Lookup.TicketStatusGroup.Blocked" value="<%=LkSNTicketStatusGroup.Blocked.getCode()%>" /><br/>
                <v:db-checkbox field="Status" caption="@Lookup.TicketStatusGroup.Invalid" value="<%=LkSNTicketStatusGroup.Invalid.getCode()%>" />
              </v:widget-block>
            </v:widget>
          </div>
        </div>
        
      </div>
    
      <div class="profile-cont-div">
        <% String params = "LicenseId=" + pageBase.getSession().getLicenseId() + "&StationSerial=" + defaultStationSerial + "&EncodeFiscalDate=" + defaultFiscalDate + "&MultiPage=false"; %>
        <v:async-grid id="ticket-grid" jsp="portfolio/ticket_grid.jsp" params="<%=params%>" />
      </div>
    </div>
  </v:tab-item-embedded>
</v:tab-group>


<jsp:include page="/resources/common/footer.jsp"/>
