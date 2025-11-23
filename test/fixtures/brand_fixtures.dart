import 'package:usago/features/brand/data/models/brand_model.dart';
import 'package:usago/features/brand/data/models/brand_invitation_model.dart';
import 'package:usago/features/brand/domain/entities/brand.dart';
import 'package:usago/features/brand/domain/entities/brand_invitation.dart';

/// Test fixtures untuk brand feature
class BrandFixtures {
  // Sample brand data
  static const String testBrandId = 'test-brand-123';
  static const String testBrandName = 'Test Brand';
  static const String testBrandSlug = 'test-brand';
  static const String testBrandOwnerId = 'test-owner-123';
  static const String testBrandLogoUrl = 'https://example.com/logo.jpg';
  static const String testBrandBusinessType = 'RETAIL';
  static const String testBrandIndustry = 'Technology';
  static const String testBrandDescription = 'Test brand description';
  static const String testBrandTimezone = 'Asia/Jakarta';
  static const String testBrandCurrency = 'IDR';
  static const String testBrandSubscriptionTier = 'BASIC';
  static const String testBrandSubscriptionStatus = 'ACTIVE';

  static final DateTime testBrandCreatedAt =
      DateTime.parse('2023-01-01T00:00:00Z');
  static final DateTime testBrandUpdatedAt =
      DateTime.parse('2023-01-02T00:00:00Z');
  static final DateTime testBrandSubscriptionExpiresAt =
      DateTime.parse('2024-01-01T00:00:00Z');

  // Sample brand invitation data
  static const String testInvitationId = 'test-invitation-123';
  static const String testInvitationBrandId = 'test-brand-123';
  static const String testInvitationBrandName = 'Test Brand';
  static const String testInvitationInviterId = 'test-inviter-123';
  static const String testInvitationInviterName = 'Test Inviter';
  static const String testInvitationInviteeEmail = 'invitee@example.com';
  static const String testInvitationRole = 'BRANCH_MANAGER';
  static const String testInvitationStatus = 'PENDING';
  static const String testInvitationToken = 'test-token-123';

  static final DateTime testInvitationCreatedAt =
      DateTime.parse('2023-01-01T00:00:00Z');
  static final DateTime testInvitationUpdatedAt =
      DateTime.parse('2023-01-02T00:00:00Z');
  static final DateTime testInvitationExpiresAt =
      DateTime.parse('2023-02-01T00:00:00Z');

  // Sample JSON data for brand
  static const Map<String, dynamic> testBrandJson = {
    'id': testBrandId,
    'name': testBrandName,
    'slug': testBrandSlug,
    'ownerId': testBrandOwnerId,
    'logoUrl': testBrandLogoUrl,
    'businessType': testBrandBusinessType,
    'industry': testBrandIndustry,
    'description': testBrandDescription,
    'settings': {},
    'timezone': testBrandTimezone,
    'currency': testBrandCurrency,
    'subscriptionTier': testBrandSubscriptionTier,
    'subscriptionStatus': testBrandSubscriptionStatus,
    'subscriptionExpiresAt': '2024-01-01T00:00:00.000Z',
    'createdAt': '2023-01-01T00:00:00.000Z',
    'updatedAt': '2023-01-02T00:00:00.000Z',
  };

  // Sample JSON data for brand invitation
  static const Map<String, dynamic> testInvitationJson = {
    'id': testInvitationId,
    'brandId': testInvitationBrandId,
    'brandName': testInvitationBrandName,
    'inviterId': testInvitationInviterId,
    'inviterName': testInvitationInviterName,
    'inviteeEmail': testInvitationInviteeEmail,
    'role': testInvitationRole,
    'status': testInvitationStatus,
    'branchIds': [],
    'expiresAt': '2023-02-01T00:00:00.000Z',
    'createdAt': '2023-01-01T00:00:00.000Z',
    'updatedAt': '2023-01-02T00:00:00.000Z',
  };

  // Sample Brand entity
  static Brand get testBrand => Brand(
        id: testBrandId,
        name: testBrandName,
        slug: testBrandSlug,
        ownerId: testBrandOwnerId,
        logoUrl: testBrandLogoUrl,
        businessType: testBrandBusinessType,
        industry: testBrandIndustry,
        description: testBrandDescription,
        settings: {},
        timezone: testBrandTimezone,
        currency: testBrandCurrency,
        subscriptionTier: testBrandSubscriptionTier,
        subscriptionStatus: testBrandSubscriptionStatus,
        subscriptionExpiresAt: testBrandSubscriptionExpiresAt,
        createdAt: testBrandCreatedAt,
        updatedAt: testBrandUpdatedAt,
      );

  // Sample Brand entity without optional fields
  static Brand get testBrandWithoutOptional => Brand(
        id: testBrandId,
        name: testBrandName,
        slug: testBrandSlug,
        ownerId: testBrandOwnerId,
        businessType: testBrandBusinessType,
        description: null,
        industry: null,
        logoUrl: null,
        settings: {},
        timezone: testBrandTimezone,
        currency: testBrandCurrency,
        subscriptionTier: testBrandSubscriptionTier,
        subscriptionStatus: testBrandSubscriptionStatus,
        subscriptionExpiresAt: null,
        createdAt: testBrandCreatedAt,
        updatedAt: testBrandUpdatedAt,
      );

