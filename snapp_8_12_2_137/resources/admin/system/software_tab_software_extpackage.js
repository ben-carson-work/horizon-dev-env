//# sourceURL=software_tab_software_extpackage.js

$(document).ready(function() {
  const EntityType_ExtensionPackage = 79;
  const CommonStatus_Active = 20;
  const CommonStatus_Warn   = 30;
  let packages = [];
  let versions = [];
  
  let $widget = $("#extpkg-widget");
  let $container = $widget.find("#extpkg-list-container");
  $widget.find("#btn-add").click(_showAddPackageDialog);
  $widget.find("#btn-updateall").click(_updateAll);
  $(document).von($widget, "software-update", _onSoftwareUpdate)
  $(document).von($widget, "OnEntityChange", _onEntityChange)
  
  let $btnUpload = $widget.find("#btn-upload");
  if ($btnUpload.length > 0) {
    if (typeof window.showOpenFilePicker !== "undefined") 
      $btnUpload.click(_uploadPackage);
    else {
      console.error("window.showOpenFilePicker() function is not supported by your browser");
      $btnUpload.setEnabled(false);
    }
  } 
  
  _refresh(true);
  
  function _showAddPackageDialog() {
    asyncDialogEasy("system/newpkgs_dialog");
  }
  
  function _showPackageDialog() {
    let packageId = $(this).attr("data-packageid");
    asyncDialogEasy("plugin/extpackage_dialog", "id=" + packageId);
  }
  
  function _uploadPackage() {
    asyncUploadFileEasy({
      types: [
        {
          description: "Extension Packages",
          accept: {
            "jar/*": [".jar"],
          },
        },
      ]
    }).then(result => {
      snpAPI
        .cmd("Plugin", "UploadExtensionPackage", {RepositoryId:result.RepositoryId})
        .then(ansDO => triggerEntityChange(EntityType_ExtensionPackage));
    });
  }
  
  function _updatePackage(event) {
    event.stopPropagation();
    
    let $tile = $(this).closest(".extpkg-tile");
    let msg = "Do you want to update " + $tile.attr("data-packagecode") + " from version " + $tile.attr("data-version") + " to " + $tile.attr("data-availableversion") + "?";
    confirmDialog(msg, function() {
      _installPackageFromURLs($tile.attr("data-downloadurl"));
    });
  }
  
  function _updateAll(event) {
    let $tiles = $container.find(".extpkg-tile.update-available"); 
    confirmDialog("Do you want to update " + $tiles.length + " packages?", function() {
      let urls = [];
      $tiles.each(function(index, elem) {
        urls.push($(elem).attr("data-downloadurl"));
      });
      
      _installPackageFromURLs(urls);
    });
  }  
  
  function _installPackageFromURLs(urls) {
    snpAPI.cmd("Plugin", "InstallExtensionPackageFromURL", {
      "DownloadURL": urls
    }).then(ansDO => triggerEntityChange(EntityType_ExtensionPackage));
  }
  
  function _onSoftwareUpdate(event, info) {
    versions = info.Packages_List || [];
    _renderPackages();
  }
  
  function _onEntityChange(event, info) {
    if ((info) && (info.EntityType == EntityType_ExtensionPackage))
      _refresh(false);
  }
   
  function _refresh(recursive) {
    snpAPI.cmd("Plugin", "ExtensionPackageSearch", {}, {showWaitGlass:false, silent:true})
      .then(ansDO => {
        try {
          packages = ansDO.ExtensionPackageList || [];
          _renderPackages();
        }
        finally {
          if ((recursive === true) && $("#extpkg-widget").length > 0)
            setTimeout(function() {_refresh(true)}, 2500);
        }      
      })
      .catch(error => {
      console.error(error);      
      if ((recursive === true) && $("#extpkg-widget").length > 0)
        setTimeout(function() {_refresh(true)}, 2500);
      });
  } 
  
  
  function _renderPackages() {
    // Remove tiles     
    let packageIDs = packages.map(pkg => pkg.PackageId);
    $container.find(".extpkg-tile").each(function(index, elem) {
      let $tile = $(elem); 
      if (packageIDs.indexOf($tile.attr("data-packageid")) < 0)
        $tile.remove();
    });
    
    // Add/Update tiles 
    for (let i=0; i<packages.length; i++) {
      let pkg = packages[i];
      let $tile = $widget.find(".extpkg-tile[data-packageid='" + pkg.PackageId + "']");

      if ($tile.length == 0) {
        $tile = $widget.find("#templates .extpkg-tile").clone().appendTo($container);
        $tile.attr("data-packageid", pkg.PackageId); 
        $tile.attr("data-packagecode", pkg.PackageCode); 
        $tile.attr("data-packagedesc", pkg.PackageName); 
        $tile.find(".pkg-code").text(pkg.PackageCodeSmart);
        $tile.click(_showPackageDialog);
        $tile.find(".pkg-update-available").click(_updatePackage);
      }

      $tile.css("order", i);
      $tile.attr("data-commonstatus", pkg.CommonStatus);
      $tile.attr("data-version", pkg.PackageVersion); 
      $tile.find(".pkg-version").text(pkg.PackageVersion);
      $tile.find(".pkg-icon img").attr("src", getIconURL(pkg.IconName, 48));
    }

    for (const pkg of versions) {
      let $tile = $widget.find(".extpkg-tile[data-packagecode='" + pkg.PackageCode + "']");
      if ($tile.length >= 0) {
        $tile.attr("data-availableversion", pkg.PackageVersion);
        $tile.attr("data-downloadsize", getSmoothSize(pkg.FileSize));
        $tile.attr("data-downloadurl", pkg.DownloadURL);
      }
    }
    
    $widget.find(".extpkg-tile").each(function(index, elem) {
      let $tile = $(elem);
      let commonStatus = parseInt($tile.attr("data-commonstatus"));
      let availableVersion = $tile.attr("data-availableversion");
      let updateAvailable = isGreaterVersion(availableVersion, $tile.attr("data-version")); 
      
      $tile.setClass("status-ok", commonStatus == CommonStatus_Active);
      $tile.setClass("status-warn", commonStatus == CommonStatus_Warn);
      $tile.setClass("status-disabled", [CommonStatus_Active, CommonStatus_Warn].indexOf(commonStatus) < 0);
      $tile.setClass("update-available", updateAvailable);
  
      $tile.find(".pkg-update-available").attr("title", "Update now to " + availableVersion + " (" + $tile.attr("data-downloadsize") + ")");
      
      let $tooltip = $widget.find("#templates .extpkg-tooltip").clone();
      $tooltip.find(".extpkg-code").text($tile.attr("data-packagecode"));
      $tooltip.find(".extpkg-version").text($tile.attr("data-version"));
      $tooltip.find(".extpkg-desc").text($tile.attr("data-packagedesc"));
      if (updateAvailable === true)
        $tooltip.find(".extpkg-update").text("New version available: " + availableVersion + " (" + $tile.attr("data-downloadsize") + ")");
      else
        $tooltip.find(".extpkg-update").remove();
      $tile.attr("data-content", $tooltip.html());
    });
    
    let availableUpdateCount = $container.find(".extpkg-tile.update-available").length;
    let $updateAllBox = $widget.find("#extpkg-updateall-box");
    $updateAllBox.setClass("hidden", availableUpdateCount <= 0);
    $updateAllBox.find("#extpkg-update-count").text(availableUpdateCount); 
  }

});
