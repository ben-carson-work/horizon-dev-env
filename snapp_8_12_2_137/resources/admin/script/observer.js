const snpObserver = new SnappMutationObserver();

function SnappMutationObserver() {
  const data = {
    selectors: [],
    listeners: [],
    registerListener: _registerListener,
    bodyChanged: _bodyChanged
  };
  
  const mo = new MutationObserver(function(mutationsList, observer) {
    for (const listener of data.listeners) {
      var nodes = [];
      for (const mutation of mutationsList) {
        if (mutation.type === 'childList') {
          for (const node of mutation.addedNodes) {
            var $node = $(node);
            nodes = nodes.concat($node.filter(listener.selector).toArray());
            nodes = nodes.concat($node.find(listener.selector).toArray());
          }
        }
      }
      
      for (const node of nodes) {
        var $comp = $(node);
        var initialized = listener.init($comp);
        if (initialized !== false)
          $comp.addClass(listener.initializedClass);
      }
    }
  });
  
  function _registerListener(componentClass, initializedClass, initFunction) {
    componentClass = componentClass || {};
    let selector = componentClass;
    if ((selector.indexOf(".") < 0) && (selector.indexOf("#") < 0) && (selector.indexOf("[") < 0))
      selector = "." + selector;
    selector = selector + ":not(." + initializedClass + ")";
    //var selector = "." + componentClass + ":not(." + initializedClass + ")";
    
    let $comp = $(selector);
    if ($comp.length > 0) {
      let initialized = initFunction($comp);
      if (initialized !== false)
        $comp.addClass(initializedClass);
    }
    
    data.listeners.push({
      "componentClass": componentClass,
      "initializedClass": initializedClass,
      "selector": selector,
      "init": initFunction
    });
  }
  
  function _bodyChanged() {
    mo.observe($("body")[0], { /*attributes: true,*/ childList: true, subtree: true });
  }

  $(document).ready(_bodyChanged);

  return data;
}
