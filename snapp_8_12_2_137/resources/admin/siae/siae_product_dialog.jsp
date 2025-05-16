<%@page import="com.vgs.snapp.query.QryBO_SiaeTax"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeSector"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeOrganizer"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeLookup.Fil"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeLookup.Sel"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeLookup"%>
<%@page import="com.vgs.snapp.dataobject.DOProduct"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
BLBO_Siae bl = pageBase.getBL(BLBO_Siae.class);
boolean isNewProduct = bl.isNewProduct(pageBase.getId());
DOSiaeProduct siaeProduct = isNewProduct ? bl.prepareNewProduct() : bl.loadProduct(pageBase.getId());
BLBO_Product productBl = pageBase.getBL(BLBO_Product.class);
DOProduct product = productBl.loadProduct(pageBase.getId());
request.setAttribute("siaeProduct", siaeProduct);
request.setAttribute("product", product);

DOSiaeEvent siaeEvent = bl.getSiaeEventByProduct(product.ProductId.getString());
if ((siaeEvent != null) && isNewProduct) {
      siaeProduct.SiaeTaxId.assign(siaeEvent.SiaeTaxId);
      siaeProduct.SiaePrevenditaTaxId.assign(siaeEvent.SiaePrevenditaTaxId);
      siaeProduct.OrganizerId.assign(siaeEvent.OrganizerId);
}

boolean isSiaeEventConfigured = siaeEvent != null;
boolean eventoInviti = isSiaeEventConfigured && siaeEvent.EventoInviti.getBoolean(); 


QueryDef qdef = new QueryDef(QryBO_SiaeLookup.class);
//Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.LookupItemCode);
qdef.addSelect(Sel.CodeAndName);
//Filter
qdef.addFilter(Fil.LookupTableId, 2);
//Sort
qdef.addSort(Sel.LookupItemCode);
//Exec
JvDataSet ordiniDiPostoDs = pageBase.execQuery(qdef);


qdef = new QueryDef(QryBO_SiaeLookup.class);
//Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.LookupItemCode);
qdef.addSelect(Sel.CodeAndName);
//Filter
qdef.addFilter(Fil.LookupItemCode, BLBO_Siae.getTitoloInviti());
qdef.addFilter(Fil.LookupTableId, 3);
//Sort
qdef.addSort(Sel.LookupItemCode);
//Exec
JvDataSet tipoTitoloDs = pageBase.execQuery(qdef);

// qdef = new QueryDef(QryBO_SiaeLookup.class);
// //Select
// qdef.addSelect(Sel.IconName);
// qdef.addSelect(Sel.LookupItemCode);
// qdef.addSelect(Sel.CodeAndName);
// //Filter
// qdef.addFilter(Fil.LookupTableId, 5);
// //Sort
// qdef.addSort(Sel.LookupItemCode);
// //Exec
// JvDataSet supportDs = pageBase.execQuery(qdef);

qdef = new QueryDef(QryBO_SiaeOrganizer.class);
//Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(QryBO_SiaeOrganizer.Sel.OrganizerId);
qdef.addSelect(QryBO_SiaeOrganizer.Sel.Denominazione);
//Sort
qdef.addSort(QryBO_SiaeOrganizer.Sel.Denominazione);
//Exec
JvDataSet organizersDs = pageBase.execQuery(qdef);

qdef = new QueryDef(QryBO_SiaeTax.class);
qdef.addSelect(QryBO_SiaeTax.Sel.IconName);
qdef.addSelect(QryBO_SiaeTax.Sel.SiaeTaxId);
qdef.addSelect(QryBO_SiaeTax.Sel.TaxName);
qdef.addSelect(QryBO_SiaeTax.Sel.CurrentTaxValue);
qdef.addSort(QryBO_SiaeTax.Sel.TaxName);
JvDataSet taxDs = pageBase.execQuery(qdef);

boolean isEnabled = bl.isSiaeEnabled();
boolean isUsed = bl.isProductUsed(pageBase.getId());
boolean isSIAEProduct = bl.isSiaeProduct(pageBase.getId());

isEnabled = isEnabled && isSiaeEventConfigured; 
String origTipoTitolo = siaeProduct.TipoTitolo.getString();
%>

<v:dialog id="product_dialog" icon="siae.png" title="Configurazione SIAE" width="800" height="600" autofocus="false">
<jsp:include page="/resources/admin/siae/siae_alert.jsp" />
<% if (isEnabled && isUsed) { %>
  <div id="main-system-error" class="successbox">La modifica non è consentita perché sono già stati venduti biglietti per questo prodotto.</div>
<% } %>

<% if (!isSiaeEventConfigured) { %>
  <div id="main-system-error" class="errorbox">La modifica non è consentita perché non è stato configurato un evento per questo  prodotto.</div>
<% } %>

<div id="i1-product-warning" class="errorbox">Verificare che il prezzo per il prodotto [I1] sia sempre definito.</div>
<div class="profile-pic-div">
  <snp:profile-pic entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.ProductType%>" field="product.ProfilePictureId" />
