<%@page import="com.vgs.web.library.product.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="org.apache.poi.util.*"%>
<%@page import="com.vgs.snapp.dataobject.DOProduct.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProduct" scope="request"/>
<jsp:useBean id="product" class="com.vgs.snapp.dataobject.DOProduct" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="rightCRUD" class="com.vgs.snapp.library.FtCRUD" scope="request"/>

<% boolean canEdit = rightCRUD.canUpdate(); %>

<v:widget caption="@Common.IdentityCheck" include="<%=!product.ProductType.isLookup(LkSNProductType.System, LkSNProductType.Fee, LkSNProductType.Presale, LkSNProductType.Material, LkSNProductType.StaffCard)%>">
  <v:widget-block>
    <v:form-field caption="@Biometric.BiometricCheckLevel">
      <v:lk-combobox field="product.BiometricCheckLevel" lookup="<%=LkSN.BiometricCheckLevel%>" allowNull="false" enabled="<%=canEdit%>"/>
    </v:form-field>
    <v:form-field id="biometric-enrollment" caption="@Biometric.Enrollment">
      <v:lk-combobox field="product.BiometricEnrollment" lookup="<%=LkSN.BiometricEnrollment%>" allowNull="false" enabled="<%=canEdit%>"/>
    </v:form-field>
    <v:form-field id="biometric-validity-period" caption="@Biometric.ValidityQantity" hint="@Biometric.ValidityPeriodHint">
      <v:input-text field="product.BioValidityPeriod" placeholder="Unlimited" enabled="<%=canEdit%>"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="@Product.ManualVerification" hint="@Product.ManualVerificationHint">
      <v:lk-combobox field="product.ManualVerificationType" lookup="<%=LkSN.ManualVerificationType%>" allowNull="false" enabled="<%=canEdit%>"/>
    </v:form-field>
    <v:form-field id="manual-verification-message" caption="@Product.ManualVerificationMessage" hint="@Product.ManualVerificationMessageHint">
      <v:input-text field="product.ManualVerificationMessage" placeholder="@Common.Default" enabled="<%=canEdit%>" />
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
//# sourceURL=product_tab_main_identitycheck_widget.jsp
$(document).ready(function() {
  $("#product\\.BiometricCheckLevel").change(refreshBiometricOptionsVisibility);
  $("#product\\.ManualVerificationType").change(refreshManualVerificationType);

  refreshBiometricOptionsVisibility();
  refreshManualVerificationType();

  function refreshBiometricOptionsVisibility() {
    var hidden = $("#product\\.BiometricCheckLevel").val() == <%=LkSNBiometricCheckLevel.None.getCode()%> || $("#product\\.BiometricCheckLevel").val()==<%=LkSNBiometricCheckLevel.Simulate.getCode()%>;
    $("#biometric-enrollment").setClass("hidden", hidden);
    $("#biometric-validity-period").setClass("hidden", hidden);
  }
  
  function refreshManualVerificationType() {
      var hidden = $("#product\\.ManualVerificationType").val() == <%=LkSNManualVerificationType.Never.getCode()%>;
      $("#manual-verification-message").setClass("hidden", hidden);
  }
});
</script>