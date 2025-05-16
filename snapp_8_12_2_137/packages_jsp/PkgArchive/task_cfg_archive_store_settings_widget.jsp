<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTask" scope="request"/>

<v:alert-box type="info">
  This task looks for all sales flagged are "archivable" and which are not yet "archived", serialize them and push them to the archiving database.
</v:alert-box>

<%-- 
<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:db-checkbox field="cfg.SimulationMode" value="true" caption="Simulation mode" hint="Prevents any change to be made on DB and just provide the output of what products/orders would be touched."/>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="Expire days" hint="Number of days, after product expiration date (ValidDateTo), when the product becomes eligible for archiving">
      <v:input-text field="cfg.ExpireDays" placeholder="0"/>
    </v:form-field>
    <v:form-field caption="Expire date from" hint="Include only product expired starting from specified date (included)">
      <v:input-text type="datepicker" field="cfg.ExpireDateFrom" placeholder="@Common.Unlimited"/>
    </v:form-field>
    <v:form-field caption="Expire date to" hint="Include only product expired up to specified date (included)">
      <v:input-text type="datepicker" field="cfg.ExpireDateTo" placeholder="@Common.Unlimited"/>
    </v:form-field>
    <v:form-field caption="@Product.ProductTags" hint="Include only product types matching these tags">
      <v:multibox field="cfg.ProductTagIDs" idFieldName="TagId" captionFieldName="TagName" linkEntityType="<%=LkSNEntityType.Tag_ProductType%>"/>
    </v:form-field>
  </v:widget-block>
</v:widget>


<script>

function saveTaskConfig(reqDO) {
  var config = {
    SimulationMode: $("#cfg\\.SimulationMode").isChecked(),
    ExpireDays: $("#cfg\\.ExpireDays").val(),
    ExpireDateFrom: getNull($("#cfg\\.ExpireDateFrom-picker").getXMLDate()),
    ExpireDateTo: getNull($("#cfg\\.ExpireDateTo-picker").getXMLDate()),
    ProductTagIDs: $("#cfg\\.ProductTagIDs").val()
  };
  
  reqDO.TaskConfig = JSON.stringify(config);  
}

</script>
--%>