///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  );

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsAppEn app = TranslationsAppEn.internal(_root);
	late final TranslationsAuthEn auth = TranslationsAuthEn.internal(_root);
	late final TranslationsValidationEn validation = TranslationsValidationEn.internal(_root);
	late final TranslationsMessagesEn messages = TranslationsMessagesEn.internal(_root);
	late final TranslationsCommonEn common = TranslationsCommonEn.internal(_root);
	late final TranslationsHomeEn home = TranslationsHomeEn.internal(_root);
	late final TranslationsBrandEn brand = TranslationsBrandEn.internal(_root);
}

// Path: app
class TranslationsAppEn {
	TranslationsAppEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Usago'
	///
	/// id: 'Usago'
	String get title => 'Usago';

	/// en: 'Welcome'
	///
	/// id: 'Selamat Datang'
	String get welcome => 'Welcome';
}

// Path: auth
class TranslationsAuthEn {
	TranslationsAuthEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Login'
	///
	/// id: 'Masuk'
	String get login => 'Login';

	/// en: 'Register'
	///
	/// id: 'Daftar'
	String get register => 'Register';

	/// en: 'Email'
	///
	/// id: 'Email'
	String get email => 'Email';

	/// en: 'Password'
	///
	/// id: 'Kata Sandi'
	String get password => 'Password';

	/// en: 'Forgot Password?'
	///
	/// id: 'Lupa Kata Sandi?'
	String get forgot_password => 'Forgot Password?';

	/// en: 'Don't have an account?'
	///
	/// id: 'Belum punya akun?'
	String get dont_have_account => 'Don\'t have an account?';

	/// en: 'Welcome Back'
	///
	/// id: 'Selamat Datang Kembali'
	String get welcome_back => 'Welcome Back';

	/// en: 'Sign in to continue'
	///
	/// id: 'Masuk untuk melanjutkan'
	String get sign_in_to_continue => 'Sign in to continue';

	/// en: 'Create Account'
	///
	/// id: 'Buat Akun'
	String get create_account => 'Create Account';

	/// en: 'Sign up to continue'
	///
	/// id: 'Daftar untuk melanjutkan'
	String get sign_up_to_continue => 'Sign up to continue';

	/// en: 'Already have an account?'
	///
	/// id: 'Sudah punya akun?'
	String get already_have_account => 'Already have an account?';

	/// en: 'Name'
	///
	/// id: 'Nama'
	String get name => 'Name';

	/// en: 'Confirm Password'
	///
	/// id: 'Konfirmasi Kata Sandi'
	String get confirm_password => 'Confirm Password';

	/// en: 'Passwords do not match'
	///
	/// id: 'Kata sandi tidak cocok'
	String get passwords_do_not_match => 'Passwords do not match';

	/// en: 'Enter your name'
	///
	/// id: 'Masukkan nama Anda'
	String get enter_your_name => 'Enter your name';

	/// en: 'Enter your email'
	///
	/// id: 'Masukkan email Anda'
	String get enter_your_email => 'Enter your email';

	/// en: 'Enter your password'
	///
	/// id: 'Masukkan kata sandi Anda'
	String get enter_your_password => 'Enter your password';

	/// en: 'Confirm your password'
	///
	/// id: 'Konfirmasi kata sandi Anda'
	String get confirm_your_password => 'Confirm your password';

	/// en: 'Enter your email address and we'll send you a link to reset your password'
	///
	/// id: 'Masukkan alamat email Anda dan kami akan mengirimkan tautan untuk mengatur ulang kata sandi Anda'
	String get forgot_password_description => 'Enter your email address and we\'ll send you a link to reset your password';

	/// en: 'Send Reset Link'
	///
	/// id: 'Kirim Tautan Reset'
	String get send_reset_link => 'Send Reset Link';

	/// en: 'Remember your password?'
	///
	/// id: 'Ingat kata sandi Anda?'
	String get remember_password => 'Remember your password?';

	/// en: 'Back to Login'
	///
	/// id: 'Kembali ke Login'
	String get back_to_login => 'Back to Login';
}

// Path: validation
class TranslationsValidationEn {
	TranslationsValidationEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'This field is required'
	///
	/// id: 'Field ini wajib diisi'
	String get required => 'This field is required';

	/// en: 'Please enter a valid email'
	///
	/// id: 'Masukkan email yang valid'
	String get email_invalid => 'Please enter a valid email';

	/// en: 'Password must be at least 6 characters'
	///
	/// id: 'Kata sandi minimal 6 karakter'
	String get password_too_short => 'Password must be at least 6 characters';

	/// en: 'Password must be less than 50 characters'
	///
	/// id: 'Kata sandi maksimal 50 karakter'
	String get password_too_long => 'Password must be less than 50 characters';

	/// en: 'This field is required'
	///
	/// id: 'Field ini wajib diisi'
	String get validation_required => 'This field is required';

	/// en: 'Please enter a valid email'
	///
	/// id: 'Masukkan email yang valid'
	String get validation_email_invalid => 'Please enter a valid email';

	/// en: 'Password must be at least 6 characters'
	///
	/// id: 'Kata sandi minimal 6 karakter'
	String get validation_password_too_short => 'Password must be at least 6 characters';
}

// Path: messages
class TranslationsMessagesEn {
	TranslationsMessagesEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Login successful'
	///
	/// id: 'Login berhasil'
	String get login_success => 'Login successful';

	/// en: 'Login failed'
	///
	/// id: 'Login gagal'
	String get login_failed => 'Login failed';

	/// en: 'Registration successful'
	///
	/// id: 'Pendaftaran berhasil'
	String get register_success => 'Registration successful';

	/// en: 'Registration failed'
	///
	/// id: 'Pendaftaran gagal'
	String get register_failed => 'Registration failed';

	/// en: 'Network error. Please check your connection.'
	///
	/// id: 'Error jaringan. Periksa koneksi Anda.'
	String get network_error => 'Network error. Please check your connection.';

	/// en: 'An unknown error occurred'
	///
	/// id: 'Terjadi error yang tidak diketahui'
	String get unknown_error => 'An unknown error occurred';

	/// en: 'Password reset email sent to {email}'
	///
	/// id: 'Email reset kata sandi telah dikirim ke {email}'
	String get password_reset_email_sent => 'Password reset email sent to {email}';
}

// Path: common
class TranslationsCommonEn {
	TranslationsCommonEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'OK'
	///
	/// id: 'OK'
	String get ok => 'OK';

	/// en: 'Cancel'
	///
	/// id: 'Batal'
	String get cancel => 'Cancel';

	/// en: 'Save'
	///
	/// id: 'Simpan'
	String get save => 'Save';

	/// en: 'Delete'
	///
	/// id: 'Hapus'
	String get delete => 'Delete';

	/// en: 'Edit'
	///
	/// id: 'Edit'
	String get edit => 'Edit';

	/// en: 'Loading...'
	///
	/// id: 'Memuat...'
	String get loading => 'Loading...';

	/// en: 'Retry'
	///
	/// id: 'Coba Lagi'
	String get retry => 'Retry';

	/// en: 'Close'
	///
	/// id: 'Tutup'
	String get close => 'Close';
}

// Path: home
class TranslationsHomeEn {
	TranslationsHomeEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Home'
	///
	/// id: 'Beranda'
	String get title => 'Home';

