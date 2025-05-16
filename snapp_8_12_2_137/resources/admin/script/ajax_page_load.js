$(document).ready(function() {

  var tsPageClick = null;
  var currentCloneId = null;
  var clones = {};
  var listSources = {}; 

  function replaceAdminBody(data) {
    var $data = $(data);

    document.title = $data.filter("title").text();

    $("body>[role='dialog']").remove();
    $data.find("#adminbody").replaceAll("#adminbody");
    $(window).scrollTop(0);
    
    $("#adminnavbar li.current-item").removeClass("current-item");
    $("#adminnavbar li").each(function(idx, elem) {
      var $elem = $(elem);
      var iconName = $elem.attr("data-IconName");
      if ((iconName) && (iconName.indexOf(".png") >= 0)) {
        var subicon = (iconName.indexOf("bko-menu-") == 0) ? "TransformNegative" : null;
        $elem.find(".ab-icon").first().css("background-image", "url(" + getIconURL(iconName, 16, subicon) + ")");
      }
    });
    $data.find("#adminnavbar li.current-item").each(function(idx, elem) {
      var $item = $("#" + $(elem).attr("id")); 
      var iconName = $item.attr("data-IconName");
      $item.addClass("current-item");
      if ((iconName) && (iconName.indexOf(".png") >= 0))
        $item.find(".ab-icon").first().css("background-image", "url(" + getIconURL(iconName, 16) + ")");
    });
    
    var entityId = getUrlParam(window.location.href, "id");
    var cloneId = listSources[entityId];
    $(".page-back-to-list").attr("data-cloneid", cloneId).setClass("hidden", (cloneId == null) || (cloneId == undefined));
    
    $(document).trigger("ajax-content-load");
    initProfilePic(".profile-pic-inner");
    $(".default-focus").focus();
  }
  
  function confirmFormDataChanged(callback) {
    if ($("form.data-changed").length == 0)
      callback();
    else {
      confirmDialog(itl("@Common.DiscardChangesConfirm"), function() {
        callback();
      });
    }
  }

  function asyncLoadPage(urlo, checkChanges, callback) {
    if (checkChanges) {
      confirmFormDataChanged(function() {
        _asyncLoadPage(urlo, callback);
      });
    }
    else 
      _asyncLoadPage(urlo, callback);
  }

  function _asyncLoadPage(urlo, callback) {
    function _slowCall(ts) {
      if (ts == tsPageClick)
        showWaitGlass();
    }
    
    var tsThisClick = (new Date()).getTime(); 
    tsPageClick = tsThisClick;
    setTimeout(function() {_slowCall(tsThisClick)}, 500);

    $.ajax({
      url: urlo,
      dataType: "html",
      cache: false,
      success: function(data, textStatus, xhr) {
        tsPageClick = null;
        hideWaitGlass();
        
        var clone = generateClone();
        clones[currentCloneId] = clone;
        history.replaceState({"cloneId":currentCloneId}, clone.title, clone.href);
        
        currentCloneId = newStrUUID();

        var $data = $(data.trim());
        clones[currentCloneId] = {"href":urlo};
        history.pushState({"cloneId":currentCloneId}, $data.filter("title").text(), urlo);
        replaceAdminBody($data);
        
        if (callback)
          callback();
      },
      error: function(xhr, textStatus, errorThrown) {
        if ((xhr) && ((xhr.status == 401) || (xhr.status == 0))) //Status 0 can happen when a redirect to a different syte is requested (external login)
          window.location = urlo;
        else {
          tsPageClick = null;
          hideWaitGlass();
          showIconMessage("warning",  errorThrown.length == 0 ? getErrorDescription(xhr.status) : errorThrown);
        }
      }
    });
  }

  $(document).on("click", "a, tr.grid-row td", function(e) {
    var $this = $(this);    

    
    if ($this.is("td")) {
      var $tr = $this.closest("tr");
      if (e.ctrlKey || ($this.find(".cblist").length > 0)) 
        $tr.find(".cblist").trigger("click");
      else 
        $this = $tr.find("a.list-title");
    }

    if ($this.is("a")) {
      if ($this.closest("tr.grid-row").length > 0)
        e.stopPropagation();
      
      if ($this.attr("disabled") == "disabled") {
        e.preventDefault();
      }
      else {
        var urlo = $this.attr("href");
        if ((urlo) && urlo.startsWith(BASE_URL) && !urlo.startsWith("#") && !urlo.startsWith("javascript:") && !$this.hasClass("no-ajax") && ($this.attr("target") != "_blank") && ($this.attr("target") != "_new") && !e.ctrlKey) {
          if ($this.hasClass("list-title")) {
            var $tr = $this.closest("tr.grid-row"); 
            $tr.closest(".listcontainer").find("tr.row-clicked").removeClass("row-clicked");
            $tr.addClass("row-clicked");
            
            currentCloneId = (currentCloneId) ? currentCloneId : newStrUUID();
            listSources[getUrlParam(urlo, "id")] = currentCloneId;
          }
          e.preventDefault();
          asyncLoadPage(urlo, true);
        }
      }
    }
  });

  function getErrorDescription(error){
    var description;
    switch(error){
      case 403:
        description = 'Forbidden';
      break;
      
      default :
        description = 'Error ' + error;
      break;
      
    }
    return description;
  }
 
  function generateClone() {
    let inputValues = {};
    $("input, textarea, select").each(function(index, elem) {
      inputValues[buildSelector(elem)] = isCheckElem(elem) ? elem.checked : elem.value;
    });    
    
    $(".selectize-control").remove();
    $("body>.selectize-dropdown").remove();
    $("select.selectized").each(function(idx, item) {
      var $item = $(item);
      var sel = $item.val();
      $item.removeClass("selectized").html($item.attr("data-html")).removeAttr("data-html");
      $item.find("option").removeAttr("selected");
      if (sel) 
        for (var i=0; i<sel.length; i++) 
          $item.find("option[value='" + sel[i] + "']").attr("selected", "selected");
    });
    $(".popover").remove();

    $("input.v-datepicker").datepicker("destroy");
    $(".ui-datepicker").remove();

    $(".ui-dialog-content").dialog("close");

    return {
      "obj": $("html").clone(true, true),
      "scrollTop":$(window).scrollTop(),
      "title": $("title").text(),
      "href": window.location.href,
      "inputs": inputValues
    };
  }
  
  function isCheckElem(elem) {
    return (elem.type === "checkbox" || elem.type === "radio");
  }
  
  function buildSelector(elem) {
    let selector = elem.tagName;
      
    if (elem.id)
      selector += "#" + elem.id;
        
    if (elem.name) 
      selector += "[name='" + elem.name + "']";
        
    if (elem.className) 
      selector += "." + elem.className.replaceAll(" ", ".");
      
    if (isCheckElem(elem))
      selector += "[value='" + elem.value + "']";
        
    return selector;
  }

  function loadClone(cloneId) {
    var clone = generateClone();
    clone.href = clones[currentCloneId].href; 
    clones[currentCloneId] = clone;

    currentCloneId = cloneId;
    var clone = clones[cloneId];
    
    replaceAdminBody(clone.obj.html());
    
    $("input, textarea, select").each(function(index, elem) {
      let value = clone.inputs[buildSelector(elem)];
      if (isCheckElem(elem))
        elem.checked = value;
      else
        elem.value = value;     
    });    
    
    snpObserver.bodyChanged();

    if (clone.scrollTop)
      $(window).scrollTop(clone.scrollTop);
  }

  $(document).on("click", ".page-back-to-list", function(e) {
    var link = this;
    if (!hasUnsavedData())
      navigateBackToList(link);
    else {
      confirmDialog(itl("@Common.DiscardChangesConfirm"), function() {
        navigateBackToList(link)
      });
    } 
  });
  
  function navigateBackToList(link) {
    var cloneId = $(link).attr("data-cloneid");
    var clone = clones[cloneId];
    loadClone(cloneId);
    history.pushState({"cloneId":cloneId}, clone.title, clone.href);
  }

  window.addEventListener("popstate", function(e) {
    if (e.state) 
      loadClone(e.state.cloneId);
  });

  window.entitySaveNotification = function(entityType, entityId, params, urlo) {
    urlo = (urlo) ? urlo : getPageURL(entityType, entityId);
    if (params)
      urlo += "&" + params;
    
    asyncLoadPage(urlo, false, function() {
      var $content = $("<div style='font-size:1.5em'><i class='fa fa-check'></i> <span class='title'/></div>");
      $content.find(".title").text(itl("@Common.SaveSuccessMsg"));
      showNotification($content, "success");
    });
  };
});
