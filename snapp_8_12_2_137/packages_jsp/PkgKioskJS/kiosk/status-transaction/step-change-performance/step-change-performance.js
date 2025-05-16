class StepChangePerformanceController extends StepController {

  static MULTIPLE_PERF_KEY = "multiplePerformances";
  static INVALID_TICKET_KEY = "multiplePerformances";
  
  #selectingPerformance = false;
  #requestChangeList = [];
  #performanceTicketMap = new Map();
  
  constructor() {
    super();
    
    $("#step-change-performance .kiosk-header-title").attr("data-itl", "@StepChangePerformance.Title");
    $("#step-change-performance .kiosk-header-subtitle").attr("data-itl", "@StepChangePerformance.Subtitle");
    
    $(document).on("kiosk-checkout", () => this._resetState());
    $(document).on("kiosk-status-change", (event, data) => {
      if (data.status == "IDLE")
        this._resetState();
      });
  }

  isStepNeeded() {
    return KIOSK_CONTROLLER.currentOrder != null;
  }

  activate() {
    super.activate();
    
    this.displayController.$ui.addClass("emptycart");
    
    this.#selectingPerformance = false;
    
    this.$performances = this.$ui.find(".event-body-performances").empty();
    this.$ticketList = this.$ui.find("#change-performance-item-list");
    
    if (!this.#performanceTicketMap?.size) {
      this.#requestChangeList = [];
      
      const ticketList = KIOSK_CONTROLLER.currentOrder.TicketList || [];
  
      const groupedTickets = this._groupTicketsByPerformance(ticketList); // Map<performanceId, ticket>
      this.#performanceTicketMap = groupedTickets;
      
      this._renderGroupedTickets(this.#performanceTicketMap);
    }
    
    
    this.updateDisplayButtons();
  }
  
  updateDisplayButtons() {
    super.updateDisplayButtons();
    
    if (this.#selectingPerformance) 
      this.displayController.$back.text(KIOSK_UI_CONTROLLER.itl("@StepChangePerformance.BackButtonCaption"));
    else
      this.displayController.$back.text(KIOSK_UI_CONTROLLER.itl("@Common.HomeCaption"));
    this.displayController.$next.text(KIOSK_UI_CONTROLLER.itl("@StepChangePerformance.NextButtonCaption"));
    
    this.displayController.$next.setClass("disabled", !this.#requestChangeList?.length);
  }

  backClick() {
    if (this.#selectingPerformance) {
      this._goToTicketView();
      this.updateDisplayButtons();
    }
    else {
      KIOSK_CONTROLLER.startNewTransaction();
      this._resetState();
      this.transactionController.activate();
    }
  }

  nextClick() {
    const $perfContainer = this.$ui.find("#change-performance-container").addClass("hidden");
    const $spinner = KIOSK_UI_CONTROLLER.showSpinner(this.$ui);
    KIOSK_CONTROLLER.apiShopCart("FillForChangePerformance", {ChangePerformanceList: this.#requestChangeList})
      .then(() => this.transactionController.jumpToStep("RECAP"))
      .finally(() => {
        $spinner.remove();
        $perfContainer.removeClass("hidden");
      });
    
  }
  
  _resetState() {
    this.#requestChangeList = [];
    this.#performanceTicketMap = new Map();
  }
  
  _goToTicketView() {
    this.#selectingPerformance = false;
    
    this.$ui.find("#change-performance-container").removeClass("hidden");
    
    this.$performances.empty();
    this.$ticketList.addClass("active");
  }
  
  _groupTicketsByPerformance(ticketList) {
    const mapGroupedByPerformanceId = ticketList.reduce((acc, ticket) => {
      if (ticket.PerformanceList.length > 1) {
        if (!acc.has(StepChangePerformanceController.MULTIPLE_PERF_KEY)) {
          acc.set(StepChangePerformanceController.MULTIPLE_PERF_KEY, []);
        }
        acc.get(StepChangePerformanceController.MULTIPLE_PERF_KEY).push(ticket);
      }
      else if (ticket.TicketStatus > 100) {
        if (!acc.has(StepChangePerformanceController.INVALID_TICKET_KEY)) {
          acc.set(StepChangePerformanceController.INVALID_TICKET_KEY, []);
        }
        acc.get(StepChangePerformanceController.INVALID_TICKET_KEY).push(ticket);
      }
      else {
        ticket.PerformanceList.forEach(performance => {
          const key = performance.Performance.PerformanceId;
          if (!acc.has(key)) {
            acc.set(key, []);
          }
          acc.get(key).push(ticket);
        });
      }

      return acc;
    }, new Map());

    return mapGroupedByPerformanceId;
  }
  
  _getPerformanceDesc(perf) {
    return perf ? perf.EventName + " - " + this._formatPerformanceDate(perf) : "";
  }
  
  _formatPerformanceDate(perf) {
    return perf ? formatDate(perf.DateTimeFrom) + " " + formatTime(perf.DateTimeFrom) : "";
  }
  
  _renderGroupedTickets(groupedTickets) {
    let $container = this.$ticketList.empty();
    this.$ticketList.addClass("active");

    for (const [perfId, ticketList] of groupedTickets.entries()) {
      if (perfId !== StepChangePerformanceController.MULTIPLE_PERF_KEY &&
        perfId !== StepChangePerformanceController.INVALID_TICKET_KEY)
        this._addPerformanceUI($container, ticketList[0].PerformanceList[0].Performance);
    }
  }

  _addPerformanceUI($container, perf) {
    const perfDate = this._formatPerformanceDate(perf);
    const $rootItem = $("#change-performance-templates .change-performance-item").clone();
    $rootItem.data("model", perf);
    $rootItem.attr("performanceId", perf.PerformanceId);
    $rootItem.find(".event-title").text(perf.EventName);
    $rootItem.find(".original-performance .change-performance-datetime").text(perfDate);
    
    $rootItem.find(".hint-msg").text(KIOSK_UI_CONTROLLER.itl("@StepChangePerformance.EmptyTargetCaption"));

    $rootItem.click(() => this._performanceClick(perf));

    $container.append($rootItem);
  }
  
  _performanceClick(perf) {
    this.#selectingPerformance = true;
    
    this.$ticketList.removeClass("active");
    const performanceController = new PerformanceController(this.$performances, this.$ui, perf.EventId, null);
    performanceController.startPerformanceSearch((newPerf) => this._newPerformanceClick(newPerf, perf), 1);
    
    this.updateDisplayButtons();
  }

  _newPerformanceClick(newPerf, oldPerf) {  
    this._goToTicketView();

    this._updateRequestChangeList(newPerf, oldPerf)
      .then(() => this._updateTargetPerformanceUI(newPerf, oldPerf))
      .finally(() => this.updateDisplayButtons());
  }
  
  _updateTargetPerformanceUI(newPerf, oldPerf) {
    const $item = this.$ui.find(`[performanceId='${oldPerf.PerformanceId}']`);
    
    $item.addClass("changed");
    
    $item.find(".hint-msg").text("Changed to:");
    
    $item.find(".change-performance-body").addClass("btn btn-success");
    
    const $targetPerfItem = $item.find(".target-performance");
    $targetPerfItem.find(".change-performance-datetime").text(this._formatPerformanceDate(newPerf));
  }

  async _updateRequestChangeList(newPerf, oldPerf) {
    const $perfContainer = this.$ui.find("#change-performance-container").addClass("hidden");
    const $spinner = KIOSK_UI_CONTROLLER.showSpinner(this.$ui);
    try {
      for (const ticket of this.#performanceTicketMap.get(oldPerf.PerformanceId) || []) {
        let product = newPerf.ProductList.find(p => p.ProductId === ticket.ProductId);

        if (!product)
          product = await this._findUpgradeableProduct(ticket, newPerf);

        if (product) {
          const changeReq = {
            OriginTicket: {
              TicketId: ticket.TicketId,
            },
            TargetProduct: {
              ProductId: product.ProductId,
            },
            TargetPerformance: {
              PerformanceId: newPerf.PerformanceId,
            }
          };

          // Add or edit change req
          this.#requestChangeList = [...this.#requestChangeList.filter(c => c.OriginTicket.TicketId !== ticket.TicketId), changeReq];
          
        }
      }
    }
    finally {
      $spinner.remove();
      $perfContainer.removeClass("hidden");
    };
  }
  
  async _findUpgradeableProduct(ticket, perf) {
    const product = (await snappAPI().cmd("PRODUCT", "LoadEntProduct", {ProductId: ticket.ProductId})).Product;
    
    let upgradeProd = product.QuickUpgradeProductList?.find(qu => perf.ProductList.some(p => p.ProductId === qu.ProductId));
    
    if (!upgradeProd)
      upgradeProd = perf.ProductList.find(p => p.AgeCategory === product.AgeCategory);
    
    return upgradeProd;
  }
  
  async _loadProduct(productId) {
    return await snappAPI().cmd("PRODUCT", "LoadEntProduct", {ProductId: productId});
  }
    
}