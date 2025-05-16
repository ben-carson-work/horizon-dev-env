<%@page import="com.vgs.snapp.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>
<%
boolean canEdit = !pageBase.isParameter("readonly", "true");
List<DORichDescItem> richDescList = pageBase.getBL(BLBO_RichDesc.class).findDescriptions(pageBase.getId());
String richDescHeight = request.getParameter("RichDescHeight");
%>

<script>
//# sourceURL=richdesc_widget_container.jsp
$(document).ready(function() {
  var richDescParams =  {
		    TransList: [],
		    Height: <%=JvString.jsString(richDescHeight)%>
		  };
		     
  <%
    for (DORichDescItem item : richDescList) {
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
  
   $(".tab-richdesc .rich-desc-widget").richdesc_init(richDescParams);        
 });
</script>

<div class="tab-content tab-richdesc">
  <jsp:include page="/resources/admin/common/richdesc_widget.jsp"></jsp:include>
</div>

                                                          
                                                                               