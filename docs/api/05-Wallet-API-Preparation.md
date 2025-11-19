# 💳 Wallet API Preparation Guide
## Infrastructure Setup for Indonesian SMEs

## 📋 Overview

Dokumentasi ini mempersiapkan **Wallet API infrastructure** untuk fase implementasi berikutnya, dengan fokus pada kebutuhan **Indonesian SMEs** dan integrasi dengan **Brand & Branch architecture** yang telah dibangun.

## 🎯 Wallet Types for Indonesian SMEs

### Primary Wallet Categories
```typescript
enum WalletType {
  OPERATIONAL = 'OPERATIONAL',    // Dana operasional harian
  SAVINGS = 'SAVINGS',           // Dana tabungan/jangka panjang
  PROJECT = 'PROJECT',            // Dana untuk project spesifik
  COMMUNITY = 'COMMUNITY',        // Dana komunitas/RT
  PERSONAL = 'PERSONAL',          // Dana pribadi owner
  CUSTOMER = 'CUSTOMER',          // Deposit/customer
  SUPPLIER = 'SUPPLIER',          // Pembayaran ke supplier
  ESCROW = 'ESCROW'               // Dana escrow/transaksi aman
}
```

### Use Cases per Wallet Type
| Wallet Type | Use Case | Typical Balance | Transaction Volume |
|-------------|-----------|------------------|-------------------|
| **OPERATIONAL** | Daily operations, utilities, rent | Rp 5-50jt | High (daily) |
| **SAVINGS** | Emergency fund, long-term savings | Rp 10-500jt | Low (monthly) |
| **PROJECT** | Specific business projects | Rp 20-200jt | Medium (project-based) |
| **COMMUNITY** | RT/RW activities, social funds | Rp 1-20jt | Low (periodic) |
| **PERSONAL** | Owner's personal expenses | Rp 5-100jt | Medium (personal) |
| **CUSTOMER** | Customer deposits, prepayments | Rp 10-1000jt | High (customer transactions) |
| **SUPPLIER** | Supplier payments, procurement | Rp 20-500jt | High (B2B transactions) |
| **ESCROW** | Safe transactions, guarantees | Rp 5-100jt | Medium (secure transactions) |

---

## 🔗 API Endpoints Structure

### 5.1 Wallet Management

#### Core Wallet Operations
```typescript
// GET /api/wallets - Get user's accessible wallets
interface GetWalletsRequest {
  brandId?: string;           // Filter by brand
  branchId?: string;          // Filter by branch
  type?: WalletType;          // Filter by type
  isActive?: boolean;          // Filter by status
  page?: number;              // Pagination
  limit?: number;             // Items per page
}

interface GetWalletsResponse {
  success: boolean;
  data: {
    wallets: WalletResponse[];
    pagination: {
      page: number;
      limit: number;
      total: number;
      totalPages: number;
    };
  };
}

// POST /api/wallets - Create new wallet
interface CreateWalletRequest {
  name: string;                    // Wallet name (1-100 chars)
  type: WalletType;                // Wallet type
  description?: string;             // Wallet description
  initialBalance: number;           // Starting balance (>= 0)
  currency: string;                // Default: IDR
  brandId: string;                 // Parent brand ID
  branchId: string;                // Parent branch ID
  settings?: Record<string, any>;   // Wallet-specific settings
  isActive: boolean;                // Wallet status
}

interface CreateWalletResponse {
  success: boolean;
  data: WalletResponse;
  message: string;
}

// GET /api/wallets/:id - Get wallet by ID
interface GetWalletResponse {
  success: boolean;
  data: WalletResponse;
}

// PUT /api/wallets/:id - Update wallet
interface UpdateWalletRequest {
  name?: string;
  description?: string;
  settings?: Record<string, any>;
  isActive?: boolean;
}

interface UpdateWalletResponse {
  success: boolean;
  data: WalletResponse;
  message: string;
}

// DELETE /api/wallets/:id - Delete wallet (soft delete)
interface DeleteWalletResponse {
  success: boolean;
  message: string;
}
```

