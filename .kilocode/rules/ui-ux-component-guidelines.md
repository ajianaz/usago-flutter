# UI/UX Component Guidelines
# Pedoman Komponen UI/UX

---

## 📋 **Document Metadata**

| Field | Value |
|-------|-------|
| **Document ID** | RULES-UI-UX-COMPONENT-GUIDELINES |
| **Version** | 1.0 |
| **Status** | Active |
| **Category** | UI/UX Rules |
| **Priority** | High |
| **Created Date** | November 15, 2025 |
| **Last Updated** | November 15, 2025 |
| **Next Review** | November 22, 2025 |
| **Author** | Mobile Development Team |
| **Reviewers** | UI/UX Lead, Product Team |
| **Stakeholders** | Development Team, Design Team, Product Team |

---

## 🎯 **Purpose**

Dokumen ini mendefinisikan pedoman dan aturan untuk pengembangan komponen UI/UX dalam aplikasi Usago Mobile. Pedoman ini memastikan konsistensi desain, user experience yang baik, dan adherence terhadap design system yang ada.

---

## 📚 **Table of Contents**

1. [Design System Compliance](#design-system-compliance)
2. [Component Architecture](#component-architecture)
3. [Layout Guidelines](#layout-guidelines)
4. [Typography Guidelines](#typography-guidelines)
5. [Color Guidelines](#color-guidelines)
6. [Icon Guidelines](#icon-guidelines)
7. [Animation Guidelines](#animation-guidelines)
8. [Responsive Design Guidelines](#responsive-design-guidelines)
9. [Accessibility Guidelines](#accessibility-guidelines)

---

## 🎨 **Design System Compliance**

### **Guideline 1.1: Component Library Usage**

Gunakan komponen dari shadcn/ui tanpa modifikasi:

```dart
// ✅ BENAR: Gunakan komponen shadcn/ui langsung
class UserForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'User Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // Gunakan shadcn/ui components langsung
        const CustomTextField(
          label: 'Name',
          placeholder: 'Enter your name',
        ),
        const SizedBox(height: 8),
        const CustomTextField(
          label: 'Email',
          placeholder: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        CustomButton(
          onPressed: _onSubmit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

// ❌ SALAH: Modifikasi komponen shadcn/ui
class ModifiedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
        // Modifikasi styling yang tidak sesuai design system
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Text('Button'),
    );
  }
}
```

### **Guideline 1.2: Component Structure**

Struktur komponen harus mengikuti pattern yang ditentukan:

```dart
// ✅ BENAR: Struktur komponen yang tepat
class UserProfileCard extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;
  final bool showActions;

  const UserProfileCard({
    Key? key,
    required this.user,
    this.onTap,
    this.showActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildContent(),
              if (showActions) ...[
                const SizedBox(height: 12),
                _buildActions(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(user.avatarUrl),
          radius: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                user.email,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (user.bio.isNotEmpty) ...[
          Text(
            user.bio,
            style: const TextStyle(fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
        ],
        _buildStats(),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        _buildStatItem('Followers', user.followersCount),
        const SizedBox(width: 16),
        _buildStatItem('Following', user.followingCount),
      ],
    );
  }

  Widget _buildStatItem(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomButton.outlined(
          onPressed: () => _onEdit(user),
          child: const Text('Edit'),
        ),
        const SizedBox(width: 8),
        CustomButton(
          onPressed: () => _onDelete(user),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}

// ❌ SALAH: Struktur komponen yang buruk
class BadUserProfileCard extends StatelessWidget {
  final User user;

  const BadUserProfileCard(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // Semua widget dalam satu method build
          CircleAvatar(
            backgroundImage: NetworkImage(user.avatarUrl),
          ),
          Text(user.name),
          Text(user.email),
          if (user.bio.isNotEmpty) Text(user.bio),
          Row(
            children: [
              Text(user.followersCount.toString()),
              Text('Followers'),
              Text(user.followingCount.toString()),
              Text('Following'),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Text('Edit'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

---

## 🏗️ **Component Architecture**

### **Guideline 2.1: Component Categorization**

Komponen harus dikategorikan dengan benar:

```
apps/mobile/lib/shared/widgets/
├── forms/                    # Form components
│   ├── custom_text_field.dart
│   ├── custom_dropdown.dart
│   └── custom_date_picker.dart
├── buttons/                   # Button components
│   ├── custom_button.dart
│   ├── icon_button.dart
│   └── text_button.dart
├── cards/                     # Card components
│   ├── user_card.dart
│   ├── product_card.dart
│   └── transaction_card.dart
├── lists/                     # List components
│   ├── item_list.dart
│   ├── search_list.dart
│   └── infinite_list.dart
├── feedback/                  # Feedback components
│   ├── loading_indicator.dart
│   ├── error_message.dart
│   └── success_message.dart
└── layout/                    # Layout components
    ├── responsive_builder.dart
    ├── screen_container.dart
    └── section_header.dart
```

### **Guideline 2.2: Component Reusability**

Komponen harus dirancang untuk reusable:

```dart
// ✅ BENAR: Komponen reusable
class CustomListTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;
  final EdgeInsetsGeometry? contentPadding;

  const CustomListTile({
    Key? key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.showDivider = true,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: contentPadding ?? const EdgeInsets.all(16),
            child: Row(
              children: [
                leading,
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title,
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        subtitle!,
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 16),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(height: 1),
      ],
    );
  }
}

// Usage examples
class UserList extends StatelessWidget {
  final List<User> users;

  const UserList({Key? key, required this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return CustomListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.avatarUrl),
          ),
          title: Text(user.name),
          subtitle: Text(user.email),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () => _onUserTapped(user),
        );
      },
    );
  }
}

class SettingsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CustomListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notifications'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () => _openNotifications(),
        ),
        CustomListTile(
          leading: const Icon(Icons.privacy_tip),
          title: const Text('Privacy'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () => _openPrivacy(),
        ),
        CustomListTile(
          leading: const Icon(Icons.help),
          title: const Text('Help'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () => _openHelp(),
        ),
      ],
    );
  }
}

// ❌ SALAH: Komponen tidak reusable
class UserListTile extends StatelessWidget {
  final User user;

  const UserListTile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.avatarUrl),
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Hardcoded navigation
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailPage(user: user),
          ),
        );
      },
    );
  }
}
```

---

## 📐 **Layout Guidelines**

### **Guideline 3.1: Spacing System**

Gunakan spacing system yang konsisten:

```dart
// ✅ BENAR: Spacing system yang konsisten
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              product.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                CustomButton(
                  onPressed: () => _addToCart(product),
                  child: const Text('Add to Cart'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ❌ SALAH: Spacing tidak konsisten
class BadProductCard extends StatelessWidget {
  final Product product;

  const BadProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.5), // Magic number
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              product.imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 6), // Inconsistent spacing
            Text(
              product.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 3), // Magic number
            Text(
              product.description,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10), // Inconsistent spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _addToCart(product),
                  child: const Text('Add to Cart'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### **Guideline 3.2: Responsive Layout**

Gunakan responsive design dengan benar:

```dart
// ✅ BENAR: Responsive layout
class ResponsiveProductGrid extends StatelessWidget {
  final List<Product> products;

  const ResponsiveProductGrid({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _getCrossAxisCount(constraints.maxWidth);
        final childAspectRatio = _getChildAspectRatio(constraints.maxWidth);

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ProductCard(product: products[index]);
          },
        );
      },
    );
  }

  int _getCrossAxisCount(double width) {
    if (width >= 1200) return 4; // Desktop
    if (width >= 800) return 3;  // Tablet
    if (width >= 600) return 2;  // Large mobile
    return 1;                    // Small mobile
  }

  double _getChildAspectRatio(double width) {
    if (width >= 800) return 0.8; // Tablet and desktop
    return 0.7;                   // Mobile
  }
}

// ❌ SALAH: Fixed layout
class FixedProductGrid extends StatelessWidget {
  final List<Product> products;

  const FixedProductGrid({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Fixed for all screen sizes
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
}
```

---

## 📝 **Typography Guidelines**

### **Guideline 4.1: Text Hierarchy**

Gunakan text hierarchy yang konsisten:

```dart
// ✅ BENAR: Text hierarchy yang konsisten
class AppTextStyles {
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle h5 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );
}

class ArticleScreen extends StatelessWidget {
  final Article article;

  const ArticleScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              article.author,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              _formatDate(article.publishedAt),
              style: AppTextStyles.caption.copyWith(
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              article.content,
              style: AppTextStyles.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

// ❌ SALAH: Text hierarchy tidak konsisten
class BadArticleScreen extends StatelessWidget {
  final Article article;

  const BadArticleScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              article.author,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              _formatDate(article.publishedAt),
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              article.content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🎨 **Color Guidelines**

### **Guideline 5.1: Color System**

Gunakan color system yang konsisten:

```dart
// ✅ BENAR: Color system yang konsisten
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF1976D2);
  static const Color primaryVariant = Color(0xFF1565C0);
  static const Color onPrimary = Colors.white;

  // Secondary colors
  static const Color secondary = Color(0xFFFF9800);
  static const Color secondaryVariant = Color(0xFFF57C00);
  static const Color onSecondary = Colors.white;

  // Surface colors
  static const Color surface = Colors.white;
  static const Color background = Color(0xFFF5F5F5);
  static const Color onSurface = Color(0xFF212121);
  static const Color onBackground = Color(0xFF212121);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);

  // Border colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFF0F0F0);
  static const Color borderDark = Color(0xFFBDBDBD);
}

