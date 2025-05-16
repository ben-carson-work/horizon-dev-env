<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@taglib uri="vgs-tags" prefix="v" %>
<%@taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProductFamily" scope="request"/>
<jsp:useBean id="prodFamily" class="com.vgs.snapp.dataobject.DOProductFamily" scope="request"/>

<%
String[] prodIDs = pageBase.getDB().executeQuery("select ProductId from tbProduct where ParentEntityId=" + prodFamily.ProductFamilyId.getSqlString()).getStrings();

JvDataSet ds = pageBase.getDB().executeQuery(
    "select" + JvString.CRLF +
    "  P.ProductId as ProductId," + JvString.CRLF +
    "  P.ProductName as ProductName," + JvString.CRLF +
    "  P.ProductCode as ProductCode," + JvString.CRLF +
    "  RI.RepositoryId as ProfilePictureId," + JvString.CRLF +
    "  X.ProductId as TargetProductId," + JvString.CRLF +
    "  X.ProductName as TargetProductName," + JvString.CRLF +
    "  X.ProductCode as TargetProductCode," + JvString.CRLF +
    "  RI2.RepositoryId as TargetProfilePictureId" + JvString.CRLF +
    "from" + JvString.CRLF +
    "  tbProduct P left join" + JvString.CRLF +
    "  (" + JvString.CRLF +
    "    select P2.*, PU2P.EntityId as SrcProductId" + JvString.CRLF +
    "    from" + JvString.CRLF +
    "      tbProductUpgrade2Product PU2P inner join" + JvString.CRLF +
    "      tbProduct P2 on P2.ProductId=PU2P.ProductId" + JvString.CRLF +
    "    where" + JvString.CRLF +
    "      PU2P.EntityId in " + JvArray.escapeSql(prodIDs) + " and" + JvString.CRLF +
    "      P2.ParentEntityId=" + prodFamily.TargetProductFamilyId.getSqlString() + JvString.CRLF + 
    "  ) X on X.SrcProductId=P.ProductId left outer join" + JvString.CRLF +
    "  tbRepositoryIndex RI on RI.EntityId=P.ProductId and RI.RepositoryIndexType=1 left outer join" + JvString.CRLF +
    "  tbRepositoryIndex RI2 on RI2.EntityId=X.ProductId and RI2.RepositoryIndexType=1" + JvString.CRLF +
    "where" + JvString.CRLF +
    "  P.ParentEntityId=" + prodFamily.ProductFamilyId.getSqlString() + JvString.CRLF +
    "order by ProductName, ProductCode");

request.setAttribute("ds", ds);

String previousProductId = ""; 
%>

<div class="tab-content">
  <v:grid dataset="<%=ds%>">
    <tr class="header">
    <td>&nbsp;</td>
    <td width="50%">
      <%=prodFamily.ProductFamilyName.getHtmlString()%>
    </td>
    <td>&nbsp;</td>
    <td width="50%">
      <%=prodFamily.TargetProductFamilyName.getHtmlString()%>
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <% if (!ds.getField("ProductId").getEmptyString().equals(previousProductId)) {%>
    <% previousProductId = ds.getField("ProductId").getEmptyString(); %>
    <td><v:grid-icon name="<%=LkSNEntityType.ProductType.getIconName()%>" repositoryId='<%=ds.getField("ProfilePictureId").getString()%>'/></td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(\"ProductId\")%>" entityType="<%=LkSNEntityType.ProductType%>">
        <%=ds.getField("ProductName").getHtmlString()%>
      </snp:entity-link><br/>
      <span class="list-subtitle"><%=ds.getField("ProductCode").getHtmlString()%>&nbsp;</span>
    </td>  
    <% } else {%>
      <td></td>
      <td>"</td>
    <% } %>
    
    <% if (!ds.getField("TargetProductId").getEmptyString().isEmpty()) {%>
    <td><v:grid-icon name="<%=LkSNEntityType.ProductType.getIconName()%>" repositoryId='<%=ds.getField("TargetProfilePictureId").getString()%>'/></td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(\"TargetProductId\")%>" entityType="<%=LkSNEntityType.ProductType%>">
        <%=ds.getField("TargetProductName").getHtmlString()%>
      </snp:entity-link><br/>
      <span class="list-subtitle"><%=ds.getField("TargetProductCode").getHtmlString()%>&nbsp;</span>
    </td>
    <% } else {%>
      <td></td>
      <td><v:itl key="@Product.ProductUnassigned"/></td>
    <% } %>
  </v:grid-row>
  </v:grid>
</div>

