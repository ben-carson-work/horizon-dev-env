<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>
<% BOSessionBean boSession = (pageBase == null) ? null : (BOSessionBean)pageBase.getSession(); %>

<% // This IF-BLOCK is supposed to always fail. Just a workaround to have this page highlighted as javascript. %>
<% if (request.getAttribute("BB63A701FB6F4C04B70C44E3CB161795") != null) { %>
<script>
<% } %>


$(document).ready(function() {
  function getShowDelay($handle) {
    var delay = parseInt($handle.attr("data-delay"));
    if (!isNaN(delay))
      return delay;
    else if ($handle.hasClass("entity-tooltip"))
      return 1000;
    
    return 0;
  }
  
  function getHideDelay($handle) {
    if ($handle.hasClass("entity-tooltip") || $handle.hasClass("lk-tooltip-link") || $handle.hasClass("metafield-tooltip-link"))
      return 200;
    
    return 0;
  }
  
  function getPopoverUrl($handle) {
    if ($handle.hasAttr("data-tooltip-url"))
      return $handle.attr("data-tooltip-url");
      
    if ($handle.hasClass("entity-tooltip"))
      return "<%=pageBase.getContextURL()%>?page=tooltip&jsp=entity_tooltip/entity_tooltip&EntityType=" + $handle.attr("data-EntityType") + "&EntityId=" + $handle.attr("data-EntityId");

    if ($handle.hasClass("lk-tooltip-link"))
      return "<%=pageBase.getContextURL()%>?page=tooltip&jsp=help/doc_lookup_tooltip&LookupTable=" + $handle.attr("data-LookupTable");

    if ($handle.hasClass("metafield-tooltip-link"))
      return "<%=pageBase.getContextURL()%>?page=tooltip&jsp=help/doc_metafield_tooltip";
      
    if ($handle.hasAttr("data-jsp"))
      return "<%=pageBase.getContextURL()%>?page=tooltip&jsp=" + $handle.attr("data-jsp");

    throw "Unable to determine tooltip URL";
  }
  
  function getPopoverClass($handle) {
    if ($handle.hasClass("hint-tooltip"))
      return "popover-hint";
      
    return "popover-default";
  }

  function showPopover($handle) {
    var htmlContent = $handle.attr("data-content");
    if ($handle.hasClass("v-tooltip-nocache") && $handle.hasAttr("data-jsp"))
      htmlContent = null;
    
    if (!(htmlContent)) {
      var $contentId = $("#" + $handle.attr("data-content-id"));
      if ($contentId.length > 0) 
        htmlContent = $contentId.html();
      else if ($handle.hasClass("v-tooltip-overflow")) 
        htmlContent = $handle.html();
      else if ($handle.hasClass("hint-tooltip") || $handle.hasClass("form-field-hint") || $handle.hasClass("rights-item-label")) {
        htmlContent = $handle.attr("title");
        if (htmlContent) {
          if (htmlContent.charAt(0) == "@")
            htmlContent = itl(htmlContent);
          var reader = new commonmark.Parser();
          var writer = new commonmark.HtmlRenderer();
          htmlContent = writer.render(reader.parse(htmlContent)); 
        }
      }
      
      $handle.attr("data-content", htmlContent);
    }
    
    if (!(htmlContent)) {
      htmlContent = "<i class='fa fa-circle-notch fa-spin fa-3x fa-fw' style='opacity:0.5'></i>";
      
      $.ajax({
        url: getPopoverUrl($handle),
        dataType:'html',
        cache: false,
        complete: function(jqXHR, textStatus) {
          if ($handle.attr("aria-describedby")) { // if attribute is not there, it means popover is hidden
            var content = (jqXHR.status == 200) ? jqXHR.responseText : "loading error";
            $handle.attr("data-content", content).popover("show");
          }
        }
      });
    }

    $handle.popover({
      container: "body",
      trigger: "manual",
      placement: "auto top",
      content: htmlContent,
      html: true,
      template: "<div class='popover " + getPopoverClass($handle) + "' role='tooltip'><div class='arrow'></div><div class='popover-content'></div></div>"
    }).popover("show");
    
    $handle.on("remove", function() {
      $handle.popover("hide");
    })
  }
  
  function hidePopover($handle) {
    var tsExit = (new Date()).getTime();
    $handle.data("ts-exit", tsExit);
    setTimeout(function() {
      if ($handle.data("ts-exit") == tsExit) 
        $handle.popover("hide");
    }, getHideDelay($handle));
  }
  
  function getPopoverHandle(popover) {
    return $(".v-tooltip[aria-describedby='" + $(popover).attr("id") + "']");
  }

  $(document).on("click", ".v-tooltip-click", function() {
    showPopover($(this));
  });
  
  $(document).on("mouseenter", ".v-tooltip", function() {
    var $this = $(this);
    if (!$this.is(".v-tooltip-click")) {
      var tsEnter = (new Date()).getTime();
      $this.data("ts-enter", tsEnter);
      $this.data("ts-exit", null);
      
      setTimeout(function() {
        var tsStoredEnter = $this.data("ts-enter");
        var tsNow = (new Date()).getTime();
        if ((tsStoredEnter == tsEnter) && ((tsNow - tsEnter) >= getShowDelay($this))) 
          showPopover($this);
      }, getShowDelay($this)); 
    }
  });
  
  $(document).on("mouseleave", ".v-tooltip", function() {
    var $this = $(this);
    if (!$this.is(".v-tooltip-click")) 
      hidePopover($this.data("ts-enter", null));
  });
  
  $(document).on("mouseenter", ".popover", function() {
    getPopoverHandle(this).data("ts-exit", null);
  });
  
  $(document).on("mouseleave", ".popover", function() {
    var $handle = getPopoverHandle(this);
    if (!$handle.is(".v-tooltip-click")) 
      hidePopover($handle);
  });
  
  $(document).on("mouseenter", ".v-tooltip-overflow", function() {
    if (this.offsetWidth < this.scrollWidth) 
      showPopover($(this));
  });
  
  $(document).on("mouseleave", ".v-tooltip-overflow", function() {
    if (this.offsetWidth < this.scrollWidth) 
      hidePopover($(this));
  });
  
});


<% // This IF-BLOCK is supposed to always fail. Just a workaround to have this page highlighted as javascript. %>
<% if (request.getAttribute("BB63A701FB6F4C04B70C44E3CB161795") != null) { %>
</script>
<% } %>
