class StatementReceiptData {
  final String accountName;
  final String openingBalance;
  final String accountNumber;
  final String requestedPeriod;
  final String dateCreated;
  final List statementItem;
  final String closingBalance;

  StatementReceiptData(
      {this.accountName,
        this.openingBalance,
        this.accountNumber,
        this.requestedPeriod,
        this.dateCreated,
        this.statementItem,
        this.closingBalance});
}