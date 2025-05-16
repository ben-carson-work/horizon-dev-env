<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
 
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
String crossPlatformName = pageBase.getEmptyParameter("CrossPlatformName");
String crossPlatformId = pageBase.getEmptyParameter("Id");
%>

<v:dialog id="xpi-crossplatform-confirm-dialog" width="600" height="350" title="@XPI.CrossPlatform">
  <v:alert-box type="info" title="@Common.Info" style="max-height:280px;overflow:auto">
    <v:itl key="@XPI.ConfirmApproval_Line1" param1="<%=crossPlatformName%>"/><br/>
    <v:itl key="@XPI.ConfirmApproval_Line2"/><br/><br/>
    <v:itl key="@XPI.ConfirmApproval_Line3" param1="<%=crossPlatformName%>"/>
  </v:alert-box>
  <v:form-field caption="@SaleChannel.SaleChannel">
    <v:combobox field="saleChannelId" lookupDataSet="<%=pageBase.getBL(BLBO_SaleChannel.class).getSaleChannelLookupDS(LkSNSaleChannelType.External)%>" idFieldName="SaleChannelId" captionFieldName="SaleChannelName"/>
  </v:form-field>
  <v:form-field caption="@Product.Catalog">
    <v:combobox field="catalogId" lookupDataSet="<%=pageBase.getBL(BLBO_Catalog.class).getCatalogDS()%>" idFieldName="CatalogId" captionFieldName="CatalogName"/>
  </v:form-field>
    
<script>
var dlg = $("#xpi-crossplatform-confirm-dialog");
dlg.bind("snapp-dialog", function(event, params) {
  params.buttons = {
    <v:itl key="@Common.Confirm" encode="JS"/>: doConfirm,
    <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
  };
});

function doConfirm() {
  showWaitGlass();
  var reqDO = {
      Command: "FinalizeCrossPlatformHandshake",
      FinalizeCrossPlatformHandshake: {
        CrossPlatformId: <%=JvString.jsString(crossPlatformId)%>,
        SaleChannelId: $("#saleChannelId").val(),
        CatalogId: $("#catalogId").val(),
        Accept: "true"
      }
    };
    
    vgsService("Account", reqDO, false, function(ansDO) {
      hideWaitGlass();
      dlg.dialog("close");
      window.location = "<v:config key="site_url"/>/admin?page=account&id=<%=pageBase.getId()%>";
    });
}
    
</script>

</v:dialog>