	/// en: 'What would you like to do today? 🎯'
	///
	/// id: 'Apa yang ingin Anda lakukan hari ini? 🎯'
	String get welcome_message => 'What would you like to do today? 🎯';

	/// en: 'Select the available features below'
	///
	/// id: 'Pilih fitur yang tersedia di bawah ini'
	String get select_feature => 'Select the available features below';

	/// en: 'An error occurred'
	///
	/// id: 'Terjadi kesalahan'
	String get error_occurred => 'An error occurred';

	/// en: 'No menu in category {category}'
	///
	/// id: 'Tidak ada menu dalam kategori {category}'
	String get no_menu_in_category => 'No menu in category {category}';

	/// en: 'No menu available'
	///
	/// id: 'Tidak ada menu tersedia'
	String get no_menu_available => 'No menu available';

	/// en: 'Contact administrator to access this feature'
	///
	/// id: 'Hubungi administrator untuk mengakses fitur ini'
	String get contact_admin => 'Contact administrator to access this feature';

	/// en: 'You have {count} items that need to be handled'
	///
	/// id: 'Anda memiliki {count} item yang perlu ditangani'
	String get you_have_pending_items => 'You have {count} items that need to be handled';

	/// en: 'Welcome back! 👋'
	///
	/// id: 'Selamat Datang! 👋'
	String get welcome_back => 'Welcome back! 👋';

	/// en: 'Management'
	///
	/// id: 'Manajemen'
	String get management => 'Management';

	/// en: 'Operations'
	///
	/// id: 'Operasional'
	String get operations => 'Operations';

	/// en: 'Reports'
	///
	/// id: 'Laporan'
	String get reports => 'Reports';

	/// en: 'Settings'
	///
	/// id: 'Pengaturan'
	String get settings => 'Settings';

	/// en: 'All Menu'
	///
	/// id: 'Semua Menu'
	String get all_menu => 'All Menu';

	/// en: 'Logout'
	///
	/// id: 'Keluar'
	String get logout => 'Logout';

	/// en: 'Dashboard'
	///
	/// id: 'Dashboard'
	String get menu_dashboard => 'Dashboard';

	/// en: 'View overview and statistics'
	///
	/// id: 'Lihat overview dan statistik'
	String get menu_dashboard_description => 'View overview and statistics';

	/// en: 'Brand'
	///
	/// id: 'Brand'
	String get menu_brand => 'Brand';

	/// en: 'Manage brands and branches'
	///
	/// id: 'Kelola brand dan cabang'
	String get menu_brand_description => 'Manage brands and branches';

	/// en: 'Orders'
	///
	/// id: 'Pesanan'
	String get menu_orders => 'Orders';

	/// en: 'Manage customer orders'
	///
	/// id: 'Kelola pesanan customer'
	String get menu_orders_description => 'Manage customer orders';

	/// en: 'Products'
	///
	/// id: 'Produk'
	String get menu_products => 'Products';

	/// en: 'Manage products and inventory'
	///
	/// id: 'Kelola produk dan inventory'
	String get menu_products_description => 'Manage products and inventory';

	/// en: 'Customers'
	///
	/// id: 'Pelanggan'
	String get menu_customers => 'Customers';

	/// en: 'Manage customer data'
	///
	/// id: 'Kelola data pelanggan'
	String get menu_customers_description => 'Manage customer data';

	/// en: 'Reports'
	///
	/// id: 'Laporan'
	String get menu_reports => 'Reports';

	/// en: 'View sales reports'
	///
	/// id: 'Lihat laporan penjualan'
	String get menu_reports_description => 'View sales reports';

	/// en: 'Finance'
	///
	/// id: 'Keuangan'
	String get menu_finance => 'Finance';

	/// en: 'Manage finance and payments'
	///
	/// id: 'Kelola keuangan dan pembayaran'
	String get menu_finance_description => 'Manage finance and payments';

	/// en: 'Settings'
	///
	/// id: 'Pengaturan'
	String get menu_settings => 'Settings';

	/// en: 'System settings'
	///
	/// id: 'Pengaturan sistem'
	String get menu_settings_description => 'System settings';

	/// en: 'Notifications'
	///
	/// id: 'Notifikasi'
	String get menu_notifications => 'Notifications';

	/// en: 'Notification center'
	///
	/// id: 'Pusat notifikasi'
	String get menu_notifications_description => 'Notification center';
}

// Path: brand
class TranslationsBrandEn {
	TranslationsBrandEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Create New Brand'
	///
	/// id: 'Buat Brand Baru'
	String get create_brand => 'Create New Brand';

	/// en: 'Edit Brand'
	///
	/// id: 'Edit Brand'
	String get edit_brand => 'Edit Brand';

	/// en: 'Select Brand'
	///
	/// id: 'Pilih Brand'
	String get brand_selection => 'Select Brand';

	/// en: 'Brand Statistics'
	///
	/// id: 'Statistik Brand'
	String get brand_stats => 'Brand Statistics';

	/// en: 'Manage Invitations'
	///
	/// id: 'Kelola Undangan'
	String get manage_invitations_page => 'Manage Invitations';

	/// en: 'Transfer Ownership'
	///
	/// id: 'Transfer Kepemilikanan'
	String get transfer_ownership => 'Transfer Ownership';

	/// en: 'Brand Information'
	///
	/// id: 'Informasi Brand'
	String get brand_info => 'Brand Information';

	/// en: 'Brand Name'
	///
	/// id: 'Nama Brand'
	String get brand_name => 'Brand Name';

	/// en: 'Enter brand name'
	///
	/// id: 'Masukkan nama brand'
	String get enter_brand_name => 'Enter brand name';

	/// en: 'Slug'
	///
	/// id: 'Slug'
	String get slug => 'Slug';

	/// en: 'URL-friendly identifier'
	///
	/// id: 'URL-friendly identifier'
	String get url_friendly_identifier => 'URL-friendly identifier';

	/// en: 'Description'
	///
	/// id: 'Deskripsi'
	String get description => 'Description';

	/// en: 'Brief brand description (optional)'
	///
	/// id: 'Deskripsi singkat brand (opsional)'
	String get brand_description => 'Brief brand description (optional)';

	/// en: 'Industry'
	///
	/// id: 'Industri'
	String get industry => 'Industry';

	/// en: 'Brand industry (optional)'
	///
	/// id: 'Industri brand (opsional)'
	String get brand_industry => 'Brand industry (optional)';

	/// en: 'Business Type'
	///
	/// id: 'Tipe Bisnis'
	String get business_type => 'Business Type';

	/// en: 'Timezone'
	///
	/// id: 'Zona Waktu'
	String get timezone => 'Timezone';

	/// en: 'Currency'
	///
	/// id: 'Mata Uang'
	String get currency => 'Currency';

	/// en: 'Auto-generate from name'
	///
	/// id: 'Auto-generate dari nama'
	String get auto_generate_from_name => 'Auto-generate from name';

	/// en: 'Enable manual slug input'
	///
	/// id: 'Enable manual slug input'
	String get enable_manual_slug_input => 'Enable manual slug input';

	/// en: 'Auto-generate from name'
	///
	/// id: 'Auto-generate dari nama'
	String get auto_generate_from_name_tooltip => 'Auto-generate from name';

