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

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMediaList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
String stationSerial = JvUtils.getCookieValue(request, "SNP-Audit-StationSerial");
StationBean sb = SrvBO_Cache_Station.instance().findStationBySerial(JvString.strToIntDef(stationSerial, -1));
String defaultLocationId = (sb != null) ? sb.locationId : pageBase.getSession().getLocationId();
String defaultOpAreaId = (sb != null) ? sb.opAreaId : pageBase.getSession().getOpAreaId();
int defaultStationSerial = (sb != null) ? sb.stationSerial : pageBase.getSession().getStationSerial();

String defaultFiscalDate = JvUtils.getCookieValue(request, "SNP-Audit-FiscalDate");
if (defaultFiscalDate == null)
  defaultFiscalDate = pageBase.getBrowserFiscalDate().getXMLDate();
pageBase.setDefaultParameter("EncodeFiscalDate", defaultFiscalDate);
%>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<v:last-error/>

<script>
 function showUpdateStatusDialog() {
    var mediaIDs = $("[name='MediaId']").getCheckedValues();
	var requireImport = (mediaIDs == "");
    asyncDialogEasy("portfolio/media_change_status_dialog", "mediaIDs=" + mediaIDs + "&requireImport=" + requireImport);
  }

  function search() {
    if ($("#MediaCode").val()=="" && $("#StationSerial").val()=="")
      showMessage(<v:itl key="@Common.WorkstationIsMandatory" encode="JS"/>);
    else {
      setGridUrlParam("#media-grid", "MediaCode", $("#MediaCode").val());
      setGridUrlParam("#media-grid", "EncodeFiscalDate", $("#EncodeFiscalDate-picker").getXMLDate());
      setGridUrlParam("#media-grid", "StationSerial", $("#StationSerial").val() == "" ? "" : $("#StationSerial").val());
      setGridUrlParam("#media-grid", "ActiveMedia", $("[name='Status']").val());
      changeGridPage("#media-grid", "first");
      
      setCookie("SNP-Audit-FiscalDate", $("#EncodeFiscalDate-picker").getXMLDate());
      setCookie("SNP-Audit-StationSerial", $("#StationSerial").val(), 30);
    }
  }
</script>


<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <v:button caption="@Common.Search" fa="search" href="javascript:search()" />
      <span class="divider"></span> 
      <v:button caption="@Common.Status" fa="lock" bindGrid="media-grid" bindGridEmpty="false" title="@Media.ChangeMediaStatus" enabled="<%=pageBase.getRights().MediaBlock.getBoolean()%>" href="javascript:showUpdateStatusDialog()"/>
      <% if (rights.ExternalMediaImport.getBoolean()) { %>
        <div class="btn-group">
          <v:button caption="@Common.Import" fa="sign-in" dropdown="true"/>
          <v:popup-menu bootstrap="true">
            <v:popup-item caption="@Media.Import_EncodeMediaProduct" onclick="asyncDialogEasy('portfolio/media_import_dialog')"/>
            <v:popup-item caption="@Media.Import_AddMediaCode" onclick="asyncDialogEasy('portfolio/mediacode_import_dialog')"/>
          </v:popup-menu>
        </div>
      <% } %>
      
      <v:pagebox gridId="media-grid"/>
    </div>

    <div class="tab-content">
      <div class="profile-pic-div">
        <div class="v-filter-container">
          <div class="form-toolbar">
            <input type="text" id="MediaCode" class="form-control default-focus v-filter-code" placeholder="<v:itl key="@Common.MediaCode"/>" onkeypress="if (event.keyCode == KEY_ENTER) {search();return false;}"/>     
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
                  <select name="Status" class="form-control">
                    <option value="0"><v:itl key="@Common.All"/></option>
                    <option value="1"><v:itl key="@Common.Active"/></option>
                    <option value="2"><v:itl key="@Common.Inactive"/></option>
                  </select>
              </v:widget-block>
            </v:widget>
          </div>
        </div>
      
      </div>
      
      <div class="profile-cont-div">
        <% String params = "LicenseId=" + pageBase.getSession().getLicenseId() + "&StationSerial=" + defaultStationSerial + "&EncodeFiscalDate=" + defaultFiscalDate + "&MultiPage=false"; %>
        <v:async-grid id="media-grid" jsp="portfolio/media_grid.jsp" params="<%=params%>" />
      </div>
    </div>
  </v:tab-item-embedded>
</v:tab-group>
  


<jsp:include page="/resources/common/footer.jsp"/>