#### Wallet Balance Operations
```typescript
// GET /api/wallets/:id/balance - Get wallet balance
interface GetWalletBalanceResponse {
  success: boolean;
  data: {
    walletId: string;
    balance: number;
    availableBalance: number;        // Balance minus pending transactions
    lastUpdated: string;
    currency: string;
  };
}

// GET /api/wallets/:id/transactions - Get wallet transactions
interface GetWalletTransactionsRequest {
  walletId: string;
  type?: TransactionType;           // INFLOW or OUTFLOW
  category?: TransactionCategory;
  status?: TransactionStatus;
  startDate?: string;              // ISO date
  endDate?: string;                // ISO date
  page?: number;
  limit?: number;
}

interface GetWalletTransactionsResponse {
  success: boolean;
  data: {
    transactions: TransactionResponse[];
    pagination: {
      page: number;
      limit: number;
      total: number;
      totalPages: number;
    };
  };
}
```

### 5.2 Transaction Management

#### Transaction Operations
```typescript
// POST /api/wallets/:id/transactions - Create transaction
interface CreateTransactionRequest {
  walletId: string;                // Target wallet ID
  type: TransactionType;            // Transaction type
  category: TransactionCategory;     // Transaction category
  amount: number;                   // Positive amount
  description?: string;             // Transaction description
  reference?: string;               // Invoice number, booking ID, etc.
  receiptUrl?: string;              // Receipt image URL
  metadata?: Record<string, any>;   // Additional metadata
  brandId: string;                  // Transaction brand
  branchId: string;                 // Transaction branch
  userId: string;                   // Transaction user
}

interface CreateTransactionResponse {
  success: boolean;
  data: TransactionResponse;
  message: string;
}

// PUT /api/transactions/:id - Update transaction
interface UpdateTransactionRequest {
  description?: string;
  reference?: string;
  receiptUrl?: string;
  metadata?: Record<string, any>;
  status?: TransactionStatus;
}

interface UpdateTransactionResponse {
  success: boolean;
  data: TransactionResponse;
  message: string;
}

// GET /api/transactions/:id - Get transaction by ID
interface GetTransactionResponse {
  success: boolean;
  data: TransactionResponse;
}
```

#### Wallet Transfer Operations
```typescript
// POST /api/wallets/transfer - Transfer between wallets
interface CreateWalletTransferRequest {
  fromWalletId: string;             // Source wallet ID
  toWalletId: string;               // Target wallet ID
  amount: number;                   // Transfer amount
  description?: string;             // Transfer description
  reference?: string;               // Transfer reference
  metadata?: Record<string, any>;   // Additional metadata
  brandId: string;                  // Transfer brand
  branchId: string;                 // Transfer branch
  userId: string;                   // Transfer user
}

interface CreateWalletTransferResponse {
  success: boolean;
  data: WalletTransferResponse;
  message: string;
}

// GET /api/wallets/transfers - Get wallet transfers
interface GetWalletTransfersRequest {
  fromWalletId?: string;
  toWalletId?: string;
  startDate?: string;
  endDate?: string;
  status?: TransactionStatus;
  page?: number;
  limit?: number;
}

interface GetWalletTransfersResponse {
  success: boolean;
  data: {
    transfers: WalletTransferResponse[];
    pagination: {
      page: number;
      limit: number;
      total: number;
      totalPages: number;
    };
  };
}
```

### 5.3 Wallet Analytics & Statistics