	/// en: 'Service'
	///
	/// id: 'Layanan'
	String get service => 'Service';

	/// en: 'Retail'
	///
	/// id: 'Ritel'
	String get retail => 'Retail';

	/// en: 'Manufacturing'
	///
	/// id: 'Manufaktur'
	String get manufacturing => 'Manufacturing';

	/// en: 'Other'
	///
	/// id: 'Lainnya'
	String get other => 'Other';

	/// en: 'Asia/Jakarta (WIB)'
	///
	/// id: 'Asia/Jakarta (WIB)'
	String get timezone_jakarta => 'Asia/Jakarta (WIB)';

	/// en: 'Asia/Singapore (SGT)'
	///
	/// id: 'Asia/Singapore (SGT)'
	String get timezone_singapore => 'Asia/Singapore (SGT)';

	/// en: 'Asia/Bangkok (ICT)'
	///
	/// id: 'Asia/Bangkok (ICT)'
	String get timezone_bangkok => 'Asia/Bangkok (ICT)';

	/// en: 'Asia/Kuala Lumpur (MYT)'
	///
	/// id: 'Asia/Kuala Lumpur (MYT)'
	String get timezone_kuala_lumpur => 'Asia/Kuala Lumpur (MYT)';

	/// en: 'Asia/Manila (PHT)'
	///
	/// id: 'Asia/Manila (PHT)'
	String get timezone_manila => 'Asia/Manila (PHT)';

	/// en: 'UTC'
	///
	/// id: 'UTC'
	String get timezone_utc => 'UTC';

	/// en: 'Indonesian Rupiah (IDR)'
	///
	/// id: 'Rupiah Indonesia (IDR)'
	String get currency_idr => 'Indonesian Rupiah (IDR)';

	/// en: 'US Dollar (USD)'
	///
	/// id: 'US Dollar (USD)'
	String get currency_usd => 'US Dollar (USD)';

	/// en: 'Euro (EUR)'
	///
	/// id: 'Euro (EUR)'
	String get currency_eur => 'Euro (EUR)';

	/// en: 'Singapore Dollar (SGD)'
	///
	/// id: 'Singapore Dollar (SGD)'
	String get currency_sgd => 'Singapore Dollar (SGD)';

	/// en: 'Malaysian Ringgit (MYR)'
	///
	/// id: 'Malaysian Ringgit (MYR)'
	String get currency_myr => 'Malaysian Ringgit (MYR)';

	/// en: 'Thai Baht (THB)'
	///
	/// id: 'Thai Baht (THB)'
	String get currency_thb => 'Thai Baht (THB)';

	/// en: 'Philippine Peso (PHP)'
	///
	/// id: 'Philippine Peso (PHP)'
	String get currency_php => 'Philippine Peso (PHP)';

	/// en: 'Create Brand'
	///
	/// id: 'Buat Brand'
	String get create_brand_btn => 'Create Brand';

	/// en: 'Update Brand'
	///
	/// id: 'Perbarui Brand'
	String get update_brand_btn => 'Update Brand';

	/// en: 'Send Confirmation Code'
	///
	/// id: 'Kirim Kode Konfirmasi'
	String get send_confirmation_code => 'Send Confirmation Code';

	/// en: 'Confirm Transfer'
	///
	/// id: 'Konfirmasi Transfer'
	String get confirm_transfer => 'Confirm Transfer';

	/// en: 'Send Invitation'
	///
	/// id: 'Kirim Undangan'
	String get send_invitation => 'Send Invitation';

	/// en: 'Invite User'
	///
	/// id: 'Undang Pengguna'
	String get invite_user => 'Invite User';

	/// en: 'Brand created successfully'
	///
	/// id: 'Brand berhasil dibuat'
	String get brand_created_successfully => 'Brand created successfully';

	/// en: 'Brand updated successfully'
	///
	/// id: 'Brand berhasil diperbarui'
	String get brand_updated_successfully => 'Brand updated successfully';

	/// en: 'Brand deleted successfully'
	///
	/// id: 'Brand berhasil dihapus'
	String get brand_deleted_successfully => 'Brand deleted successfully';

	/// en: 'Invitation sent successfully'
	///
	/// id: 'Undangan berhasil dikirim'
	String get invitation_sent_successfully => 'Invitation sent successfully';

	/// en: 'Confirmation code has been sent to the new owner's email'
	///
	/// id: 'Kode konfirmasi telah dikirim ke email pemilik baru'
	String get confirmation_code_sent => 'Confirmation code has been sent to the new owner\'s email';

	/// en: 'Brand ownership transferred successfully'
	///
	/// id: 'Kepemilikanan brand berhasil ditransfer'
	String get transfer_completed_successfully => 'Brand ownership transferred successfully';

	/// en: 'Brand name is required'
	///
	/// id: 'Nama brand wajib diisi'
	String get brand_name_required => 'Brand name is required';

	/// en: 'Brand name must be at least 3 characters'
	///
	/// id: 'Nama brand minimal 3 karakter'
	String get brand_name_min_length => 'Brand name must be at least 3 characters';

	/// en: 'Brand name must be less than 50 characters'
	///
	/// id: 'Nama brand maksimal 50 karakter'
	String get brand_name_max_length => 'Brand name must be less than 50 characters';

	/// en: 'Slug is required'
	///
	/// id: 'Slug wajib diisi'
	String get slug_required => 'Slug is required';

	/// en: 'Slug must be at least 3 characters'
	///
	/// id: 'Slug minimal 3 karakter'
	String get slug_min_length => 'Slug must be at least 3 characters';

	/// en: 'Slug must be less than 50 characters'
	///
	/// id: 'Slug maksimal 50 karakter'
	String get slug_max_length => 'Slug must be less than 50 characters';

	/// en: 'Slug can only contain lowercase letters, numbers, and hyphens (-)'
	///
	/// id: 'Slug hanya boleh mengandung huruf kecil, angka, dan strip (-)'
	String get slug_invalid_characters => 'Slug can only contain lowercase letters, numbers, and hyphens (-)';

	/// en: 'Description must be less than 500 characters'
	///
	/// id: 'Deskripsi maksimal 500 karakter'
	String get description_max_length => 'Description must be less than 500 characters';

	/// en: 'Industry must be less than 100 characters'
	///
	/// id: 'Industri maksimal 100 karakter'
	String get industry_max_length => 'Industry must be less than 100 characters';

	/// en: 'Email is required'
	///
	/// id: 'Email wajib diisi'
	String get email_required => 'Email is required';

	/// en: 'Please enter a valid email'
	///
	/// id: 'Format email tidak valid'
	String get email_invalid => 'Please enter a valid email';

	/// en: 'Confirmation code is required'
	///
	/// id: 'Kode konfirmasi wajib diisi'
	String get confirmation_code_required => 'Confirmation code is required';

	/// en: 'Confirmation code must be 6 digits'
	///
	/// id: 'Kode konfirmasi harus 6 digit'
	String get confirmation_code_length => 'Confirmation code must be 6 digits';

	/// en: 'Edit Brand'
	///
	/// id: 'Edit Brand'
	String get edit_brand_dialog_title => 'Edit Brand';

	/// en: 'Do you want to edit this brand?'
	///
	/// id: 'Apakah Anda ingin mengedit brand ini?'
	String get edit_brand_dialog_message => 'Do you want to edit this brand?';

