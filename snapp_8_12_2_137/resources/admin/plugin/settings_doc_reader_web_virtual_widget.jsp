<%@page import="com.vgs.vcl.*"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@taglib uri="vgs-tags" prefix="v"%>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>


<v:widget id="doc_reader_web_virtual_settings" caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
   	<v:form-field caption="StorablePicture" hint="Storable picture"  mandatory="true">
   		<v:db-checkbox field="StorablePicture" caption="" value="true"/>
  	 </v:form-field>  
   	<v:form-field caption="Document number" hint="This property set a fixed document number">
      <v:input-text field="DocumentNumber"/>
    </v:form-field>
  </v:widget-block>
</v:widget>
 
<script>
$(document).ready(function() {
  var $cfg = $("#doc_reader_web_virtual_settings");
    
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#StorablePicture").prop('checked', (params.settings.StorablePicture));
    $cfg.find("#DocumentNumber").val(params.settings.DocumentNumber);
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
    		StorablePicture:	$cfg.find("#StorablePicture").isChecked(),
    		DocumentNumber :  $cfg.find("#DocumentNumber").val()
      };
    });
});

</script>
 