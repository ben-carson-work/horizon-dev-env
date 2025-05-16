<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
String batchId= pageBase.getEmptyParameter("batchId");

JvDataSet ds = pageBase.getDB().executeQuery( 
    "select" + JvString.CRLF +
    "  EPT.ExtProductTypeId," + JvString.CRLF + 
    "  EPT.ExtProductName," + JvString.CRLF + 
    "  EPT.ExtProductCode," + JvString.CRLF +
    "  EPT.ExtMediaGroupId," + JvString.CRLF +
    "  EMG.ExtMediaGroupName" + JvString.CRLF +
    "from" + JvString.CRLF +
    "  tbExtProductType EPT join"  + JvString.CRLF +
    "  tbExtMediaBatchDetail EMBD on EPT.ExtProductCode = EMBD.ExtProductCode left join" + JvString.CRLF +
    "  tbExtMediaGroup EMG on EMG.ExtMediaGroupId=EPT.ExtMediaGroupId" + JvString.CRLF +
    "where" + JvString.CRLF +
    "  EMBD.ExtMediaBatchId=" + JvString.sqlStr(batchId) + JvString.CRLF +
    "group by"+ JvString.CRLF +
    "  EPT.ExtProductTypeId," + JvString.CRLF +
    "  EPT.ExtProductcode," + JvString.CRLF +
    "  EPT.ExtProductName," + JvString.CRLF +
    "  EPT.ExtMediaGroupId," + JvString.CRLF +
    "  EMG.ExtMediaGroupName");

request.setAttribute("ds", ds);
%>
<div id="step-plu-mediagoup">
  <v:grid id="plu-mediagroup-grid" dataset="<%=ds%>">
    <thead>
      <tr>
        <td width="50%"><v:itl key="@ExtMediaBatch.ExtProductName"/></td>
        <td width="50%"><v:itl key="@Product.ExtMediaGroup"/></td>
      </tr>
    </thead>
    <tbody>
      <v:grid-row dataset="ds">
        <td>
          <span class="title"> <%=ds.getField("ExtProductName").getHtmlString()%></span>
        </td>
        <td>
          <% String  groupName = ds.getField("ExtMediaGroupName").getString();%>
          <%if (groupName == null) {%>
          <%String  extProductTypeId=ds.getField("ExtProductTypeId").getString();%>
            <snp:dyncombo clazz="class-mediagroup" id="<%=extProductTypeId%>" entityType="<%=LkSNEntityType.ExtMediaGroup%>" allowNull="false"/>
          <%} else{%>
            <span class="title"> <%=groupName%> </span>
          <%}%> 
        </td>
      </v:grid-row>
    </tbody>
  </v:grid>
</div>