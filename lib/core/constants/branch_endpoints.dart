class BranchEndpoints {
  // Branch CRUD
  static const String branches = '/api/branches';
  static const String createBranch = '/api/branches';
  static const String getBranch = '/api/branches/{id}';
  static const String updateBranch = '/api/branches/{id}';
  static const String deleteBranch = '/api/branches/{id}';
  static const String getBranchBySlug = '/api/branches/slug/{slug}';

  // User Branch Relations
  static const String getUserBranches = '/api/branches/user';
  static const String getAccessibleBranches = '/api/branches/user';
  static const String switchActiveBranch = '/api/branches/switch';

  // Branch Management
  static const String getBranchStats = '/api/branches/{id}/stats';
  static const String getBranchHierarchy = '/api/branches/hierarchy';
  static const String updateBranchHierarchy = '/api/branches/{id}/hierarchy';

  // Branch User Management
  static const String getBranchUsers = '/api/branches/{id}/users';
  static const String assignUserToBranch = '/api/branches/{id}/users';
  static const String updateUserBranchRole = '/api/branches/users/{roleId}';
  static const String removeUserBranchRole = '/api/branches/users/{roleId}';
}