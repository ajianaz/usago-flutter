class WalletEndpoints {
  // Wallet CRUD
  static const String wallets = '/api/wallets';
  static const String createWallet = '/api/wallets';
  static const String getWallet = '/api/wallets/{id}';
  static const String updateWallet = '/api/wallets/{id}';
  static const String deleteWallet = '/api/wallets/{id}';

  // Wallet Operations
  static const String getWalletBalance = '/api/wallets/{id}/balance';
  static const String getWalletTransactions = '/api/wallets/{id}/transactions';
  static const String transferFunds = '/api/wallets/transfer';
  static const String depositFunds = '/api/wallets/deposit';
  static const String withdrawFunds = '/api/wallets/withdraw';

  // Wallet Types
  static const String getOperationalWallets = '/api/wallets/operational';
  static const String getSavingsWallets = '/api/wallets/savings';
  static const String getProjectWallets = '/api/wallets/project';
  static const String getCommunityWallets = '/api/wallets/community';
  static const String getPersonalWallets = '/api/wallets/personal';
  static const String getCustomerWallets = '/api/wallets/customer';
  static const String getSupplierWallets = '/api/wallets/supplier';
  static const String getEscrowWallets = '/api/wallets/escrow';

  // Wallet Analytics
  static const String getWalletStats = '/api/wallets/{id}/stats';
  static const String getWalletReport = '/api/wallets/{id}/report';
}