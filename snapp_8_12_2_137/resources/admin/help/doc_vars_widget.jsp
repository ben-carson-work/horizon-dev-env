<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.dataobject.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
LkSNDocTemplateType.DocTemplateTypeItem docTemplateType = (LkSNDocTemplateType.DocTemplateTypeItem)LkSN.DocTemplateType.getItemByCode(pageBase.getNullParameter("DocTemplateType"));
String contentId = "fields-tree-" + docTemplateType.getCode();
DOWebTreeNode<?> treeDoc = pageBase.getBL(BLBO_DocTemplate.class).buildDocLegendaTree(docTemplateType);
%>

<style>
.vars-subtitle {
  font-weight: bold;
  text-decoration: underline;
}
</style>

<v:tab-content>
  <v:widget caption="Fields">
    <v:widget-block>
      <div id="<%=contentId%>"></div>
    </v:widget-block>
  </v:widget>
  
  <v:widget caption="Custom fields">
    <v:widget-block>
      <div>
        Sections marked with (*) allow custom fields.<br/>
        Syntax: <b>[@<i>Section</i>.Custom_<i>FieldCode</i>]</b><br/>
        Example: <b>[@Sale.Custom_FT11]</b> - <i>will show sale survey custom field with code "FT11"</i>
      </div>
    </v:widget-block>
  </v:widget>
</v:tab-content>

<script>
$(document).ready(function() {
  _initDocVarTree("#<%=contentId%>", <%=treeDoc.getJSONString()%>);  

  function _initDocVarTree(selector, root) {
    $(selector).tree({data:root});
    
    $(selector).find(".caption").each(function() {
      var li = $(this).closest("li");
      var c = "";
      
      if (li.attr("data-annotation")) {
        var reader = new commonmark.Parser();
        var writer = new commonmark.HtmlRenderer();
        var ann = writer.render(reader.parse(li.attr("data-annotation"))); 
        c += "<div style='margin-bottom:10px'><i>" + ann + "</i></div>";
      }
      
      if (li.attr("data-fieldtype"))
        c += "<div>Field type: <b>" + li.attr("data-fieldtype") + "</b></div>";
      if (li.attr("data-example"))
        c += "<div>Example: <b>" + li.attr("data-example") + "</b></div>";
        
      if (c != "") 
        $(this).attr("data-content", c).addClass("v-tooltip hint-tooltip");
    });
  }
});
</script>