class StatusBadge extends StatelessWidget {
  final Status status;
  final String text;

  const StatusBadge({
    Key? key,
    required this.status,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: _getTextColor(),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (status) {
      case Status.success:
        return AppColors.success;
      case Status.warning:
        return AppColors.warning;
      case Status.error:
        return AppColors.error;
      case Status.info:
        return AppColors.info;
    }
  }

  Color _getTextColor() {
    switch (status) {
      case Status.success:
      case Status.error:
      case Status.info:
        return Colors.white;
      case Status.warning:
        return Colors.black;
    }
  }
}

// ❌ SALAH: Hardcoded colors
class BadStatusBadge extends StatelessWidget {
  final String status;
  final String text;

  const BadStatusBadge({
    Key? key,
    required this.status,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'success':
        backgroundColor = const Color(0xFF4CAF50); // Magic color
        textColor = Colors.white;
        break;
      case 'warning':
        backgroundColor = const Color(0xFFFF9800); // Magic color
        textColor = Colors.black;
        break;
      case 'error':
        backgroundColor = const Color(0xFFF44336); // Magic color
        textColor = Colors.white;
        break;
      default:
        backgroundColor = Colors.grey;
        textColor = Colors.white;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
```

---

## 🎯 **Icon Guidelines**

### **Guideline 6.1: Icon Usage**

Gunakan Lucide icons untuk semua ikon:

```dart
// ✅ BENAR: Gunakan Lucide icons
import 'package:lucide_icons/lucide_icons.dart';

class IconConstants {
  static const double small = 16.0;
  static const double medium = 24.0;
  static const double large = 32.0;
}

class NavigationItem {
  final String label;
  final IconData icon;
  final String route;

  const NavigationItem({
    required this.label,
    required this.icon,
    required this.route,
  });
}

class AppNavigation extends StatelessWidget {
  static const List<NavigationItem> items = [
    NavigationItem(
      label: 'Home',
      icon: LucideIcons.home,
      route: '/home',
    ),
    NavigationItem(
      label: 'Search',
      icon: LucideIcons.search,
      route: '/search',
    ),
    NavigationItem(
      label: 'Profile',
      icon: LucideIcons.user,
      route: '/profile',
    ),
    NavigationItem(
      label: 'Settings',
      icon: LucideIcons.settings,
      route: '/settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          leading: Icon(
            item.icon,
            size: IconConstants.medium,
          ),
          title: Text(item.label),
          onTap: () => _navigateTo(context, item.route),
        );
      },
    );
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }
}

// ❌ SALAH: Gunakan SVG atau custom icons
class BadNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: SvgPicture.asset('assets/icons/home.svg'), // SVG file
          title: const Text('Home'),
          onTap: () => Navigator.pushNamed(context, '/home'),
        ),
        ListTile(
          leading: Container( // Custom drawn icon
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search, color: Colors.white, size: 16),
          ),
          title: const Text('Search'),
          onTap: () => Navigator.pushNamed(context, '/search'),
        ),
      ],
    );
  }
}
```

---

## 🎬 **Animation Guidelines**

### **Guideline 7.1: Animation Duration**

Gunakan animation duration yang konsisten:

```dart
// ✅ BENAR: Animation duration yang konsisten
class AppAnimations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.bounceOut;
  static const Curve sharpCurve = Curves.easeOutCubic;
}

