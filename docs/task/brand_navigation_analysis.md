# Analisis Alur Navigasi Fitur Brand

## 1. Implementasi Navigasi Saat Ini

### 1.1 Entry Point (Dari HomePage ke BrandSelectionPage)

**Alur Navigasi:**
```
HomePage → FeatureGrid → MenuCard → BrandSelectionPage
```

**Implementasi:**
- Di [`HomePage`](lib/features/home/presentation/pages/home_page.dart:163), user dapat memilih menu "Brand" dari [`FeatureGrid`](lib/features/home/presentation/widgets/feature_grid.dart:55)
- Menu Brand didefinisikan di [`MenuItemModel.getDefaultMenuItems()`](lib/features/home/data/models/menu_item_model.dart:94-99) dengan route `/brand-selection`
- Navigasi menggunakan `context.router.pushNamed(menuItem.route)` yang mengarah ke `/brand-selection`

### 1.2 Navigasi dari BrandSelectionPage

#### 1.2.1 Ke CreateBrandPage
**Implementasi:**
- Tombol "Buat Brand Baru" di [`BrandSelectionPage`](lib/features/brand/presentation/pages/brand_selection_page.dart:236-240)
- Floating Action Button di [`BrandSelectionPage`](lib/features/brand/presentation/pages/brand_selection_page.dart:310-319)
- Menggunakan `context.router.pushNamed('/create-brand')`

#### 1.2.2 Ke EditBrandPage
**Implementasi:**
- Dialog konfirmasi di [`_showEditBrandDialog()`](lib/features/brand/presentation/pages/brand_selection_page.dart:446-482)
- Menggunakan `context.router.pushNamed('/edit-brand/${brand.id}')`
- Parameter: `brandId` (String)

#### 1.2.3 Switch Brand
**Implementasi:**
- Tap pada [`BrandCard`](lib/features/brand/presentation/widgets/brand_card.dart:70) di [`BrandSelectionPage`](lib/features/brand/presentation/pages/brand_selection_page.dart:430-432)
- Trigger event `SwitchBrandEvent(brand.id)` ke [`BrandBloc`](lib/features/brand/presentation/bloc/brand_bloc.dart)

### 1.3 Halaman Brand yang Memerlukan Parameter Brand

#### 1.3.1 BrandStatsPage
**Router Definition:**
```dart
BrandStatsRoute({
  required Brand brand,
})
```
**Masalah:** Tidak ada navigasi dari BrandSelectionPage ke BrandStatsPage

#### 1.3.2 BrandInvitationListPage
**Router Definition:**
```dart
BrandInvitationListRoute({
  required Brand brand,
})
```
**Masalah:** Tidak ada navigasi dari BrandSelectionPage ke BrandInvitationListPage

#### 1.3.3 BrandTransferPage
**Router Definition:**
```dart
BrandTransferRoute({
  required Brand brand,
})
```
**Masalah:** Tidak ada navigasi dari BrandSelectionPage ke BrandTransferPage

## 2. Diagram Alur Navigasi

```
┌─────────────┐
│   HomePage  │
└─────┬───────┘
      │ (tap menu "Brand")
      ▼
┌─────────────────────┐
│ BrandSelectionPage │
└─────┬───────────────┘
      │
      ├───┬─────────────────────┐
      │   │                     │
      ▼   ▼                     ▼
┌─────────────┐    ┌─────────────────┐    ┌─────────────┐
│CreateBrand  │    │ EditBrandPage   │    │ SwitchBrand │
│Page         │    │ (brandId)       │    │ Event       │
└─────┬───────┘    └────────┬────────┘    └─────────────┘
      │                     │
      ▼                     ▼
┌─────────────┐    ┌─────────────────┐
│ Back to     │    │ Back to         │
│ BrandSelect │    │ BrandSelect     │
└─────────────┘    └─────────────────┘

❌ HALAMAN YANG TIDAK TERJANGKAU:
┌─────────────────────┐    ┌──────────────────────┐    ┌─────────────────┐
│   BrandStatsPage    │    │BrandInvitationListPage│    │ BrandTransferPage│
│   (brand object)    │    │   (brand object)      │    │ (brand object)  │
└─────────────────────┘    └──────────────────────┘    └─────────────────┘
```

## 3. Gap dan Masalah dalam Alur Navigasi

### 3.1 Halaman yang Tidak Dapat Dijangkau

1. **BrandStatsPage**
   - Memerlukan parameter `Brand` object
   - Tidak ada tombol atau aksi di BrandSelectionPage yang mengarah ke sini
   - Router sudah didefinisikan tapi tidak digunakan

2. **BrandInvitationListPage**
   - Memerlukan parameter `Brand` object
   - Tidak ada navigasi dari BrandSelectionPage
   - Router sudah didefinisikan tapi tidak digunakan

3. **BrandTransferPage**
   - Memerlukan parameter `Brand` object
   - Tidak ada navigasi dari BrandSelectionPage
   - Router sudah didefinisikan tapi tidak digunakan

### 3.2 Masalah Parameter Passing

1. **Inkonsistensi Parameter**
   - EditBrandPage menggunakan `brandId` (String)
   - BrandStatsPage, BrandInvitationListPage, BrandTransferPage membutuhkan `Brand` object lengkap

2. **Tidak Ada Akses ke Brand Object**
   - BrandSelectionPage memiliki akses ke list Brand objects
   - Tapi tidak ada UI untuk navigasi ke halaman-halaman yang membutuhkan Brand object

