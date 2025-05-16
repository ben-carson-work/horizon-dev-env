<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.b2b.page.PageB2B_ReportList" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<v:tab-group name="tab" main="true"> 
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <v:button caption="@Common.Search" fa="search" onclick="search()" />
      <v:pagebox gridId="report-grid"/>
    </div>

    <div class="tab-content">
      <div class="profile-pic-div">
        <v:widget caption="@Common.Search">
          <v:widget-block>
            <input type="text" id="FullText" class="form-control default-focus" placeholder="<v:itl key="@Common.FullSearch"/>"/>
          </v:widget-block>
        </v:widget>
      </div>
      
      <div class="profile-cont-div">
        <v:async-grid id="report-grid" jsp="report/report_grid.jsp" />
      </div>
    </div>  
  </v:tab-item-embedded>
</v:tab-group>

<script>

function search() {
  setGridUrlParam("#report-grid", "FullText", $("#FullText").val());
  changeGridPage("#report-grid", "first");
}

function searchOnEnter() {
  if (event.keyCode == KEY_ENTER) {
    search();
    return false;
  }
}

$("#FullText").keypress(searchOnEnter);

</script>

<jsp:include page="/resources/common/footer.jsp"/>
