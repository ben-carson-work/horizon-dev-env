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
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
String eventId = pageBase.getNullParameter("EventId");
%>

<v:wizard-step id="performance-create-wizard-step-resource" title="@Resource.ResourceManagement">
  <v:widget>
    <v:widget-block>
    <% for (DOResourceConfigRes rescfg : pageBase.getBL(BLBO_Resource.class).getResourceConfigList(eventId)) { %>
      <% for (int i=0; i<rescfg.Quantity.getInt(); i++) { %>
        <%
        String resourceTypeId = rescfg.ResourceTypeId.getString();
        JvDataSet dsResource = pageBase.getBL(BLBO_Resource.class).getResourceDS(resourceTypeId); 
        %>
        <div class="form-field resource-type" data-ResourceTypeId="<%=resourceTypeId%>">
          <div class="form-field-caption"><%=rescfg.ResourceTypeName.getHtmlString()%></div>
          <div class="form-field-value"><v:combobox idFieldName="EntityId" captionFieldName="EntityName" lookupDataSet="<%=dsResource%>" /></div>
        </div>
      <% } %>
    <% } %>
    </v:widget-block>
  </v:widget>

<script>

$(document).ready(function() {
  const $step = $("#performance-create-wizard-step-resource");
  const $wizard = $step.closest(".wizard");
  $step.vWizard("step-filldata", _stepFillData);
  
  function _stepFillData(data) {
    data.ResourceTypeList = [];
    
    var rts = $step.find(".resource-type");
    for (var i=0; i<rts.length; i++) {
      var resourceTypeId = $(rts[i]).attr("data-ResourceTypeId");
      var entityId = $(rts[i]).find("select").val();
      
      if (entityId != "") {
        var found = false;
        for (var k=0; k<reqDO.ResourceTypeList.length; k++) {
          if (data.ResourceTypeList[k].ResourceTypeId == resourceTypeId) {
            data.ResourceTypeList[k].EntityIDs.push(entityId);
            found = true;
            break;
          }
        }
        
        if (!found) {
          data.ResourceTypeList.push({
            ResourceTypeId: resourceTypeId,
            EntityIDs: [entityId]
          });
        }
      }
    }
  }
});

</script>
    
</v:wizard-step>