#### Wallet Statistics
```typescript
// GET /api/wallets/:id/stats - Get wallet statistics
interface GetWalletStatsRequest {
  walletId: string;
  period?: 'day' | 'week' | 'month' | 'quarter' | 'year';
  startDate?: string;
  endDate?: string;
}

interface GetWalletStatsResponse {
  success: boolean;
  data: {
    walletId: string;
    totalInflow: number;
    totalOutflow: number;
    netFlow: number;
    transactionCount: number;
    averageTransaction: number;
    periodStart: string;
    periodEnd: string;
    breakdown: {
      byCategory: Record<TransactionCategory, {
        count: number;
        amount: number;
        percentage: number;
      }>;
      byType: Record<TransactionType, {
        count: number;
        amount: number;
        percentage: number;
      }>;
    };
  };
}

// GET /api/wallets/analytics - Get multi-wallet analytics
interface GetWalletAnalyticsRequest {
  brandId?: string;
  branchId?: string;
  walletIds?: string[];
  period?: 'day' | 'week' | 'month' | 'quarter' | 'year';
  startDate?: string;
  endDate?: string;
  groupBy?: 'wallet' | 'category' | 'type' | 'date';
}

interface GetWalletAnalyticsResponse {
  success: boolean;
  data: {
    summary: {
      totalBalance: number;
      totalInflow: number;
      totalOutflow: number;
      netFlow: number;
      transactionCount: number;
    };
    breakdown: Array<{
      group: string;
      value: number;
      percentage: number;
    }>;
    trends: Array<{
      date: string;
      inflow: number;
      outflow: number;
      netFlow: number;
    }>;
  };
}
```

---

## 📱 Mobile Implementation Preparation

### 6.1 Wallet Data Models

#### Wallet Entity
```dart
// lib/features/wallet/domain/entities/wallet.dart
import 'package:equatable/equatable.dart';

enum WalletType {
  operational,
  savings,
  project,
  community,
  personal,
  customer,
  supplier,
  escrow,
}

class Wallet extends Equatable {
  final String id;
  final String name;
  final WalletType type;
  final String? description;
  final double balance;
  final double availableBalance;
  final String currency;
  final String brandId;
  final String branchId;
  final Map<String, dynamic> settings;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Wallet({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    required this.balance,
    required this.availableBalance,
    required this.currency,
    required this.brandId,
    required this.branchId,
    required this.settings,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        description,
        balance,
        availableBalance,
        currency,
        brandId,
        branchId,
        settings,
        isActive,
        createdAt,
        updatedAt,
      ];

  String get typeDisplayName {
    switch (type) {
      case WalletType.operational:
        return 'Dana Operasional';
      case WalletType.savings:
        return 'Dana Tabungan';
      case WalletType.project:
        return 'Dana Proyek';
      case WalletType.community:
        return 'Dana Komunitas';
      case WalletType.personal:
        return 'Dana Pribadi';
      case WalletType.customer:
        return 'Dana Customer';
      case WalletType.supplier:
        return 'Dana Supplier';
      case WalletType.escrow:
        return 'Dana Escrow';
    }
  }

  String get formattedBalance {
    return 'Rp ${balance.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  Wallet copyWith({
    String? id,
    String? name,
    WalletType? type,
    String? description,
    double? balance,
    double? availableBalance,
    String? currency,
    String? brandId,
    String? branchId,
    Map<String, dynamic>? settings,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Wallet(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      balance: balance ?? this.balance,
      availableBalance: availableBalance ?? this.availableBalance,
      currency: currency ?? this.currency,
      brandId: brandId ?? this.brandId,
      branchId: branchId ?? this.branchId,
      settings: settings ?? this.settings,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
```

