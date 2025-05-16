<%@page import="com.vgs.snapp.library.AsyncProcessUtils"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
String firstNameFieldCode = pageBase.getBL(BLBO_MetaData.class).getMetaFieldCodeByFieldType(LkSNMetaFieldType.FirstName);
%>

<v:dialog id="sale-import-dialog" title="@Common.Import" width="800" height="600" autofocus="false">
  <div id="step-input">
    <v:widget caption="@Common.Parameters">
    <%-- 
      <v:widget-block>
        <v:form-field caption="@Category.Category" id="DefaultCategoryId">
          <v:combobox field="CategoryId" lookupDataSet="<%=pageBase.getBL(BLBO_Category.class).getCategoryAshedTreeDS(entityType)%>" idFieldName="CategoryId" captionFieldName="AshedCategoryName" allowNull="false"/>
        </v:form-field>
        <v:form-field>
          <v:db-checkbox field="ForcePasswordChange" caption="@Common.ForcePasswordChange" value="true" checked="true"/>
        </v:form-field>
      </v:widget-block>
    --%>
      <v:widget-block>
        <jsp:include page="../repository/file_upload_widget.jsp"/>
      </v:widget-block>
    </v:widget>
    
    <v:alert-box type="info" title="@Common.Info" style="max-height:350px; overflow:auto">
      <div><v:itl key="@Sale.ImportWizard_Line1"/></div>
      <div><v:itl key="@Sale.ImportWizard_Line2"/></div>
      <div><v:itl key="@Sale.ImportWizard_Line3"/></div>
      
      &nbsp;
      <table class="table-import-help">
        <thead>
          <tr>
            <td>Field name</td>
            <td width="100%">Description</td>
            <td>Mandatory</td>
            <td>HDR</td>
            <td>OIT</td>
            <td>PAY</td>
            <td>OCA</td>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td class="table-import-help-fieldname">Type</td>
            <td class="table-import-help-desc">
              Type of line. Possible values are:<br/>
              - HDR (order header)<br/>
              - OIT (order item)<br/>
              - PAY (additional payment)<br/>
              - OCA (order code alias)<br/>
            </td>
            <td class="table-import-help-mandatory">Always</td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types">X</td>
          </tr>
          <tr>
            <td class="table-import-help-fieldname">Action</td>
            <td class="table-import-help-desc">Possible values are INS (Insert), UPD (Update)</td>
            <td class="table-import-help-mandatory">-</td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
          </tr>
          <tr>
            <td class="table-import-help-fieldname">SaleCode</td>
            <td class="table-import-help-desc">Order PNR. Mandatory only when updating. If specified during inserts, it cannot already exists on DB</td>
            <td class="table-import-help-types">Sometimes</td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
          </tr>
          <tr>
            <td class="table-import-help-fieldname">Approved</td>
            <td class="table-import-help-desc">Order \"Approved\" flag. Values can be '0', '1', 'false', 'true'</td>
            <td class="table-import-help-types">-</td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
          </tr>
          <tr>
            <td class="table-import-help-fieldname">Paid</td>
            <td class="table-import-help-desc">Order \"Paid\" flag. Values can be '0', '1', 'false', 'true'</td>
            <td class="table-import-help-types">-</td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
          </tr>
          <tr>
            <td class="table-import-help-fieldname">Encoded</td>
            <td class="table-import-help-desc">Order \"Encoded\" flag. Values can be '0', '1', 'false', 'true'</td>
            <td class="table-import-help-types">-</td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
          </tr>
          <tr>
            <td class="table-import-help-fieldname">Validated</td>
            <td class="table-import-help-desc">Order \"Validated\" flag. Values can be '0', '1', 'false', 'true'</td>
            <td class="table-import-help-types">-</td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
          </tr>
          <tr>
            <td class="table-import-help-fieldname">PaymentMethodCode</td>
            <td class="table-import-help-desc">'Code' of the payment method to be used</td>
            <td class="table-import-help-types">-</td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
          </tr>
          <tr>
            <td class="table-import-help-fieldname">PaymentAmount</td>
            <td class="table-import-help-desc">Payment amount. Works along with 'PaymentMethodCode'</td>
            <td class="table-import-help-types">-</td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
          </tr>
          <tr>
            <td class="table-import-help-fieldname">PaymentCreditAccountCode</td>
            <td class="table-import-help-desc">AccountCode for credit line payments. Works along with 'PaymentMethodCode'</td>
            <td class="table-import-help-types">-</td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
          </tr>
          <tr>
            <td class="table-import-help-fieldname">CodeAliasTypeCode</td>
            <td class="table-import-help-desc">'Code' of the code alias type to be used. Works along with 'CodeAlias'</td>
            <td class="table-import-help-types">-</td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types">X</td>
          </tr>
          <tr>
            <td class="table-import-help-fieldname">CodeAlias</td>
            <td class="table-import-help-desc">Code alias to be used. Works along with 'CodeAliasTypeCode'</td>
            <td class="table-import-help-types">-</td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types">X</td>
          </tr>
          <tr>
            <td class="table-import-help-fieldname">ResOwnerAccountCode</td>
            <td class="table-import-help-desc">Account code of the reservation owner. Mandatory only when creating a reservation order.</td>
            <td class="table-import-help-types">Sometimes</td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
          </tr>
          <tr>
            <td class="table-import-help-fieldname">ResOwnerEntityType</td>
            <td class="table-import-help-desc">Reservation owner account type: 1=Organization, 15=Person. Required only for creation, ignored for upgrades.</td>
            <td class="table-import-help-types">-</td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
          <tr>
          <tr>
            <td class="table-import-help-fieldname">ResOwnerAccount-MF:<i>{CODE}</i></td>
            <td class="table-import-help-desc">Reservation owner account meta data: where {CODE} matches a <span class="metafield-tooltip-link">metafield code</span>; ie: <b>MF:<%=JvString.escapeHtml(firstNameFieldCode)%></b> for first name</td>
            <td class="table-import-help-types">-</td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
          </tr>
          <tr>
            <td class="table-import-help-fieldname">ResOwnerAccount-MF$<i>{NUMBER}</i></td>
            <td class="table-import-help-desc">Reservation owner account meta data: where {NUMBER} matches the <span class="lk-tooltip-link" data-LookupTable="<%=LkSN.MetaFieldType.getCode()%>">Meta Field Type</span> lookup item; ie: <b>MF$1</b> for first name</td>
            <td class="table-import-help-types">-</td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
          <tr>
            <td class="table-import-help-fieldname">ShipAccountCode</td>
            <td class="table-import-help-desc">Account code of the reservation 'ship-to'</td>
            <td class="table-import-help-types">-</td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
          </tr>
          <tr>
            <td class="table-import-help-fieldname">ShipEntityType</td>
            <td class="table-import-help-desc">Reservation shipping account type: 1=Organization, 15=Person. Required only for creation, ignored for upgrades.</td>
            <td class="table-import-help-types">-</td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
          <tr>
          <tr>
            <td class="table-import-help-fieldname">ShipAccount-MF:<i>{CODE}</i></td>
            <td class="table-import-help-desc">Reservation shipping account meta data: where {CODE} matches a <span class="metafield-tooltip-link">metafield code</span>; ie: <b>MF:<%=JvString.escapeHtml(firstNameFieldCode)%></b> for first name</td>
            <td class="table-import-help-types">-</td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
          </tr>
          <tr>
            <td class="table-import-help-fieldname">ShipAccount-MF$<i>{NUMBER}</i></td>
            <td class="table-import-help-desc">Reservation shipping account meta data: where {NUMBER} matches the <span class="lk-tooltip-link" data-LookupTable="<%=LkSN.MetaFieldType.getCode()%>">Meta Field Type</span> lookup item; ie: <b>MF$1</b> for first name</td>
            <td class="table-import-help-types">-</td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
          <tr>
          <tr>
            <td class="table-import-help-fieldname">OrderMaskCodes</td>
            <td class="table-import-help-desc">List of mask codes (separated by '|' pipe) associated to the order</td>
            <td class="table-import-help-types">-</td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
          </tr>
          <tr>
            <td class="table-import-help-fieldname">ORDER-MF:<i>{CODE}</i></td>
            <td class="table-import-help-desc">Order meta data: where {CODE} matches a <span class="metafield-tooltip-link">metafield code</span>; ie: <b>MF:<%=JvString.escapeHtml(firstNameFieldCode)%></b> for first name</td>
            <td class="table-import-help-types">-</td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
          </tr>
          <tr>
            <td class="table-import-help-fieldname">ORDER-MF$<i>{NUMBER}</i></td>
            <td class="table-import-help-desc">Order meta data: where {NUMBER} matches the <span class="lk-tooltip-link" data-LookupTable="<%=LkSN.MetaFieldType.getCode()%>">Meta Field Type</span> lookup item; ie: <b>MF$1</b> for first name</td>
            <td class="table-import-help-types">-</td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
          </tr>
          <tr>
            <td class="table-import-help-fieldname">ProductCode</td>
            <td class="table-import-help-desc">Product type code</td>
            <td class="table-import-help-types">Always</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
          </tr>
          <tr>
            <td class="table-import-help-fieldname">UnitAmount</td>
            <td class="table-import-help-desc">Unit amount (tax inclusive)</td>
            <td class="table-import-help-types">-</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
          </tr>
          <tr>
            <td class="table-import-help-fieldname">UnitTax</td>
            <td class="table-import-help-desc">Unit tax</td>
            <td class="table-import-help-types">-</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
          </tr>
          <tr>
            <td class="table-import-help-fieldname">Quantity</td>
            <td class="table-import-help-desc">Quantity</td>
            <td class="table-import-help-types">-</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types">X</td>
            <td class="table-import-help-types"></td>
            <td class="table-import-help-types"></td>
          </tr>
        </tbody>
      </table>
    </v:alert-box>
  </div>

  <div id="step-preview" class="step-item v-hidden">
    <jsp:include page="../csv_import_widget.jsp">
      <jsp:param name="AsyncProcessClassAlias" value="<%=AsyncProcessUtils.CLASS_ALIAS_IMPORT_ORDER%>"/>
    </jsp:include>
  </div>

<script>

function getImportParams() {
  return {
    Sale: {
<%--
      EntityType: <%=entityType.getCode()%>,
      DefaultCategoryId: $("#account-import-dialog [name='CategoryId']").val(),
      ForcePwdChangeFirstLogin: $("#ForcePasswordChange").isChecked()
--%>
    }
  }
}

function doUploadFinish(obj) {
  $("#step-input").addClass("v-hidden");
  $("#step-preview").removeClass("v-hidden");
  doCsvImport(obj.RepositoryId);
}

function csvImportCallback(proc) {
  triggerEntityChange(<%=LkSNEntityType.Sale.getCode()%>);
}

</script>

</v:dialog>
