$(document).ready(function() {
  var SEARCH_DELAY = 100;
  var lastSearchText = null;
  var lastSearchId = null;
  var lastSearchPage = 1;
  
  var _function_val = $.fn.val;
  $.fn.val = function(value) {
    var $this = $(this);
    if (!$this.is(".v-dyncombo")) 
      return _function_val.call(this, value);
    else {
      var $combo = $this;
      if (typeof value == 'undefined') { 
        var value = $this.attr("data-itemid");
        return (value) ? value : "";
      }
      else {
        if ($combo.is(".v-dyncombo-open")) 
          closeDropdown($combo.data("dropdown"));
      
        if (typeof value == "string") 
          setComboItemId($combo, value);
        else  
          setComboItem($combo, value);
      }
    }
  };
  
  var _function_setEnabled = $.fn.setEnabled;
  $.fn.setEnabled = function(value) {
    var $this = $(this);
    if ($this.is(".v-dyncombo")) {
      var $btn = $this.find(".v-dyncombo-btn");
      if (value == true)
        $btn.removeAttr("disabled");
      else
        $btn.attr("disabled", "disabled");
      return $this;
    } 
    else if (_function_setEnabled)
      return _function_setEnabled.call(this, value);
  };
  
  var _function_allowInteraction = $.ui.dialog.prototype._allowInteraction;
  $.ui.dialog.prototype._allowInteraction = function(event) {
    return !!$(event.target).is(".v-dyncombo-search-text" ) || _function_allowInteraction(event);
  };
  
  $(document).on("submit", "form", function(e) {
    var $form = $(this);
    $form.find(".v-dyncombo-form-param").remove(); 
    $form.find(".v-dyncombo").each(function(idx, combo) {
      var $combo = $(combo);
      $("<input type='hidden' class='v-dyncombo-form-param'/>").appendTo($form).attr("name", $combo.attr("name")).val($combo.val());
    });
  });
  
  $(document).on("keydown", ".v-dyncombo-btn", function(e) {
    if (e.keyCode == KEY_DOWN) {
      var $btn = $(this);
      var $combo = $btn.closest(".v-dyncombo");
      if (!$combo.hasClass("v-dyncombo-open"))
        $btn.trigger("click", e);
    }
  });

  $(document).on("click", ".v-dyncombo-btn", function(e) {
    var $btn = $(this);
    var $combo = $btn.closest(".v-dyncombo");
    var $dropdown = $combo.data("dropdown");
    var $openDropdown = $(".v-dyncombo-dropdown");
    
    var doOpen = true;
    if ($openDropdown.length > 0) {
      doOpen = ($openDropdown[0] != ((($dropdown) && ($dropdown.length >= 0)) ? $dropdown[0] : null));
      closeDropdown($openDropdown);
    }
    
    if (doOpen) {
      var isDialog = ($btn.closest(".ui-dialog").length > 0);
      var $dropdown = $("<div class='dropdown-menu v-dyncombo-dropdown'/>").appendTo("body");
      $dropdown.append("<div class='v-dyncombo-search-container'><input type='text' class='v-dyncombo-search-text'/><i class='fa fa-search search-icon'></i><i class='fa fa-spinner fa-spin spinner-icon'></i></div>");
      $dropdown.append("<ul class='v-dyncombo-item-list'/>");
      $dropdown.css({
        "left": $btn.offset().left + "px", 
        "top": $btn.offset().top + $btn.outerHeight() - (isDialog ? $(document).scrollTop() : 0) + "px",
        "min-width": $btn.outerWidth(),
        "position": isDialog ? "fixed" : "absolute"
      });
      $dropdown.data("combo", $combo);

      $combo.data("dropdown", $dropdown);
      $combo.addClass("v-dyncombo-open");
      $combo.on("remove", function() {
        closeDropdown($dropdown);
      });

      var $srctxt = $dropdown.find(".v-dyncombo-search-text").focus(); 
      $srctxt
        .keyup(function(e) {
          startSearch($combo, false);
        })
        .keydown(function(e) {
          if (e.keyCode == KEY_ENTER)
            handleKeyEnter($dropdown);
          else if (e.keyCode == KEY_DOWN)
            handleKeyDown($dropdown);
          else if (e.keyCode == KEY_UP)
            handleKeyUp($dropdown);
          else if (e.keyCode == KEY_ESC)
            closeDropdown($dropdown);
        })
        .on("focus.spt", function(e) {
          setTimeout(function() {$srctxt.focus()}, 0);
          e.stopPropagation();
        });
      
      $dropdown.find(".v-dyncombo-item-list").scroll(handleScroll);
      
      startSearch($combo, false);
    }
    e.stopPropagation();
  });

  $(document).on("click", function(e) {
    if ($(e.target).closest(".v-dyncombo-dropdown").length == 0) 
      closeDropdown($(".v-dyncombo-dropdown"));
  });
  
  function closeDropdown($dropdown) {
    if ($dropdown.length > 0) {
      var $combo = $dropdown.data("combo");
      if ($combo) {
        $combo.data("dropdown", null);
        $combo.removeClass("v-dyncombo-open");
        if ($dropdown)
          $dropdown.remove();
        lastSearchText = null;
  
        // Calling focus() async as workaround to solve an issue: sync focus() call was somehow triggering "click" on the button, reopening the dropdown again
        setTimeout(function() {
          $combo.find(".v-dyncombo-btn").focus();
        }, 0);
      }
    }
  }
  
  function handleScroll() {
    var $list = $(this);
    var bottom = $list[0].scrollHeight - $list.scrollTop() - $list.innerHeight();
    if (bottom < 200) 
      startSearch($list.closest(".v-dyncombo-dropdown").data("combo"), true);
  }
  
  function handleKeyEnter($dropdown) {
    var $selItem = $dropdown.find(".v-dyncombo-item-list>li.selected");
    if ($selItem.length > 0)
      pickItem($selItem);
  }
  
  function handleKeyDown($dropdown) {
    var $list = $dropdown.find(".v-dyncombo-item-list");
    var $selItem = $list.find(">li.selected");
    if ($selItem.length == 0)
      $list.find(">li").first().addClass("selected");
    else {
      var $next = $selItem.next();
      if ($next.length > 0) {
        $selItem.removeClass("selected");
        $next.addClass("selected");
        var delta = $next.position().top + $next.outerHeight() - $list.innerHeight(); 
        if (delta > 0) 
          $list.scrollTop($list.scrollTop() + delta);
      }
    }
  }
  
  function handleKeyUp($dropdown) {
    var $list = $dropdown.find(".v-dyncombo-item-list");
    var $selItem = $list.find(">li.selected");
    if ($selItem.length == 0)
      $list.find(">li").first().addClass("selected");
    else {
      var $prev = $selItem.prev();
      if ($prev.length > 0) {
        $selItem.removeClass("selected");
        $prev.addClass("selected");
        var delta = $prev.position().top; 
        if (delta < 0) 
          $list.scrollTop($list.scrollTop() + delta);
      }
    }
  }
  
  function startSearch($combo, forScroll) {
    var $dropdown = $combo.data("dropdown");
    var thisSearchText = $dropdown.find(".v-dyncombo-search-text").val().trim();
    if ((thisSearchText != lastSearchText) || forScroll) {
      lastSearchText = thisSearchText;
      
      var thisSearchId = newStrUUID();
      lastSearchId = thisSearchId;
      lastSearchPage = forScroll ? lastSearchPage+1 : 1; 
      
      $dropdown.addClass("v-dyncombo-loading");
      
      setTimeout(function() {
        if (thisSearchId == lastSearchId) {
          var reqDO = {
            PagePos: lastSearchPage,
            RecordPerPage: 100,
            EntityType: $combo.attr("data-entitytype"),
            AuditLocationFilter: ($combo.attr("data-auditlocationfilter") == "true"),
            FullText: thisSearchText
          };
          
          var filters = $combo.attr("data-filters");
          if (filters) 
            reqDO.Filters = JSON.parse(filters);
          
          var $ancestorCombo = findAncestorCombo($combo);
          if (($ancestorCombo) && ($ancestorCombo.length > 0)) {
            reqDO.AncestorId = $ancestorCombo.attr("data-itemid");
            reqDO.AncestorEntityType = $ancestorCombo.attr("data-itementitytype");
          }
          else {
            reqDO.AncestorId = $combo.attr("data-ancestorentityid");
            reqDO.AncestorEntityType = $combo.attr("data-ancestorentitytype");
          }

          vgsService("FullTextLookup", reqDO, false, function(ansDO) {
            if (thisSearchId == lastSearchId) {
              $dropdown.removeClass("v-dyncombo-loading");
              var $list = $dropdown.find(".v-dyncombo-item-list");
              if (!forScroll) {
                $list.empty();
                if ($combo.attr("data-allownull") == "true")
                  $list.append(createItem(null));
              }
              if ((ansDO.Answer) && (ansDO.Answer.ItemList)) {
                for (var i=0; i<ansDO.Answer.ItemList.length; i++) 
                  $list.append(createItem(ansDO.Answer.ItemList[i], $combo));
              }
            }
          }); 
        }
      }, (forScroll) ? 0 : SEARCH_DELAY);
    }
  }
  
  function findParentCombo($combo) {
    var parentComboId = $combo.attr("data-parentcomboid");
    if (getNull(parentComboId) != null) {
      var $parentCombo = $("#" + parentComboId.replace(".", "\\.") + ".v-dyncombo");
      if ($parentCombo.length > 0) 
        return $parentCombo;
      else
        console.error("Unable to find parent combo: #" + parentComboId);
    }
    return null;
  }
  
  /*
   * Recursively find first parent which has a value
   */
  function findAncestorCombo($combo) {
    var $parentCombo = findParentCombo($combo);
    if ($parentCombo == null)
      return null;
    else if (getNull($parentCombo.val()) != null)
      return $parentCombo;
    else
      return findAncestorCombo($parentCombo);
  }
  
  /*
   * Browse all parents and ancestors and set value to null
   */
  function recursiveClearParents($combo) {
    var $parentCombo = findParentCombo($combo);
    if ($parentCombo != null) {
      $parentCombo.val(null);
      recursiveClearParents($parentCombo);
    }
  }
  
  function createItem(item, $combo) {
    var person = (item != null) && (item.ItemEntityType == 15);
    var $item = person ? $("#templates .v-dyncombo-item-account").clone() : $("#templates .v-dyncombo-item-simple").clone();
    
    if (item == null) 
      $item.addClass("empty-option").text("- " + itl("@Common.Empty").toLowerCase() + " -");      
    else {
      $item.data("item", item);
      $item.attr("data-itemid", item.ItemId);

      if (person)
        renderPersonItem($item, item);
      else {
        var caption = "&nbsp;";
        if (($combo) && ($combo.attr("data-showitemcode") == "true")) 
          caption = calcEntityDesc(item.ItemCode, item.ItemName);
        else if (getNull(item.ItemName) != null)
          caption = item.ItemName;

        $item.html(caption);
      }
    }
    
    $item.click(function() {
      pickItem($item);
    });
    
    return $item;
  }
  
  function renderPersonItem($item, item) {
    var iconURL = (item.ProfilePictureId) ? calcRepositoryURL(item.ProfilePictureId, "thumb") : calcIconName(item.IconName, 32);
    var name = ((item.ItemName || "") == "") ? "-" : item.ItemName; 
    var cat = ((item.CategoryNames || []).length == 0) ? "-" : item.CategoryNames.join(", "); 
    
    $item.find(".v-dyncombo-item-icon img").attr("src", iconURL);
    $item.find(".v-dyncombo-account-name").text(name);
    $item.find(".v-dyncombo-account-code").text(item.ItemCode);
    $item.find(".v-dyncombo-account-category").text(cat);
    
  }
  
  function pickItem($item) {
    var $dropdown = $item.closest(".v-dyncombo-dropdown");
    var $combo = $dropdown.data("combo");
    var item = $item.data("item");
    $combo.val((item) ? item : null);
  }

  function setComboItem($combo, item) {
    var itemId = (item) ? item.ItemId : "";
    var itemName = (item) ? item.ItemName : "";
    if ($combo.attr("data-showitemcode") == "true")
      itemName = (item) ? calcEntityDesc(item.ItemCode, item.ItemName) : "";
    
    var itemEntityType = (item) ? item.ItemEntityType : "";
    var parentId = (item) ? item.ParentId : "";
    
    var $btn = $combo.find(".v-dyncombo-btn");
    var $lnk = $combo.find(".combo-link-btn");
    $combo.attr("data-itemid", itemId);
    $combo.attr("data-itemname", itemName);
    $combo.attr("data-itementitytype", itemEntityType);
    $combo.attr("data-parentid", getNull(parentId));
    $btn.find(".caption").text(itemName);
    
    if ((itemId) && (itemId != ""))
      $lnk.removeAttr("disabled");
    else
      $lnk.attr("disabled", "disabled");
    
    if (item) {
      // Update parents
      var parentId = getNull(item.ParentId);
      if (parentId == null) 
        recursiveClearParents($combo);
      else {
        var $parentCombo = findParentCombo($combo);
        if ($parentCombo != null) 
          $parentCombo.val(parentId);
      }
    }

    // Update children
    $(".v-dyncombo[data-parentcomboid='" + $combo.attr("id") + "']").each(function(idx, childCombo) {
      var $childCombo = $(childCombo);
      if (getNull($childCombo.attr("data-parentid")) != getNull($combo.attr("data-itemid")))
        $childCombo.val(null);
    });

    $combo.change();
  }

  function setComboItemId($combo, itemId) {
    if ($combo.attr("data-itemid") != itemId) {
      var reqDO = {
        EntityType: $combo.attr("data-entitytype"),
        EntityId: itemId
      };

      $combo.addClass("looking-up");
      $combo.attr("data-itemid", itemId);
      
      vgsService("FullTextLookup", reqDO, true, function(ansDO) {
        $combo.removeClass("looking-up");
        var errorMsg = getVgsServiceError(ansDO);
        if (errorMsg != null) 
          showIconMessage("warning", errorMsg);
        else {
          var item = ((ansDO.Answer) && (ansDO.Answer.ItemList) && (ansDO.Answer.ItemList.length > 0)) ? ansDO.Answer.ItemList[0] : null;
          setComboItem($combo, item);
        }
      }); 
    }
  }

});