class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AnimatedButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.defaultCurve,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.7,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.defaultCurve,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isLoading ? null : _handleTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: child,
            ),
          );
        },
        child: CustomButton(
          onPressed: widget.onPressed,
          isLoading: widget.isLoading,
          child: widget.child,
        ),
      ),
    );
  }

  void _handleTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    widget.onPressed?.call();
  }
}

// ❌ SALAH: Animation duration tidak konsisten
class BadAnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const BadAnimatedButton({
    Key? key,
    required this.child,
    this.onPressed,
  }) : super(key: key);

  @override
  _BadAnimatedButtonState createState() => _BadAnimatedButtonState();
}

class _BadAnimatedButtonState extends State<BadAnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 450), // Magic number
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) {
          _controller.reverse();
        });
        widget.onPressed?.call();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_controller.value * 0.1), // Magic calculation
            child: Opacity(
              opacity: 1.0 - (_controller.value * 0.3), // Magic calculation
              child: child,
            ),
          );
        },
        child: ElevatedButton(
          onPressed: widget.onPressed,
          child: widget.child,
        ),
      ),
    );
  }
}
```

---

## 📱 **Responsive Design Guidelines**

### **Guideline 8.1: Breakpoint System**

Gunakan breakpoint system yang konsisten:

```dart
// ✅ BENAR: Breakpoint system yang konsisten
class AppBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenType screenType) builder;

  const ResponsiveBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenType = _getScreenType(screenWidth);

        return builder(context, screenType);
      },
    );
  }

  ScreenType _getScreenType(double width) {
    if (width >= AppBreakpoints.desktop) {
      return ScreenType.desktop;
    } else if (width >= AppBreakpoints.tablet) {
      return ScreenType.tablet;
    } else {
      return ScreenType.mobile;
    }
  }
}

