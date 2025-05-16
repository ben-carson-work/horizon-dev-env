<%@page import="com.vgs.cl.json.*"%>
<%@page import="io.swagger.v3.core.util.Json"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Account.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
  String gridId = pageBase.getParameter("GridId");
/*   String options = pageBase.getParameter("Options");
  JSONObject obj = new JSONObject(options);
  System.out.println(obj.toString()); */
%>

<v:dialog id="csv-options-dialog" title="@Common.Options" width="500" height="300" autofocus="false">
  <v:widget>
    <v:widget-block>
      <v:form-field caption="@DocTemplate.CSV_FieldDelimiter" hint="@DocTemplate.CSV_FieldDelimiterHint">
        <input type="text" id="CSV_FieldDelimiter"name="CSV_FieldDelimiter" class="form-control"/>
      </v:form-field>
      <v:form-field caption="@DocTemplate.CSV_QuoteCharacter" hint="@DocTemplate.CSV_QuoteCharacterHint">
        <input type="text" id="CSV_QuoteCharacter" name="CSV_QuoteCharacter" class="form-control"/>
      </v:form-field>
      <v:form-field>
        <input type="hidden" name="CSV_IncludeHeaderLine"/>
        <label class="checkbox-label"><input type="checkbox" id="CSV_IncludeHeaderLine"/> <v:itl key="@DocTemplate.CSV_IncludeHeaderLine"/></label>
      </v:form-field>
    </v:widget-block>
  </v:widget>

<script>

$("#CSV_FieldDelimiter").val(getCookie("CSV_FieldDelimiter"));
$("#CSV_QuoteCharacter").val(getCookie("CSV_QuoteCharacter"));
$("#CSV_IncludeHeaderLine").setChecked(getCookie("CSV_IncludeHeaderLine") != "false");

var dlg = $("#csv-options-dialog");
dlg.on("snapp-dialog", function(event, params) {
  params.buttons = [
      {
        text: <v:itl key="@Common.Export" encode="JS"/>,
        click: function() {
          gridDownloadCSV("<%=gridId%>");
          dlg.dialog("close");
        }
      },
      {
        text: <v:itl key="@Common.Close" encode="JS"/>,
        click: function() {
          dlg.dialog("close");
        }
      }
  ]
});

function gridDownloadCSV(gridId) {
  optionsObj = JSON.parse("{}");
  optionsObj.Options = {};
  
  optionsObj.Options.CSV_FieldDelimiter = $("#CSV_FieldDelimiter").val();
  optionsObj.Options.CSV_QuoteCharacter = $("#CSV_QuoteCharacter").val();
  optionsObj.Options.CSV_IncludeHeaderLine = $("#CSV_IncludeHeaderLine").isChecked();
  
  gridDownload(gridId, JSON.stringify(optionsObj));
}
</script>  

</v:dialog>