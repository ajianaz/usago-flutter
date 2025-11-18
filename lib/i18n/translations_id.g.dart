///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'translations.g.dart';

// Path: <root>
class TranslationsId extends Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsId({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.id,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

	/// Metadata for the translations of <id>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final TranslationsId _root = this; // ignore: unused_field

	@override 
	TranslationsId $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsId(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAppId app = _TranslationsAppId._(_root);
	@override late final _TranslationsAuthId auth = _TranslationsAuthId._(_root);
	@override late final _TranslationsValidationId validation = _TranslationsValidationId._(_root);
	@override late final _TranslationsMessagesId messages = _TranslationsMessagesId._(_root);
	@override late final _TranslationsCommonId common = _TranslationsCommonId._(_root);
	@override late final _TranslationsHomeId home = _TranslationsHomeId._(_root);
	@override late final _TranslationsBrandId brand = _TranslationsBrandId._(_root);
}

// Path: app
class _TranslationsAppId extends TranslationsAppEn {
	_TranslationsAppId._(TranslationsId root) : this._root = root, super.internal(root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Usago';
	@override String get welcome => 'Selamat Datang';
}

// Path: auth
class _TranslationsAuthId extends TranslationsAuthEn {
	_TranslationsAuthId._(TranslationsId root) : this._root = root, super.internal(root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get login => 'Masuk';
	@override String get register => 'Daftar';
	@override String get email => 'Email';
	@override String get password => 'Kata Sandi';
	@override String get forgot_password => 'Lupa Kata Sandi?';
	@override String get dont_have_account => 'Belum punya akun?';
	@override String get welcome_back => 'Selamat Datang Kembali';
	@override String get sign_in_to_continue => 'Masuk untuk melanjutkan';
	@override String get create_account => 'Buat Akun';
	@override String get sign_up_to_continue => 'Daftar untuk melanjutkan';
	@override String get already_have_account => 'Sudah punya akun?';
	@override String get name => 'Nama';
	@override String get confirm_password => 'Konfirmasi Kata Sandi';
	@override String get passwords_do_not_match => 'Kata sandi tidak cocok';
	@override String get enter_your_name => 'Masukkan nama Anda';
	@override String get enter_your_email => 'Masukkan email Anda';
	@override String get enter_your_password => 'Masukkan kata sandi Anda';
	@override String get confirm_your_password => 'Konfirmasi kata sandi Anda';
	@override String get forgot_password_description => 'Masukkan alamat email Anda dan kami akan mengirimkan tautan untuk mengatur ulang kata sandi Anda';
	@override String get send_reset_link => 'Kirim Tautan Reset';
	@override String get remember_password => 'Ingat kata sandi Anda?';
	@override String get back_to_login => 'Kembali ke Login';
}

// Path: validation
class _TranslationsValidationId extends TranslationsValidationEn {
	_TranslationsValidationId._(TranslationsId root) : this._root = root, super.internal(root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get required => 'Field ini wajib diisi';
	@override String get email_invalid => 'Masukkan email yang valid';
	@override String get password_too_short => 'Kata sandi minimal 6 karakter';
	@override String get password_too_long => 'Kata sandi maksimal 50 karakter';
	@override String get validation_required => 'Field ini wajib diisi';
	@override String get validation_email_invalid => 'Masukkan email yang valid';
	@override String get validation_password_too_short => 'Kata sandi minimal 6 karakter';
}

// Path: messages
class _TranslationsMessagesId extends TranslationsMessagesEn {
	_TranslationsMessagesId._(TranslationsId root) : this._root = root, super.internal(root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get login_success => 'Login berhasil';
	@override String get login_failed => 'Login gagal';
	@override String get register_success => 'Pendaftaran berhasil';
	@override String get register_failed => 'Pendaftaran gagal';
	@override String get network_error => 'Error jaringan. Periksa koneksi Anda.';
	@override String get unknown_error => 'Terjadi error yang tidak diketahui';
	@override String get password_reset_email_sent => 'Email reset kata sandi telah dikirim ke {email}';
}

// Path: common
class _TranslationsCommonId extends TranslationsCommonEn {
	_TranslationsCommonId._(TranslationsId root) : this._root = root, super.internal(root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get ok => 'OK';
	@override String get cancel => 'Batal';
	@override String get save => 'Simpan';
	@override String get delete => 'Hapus';
	@override String get edit => 'Edit';
	@override String get loading => 'Memuat...';
	@override String get retry => 'Coba Lagi';
	@override String get close => 'Tutup';
}

// Path: home
class _TranslationsHomeId extends TranslationsHomeEn {
	_TranslationsHomeId._(TranslationsId root) : this._root = root, super.internal(root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get welcome_message => 'Apa yang ingin Anda lakukan hari ini? 🎯';
	@override String get select_feature => 'Pilih fitur yang tersedia di bawah ini';
	@override String get error_occurred => 'Terjadi kesalahan';
	@override String get no_menu_in_category => 'Tidak ada menu dalam kategori {category}';
	@override String get no_menu_available => 'Tidak ada menu tersedia';
	@override String get contact_admin => 'Hubungi administrator untuk mengakses fitur ini';
	@override String get you_have_pending_items => 'Anda memiliki {count} item yang perlu ditangani';
	@override String get welcome_back => 'Selamat Datang! 👋';
	@override String get management => 'Manajemen';
	@override String get operations => 'Operasional';
	@override String get reports => 'Laporan';
	@override String get settings => 'Pengaturan';
	@override String get all_menu => 'Semua Menu';
	@override String get logout => 'Keluar';
}

// Path: brand
class _TranslationsBrandId extends TranslationsBrandEn {
	_TranslationsBrandId._(TranslationsId root) : this._root = root, super.internal(root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get create_brand => 'Buat Brand Baru';
	@override String get edit_brand => 'Edit Brand';
	@override String get brand_selection => 'Pilih Brand';
	@override String get brand_stats => 'Statistik Brand';
	@override String get manage_invitations_page => 'Kelola Undangan';
	@override String get transfer_ownership => 'Transfer Kepemilikanan';
	@override String get brand_info => 'Informasi Brand';
	@override String get brand_name => 'Nama Brand';
	@override String get enter_brand_name => 'Masukkan nama brand';
	@override String get slug => 'Slug';
	@override String get url_friendly_identifier => 'URL-friendly identifier';
	@override String get description => 'Deskripsi';
	@override String get brand_description => 'Deskripsi singkat brand (opsional)';
	@override String get industry => 'Industri';
	@override String get brand_industry => 'Industri brand (opsional)';
	@override String get business_type => 'Tipe Bisnis';
	@override String get timezone => 'Zona Waktu';
	@override String get currency => 'Mata Uang';
	@override String get auto_generate_from_name => 'Auto-generate dari nama';
	@override String get enable_manual_slug_input => 'Enable manual slug input';
	@override String get auto_generate_from_name_tooltip => 'Auto-generate dari nama';
	@override String get service => 'Layanan';
	@override String get retail => 'Ritel';
	@override String get manufacturing => 'Manufaktur';
	@override String get other => 'Lainnya';
	@override String get timezone_jakarta => 'Asia/Jakarta (WIB)';
	@override String get timezone_singapore => 'Asia/Singapore (SGT)';
	@override String get timezone_bangkok => 'Asia/Bangkok (ICT)';
	@override String get timezone_kuala_lumpur => 'Asia/Kuala Lumpur (MYT)';
	@override String get timezone_manila => 'Asia/Manila (PHT)';
	@override String get timezone_utc => 'UTC';
	@override String get currency_idr => 'Rupiah Indonesia (IDR)';
	@override String get currency_usd => 'US Dollar (USD)';
	@override String get currency_eur => 'Euro (EUR)';
	@override String get currency_sgd => 'Singapore Dollar (SGD)';
	@override String get currency_myr => 'Malaysian Ringgit (MYR)';
	@override String get currency_thb => 'Thai Baht (THB)';
	@override String get currency_php => 'Philippine Peso (PHP)';
	@override String get create_brand_btn => 'Buat Brand';
	@override String get update_brand_btn => 'Perbarui Brand';
	@override String get send_confirmation_code => 'Kirim Kode Konfirmasi';
	@override String get confirm_transfer => 'Konfirmasi Transfer';
	@override String get send_invitation => 'Kirim Undangan';
	@override String get invite_user => 'Undang Pengguna';
	@override String get brand_created_successfully => 'Brand berhasil dibuat';
	@override String get brand_updated_successfully => 'Brand berhasil diperbarui';
	@override String get brand_deleted_successfully => 'Brand berhasil dihapus';
	@override String get invitation_sent_successfully => 'Undangan berhasil dikirim';
	@override String get confirmation_code_sent => 'Kode konfirmasi telah dikirim ke email pemilik baru';
	@override String get transfer_completed_successfully => 'Kepemilikanan brand berhasil ditransfer';
	@override String get brand_name_required => 'Nama brand wajib diisi';
	@override String get brand_name_min_length => 'Nama brand minimal 3 karakter';
	@override String get brand_name_max_length => 'Nama brand maksimal 50 karakter';
	@override String get slug_required => 'Slug wajib diisi';
	@override String get slug_min_length => 'Slug minimal 3 karakter';
	@override String get slug_max_length => 'Slug maksimal 50 karakter';
	@override String get slug_invalid_characters => 'Slug hanya boleh mengandung huruf kecil, angka, dan strip (-)';
	@override String get description_max_length => 'Deskripsi maksimal 500 karakter';
	@override String get industry_max_length => 'Industri maksimal 100 karakter';
	@override String get email_required => 'Email wajib diisi';
	@override String get email_invalid => 'Format email tidak valid';
	@override String get confirmation_code_required => 'Kode konfirmasi wajib diisi';
	@override String get confirmation_code_length => 'Kode konfirmasi harus 6 digit';
	@override String get edit_brand_dialog_title => 'Edit Brand';
	@override String get edit_brand_dialog_message => 'Apakah Anda ingin mengedit brand ini?';
	@override String get delete_brand_dialog_title => 'Hapus Brand';
	@override String get delete_brand_dialog_message => 'Apakah Anda yakin ingin menghapus brand ini?';
	@override String get delete_brand_warning => 'Tindakan ini tidak dapat dibatalkan.';
	@override String get accept_invitation_dialog_title => 'Terima Undangan';
	@override String get accept_invitation_dialog_message => 'Apakah Anda yakin ingin menerima undangan untuk bergabung dengan {brandName}?';
	@override String get accept_invitation_role_info => 'Anda akan ditambahkan ke brand dengan peran {role}.';
	@override String get decline_invitation_dialog_title => 'Tolak Undangan';
	@override String get decline_invitation_dialog_message => 'Apakah Anda yakin ingin menolak undangan dari {brandName}?';
	@override String get cancel_invitation_dialog_title => 'Batalkan Undangan';
	@override String get cancel_invitation_dialog_message => 'Apakah Anda yakin ingin membatalkan undangan ke {email}?';
	@override String get kNew => 'BARU';
	@override String get active => 'Aktif';
	@override String get brand_active => 'Brand Aktif';
	@override String get joined => 'Bergabung: {date}';
	@override String get status => 'Status';
	@override String get created => 'Dibuat';
	@override String get total_users => 'Total Pengguna';
	@override String get active_branches => 'Cabang Aktif';
	@override String get monthly_revenue => 'Pendapatan Bulan Ini';
	@override String get growth => 'Pertumbuhan';
	@override String get invitations_sent => 'Undangan Terkirim';
	@override String get weekly_activity => 'Aktivitas Minggu Ini';
	@override String get performance_score => 'Skor Kinerja';
	@override String get active_users => 'Aktif: {count}';
	@override String get total_branches => 'Total: {count}';
	@override String get revenue_target => 'Target: {amount}';
	@override String get compare_last_month => 'Banding bulan lalu';
	@override String get pending_invitations => '{pending} tertunda, {accepted} diterima';
	@override String get daily_average => 'Rata-rata: {count}/hari';
	@override String get very_good => 'Sangat Baik';
	@override String get search_brand => 'Cari brand...';
	@override String get search_results => 'Hasil Pencarian';
	@override String get type => 'Tipe';
	@override String get all => 'Semua';
	@override String get loading_brands => 'Memuat brands...';
	@override String get no_brands_available => 'Belum ada brand';
	@override String get no_brands_message => 'Buat brand pertama untuk memulai bisnis Anda';
	@override String get create_new_brand => 'Buat Brand Baru';
	@override String get statistics => 'Statistik';
	@override String get invitations => 'Undangan';
	@override String get transfer => 'Transfer';
	@override String get view_statistics => 'Lihat Statistik';
	@override String get manage_invitations => 'Kelola Undangan';
	@override String get transfer_brand => 'Transfer Brand';
	@override String get received => 'Diterima';
	@override String get sent => 'Terkirim';
	@override String get no_received_invitations => 'Belum ada undangan yang diterima';
	@override String get no_received_invitations_message => 'Anda belum menerima undangan brand apa pun. Undangan yang diterima akan muncul di sini.';
	@override String get no_sent_invitations => 'Belum ada undangan terkirim';
	@override String get no_sent_invitations_message => 'Anda belum mengirim undangan brand apa pun. Undangan yang terkirim akan muncul di sini.';
	@override String get failed_to_load_invitations => 'Gagal memuat undangan';
	@override String get failed_to_load_received_invitations => 'Terjadi kesalahan saat memuat undangan yang diterima. Silakan coba lagi.';
	@override String get failed_to_load_sent_invitations => 'Terjadi kesalahan saat memuat undangan terkirim. Silakan coba lagi.';
	@override String get invitation_details => 'Detail Undangan';
	@override String get brand_label => 'Brand';
	@override String get from_label => 'Dari';
	@override String get to_label => 'Ke';
	@override String get role_label => 'Peran';
	@override String get sent_label => 'Dikirim';
	@override String get expires_label => 'Kadaluarsa';
	@override String get close_label => 'Tutup';
	@override String get invite_new_user => 'Undang Pengguna Baru';
	@override String get invite_new_user_tooltip => 'Undang Pengguna Baru';
	@override String get accept => 'Terima';
	@override String get decline => 'Tolak';
	@override String get cancel => 'Batal';
	@override String get resend => 'Kirim Ulang';
	@override String get reject => 'Tolak';
	@override String get pending => 'Pending';
	@override String get accepted => 'Diterima';
	@override String get declined => 'Ditolak';
	@override String get expired => 'Kadaluarsa';
	@override String get brand_owner => 'Pemilik Brand';
	@override String get brand_admin => 'Admin Brand';
	@override String get branch_manager => 'Manajer Cabang';
	@override String get branch_admin => 'Admin Cabang';
	@override String get branch_staff => 'Staf Cabang';
	@override String get cross_branch_viewer => 'Penonton Lintas Cabang';
	@override String get transfer_ownership_warning => 'Peringatan Transfer Kepemilikanan';
	@override String get transfer_warning_message => 'Tindakan ini tidak dapat dibatalkan dan akan mengubah kepemilikanan brand secara permanen. Pastikan Anda memasukkan email yang benar dan pemilik baru telah menyetujui transfer ini.';
	@override String get new_owner_email => 'Email Pemilik Baru';
	@override String get enter_new_owner_email => 'Masukkan email pemilik baru';
	@override String get example_email => 'contoh: user@example.com';
	@override String get confirmation_code => 'Kode Konfirmasi';
	@override String get enter_confirmation_code => 'Masukkan kode konfirmasi';
	@override String get six_digit_code => 'Kode 6 digit';
	@override String get message_optional => 'Pesan (Opsional)';
	@override String get message_for_new_owner => 'Pesan untuk pemilik baru';
	@override String get add_explanation_message => 'Tambahkan pesan penjelasan jika diperlukan';
	@override String get detail_transfer => 'Detail Transfer';
	@override String get brand_id_label => 'Brand ID: {id}';
	@override String get no_brands_available_selector => 'Tidak ada brand tersedia';
	@override String get select_brand => 'Pilih Brand';
	@override String get currently => 'Saat ini:';
	@override String get back => 'Kembali';
	@override String get refresh => 'Refresh';
	@override String get brand_not_found => 'Brand tidak ditemukan';
}
