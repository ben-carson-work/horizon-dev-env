<%@page import="com.vgs.vcl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
    <table class="form-table" >
       <tr>
        <th><label for="settings.ResourcesPath"><v:itl key="@Plugin.ResourcePath"/></label></th>
        <td><v:input-text field="settings.ResourcesPath"/></td>
      </tr>
    </table>
  </v:widget-block>
</v:widget>
 
<script>
function getPluginSettings() {
  return {
    ResourcesPath: $("#settings\\.ResourcesPath").val()
  };
}

</script>