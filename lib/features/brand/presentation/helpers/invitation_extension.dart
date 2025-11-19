import 'package:flutter/widgets.dart';
import '../../domain/entities/brand_invitation.dart';
import 'invitation_formatter.dart';

/// Extension methods untuk BrandInvitation entity
/// Menyediakan UI helper methods yang menggunakan InvitationFormatter
extension BrandInvitationExtension on BrandInvitation {
  /// Pure business logic (tetap di domain)
  bool get isPending => status.toUpperCase() == 'PENDING';

  bool get isAccepted => status.toUpperCase() == 'ACCEPTED';

  bool get isDeclined => status.toUpperCase() == 'DECLINED';

  bool get isRejected => status.toUpperCase() == 'REJECTED';

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  bool get isValid => !isExpired && isPending;

  /// UI helpers (pindah ke presentation)
  String displayRole(BuildContext context) {
    return InvitationFormatter.formatRole(role, context);
  }

  String displayStatus(BuildContext context) {
    return InvitationFormatter.formatStatus(status, context);
  }

  String displayCreatedDate(BuildContext context) {
    return InvitationFormatter.formatCreatedDate(createdAt, context);
  }

  String? displayExpirationDate(BuildContext context) {
    return InvitationFormatter.formatExpirationDate(expiresAt, context);
  }

  String displayExpiryStatus(BuildContext context) {
    return InvitationFormatter.formatExpiryStatus(expiresAt, context);
  }

  bool get isExpiringSoon => InvitationFormatter.isExpiringSoon(expiresAt);

  String getInvitationPriority(BuildContext context) {
    return InvitationFormatter.getInvitationPriority(expiresAt, context);
  }
}