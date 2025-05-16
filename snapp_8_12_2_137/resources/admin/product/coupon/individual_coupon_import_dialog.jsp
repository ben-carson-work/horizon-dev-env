<%@page import="com.vgs.snapp.library.AsyncProcessUtils"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:dialog id="account-extmedia-import-dialog" title="@Coupon.ImportIndividualCouponCodesHint" width="800" height="600" autofocus="false">
  <div id="step-input">
    <v:widget caption="@Common.Parameters">
      <v:widget-block>
        <jsp:include page="../../repository/file_upload_widget.jsp"/>
      </v:widget-block>
    </v:widget>
 
    <v:alert-box type="info" title="@Common.Info">
      This wizard will import individual coupon codes from a CSV file into the system.<br/>
      Existing coupon codes will be updated, non existing will be created at DB through a transaction.<br/>
      The first line of the input file will be used to identify the field matching as follows:
      <ul>
        <li><b>CouponCode</b> <i>(mandatory)</i>: individual coupon code</li>
        <li><b>ProductCode</b> <i>(mandatory)</i>: promo rule code</li>
        <li><b>ValidFrom</b> <i>(optional)</i>: in the format YYYY-MM-DD; start validity date</li>
        <li><b>ValidTo</b> <i>(optional)</i>: in the format YYYY-MM-DD; end validity date</li>
        <li><b>AccountCode</b> <i>(optional)</i>: organization account code</li>
        <li><b>CampaignCode</b> <i>(optional)</i>: promotional campaign code</li>
      </ul>
    </v:alert-box>
  </div>

  <div id="step-preview" class="step-item v-hidden">
    <jsp:include page="../../csv_import_widget.jsp">
      <jsp:param name="AsyncProcessClassAlias" value="<%=AsyncProcessUtils.CLASS_ALIAS_IMPORT_IND_COUPON%>"/>
    </jsp:include>
  </div>
</v:dialog>

<script>

function getImportParams() {
  return {
    IndividualCoupon: {
    }
  }
}

function doUploadFinish(obj) {
  $("#step-input").addClass("v-hidden");
  $("#step-preview").removeClass("v-hidden");
  doCsvImport(obj.RepositoryId);
}

function csvImportCallback(proc) {
  triggerEntityChange(<%=LkSNEntityType.IndividualCoupon.getCode()%>);
}


</script>