#### Transaction Entity
```dart
// lib/features/wallet/domain/entities/transaction.dart
import 'package:equatable/equatable.dart';

enum TransactionType {
  inflow,
  outflow,
}

enum TransactionCategory {
  // Inflow Categories
  sales,
  loan,
  investment,
  gift,
  refund,
  otherIn,

  // Outflow Categories
  operational,
  salary,
  supplierPayment,
  investmentOut,
  tax,
  expense,
  otherOut,
}

enum TransactionStatus {
  pending,
  completed,
  failed,
  cancelled,
}

class Transaction extends Equatable {
  final String id;
  final String walletId;
  final TransactionType type;
  final TransactionCategory category;
  final double amount;
  final String? description;
  final String? reference;
  final String? receiptUrl;
  final TransactionStatus status;
  final Map<String, dynamic> metadata;
  final String brandId;
  final String branchId;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Transaction({
    required this.id,
    required this.walletId,
    required this.type,
    required this.category,
    required this.amount,
    this.description,
    this.reference,
    this.receiptUrl,
    required this.status,
    required this.metadata,
    required this.brandId,
    required this.branchId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        walletId,
        type,
        category,
        amount,
        description,
        reference,
        receiptUrl,
        status,
        metadata,
        brandId,
        branchId,
        userId,
        createdAt,
        updatedAt,
      ];

  String get formattedAmount {
    final prefix = type == TransactionType.inflow ? '+' : '-';
    return '$prefix Rp ${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  String get categoryDisplayName {
    switch (category) {
      case TransactionCategory.sales:
        return 'Penjualan';
      case TransactionCategory.loan:
        return 'Pinjaman';
      case TransactionCategory.investment:
        return 'Investasi';
      case TransactionCategory.gift:
        return 'Hadiah';
      case TransactionCategory.refund:
        return 'Pengembalian';
      case TransactionCategory.otherIn:
        return 'Lainnya (Masuk)';
      case TransactionCategory.operational:
        return 'Operasional';
      case TransactionCategory.salary:
        return 'Gaji';
      case TransactionCategory.supplierPayment:
        return 'Pembayaran Supplier';
      case TransactionCategory.investmentOut:
        return 'Investasi (Keluar)';
      case TransactionCategory.tax:
        return 'Pajak';
      case TransactionCategory.expense:
        return 'Pengeluaran';
      case TransactionCategory.otherOut:
        return 'Lainnya (Keluar)';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case TransactionStatus.pending:
        return 'Menunggu';
      case TransactionStatus.completed:
        return 'Selesai';
      case TransactionStatus.failed:
        return 'Gagal';
      case TransactionStatus.cancelled:
        return 'Dibatalkan';
    }
  }
}
```

### 6.2 Wallet Repository Interface

#### Wallet Repository
```dart
// lib/features/wallet/domain/repositories/wallet_repository.dart
import '../entities/wallet.dart';
import '../entities/transaction.dart';
import '../entities/wallet_transfer.dart';
import '../entities/wallet_stats.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/either.dart';

abstract class WalletRepository {
  // Wallet Management
  Future<Either<Failure, List<Wallet>>> getWallets({
    String? brandId,
    String? branchId,
    WalletType? type,
    bool? isActive,
    int? page,
    int? limit,
  });

  Future<Either<Failure, Wallet>> getWalletById(String id);
  Future<Either<Failure, Wallet>> createWallet(Map<String, dynamic> walletData);
  Future<Either<Failure, Wallet>> updateWallet(String id, Map<String, dynamic> walletData);
  Future<Either<Failure, void>> deleteWallet(String id);

  // Balance Operations
  Future<Either<Failure, double>> getWalletBalance(String walletId);
  Future<Either<Failure, List<Transaction>>> getWalletTransactions(
    String walletId, {
    TransactionType? type,
    TransactionCategory? category,
    TransactionStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    int? page,
    int? limit,
  });

  // Transaction Management
  Future<Either<Failure, Transaction>> createTransaction(Map<String, dynamic> transactionData);
  Future<Either<Failure, Transaction>> updateTransaction(String id, Map<String, dynamic> transactionData);
  Future<Either<Failure, Transaction>> getTransactionById(String id);

  // Wallet Transfer
  Future<Either<Failure, WalletTransfer>> createWalletTransfer(Map<String, dynamic> transferData);
  Future<Either<Failure, List<WalletTransfer>>> getWalletTransfers({
    String? fromWalletId,
    String? toWalletId,
    DateTime? startDate,
    DateTime? endDate,
    TransactionStatus? status,
    int? page,
    int? limit,
  });

  // Analytics & Statistics
  Future<Either<Failure, WalletStats>> getWalletStats(
    String walletId, {
    String? period,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Either<Failure, Map<String, dynamic>>> getWalletAnalytics({
    String? brandId,
    String? branchId,
    List<String>? walletIds,
    String? period,
    DateTime? startDate,
    DateTime? endDate,
    String? groupBy,
  });
}
```

