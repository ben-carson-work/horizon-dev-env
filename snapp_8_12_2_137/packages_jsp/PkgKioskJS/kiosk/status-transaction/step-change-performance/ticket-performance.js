class TicketPerformanceController {
  constructor($container, ticket) {
    this.$container = $($container);
    this.ticket = ticket;
    
    this.performanceController = new PerformanceController($container, ticket.PerformanceList[0].EventId, null);
  }
  
  render($baseTemplate) {
    const $item = $baseTemplate.find(".ticket-performance").clone();
    $item.data("model", this.ticket);
    $item.find(".ticket-title").text(this.ticket.PerformanceDesc);
    $item.find(".ticket-subtitle").text(this.ticket.ProductName);
    
    this.$ui = $item;
    
    $item.click(() => _this._ticketClick)
        
    return $item;
  }
  
  _ticketClick() {
      this.performanceController.startPerformanceSearch(this._performanceClick, 1);    
    }
}