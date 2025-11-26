class SelectPrimaryAccountState {
  final List<DepositAccount> accounts;
  final bool isLoading;
  final bool isUpdating;
  final String? errorMessage;
  final DepositAccount? selectedAccount;

  const SelectPrimaryAccountState({
    this.accounts = const [],
    this.isLoading = false,
    this.isUpdating = false,
    this.errorMessage,
    this.selectedAccount,
  });

  SelectPrimaryAccountState copyWith({
    List<DepositAccount>? accounts,
    bool? isLoading,
    bool? isUpdating,
    String? errorMessage,
    DepositAccount? selectedAccount,
  }) {
    return SelectPrimaryAccountState(
      accounts: accounts ?? this.accounts,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedAccount: selectedAccount ?? this.selectedAccount,
    );
  }
}

class DepositAccount {
  final String accountType;
  final String accountName;
  final String accountNumber;
  final double balance;
  final bool isPrimary;
  final String currency;

  const DepositAccount({
    required this.accountType,
    required this.accountName,
    required this.accountNumber,
    required this.balance,
    required this.isPrimary,
    this.currency = 'LAK',
  });

  DepositAccount copyWith({
    String? accountType,
    String? accountName,
    String? accountNumber,
    double? balance,
    bool? isPrimary,
    String? currency,
  }) {
    return DepositAccount(
      accountType: accountType ?? this.accountType,
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      balance: balance ?? this.balance,
      isPrimary: isPrimary ?? this.isPrimary,
      currency: currency ?? this.currency,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DepositAccount && other.accountNumber == accountNumber;
  }

  @override
  int get hashCode => accountNumber.hashCode;
}
