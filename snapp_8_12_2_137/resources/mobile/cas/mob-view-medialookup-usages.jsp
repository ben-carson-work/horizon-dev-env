<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="view-medialookup-usages">
  <div class="tab-header">
    <div class="toolbar-button btn-toolbar-back"></div>
    <div class="toolbar-button btn-float-right"></div>
    <div class="tab-header-title"><div class="snp-itl" data-key="@Ticket.Usages"/></div>
  </div>
  <div class="tab-body">
    <div class="scroll-content">
      <div class="search-list"/>
    </div>
  </div>
  
  
  <div class="templates">
    <div class="list-item show-icon">
      <div class="list-item-icon"></div>
      <div class="list-item-body">
        <div class="mobile-ellipsis usage-datetime list-item-title"><span class="list-item-text"></span></div>
        <div class="mobile-ellipsis usage-valresult"><span class="list-item-text"></span></div>
        <div class="mobile-ellipsis usage-location"><span class="list-item-texticon fa fa-map-marker-alt"></span><span class="list-item-text"></span></div>
        <div class="mobile-ellipsis usage-product"><span class="list-item-texticon fa fa-tag"></span><span class="list-item-text"></span></div>
      </div>
    </div>
  </div>
</div>


<script>

UIMob.init("medialookup-usages", function($view, params) {
  var $tabBody = $view.find(".tab-body");
  
  UIMob.initSearch({
    "Body": $tabBody,
    "Cmd": "Portfolio",
    "Command": "SearchTicketUsage",
    "ListNodeName": "TicketUsageList",
    "renderItem": renderUsage,
    "CommandDO": {
      "PortfolioMediaId": params.PortfolioId,
      "TicketId": params.TicketId
    }
  });
  
  function renderUsage(usage) {
    var location = usage.AptLocationName;
    if (usage.AccessAreaName)
      location += " » " + usage.AccessAreaName;

    var $usage = $view.find(".templates .list-item").clone().appendTo($tabBody.find(".search-list"));      

    $usage.find(".list-item-icon").css("background-image", "url(" + calcIconName(usage.IconName, 128) + ")");
    
    $usage.find(".usage-datetime .list-item-text").text(formatShortDateTimeFromXML(usage.UsageDateTime));
    $usage.find(".usage-valresult .list-item-text").text(usage.ValidateResultDesc);
    $usage.find(".usage-location .list-item-text").text(location);
    $usage.find(".usage-product .list-item-text").text(usage.ProductName);
  }

});

</script>
