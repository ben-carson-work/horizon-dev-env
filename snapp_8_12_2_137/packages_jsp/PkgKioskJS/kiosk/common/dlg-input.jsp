<%@ taglib uri="ksk-tags" prefix="ksk" %>
<div id="dlg-input" class="modal fade" tabindex="-1" data-controller="DlgInputController">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <label for="dlg-input-control" class="form-label"></label>
        <input type="text" class="form-control" id="dlg-input-control"/>
      </div>
      <div class="modal-footer">
        <button id="btn-yes" type="button" class="btn btn-primary"><ksk:itl key="@Common.Yes"/></button>
        <button id="btn-no" type="button" class="btn btn-danger close-btn" data-bs-dismiss="modal"><ksk:itl key="@Common.No"/></button> 
      </div>
    </div>
  </div>
</div>