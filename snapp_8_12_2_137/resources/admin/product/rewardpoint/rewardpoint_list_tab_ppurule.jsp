<%@page import="com.vgs.cl.JvArray"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageRewardPointList" scope="request"/>
<% boolean defaultStatusFilter = true; %>

<div class="tab-toolbar">
  <v:button id="search-btn" caption="@Common.Search" fa="search"/>
  <span class="divider"></span>
  <v:button caption="@Common.New" fa="plus" onclick="asyncDialogEasy('product/ppurule/ppurule_dialog', 'id=new')"/>
  <v:button caption="@Common.Delete" title="@Common.DeleteSelectedItems" fa="trash" onclick="doDeletePPURules()"/>
  <v:hint-handle hint="@Product.PPURuleHint"/>
  <v:pagebox gridId="ppurule-grid"/>
</div>

<div class="tab-content">
  <div class="profile-pic-div">
    <div class="v-filter-container">
      <v:widget>
        <v:widget-block>
          <v:itl key="@Product.MembershipPoint"/><br/>
          <snp:dyncombo field="MembershipPointId" entityType="<%=LkSNEntityType.WalletAndRewardPoint%>"/>
        </v:widget-block>
      </v:widget>
       
      <v:widget caption="@Common.Status">
         <v:widget-block>
           <v:db-checkbox field="Status" caption="@Common.ActiveOnly" value="true" checked="<%=defaultStatusFilter%>"/><br/>
           <v:db-checkbox field="Status" caption="@Common.Inactive" value="false"/>                 
        </v:widget-block>
      </v:widget>
      
          <v:widget caption="@Common.Restrictions">
       <v:widget-block>
         <v:itl key="@Account.Location"/><br/>
         <snp:dyncombo field="LocationId" entityType="<%=LkSNEntityType.Location%>"/>
         
         <div class="filter-divider"></div>
         
         <v:itl key="@Account.OpArea"/><br/>
         <snp:dyncombo field="OpAreaId" entityType="<%=LkSNEntityType.OperatingArea%>" parentComboId="LocationId"/>
          
         <div class="filter-divider"></div>
         
         <v:itl key="@AccessPoint.AccessPoint"/><br/>
         <snp:dyncombo field="AccessPointId" entityType="<%=LkSNEntityType.AccessPoint%>" parentComboId="OpAreaId"/>
          
         <div class="filter-divider"></div>
         
         <v:itl key="@Event.Event"/><br/>
           <% JvDataSet dsEvent = pageBase.getBL(BLBO_Event.class).getEventDS(); %>
         <snp:dyncombo field="EventIDs" entityType="<%=LkSNEntityType.Event%>" />
           <!--<v:multibox field="EventIDs" lookupDataSet="<%=dsEvent%>" idFieldName="EventId" captionFieldName="EventName" allowNull="true" />
         </v>  -->       
       </v:widget-block>
       
       <v:widget-block>
         <v:itl key="@Product.ProductTypes"/><br/>
           <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
           <v:multibox field="ProductTagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName" allowNull="true" />
         </v>
       </v:widget-block>         
     </v:widget> 
     
    </div>
  </div>
  <div class="profile-cont-div">
    <v:last-error/>
    <% String params = "PPURuleStatus=" + defaultStatusFilter; %>
    <v:async-grid id="ppurule-grid" jsp="product/ppurule/ppurule_grid.jsp" params="<%=params%>"/>
  </div>
</div>


<script>
$(document).ready(function() {
  $("#search-btn").click(search);

  function search() {
    try {
      setGridUrlParam("#ppurule-grid", "MembershipPointId", $("#MembershipPointId").val() || "");
      setGridUrlParam("#ppurule-grid", "PPURuleStatus", $("[name='Status']").getCheckedValues());
      setGridUrlParam("#ppurule-grid", "LocationId", $("#LocationId").val() || "");
      setGridUrlParam("#ppurule-grid", "OpAreaId", $("#OpAreaId").val() || "");
      setGridUrlParam("#ppurule-grid", "AccessPointId", $("#AccessPointId").val() || "");
      
      setGridUrlParam("#ppurule-grid", "EventIDs", $("#EventIDs").val() || "");
      setGridUrlParam("#ppurule-grid", "ProductTagIDs", $("#ProductTagIDs").val().join(","));
      
      changeGridPage("#ppurule-grid", "first");
    }
    catch (err) {
      showMessage(err);
    }
  }
});

function doDeletePPURules() {
  confirmDialog(null, function() {
    var reqDO = {
      Command: "DeletePPURule",
      DeletePPURule: {
        PPURuleIDs: $("[name='PPURuleId']").getCheckedValues()
      }
    };
    
    vgsService("Product", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.RewardPointRule.getCode()%>);
    });
  });
}

</script>