<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="Help" default="true">
    <div class="tab-content">
      <v:widget caption="Info">
        <v:widget-block>
          <b>Vgs Store</b> includes functionality to manage SnApp licenses and some utility tools
          <br><br>
        </v:widget-block>
      </v:widget>
      <v:widget caption="Security">
        <v:widget-block>
          In order to manage Licenses and create JIRA versions, the user logged must have the "vgs support" right or belong to one of the following roles: <br><br>
		  <ul>
		    <li>Security role with code <b>STORE_LIC</b> to manage licenses</li>
        <li>Security role with code <b>STORE_VER</b> to create JIRA versions</li>
        <li>Security role with code <b>STORE_PWD</b> to generate "vgs-support" passwords</li>
		  </ul>
        </v:widget-block>
      </v:widget>
    </div>
  </v:tab-item-embedded>
</v:tab-group>

<jsp:include page="/resources/common/footer.jsp"/>