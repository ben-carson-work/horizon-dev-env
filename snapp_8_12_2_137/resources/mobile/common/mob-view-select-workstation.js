$(document).ready(function() {
  var $main = $("#select-wks-main"); 
  var $pref = $main.find("#select-wks-pref");
  var $prefSectionTitle = $pref.find(".pref-section-title");
  var $prefItemList = $pref.find(".pref-item-list");
  
  snpAPI("Login", "GetWorkstationTree", {"WorkstationType":LkSN.WorkstationType.MOB.code})
    .finally(function() {
      $main.find(".tab-body").removeClass("waiting");
    })
    .then(function(ansDO) {
      var list = ansDO.LocationList;
      if ((list) && (list.length > 0)) {
        $pref.removeClass("hidden"); 
        renderLocations(list);
      }
      else 
        $("#select-wks-error").removeClass("hidden");
    })
    .catch(function(error) {
      $("#select-wks-error").removeClass("hidden").text(error.message);
    });
  
  $main.find(".btn-back").on(MOUSE_DOWN_EVENT, function() {
    if ($main.attr("data-level") == "oparea")
      renderLocations($main.data("locations"));
    else if ($main.attr("data-level") == "workstation")
      renderOpAreas($main.data("location"));
  });

  function renderLocations(locations) {
    $main.attr("data-level", "location").data("locations", locations);
    $prefSectionTitle.text(itl("@Account.Locations"));
    $prefItemList.empty();
    
    for (var i=0; i<locations.length; i++) {
      var location = locations[i];
      var $location = $("#common-templates .pref-item").clone().appendTo($prefItemList);
      $location.addClass("pref-item-arrow");
      $location.find(".pref-item-caption").text(location.LocationName);
      $location.data("location", location);
      
      $location.on(MOUSE_DOWN_EVENT, function() {
        renderOpAreas($(this).data("location"));
      });
    }
  }
  
  function renderOpAreas(location) {
    $main.attr("data-level", "oparea").data("location", location);
    $prefSectionTitle.text(location.LocationName);
    $prefItemList.empty();
    
    for (var i=0; i<location.OperatingAreaList.length; i++) {
      var opArea = location.OperatingAreaList[i];
      var $opArea = $("#common-templates .pref-item").clone().appendTo($prefItemList);
      $opArea.addClass("pref-item-arrow");
      $opArea.find(".pref-item-caption").text(opArea.OperatingAreaName);
      $opArea.data("opArea", opArea);
      
      $opArea.on(MOUSE_DOWN_EVENT, function() {
        renderWorkstations(location, $(this).data("opArea"));
      });
    }
  }
  
  function renderWorkstations(location, opArea) {
    $main.attr("data-level", "workstation");
    $prefSectionTitle.text(location.LocationName + " " + CHAR_RAQUO + " " + opArea.OperatingAreaName);
    $prefItemList.empty();
    
    for (var i=0; i<opArea.WorkstationList.length; i++) {
      var wks = opArea.WorkstationList[i];
      var $wks = $("#common-templates .pref-item").clone().appendTo($prefItemList);
      $wks.find(".pref-item-caption").text(wks.WorkstationName);
      $wks.attr("data-workstationid", wks.WorkstationId);
      
      $wks.on(MOUSE_DOWN_EVENT, function() {
        var workstationId = $(this).attr("data-workstationid");
        var activationKey = getLocalStorage("ActivationKey");
        setLocalStorage("WorkstationId", workstationId);
        
        BLMob.registerMobile(workstationId);
      });
    }
  }
});
