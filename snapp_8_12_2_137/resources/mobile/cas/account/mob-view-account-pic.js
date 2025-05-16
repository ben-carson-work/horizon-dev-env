/**
 * params = {
 *   ProfilePictureId: string,
 *   EntityId: string,
 *   EntityType: int,
 *   setRepositoryId: function("RepositoryId"),
 *   takePicture: function()
 * } 
 */
UIMob.init("account-pic", function($view, params) {
  $view.find(".btn-toolbar-back").click(onBackClick);
  $view.find(".btn-toolbar-camera").click(onCameraClick);
  
  var $pic = $view.find(".profile-pic");
  $pic.attr("data-repositoryid", params.ProfilePictureId);
  
  var $body = $view.find(".tab-body");
  var hList = $view.find(".repository-list").height();
  var w = $body.width();
  var h = $body.height() - hList;
  var size = Math.min(w, h);
  
  $pic.css({
    "background-image": "url(" + calcRepositoryURL(params.ProfilePictureId, "large") + ")",
    "width": size + "px",
    "height": size + "px",
    "margin-left": ((w - size) / 2) + "px"
  });
  
  var $list = $view.find(".repository-list").empty();
  var $spinner = UIMob.createSpinnerClone().appendTo($list);
  snpAPI("Repository", "Search", {
    "PagePos": 1,
    "RecordPerPage": 20,
    "EntityId": params.EntityId
  }).finally(function() {
    $spinner.remove();
  }).then(function(ansDO) {
    var list = ansDO.RepositoryList || [];
    for (var i=0; i<list.length; i++) {
      var item = list[i];
      var $item = $view.find(".templates .repository-item").clone().appendTo($list);
      $item.attr("data-repositoryid", item.RepositoryId);
      $item.css("background-image", "url(" + calcRepositoryURL(item.RepositoryId, "small") + ")");
      $item.click(onThumbClick);
      if (item.RepositoryId == params.ProfilePictureId) 
        $item.addClass("selected");
    }
  });
  
  function onThumbClick() {
    var $item = $(this);
    $view.find(".repository-item").removeClass("selected");
    $item.addClass("selected");
    
    var id = $item.attr("data-repositoryid");
    $pic.css("background-image", "url(" + calcRepositoryURL(id, "large") + ")");
    $pic.attr("data-repositoryid", id);
  }
  
  function onBackClick() {
    if (params.setRepositoryId)
      params.setRepositoryId($pic.attr("data-repositoryid"));
    navBack();
  }
  
  function onCameraClick() {
    if (params.takePicture)
      params.takePicture();
    navBack();
  }
  
  function navBack() {
    UIMob.tabNavBack($view.closest(".tab-content"));
  }
});