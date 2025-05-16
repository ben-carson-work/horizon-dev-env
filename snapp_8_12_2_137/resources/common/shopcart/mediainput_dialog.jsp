<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<v:dialog id="mediainput_dialog" title="@Common.Medias" width="900" height="700" resizable="false">


  <div class="body-block">
    <div class="tab-content">
      <table id="mediainput-table">
      </table>
    </div>
  </div>
  
  <div class="toolbar-block">
    <div id="btn-mediainput-next" class="v-button btn-float-right hl-green"><v:itl key="@Common.Next"/></div>
    <div id="btn-mediainput-back" class="v-button btn-float-right hl-green"><v:itl key="@Common.Back"/></div>
  </div>


  <jsp:include page="mediainput_dialog_css.jsp"/>
  <jsp:include page="mediainput_dialog_js.jsp"/>
  
  <div id="mediainput-templates" class="hidden">
    <table>
      <tbody class="mi-item">
        <tr><td class="mi-item-title" colspan="100%"></td></tr>
      </tbody>
    </table>
  
    <table>
      <tr class="mi-detail">
        <td class="mi-detail-position"></td>
        <td class="mi-detail-account"></td>
        <td class="mi-detail-mediacode"><v:input-text clazz="txt-mediacode" placeholder="@Common.MediaCode"/></td>
      </tr>
    </table>
  </div>

</v:dialog>