<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="view-medialookup-medias">
  <div class="tab-header">
    <div class="toolbar-button btn-toolbar-back"></div>
    <div class="toolbar-button btn-float-right"></div>
    <div class="tab-header-title"><div class="snp-itl" data-key="@Ticket.Tickets"/></div>
  </div>
  <div class="tab-body waiting">
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

UIMob.init("medialookup-medias", function($view, params) {
  var media = params.MediaRef;
  var $tabBody = $view.find(".tab-body");
  
  snpAPI("Media", "Search", {"PortfolioId":media.PortfolioId})
    .finally(function() {
      $tabBody.removeClass("waiting");
    })
    .then(function(ansDO) {
      renderMedias(ansDO.MediaList || []);
    });
  
  function renderMedias(list) {
    for (var i=0; i<list.length; i++) {
      var media = list[i];
      
      var printed = itl("@Common.NotPrinted");
      if (media.PrintDateTime)
        printed = formatShortDateTimeFromXML(media.PrintDateTime);
      
      var $rec = $view.find(".templates .list-item").clone().appendTo($tabBody);      
      $rec.addClass(COMMON_STATUS[media.CommonStatus]);
      $rec.find(".pmedia-tdssn .list-item-text").text(media.MediaCalcCode);
      $rec.find(".pmedia-status .list-item-text").text(media.MediaStatusDesc);
      $rec.find(".pmedia-print .list-item-text").text(printed);
    }
  }

});

</script>
