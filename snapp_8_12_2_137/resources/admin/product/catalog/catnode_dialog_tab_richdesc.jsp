<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="node" class="com.vgs.snapp.dataobject.DOCatalog" scope="request"/>
<script>
//# sourceURL=catnode_dialog_tab_richtext.jsp
$(document).ready(function() {
  var richDescParams =  {
    TransList: [],
    Height: "290px"
  };
     
  <%
    for (DORichDescItem item : node.RichDescList) {
	    String langISO = item.LangISO.getString();
	    String iconName = SnappUtils.getFlagName(langISO);
	    String langName = JvString.getPascalCase((new Locale(langISO)).getDisplayLanguage(pageBase.getLocale()));
	    %>
	    richDescParams.TransList.push(
		   	  {
				    LangISO: <%=JvString.jsString(langISO)%>,
				    LangName: <%=JvString.jsString(langName)%>, 
				    IconName: <%=JvString.jsString(iconName)%>, 
				    Translation: <%=item.Description.getJsString()%>
		   	  });
	    <%
	  }
  %>
  
  $(".catnode-tab-richdesc .rich-desc-widget").richdesc_init(richDescParams);
});

</script>

<div class="tab-content catnode-tab-richdesc">
    <jsp:include page="/resources/admin/common/richdesc_widget.jsp"></jsp:include>
</div>
