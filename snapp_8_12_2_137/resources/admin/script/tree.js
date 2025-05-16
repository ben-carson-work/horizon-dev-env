
jQuery.fn.tree = function(params) {

  function recursiveFill(ul, node) {
    var li = $("<li/>").appendTo(ul);
    li.treeNodeCaption(node.Caption);
    li.treeNodeIcon(node.Icon);
    
    for (var dataItem in node.Data)
      li.attr("data-" + dataItem, node.Data[dataItem]);
    
    if (node.Classes)
      li.attr("class", node.Classes.replace(",", " "));
      
    if (node.Id)
      li.attr("data-id", node.Id);
    
    if ((node.ChildNodes) && (node.ChildNodes.length > 0)) {
      var ulChild = $("<ul/>").appendTo(li);
      for (var i=0; i<node.ChildNodes.length; i++) 
        recursiveFill(ulChild,  node.ChildNodes[i]);
    }

    li.treeNodeRefreshHasChild();
    
    if (li.hasClass("selected"))
      li.treeNodeSelect();
  }

  $(this).find(".vgs-tree").remove();
  var ul = $("<ul class='vgs-tree'/>").appendTo(this);
  ul.data("params", params);

  if (params.data.ChildNodes)
    for (var i=0; i<params.data.ChildNodes.length; i++) 
      recursiveFill(ul, params.data.ChildNodes[i]);
};

jQuery.fn.treeParams = function() {
  var tree = $(this).closest("ul.vgs-tree");
  var params = tree.data("params");
  return (params) ? params : {};
};

jQuery.fn.treeAddChild = function(params) {
  var ul = $(this).children("ul");
  if (ul.length == 0) 
    ul = $("<ul/>").appendTo(this);
  var li = $("<li/>").appendTo(ul[0]);
  
  params = (params) ? params : {};
  li.treeNodeCaption(params.caption);
  li.treeNodeIcon(params.icon);
  li.treeNodeRefreshHasChild();
  
  if (params.id)
    li.attr("data-id", params.id);
  
  return li;
};

jQuery.fn.treeNodeSelect = function() {
  $(this).closest("ul.vgs-tree").find("li").removeClass("selected"); 
  $(this).addClass("selected");
  
  var params = $(this).treeParams();
  if (params.nodeSelected)
    params.nodeSelected(this);
};

jQuery.fn.treeNode = function() {
  var node = $(this).children(".node");
  if (node.length != 1) {
    $(this).children(".node, .treemark").remove();
    node = $("<span class='node'/>").prependTo(this);    
    
    node.click(function() {
      var li = $(this).parent("li");
      li.treeNodeSelect();
    });
    
    node.on("contextmenu", function() {
      var params = $(this).treeParams();
      var li = $(this).closest("li");
      if ((params.popupMenu) && ((params.popupAccept) ? params.popupAccept(li) : true)) {
        li.treeNodeSelect();
        popupMenu(params.popupMenu, this);
      }
      return false;
    });

    var treemark = $("<span class='treemark'><i class='tm-exploded fa fa-chevron-down'></i><i class='tm-collapsed fa fa-chevron-right'></i></span>").prependTo(this);
      
    treemark.click(function() {
      $(this).closest("li").toggleClass("collapsed");
    });

    var params = $(this).treeParams();
    
    if (params.nodeDraggable) $(this).find(".node").draggable(params.nodeDraggable);
    if (params.nodeDroppable) $(this).find(".node").droppable(params.nodeDroppable);
    if (params.nodeCreated) params.nodeCreated($(this));
  }
  return node;
};

jQuery.fn.treeNodeRefreshHasChild = function() {
  var ul = $(this).children("ul");
  var haschild = (ul.length > 0) && (ul.children("li").length > 0);
  $(this).setClass("haschild", haschild);
};

jQuery.fn.treeNodeCaption = function(sCaption) {
  if (sCaption) {
    $(this).attr("data-caption", sCaption);
    
    var node = $(this).treeNode();
    var caption = node.children(".caption");
    if (caption.length != 1) {
      caption.remove();
      caption = $("<span class='caption'/>").appendTo(node);
    }
    caption.html(sCaption);
  }
  return $(this).attr("data-caption");
};

jQuery.fn.treeNodeIcon = function(sIcon) {
  if (sIcon) {
    $(this).attr("data-icon", sIcon);

    var node = $(this).treeNode();
    var icon = node.children(".icon");
    if (sIcon == null)
      icon.remove();
    else {
      if (icon.length != 1) {
        icon.remove();
        icon = $("<img class='icon'/>").prependTo(node);
      }
      icon.attr("src", sIcon);        
    }
  }
  return $(this).attr("data-icon");  
};

jQuery.fn.treeNodeParent = function(newParent) {
  if (newParent) {
    var oldParent = $(this).treeNodeParent();
    
    var newUL = $(newParent).children("ul");
    if (newUL.length == 0)
      newUL = $("<ul/>").appendTo(newParent);
    newUL.append(this);
    
    oldParent.treeNodeRefreshHasChild();
    newParent.treeNodeRefreshHasChild();
    
    return newParent;
  }
  else {
    return $(this).parent().parent();
  }
};

jQuery.fn.treeNodeDelete = function() {
  var parent = $(this).treeNodeParent();
  $(this).remove();
  parent.treeNodeSelect();
};
