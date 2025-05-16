<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Account.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
String[] locationIDs = {};

if (pageBase.getNullParameter("EntityType").equals(Integer.toString(LkSNEntityType.ProductType.getCode())))
  locationIDs = pageBase.getBL(BLBO_Product.class).getProductLocationIDs(pageBase.getId());
else 
  if (pageBase.getNullParameter("EntityType").equals(Integer.toString(LkSNEntityType.Person.getCode())) || pageBase.getNullParameter("EntityType").equals(Integer.toString(LkSNEntityType.Organization.getCode())))
    locationIDs = pageBase.getBL(BLBO_Account.class).findAccountLocationIDs(pageBase.getId());
  else 
    if (pageBase.getNullParameter("EntityType").equals(Integer.toString(LkSNEntityType.Event.getCode())))
  locationIDs = pageBase.getBL(BLBO_Event.class).getEventLocationIDs(pageBase.getId());
    else
  throw new EUserException("EntityType not supported");

QueryDef qdef = new QueryDef(QryBO_Account.class);
//Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.AccountId);
qdef.addSelect(Sel.AccountCode);
qdef.addSelect(Sel.AccountCode);
qdef.addSelect(Sel.DisplayName);
qdef.addSelect(Sel.ProfilePictureId);

qdef.addSort(Sel.DisplayName);
//Filter
qdef.addFilter(Fil.EntityType, LkSNEntityType.Location.getCode());
qdef.addFilter(Fil.AccountId, locationIDs);

//Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>


<v:dialog id="location-list-dialog" width="400" height="400" title="@Common.RelatedLocations">

  <v:grid id="location-list-grid">
    <thead>

    </thead>
    <tbody>
    <v:grid-row dataset="ds">
      <td>
        <v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>" repositoryId="<%=ds.getField(Sel.ProfilePictureId).getString()%>"/>
      </td>
      <td width="100%">
        <a href="<v:config key="site_url"/>/admin?page=account&id=<%=ds.getField(Sel.AccountId).getEmptyString()%>" class="list-title"><%=ds.getField(Sel.DisplayName).getHtmlString()%></a><br/>
        <span class="list-subtitle"><%=ds.getField(Sel.AccountCode).getHtmlString()%>&nbsp;</span>
      </td>
    </v:grid-row>
  </tbody>
  </v:grid>

<script>
var dlg = $("#location-list-dialog");
dlg.on("snapp-dialog", function(event, params) {
  params.buttons = {
    <v:itl key="@Common.Close" encode="JS"/>: doCloseDialog
  };
});
</script>  

</v:dialog>