### 3.3 Alur Navigasi yang Tidak Intuitif

1. **Tidak Ada Menu Options di BrandCard**
   - BrandCard hanya memiliki opsi Edit dan Delete
   - Tidak ada opsi untuk melihat statistik, undangan, atau transfer

2. **Tidak Ada Navigasi Langsung**
   - User harus kembali ke BrandSelectionPage untuk mengakses fungsi lain
   - Tidak ada navigasi antar halaman brand

## 4. Rekomendasi Perbaikan

### 4.1 Tambahkan Navigasi di BrandCard

**Modifikasi BrandCard options:**
```dart
PopupMenuButton<String>(
  onSelected: (value) {
    switch (value) {
      case 'stats':
        // Navigasi ke BrandStatsPage
        context.router.push(BrandStatsRoute(brand: brand));
        break;
      case 'invitations':
        // Navigasi ke BrandInvitationListPage
        context.router.push(BrandInvitationListRoute(brand: brand));
        break;
      case 'transfer':
        // Navigasi ke BrandTransferPage
        context.router.push(BrandTransferRoute(brand: brand));
        break;
      case 'edit':
        onEdit?.call();
        break;
      case 'delete':
        onDelete?.call();
        break;
    }
  },
  itemBuilder: (context) => [
    PopupMenuItem(value: 'stats', child: Text('Statistik')),
    PopupMenuItem(value: 'invitations', child: Text('Undangan')),
    PopupMenuItem(value: 'transfer', child: Text('Transfer')),
    PopupMenuItem(value: 'edit', child: Text('Edit')),
    PopupMenuItem(value: 'delete', child: Text('Hapus')),
  ],
)
```

### 4.2 Tambahkan Quick Actions di BrandSelectionPage

**Tambahkan tombol aksi cepat untuk setiap brand:**
```dart
// Di dalam BrandCard
Row(
  children: [
    IconButton(
      icon: Icon(Icons.analytics),
      onPressed: () => context.router.push(BrandStatsRoute(brand: brand)),
    ),
    IconButton(
      icon: Icon(Icons.mail),
      onPressed: () => context.router.push(BrandInvitationListRoute(brand: brand)),
    ),
    IconButton(
      icon: Icon(Icons.swap_horiz),
      onPressed: () => context.router.push(BrandTransferRoute(brand: brand)),
    ),
  ],
)
```

### 4.3 Standardisasi Parameter Passing

**Opsi 1: Gunakan BrandId untuk semua halaman**
```dart
// Router definition
BrandStatsRoute({
  required String brandId,
})

// Di halaman, load brand data
class BrandStatsPage extends StatelessWidget {
  final String brandId;

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BrandBloc(brandRepository: context.read())
        ..add(GetBrandByIdEvent(brandId)),
      child: BrandStatsView(brandId: brandId),
    );
  }
}
```

**Opsi 2: Pass Brand object untuk semua halaman**
```dart
// EditBrandRoute juga menggunakan Brand object
EditBrandRoute({
  required Brand brand,
})
```

### 4.4 Tambahkan Navigasi Breadcrumb

**Implementasi breadcrumb untuk navigasi yang lebih baik:**
```dart
// Di setiap halaman brand
AppBar(
  title: Row(
    children: [
      GestureDetector(
        onTap: () => context.router.push(BrandSelectionRoute()),
        child: Text('Brand /'),
      ),
      Text(' Statistik'),
    ],
  ),
)
```

### 4.5 Tambahkan Bottom Navigation untuk Brand Actions

**Implementasi bottom navigation di BrandSelectionPage:**
```dart
// Ketika brand dipilih/aktif
BottomNavigationBar(
  items: [
    BottomNavigationBarItem(
      icon: Icon(Icons.analytics),
      label: 'Statistik',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.mail),
      label: 'Undangan',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.swap_horiz),
      label: 'Transfer',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.edit),
      label: 'Edit',
    ),
  ],
  onTap: (index) {
    final brand = activeBrand;
    if (brand == null) return;

    switch (index) {
      case 0:
        context.router.push(BrandStatsRoute(brand: brand));
        break;
      case 1:
        context.router.push(BrandInvitationListRoute(brand: brand));
        break;
      case 2:
        context.router.push(BrandTransferRoute(brand: brand));
        break;
      case 3:
        context.router.pushNamed('/edit-brand/${brand.id}');
        break;
    }
  },
)
```

## 5. Prioritas Implementasi

1. **High Priority:**
   - Tambahkan navigasi ke BrandStatsPage dari BrandSelectionPage
   - Tambahkan navigasi ke BrandInvitationListPage dari BrandSelectionPage
   - Tambahkan navigasi ke BrandTransferPage dari BrandSelectionPage

2. **Medium Priority:**
   - Standardisasi parameter passing (gunakan BrandId untuk konsistensi)
   - Tambahkan quick actions di BrandCard

3. **Low Priority:**
   - Implementasi breadcrumb navigation
   - Tambahkan bottom navigation untuk brand actions

## 6. Kesimpulan

Saat ini, alur navigasi brand memiliki gap signifikan di mana 3 halaman penting (BrandStatsPage, BrandInvitationListPage, BrandTransferPage) tidak dapat diakses dari BrandSelectionPage. Router sudah didefinisikan dengan benar, tetapi tidak ada implementasi UI yang menghubungkan halaman-halaman tersebut.

Rekomendasi utama adalah menambahkan opsi navigasi di BrandCard dan tombol aksi cepat di BrandSelectionPage untuk mengakses semua fungsi brand yang tersedia.