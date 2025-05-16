jQuery.fn.vWizard = function(p1, p2) {
  const DATA_FUNCTION_ACTIVATE = "function-activate";
  const DATA_FUNCTION_VALIDATE = "function-validate";
  const DATA_FUNCTION_FILLDATA = "function-filldata";
  var $this = $(this);
  
  if (p1 == "activeIndex") {
    if (p2 === undefined)
      return _getActiveIndex();
    else
      return _setActiveIndex(p2);
  } 
  else if (p1 == "next")
    return _next();
  else if (p1 == "prior")
    return _prior();
  else if (p1 == "length")
    return _length();
  else if (p1 == "step-activate")
    return _stepActivate(p2);
  else if (p1 == "step-validate")
    return _stepValidate(p2);
  else if (p1 == "step-filldata")
    return _stepFillData(p2);
  else if (p1 == "validateActiveStep")
    return _validateActiveStep(p2);
  else if (p1 == "fillData")
    return _fillData(p2);
  else if (typeof p1 == "object") 
    return _init(p1);
  

  function _init(params) {
    if (!$this.is(".nav-initialized")) {
      var $nav = $("<ul class='nav nav-wizard'/>").prependTo($this);
      $this.data(params || {});
      $this.find(".wizard-step").each(function(index, elem) {
        var $item = $(elem);
        var title = $item.find(".wizard-step-title").text();
        $("<li><a href='#'></a></li>").appendTo($nav).find("a").text(title);
      });
      
      $this.addClass("nav-initialized");
      
      _setActiveIndex(0);
    }

    return $this;
  }  
  
  function _getActiveIndex() {
    var $step = $this.find(".nav-wizard li.active");
    if ($step.length == 0)
      return -1;
    else
      return $step.index();
  }
  
  function _setActiveIndex(index) {
    var activeIndex = _getActiveIndex();
    if (activeIndex != index) {
      var $navItems = $this.find(".nav-wizard li");
      var $steps = $this.find(".wizard-step");
      var $step = $($steps[index]);
      var $oldStep = $($steps[activeIndex]);
  
      if ((index < 0) || ($navItems.length <= index))
        throw "Index out of bounds: " + index;
        
      var validateFunction = $oldStep.data(DATA_FUNCTION_VALIDATE);
      if ((index > activeIndex) && validateFunction) 
        validateFunction(__doChange);
      else 
        __doChange();

      function __doChange() {
        $navItems.removeClass("active");
        $($navItems[index]).addClass("active");
    
        $steps.removeClass("active");
        $step.addClass("active");
        
        var activateFunction = $step.data(DATA_FUNCTION_ACTIVATE);
        if (activateFunction) {
          activateFunction({
            "$step": $step,
            "$oldStep": $oldStep,
            "direction": (index > activeIndex) ? "forward" : "backward"
          });
        }
        
        var params = $this.data();
        if (params.onStepChanged) {
          params.onStepChanged();
        }
      }
    }

    return $this;
  }
  
  function _next() {
    _setActiveIndex(_getActiveIndex() + 1);
    return $this;
  }
  
  function _prior() {
    _setActiveIndex(_getActiveIndex() - 1);
    return $this;
  }
  
  function _length() {
    return $this.find(".nav-wizard li").length;
  }
  
  function _assertIsStep(methodName) {
    if (!$this.is(".wizard-step"))
      throw "Method '" + methodName + "' can be called only for wizard STEP elements";
  }
  
  function _stepActivate(activateFunction) {
    _assertIsStep("step-activate");
    $this.data(DATA_FUNCTION_ACTIVATE, activateFunction);
  }
  
  function _stepValidate(validateFunction) {
    _assertIsStep("step-validate");
    $this.data(DATA_FUNCTION_VALIDATE, validateFunction);
  }
  
  function _stepFillData(fillDataFunction) {
    _assertIsStep("step-filldata");
    $this.data(DATA_FUNCTION_FILLDATA, fillDataFunction);
  }
  
  function _validateActiveStep(callback) {
    var $step = $($this.find(".wizard-step")[_getActiveIndex()]);
    var validateFunction = $step.data(DATA_FUNCTION_VALIDATE);
    if (validateFunction) 
      validateFunction(callback);
  }
  
  function _fillData(data) {
    $this.find(".wizard-step").each(function(index, item) {
      let $step = $(item);
      let fnc = $step.data(DATA_FUNCTION_FILLDATA);
      if (fnc)
        fnc(data);
    });
  }
};