</div>
<div class="profile-cont-div">
<v:widget caption="@Common.General" icon="profile.png">
  <v:widget-block>
    <v:form-field caption="@Common.Code" mandatory="true">
      <v:input-text field="product.ProductCode" enabled="false" />
    </v:form-field>
    <v:form-field caption="@Common.Name" mandatory="true">
      <snp:entity-link entityId="<%=product.ProductId.getString()%>" entityType="<%=LkSNEntityType.ProductType%>">
        <%=product.ProductName%>
      </snp:entity-link>
    </v:form-field>
    <v:form-field caption="Organizzatore" mandatory="true">
      <v:combobox enabled="<%=false%>" field="siaeProduct.OrganizerId" lookupDataSet="<%=organizersDs%>" captionFieldName="Denominazione" idFieldName="OrganizerId" allowNull="false"/>
    </v:form-field>
    <v:form-field caption="Ordine di posto" mandatory="true">
      <v:combobox enabled="<%=isEnabled && !isUsed %>" field="siaeProduct.OrdinePosto" lookupDataSet="<%=ordiniDiPostoDs%>" captionFieldName="CodeAndName" idFieldName="LookupItemCode" allowNull="false"/>
    </v:form-field>
    <v:form-field caption="Tipo titolo" mandatory="true">
      <% if (eventoInviti) { %>
        <v:combobox enabled="<%=isEnabled && !isUsed %>" field="siaeProduct.TipoTitolo" lookupDataSet="<%=tipoTitoloDs%>" captionFieldName="CodeAndName" idFieldName="LookupItemCode" allowNull="false"/>
      <% } else { %>
       <snp:dyncombo enabled="<%=isEnabled && !isUsed %>" field="siaeProduct.TipoTitolo" entityType="<%=LkSNEntityType.SiaeLKTipoTitolo%>"/>
      <% } %>  
    </v:form-field>
    <v:form-field caption="Eventi abilitati" mandatory="true">
      <v:input-text enabled="<%=isEnabled && !isUsed %>" field="siaeProduct.EventiAbilitati" placeholder="1" defaultValue="1" type="number" required="" min="1" max="2147483647" />
    </v:form-field>
    <v:form-field caption="Tipo prodotto" mandatory="true">
      <v:lk-combobox field="siaeProduct.ProductType" lookup="<%=LkSN.SiaeProductType%>" allowNull="false" enabled="<%=isEnabled && !isUsed %>" />
    </v:form-field>
<%--     <v:form-field caption="Codice supporto" mandatory="true"> --%>
<%--       <v:combobox enabled="<%=isEnabled && !isUsed %>" field="siaeProduct.CodiceSupporto" lookupDataSet="<%=supportDs%>" captionFieldName="CodeAndName" idFieldName="LookupItemCode" allowNull="false"/> --%>
<%--     </v:form-field> --%>
    <v:form-field caption="Tipo IVA" mandatory="true">
      <v:combobox enabled="<%=false%>" field="siaeProduct.SiaeTaxId" lookupDataSet="<%=taxDs%>" captionFieldName="TaxName" idFieldName="SiaeTaxId" allowNull="false"/>
    </v:form-field>
  </v:widget-block>
</v:widget>
</div>
<% if (!isSIAEProduct) { %><div class=errorbox> Prodotto non fiscale</div><% } %>
<script src="<v:config key="resources_url"/>/admin/script/siae.js"></script>
<script>
//# sourceURL=siae_product_dialog.jsp
$(document).ready(function() {
  refreshI1BannerVisibility();
  $('#siaeProduct\\.TipoTitolo').change(function() {
	  refreshI1BannerVisibility();
  });
  
  $(".default-focus").focus();
  var dlg = $("#product_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        text: <v:itl key="@Common.Save" encode="JS"/>,
        click: doSaveSiae,
        disabled:  <%=!isEnabled || isUsed %>
      }, 
      {
        text: <v:itl key="@Common.Cancel" encode="JS"/>,
        click: doCloseDialog
      }
    ];
    setTimeout(function() {
      $(".default-focus").focus();
    }, 1);
  });
  
  
});

function refreshI1BannerVisibility() {
  var showMessage = ($('#siaeProduct\\.TipoTitolo').val().toUpperCase() === 'I1');
  $("#i1-product-warning").setClass("hidden", !showMessage);
}

function doSaveSiae() {
  if ($('#product\\.ProductCode').val().length > 8 && $('#siaeProduct\\.ProductType').val() == 1) { // abbonamento
    alert('Il codice di abbonamento è sbagliato. La lunghezza massima è di 8 caratteri');
    return;
  }
  if ($('#siaeProduct\\.ProductType').val() == 0 && $('#siaeProduct\\.EventiAbilitati').val() > 1) { // titolo fisso
    alert('Non più di un evento può essere abilitato per i titoli a turno fisso');
    return;
  }
  var formElements = $('#product_dialog').find(':input');
  if (!formValidate($('input'))) {
    return;
  }
  var reqDO = {
      Command: "SaveProduct",
      SaveProduct: {
        Product: {
          ProductId: <%=JvString.jsString(pageBase.getId()) %>,
          OrganizerId: $('#siaeProduct\\.OrganizerId').val(),
          OrdinePosto: $('#siaeProduct\\.OrdinePosto').val(),
          TipoTitolo: $('#siaeProduct\\.TipoTitolo').val(),
          EventiAbilitati: $('#siaeProduct\\.EventiAbilitati').val(),
          ProductType: $('#siaeProduct\\.ProductType').val(),
//           CodiceSupporto: $('#siaeProduct\\.CodiceSupporto').val(),
          SiaeTaxId: $('#siaeProduct\\.SiaeTaxId').val(),
          SiaePrevenditaTaxId: $('#siaeProduct\\.SiaeTaxId').val()
        }
      }
    };
  
  vgsService("siae", reqDO, false, function(ansDO) {
	  if (($('#siaeProduct\\.TipoTitolo').val() !== <%=JvString.jsString(origTipoTitolo)%>)) 
	    entitySaveNotification(<%=LkSNEntityType.ProductType.getCode()%>, <%=product.ProductId.getJsString()%>, "tab=price");
	  else  
      triggerEntityChange(<%=LkSNEntityType.SiaeProduct.getCode()%>);
    $("#product_dialog").dialog("close");
  });
};
</script>
</v:dialog>