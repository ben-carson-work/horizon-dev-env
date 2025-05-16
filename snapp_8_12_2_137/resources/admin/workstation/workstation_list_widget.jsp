<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 
boolean isXPI = pageBase.isParameter("Xpi", "true");
boolean canCreate = rights.SystemSetupWorkstations.getOverallCRUD().canCreate() && 
                    rights.SystemSetupWorkstationDemographic.getBoolean() && 
                    rights.SystemSetupWorkstationActivationKey.getBoolean() && 
                    !isXPI;

boolean canDelete = rights.SystemSetupWorkstations.getOverallCRUD().canDelete() && !isXPI;

String locationId = pageBase.getNullParameter("LocationAccountId");
String opAreaId = pageBase.getNullParameter("OpAreaAccountId");
if ((locationId == null) && (opAreaId != null))
  locationId = pageBase.getBL(BLBO_Account.class).getParentAccountId(opAreaId);
%>

<v:page-form>

<v:tab-toolbar>
  <v:button-group>
    <v:button-group>
      <v:button caption="@Common.New" fa="plus" dropdown="true" enabled="<%=canCreate%>"/>
  	  <v:popup-menu bootstrap="true" include="<%=canCreate%>">
        <% for (LookupItem item : LkSNWorkstationType.getCreateWorkstationTypes()) { %>
          <v:popup-item clazz="menu-newwks" caption="<%=item.getDescription(pageBase.getLang())%>" attributes="<%=TagAttributeBuilder.builder().put(\"data-workstationtype\", item.getCode())%>"/>
        <% } %> 
      </v:popup-menu>
    </v:button-group>
    
    <v:button caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" onclick="deleteWorkstations()" enabled="<%=canDelete%>"/>
  </v:button-group>
  
  <v:pagebox gridId="workstation-grid"/>
</v:tab-toolbar>

<v:tab-content>  
  <% String params = "LocationAccountId=" + pageBase.getEmptyParameter("LocationAccountId") + "&OpAreaAccountId=" + pageBase.getEmptyParameter("OpAreaAccountId"); %>
  <v:async-grid id="workstation-grid" jsp="workstation/workstation_grid.jsp" params="<%=params%>"/>
</v:tab-content>
 
</v:page-form>


<script>
$(document).ready(function() {
  $(".menu-newwks").click(newWorkstation);

  function newWorkstation() {
    var workstationType = $(this).closest(".menu-newwks").attr("data-workstationtype");
    createNewWorkstation(workstationType, <%=JvString.jsString(locationId)%>, <%=JvString.jsString(opAreaId)%>, null);
  }
  
});

</script>
