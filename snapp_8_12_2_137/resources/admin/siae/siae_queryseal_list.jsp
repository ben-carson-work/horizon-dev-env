<%@page import="com.vgs.snapp.query.QryBO_SiaeBox"%>
<%@page import="com.vgs.snapp.dataobject.DOSiaeFullDetail"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeOrganizer"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSiaeQuerySealList" scope="request"/>

  
<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
<%
BLBO_Siae bl = pageBase.getBLDef();
QueryDef qdef = new QueryDef(QryBO_SiaeBox.class);
qdef.addSelect(QryBO_SiaeBox.Sel.SiaeBoxId);
qdef.addSelect(QryBO_SiaeBox.Sel.SiaeBoxName);
qdef.addSort(QryBO_SiaeBox.Sel.SiaeBoxName);
JvDataSet boxDS = pageBase.execQuery(qdef);

pageBase.setDefaultParameter("SearchDate", pageBase.getBrowserFiscalDate().getXMLDateTime());
%>

<script>
function search() {
   setGridUrlParam("#siae-queryseal-grid", "SearchDate", $("#SearchDate-picker").getXMLDate());
   setGridUrlParam("#siae-queryseal-grid", "SiaeBoxId", $("#SiaeBoxId").val(), true);
}
</script>

<div id="main-container">
  <div class="mainlist-container">
    <jsp:include page="/resources/admin/siae/siae_alert.jsp" />
    <div class="profile-pic-div">
      
      <v:widget caption="@Common.Filters">
        <v:widget-block>
          <v:itl key="Siae box"/><br/>
          <v:combobox field="SiaeBoxId" lookupDataSet="<%=boxDS%>" captionFieldName="SiaeBoxName" idFieldName="SiaeBoxId" allowNull="false"/>
        </v:widget-block>
        <v:widget-block>
          <v:itl key="@Common.Date"/><br/>
          <v:input-text type="datepicker" field="SearchDate"/>
        </v:widget-block>
      </v:widget>
    </div>
    
    <div class="profile-cont-div">
      <div class="form-toolbar">
        <v:button caption="@Common.Search" fa="search" href="javascript:search()"/>
      </div>
    
      <div>
        <v:last-error/>
        <v:async-grid id="siae-queryseal-grid" jsp="siae/siae_queryseal_grid.jsp" />
      </div>
    </div>
  </div>  
</div>

  
<jsp:include page="/resources/common/footer.jsp"/>