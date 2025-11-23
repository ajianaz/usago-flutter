class BrandEndpoints {
  // Brand CRUD
  static const String getAllBrands = '/api/brands';
  static const String brands = '/api/brands';
  static const String createBrand = '/api/brands';
  static const String getBrand = '/api/brands/{id}';
  static const String updateBrand = '/api/brands/{id}';
  static const String deleteBrand = '/api/brands/{id}';
  static const String getBrandBySlug = '/api/brands/slug/{slug}';

  // User Brand Relations
  static const String getUserBrands = '/api/brands/user';
  static const String getAccessibleBrands = '/api/brands/accessible';
  static const String switchActiveBrand = '/api/brands/switch';

  // Brand Management
  static const String getBrandStats = '/api/brands/{id}/stats';
  static const String transferOwnership = '/api/brands/{id}/transfer';

  // Brand Invitations
  static const String inviteUser = '/api/brands/{id}/invite';
  static const String acceptInvitation = '/api/invitations/accept';
  static const String declineInvitation =
      '/api/invitations/{invitationId}/decline';
  static const String getBrandInvitations = '/api/brands/{id}/invitations';
  static const String getUserInvitations = '/api/invitations/user';
  static const String cancelInvitation =
      '/api/invitations/{invitationId}/cancel';
  static const String resendInvitation =
      '/api/invitations/{invitationId}/resend';
}
