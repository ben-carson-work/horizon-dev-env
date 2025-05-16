<%@page import="com.vgs.vcl.JvImageCache"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.LkSN"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget id="printer-posiflex-pp7600-settings" caption="Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block> 
    <v:form-field caption="Port Name" hint="Insert port name"  mandatory="true">
      <v:input-text field="PortName" placeholder="COM2"/>
    </v:form-field> 
  </v:widget-block>
  <v:widget-block> 
      <v:form-field caption="Code Page">
        <select id="CodePage" class="form-control">
          <option value="STANDARD">Standard</option>
          <option value="MULTILINGUALLATINI">Multilingual (Latin I)</option>
          <option value="PORTUGUESE">Portuguese</option>          
          <option value="CANADIANFRENCH">Canadian-French</option>
          <option value="NORDIC">Nordic</option>
          <option value="CYRILLIC1">Cyrillic</option> 
          <option value="LATIN2">Latin 2</option>
          <option value="MULTILINGUALLATINEURO">Multilingual (Latin + Euro)</option>
          <option value="HEBREW1">Hebrew</option>
          <option value="ARABIC">Arabic</option>
          <option value="WINDOWSGREEK">Windows Greek</option>
          <option value="WINDOWSTURKISH">Windows Turkish</option>
          <option value="WINDOWSBALTIC">Windows Baltic</option>
          <option value="WINDOWSARABICFARSI">Windows Arabic (Farsi)</option> 
          <option value="WINDOWSCYRILLIC">Windows Cyrillic</option> 
          <option value="GREEK">Greek</option>
          <option value="THAIPAGE14">Thai page 14</option>
          <option value="HEBREW2">Hebrew</option>
          <option value="THAIPAGE11">Thai page 11</option>
          <option value="CYRILLIC2">Cyrillic</option>
          <option value="TURKISH">Turkish</option>
          <option value="JAPANESE">Japanese</option>                                                                                                                                                                                                                     
        </select>
      </v:form-field>
  </v:widget-block> 
  <v:widget-block> 
      <v:form-field caption="Font type">
        <select id="FontType" class="form-control">
          <option value="FONT_A">Character font A (12 × 24)</option>
          <option value="FONT_B">Character font B (9 × 17)</option>
        </select>
      </v:form-field>
  </v:widget-block>    
</v:widget>

<script>
$(document).ready(function() {
  var $cfg = $("#printer-posiflex-pp7600-settings");
    
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#PortName").val(params.settings.PortName);
    $cfg.find("#CodePage").val(params.settings.CodePage);
    $cfg.find("#FontType").val(params.settings.FontType);
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
        PortName : $cfg.find("#PortName").val(),
        CodePage : $cfg.find("#CodePage").val(),
        FontType : $cfg.find("#FontType").val()
      };
    });
});
</script>