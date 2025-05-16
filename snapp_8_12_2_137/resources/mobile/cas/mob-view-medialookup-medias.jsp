<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="view-medialookup-medias">
  <div class="tab-header">
    <div class="toolbar-button btn-toolbar-back"></div>
    <div class="toolbar-button btn-float-right"></div>
    <div class="tab-header-title"><div class="snp-itl" data-key="@Common.Medias"/></div>
  </div>
  <div class="tab-body">
    <div class="scroll-content">
      <div class="search-list"/>
    </div>
  </div>
  
  
  <div class="templates">
    <div class="list-item">
      <div class="mobile-ellipsis pmedia-tdssn list-item-title"><span class="list-item-text"></span></div>
      <div class="mobile-ellipsis pmedia-status"><span class="list-item-text"></span></div>
      <div class="mobile-ellipsis pmedia-print rec-small"><span class="list-item-texticon fa fa-print"></span><span class="list-item-text"></span></div>
    </div>
  </div>
</div>


<script>

/**
 * params = {
 *   PortfolioId: string,
 *   onItemClick: function($view, mediaRef)
 * }
 */
UIMob.init("medialookup-medias", function($view, params) {
  var $tabBody = $view.find(".tab-body");
  
  UIMob.initSearch({
    "Body": $tabBody,
    "Cmd": "Media",
    "Command": "Search",
    "ListNodeName": "MediaList",
    "renderItem": renderMedia,
    "CommandDO": {
      "PortfolioId": params.PortfolioId
    }
  });
  
  function renderMedia(media) {
    var printed = itl("@Common.NotPrinted");
    if (media.PrintDateTime)
      printed = formatShortDateTimeFromXML(media.PrintDateTime);
    
    var $media = $view.find(".templates .list-item").clone().appendTo($tabBody.find(".search-list"));
    $media.data("media", media);
    $media.addClass(COMMON_STATUS[media.CommonStatus]);
    $media.find(".pmedia-tdssn .list-item-text").text(media.MediaCalcCode);
    $media.find(".pmedia-status .list-item-text").text(media.MediaStatusDesc);
    $media.find(".pmedia-print .list-item-text").text(printed);
    
    if (params.onItemClick) {
      $media.click(function() {
        params.onItemClick($view, $(this).data("media"));
      });
    }
  }

});

</script>