### 6.3 Wallet BLoC Structure

#### Wallet Events
```dart
// lib/features/wallet/presentation/bloc/wallet_event.dart
part of 'wallet_bloc.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object> get props => [];
}

class LoadWalletsEvent extends WalletEvent {
  final String? brandId;
  final String? branchId;
  final WalletType? type;
  final bool? isActive;

  const LoadWalletsEvent({
    this.brandId,
    this.branchId,
    this.type,
    this.isActive,
  });

  @override
  List<Object> get props => [brandId, branchId, type, isActive];
}

class CreateWalletEvent extends WalletEvent {
  final Map<String, dynamic> walletData;

  const CreateWalletEvent(this.walletData);

  @override
  List<Object> get props => [walletData];
}

class CreateTransactionEvent extends WalletEvent {
  final String walletId;
  final Map<String, dynamic> transactionData;

  const CreateTransactionEvent(this.walletId, this.transactionData);

  @override
  List<Object> get props => [walletId, transactionData];
}

class LoadWalletTransactionsEvent extends WalletEvent {
  final String walletId;
  final TransactionType? type;
  final TransactionCategory? category;
  final TransactionStatus? status;
  final DateTime? startDate;
  final DateTime? endDate;

  const LoadWalletTransactionsEvent(
    this.walletId, {
    this.type,
    this.category,
    this.status,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object> get props => [
        walletId,
        type,
        category,
        status,
        startDate,
        endDate,
      ];
}

class CreateWalletTransferEvent extends WalletEvent {
  final Map<String, dynamic> transferData;

  const CreateWalletTransferEvent(this.transferData);

  @override
  List<Object> get props => [transferData];
}

class LoadWalletStatsEvent extends WalletEvent {
  final String walletId;
  final String? period;
  final DateTime? startDate;
  final DateTime? endDate;

  const LoadWalletStatsEvent(
    this.walletId, {
    this.period,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object> get props => [walletId, period, startDate, endDate];
}
```

#### Wallet States
```dart
// lib/features/wallet/presentation/bloc/wallet_state.dart
part of 'wallet_bloc.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final List<Wallet> wallets;
  final Wallet? activeWallet;
  final List<Transaction>? transactions;
  final WalletStats? stats;
  final Map<String, dynamic>? analytics;

  const WalletLoaded({
    required this.wallets,
    this.activeWallet,
    this.transactions,
    this.stats,
    this.analytics,
  });

  @override
  List<Object> get props => [
        wallets,
        activeWallet,
        transactions,
        stats,
        analytics,
      ];
}

class WalletOperationSuccess extends WalletState {
  final String message;

  const WalletOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class WalletError extends WalletState {
  final String message;

  const WalletError(this.message);

  @override
  List<Object> get props => [message];
}
```

### 6.4 Wallet UI Components

