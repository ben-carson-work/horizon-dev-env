<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.b2b.page.PageB2B_UserList" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<v:tab-group name="tab" main="true"> 
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <v:tab-toolbar>
      <v:button caption="@Common.Search" fa="search" onclick="search()" />
      <span class="divider"></span>
      <% String hrefNew = pageBase.getContextURL() +  "?page=user&id=new&ParentAccountId=" + pageBase.getSession().getOrgAccountId(); %>
      <v:button caption="@Common.New" fa="plus" href="<%=hrefNew%>"/>
      <v:pagebox gridId="user-grid"/>
    </v:tab-toolbar>
  
    <v:tab-content>
      <v:profile-recap>
        <v:widget caption="@Common.Search">
          <v:widget-block>
            <input type="text" id="FullText" class="form-control default-focus" placeholder="<v:itl key="@Common.FullSearch"/>"/>
          </v:widget-block>
        </v:widget>
      </v:profile-recap>
      
      <v:profile-main>
        <v:async-grid id="user-grid" jsp="account/user_grid.jsp"/>
      </v:profile-main>
    </v:tab-content>
  </v:tab-item-embedded>
</v:tab-group>


<script>

function search() {
  setGridUrlParam("#user-grid", "FullText", $("#FullText").val());
  changeGridPage("#user-grid", "first");
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