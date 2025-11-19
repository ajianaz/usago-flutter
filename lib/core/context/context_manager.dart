import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_constants.dart';
import '../utils/logger.dart';

/// User role enum
enum UserRole {
  BRAND_OWNER('BRAND_OWNER'),
  BRANCH_MANAGER('BRANCH_MANAGER'),
  BRANCH_ADMIN('BRANCH_ADMIN'),
  BRANCH_STAFF('BRANCH_STAFF'),
  CROSS_BRANCH_VIEWER('CROSS_BRANCH_VIEWER');

  const UserRole(this.name);
  final String name;
}

/// User entity
class User {
  final String id;
  final String email;
  final String name;
  final UserRole role;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });
}

/// Brand entity
class Brand {
  final String id;
  final String name;
  final String description;

  Brand({
    required this.id,
    required this.name,
    required this.description,
  });
}

/// Branch entity
class Branch {
  final String id;
  final String name;
  final String address;
  final String brandId;

  Branch({
    required this.id,
    required this.name,
    required this.address,
    required this.brandId,
  });
}

/// UserContext model
class UserContext {
  final User user;
  final Brand? activeBrand;
  final Branch? activeBranch;
  final List<Brand> accessibleBrands;
  final List<Branch> accessibleBranches;
  final UserRole role;
  final Map<String, dynamic> permissions;
  final DateTime lastUpdated;

  UserContext({
    required this.user,
    this.activeBrand,
    this.activeBranch,
    required this.accessibleBrands,
    required this.accessibleBranches,
    required this.role,
    required this.permissions,
    required this.lastUpdated,
  });

  UserContext copyWith({
    User? user,
    Brand? activeBrand,
    Branch? activeBranch,
    List<Brand>? accessibleBrands,
    List<Branch>? accessibleBranches,
    UserRole? role,
    Map<String, dynamic>? permissions,
    DateTime? lastUpdated,
  }) {
    return UserContext(
      user: user ?? this.user,
      activeBrand: activeBrand ?? this.activeBrand,
      activeBranch: activeBranch ?? this.activeBranch,
      accessibleBrands: accessibleBrands ?? this.accessibleBrands,
      accessibleBranches: accessibleBranches ?? this.accessibleBranches,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
      lastUpdated: lastUpdated ?? DateTime.now(),
    );
  }
}

/// Context Manager Implementation
class ContextManager {
  static final ContextManager _instance = ContextManager._internal();
  factory ContextManager() => _instance;
  ContextManager._internal();

  UserContext? _context;
  final StreamController<UserContext> _contextController = StreamController<UserContext>.broadcast();
  final AppLogger _logger = AppLogger();

  Stream<UserContext> get contextStream => _contextController.stream;
  UserContext? get currentContext => _context;

  Future<void> initializeContext() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get user data from local storage (simplified for now)
      final userId = prefs.getString(StorageConstants.userIdKey);
      final userEmail = prefs.getString(StorageConstants.userEmailKey);
      final userName = prefs.getString(StorageConstants.userNameKey);
      final userRoleName = prefs.getString(StorageConstants.userRoleKey) ?? 'BRANCH_STAFF';

      if (userId == null || userEmail == null || userName == null) {
        _logger.warning('No user data found in local storage');
        return;
      }

      final userRole = UserRole.values.firstWhere(
        (role) => role.name == userRoleName,
        orElse: () => UserRole.BRANCH_STAFF,
      );

      final user = User(
        id: userId,
        email: userEmail,
        name: userName,
        role: userRole,
      );

      // For now, we'll use empty lists and null values
      // In a real implementation, these would be fetched from API
      final brands = <Brand>[];
      final branches = <Branch>[];
      final permissions = <String, dynamic>{};

      _context = UserContext(
        user: user,
        accessibleBrands: brands,
        accessibleBranches: branches,
        role: userRole,
        permissions: permissions,
        lastUpdated: DateTime.now(),
      );

      _contextController.add(_context!);
      _logger.info('Context initialized for user: ${user.email}');
    } catch (e) {
      _logger.error('Failed to initialize context', e);
    }
  }

  Future<void> switchBrand(Brand brand) async {
    if (_context == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(StorageConstants.activeBrandIdKey, brand.id);

      final branches = <Branch>[]; // In real implementation, fetch from API
      final updatedContext = _context!.copyWith(
        activeBrand: brand,
        activeBranch: null,
        accessibleBranches: branches,
      );

      _context = updatedContext;
      _contextController.add(_context!);
      _logger.info('Switched to brand: ${brand.name}');
    } catch (e) {
      _logger.error('Failed to switch brand', e);
    }
  }

  Future<void> switchBranch(Branch branch) async {
    if (_context == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(StorageConstants.activeBranchIdKey, branch.id);

      final permissions = <String, dynamic>{}; // In real implementation, fetch from API
      final updatedContext = _context!.copyWith(
        activeBranch: branch,
        permissions: permissions,
      );

      _context = updatedContext;
      _contextController.add(_context!);
      _logger.info('Switched to branch: ${branch.name}');
    } catch (e) {
      _logger.error('Failed to switch branch', e);
    }
  }

  Future<void> refreshContext() async {
    await initializeContext();
  }

  void dispose() {
    _contextController.close();
  }
}