<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>

<v:widget id="opos-settings" caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
    <table class="form-table" >
      <tr>
        <th><label for="settings.DeviceName"><v:itl key="@Common.Name"/></label></th>
        <td><v:input-text field="settings.DeviceName"/></td>
      </tr>
    </table>
  </v:widget-block>
</v:widget>
 
<script>

$(document).ready(function() {
	var $cfg = $("#opos-settings");
	$(document).von($cfg, "plugin-settings-load", function(event, params) {
	  $cfg.find("#settings\\.DeviceName").val(params.settings.DeviceName);
	});
	
	$(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
    		DeviceName: $("#settings\\.DeviceName").val()
    };
  });	  
});

</script>
 