#### Wallet Card Widget
```dart
// lib/features/wallet/presentation/widgets/wallet_card.dart
import 'package:flutter/material.dart';
import '../../domain/entities/wallet.dart';

class WalletCard extends StatelessWidget {
  final Wallet wallet;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const WalletCard({
    Key? key,
    required this.wallet,
    required this.isActive,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isActive ? 4 : 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isActive
            ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wallet.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          wallet.typeDisplayName,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      if (onEdit != null)
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: const [
                              Icon(Icons.edit),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                          onTap: onEdit,
                        ),
                      if (onDelete != null)
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: const [
                              Icon(Icons.delete),
                              SizedBox(width: 8),
                              Text('Hapus'),
                            ],
                          ),
                          onTap: onDelete,
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Balance
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saldo',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          wallet.formattedBalance,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Tersedia',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        'Rp ${wallet.availableBalance.toStringAsFixed(0).replaceAllMapped(
                              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                              (Match m) => '${m[1]}.',
                            )}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: wallet.availableBalance >= 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Description
              if (wallet.description != null) ...[
                const SizedBox(height: 12),
                Text(
                  wallet.description!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              // Status Badge
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: wallet.isActive
                          ? Colors.green.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      wallet.isActive ? 'Aktif' : 'Tidak Aktif',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: wallet.isActive ? Colors.green : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    wallet.currency,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

#### Create Wallet Form
```dart
// lib/features/wallet/presentation/widgets/create_wallet_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/wallet_bloc.dart';
import '../../domain/entities/wallet.dart';

class CreateWalletForm extends StatefulWidget {
  final String brandId;
  final String branchId;

  const CreateWalletForm({
    Key? key,
    required this.brandId,
    required this.branchId,
  }) : super(key: key);

  @override
  State<CreateWalletForm> createState() => _CreateWalletFormState();
}

class _CreateWalletFormState extends State<CreateWalletForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _initialBalanceController = TextEditingController(text: '0');

  WalletType _walletType = WalletType.operational;
  String _currency = 'IDR';
  bool _isLoading = false;

  final List<WalletType> _walletTypes = [
    WalletType.operational,
    WalletType.savings,
    WalletType.project,
    WalletType.community,
    WalletType.personal,
    WalletType.customer,
    WalletType.supplier,
    WalletType.escrow,
  ];

  final List<String> _currencies = [
    'IDR',
    'USD',
    'EUR',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _initialBalanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Wallet Baru'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state is WalletLoading) {
            setState(() {
              _isLoading = true;
            });
          } else {
            setState(() {
              _isLoading = false;
            });
          }

          if (state is WalletOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          }

          if (state is WalletError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Wallet Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Wallet',
                    hintText: 'Masukkan nama wallet',
                    prefixIcon: Icon(Icons.account_balance_wallet),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama wallet wajib diisi';
                    }
                    if (value.length > 100) {
                      return 'Nama wallet maksimal 100 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Wallet Type
                DropdownButtonFormField<WalletType>(
                  value: _walletType,
                  decoration: const InputDecoration(
                    labelText: 'Tipe Wallet',
                    prefixIcon: Icon(Icons.category),
                    border: OutlineInputBorder(),
                  ),
                  items: _walletTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(Wallet(
                        id: '',
                        name: '',
                        type: type,
                        balance: 0,
                        availableBalance: 0,
                        currency: '',
                        brandId: '',
                        branchId: '',
                        settings: {},
                        isActive: true,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      ).typeDisplayName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _walletType = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    hintText: 'Deskripsikan wallet ini',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Initial Balance
                TextFormField(
                  controller: _initialBalanceController,
                  decoration: const InputDecoration(
                    labelText: 'Saldo Awal',
                    hintText: '0',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Saldo awal wajib diisi';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount < 0) {
                      return 'Saldo awal harus berupa angka positif';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Currency
                DropdownButtonFormField<String>(
                  value: _currency,
                  decoration: const InputDecoration(
                    labelText: 'Mata Uang',
                    prefixIcon: Icon(Icons.currency_exchange),
                    border: OutlineInputBorder(),
                  ),
                  items: _currencies.map((currency) {
                    return DropdownMenuItem(
                      value: currency,
                      child: Text(currency),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _currency = value!;
                    });
                  },
                ),
                const SizedBox(height: 32),

                // Submit Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Buat Wallet',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final walletData = {
        'name': _nameController.text.trim(),
        'type': _walletType.name.toUpperCase(),
        'description': _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        'initialBalance': double.parse(_initialBalanceController.text),
        'currency': _currency,
        'brandId': widget.brandId,
        'branchId': widget.branchId,
        'isActive': true,
      };

      context.read<WalletBloc>().add(CreateWalletEvent(walletData));
    }
  }
}
```

---

## 🧪 Testing Strategy

### 7.1 Unit Testing

#### Wallet Repository Tests
```dart
// test/unit/wallet/data/repositories/wallet_repository_impl_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import '../../../../../../lib/features/wallet/data/repositories/wallet_repository_impl.dart';
import '../../../../../../lib/features/wallet/data/datasources/wallet_remote_datasource.dart';
import '../../../../../../lib/features/wallet/data/datasources/wallet_local_datasource.dart';
import '../../../../../../lib/features/wallet/domain/entities/wallet.dart';

import 'wallet_repository_impl_test.mocks.dart';

@GenerateMocks([WalletRemoteDataSource, WalletLocalDataSource])
void main() {
  group('WalletRepositoryImpl', () {
    late WalletRepositoryImpl repository;
    late MockWalletRemoteDataSource mockRemoteDataSource;
    late MockWalletLocalDataSource mockLocalDataSource;

    setUp(() {
      mockRemoteDataSource = MockWalletRemoteDataSource();
      mockLocalDataSource = MockWalletLocalDataSource();
      repository = WalletRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
      );
    });

    group('getWallets', () {
      test('should return list of wallets when remote call succeeds', () async {
        // Arrange
        final wallets = [
          Wallet(
            id: '1',
            name: 'Operational Wallet',
            type: WalletType.operational,
            balance: 1000000,
            availableBalance: 950000,
            currency: 'IDR',
            brandId: 'brand1',
            branchId: 'branch1',
            settings: {},
            isActive: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ];

        when(mockRemoteDataSource.getWallets(any))
            .thenAnswer((_) async => wallets);
        when(mockLocalDataSource.cacheWallets(any))
            .thenAnswer((_) async {});

        // Act
        final result = await repository.getWallets();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected Right but got Left'),
          (walletsResult) => expect(walletsResult, wallets),
        );
        verify(mockRemoteDataSource.getWallets(any)).called(1);
        verify(mockLocalDataSource.cacheWallets(wallets)).called(1);
      });
    });
  });
}
```

### 7.2 Integration Testing

#### Wallet Flow Integration Test
```dart
// test/integration/wallet_flow_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../lib/features/wallet/presentation/pages/wallet_selection_page.dart';
import '../../../lib/features/wallet/presentation/bloc/wallet_bloc.dart';
import '../../../lib/features/wallet/domain/entities/wallet.dart';

