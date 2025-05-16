<%@page import="com.vgs.snapp.dataobject.DODB.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.web.bko.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request" />

<v:dialog id="version_builder_create_dialog" width="1000" height="710" title="Create new JIRA version">

  <jsp:include page="version_builder_create_dialog_css.jsp"/>
  <jsp:include page="version_builder_create_dialog_js.jsp"/>

  <div class="wizard waiting">
    <div id="spinner">
      <i class="fas fa-circle-notch fa-spin fa-3x"></i>
    </div>
    <div id="content">
      <table id="table-build-version">
        <tr>
          <td width="25%">
            <v:widget clazz="project-widget" caption="Project" id="project-widget">
              <v:widget-block clazz="version-widget-block"/>
            </v:widget>
          </td>
          <td width="25%">
            <v:widget caption="Major version" id="version-widget">
              <v:widget-block clazz="version-widget-block"/>
            </v:widget>
          </td>
          <td width="50%">
            <v:widget caption="Recap" id="recap-widget">
              <v:widget-block clazz="version-widget-block"/>
            </v:widget>
          </td>
        </tr>
      </table>
    </div>
  </div>
  
   <div class="recap-version-block hidden">
     <div class="recap-version"></div>
     <div class="recap-description"></div>
   </div>
</v:dialog>