	/// en: 'Delete Brand'
	///
	/// id: 'Hapus Brand'
	String get delete_brand_dialog_title => 'Delete Brand';

	/// en: 'Are you sure you want to delete this brand?'
	///
	/// id: 'Apakah Anda yakin ingin menghapus brand ini?'
	String get delete_brand_dialog_message => 'Are you sure you want to delete this brand?';

	/// en: 'This action cannot be undone.'
	///
	/// id: 'Tindakan ini tidak dapat dibatalkan.'
	String get delete_brand_warning => 'This action cannot be undone.';

	/// en: 'Accept Invitation'
	///
	/// id: 'Terima Undangan'
	String get accept_invitation_dialog_title => 'Accept Invitation';

	/// en: 'Are you sure you want to accept the invitation to join {brandName}?'
	///
	/// id: 'Apakah Anda yakin ingin menerima undangan untuk bergabung dengan {brandName}?'
	String get accept_invitation_dialog_message => 'Are you sure you want to accept the invitation to join {brandName}?';

	/// en: 'You will be added to the brand with the role of {role}.'
	///
	/// id: 'Anda akan ditambahkan ke brand dengan peran {role}.'
	String get accept_invitation_role_info => 'You will be added to the brand with the role of {role}.';

	/// en: 'Decline Invitation'
	///
	/// id: 'Tolak Undangan'
	String get decline_invitation_dialog_title => 'Decline Invitation';

	/// en: 'Are you sure you want to decline the invitation from {brandName}?'
	///
	/// id: 'Apakah Anda yakin ingin menolak undangan dari {brandName}?'
	String get decline_invitation_dialog_message => 'Are you sure you want to decline the invitation from {brandName}?';

	/// en: 'Cancel Invitation'
	///
	/// id: 'Batalkan Undangan'
	String get cancel_invitation_dialog_title => 'Cancel Invitation';

	/// en: 'Are you sure you want to cancel the invitation to {email}?'
	///
	/// id: 'Apakah Anda yakin ingin membatalkan undangan ke {email}?'
	String get cancel_invitation_dialog_message => 'Are you sure you want to cancel the invitation to {email}?';

	/// en: 'NEW'
	///
	/// id: 'BARU'
	String get kNew => 'NEW';

	/// en: 'Active'
	///
	/// id: 'Aktif'
	String get active => 'Active';

	/// en: 'Brand Active'
	///
	/// id: 'Brand Aktif'
	String get brand_active => 'Brand Active';

	/// en: 'Joined: {date}'
	///
	/// id: 'Bergabung: {date}'
	String get joined => 'Joined: {date}';

	/// en: 'Status'
	///
	/// id: 'Status'
	String get status => 'Status';

	/// en: 'Created'
	///
	/// id: 'Dibuat'
	String get created => 'Created';

	/// en: 'Total Users'
	///
	/// id: 'Total Pengguna'
	String get total_users => 'Total Users';

	/// en: 'Active Branches'
	///
	/// id: 'Cabang Aktif'
	String get active_branches => 'Active Branches';

	/// en: 'Monthly Revenue'
	///
	/// id: 'Pendapatan Bulan Ini'
	String get monthly_revenue => 'Monthly Revenue';

	/// en: 'Growth'
	///
	/// id: 'Pertumbuhan'
	String get growth => 'Growth';

	/// en: 'Invitations Sent'
	///
	/// id: 'Undangan Terkirim'
	String get invitations_sent => 'Invitations Sent';

	/// en: 'Weekly Activity'
	///
	/// id: 'Aktivitas Minggu Ini'
	String get weekly_activity => 'Weekly Activity';

	/// en: 'Performance Score'
	///
	/// id: 'Skor Kinerja'
	String get performance_score => 'Performance Score';

	/// en: 'Active: {count}'
	///
	/// id: 'Aktif: {count}'
	String get active_users => 'Active: {count}';

	/// en: 'Total: {count}'
	///
	/// id: 'Total: {count}'
	String get total_branches => 'Total: {count}';

	/// en: 'Target: {amount}'
	///
	/// id: 'Target: {amount}'
	String get revenue_target => 'Target: {amount}';

	/// en: 'Compare last month'
	///
	/// id: 'Banding bulan lalu'
	String get compare_last_month => 'Compare last month';

	/// en: '{pending} pending, {accepted} accepted'
	///
	/// id: '{pending} tertunda, {accepted} diterima'
	String get pending_invitations => '{pending} pending, {accepted} accepted';

	/// en: 'Average: {count}/day'
	///
	/// id: 'Rata-rata: {count}/hari'
	String get daily_average => 'Average: {count}/day';

	/// en: 'Very Good'
	///
	/// id: 'Sangat Baik'
	String get very_good => 'Very Good';

	/// en: 'Search brand...'
	///
	/// id: 'Cari brand...'
	String get search_brand => 'Search brand...';

	/// en: 'Search Results'
	///
	/// id: 'Hasil Pencarian'
	String get search_results => 'Search Results';

	/// en: 'Type'
	///
	/// id: 'Tipe'
	String get type => 'Type';

	/// en: 'All'
	///
	/// id: 'Semua'
	String get all => 'All';

	/// en: 'Loading brands...'
	///
	/// id: 'Memuat brands...'
	String get loading_brands => 'Loading brands...';

	/// en: 'No brands available'
	///
	/// id: 'Belum ada brand'
	String get no_brands_available => 'No brands available';

	/// en: 'Create your first brand to start your business'
	///
	/// id: 'Buat brand pertama untuk memulai bisnis Anda'
	String get no_brands_message => 'Create your first brand to start your business';

	/// en: 'Start by creating your first brand to manage your business efficiently'
	///
	/// id: 'Mulai dengan membuat brand pertama Anda untuk mengelola bisnis secara efisien'
	String get create_first_brand_message => 'Start by creating your first brand to manage your business efficiently';

	/// en: 'Create New Brand'
	///
	/// id: 'Buat Brand Baru'
	String get create_new_brand => 'Create New Brand';

	/// en: 'Statistics'
	///
	/// id: 'Statistik'
	String get statistics => 'Statistics';

	/// en: 'Invitations'
	///
	/// id: 'Undangan'
	String get invitations => 'Invitations';

	/// en: 'Transfer'
	///
	/// id: 'Transfer'
	String get transfer => 'Transfer';

	/// en: 'View Statistics'
	///
	/// id: 'Lihat Statistik'
	String get view_statistics => 'View Statistics';

	/// en: 'Manage Invitations'
	///
	/// id: 'Kelola Undangan'
	String get manage_invitations => 'Manage Invitations';

	/// en: 'Transfer Brand'
	///
	/// id: 'Transfer Brand'
	String get transfer_brand => 'Transfer Brand';

	/// en: 'Received'
	///
	/// id: 'Diterima'
	String get received => 'Received';

	/// en: 'Sent'
	///
	/// id: 'Terkirim'
	String get sent => 'Sent';

	/// en: 'No received invitations'
	///
	/// id: 'Belum ada undangan yang diterima'
	String get no_received_invitations => 'No received invitations';

	/// en: 'You haven't received any brand invitations. Received invitations will appear here.'
	///
	/// id: 'Anda belum menerima undangan brand apa pun. Undangan yang diterima akan muncul di sini.'
	String get no_received_invitations_message => 'You haven\'t received any brand invitations. Received invitations will appear here.';

