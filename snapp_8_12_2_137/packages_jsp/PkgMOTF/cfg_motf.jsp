<%@page import="com.vgs.snapp.web.gencache.*"%>
<%@page import="com.vgs.cl.database.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pkg" class="com.vgs.snapp.dataobject.DOExtensionPackage" scope="request"/>
<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>


<v:widget caption="Redemption message">
  <v:widget-block>
     <v:form-field caption="Monitored access points" hint='Messages contain only interations made with these access points'>
       <v:multibox 
           field="motf-config-AccessPointIDs" 
           lookupDataSet="<%=pageBase.getBL(BLBO_Workstation.class).findAccessPointDS()%>" 
           idFieldName="WorkstationId" 
           captionFieldName="WorkstationName" 
           linkEntityType="<%=LkSNEntityType.AccessPoint%>" 
           enabled="<%=true%>"/>
     </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="Outbound settings">
  <v:widget-block>
    <%
    String orderDelayHint = JvString.lines(
        "Delay, in milliseconds, to be applied on **order** events.",
        "",
        "The delay was requested because of saleforce extra logging when SnApp posts **account** and **order** simultaneously",
        "",
        "**NOTE:**",
        "**Given the same number of orders entered in SnApp, this delay will require more \"oubound queue workers\" compared to not having it.**",
        "**In case the number of workers is restricted because of a limited amount of database connections (some cloud implementations have low limits based on the plan purchased), this delay could cause long queueing in SnApp**"
        );
    %>
    <v:form-field caption="Order delay"  hint="<%=orderDelayHint%>"> 
      <v:input-text field="motf-config-orderDelayMsecs" type="number" placeholder="0"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="D-Logic Device settings">
  <v:widget-block>
    <v:form-field caption="Quuppa DocTemplate"  mandatory="true" hint="DocTemplate to be associated to the Quuppa Media codes"> 
			<v:combobox field="motf-config-quuppaDocTemplateId" lookupDataSet="<%=pageBase.getBL(BLBO_DocTemplate.class).getDocTemplateDS(LkSNDocTemplateType.Media)%>" idFieldName="DocTemplateId" captionFieldName="DocTemplateName"/>
    </v:form-field>
    <v:form-field caption="Quuppa CardType"  hint="Card type value used to identify quuppa tags"> 
    	<v:input-text field="motf-config-quuppaCardType" type="number" placeholder="16"/>
    </v:form-field>
    <v:form-field caption="Souvenir DocTemplate"  mandatory="true" hint="DocTemplate to be associated to the Souvenir Media codes"> 
			<v:combobox field="motf-config-souvenirDocTemplateId" lookupDataSet="<%=pageBase.getBL(BLBO_DocTemplate.class).getDocTemplateDS(LkSNDocTemplateType.Media)%>" idFieldName="DocTemplateId" captionFieldName="DocTemplateName"/>
    </v:form-field>
    <v:form-field caption="Souvenir CardType" hint="Card type value used to identify souvenir cards">
    	<v:input-text field="motf-config-souvenirCardType" type="number" placeholder="4"/>
    </v:form-field>
    <v:form-field caption="Reversal read" hint="Read card id in reversal way">
    	<v:db-checkbox field="motf-config-ReversalRead" caption="@Common.Enable" value="true"/>
    </v:form-field>
    <v:form-field caption="Multiple devices" hint="If flaged system is expecting two reader devices connected to the system">
    	<v:db-checkbox field="motf-config-MultiDevices" caption="@Common.Enable" value="true"/>
    </v:form-field>
    <v:form-field caption="Unknown tags" hint="If flaged system will manage tags defined as Unknown by the driver">
    	<v:db-checkbox field="motf-config-UnknownTags" caption="@Common.Enable" value="true"/>
    </v:form-field>  </v:widget-block>
</v:widget>

<script>
//# sourceURL=cfg_motf.jsp
$(document).ready(function() {
  var doc = <%=pkg.ConfigDoc.getString()%>;
  doc = (doc) ? doc : {};
  
 var $sel = $("#motf-config-AccessPointIDs");
 $sel.attr('data-html', $sel.html());
 $sel.selectize({
   dropdownParent:"body",
   plugins: ['remove_button','drag_drop']
 })[0].selectize.setValue(doc.AccessPointIDs, true);
 $("#motf-config-orderDelayMsecs").val(doc.OrderDelayMsecs);
 $("#motf-config-quuppaDocTemplateId").val(doc.QuuppaDocTemplateId);
 $("#motf-config-souvenirDocTemplateId").val(doc.SouvenirDocTemplateId);
 $("#motf-config-quuppaCardType").val(doc.QuuppaCardType);
 $("#motf-config-souvenirCardType").val(doc.SouvenirCardType);
 $("#motf-config-ReversalRead").prop('checked', doc.ReversalRead);
 $("#motf-config-MultiDevices").prop('checked', doc.MultiDevices);
 $("#motf-config-UnknownTags").prop('checked', doc.UnknownTags);
});


function getExtensionPackageConfigDoc() {
  return {
    AccessPointIDs: $("#motf-config-AccessPointIDs").val(),
    OrderDelayMsecs: strToIntDef($("#motf-config-orderDelayMsecs").val(), 0),
    SouvenirDocTemplateId: $("#motf-config-souvenirDocTemplateId").val(),
    QuuppaDocTemplateId: $("#motf-config-quuppaDocTemplateId").val(),
    QuuppaCardType: $("#motf-config-quuppaCardType").val(),
    SouvenirCardType: $("#motf-config-souvenirCardType").val(),
    ReversalRead: $("#motf-config-ReversalRead").isChecked(),
    MultiDevices: $("#motf-config-MultiDevices").isChecked(),
    UnknownTags: $("#motf-config-UnknownTags").isChecked()
  };
}

</script>