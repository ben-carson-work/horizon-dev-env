<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.web.library.BLBO_Tag"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.bko.page.PageBO_StatsSalesByAttribute" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% 
QueryDef qdef = new QueryDef(QryBO_SaleChannel.class);
//Select
qdef.addSelect(QryBO_SaleChannel.Sel.SaleChannelId);
qdef.addSelect(QryBO_SaleChannel.Sel.SaleChannelName);
//Paging
//Sort
qdef.addSort(QryBO_SaleChannel.Sel.SaleChannelName);
//Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("dsSaleChannel", ds);

String defaultLocationId = rights.MasterLocationId.isNull(pageBase.getSession().getLocationId());
String dateFromDefault = pageBase.getFiscalDate().getXMLDate();
String dateToDefault = pageBase.getFiscalDate().getXMLDate();
pageBase.setDefaultParameter("DateFrom", dateFromDefault);
pageBase.setDefaultParameter("DateTo", dateToDefault);

DOStat stats = (DOStat)request.getAttribute("stats"); 
%>
<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<style>

tr.optional {
  text-decoration: underline;
}

tr.optional td.item-desc {
  padding-left: 20px;
}

tr.product td.item-desc {
  padding-left: 40px;
}

.quantity,
.amount {
  text-align: right;
}

</style>

<script>
  function getStringParam(selector) {
    var value = $(selector).val();
    return (value == null) ? "" : value;
  }

  function doApply() {
    setGridUrlParam("#sales-by-attribute-data", "DateFrom", $("#DateFrom-picker").getXMLDate());
    setGridUrlParam("#sales-by-attribute-data", "DateTo", $("#DateTo-picker").getXMLDate());
    setGridUrlParam("#sales-by-attribute-data", "LocationId", getStringParam("#LocationId"));
    setGridUrlParam("#sales-by-attribute-data", "OpAreaId", getStringParam("#OpAreaId"));
    setGridUrlParam("#sales-by-attribute-data", "WorkstationId", getStringParam("#WorkstationId"));
    setGridUrlParam("#sales-by-attribute-data", "SaleChannelId", getStringParam("#SaleChannelId"));
    setGridUrlParam("#sales-by-attribute-data", "TagIDs", ($("#TagIDs").val() || ""));
    
    changeGridPage("#sales-by-attribute-data", "first");
  }
</script>

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Dashboard" default="true">
    <form id="filter-form" action="<%=pageBase.getContextURL()%>?page=stats_sales_by_attribute" method="post">
      <div class="tab-toolbar">
        <v:button caption="@Common.Apply" fa="search" href="javascript:doApply()"/>
      </div>
    
      <div class="tab-content">
        <div class="profile-pic-div">
          <v:widget caption="@Common.DateRange">
           <v:widget-block>
             <v:itl key="@Common.FromDate"/><br/>
             <v:input-text type="datepicker" field="DateFrom"/>
             <br/>
             <v:itl key="@Common.ToDate"/><br/>
             <v:input-text type="datepicker" field="DateTo"/>
           </v:widget-block>
         </v:widget>
         
         <v:widget caption="@Account.Location">
           <v:widget-block>
            <v:itl key="@Account.Location"/><br/>
            <snp:dyncombo id="LocationId" entityType="<%=LkSNEntityType.Location%>" entityId="<%=defaultLocationId%>" auditLocationFilter="true" allowNull="<%=(rights.AuditLocationFilter.isLookup(LkSNAuditLocationFilter.All) ? true : false) %>"/>
            
            <br/>
            
            <v:itl key="@Account.OpArea"/><br/>
            <snp:dyncombo id="OpAreaId" entityType="<%=LkSNEntityType.OperatingArea%>" parentComboId="LocationId" auditLocationFilter="true"/>
            
            <br/>
            
            <v:itl key="@Common.Workstation"/><br/>
            <snp:dyncombo id="WorkstationId" entityType="<%=LkSNEntityType.Workstation%>" parentComboId="OpAreaId" auditLocationFilter="true"/>
           </v:widget-block>
         </v:widget>
         
         <v:widget caption="@Common.Filters">
           <v:widget-block>
             <v:itl key="@SaleChannel.SaleChannel"/><br/>
             <v:combobox field="SaleChannelId" lookupDataSetName="dsSaleChannel" idFieldName="SaleChannelId" captionFieldName="SaleChannelName" style="width:98%"/>
             
             <v:itl key="@Product.ProductTags"/><br/>
            <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
            <v:multibox field="TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName"/>
          </v:widget-block>
         </v:widget>
        </div>
      </form>
     
      <div class="profile-cont-div">
        <% String params = "DateFrom=" + dateFromDefault + "&DateTo=" + dateToDefault + "&LocationId=" + JvString.getEmpty(defaultLocationId); %>
        <v:async-grid id="sales-by-attribute-data" jsp="stats/stats_sales_by_attribute_data.jsp" params="<%=params%>"/>
      </div>
    </div>
  </v:tab-item-embedded>
</v:tab-group>  
 
<jsp:include page="/resources/common/footer.jsp"/>