	/// en: 'No sent invitations'
	///
	/// id: 'Belum ada undangan terkirim'
	String get no_sent_invitations => 'No sent invitations';

	/// en: 'You haven't sent any brand invitations. Sent invitations will appear here.'
	///
	/// id: 'Anda belum mengirim undangan brand apa pun. Undangan yang terkirim akan muncul di sini.'
	String get no_sent_invitations_message => 'You haven\'t sent any brand invitations. Sent invitations will appear here.';

	/// en: 'Failed to load invitations'
	///
	/// id: 'Gagal memuat undangan'
	String get failed_to_load_invitations => 'Failed to load invitations';

	/// en: 'An error occurred while loading received invitations. Please try again.'
	///
	/// id: 'Terjadi kesalahan saat memuat undangan yang diterima. Silakan coba lagi.'
	String get failed_to_load_received_invitations => 'An error occurred while loading received invitations. Please try again.';

	/// en: 'An error occurred while loading sent invitations. Please try again.'
	///
	/// id: 'Terjadi kesalahan saat memuat undangan terkirim. Silakan coba lagi.'
	String get failed_to_load_sent_invitations => 'An error occurred while loading sent invitations. Please try again.';

	/// en: 'Invitation Details'
	///
	/// id: 'Detail Undangan'
	String get invitation_details => 'Invitation Details';

	/// en: 'Brand'
	///
	/// id: 'Brand'
	String get brand_label => 'Brand';

	/// en: 'From'
	///
	/// id: 'Dari'
	String get from_label => 'From';

	/// en: 'To'
	///
	/// id: 'Ke'
	String get to_label => 'To';

	/// en: 'Role'
	///
	/// id: 'Peran'
	String get role_label => 'Role';

	/// en: 'Sent'
	///
	/// id: 'Dikirim'
	String get sent_label => 'Sent';

	/// en: 'Expires'
	///
	/// id: 'Kadaluarsa'
	String get expires_label => 'Expires';

	/// en: 'Close'
	///
	/// id: 'Tutup'
	String get close_label => 'Close';

	/// en: 'Invite New User'
	///
	/// id: 'Undang Pengguna Baru'
	String get invite_new_user => 'Invite New User';

	/// en: 'Invite New User'
	///
	/// id: 'Undang Pengguna Baru'
	String get invite_new_user_tooltip => 'Invite New User';

	/// en: 'Accept'
	///
	/// id: 'Terima'
	String get accept => 'Accept';

	/// en: 'Decline'
	///
	/// id: 'Tolak'
	String get decline => 'Decline';

	/// en: 'Cancel'
	///
	/// id: 'Batal'
	String get cancel => 'Cancel';

	/// en: 'Resend'
	///
	/// id: 'Kirim Ulang'
	String get resend => 'Resend';

	/// en: 'Reject'
	///
	/// id: 'Tolak'
	String get reject => 'Reject';

	/// en: 'Pending'
	///
	/// id: 'Pending'
	String get pending => 'Pending';

	/// en: 'Accepted'
	///
	/// id: 'Diterima'
	String get accepted => 'Accepted';

	/// en: 'Declined'
	///
	/// id: 'Ditolak'
	String get declined => 'Declined';

	/// en: 'Expired'
	///
	/// id: 'Kadaluarsa'
	String get expired => 'Expired';

	/// en: 'Brand Owner'
	///
	/// id: 'Pemilik Brand'
	String get brand_owner => 'Brand Owner';

	/// en: 'Brand Admin'
	///
	/// id: 'Admin Brand'
	String get brand_admin => 'Brand Admin';

	/// en: 'Branch Manager'
	///
	/// id: 'Manajer Cabang'
	String get branch_manager => 'Branch Manager';

	/// en: 'Branch Admin'
	///
	/// id: 'Admin Cabang'
	String get branch_admin => 'Branch Admin';

	/// en: 'Branch Staff'
	///
	/// id: 'Staf Cabang'
	String get branch_staff => 'Branch Staff';

	/// en: 'Cross Branch Viewer'
	///
	/// id: 'Penonton Lintas Cabang'
	String get cross_branch_viewer => 'Cross Branch Viewer';

	/// en: 'Ownership Transfer Warning'
	///
	/// id: 'Peringatan Transfer Kepemilikanan'
	String get transfer_ownership_warning => 'Ownership Transfer Warning';

	/// en: 'This action cannot be undone and will permanently change the brand ownership. Make sure you enter the correct email and the new owner has approved this transfer.'
	///
	/// id: 'Tindakan ini tidak dapat dibatalkan dan akan mengubah kepemilikanan brand secara permanen. Pastikan Anda memasukkan email yang benar dan pemilik baru telah menyetujui transfer ini.'
	String get transfer_warning_message => 'This action cannot be undone and will permanently change the brand ownership. Make sure you enter the correct email and the new owner has approved this transfer.';

	/// en: 'New Owner Email'
	///
	/// id: 'Email Pemilik Baru'
	String get new_owner_email => 'New Owner Email';

	/// en: 'Enter new owner email'
	///
	/// id: 'Masukkan email pemilik baru'
	String get enter_new_owner_email => 'Enter new owner email';

	/// en: 'example: user@example.com'
	///
	/// id: 'contoh: user@example.com'
	String get example_email => 'example: user@example.com';

	/// en: 'Confirmation Code'
	///
	/// id: 'Kode Konfirmasi'
	String get confirmation_code => 'Confirmation Code';

	/// en: 'Enter confirmation code'
	///
	/// id: 'Masukkan kode konfirmasi'
	String get enter_confirmation_code => 'Enter confirmation code';

	/// en: '6-digit code'
	///
	/// id: 'Kode 6 digit'
	String get six_digit_code => '6-digit code';

	/// en: 'Message (Optional)'
	///
	/// id: 'Pesan (Opsional)'
	String get message_optional => 'Message (Optional)';

	/// en: 'Message for new owner'
	///
	/// id: 'Pesan untuk pemilik baru'
	String get message_for_new_owner => 'Message for new owner';

	/// en: 'Add an explanation message if needed'
	///
	/// id: 'Tambahkan pesan penjelasan jika diperlukan'
	String get add_explanation_message => 'Add an explanation message if needed';

	/// en: 'Detail Transfer'
	///
	/// id: 'Detail Transfer'
	String get detail_transfer => 'Detail Transfer';

	/// en: 'Brand ID: {id}'
	///
	/// id: 'Brand ID: {id}'
	String get brand_id_label => 'Brand ID: {id}';

	/// en: 'No brands available'
	///
	/// id: 'Tidak ada brand tersedia'
	String get no_brands_available_selector => 'No brands available';

	/// en: 'Select Brand'
	///
	/// id: 'Pilih Brand'
	String get select_brand => 'Select Brand';

	/// en: 'Currently:'
	///
	/// id: 'Saat ini:'
	String get currently => 'Currently:';

	/// en: 'Back'
	///
	/// id: 'Kembali'
	String get back => 'Back';

	/// en: 'Refresh'
	///
	/// id: 'Refresh'
	String get refresh => 'Refresh';

	/// en: 'Brand not found'
	///
	/// id: 'Brand tidak ditemukan'
	String get brand_not_found => 'Brand not found';

