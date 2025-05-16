<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<% String metaFieldId = pageBase.getId(); %>

<v:dialog id="maskedit_richtext_dialog2" title="@Common.Description" width="900" height="700" autofocus="false">

<script>
//# sourceURL=maskedit_richtext_dialog2.jsp
$(document).ready(function() {
  var $dlg = $("#maskedit_richtext_dialog2");
  var $richDesc = $dlg.find(".rich-desc-widget");
  var richDescParams = {TransList: []};
  var json = $("#MetaFieldId_" + <%=JvString.jsString(metaFieldId)%>).val();
  if (json != "") 
    richDescParams = JSON.parse(json);
  
  richDescParams.Height = "290px";

  $richDesc.richdesc_init(richDescParams);
    
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      dialogButton("@Common.Save", doSaveRichEdit),
      dialogButton("@Common.Cancel", doCloseDialog)
    ]; 
  });

  function doSaveRichEdit() {
    richDescParams.TransList = $richDesc.richdesc_getTransList(); 

    richDescParams.Default = null;
    richDescParams.TransList.forEach(function(item, index) {
      if (item.LangISO == "<%=pageBase.getLangISO()%>") {
        var text = $("<div/>").html(item.Translation).text();
        if (text.length > 100)
          text = text.substring(0, 100);
        richDescParams.Default = text;
      }
    });
    
    $("#MetaFieldId_" + <%=JvString.jsString(metaFieldId)%>).val(JSON.stringify(richDescParams));
    $("#DefaultLang_MetaFieldId_" + <%=JvString.jsString(metaFieldId)%>).val(richDescParams.Default);
      
    $dlg.dialog("close");
  }
});
  
</script>
<jsp:include page="/resources/admin/common/richdesc_widget.jsp"></jsp:include>
</v:dialog>

