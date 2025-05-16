$(document).ready(function() {
  "use strict";

  $(document).on("view-create", ".apt-view[data-view='free']", _onViewCreate);
  
  function _onViewCreate() {
    let $view = $(this);
    ACM.addClickHandler($view.find(".apt-tool-settings"), _onToolClick_Settings);
  }
  
  function _onToolClick_Settings(event, ui) {
    ACM.setActiveView(ui.$apt, "settings");
  }
  
});