	/// en: 'Navigating to stats for {brandName}'
	///
	/// id: 'Menavigasi ke statistik untuk {brandName}'
	String get navigating_to_stats => 'Navigating to stats for {brandName}';

	/// en: 'Navigating to invitations for {brandName}'
	///
	/// id: 'Menavigasi ke undangan untuk {brandName}'
	String get navigating_to_invitations => 'Navigating to invitations for {brandName}';

	/// en: 'Navigating to transfer for {brandName}'
	///
	/// id: 'Menavigasi ke transfer untuk {brandName}'
	String get navigating_to_transfer => 'Navigating to transfer for {brandName}';

	/// en: 'Loading brand details...'
	///
	/// id: 'Memuat detail brand...'
	String get loading_brand_details => 'Loading brand details...';

	/// en: 'Enter brand name'
	///
	/// id: 'Masukkan nama brand'
	String get brand_name_hint => 'Enter brand name';

	/// en: 'URL-friendly identifier'
	///
	/// id: 'URL-friendly identifier'
	String get slug_hint => 'URL-friendly identifier';

	/// en: 'Brief brand description (optional)'
	///
	/// id: 'Deskripsi singkat brand (opsional)'
	String get description_hint => 'Brief brand description (optional)';

	/// en: 'Brand industry (optional)'
	///
	/// id: 'Industri brand (opsional)'
	String get industry_hint => 'Brand industry (optional)';

	/// en: 'Enter new owner email'
	///
	/// id: 'Masukkan email pemilik baru'
	String get new_owner_email_hint => 'Enter new owner email';

	/// en: 'Enter confirmation code'
	///
	/// id: 'Masukkan kode konfirmasi'
	String get confirmation_code_hint => 'Enter confirmation code';

	/// en: 'example: user@example.com'
	///
	/// id: 'contoh: user@example.com'
	String get email_example => 'example: user@example.com';

	/// en: 'Message for new owner'
	///
	/// id: 'Pesan untuk pemilik baru'
	String get message_hint => 'Message for new owner';

	/// en: 'Add an explanation message if needed'
	///
	/// id: 'Tambahkan pesan penjelasan jika diperlukan'
	String get message_explanation => 'Add an explanation message if needed';

	/// en: 'Enter email of user to invite'
	///
	/// id: 'Masukkan email pengguna yang ingin diundang'
	String get user_email_hint => 'Enter email of user to invite';

	/// en: 'example: user@example.com'
	///
	/// id: 'contoh: user@example.com'
	String get user_email_example => 'example: user@example.com';

	/// en: 'Personal message for user (optional)'
	///
	/// id: 'Pesan personal untuk pengguna (opsional)'
	String get personal_message_hint => 'Personal message for user (optional)';

	/// en: 'Add a personal message if needed'
	///
	/// id: 'Tambahkan pesan personal jika diperlukan'
	String get personal_message_explanation => 'Add a personal message if needed';

	/// en: 'Select role'
	///
	/// id: 'Pilih peran'
	String get select_role_hint => 'Select role';

	/// en: 'Service'
	///
	/// id: 'Layanan'
	String get business_type_service => 'Service';

	/// en: 'Retail'
	///
	/// id: 'Ritel'
	String get business_type_retail => 'Retail';

	/// en: 'Manufacturing'
	///
	/// id: 'Manufaktur'
	String get business_type_manufacturing => 'Manufacturing';

	/// en: 'Other'
	///
	/// id: 'Lainnya'
	String get business_type_other => 'Other';

	/// en: 'Basic'
	///
	/// id: 'Dasar'
	String get subscription_tier_basic => 'Basic';

	/// en: 'Pro'
	///
	/// id: 'Pro'
	String get subscription_tier_pro => 'Pro';

	/// en: 'Enterprise'
	///
	/// id: 'Enterprise'
	String get subscription_tier_enterprise => 'Enterprise';

	/// en: 'Active'
	///
	/// id: 'Aktif'
	String get subscription_status_active => 'Active';

	/// en: 'Inactive'
	///
	/// id: 'Tidak Aktif'
	String get subscription_status_inactive => 'Inactive';

	/// en: 'Suspended'
	///
	/// id: 'Ditangguhkan'
	String get subscription_status_suspended => 'Suspended';

	/// en: 'Cancelled'
	///
	/// id: 'Dibatalkan'
	String get subscription_status_cancelled => 'Cancelled';

	/// en: 'Owner'
	///
	/// id: 'Pemilik'
	String get role_owner => 'Owner';

	/// en: 'Admin'
	///
	/// id: 'Admin'
	String get role_admin => 'Admin';

	/// en: 'Manager'
	///
	/// id: 'Manajer'
	String get role_manager => 'Manager';

	/// en: 'Employee'
	///
	/// id: 'Karyawan'
	String get role_employee => 'Employee';

	/// en: 'Email'
	///
	/// id: 'Email'
	String get email_label => 'Email';

	/// en: 'Confirmation Code'
	///
	/// id: 'Kode Konfirmasi'
	String get confirmation_code_label => 'Confirmation Code';

	/// en: '6-digit code'
	///
	/// id: 'Kode 6 digit'
	String get six_digit_code_label => '6-digit code';

	/// en: 'User Email'
	///
	/// id: 'Email Pengguna'
	String get user_email_label => 'User Email';

	/// en: 'User Role'
	///
	/// id: 'Peran Pengguna'
	String get user_role_label => 'User Role';

	/// en: '(Optional)'
	///
	/// id: '(Opsional)'
	String get optional_label => '(Optional)';

	/// en: 'Back'
	///
	/// id: 'Kembali'
	String get back_button => 'Back';

	/// en: 'Refresh'
	///
	/// id: 'Refresh'
	String get refresh_button => 'Refresh';

	/// en: 'Edit'
	///
	/// id: 'Edit'
	String get edit_button => 'Edit';

	/// en: 'Delete'
	///
	/// id: 'Hapus'
	String get delete_button => 'Delete';

	/// en: 'Close'
	///
	/// id: 'Tutup'
	String get close_button => 'Close';

	/// en: 'Cancel'
	///
	/// id: 'Batal'
	String get cancel_button => 'Cancel';

	/// en: 'Accept'
	///
	/// id: 'Terima'
	String get accept_button => 'Accept';

	/// en: 'Decline'
	///
	/// id: 'Tolak'
	String get decline_button => 'Decline';

	/// en: 'Resend'
	///
	/// id: 'Kirim Ulang'
	String get resend_button => 'Resend';

	/// en: 'Brand Details'
	///
	/// id: 'Detail Brand'
	String get brand_details_title => 'Brand Details';

	/// en: 'Invitation Details'
	///
	/// id: 'Detail Undangan'
	String get invitation_details_title => 'Invitation Details';

	/// en: 'Are you sure you want to edit this brand?'
	///
	/// id: 'Apakah Anda ingin mengedit brand ini?'
	String get confirm_edit_brand => 'Are you sure you want to edit this brand?';

	/// en: 'Are you sure you want to delete this brand?'
	///
	/// id: 'Apakah Anda yakin ingin menghapus brand ini?'
	String get confirm_delete_brand => 'Are you sure you want to delete this brand?';