enum ScreenType { mobile, tablet, desktop }

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenType) {
        switch (screenType) {
          case ScreenType.desktop:
            return desktop ?? tablet ?? mobile;
          case ScreenType.tablet:
            return tablet ?? mobile;
          case ScreenType.mobile:
            return mobile;
        }
      },
    );
  }
}

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
      desktop: _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: AppSpacing.md),
        _buildStatsGrid(crossAxisCount: 2),
        const SizedBox(height: AppSpacing.md),
        _buildChartList(),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: AppSpacing.md),
              _buildStatsGrid(crossAxisCount: 3),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: _buildChartList(),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _buildSidebar(),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: AppSpacing.md),
              _buildStatsGrid(crossAxisCount: 4),
              const SizedBox(height: AppSpacing.md),
              _buildChartsGrid(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() => const Text('Dashboard');
  Widget _buildStatsGrid({required int crossAxisCount}) => Container();
  Widget _buildChartList() => Container();
  Widget _buildSidebar() => Container();
  Widget _buildChartsGrid() => Container();
}

// ❌ SALAH: Tidak ada responsive design
class BadDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Dashboard'),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 4, // Fixed for all screen sizes
          children: [
            _buildStatCard('Users', '100'),
            _buildStatCard('Orders', '50'),
            _buildStatCard('Revenue', '\$1000'),
            _buildStatCard('Growth', '10%'),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title),
            Text(value),
          ],
        ),
      ),
    );
  }
}
```

---

## ♿ **Accessibility Guidelines**

### **Guideline 9.1: Semantic Labels**

Gunakan semantic labels yang deskriptif:

```dart
// ✅ BENAR: Semantic labels yang deskriptif
class AccessibleButton extends StatelessWidget {
  final String label;
  final String? semanticLabel;
  final VoidCallback? onPressed;