  // Sample BrandInvitation entity
  static BrandInvitation get testInvitation => BrandInvitation(
        id: testInvitationId,
        brandId: testInvitationBrandId,
        brandName: testInvitationBrandName,
        inviterId: testInvitationInviterId,
        inviterName: testInvitationInviterName,
        inviteeEmail: testInvitationInviteeEmail,
        role: testInvitationRole,
        status: testInvitationStatus,
        branchIds: [],
        expiresAt: testInvitationExpiresAt,
        createdAt: testInvitationCreatedAt,
        updatedAt: testInvitationUpdatedAt,
      );

  // Sample BrandInvitation entity without optional fields
  static BrandInvitation get testInvitationWithoutOptional => BrandInvitation(
        id: testInvitationId,
        brandId: testInvitationBrandId,
        brandName: testInvitationBrandName,
        inviterId: testInvitationInviterId,
        inviterName: testInvitationInviterName,
        inviteeEmail: testInvitationInviteeEmail,
        role: testInvitationRole,
        status: testInvitationStatus,
        branchIds: [],
        expiresAt: null,
        createdAt: testInvitationCreatedAt,
        updatedAt: null,
      );

  // Sample BrandModel
  static BrandModel get testBrandModel => BrandModel(
        id: testBrandId,
        name: testBrandName,
        slug: testBrandSlug,
        ownerId: testBrandOwnerId,
        logoUrl: testBrandLogoUrl,
        businessType: testBrandBusinessType,
        industry: testBrandIndustry,
        description: testBrandDescription,
        settings: {},
        timezone: testBrandTimezone,
        currency: testBrandCurrency,
        subscriptionTier: testBrandSubscriptionTier,
        subscriptionStatus: testBrandSubscriptionStatus,
        subscriptionExpiresAt: testBrandSubscriptionExpiresAt,
        createdAt: testBrandCreatedAt,
        updatedAt: testBrandUpdatedAt,
      );

  // Sample BrandInvitationModel
  static BrandInvitationModel get testInvitationModel => BrandInvitationModel(
        id: testInvitationId,
        brandId: testInvitationBrandId,
        brandName: testInvitationBrandName,
        inviterId: testInvitationInviterId,
        inviterName: testInvitationInviterName,
        inviteeEmail: testInvitationInviteeEmail,
        role: testInvitationRole,
        status: testInvitationStatus,
        branchIds: [],
        expiresAt: testInvitationExpiresAt,
        createdAt: testInvitationCreatedAt,
        updatedAt: testInvitationUpdatedAt,
      );

  // Test data for various scenarios
  static List<Brand> get testBrandList => [
        testBrand,
        testBrandWithoutOptional,
        Brand(
          id: 'test-brand-456',
          name: 'Another Brand',
          slug: 'another-brand',
          ownerId: 'test-owner-456',
          businessType: 'SERVICE',
          settings: {},
          timezone: testBrandTimezone,
          currency: testBrandCurrency,
          subscriptionTier: 'PRO',
          subscriptionStatus: 'ACTIVE',
          createdAt: testBrandCreatedAt,
          updatedAt: testBrandUpdatedAt,
        ),
      ];

  static List<BrandModel> get testBrandModelList => [
        testBrandModel,
        BrandModel(
          id: testBrandId,
          name: testBrandName,
          slug: testBrandSlug,
          ownerId: testBrandOwnerId,
          businessType: testBrandBusinessType,
          description: null,
          industry: null,
          logoUrl: null,
          settings: {},
          timezone: testBrandTimezone,
          currency: testBrandCurrency,
          subscriptionTier: testBrandSubscriptionTier,
          subscriptionStatus: testBrandSubscriptionStatus,
          subscriptionExpiresAt: null,
          createdAt: testBrandCreatedAt,
          updatedAt: testBrandUpdatedAt,
        ),
        BrandModel(
          id: 'test-brand-456',
          name: 'Another Brand',
          slug: 'another-brand',
          ownerId: 'test-owner-456',
          businessType: 'SERVICE',
          settings: {},
          timezone: testBrandTimezone,
          currency: testBrandCurrency,
          subscriptionTier: 'PRO',
          subscriptionStatus: 'ACTIVE',
          createdAt: testBrandCreatedAt,
          updatedAt: testBrandUpdatedAt,
        ),
      ];

  static List<BrandInvitation> get testInvitationList => [
        testInvitation,
        testInvitationWithoutOptional,
        BrandInvitation(
          id: 'test-invitation-456',
          brandId: 'test-brand-456',
          brandName: 'Another Brand',
          inviterId: 'test-inviter-456',
          inviterName: 'Another Inviter',
          inviteeEmail: 'another@example.com',
          role: 'BRANCH_ADMIN',
          status: 'ACCEPTED',
          branchIds: [],
          createdAt: testInvitationCreatedAt,
          updatedAt: testInvitationUpdatedAt,
        ),
      ];

  // Test data for brand creation/update
  static const Map<String, dynamic> testBrandData = {
    'name': 'New Brand',
    'slug': 'new-brand',
    'businessType': 'MANUFACTURING',
    'description': 'New brand description',
    'timezone': 'Asia/Jakarta',
    'currency': 'IDR',
  };

  // Test data for invitation creation
  static const Map<String, dynamic> testInvitationData = {
    'inviteeEmail': 'new@example.com',
    'role': 'BRANCH_STAFF',
    'branchIds': ['branch-1', 'branch-2'],
  };

  // Test credentials and tokens
  static const String testBrandId2 = 'test-brand-456';
  static const String testNewOwnerId = 'new-owner-123';
  static const String testConfirmationCode = 'CONFIRM-123';
  static const String testSearchQuery = 'test';
  static const Map<String, dynamic> testSearchFilters = {
    'businessType': 'RETAIL',
    'subscriptionTier': 'BASIC',
  };
}