	/// en: 'Are you sure you want to accept the invitation to join {brandName}?'
	///
	/// id: 'Apakah Anda yakin ingin menerima undangan untuk bergabung dengan {brandName}?'
	String get confirm_accept_invitation => 'Are you sure you want to accept the invitation to join {brandName}?';

	/// en: 'Are you sure you want to decline the invitation from {brandName}?'
	///
	/// id: 'Apakah Anda yakin ingin menolak undangan dari {brandName}?'
	String get confirm_decline_invitation => 'Are you sure you want to decline the invitation from {brandName}?';

	/// en: 'Are you sure you want to cancel the invitation to {email}?'
	///
	/// id: 'Apakah Anda yakin ingin membatalkan undangan ke {email}?'
	String get confirm_cancel_invitation => 'Are you sure you want to cancel the invitation to {email}?';

	/// en: 'NEW'
	///
	/// id: 'BARU'
	String get new_label => 'NEW';

	/// en: 'Active'
	///
	/// id: 'Aktif'
	String get active_label => 'Active';

	/// en: 'Created'
	///
	/// id: 'Dibuat'
	String get created_label => 'Created';

	/// en: 'Joined: {date}'
	///
	/// id: 'Bergabung: {date}'
	String get joined_label => 'Joined: {date}';

	/// en: 'Total Users'
	///
	/// id: 'Total Pengguna'
	String get total_users_label => 'Total Users';

	/// en: 'Active Branches'
	///
	/// id: 'Cabang Aktif'
	String get active_branches_label => 'Active Branches';

	/// en: 'Monthly Revenue'
	///
	/// id: 'Pendapatan Bulanan'
	String get monthly_revenue_label => 'Monthly Revenue';

	/// en: 'Growth'
	///
	/// id: 'Pertumbuhan'
	String get growth_label => 'Growth';

	/// en: 'Invitations Sent'
	///
	/// id: 'Undangan Terkirim'
	String get invitations_sent_label => 'Invitations Sent';

	/// en: 'Weekly Activity'
	///
	/// id: 'Aktivitas Mingguan'
	String get weekly_activity_label => 'Weekly Activity';

	/// en: 'Performance Score'
	///
	/// id: 'Skor Kinerja'
	String get performance_score_label => 'Performance Score';

	/// en: 'Active: {count}'
	///
	/// id: 'Aktif: {count}'
	String get active_users_label => 'Active: {count}';

	/// en: 'Total: {count}'
	///
	/// id: 'Total: {count}'
	String get total_branches_label => 'Total: {count}';

	/// en: 'Target: {amount}'
	///
	/// id: 'Target: {amount}'
	String get revenue_target_label => 'Target: {amount}';

	/// en: 'Compare last month'
	///
	/// id: 'Banding bulan lalu'
	String get compare_last_month_label => 'Compare last month';

	/// en: '{pending} pending, {accepted} accepted'
	///
	/// id: '{pending} tertunda, {accepted} diterima'
	String get pending_invitations_label => '{pending} pending, {accepted} accepted';

	/// en: 'Average: {count}/day'
	///
	/// id: 'Rata-rata: {count}/hari'
	String get daily_average_label => 'Average: {count}/day';

	/// en: 'Very Good'
	///
	/// id: 'Sangat Baik'
	String get very_good_label => 'Very Good';

	/// en: 'Search brand...'
	///
	/// id: 'Cari brand...'
	String get search_hint => 'Search brand...';

	/// en: 'Search Results'
	///
	/// id: 'Hasil Pencarian'
	String get search_results_label => 'Search Results';

	/// en: 'Type'
	///
	/// id: 'Tipe'
	String get type_label => 'Type';

	/// en: 'All'
	///
	/// id: 'Semua'
	String get all_label => 'All';

	/// en: 'No brands available'
	///
	/// id: 'Tidak ada brand tersedia'
	String get no_brands_available_label => 'No brands available';

	/// en: 'Create your first brand to start your business'
	///
	/// id: 'Buat brand pertama untuk memulai bisnis Anda'
	String get no_brands_message_label => 'Create your first brand to start your business';

	/// en: 'Create New Brand'
	///
	/// id: 'Buat Brand Baru'
	String get create_new_brand_label => 'Create New Brand';

	/// en: 'Statistics'
	///
	/// id: 'Statistik'
	String get statistics_label => 'Statistics';

	/// en: 'Invitations'
	///
	/// id: 'Undangan'
	String get invitations_label => 'Invitations';

	/// en: 'Transfer'
	///
	/// id: 'Transfer'
	String get transfer_label => 'Transfer';

	/// en: 'View Statistics'
	///
	/// id: 'Lihat Statistik'
	String get view_statistics_label => 'View Statistics';

	/// en: 'Manage Invitations'
	///
	/// id: 'Kelola Undangan'
	String get manage_invitations_label => 'Manage Invitations';

	/// en: 'Transfer Brand'
	///
	/// id: 'Transfer Brand'
	String get transfer_brand_label => 'Transfer Brand';

	/// en: 'Received'
	///
	/// id: 'Diterima'
	String get received_label => 'Received';

	/// en: 'No received invitations'
	///
	/// id: 'Tidak ada undangan yang diterima'
	String get no_received_invitations_label => 'No received invitations';

	/// en: 'No sent invitations'
	///
	/// id: 'Tidak ada undangan terkirim'
	String get no_sent_invitations_label => 'No sent invitations';

	/// en: 'Failed to load invitations'
	///
	/// id: 'Gagal memuat undangan'
	String get failed_to_load_invitations_label => 'Failed to load invitations';

	/// en: 'An error occurred while loading received invitations. Please try again.'
	///
	/// id: 'Terjadi kesalahan saat memuat undangan yang diterima. Silakan coba lagi.'
	String get failed_to_load_received_invitations_label => 'An error occurred while loading received invitations. Please try again.';

	/// en: 'An error occurred while loading sent invitations. Please try again.'
	///
	/// id: 'Terjadi kesalahan saat memuat undangan terkirim. Silakan coba lagi.'
	String get failed_to_load_sent_invitations_label => 'An error occurred while loading sent invitations. Please try again.';

	/// en: 'Invitation Details'
	///
	/// id: 'Detail Undangan'
	String get invitation_details_label => 'Invitation Details';

	/// en: 'Invite New User'
	///
	/// id: 'Undang Pengguna Baru'
	String get invite_new_user_label => 'Invite New User';

	/// en: 'Pending'
	///
	/// id: 'Pending'
	String get pending_label => 'Pending';

	/// en: 'Accepted'
	///
	/// id: 'Diterima'
	String get accepted_label => 'Accepted';

	/// en: 'Declined'
	///
	/// id: 'Ditolak'
	String get declined_label => 'Declined';

	/// en: 'Expired'
	///
	/// id: 'Kadaluarsa'
	String get expired_label => 'Expired';

	/// en: 'Brand Owner'
	///
	/// id: 'Pemilik Brand'
	String get brand_owner_label => 'Brand Owner';

	/// en: 'Brand Admin'
	///
	/// id: 'Admin Brand'
	String get brand_admin_label => 'Brand Admin';

	/// en: 'Branch Manager'
	///
	/// id: 'Manajer Cabang'
	String get branch_manager_label => 'Branch Manager';

	/// en: 'Branch Admin'
	///
	/// id: 'Admin Cabang'
	String get branch_admin_label => 'Branch Admin';