  const AccessibleButton({
    Key? key,
    required this.label,
    this.semanticLabel,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel ?? label,
      hint: onPressed != null ? 'Double tap to activate' : null,
      child: CustomButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Semantics(
            label: 'Email address input field',
            hint: 'Enter your email address',
            child: const CustomTextField(
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Semantics(
            label: 'Password input field',
            hint: 'Enter your password',
            child: const CustomTextField(
              label: 'Password',
              obscureText: true,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AccessibleButton(
            label: 'Login',
            semanticLabel: 'Login to your account',
            onPressed: _onLogin,
          ),
        ],
      ),
    );
  }

  void _onLogin() {
    // Login logic
  }
}

// ❌ SALAH: Tidak ada semantic labels
class InaccessibleForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const TextField(
            decoration: InputDecoration(
              labelText: 'Email',
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Password',
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
```

### **Guideline 9.2: Color Contrast**

Pastikan color contrast memenuhi accessibility standards:

```dart
// ✅ BENAR: Color contrast yang baik
class AccessibleTextStyles {
  static const TextStyle headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary, // High contrast
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary, // High contrast
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary, // Still good contrast
  );
}

class AccessibleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? action;

  const AccessibleCard({
    Key? key,
    required this.title,
    required this.subtitle,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AccessibleTextStyles.headline1.copyWith(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              style: AccessibleTextStyles.bodyText.copyWith(
                fontSize: 14,
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: AppSpacing.sm),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

// ❌ SALAH: Color contrast yang buruk
class InaccessibleCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const InaccessibleCard({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200], // Low contrast background
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600], // Low contrast text
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500], // Very low contrast text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## ✅ **UI/UX Checklist**

### **Component Design**
- [ ] Menggunakan komponen shadcn/ui tanpa modifikasi
- [ ] Struktur komponen mengikuti pattern yang ditentukan
- [ ] Komponen reusable dan well-documented
- [ ] Props dan state terdefinisi dengan jelas
- [ ] Error states dan loading states diimplementasikan

### **Layout & Spacing**
- [ ] Menggunakan spacing system yang konsisten
- [ ] Responsive design untuk berbagai screen sizes
- [ ] Breakpoint system yang tepat
- [ ] Layout yang accessible
- [ ] Proper padding dan margins

### **Typography & Colors**
- [ ] Text hierarchy yang konsisten
- [ ] Color system yang konsisten
- [ ] Color contrast memenuhi accessibility standards
- [ ] Text styles yang readable
- [ ] Proper text scaling

### **Icons & Images**
- [ ] Menggunakan Lucide icons
- [ ] Icon sizes yang konsisten
- [ ] Image optimization
- [ ] Proper alt text untuk images
- [ ] Icon yang meaningful

### **Animations**
- [ ] Animation duration yang konsisten
- [ ] Smooth transitions
- [ ] Respect user preferences (reduced motion)
- [ ] Purposeful animations
- [ ] Performance optimized

### **Accessibility**
- [ ] Semantic labels yang deskriptif
- [ ] Screen reader support
- [ ] Keyboard navigation
- [ ] Focus management
- [ ] Color contrast compliance

---

## 🔗 **Related Documentation**

- [`../flutter-development-guidelines.md`](./flutter-development-guidelines.md) - Flutter development guidelines
- [`../code-review-checklist-rules.md`](./code-review-checklist-rules.md) - Code review checklist
- [`../testing-strategies-rules.md`](./testing-strategies-rules.md) - Testing strategies
- [`../security-implementation-rules.md`](./security-implementation-rules.md) - Security implementation
- [`../performance-monitoring-rules.md`](./performance-monitoring-rules.md) - Performance monitoring

---

## 📞 **Contact Information**

### **UI/UX Team**

| Issue | Contact | Response Time |
|-------|----------|---------------|
| **Design System** | ux-team@usago.id | 4 hours |
| **Component Issues** | ux-team@usago.id | 2 hours |
| **Accessibility** | ux-team@usago.id | 1 hour |
| **Responsive Design** | ux-team@usago.id | 4 hours |

---

## 📝 **Notes**

### **Design Tools**
- Figma for design mockups
- Storybook for component documentation
- Contrast checker for accessibility
- Device simulator for responsive testing

### **Best Practices**
- User-centered design approach
- Consistent visual hierarchy
- Intuitive navigation patterns
- Error prevention over error correction
- Progressive enhancement

---

**Document End**

**Go Digital, Grow Together.**