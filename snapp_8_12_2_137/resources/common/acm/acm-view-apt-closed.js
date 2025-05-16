$(document).ready(function() {
  "use strict";

  $(document).on("view-create", ".apt-view[data-view='closed']", _onViewCreate);
  
  function _onViewCreate() {
    var $view = $(this);
    ACM.addClickHandler($view.find(".apt-tool-settings"), _onToolClick_Settings);
  }
  
  function _onToolClick_Settings(event, ui) {
    ACM.setActiveView(ui.$apt, "settings");
  }
  
});