<%@page import="com.vgs.web.library.bean.StationBean"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Comparator"%>
<%@page import="com.vgs.snapp.web.gencache.SrvBO_Cache_Station"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="logConfig" class="com.vgs.snapp.dataobject.DOLogConfig" scope="request"/>


<v:tab-content id="logcfg-tab-config">
  <v:widget caption="Internal logging">
    <v:widget-block>
      <v:form-field caption="@Common.DataSource">
        <snp:dyncombo field="cbDataSourceId" entityType="<%=LkSNEntityType.DataSource%>" filtersJSON="{\"DataSource\":{\"DataSourceType\":2}}"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>

  <v:widget caption="Log4J properties">
    <v:widget-block>
      <textarea id="areaLog4jProperties" class="form-control" rows="25" width="100%" style="font-family:monospace;"></textarea>
    </v:widget-block>
  </v:widget>
</v:tab-content>

<script>
$(document).ready(function() {
  var $tab = $("#logcfg-tab-config");
  
  $(document).von($tab, "logcfg-load", _initialize);
  $(document).von($tab, "logcfg-save", _save);
  
  function _initialize(event, params) {
    var cfg = params.logcfg || {};
    
    $tab.find("#cbDataSourceId").val(cfg.DataSourceId);
    $tab.find("#areaLog4jProperties").val(cfg.Log4jProperties);
  }
  
  function _save(event, params) {
    params.logcfg.DataSourceId = $tab.find("#cbDataSourceId").val();
    params.logcfg.Log4jProperties = $tab.find("#areaLog4jProperties").val(); 
  }
});
</script>
