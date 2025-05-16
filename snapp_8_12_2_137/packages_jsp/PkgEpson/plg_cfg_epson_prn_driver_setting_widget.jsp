<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<%
String recLetterQualityHint = 
    "TRUE: Printing resolution of bitmap is the same as that of the printer respecting both height and width." + JvString.CRLF + 
    "FALSE : Printing resolution of bitmap is a half of that of the printer respecting both height and width.";

%>
<v:widget id="drv-epson-opos-settings" caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
    <v:db-checkbox field="RecLetterQuality" caption="Letter Quality" hint="<%=recLetterQualityHint %>" value="true"/>   
  </v:widget-block>
</v:widget>
 
<script>

$(document).ready(function() {
  var $cfg = $("#drv-epson-opos-settings");
  
  $(document).von($cfg, "driver-settings-load", function(event, params) {
    $cfg.find("#RecLetterQuality").prop('checked',params.settings.RecLetterQuality);
  });
  
  $(document).von($cfg, "driver-settings-save", function(event, params) {
    params.settings = {
        RecLetterQuality: $cfg.find("#RecLetterQuality").isChecked()
      };
    });
  });

</script>
