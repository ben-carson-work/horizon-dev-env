<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.dataobject.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageDocAPI" scope="request"/>


<link rel="stylesheet" type="text/css" href="<v:config key="site_url"/>/libraries/swagger-ui-3.21.0/swagger-ui.css" >
<script src="<v:config key="site_url"/>/libraries/swagger-ui-3.21.0/swagger-ui-bundle.js"> </script>
<script src="<v:config key="site_url"/>/libraries/swagger-ui-3.21.0/swagger-ui-standalone-preset.js"> </script>

<style>
.main-tab-fixed-apidoc {
  position: absolute;
  top: 0;
  left: 0;
  bottom: 0;
  right: 0;
  display: flex;
  justify-content: space-between;
}

.apidoc-sidebar {
  border-right: 1px solid var(--border-color);
  flex-shrink: 0;
  flex-grow: 0;
}

.apidoc-sidebar table.listcontainer {
  border: none;
  border-radius: 0;
  width: var(--profile-sidebar-width);
}

.apidoc-sidebar table.listcontainer td {
  padding-left: 10px;
  padding-right: 10px;
}

.apidoc-detail {
  flex-shrink: 1;
  flex-grow: 1;
}

.apidoc-sidebar,
.apidoc-detail {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.apidoc-search-container {
  flex-shrink: 0;
  flex-grow: 0;
  border-bottom: 1px solid var(--border-color);
}

.apidoc-search-result {
  flex-shrink: 1;
  flex-grow: 1;
  overflow-y: auto;
}

.apidoc-search-container input {
  border: none !important;
  border-radius: 0 !important;
  -webkit-box-shadow: none !important;
  box-shadow: none !important;
}
#swagger-ui .information-container,
#swagger-ui .scheme-container {
  display: none;
}
.search-hidden {
  display: none;
}
.search-container {
  margin-right: 150px;
}
.download-container {
  float: right;
  width: 150px;
  padding-left: 10px;
}
.download-container .btn {
  width: 100%;
}
</style>    

<script>
$(document).ready(function() {
  
  function getOpenApiUrl(path) {
    return BASE_URL + "/rest/openapi?path=" + encodeURIComponent(path);
  }

  function showSwagger(path) {
    $("#swagger-ui").empty();
    $(".apidoc-detail").removeClass("hidden");
    $(".apidoc-detail").attr("data-path", path);
    $("#txt-src-method").focus();

    SwaggerUIBundle({
      url: getOpenApiUrl(path),
      dom_id: '#swagger-ui',
      deepLinking: true,
      displayOperationId: true,
      defaultModelsExpandDepth: 0,
      presets: [
        SwaggerUIBundle.presets.apis,
        SwaggerUIStandalonePreset
      ],
      plugins: [
        SwaggerUIBundle.plugins.DownloadUrl
      ],
      layout: "BaseLayout"
    })
  }

  $(".snp-rest-row").click(function() {
    showSwagger($(this).attr("data-path"));
  });
  
  function commonSearch($txt, $items, _getText) {
    $txt = $($txt);
    var text = $txt.val().trim();
    
    $items.removeClass("search-hidden");
    if (text.length > 0) {
      var words = $txt.val().split(" ");
      for (var i=0; i<words.length; i++)
        words[i] = words[i].trim().toLowerCase();
      
      function _match($item) {
        var text = _getText($item).toLowerCase();
        for (var i=0; i<words.length; i++)
          if ((words[i] != "") && (text.indexOf(words[i]) < 0))
            return false;
        return true;
      }

      $items.each(function(index, elem) {
        var $item = $(elem);
        if (!_match($item))
          $item.addClass("search-hidden");
      });
    }
  }
  
  $("#txt-src-api").keyup(function(e) {
    commonSearch(this, $(".snp-rest-row"), function($row) {
      return $row.text();  
    });
  });
  
  $("#txt-src-method").keyup(function(e) {
    commonSearch(this, $("#swagger-ui .opblock"), function($method) {
      return $method.find(".opblock-summary-description").text() + " " + $method.find(".opblock-summary-operation-id").text();  
    });
  });

  $("#btn-openapi-download").click(function() {
    var path = $(".apidoc-detail").attr("data-path");
    console.log(path);
    window.open(getOpenApiUrl(path), "_blank");
  });
});


</script>

<div class="main-tab-fixed">
  <div class="main-tab-fixed-apidoc">
    <div class="apidoc-sidebar">
      <div class="apidoc-search-container">
        <v:input-text field="txt-src-api" clazz="default-focus" autocomplete="off" placeholder="Search..."/>
      </div>
      <div class="apidoc-search-result thin-scrollbar">
        <v:grid id="rest-api-grid">
          <% List<String> groups = new ArrayList<>(); %>
          <% for (DORestApiRef item : BLBO_ApiLog.getRestApiList()) { %>
            <%
            String title = item.Name.getHtmlString();
            String desc = item.Description.getHtmlString();
            boolean display = true; 
            if (!item.ApiGroup.isNull()) {
              if (groups.contains(item.ApiGroup.getString()))
                display = false;
              else {
                groups.add(item.ApiGroup.getString());
                title = item.ApiGroupTitle.getHtmlString();
                desc = item.ApiGroupDescription.getHtmlString();
              }
            }
            %>
            <% if (display) { %>
              <tr class="grid-row snp-rest-row" data-path="<%=item.Path.getHtmlString()%>">
                <td>
                  <div class="list-title"><%=title%></div>
                  <div class="list-subtitle"><%=desc%></div>
                </td>
              </tr>          
            <% } %>
          <% } %>
        </v:grid>
      </div>
    </div>
    <div class="apidoc-detail hidden">
      <div class="apidoc-search-container">
        <div class="download-container"><v:button id="btn-openapi-download" fa="download" caption="OpenAPI JSON"/></div>
        <div class="search-container"><v:input-text field="txt-src-method" placeholder="Search..."/></div>
      </div>
      <div class="apidoc-search-result">
        <div id="swagger-ui"></div>
      </div>
    </div>
  </div>
</div>
