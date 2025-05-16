function monitorFormChange(formElements) {
  formElements.change(function () {
    $(this).data('isDirty', true);
  });
  
};

function formIsDirty(formElements) {
  var isDirty = false;
  $(formElements).each(function(i, item) {
    isDirty = $(item).data('isDirty') || isDirty; 
    return !isDirty;
  });
  return isDirty;
};

function formValidate(formElements) {
  var message;
  
  var getTitle = function(input) {
    return $(input).closest('.form-field').children('.form-field-caption').text();
  };
  
  $(formElements).each(function(i, input) {
    var validity = input.validity;
    if (!validity.valid) {
      var title = getTitle(input);
      var min = $(input).attr('min');
      var max = $(input).attr('max');
      var step = $(input).attr('step') || 1;
      var inputNumber = $(input).attr('type') === 'number';
      if (validity.rangeUnderflow)
        message = '{0} è fuori del range (min={1})'.format(title, min);
      else if (validity.rangeOverflow)
        message = '{0} è fuori del range (max={1})'.format(title, max);
      else if (validity.badInput)
        if (inputNumber)
          message = '{0} è il numero'.format(title);
        else
          message = '{0} è male ingresso'.format(title);
      else if (validity.stepMismatch) {
        var pattern = $(input).attr('pattern');
        if (pattern) {
          if (validity.patternMismatch)
            message = '{0} mismatch pattern ({1})'.format(title, pattern);
          else
            return true
        } else
          message = '{0} è male passo (passo={1})'.format(title, step);
      } else if (validity.valueMissing) {
        var defaultValue = $(input).attr('data-default');
        if (defaultValue) {
          $(input).val(defaultValue);
          return true;
        } else
          message = '{0} è un campo obbligatorio'.format(title);
      } else if (validity.patternMismatch) {
        var pattern = $(input).attr('pattern');
        console.info('{0} mismatch pattern=/{1}/'.format(title, pattern));
        message = '{0} mismatch pattern'.format(title);
      } else {
        message = 'Unhandled problem for field {0}'.format(title);
        console.error('Unhandled validation problem: input=', title, '; validity=', validity);
      }  
      showMessage(message);
      return false;
    }
  });
  if (message)
    return false;
  return true;
};