	/// en: 'Branch Staff'
	///
	/// id: 'Staf Cabang'
	String get branch_staff_label => 'Branch Staff';

	/// en: 'Cross Branch Viewer'
	///
	/// id: 'Penonton Lintas Cabang'
	String get cross_branch_viewer_label => 'Cross Branch Viewer';

	/// en: 'Ownership Transfer Warning'
	///
	/// id: 'Peringatan Transfer Kepemilikanan'
	String get transfer_ownership_warning_label => 'Ownership Transfer Warning';

	/// en: 'This action cannot be undone and will permanently change the brand ownership. Make sure you enter the correct email and the new owner has approved this transfer.'
	///
	/// id: 'Tindakan ini tidak dapat dibatalkan dan akan mengubah kepemilikanan brand secara permanen. Pastikan Anda memasukkan email yang benar dan pemilik baru telah menyetujui transfer ini.'
	String get transfer_warning_message_label => 'This action cannot be undone and will permanently change the brand ownership. Make sure you enter the correct email and the new owner has approved this transfer.';

	/// en: 'New Owner Email'
	///
	/// id: 'Email Pemilik Baru'
	String get new_owner_email_label => 'New Owner Email';

	/// en: 'Message (Optional)'
	///
	/// id: 'Pesan (Opsional)'
	String get message_optional_label => 'Message (Optional)';

	/// en: 'Message for new owner'
	///
	/// id: 'Pesan untuk pemilik baru'
	String get message_for_new_owner_label => 'Message for new owner';

	/// en: 'Add an explanation message if needed'
	///
	/// id: 'Tambahkan pesan penjelasan jika diperlukan'
	String get add_explanation_message_label => 'Add an explanation message if needed';

	/// en: 'Detail Transfer'
	///
	/// id: 'Detail Transfer'
	String get detail_transfer_label => 'Detail Transfer';

	/// en: 'No brands available'
	///
	/// id: 'Tidak ada brand tersedia'
	String get no_brands_available_selector_label => 'No brands available';

	/// en: 'Select Brand'
	///
	/// id: 'Pilih Brand'
	String get select_brand_label => 'Select Brand';

	/// en: 'Currently:'
	///
	/// id: 'Saat ini:'
	String get currently_label => 'Currently:';

	/// en: 'Switched to {brandName}'
	///
	/// id: 'Beralih ke {brandName}'
	String get brand_switched_success => 'Switched to {brandName}';

	/// en: 'User invited successfully'
	///
	/// id: 'Pengguna berhasil diundang'
	String get user_invited_success => 'User invited successfully';

	/// en: 'Invitation accepted successfully'
	///
	/// id: 'Undangan berhasil diterima'
	String get invitation_accepted_success => 'Invitation accepted successfully';

	/// en: 'Invitation declined'
	///
	/// id: 'Undangan ditolak'
	String get invitation_declined_success => 'Invitation declined';

	/// en: 'Brand found: {brandName}'
	///
	/// id: 'Brand ditemukan: {brandName}'
	String get brand_found_success => 'Brand found: {brandName}';

	/// en: 'Loaded {count} invitations'
	///
	/// id: '{count} undangan dimuat'
	String get invitations_loaded_success => 'Loaded {count} invitations';

	/// en: 'Ownership transferred successfully'
	///
	/// id: 'Kepemilikanan berhasil ditransfer'
	String get ownership_transferred_success => 'Ownership transferred successfully';

	/// en: 'Invitation cancelled'
	///
	/// id: 'Undangan dibatalkan'
	String get invitation_cancelled_success => 'Invitation cancelled';

	/// en: 'Invitation resent'
	///
	/// id: 'Undangan dikirim ulang'
	String get invitation_resent_success => 'Invitation resent';

	/// en: 'Failed to load brands'
	///
	/// id: 'Gagal memuat brands'
	String get failed_to_load_brands => 'Failed to load brands';

	/// en: 'Brand creation failed'
	///
	/// id: 'Pembuatan brand gagal'
	String get brand_creation_failed => 'Brand creation failed';

	/// en: 'Brand update failed'
	///
	/// id: 'Pembaruan brand gagal'
	String get brand_update_failed => 'Brand update failed';

	/// en: 'Brand deletion failed'
	///
	/// id: 'Penghapusan brand gagal'
	String get brand_deletion_failed => 'Brand deletion failed';

	/// en: 'Failed to send invitation'
	///
	/// id: 'Gagal mengirim undangan'
	String get invitation_send_failed => 'Failed to send invitation';

	/// en: 'Ownership transfer failed'
	///
	/// id: 'Transfer kepemilikanan gagal'
	String get transfer_failed => 'Ownership transfer failed';

	/// en: 'Jan'
	///
	/// id: 'Jan'
	String get month_jan => 'Jan';

	/// en: 'Feb'
	///
	/// id: 'Feb'
	String get month_feb => 'Feb';

	/// en: 'Mar'
	///
	/// id: 'Mar'
	String get month_mar => 'Mar';

	/// en: 'Apr'
	///
	/// id: 'Apr'
	String get month_apr => 'Apr';

	/// en: 'May'
	///
	/// id: 'Mei'
	String get month_may => 'May';

	/// en: 'Jun'
	///
	/// id: 'Jun'
	String get month_jun => 'Jun';

	/// en: 'Jul'
	///
	/// id: 'Jul'
	String get month_jul => 'Jul';

	/// en: 'Aug'
	///
	/// id: 'Agu'
	String get month_aug => 'Aug';

	/// en: 'Sep'
	///
	/// id: 'Sep'
	String get month_sep => 'Sep';

	/// en: 'Oct'
	///
	/// id: 'Okt'
	String get month_oct => 'Oct';

	/// en: 'Nov'
	///
	/// id: 'Nov'
	String get month_nov => 'Nov';

	/// en: 'Dec'
	String get month_dec => 'Dec';

	/// en: 'increase'
	///
	/// id: 'kenaikan'
	String get increase_label => 'increase';

	/// en: 'decrease'
	///
	/// id: 'penurunan'
	String get decrease_label => 'decrease';

	/// en: '{sign}{percent}%'
	///
	/// id: '{sign}{percent}%'
	String get percent_change => '{sign}{percent}%';

	/// en: 'Update existing brand data as needed'
	///
	/// id: 'Perbarui data brand yang ada sesuai kebutuhan'
	String get edit_brand_description => 'Update existing brand data as needed';

	/// en: 'Complete your brand data and start operating'
	///
	/// id: 'Lengkapi data brand Anda dan mulai beroperasi'
	String get create_brand_description => 'Complete your brand data and start operating';

	/// en: 'Update the brand information below. Make sure all required data is correct.'
	///
	/// id: 'Perbarui informasi brand di bawah ini. Pastikan semua data yang diperlukan sudah benar.'
	String get brand_info_description => 'Update the brand information below. Make sure all required data is correct.';

	/// en: 'Back'
	///
	/// id: 'Kembali'
	String get back_tooltip => 'Back';

	/// en: 'Refresh'
	///
	/// id: 'Refresh'
	String get refresh_tooltip => 'Refresh';

	/// en: 'Enable manual slug input'
	///
	/// id: 'Enable manual slug input'
	String get enable_manual_slug_tooltip => 'Enable manual slug input';
}
