const String kLoanRepaymentApiErrorMessage = 'Something went wrong';

class LoanRepaymentApiException implements Exception {
  LoanRepaymentApiException([this.userMessage = kLoanRepaymentApiErrorMessage]);

  final String userMessage;

  @override
  String toString() => userMessage;
}

String loanRepaymentApiUserMessage(Object error) {
  if (error is LoanRepaymentApiException) return error.userMessage;
  return kLoanRepaymentApiErrorMessage;
}