void main() {
  group('Wallet Flow Integration Tests', () {
    late WalletBloc mockWalletBloc;

    setUp(() {
      mockWalletBloc = MockWalletBloc();
    });

    testWidgets('should display wallet list when wallets are loaded', (tester) async {
      // Arrange
      final wallets = [
        Wallet(
          id: '1',
          name: 'Operational Wallet',
          type: WalletType.operational,
          balance: 1000000,
          availableBalance: 950000,
          currency: 'IDR',
          brandId: 'brand1',
          branchId: 'branch1',
          settings: {},
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      whenListen(mockWalletBloc, Stream.fromIterable([
        WalletLoaded(wallets: wallets),
      ]));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<WalletBloc>.value(
            value: mockWalletBloc,
            child: const WalletSelectionPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Pilih Wallet'), findsOneWidget);
      expect(find.text('Operational Wallet'), findsOneWidget);
      expect(find.byType(WalletCard), findsOneWidget);
    });
  });
}
```

---

## 📋 Implementation Checklist

### Phase 1: Infrastructure Setup ✅
- [ ] **Wallet Data Models**
  - [ ] Wallet entity dengan type support
  - [ ] Transaction entity dengan categories
  - [ ] Wallet transfer entity
  - [ ] Wallet stats entity
  - [ ] JSON serialization setup

- [ ] **Wallet Repository**
  - [ ] Remote data source implementation
  - [ ] Local data source implementation
  - [ ] Repository implementation
  - [ ] Error handling

- [ ] **Wallet BLoC**
  - [ ] Events definition
  - [ ] States definition
  - [ ] BLoC implementation
  - [ ] State management

### Phase 2: UI Components ✅
- [ ] **Wallet Selection**
  - [ ] Wallet selection page
  - [ ] Wallet card widget
  - [ ] Wallet type selector
  - [ ] Balance display

- [ ] **Wallet Creation**
  - [ ] Create wallet form
  - [ ] Wallet type selection
  - [ ] Initial balance input
  - [ ] Validation

- [ ] **Transaction Management**
  - [ ] Transaction list page
  - [ ] Transaction card widget
  - [ ] Create transaction form
  - [ ] Receipt upload

### Phase 3: Advanced Features 🔄
- [ ] **Wallet Transfer**
  - [ ] Transfer form
  - [ ] Wallet selection
  - [ ] Amount validation
  - [ ] Confirmation dialog

- [ ] **Analytics & Statistics**
  - [ ] Wallet stats display
  - [ ] Transaction analytics
  - [ ] Charts and graphs
  - [ ] Export functionality

### Phase 4: Testing & Integration 🔄
- [ ] **Unit Tests**
  - [ ] Wallet repository tests
  - [ ] BLoC tests
  - [ ] Entity tests
  - [ ] Utility tests

- [ ] **Integration Tests**
  - [ ] End-to-end flow tests
  - [ ] API integration tests
  - [ ] UI integration tests

- [ ] **Performance Tests**
  - [ ] Loading time tests
  - [ ] Memory usage tests
  - [ ] Battery usage tests

---

## 🎯 Success Metrics

### Phase 1: Infrastructure
- **Data Model Setup**: < 1 day
- **Repository Implementation**: < 2 days
- **BLoC Implementation**: < 2 days
- **Basic Testing**: < 1 day

### Phase 2: UI Components
- **Wallet Selection**: < 2 days
- **Wallet Creation**: < 2 days
- **Transaction Management**: < 3 days
- **Basic Integration**: < 1 day

### Phase 3: Advanced Features
- **Wallet Transfer**: < 2 days
- **Analytics**: < 3 days
- **Export Features**: < 2 days
- **Advanced Integration**: < 1 day

### Performance Targets
- **Wallet Loading**: < 2 seconds for 100 wallets
- **Transaction Loading**: < 3 seconds for 1000 transactions
- **Transfer Processing**: < 5 seconds
- **UI Performance**: 60 FPS on mid-range devices

---

## 🔗 References

### Documentation
- [Brand & Branch Focused Implementation](./03-Brand-Branch-Focused-Implementation.md)
- [Brand & Branch Implementation Guide](./04-Brand-Branch-Implementation-Guide.md)
- [API Endpoints Structure](./01-API-Endpoints-Structure.md)

### Server Documentation
- [Wallet Schema](../../../apps/server/src/features/wallet/wallet.schema.ts)
- [Wallet Routes](../../../apps/server/src/features/wallet/wallet.routes.ts)
- [Wallet Controller](../../../apps/server/src/features/wallet/wallet.controller.ts)

### Flutter Documentation
- [BLoC Pattern](https://bloclibrary.dev/)
- [State Management](https://pub.dev/packages/flutter_bloc)
- [JSON Serialization](https://pub.dev/packages/json_annotation)

---

## 🔄 Next Steps

1. **Implement Phase 1**: Complete wallet infrastructure setup
2. **Implement Phase 2**: Build wallet UI components
3. **Implement Phase 3**: Add advanced features
4. **Integration Testing**: End-to-end flow validation
5. **Performance Optimization**: Based on testing results
6. **User Testing**: Real-world feedback collection
7. **Documentation Update**: Based on implementation learnings

---

*Dokumentasi ini akan terus diupdate seiring dengan perkembangan implementasi Wallet features di aplikasi mobile Usago.*