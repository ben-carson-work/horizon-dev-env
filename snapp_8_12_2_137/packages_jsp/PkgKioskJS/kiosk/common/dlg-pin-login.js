class DlgPinLoginController extends DialogBase {
	constructor() {
		super("#dlg-pin-login");
		let el = this.$body.find("#mainPinLogin");
		this.el = {
			main: el,
			numPad: el.find(".pin-login__numpad"),
			textDisplay: el.find(".pin-login__text")
		};

		this.maxNumbers = Infinity;
		this.value = "";
		this.pin = "";

		this._generatePad();
	}

	_generatePad() {
		const padLayout = [
			"1", "2", "3",
			"4", "5", "6",
			"7", "8", "9",
			"backspace", "0", "check"
		];

		padLayout.forEach(key => {
			const insertBreak = key.search(/[369]/) !== -1;
			const keyEl = $('<div></div>');

			keyEl.addClass("pin-login__key");
			if (isNaN(key)) {
				let $icon = $('<i class="fa-solid"></i>');
				$icon.appendTo(keyEl);
				$icon.addClass("fa-" + key);				
			}
			else
				keyEl.text(key);
			keyEl.click(() => this._handleKeyPress(key));
			keyEl.appendTo(this.el.numPad);

			if (insertBreak) {
				$('<br/>').appendTo(this.el.numPad);
			}
		});
	}

	_handleKeyPress(key) {
		switch (key) {
			case "backspace":
				this.value = this.value.substring(0, this.value.length - 1);
				this._updateValueText();
				break;
			case "check":
				this._attemptLogin();
				break;
			default:
				if (this.value.length < this.maxNumbers && !isNaN(key)) {
					this.value += key;
					this._updateValueText();
				}
				break;
		}

	}

	_updateValueText() {
		this.el.textDisplay.val("_".repeat(this.value.length));
		this.el.textDisplay.removeClass("pin-login-text-error");
	}

	_attemptLogin() {
		if (this.value.length > 0) {
			let date = new Date();
			let dateStr = String(date.getDate()).padStart(2, '0'); 
			if (this.value === dateStr + this.pin) {
				this.value = "";
				this._updateValueText();
				KIOSK_CONTROLLER.enterMaintenanceMode();
				this.hide();
			}
			else
				this.el.textDisplay.addClass("pin-login-text-error");
		}
	}
	
	execute(params) {
    params = params || {};
		this.pin = params.pin;
		this.maxNumbers = String(this.pin).length + 2;
    
    return super.execute();
  }

}