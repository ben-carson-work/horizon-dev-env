const OPTION_CONFIG= {
	  PRINT: {icon: "fa-print", text: "Print"}, 
	  "GO-GREEN": {icon: "fa-leaf", text: "Go Green"}, 
	  "PRINT-AT-HOME": {icon: "fa-envelope", text: "Send email"}, 
	  "MOBILE-WALLET": {icon: "fa-wallet", text: "Add to Mobile Wallet"}
	};

class StepCheckoutController extends StepController {
  
  constructor() {
    super({"showShopcartDisplay":false});
    $("#step-checkout .kiosk-header-title").text("Finalizing order");
    $(document).on("kiosk-checkout", (event, data) => this._onKioskCheckout(data));
  }
  
  activate() {
    this.transactionController.startCheckout();
  }
  
  _onKioskCheckout(data) {
    let $message = null;
    let message = null;

    if (data.type == "payment") {
      if (data.payment.paymentStatus == "working") {
        $message = $("#checkout-message-payment-working");
        if (data.payment.remainingTime)
          $message.find("#remaining-time").text(data.payment.remainingTime);
        else
          $message.find("#remaining-time").text("");
      }
      else if (data.payment.paymentStatus == "failed") {
        $message = $("#checkout-message-payment-failed");
        message = data.payment.message;
        $("#btn-checkout-payment-failed-dismiss").click(() => {
          data.payment.dismiss();
        });
        $("#btn-checkout-payment-failed-retry").click(() => {
          data.payment.retry();
          this.transactionController.jumpToStep("PAYSEL");
        });
      }
      else if (data.payment.paymentStatus == "success") {
        $message = $("#checkout-message-payment-success");
      }
    }
    else if (data.type == "transaction") {
      let transaction = data.transaction;
      let transactionStatus = transaction.transactionStatus;
      let transactionRef = transaction.transactionRef;

      if (transactionStatus == "failed") {
        $message = $("#checkout-message-transaction-failed");
        message = transaction.message;
        // transactionRef.saleCode
      }
      else if (transactionStatus == "successful") {
        let $btnDone = this.$ui.find("#btn-checkout-end-transaction");
        $btnDone.on("click", () => KIOSK_CONTROLLER.startNewTransaction());
        $message = $("#checkout-message-transaction-success");
      }
      else if (transactionStatus == "working") {
        let progress = transaction.progress;
        if ((progress == "post-transaction") || (progress == "generating-media"))
          $message = $("#checkout-message-post-transaction");
        else if (progress == "print-ticket") {
          $message = $("#checkout-message-print-ticket");
          $message.find("#ticket-no").text(transaction.ticketPrint.currentTicketNo);
          $message.find("#ticket-count").text(transactionRef.ticketCount);
        }
        else if (progress == "print-receipt")
          $message = $("#checkout-message-print-receipt");
        else if (progress == "dispensing-change")
          $message = $("#checkout-message-change");
        else if (progress == "print-option") {
          $message = $("#checkout-message-print-selection");

          let $container = this.$ui.find("#print-option-list").empty();

          for (let option of transaction.deliveryOptions) {
            this.#addprintOption(transaction, $container, option);
          }
        }
        else if (progress == "virtual-print") {
          $message = $("#checkout-message-virtual-print");
          message = "Press DONE once ticket picture is captured";

          let $container = this.$ui.find("#virtual-ticket-list").empty();

          let $mobileWalletQr = this.$ui.find("#qr-mobile-wallet-add");
          if (transaction.addToWalletUrl) {
            message = "Scan to add ticket to your wallet";
            new QRCode($mobileWalletQr.get(0), transaction.addToWalletUrl);
          } else {
            transaction.virtualTicketList.forEach(printItem => {
              this.#addVirtualTicket($container, printItem);
            });
          }

          let $btnDone = this.$ui.find("#btn-print-done");
          $btnDone.click(() => {
            transaction.virtualPrintCallback();
            $mobileWalletQr.empty();
          });

          let $btnBack = this.$ui.find("#btn-print-back");
          $btnBack.click(() => {
            transaction.virtualGoBackCallback();
            $mobileWalletQr.empty();
          });

        }
        else if (progress == "print-at-home") {
          let params = {
            "title": KIOSK_UI_CONTROLLER.itl("@StepPrintsel.InputEmailTitle"),
            "message": KIOSK_UI_CONTROLLER.itl("@StepPrintsel.InputEmailCaption"),
            defaultValue: ""
          };

          KIOSK_UI_CONTROLLER.showInput(params)
            .then(value => transaction.emailInputCallback(value))
            .catch((error) => {
              console.log(error);
              transaction.goBackCallback();
            });
        }
      }
    }

    if ($message) {
      $(".checkout-message.active").removeClass("active");
      $message.addClass("active");

      if (message)
        $message.find("h2").text(message);
    }
  }
  
  #addVirtualTicket(container, printItem) {
    let $template = this.$ui.find("#checkout-templates .virtual-ticket");
    let $item = $template.clone().appendTo(container);
    $item.find(".kiosk-pane-item-title").text(printItem.PrintData.Ticket.ProductNameITL);
  }  
	
  #addprintOption(transaction, container, optionId) {
    let $template = this.$ui.find(`#checkout-templates .btn-print-option`);
    let $item = $template.clone().appendTo(container);
    $item.find(".kiosk-pane-item-title").text(OPTION_CONFIG[optionId].text);
    $item.find(".kiosk-pane-item-icon .fa").addClass(OPTION_CONFIG[optionId].icon);
    $item.click(() => transaction.deliveryOptionCallback(optionId));
  }
}