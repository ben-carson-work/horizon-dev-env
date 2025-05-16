class StepLangController extends StepController {
  
  constructor() {
    super({"showShopcartDisplay":false});
    
    $("#step-lang .kiosk-header-title").attr("data-itl", "@StepLang.Title");
    $("#step-lang .kiosk-header-subtitle").attr("data-itl", "@StepLang.Subtitle");
  }
  
  isStepNeeded() {
    let langList = KIOSK_UI_CONTROLLER.kiosk.LangList || [];
    if (langList.length == 1)
      KIOSK_UI_CONTROLLER.setLangISO(langList[0].LangISO);
      
    return (langList.length > 1);    
  }
  
  activate() {
    super.activate();

    let $container = this.$ui.find("#lang-list").empty();
    let $template = this.$ui.find("#lang-templates .btn-lang");
    let langList = KIOSK_UI_CONTROLLER.kiosk.LangList || [];
    
    for (const lang of langList) {
      let $lang = $template.clone().appendTo($container);
      $lang.find(".kiosk-pane-item-title").text(lang.LangName);
      $lang.find(".kiosk-pane-item-icon img").attr("src", getIconURL(lang.IconName, 64));
      $lang.click(() => this._onLangClick(lang.LangISO));
    }
  }

  _onLangClick(langISO) {
    KIOSK_UI_CONTROLLER.setLangISO(langISO);
    this.nextClick();
  }

}