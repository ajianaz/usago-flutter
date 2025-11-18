///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

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
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsEnEn en = TranslationsEnEn._(_root);
	late final TranslationsIdEn id = TranslationsIdEn._(_root);
}

// Path: en
class TranslationsEnEn {
	TranslationsEnEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsEnAppEn app = TranslationsEnAppEn._(_root);
	late final TranslationsEnAuthEn auth = TranslationsEnAuthEn._(_root);
	late final TranslationsEnValidationEn validation = TranslationsEnValidationEn._(_root);
	late final TranslationsEnMessagesEn messages = TranslationsEnMessagesEn._(_root);
	late final TranslationsEnCommonEn common = TranslationsEnCommonEn._(_root);
	late final TranslationsEnHomeEn home = TranslationsEnHomeEn._(_root);
	late final TranslationsEnBrandEn brand = TranslationsEnBrandEn._(_root);
}

// Path: id
class TranslationsIdEn {
	TranslationsIdEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsIdAppEn app = TranslationsIdAppEn._(_root);
	late final TranslationsIdAuthEn auth = TranslationsIdAuthEn._(_root);
	late final TranslationsIdValidationEn validation = TranslationsIdValidationEn._(_root);
	late final TranslationsIdMessagesEn messages = TranslationsIdMessagesEn._(_root);
	late final TranslationsIdCommonEn common = TranslationsIdCommonEn._(_root);
	late final TranslationsIdHomeEn home = TranslationsIdHomeEn._(_root);
	late final TranslationsIdBrandEn brand = TranslationsIdBrandEn._(_root);
}

// Path: en.app
class TranslationsEnAppEn {
	TranslationsEnAppEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Usago'
	String get title => 'Usago';

	/// en: 'Welcome'
	String get welcome => 'Welcome';
}

// Path: en.auth
class TranslationsEnAuthEn {
	TranslationsEnAuthEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Login'
	String get login => 'Login';

	/// en: 'Register'
	String get register => 'Register';

	/// en: 'Email'
	String get email => 'Email';

	/// en: 'Password'
	String get password => 'Password';

	/// en: 'Forgot Password?'
	String get forgot_password => 'Forgot Password?';

	/// en: 'Don't have an account?'
	String get dont_have_account => 'Don\'t have an account?';

	/// en: 'Welcome Back'
	String get welcome_back => 'Welcome Back';

	/// en: 'Sign in to continue'
	String get sign_in_to_continue => 'Sign in to continue';

	/// en: 'Create Account'
	String get create_account => 'Create Account';

	/// en: 'Sign up to continue'
	String get sign_up_to_continue => 'Sign up to continue';

	/// en: 'Already have an account?'
	String get already_have_account => 'Already have an account?';

	/// en: 'Name'
	String get name => 'Name';

	/// en: 'Confirm Password'
	String get confirm_password => 'Confirm Password';

	/// en: 'Passwords do not match'
	String get passwords_do_not_match => 'Passwords do not match';

	/// en: 'Enter your name'
	String get enter_your_name => 'Enter your name';

	/// en: 'Enter your email'
	String get enter_your_email => 'Enter your email';

	/// en: 'Enter your password'
	String get enter_your_password => 'Enter your password';

	/// en: 'Confirm your password'
	String get confirm_your_password => 'Confirm your password';

	/// en: 'Email'
	String get auth_email => 'Email';

	/// en: 'Password'
	String get auth_password => 'Password';

	/// en: 'Login'
	String get auth_login => 'Login';

	/// en: 'Register'
	String get auth_register => 'Register';

	/// en: 'Forgot Password?'
	String get auth_forgot_password => 'Forgot Password?';

	/// en: 'Don't have an account?'
	String get auth_dont_have_account => 'Don\'t have an account?';

	/// en: 'Welcome Back'
	String get auth_welcome_back => 'Welcome Back';

	/// en: 'Sign in to continue'
	String get auth_sign_in_to_continue => 'Sign in to continue';

	/// en: 'Create Account'
	String get auth_create_account => 'Create Account';

	/// en: 'Sign up to continue'
	String get auth_sign_up_to_continue => 'Sign up to continue';

	/// en: 'Already have an account?'
	String get auth_already_have_account => 'Already have an account?';

	/// en: 'Enter your email address and we'll send you a link to reset your password'
	String get forgot_password_description => 'Enter your email address and we\'ll send you a link to reset your password';

	/// en: 'Send Reset Link'
	String get send_reset_link => 'Send Reset Link';

	/// en: 'Remember your password?'
	String get remember_password => 'Remember your password?';

	/// en: 'Back to Login'
	String get back_to_login => 'Back to Login';
}

// Path: en.validation
class TranslationsEnValidationEn {
	TranslationsEnValidationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'This field is required'
	String get required => 'This field is required';

	/// en: 'Please enter a valid email'
	String get email_invalid => 'Please enter a valid email';

	/// en: 'Password must be at least 6 characters'
	String get password_too_short => 'Password must be at least 6 characters';

	/// en: 'Password must be less than 50 characters'
	String get password_too_long => 'Password must be less than 50 characters';

	/// en: 'This field is required'
	String get validation_required => 'This field is required';

	/// en: 'Please enter a valid email'
	String get validation_email_invalid => 'Please enter a valid email';

	/// en: 'Password must be at least 6 characters'
	String get validation_password_too_short => 'Password must be at least 6 characters';
}

// Path: en.messages
class TranslationsEnMessagesEn {
	TranslationsEnMessagesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Login successful'
	String get login_success => 'Login successful';

	/// en: 'Login failed'
	String get login_failed => 'Login failed';

	/// en: 'Registration successful'
	String get register_success => 'Registration successful';

	/// en: 'Registration failed'
	String get register_failed => 'Registration failed';

	/// en: 'Network error. Please check your connection.'
	String get network_error => 'Network error. Please check your connection.';

	/// en: 'An unknown error occurred'
	String get unknown_error => 'An unknown error occurred';

	/// en: 'Password reset email sent to {email}'
	String get password_reset_email_sent => 'Password reset email sent to {email}';
}

// Path: en.common
class TranslationsEnCommonEn {
	TranslationsEnCommonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'OK'
	String get ok => 'OK';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Loading...'
	String get loading => 'Loading...';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Close'
	String get close => 'Close';
}

// Path: en.home
class TranslationsEnHomeEn {
	TranslationsEnHomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'What would you like to do today? 🎯'
	String get welcome_message => 'What would you like to do today? 🎯';

	/// en: 'Select the available features below'
	String get select_feature => 'Select the available features below';

	/// en: 'An error occurred'
	String get error_occurred => 'An error occurred';

	/// en: 'No menu in category {category}'
	String get no_menu_in_category => 'No menu in category {category}';

	/// en: 'No menu available'
	String get no_menu_available => 'No menu available';

	/// en: 'Contact administrator to access this feature'
	String get contact_admin => 'Contact administrator to access this feature';

	/// en: 'You have {count} items that need to be handled'
	String get you_have_pending_items => 'You have {count} items that need to be handled';

	/// en: 'Welcome back! 👋'
	String get welcome_back => 'Welcome back! 👋';

	/// en: 'Management'
	String get management => 'Management';

	/// en: 'Operations'
	String get operations => 'Operations';

	/// en: 'Reports'
	String get reports => 'Reports';

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'All Menu'
	String get all_menu => 'All Menu';

	/// en: 'Logout'
	String get logout => 'Logout';
}

// Path: en.brand
class TranslationsEnBrandEn {
	TranslationsEnBrandEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Create New Brand'
	String get create_brand => 'Create New Brand';

	/// en: 'Edit Brand'
	String get edit_brand => 'Edit Brand';

	/// en: 'Select Brand'
	String get brand_selection => 'Select Brand';

	/// en: 'Brand Statistics'
	String get brand_stats => 'Brand Statistics';

	/// en: 'Manage Invitations'
	String get manage_invitations_page => 'Manage Invitations';

	/// en: 'Transfer Ownership'
	String get transfer_ownership => 'Transfer Ownership';

	/// en: 'Brand Information'
	String get brand_info => 'Brand Information';

	/// en: 'Brand Name'
	String get brand_name => 'Brand Name';

	/// en: 'Enter brand name'
	String get enter_brand_name => 'Enter brand name';

	/// en: 'Slug'
	String get slug => 'Slug';

	/// en: 'URL-friendly identifier'
	String get url_friendly_identifier => 'URL-friendly identifier';

	/// en: 'Description'
	String get description => 'Description';

	/// en: 'Brief brand description (optional)'
	String get brand_description => 'Brief brand description (optional)';

	/// en: 'Industry'
	String get industry => 'Industry';

	/// en: 'Brand industry (optional)'
	String get brand_industry => 'Brand industry (optional)';

	/// en: 'Business Type'
	String get business_type => 'Business Type';

	/// en: 'Timezone'
	String get timezone => 'Timezone';

	/// en: 'Currency'
	String get currency => 'Currency';

	/// en: 'Auto-generate from name'
	String get auto_generate_from_name => 'Auto-generate from name';

	/// en: 'Enable manual slug input'
	String get enable_manual_slug_input => 'Enable manual slug input';

	/// en: 'Auto-generate from name'
	String get auto_generate_from_name_tooltip => 'Auto-generate from name';

	/// en: 'Service'
	String get service => 'Service';

	/// en: 'Retail'
	String get retail => 'Retail';

	/// en: 'Manufacturing'
	String get manufacturing => 'Manufacturing';

	/// en: 'Other'
	String get other => 'Other';

	/// en: 'Asia/Jakarta (WIB)'
	String get timezone_jakarta => 'Asia/Jakarta (WIB)';

	/// en: 'Asia/Singapore (SGT)'
	String get timezone_singapore => 'Asia/Singapore (SGT)';

	/// en: 'Asia/Bangkok (ICT)'
	String get timezone_bangkok => 'Asia/Bangkok (ICT)';

	/// en: 'Asia/Kuala Lumpur (MYT)'
	String get timezone_kuala_lumpur => 'Asia/Kuala Lumpur (MYT)';

	/// en: 'Asia/Manila (PHT)'
	String get timezone_manila => 'Asia/Manila (PHT)';

	/// en: 'UTC'
	String get timezone_utc => 'UTC';

	/// en: 'Indonesian Rupiah (IDR)'
	String get currency_idr => 'Indonesian Rupiah (IDR)';

	/// en: 'US Dollar (USD)'
	String get currency_usd => 'US Dollar (USD)';

	/// en: 'Euro (EUR)'
	String get currency_eur => 'Euro (EUR)';

	/// en: 'Singapore Dollar (SGD)'
	String get currency_sgd => 'Singapore Dollar (SGD)';

	/// en: 'Malaysian Ringgit (MYR)'
	String get currency_myr => 'Malaysian Ringgit (MYR)';

	/// en: 'Thai Baht (THB)'
	String get currency_thb => 'Thai Baht (THB)';

	/// en: 'Philippine Peso (PHP)'
	String get currency_php => 'Philippine Peso (PHP)';

	/// en: 'Create Brand'
	String get create_brand_btn => 'Create Brand';

	/// en: 'Update Brand'
	String get update_brand_btn => 'Update Brand';

	/// en: 'Send Confirmation Code'
	String get send_confirmation_code => 'Send Confirmation Code';

	/// en: 'Confirm Transfer'
	String get confirm_transfer => 'Confirm Transfer';

	/// en: 'Send Invitation'
	String get send_invitation => 'Send Invitation';

	/// en: 'Invite User'
	String get invite_user => 'Invite User';

	/// en: 'Brand created successfully'
	String get brand_created_successfully => 'Brand created successfully';

	/// en: 'Brand updated successfully'
	String get brand_updated_successfully => 'Brand updated successfully';

	/// en: 'Brand deleted successfully'
	String get brand_deleted_successfully => 'Brand deleted successfully';

	/// en: 'Invitation sent successfully'
	String get invitation_sent_successfully => 'Invitation sent successfully';

	/// en: 'Confirmation code has been sent to the new owner's email'
	String get confirmation_code_sent => 'Confirmation code has been sent to the new owner\'s email';

	/// en: 'Brand ownership transferred successfully'
	String get transfer_completed_successfully => 'Brand ownership transferred successfully';

	/// en: 'Brand name is required'
	String get brand_name_required => 'Brand name is required';

	/// en: 'Brand name must be at least 3 characters'
	String get brand_name_min_length => 'Brand name must be at least 3 characters';

	/// en: 'Brand name must be less than 50 characters'
	String get brand_name_max_length => 'Brand name must be less than 50 characters';

	/// en: 'Slug is required'
	String get slug_required => 'Slug is required';

	/// en: 'Slug must be at least 3 characters'
	String get slug_min_length => 'Slug must be at least 3 characters';

	/// en: 'Slug must be less than 50 characters'
	String get slug_max_length => 'Slug must be less than 50 characters';

	/// en: 'Slug can only contain lowercase letters, numbers, and hyphens (-)'
	String get slug_invalid_characters => 'Slug can only contain lowercase letters, numbers, and hyphens (-)';

	/// en: 'Description must be less than 500 characters'
	String get description_max_length => 'Description must be less than 500 characters';

	/// en: 'Industry must be less than 100 characters'
	String get industry_max_length => 'Industry must be less than 100 characters';

	/// en: 'Email is required'
	String get email_required => 'Email is required';

	/// en: 'Please enter a valid email'
	String get email_invalid => 'Please enter a valid email';

	/// en: 'Confirmation code is required'
	String get confirmation_code_required => 'Confirmation code is required';

	/// en: 'Confirmation code must be 6 digits'
	String get confirmation_code_length => 'Confirmation code must be 6 digits';

	/// en: 'Edit Brand'
	String get edit_brand_dialog_title => 'Edit Brand';

	/// en: 'Do you want to edit this brand?'
	String get edit_brand_dialog_message => 'Do you want to edit this brand?';

	/// en: 'Delete Brand'
	String get delete_brand_dialog_title => 'Delete Brand';

	/// en: 'Are you sure you want to delete this brand?'
	String get delete_brand_dialog_message => 'Are you sure you want to delete this brand?';

	/// en: 'This action cannot be undone.'
	String get delete_brand_warning => 'This action cannot be undone.';

	/// en: 'Accept Invitation'
	String get accept_invitation_dialog_title => 'Accept Invitation';

	/// en: 'Are you sure you want to accept the invitation to join {brandName}?'
	String get accept_invitation_dialog_message => 'Are you sure you want to accept the invitation to join {brandName}?';

	/// en: 'You will be added to the brand with the role of {role}.'
	String get accept_invitation_role_info => 'You will be added to the brand with the role of {role}.';

	/// en: 'Decline Invitation'
	String get decline_invitation_dialog_title => 'Decline Invitation';

	/// en: 'Are you sure you want to decline the invitation from {brandName}?'
	String get decline_invitation_dialog_message => 'Are you sure you want to decline the invitation from {brandName}?';

	/// en: 'Cancel Invitation'
	String get cancel_invitation_dialog_title => 'Cancel Invitation';

	/// en: 'Are you sure you want to cancel the invitation to {email}?'
	String get cancel_invitation_dialog_message => 'Are you sure you want to cancel the invitation to {email}?';

	/// en: 'NEW'
	String get k_new => 'NEW';

	/// en: 'Active'
	String get active => 'Active';

	/// en: 'Brand Active'
	String get brand_active => 'Brand Active';

	/// en: 'Joined: {date}'
	String get joined => 'Joined: {date}';

	/// en: 'Status'
	String get status => 'Status';

	/// en: 'Created'
	String get created => 'Created';

	/// en: 'Total Users'
	String get total_users => 'Total Users';

	/// en: 'Active Branches'
	String get active_branches => 'Active Branches';

	/// en: 'Monthly Revenue'
	String get monthly_revenue => 'Monthly Revenue';

	/// en: 'Growth'
	String get growth => 'Growth';

	/// en: 'Invitations Sent'
	String get invitations_sent => 'Invitations Sent';

	/// en: 'Weekly Activity'
	String get weekly_activity => 'Weekly Activity';

	/// en: 'Performance Score'
	String get performance_score => 'Performance Score';

	/// en: 'Active: {count}'
	String get active_users => 'Active: {count}';

	/// en: 'Total: {count}'
	String get total_branches => 'Total: {count}';

	/// en: 'Target: {amount}'
	String get revenue_target => 'Target: {amount}';

	/// en: 'Compare last month'
	String get compare_last_month => 'Compare last month';

	/// en: '{pending} pending, {accepted} accepted'
	String get pending_invitations => '{pending} pending, {accepted} accepted';

	/// en: 'Average: {count}/day'
	String get daily_average => 'Average: {count}/day';

	/// en: 'Very Good'
	String get very_good => 'Very Good';

	/// en: 'Search brand...'
	String get search_brand => 'Search brand...';

	/// en: 'Search Results'
	String get search_results => 'Search Results';

	/// en: 'Type'
	String get type => 'Type';

	/// en: 'All'
	String get all => 'All';

	/// en: 'Loading brands...'
	String get loading_brands => 'Loading brands...';

	/// en: 'No brands available'
	String get no_brands_available => 'No brands available';

	/// en: 'Create your first brand to start your business'
	String get no_brands_message => 'Create your first brand to start your business';

	/// en: 'Create New Brand'
	String get create_new_brand => 'Create New Brand';

	/// en: 'Statistics'
	String get statistics => 'Statistics';

	/// en: 'Invitations'
	String get invitations => 'Invitations';

	/// en: 'Transfer'
	String get transfer => 'Transfer';

	/// en: 'View Statistics'
	String get view_statistics => 'View Statistics';

	/// en: 'Manage Invitations'
	String get manage_invitations => 'Manage Invitations';

	/// en: 'Transfer Brand'
	String get transfer_brand => 'Transfer Brand';

	/// en: 'Received'
	String get received => 'Received';

	/// en: 'Sent'
	String get sent => 'Sent';

	/// en: 'No received invitations'
	String get no_received_invitations => 'No received invitations';

	/// en: 'You haven't received any brand invitations. Received invitations will appear here.'
	String get no_received_invitations_message => 'You haven\'t received any brand invitations. Received invitations will appear here.';

	/// en: 'No sent invitations'
	String get no_sent_invitations => 'No sent invitations';

	/// en: 'You haven't sent any brand invitations. Sent invitations will appear here.'
	String get no_sent_invitations_message => 'You haven\'t sent any brand invitations. Sent invitations will appear here.';

	/// en: 'Failed to load invitations'
	String get failed_to_load_invitations => 'Failed to load invitations';

	/// en: 'An error occurred while loading received invitations. Please try again.'
	String get failed_to_load_received_invitations => 'An error occurred while loading received invitations. Please try again.';

	/// en: 'An error occurred while loading sent invitations. Please try again.'
	String get failed_to_load_sent_invitations => 'An error occurred while loading sent invitations. Please try again.';

	/// en: 'Invitation Details'
	String get invitation_details => 'Invitation Details';

	/// en: 'Brand'
	String get brand_label => 'Brand';

	/// en: 'From'
	String get from_label => 'From';

	/// en: 'To'
	String get to_label => 'To';

	/// en: 'Role'
	String get role_label => 'Role';

	/// en: 'Sent'
	String get sent_label => 'Sent';

	/// en: 'Expires'
	String get expires_label => 'Expires';

	/// en: 'Close'
	String get close_label => 'Close';

	/// en: 'Invite New User'
	String get invite_new_user => 'Invite New User';

	/// en: 'Invite New User'
	String get invite_new_user_tooltip => 'Invite New User';

	/// en: 'Accept'
	String get accept => 'Accept';

	/// en: 'Decline'
	String get decline => 'Decline';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Resend'
	String get resend => 'Resend';

	/// en: 'Reject'
	String get reject => 'Reject';

	/// en: 'Pending'
	String get pending => 'Pending';

	/// en: 'Accepted'
	String get accepted => 'Accepted';

	/// en: 'Declined'
	String get declined => 'Declined';

	/// en: 'Expired'
	String get expired => 'Expired';

	/// en: 'Brand Owner'
	String get brand_owner => 'Brand Owner';

	/// en: 'Brand Admin'
	String get brand_admin => 'Brand Admin';

	/// en: 'Branch Manager'
	String get branch_manager => 'Branch Manager';

	/// en: 'Branch Admin'
	String get branch_admin => 'Branch Admin';

	/// en: 'Branch Staff'
	String get branch_staff => 'Branch Staff';

	/// en: 'Cross Branch Viewer'
	String get cross_branch_viewer => 'Cross Branch Viewer';

	/// en: 'Ownership Transfer Warning'
	String get transfer_ownership_warning => 'Ownership Transfer Warning';

	/// en: 'This action cannot be undone and will permanently change the brand ownership. Make sure you enter the correct email and the new owner has approved this transfer.'
	String get transfer_warning_message => 'This action cannot be undone and will permanently change the brand ownership. Make sure you enter the correct email and the new owner has approved this transfer.';

	/// en: 'New Owner Email'
	String get new_owner_email => 'New Owner Email';

	/// en: 'Enter new owner email'
	String get enter_new_owner_email => 'Enter new owner email';

	/// en: 'example: user@example.com'
	String get example_email => 'example: user@example.com';

	/// en: 'Confirmation Code'
	String get confirmation_code => 'Confirmation Code';

	/// en: 'Enter confirmation code'
	String get enter_confirmation_code => 'Enter confirmation code';

	/// en: '6-digit code'
	String get six_digit_code => '6-digit code';

	/// en: 'Message (Optional)'
	String get message_optional => 'Message (Optional)';

	/// en: 'Message for new owner'
	String get message_for_new_owner => 'Message for new owner';

	/// en: 'Add an explanation message if needed'
	String get add_explanation_message => 'Add an explanation message if needed';

	/// en: 'Detail Transfer'
	String get detail_transfer => 'Detail Transfer';

	/// en: 'Brand ID: {id}'
	String get brand_id_label => 'Brand ID: {id}';

	/// en: 'No brands available'
	String get no_brands_available_selector => 'No brands available';

	/// en: 'Select Brand'
	String get select_brand => 'Select Brand';

	/// en: 'Currently:'
	String get currently => 'Currently:';

	/// en: 'Back'
	String get back => 'Back';

	/// en: 'Refresh'
	String get refresh => 'Refresh';

	/// en: 'Brand not found'
	String get brand_not_found => 'Brand not found';
}

// Path: id.app
class TranslationsIdAppEn {
	TranslationsIdAppEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Usago'
	String get title => 'Usago';

	/// en: 'Selamat Datang'
	String get welcome => 'Selamat Datang';
}

// Path: id.auth
class TranslationsIdAuthEn {
	TranslationsIdAuthEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Masuk'
	String get login => 'Masuk';

	/// en: 'Daftar'
	String get register => 'Daftar';

	/// en: 'Email'
	String get email => 'Email';

	/// en: 'Kata Sandi'
	String get password => 'Kata Sandi';

	/// en: 'Lupa Kata Sandi?'
	String get forgot_password => 'Lupa Kata Sandi?';

	/// en: 'Belum punya akun?'
	String get dont_have_account => 'Belum punya akun?';

	/// en: 'Selamat Datang Kembali'
	String get welcome_back => 'Selamat Datang Kembali';

	/// en: 'Masuk untuk melanjutkan'
	String get sign_in_to_continue => 'Masuk untuk melanjutkan';

	/// en: 'Buat Akun'
	String get create_account => 'Buat Akun';

	/// en: 'Daftar untuk melanjutkan'
	String get sign_up_to_continue => 'Daftar untuk melanjutkan';

	/// en: 'Sudah punya akun?'
	String get already_have_account => 'Sudah punya akun?';

	/// en: 'Nama'
	String get name => 'Nama';

	/// en: 'Konfirmasi Kata Sandi'
	String get confirm_password => 'Konfirmasi Kata Sandi';

	/// en: 'Kata sandi tidak cocok'
	String get passwords_do_not_match => 'Kata sandi tidak cocok';

	/// en: 'Masukkan nama Anda'
	String get enter_your_name => 'Masukkan nama Anda';

	/// en: 'Masukkan email Anda'
	String get enter_your_email => 'Masukkan email Anda';

	/// en: 'Masukkan kata sandi Anda'
	String get enter_your_password => 'Masukkan kata sandi Anda';

	/// en: 'Konfirmasi kata sandi Anda'
	String get confirm_your_password => 'Konfirmasi kata sandi Anda';

	/// en: 'Masukkan alamat email Anda dan kami akan mengirimkan tautan untuk mengatur ulang kata sandi Anda'
	String get forgot_password_description => 'Masukkan alamat email Anda dan kami akan mengirimkan tautan untuk mengatur ulang kata sandi Anda';

	/// en: 'Kirim Tautan Reset'
	String get send_reset_link => 'Kirim Tautan Reset';

	/// en: 'Ingat kata sandi Anda?'
	String get remember_password => 'Ingat kata sandi Anda?';

	/// en: 'Kembali ke Login'
	String get back_to_login => 'Kembali ke Login';
}

// Path: id.validation
class TranslationsIdValidationEn {
	TranslationsIdValidationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Field ini wajib diisi'
	String get required => 'Field ini wajib diisi';

	/// en: 'Masukkan email yang valid'
	String get email_invalid => 'Masukkan email yang valid';

	/// en: 'Kata sandi minimal 6 karakter'
	String get password_too_short => 'Kata sandi minimal 6 karakter';

	/// en: 'Kata sandi maksimal 50 karakter'
	String get password_too_long => 'Kata sandi maksimal 50 karakter';

	/// en: 'Field ini wajib diisi'
	String get validation_required => 'Field ini wajib diisi';

	/// en: 'Masukkan email yang valid'
	String get validation_email_invalid => 'Masukkan email yang valid';

	/// en: 'Kata sandi minimal 6 karakter'
	String get validation_password_too_short => 'Kata sandi minimal 6 karakter';
}

// Path: id.messages
class TranslationsIdMessagesEn {
	TranslationsIdMessagesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Login berhasil'
	String get login_success => 'Login berhasil';

	/// en: 'Login gagal'
	String get login_failed => 'Login gagal';

	/// en: 'Pendaftaran berhasil'
	String get register_success => 'Pendaftaran berhasil';

	/// en: 'Pendaftaran gagal'
	String get register_failed => 'Pendaftaran gagal';

	/// en: 'Error jaringan. Periksa koneksi Anda.'
	String get network_error => 'Error jaringan. Periksa koneksi Anda.';

	/// en: 'Terjadi error yang tidak diketahui'
	String get unknown_error => 'Terjadi error yang tidak diketahui';

	/// en: 'Email reset kata sandi telah dikirim ke {email}'
	String get password_reset_email_sent => 'Email reset kata sandi telah dikirim ke {email}';
}

// Path: id.common
class TranslationsIdCommonEn {
	TranslationsIdCommonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'OK'
	String get ok => 'OK';

	/// en: 'Batal'
	String get cancel => 'Batal';

	/// en: 'Simpan'
	String get save => 'Simpan';

	/// en: 'Hapus'
	String get delete => 'Hapus';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Memuat...'
	String get loading => 'Memuat...';

	/// en: 'Coba Lagi'
	String get retry => 'Coba Lagi';

	/// en: 'Tutup'
	String get close => 'Tutup';
}

// Path: id.home
class TranslationsIdHomeEn {
	TranslationsIdHomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Apa yang ingin Anda lakukan hari ini? 🎯'
	String get welcome_message => 'Apa yang ingin Anda lakukan hari ini? 🎯';

	/// en: 'Pilih fitur yang tersedia di bawah ini'
	String get select_feature => 'Pilih fitur yang tersedia di bawah ini';

	/// en: 'Terjadi kesalahan'
	String get error_occurred => 'Terjadi kesalahan';

	/// en: 'Tidak ada menu dalam kategori {category}'
	String get no_menu_in_category => 'Tidak ada menu dalam kategori {category}';

	/// en: 'Tidak ada menu tersedia'
	String get no_menu_available => 'Tidak ada menu tersedia';

	/// en: 'Hubungi administrator untuk mengakses fitur ini'
	String get contact_admin => 'Hubungi administrator untuk mengakses fitur ini';

	/// en: 'Anda memiliki {count} item yang perlu ditangani'
	String get you_have_pending_items => 'Anda memiliki {count} item yang perlu ditangani';

	/// en: 'Selamat Datang! 👋'
	String get welcome_back => 'Selamat Datang! 👋';

	/// en: 'Manajemen'
	String get management => 'Manajemen';

	/// en: 'Operasional'
	String get operations => 'Operasional';

	/// en: 'Laporan'
	String get reports => 'Laporan';

	/// en: 'Pengaturan'
	String get settings => 'Pengaturan';

	/// en: 'Semua Menu'
	String get all_menu => 'Semua Menu';

	/// en: 'Keluar'
	String get logout => 'Keluar';
}

// Path: id.brand
class TranslationsIdBrandEn {
	TranslationsIdBrandEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Buat Brand Baru'
	String get create_brand => 'Buat Brand Baru';

	/// en: 'Edit Brand'
	String get edit_brand => 'Edit Brand';

	/// en: 'Pilih Brand'
	String get brand_selection => 'Pilih Brand';

	/// en: 'Statistik Brand'
	String get brand_stats => 'Statistik Brand';

	/// en: 'Kelola Undangan'
	String get manage_invitations_page => 'Kelola Undangan';

	/// en: 'Transfer Kepemilikanan'
	String get transfer_ownership => 'Transfer Kepemilikanan';

	/// en: 'Informasi Brand'
	String get brand_info => 'Informasi Brand';

	/// en: 'Nama Brand'
	String get brand_name => 'Nama Brand';

	/// en: 'Masukkan nama brand'
	String get enter_brand_name => 'Masukkan nama brand';

	/// en: 'Slug'
	String get slug => 'Slug';

	/// en: 'URL-friendly identifier'
	String get url_friendly_identifier => 'URL-friendly identifier';

	/// en: 'Deskripsi'
	String get description => 'Deskripsi';

	/// en: 'Deskripsi singkat brand (opsional)'
	String get brand_description => 'Deskripsi singkat brand (opsional)';

	/// en: 'Industri'
	String get industry => 'Industri';

	/// en: 'Industri brand (opsional)'
	String get brand_industry => 'Industri brand (opsional)';

	/// en: 'Tipe Bisnis'
	String get business_type => 'Tipe Bisnis';

	/// en: 'Zona Waktu'
	String get timezone => 'Zona Waktu';

	/// en: 'Mata Uang'
	String get currency => 'Mata Uang';

	/// en: 'Auto-generate dari nama'
	String get auto_generate_from_name => 'Auto-generate dari nama';

	/// en: 'Enable manual slug input'
	String get enable_manual_slug_input => 'Enable manual slug input';

	/// en: 'Auto-generate dari nama'
	String get auto_generate_from_name_tooltip => 'Auto-generate dari nama';

	/// en: 'Layanan'
	String get service => 'Layanan';

	/// en: 'Ritel'
	String get retail => 'Ritel';

	/// en: 'Manufaktur'
	String get manufacturing => 'Manufaktur';

	/// en: 'Lainnya'
	String get other => 'Lainnya';

	/// en: 'Asia/Jakarta (WIB)'
	String get timezone_jakarta => 'Asia/Jakarta (WIB)';

	/// en: 'Asia/Singapore (SGT)'
	String get timezone_singapore => 'Asia/Singapore (SGT)';

	/// en: 'Asia/Bangkok (ICT)'
	String get timezone_bangkok => 'Asia/Bangkok (ICT)';

	/// en: 'Asia/Kuala Lumpur (MYT)'
	String get timezone_kuala_lumpur => 'Asia/Kuala Lumpur (MYT)';

	/// en: 'Asia/Manila (PHT)'
	String get timezone_manila => 'Asia/Manila (PHT)';

	/// en: 'UTC'
	String get timezone_utc => 'UTC';

	/// en: 'Rupiah Indonesia (IDR)'
	String get currency_idr => 'Rupiah Indonesia (IDR)';

	/// en: 'US Dollar (USD)'
	String get currency_usd => 'US Dollar (USD)';

	/// en: 'Euro (EUR)'
	String get currency_eur => 'Euro (EUR)';

	/// en: 'Singapore Dollar (SGD)'
	String get currency_sgd => 'Singapore Dollar (SGD)';

	/// en: 'Malaysian Ringgit (MYR)'
	String get currency_myr => 'Malaysian Ringgit (MYR)';

	/// en: 'Thai Baht (THB)'
	String get currency_thb => 'Thai Baht (THB)';

	/// en: 'Philippine Peso (PHP)'
	String get currency_php => 'Philippine Peso (PHP)';

	/// en: 'Buat Brand'
	String get create_brand_btn => 'Buat Brand';

	/// en: 'Perbarui Brand'
	String get update_brand_btn => 'Perbarui Brand';

	/// en: 'Kirim Kode Konfirmasi'
	String get send_confirmation_code => 'Kirim Kode Konfirmasi';

	/// en: 'Konfirmasi Transfer'
	String get confirm_transfer => 'Konfirmasi Transfer';

	/// en: 'Kirim Undangan'
	String get send_invitation => 'Kirim Undangan';

	/// en: 'Undang Pengguna'
	String get invite_user => 'Undang Pengguna';

	/// en: 'Brand berhasil dibuat'
	String get brand_created_successfully => 'Brand berhasil dibuat';

	/// en: 'Brand berhasil diperbarui'
	String get brand_updated_successfully => 'Brand berhasil diperbarui';

	/// en: 'Brand berhasil dihapus'
	String get brand_deleted_successfully => 'Brand berhasil dihapus';

	/// en: 'Undangan berhasil dikirim'
	String get invitation_sent_successfully => 'Undangan berhasil dikirim';

	/// en: 'Kode konfirmasi telah dikirim ke email pemilik baru'
	String get confirmation_code_sent => 'Kode konfirmasi telah dikirim ke email pemilik baru';

	/// en: 'Kepemilikanan brand berhasil ditransfer'
	String get transfer_completed_successfully => 'Kepemilikanan brand berhasil ditransfer';

	/// en: 'Nama brand wajib diisi'
	String get brand_name_required => 'Nama brand wajib diisi';

	/// en: 'Nama brand minimal 3 karakter'
	String get brand_name_min_length => 'Nama brand minimal 3 karakter';

	/// en: 'Nama brand maksimal 50 karakter'
	String get brand_name_max_length => 'Nama brand maksimal 50 karakter';

	/// en: 'Slug wajib diisi'
	String get slug_required => 'Slug wajib diisi';

	/// en: 'Slug minimal 3 karakter'
	String get slug_min_length => 'Slug minimal 3 karakter';

	/// en: 'Slug maksimal 50 karakter'
	String get slug_max_length => 'Slug maksimal 50 karakter';

	/// en: 'Slug hanya boleh mengandung huruf kecil, angka, dan strip (-)'
	String get slug_invalid_characters => 'Slug hanya boleh mengandung huruf kecil, angka, dan strip (-)';

	/// en: 'Deskripsi maksimal 500 karakter'
	String get description_max_length => 'Deskripsi maksimal 500 karakter';

	/// en: 'Industri maksimal 100 karakter'
	String get industry_max_length => 'Industri maksimal 100 karakter';

	/// en: 'Email wajib diisi'
	String get email_required => 'Email wajib diisi';

	/// en: 'Format email tidak valid'
	String get email_invalid => 'Format email tidak valid';

	/// en: 'Kode konfirmasi wajib diisi'
	String get confirmation_code_required => 'Kode konfirmasi wajib diisi';

	/// en: 'Kode konfirmasi harus 6 digit'
	String get confirmation_code_length => 'Kode konfirmasi harus 6 digit';

	/// en: 'Edit Brand'
	String get edit_brand_dialog_title => 'Edit Brand';

	/// en: 'Apakah Anda ingin mengedit brand ini?'
	String get edit_brand_dialog_message => 'Apakah Anda ingin mengedit brand ini?';

	/// en: 'Hapus Brand'
	String get delete_brand_dialog_title => 'Hapus Brand';

	/// en: 'Apakah Anda yakin ingin menghapus brand ini?'
	String get delete_brand_dialog_message => 'Apakah Anda yakin ingin menghapus brand ini?';

	/// en: 'Tindakan ini tidak dapat dibatalkan.'
	String get delete_brand_warning => 'Tindakan ini tidak dapat dibatalkan.';

	/// en: 'Terima Undangan'
	String get accept_invitation_dialog_title => 'Terima Undangan';

	/// en: 'Apakah Anda yakin ingin menerima undangan untuk bergabung dengan {brandName}?'
	String get accept_invitation_dialog_message => 'Apakah Anda yakin ingin menerima undangan untuk bergabung dengan {brandName}?';

	/// en: 'Anda akan ditambahkan ke brand dengan peran {role}.'
	String get accept_invitation_role_info => 'Anda akan ditambahkan ke brand dengan peran {role}.';

	/// en: 'Tolak Undangan'
	String get decline_invitation_dialog_title => 'Tolak Undangan';

	/// en: 'Apakah Anda yakin ingin menolak undangan dari {brandName}?'
	String get decline_invitation_dialog_message => 'Apakah Anda yakin ingin menolak undangan dari {brandName}?';

	/// en: 'Batalkan Undangan'
	String get cancel_invitation_dialog_title => 'Batalkan Undangan';

	/// en: 'Apakah Anda yakin ingin membatalkan undangan ke {email}?'
	String get cancel_invitation_dialog_message => 'Apakah Anda yakin ingin membatalkan undangan ke {email}?';

	/// en: 'BARU'
	String get k_new => 'BARU';

	/// en: 'Aktif'
	String get active => 'Aktif';

	/// en: 'Brand Aktif'
	String get brand_active => 'Brand Aktif';

	/// en: 'Bergabung: {date}'
	String get joined => 'Bergabung: {date}';

	/// en: 'Status'
	String get status => 'Status';

	/// en: 'Dibuat'
	String get created => 'Dibuat';

	/// en: 'Total Pengguna'
	String get total_users => 'Total Pengguna';

	/// en: 'Cabang Aktif'
	String get active_branches => 'Cabang Aktif';

	/// en: 'Pendapatan Bulan Ini'
	String get monthly_revenue => 'Pendapatan Bulan Ini';

	/// en: 'Pertumbuhan'
	String get growth => 'Pertumbuhan';

	/// en: 'Undangan Terkirim'
	String get invitations_sent => 'Undangan Terkirim';

	/// en: 'Aktivitas Minggu Ini'
	String get weekly_activity => 'Aktivitas Minggu Ini';

	/// en: 'Skor Kinerja'
	String get performance_score => 'Skor Kinerja';

	/// en: 'Aktif: {count}'
	String get active_users => 'Aktif: {count}';

	/// en: 'Total: {count}'
	String get total_branches => 'Total: {count}';

	/// en: 'Target: {amount}'
	String get revenue_target => 'Target: {amount}';

	/// en: 'Banding bulan lalu'
	String get compare_last_month => 'Banding bulan lalu';

	/// en: '{pending} tertunda, {accepted} diterima'
	String get pending_invitations => '{pending} tertunda, {accepted} diterima';

	/// en: 'Rata-rata: {count}/hari'
	String get daily_average => 'Rata-rata: {count}/hari';

	/// en: 'Sangat Baik'
	String get very_good => 'Sangat Baik';

	/// en: 'Cari brand...'
	String get search_brand => 'Cari brand...';

	/// en: 'Hasil Pencarian'
	String get search_results => 'Hasil Pencarian';

	/// en: 'Tipe'
	String get type => 'Tipe';

	/// en: 'Semua'
	String get all => 'Semua';

	/// en: 'Memuat brands...'
	String get loading_brands => 'Memuat brands...';

	/// en: 'Belum ada brand'
	String get no_brands_available => 'Belum ada brand';

	/// en: 'Buat brand pertama untuk memulai bisnis Anda'
	String get no_brands_message => 'Buat brand pertama untuk memulai bisnis Anda';

	/// en: 'Buat Brand Baru'
	String get create_new_brand => 'Buat Brand Baru';

	/// en: 'Statistik'
	String get statistics => 'Statistik';

	/// en: 'Undangan'
	String get invitations => 'Undangan';

	/// en: 'Transfer'
	String get transfer => 'Transfer';

	/// en: 'Lihat Statistik'
	String get view_statistics => 'Lihat Statistik';

	/// en: 'Kelola Undangan'
	String get manage_invitations => 'Kelola Undangan';

	/// en: 'Transfer Brand'
	String get transfer_brand => 'Transfer Brand';

	/// en: 'Diterima'
	String get received => 'Diterima';

	/// en: 'Terkirim'
	String get sent => 'Terkirim';

	/// en: 'Belum ada undangan yang diterima'
	String get no_received_invitations => 'Belum ada undangan yang diterima';

	/// en: 'Anda belum menerima undangan brand apa pun. Undangan yang diterima akan muncul di sini.'
	String get no_received_invitations_message => 'Anda belum menerima undangan brand apa pun. Undangan yang diterima akan muncul di sini.';

	/// en: 'Belum ada undangan terkirim'
	String get no_sent_invitations => 'Belum ada undangan terkirim';

	/// en: 'Anda belum mengirim undangan brand apa pun. Undangan yang terkirim akan muncul di sini.'
	String get no_sent_invitations_message => 'Anda belum mengirim undangan brand apa pun. Undangan yang terkirim akan muncul di sini.';

	/// en: 'Gagal memuat undangan'
	String get failed_to_load_invitations => 'Gagal memuat undangan';

	/// en: 'Terjadi kesalahan saat memuat undangan yang diterima. Silakan coba lagi.'
	String get failed_to_load_received_invitations => 'Terjadi kesalahan saat memuat undangan yang diterima. Silakan coba lagi.';

	/// en: 'Terjadi kesalahan saat memuat undangan terkirim. Silakan coba lagi.'
	String get failed_to_load_sent_invitations => 'Terjadi kesalahan saat memuat undangan terkirim. Silakan coba lagi.';

	/// en: 'Detail Undangan'
	String get invitation_details => 'Detail Undangan';

	/// en: 'Brand'
	String get brand_label => 'Brand';

	/// en: 'Dari'
	String get from_label => 'Dari';

	/// en: 'Ke'
	String get to_label => 'Ke';

	/// en: 'Peran'
	String get role_label => 'Peran';

	/// en: 'Dikirim'
	String get sent_label => 'Dikirim';

	/// en: 'Kadaluarsa'
	String get expires_label => 'Kadaluarsa';

	/// en: 'Tutup'
	String get close_label => 'Tutup';

	/// en: 'Undang Pengguna Baru'
	String get invite_new_user => 'Undang Pengguna Baru';

	/// en: 'Undang Pengguna Baru'
	String get invite_new_user_tooltip => 'Undang Pengguna Baru';

	/// en: 'Terima'
	String get accept => 'Terima';

	/// en: 'Tolak'
	String get decline => 'Tolak';

	/// en: 'Batal'
	String get cancel => 'Batal';

	/// en: 'Kirim Ulang'
	String get resend => 'Kirim Ulang';

	/// en: 'Tolak'
	String get reject => 'Tolak';

	/// en: 'Pending'
	String get pending => 'Pending';

	/// en: 'Diterima'
	String get accepted => 'Diterima';

	/// en: 'Ditolak'
	String get declined => 'Ditolak';

	/// en: 'Kadaluarsa'
	String get expired => 'Kadaluarsa';

	/// en: 'Pemilik Brand'
	String get brand_owner => 'Pemilik Brand';

	/// en: 'Admin Brand'
	String get brand_admin => 'Admin Brand';

	/// en: 'Manajer Cabang'
	String get branch_manager => 'Manajer Cabang';

	/// en: 'Admin Cabang'
	String get branch_admin => 'Admin Cabang';

	/// en: 'Staf Cabang'
	String get branch_staff => 'Staf Cabang';

	/// en: 'Penonton Lintas Cabang'
	String get cross_branch_viewer => 'Penonton Lintas Cabang';

	/// en: 'Peringatan Transfer Kepemilikanan'
	String get transfer_ownership_warning => 'Peringatan Transfer Kepemilikanan';

	/// en: 'Tindakan ini tidak dapat dibatalkan dan akan mengubah kepemilikanan brand secara permanen. Pastikan Anda memasukkan email yang benar dan pemilik baru telah menyetujui transfer ini.'
	String get transfer_warning_message => 'Tindakan ini tidak dapat dibatalkan dan akan mengubah kepemilikanan brand secara permanen. Pastikan Anda memasukkan email yang benar dan pemilik baru telah menyetujui transfer ini.';

	/// en: 'Email Pemilik Baru'
	String get new_owner_email => 'Email Pemilik Baru';

	/// en: 'Masukkan email pemilik baru'
	String get enter_new_owner_email => 'Masukkan email pemilik baru';

	/// en: 'contoh: user@example.com'
	String get example_email => 'contoh: user@example.com';

	/// en: 'Kode Konfirmasi'
	String get confirmation_code => 'Kode Konfirmasi';

	/// en: 'Masukkan kode konfirmasi'
	String get enter_confirmation_code => 'Masukkan kode konfirmasi';

	/// en: 'Kode 6 digit'
	String get six_digit_code => 'Kode 6 digit';

	/// en: 'Pesan (Opsional)'
	String get message_optional => 'Pesan (Opsional)';

	/// en: 'Pesan untuk pemilik baru'
	String get message_for_new_owner => 'Pesan untuk pemilik baru';

	/// en: 'Tambahkan pesan penjelasan jika diperlukan'
	String get add_explanation_message => 'Tambahkan pesan penjelasan jika diperlukan';

	/// en: 'Detail Transfer'
	String get detail_transfer => 'Detail Transfer';

	/// en: 'Brand ID: {id}'
	String get brand_id_label => 'Brand ID: {id}';

	/// en: 'Tidak ada brand tersedia'
	String get no_brands_available_selector => 'Tidak ada brand tersedia';

	/// en: 'Pilih Brand'
	String get select_brand => 'Pilih Brand';

	/// en: 'Saat ini:'
	String get currently => 'Saat ini:';

	/// en: 'Kembali'
	String get back => 'Kembali';

	/// en: 'Refresh'
	String get refresh => 'Refresh';

	/// en: 'Brand tidak ditemukan'
	String get brand_not_found => 'Brand tidak ditemukan';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return _flatMapFunction$0(path);
	}

	dynamic _flatMapFunction$0(String path) {
		return switch (path) {
			'en.app.title' => 'Usago',
			'en.app.welcome' => 'Welcome',
			'en.auth.login' => 'Login',
			'en.auth.register' => 'Register',
			'en.auth.email' => 'Email',
			'en.auth.password' => 'Password',
			'en.auth.forgot_password' => 'Forgot Password?',
			'en.auth.dont_have_account' => 'Don\'t have an account?',
			'en.auth.welcome_back' => 'Welcome Back',
			'en.auth.sign_in_to_continue' => 'Sign in to continue',
			'en.auth.create_account' => 'Create Account',
			'en.auth.sign_up_to_continue' => 'Sign up to continue',
			'en.auth.already_have_account' => 'Already have an account?',
			'en.auth.name' => 'Name',
			'en.auth.confirm_password' => 'Confirm Password',
			'en.auth.passwords_do_not_match' => 'Passwords do not match',
			'en.auth.enter_your_name' => 'Enter your name',
			'en.auth.enter_your_email' => 'Enter your email',
			'en.auth.enter_your_password' => 'Enter your password',
			'en.auth.confirm_your_password' => 'Confirm your password',
			'en.auth.auth_email' => 'Email',
			'en.auth.auth_password' => 'Password',
			'en.auth.auth_login' => 'Login',
			'en.auth.auth_register' => 'Register',
			'en.auth.auth_forgot_password' => 'Forgot Password?',
			'en.auth.auth_dont_have_account' => 'Don\'t have an account?',
			'en.auth.auth_welcome_back' => 'Welcome Back',
			'en.auth.auth_sign_in_to_continue' => 'Sign in to continue',
			'en.auth.auth_create_account' => 'Create Account',
			'en.auth.auth_sign_up_to_continue' => 'Sign up to continue',
			'en.auth.auth_already_have_account' => 'Already have an account?',
			'en.auth.forgot_password_description' => 'Enter your email address and we\'ll send you a link to reset your password',
			'en.auth.send_reset_link' => 'Send Reset Link',
			'en.auth.remember_password' => 'Remember your password?',
			'en.auth.back_to_login' => 'Back to Login',
			'en.validation.required' => 'This field is required',
			'en.validation.email_invalid' => 'Please enter a valid email',
			'en.validation.password_too_short' => 'Password must be at least 6 characters',
			'en.validation.password_too_long' => 'Password must be less than 50 characters',
			'en.validation.validation_required' => 'This field is required',
			'en.validation.validation_email_invalid' => 'Please enter a valid email',
			'en.validation.validation_password_too_short' => 'Password must be at least 6 characters',
			'en.messages.login_success' => 'Login successful',
			'en.messages.login_failed' => 'Login failed',
			'en.messages.register_success' => 'Registration successful',
			'en.messages.register_failed' => 'Registration failed',
			'en.messages.network_error' => 'Network error. Please check your connection.',
			'en.messages.unknown_error' => 'An unknown error occurred',
			'en.messages.password_reset_email_sent' => 'Password reset email sent to {email}',
			'en.common.ok' => 'OK',
			'en.common.cancel' => 'Cancel',
			'en.common.save' => 'Save',
			'en.common.delete' => 'Delete',
			'en.common.edit' => 'Edit',
			'en.common.loading' => 'Loading...',
			'en.common.retry' => 'Retry',
			'en.common.close' => 'Close',
			'en.home.welcome_message' => 'What would you like to do today? 🎯',
			'en.home.select_feature' => 'Select the available features below',
			'en.home.error_occurred' => 'An error occurred',
			'en.home.no_menu_in_category' => 'No menu in category {category}',
			'en.home.no_menu_available' => 'No menu available',
			'en.home.contact_admin' => 'Contact administrator to access this feature',
			'en.home.you_have_pending_items' => 'You have {count} items that need to be handled',
			'en.home.welcome_back' => 'Welcome back! 👋',
			'en.home.management' => 'Management',
			'en.home.operations' => 'Operations',
			'en.home.reports' => 'Reports',
			'en.home.settings' => 'Settings',
			'en.home.all_menu' => 'All Menu',
			'en.home.logout' => 'Logout',
			'en.brand.create_brand' => 'Create New Brand',
			'en.brand.edit_brand' => 'Edit Brand',
			'en.brand.brand_selection' => 'Select Brand',
			'en.brand.brand_stats' => 'Brand Statistics',
			'en.brand.manage_invitations_page' => 'Manage Invitations',
			'en.brand.transfer_ownership' => 'Transfer Ownership',
			'en.brand.brand_info' => 'Brand Information',
			'en.brand.brand_name' => 'Brand Name',
			'en.brand.enter_brand_name' => 'Enter brand name',
			'en.brand.slug' => 'Slug',
			'en.brand.url_friendly_identifier' => 'URL-friendly identifier',
			'en.brand.description' => 'Description',
			'en.brand.brand_description' => 'Brief brand description (optional)',
			'en.brand.industry' => 'Industry',
			'en.brand.brand_industry' => 'Brand industry (optional)',
			'en.brand.business_type' => 'Business Type',
			'en.brand.timezone' => 'Timezone',
			'en.brand.currency' => 'Currency',
			'en.brand.auto_generate_from_name' => 'Auto-generate from name',
			'en.brand.enable_manual_slug_input' => 'Enable manual slug input',
			'en.brand.auto_generate_from_name_tooltip' => 'Auto-generate from name',
			'en.brand.service' => 'Service',
			'en.brand.retail' => 'Retail',
			'en.brand.manufacturing' => 'Manufacturing',
			'en.brand.other' => 'Other',
			'en.brand.timezone_jakarta' => 'Asia/Jakarta (WIB)',
			'en.brand.timezone_singapore' => 'Asia/Singapore (SGT)',
			'en.brand.timezone_bangkok' => 'Asia/Bangkok (ICT)',
			'en.brand.timezone_kuala_lumpur' => 'Asia/Kuala Lumpur (MYT)',
			'en.brand.timezone_manila' => 'Asia/Manila (PHT)',
			'en.brand.timezone_utc' => 'UTC',
			'en.brand.currency_idr' => 'Indonesian Rupiah (IDR)',
			'en.brand.currency_usd' => 'US Dollar (USD)',
			'en.brand.currency_eur' => 'Euro (EUR)',
			'en.brand.currency_sgd' => 'Singapore Dollar (SGD)',
			'en.brand.currency_myr' => 'Malaysian Ringgit (MYR)',
			'en.brand.currency_thb' => 'Thai Baht (THB)',
			'en.brand.currency_php' => 'Philippine Peso (PHP)',
			'en.brand.create_brand_btn' => 'Create Brand',
			'en.brand.update_brand_btn' => 'Update Brand',
			'en.brand.send_confirmation_code' => 'Send Confirmation Code',
			'en.brand.confirm_transfer' => 'Confirm Transfer',
			'en.brand.send_invitation' => 'Send Invitation',
			'en.brand.invite_user' => 'Invite User',
			'en.brand.brand_created_successfully' => 'Brand created successfully',
			'en.brand.brand_updated_successfully' => 'Brand updated successfully',
			'en.brand.brand_deleted_successfully' => 'Brand deleted successfully',
			'en.brand.invitation_sent_successfully' => 'Invitation sent successfully',
			'en.brand.confirmation_code_sent' => 'Confirmation code has been sent to the new owner\'s email',
			'en.brand.transfer_completed_successfully' => 'Brand ownership transferred successfully',
			'en.brand.brand_name_required' => 'Brand name is required',
			'en.brand.brand_name_min_length' => 'Brand name must be at least 3 characters',
			'en.brand.brand_name_max_length' => 'Brand name must be less than 50 characters',
			'en.brand.slug_required' => 'Slug is required',
			'en.brand.slug_min_length' => 'Slug must be at least 3 characters',
			'en.brand.slug_max_length' => 'Slug must be less than 50 characters',
			'en.brand.slug_invalid_characters' => 'Slug can only contain lowercase letters, numbers, and hyphens (-)',
			'en.brand.description_max_length' => 'Description must be less than 500 characters',
			'en.brand.industry_max_length' => 'Industry must be less than 100 characters',
			'en.brand.email_required' => 'Email is required',
			'en.brand.email_invalid' => 'Please enter a valid email',
			'en.brand.confirmation_code_required' => 'Confirmation code is required',
			'en.brand.confirmation_code_length' => 'Confirmation code must be 6 digits',
			'en.brand.edit_brand_dialog_title' => 'Edit Brand',
			'en.brand.edit_brand_dialog_message' => 'Do you want to edit this brand?',
			'en.brand.delete_brand_dialog_title' => 'Delete Brand',
			'en.brand.delete_brand_dialog_message' => 'Are you sure you want to delete this brand?',
			'en.brand.delete_brand_warning' => 'This action cannot be undone.',
			'en.brand.accept_invitation_dialog_title' => 'Accept Invitation',
			'en.brand.accept_invitation_dialog_message' => 'Are you sure you want to accept the invitation to join {brandName}?',
			'en.brand.accept_invitation_role_info' => 'You will be added to the brand with the role of {role}.',
			'en.brand.decline_invitation_dialog_title' => 'Decline Invitation',
			'en.brand.decline_invitation_dialog_message' => 'Are you sure you want to decline the invitation from {brandName}?',
			'en.brand.cancel_invitation_dialog_title' => 'Cancel Invitation',
			'en.brand.cancel_invitation_dialog_message' => 'Are you sure you want to cancel the invitation to {email}?',
			'en.brand.k_new' => 'NEW',
			'en.brand.active' => 'Active',
			'en.brand.brand_active' => 'Brand Active',
			'en.brand.joined' => 'Joined: {date}',
			'en.brand.status' => 'Status',
			'en.brand.created' => 'Created',
			'en.brand.total_users' => 'Total Users',
			'en.brand.active_branches' => 'Active Branches',
			'en.brand.monthly_revenue' => 'Monthly Revenue',
			'en.brand.growth' => 'Growth',
			'en.brand.invitations_sent' => 'Invitations Sent',
			'en.brand.weekly_activity' => 'Weekly Activity',
			'en.brand.performance_score' => 'Performance Score',
			'en.brand.active_users' => 'Active: {count}',
			'en.brand.total_branches' => 'Total: {count}',
			'en.brand.revenue_target' => 'Target: {amount}',
			'en.brand.compare_last_month' => 'Compare last month',
			'en.brand.pending_invitations' => '{pending} pending, {accepted} accepted',
			'en.brand.daily_average' => 'Average: {count}/day',
			'en.brand.very_good' => 'Very Good',
			'en.brand.search_brand' => 'Search brand...',
			'en.brand.search_results' => 'Search Results',
			'en.brand.type' => 'Type',
			'en.brand.all' => 'All',
			'en.brand.loading_brands' => 'Loading brands...',
			'en.brand.no_brands_available' => 'No brands available',
			'en.brand.no_brands_message' => 'Create your first brand to start your business',
			'en.brand.create_new_brand' => 'Create New Brand',
			'en.brand.statistics' => 'Statistics',
			'en.brand.invitations' => 'Invitations',
			'en.brand.transfer' => 'Transfer',
			'en.brand.view_statistics' => 'View Statistics',
			'en.brand.manage_invitations' => 'Manage Invitations',
			'en.brand.transfer_brand' => 'Transfer Brand',
			'en.brand.received' => 'Received',
			'en.brand.sent' => 'Sent',
			'en.brand.no_received_invitations' => 'No received invitations',
			'en.brand.no_received_invitations_message' => 'You haven\'t received any brand invitations. Received invitations will appear here.',
			'en.brand.no_sent_invitations' => 'No sent invitations',
			'en.brand.no_sent_invitations_message' => 'You haven\'t sent any brand invitations. Sent invitations will appear here.',
			'en.brand.failed_to_load_invitations' => 'Failed to load invitations',
			'en.brand.failed_to_load_received_invitations' => 'An error occurred while loading received invitations. Please try again.',
			'en.brand.failed_to_load_sent_invitations' => 'An error occurred while loading sent invitations. Please try again.',
			'en.brand.invitation_details' => 'Invitation Details',
			'en.brand.brand_label' => 'Brand',
			'en.brand.from_label' => 'From',
			'en.brand.to_label' => 'To',
			'en.brand.role_label' => 'Role',
			'en.brand.sent_label' => 'Sent',
			'en.brand.expires_label' => 'Expires',
			'en.brand.close_label' => 'Close',
			'en.brand.invite_new_user' => 'Invite New User',
			'en.brand.invite_new_user_tooltip' => 'Invite New User',
			'en.brand.accept' => 'Accept',
			'en.brand.decline' => 'Decline',
			'en.brand.cancel' => 'Cancel',
			'en.brand.resend' => 'Resend',
			'en.brand.reject' => 'Reject',
			'en.brand.pending' => 'Pending',
			'en.brand.accepted' => 'Accepted',
			'en.brand.declined' => 'Declined',
			'en.brand.expired' => 'Expired',
			'en.brand.brand_owner' => 'Brand Owner',
			'en.brand.brand_admin' => 'Brand Admin',
			'en.brand.branch_manager' => 'Branch Manager',
			'en.brand.branch_admin' => 'Branch Admin',
			'en.brand.branch_staff' => 'Branch Staff',
			'en.brand.cross_branch_viewer' => 'Cross Branch Viewer',
			'en.brand.transfer_ownership_warning' => 'Ownership Transfer Warning',
			'en.brand.transfer_warning_message' => 'This action cannot be undone and will permanently change the brand ownership. Make sure you enter the correct email and the new owner has approved this transfer.',
			'en.brand.new_owner_email' => 'New Owner Email',
			'en.brand.enter_new_owner_email' => 'Enter new owner email',
			'en.brand.example_email' => 'example: user@example.com',
			'en.brand.confirmation_code' => 'Confirmation Code',
			'en.brand.enter_confirmation_code' => 'Enter confirmation code',
			'en.brand.six_digit_code' => '6-digit code',
			'en.brand.message_optional' => 'Message (Optional)',
			'en.brand.message_for_new_owner' => 'Message for new owner',
			'en.brand.add_explanation_message' => 'Add an explanation message if needed',
			'en.brand.detail_transfer' => 'Detail Transfer',
			'en.brand.brand_id_label' => 'Brand ID: {id}',
			'en.brand.no_brands_available_selector' => 'No brands available',
			'en.brand.select_brand' => 'Select Brand',
			'en.brand.currently' => 'Currently:',
			'en.brand.back' => 'Back',
			'en.brand.refresh' => 'Refresh',
			'en.brand.brand_not_found' => 'Brand not found',
			'id.app.title' => 'Usago',
			'id.app.welcome' => 'Selamat Datang',
			'id.auth.login' => 'Masuk',
			'id.auth.register' => 'Daftar',
			'id.auth.email' => 'Email',
			'id.auth.password' => 'Kata Sandi',
			'id.auth.forgot_password' => 'Lupa Kata Sandi?',
			'id.auth.dont_have_account' => 'Belum punya akun?',
			'id.auth.welcome_back' => 'Selamat Datang Kembali',
			'id.auth.sign_in_to_continue' => 'Masuk untuk melanjutkan',
			'id.auth.create_account' => 'Buat Akun',
			'id.auth.sign_up_to_continue' => 'Daftar untuk melanjutkan',
			'id.auth.already_have_account' => 'Sudah punya akun?',
			'id.auth.name' => 'Nama',
			'id.auth.confirm_password' => 'Konfirmasi Kata Sandi',
			'id.auth.passwords_do_not_match' => 'Kata sandi tidak cocok',
			'id.auth.enter_your_name' => 'Masukkan nama Anda',
			'id.auth.enter_your_email' => 'Masukkan email Anda',
			'id.auth.enter_your_password' => 'Masukkan kata sandi Anda',
			'id.auth.confirm_your_password' => 'Konfirmasi kata sandi Anda',
			'id.auth.forgot_password_description' => 'Masukkan alamat email Anda dan kami akan mengirimkan tautan untuk mengatur ulang kata sandi Anda',
			'id.auth.send_reset_link' => 'Kirim Tautan Reset',
			'id.auth.remember_password' => 'Ingat kata sandi Anda?',
			'id.auth.back_to_login' => 'Kembali ke Login',
			'id.validation.required' => 'Field ini wajib diisi',
			'id.validation.email_invalid' => 'Masukkan email yang valid',
			'id.validation.password_too_short' => 'Kata sandi minimal 6 karakter',
			'id.validation.password_too_long' => 'Kata sandi maksimal 50 karakter',
			'id.validation.validation_required' => 'Field ini wajib diisi',
			'id.validation.validation_email_invalid' => 'Masukkan email yang valid',
			'id.validation.validation_password_too_short' => 'Kata sandi minimal 6 karakter',
			'id.messages.login_success' => 'Login berhasil',
			'id.messages.login_failed' => 'Login gagal',
			'id.messages.register_success' => 'Pendaftaran berhasil',
			'id.messages.register_failed' => 'Pendaftaran gagal',
			'id.messages.network_error' => 'Error jaringan. Periksa koneksi Anda.',
			'id.messages.unknown_error' => 'Terjadi error yang tidak diketahui',
			'id.messages.password_reset_email_sent' => 'Email reset kata sandi telah dikirim ke {email}',
			'id.common.ok' => 'OK',
			'id.common.cancel' => 'Batal',
			'id.common.save' => 'Simpan',
			'id.common.delete' => 'Hapus',
			'id.common.edit' => 'Edit',
			'id.common.loading' => 'Memuat...',
			'id.common.retry' => 'Coba Lagi',
			'id.common.close' => 'Tutup',
			'id.home.welcome_message' => 'Apa yang ingin Anda lakukan hari ini? 🎯',
			'id.home.select_feature' => 'Pilih fitur yang tersedia di bawah ini',
			'id.home.error_occurred' => 'Terjadi kesalahan',
			'id.home.no_menu_in_category' => 'Tidak ada menu dalam kategori {category}',
			'id.home.no_menu_available' => 'Tidak ada menu tersedia',
			'id.home.contact_admin' => 'Hubungi administrator untuk mengakses fitur ini',
			'id.home.you_have_pending_items' => 'Anda memiliki {count} item yang perlu ditangani',
			'id.home.welcome_back' => 'Selamat Datang! 👋',
			'id.home.management' => 'Manajemen',
			'id.home.operations' => 'Operasional',
			'id.home.reports' => 'Laporan',
			'id.home.settings' => 'Pengaturan',
			'id.home.all_menu' => 'Semua Menu',
			'id.home.logout' => 'Keluar',
			'id.brand.create_brand' => 'Buat Brand Baru',
			'id.brand.edit_brand' => 'Edit Brand',
			'id.brand.brand_selection' => 'Pilih Brand',
			'id.brand.brand_stats' => 'Statistik Brand',
			'id.brand.manage_invitations_page' => 'Kelola Undangan',
			'id.brand.transfer_ownership' => 'Transfer Kepemilikanan',
			'id.brand.brand_info' => 'Informasi Brand',
			'id.brand.brand_name' => 'Nama Brand',
			'id.brand.enter_brand_name' => 'Masukkan nama brand',
			'id.brand.slug' => 'Slug',
			'id.brand.url_friendly_identifier' => 'URL-friendly identifier',
			'id.brand.description' => 'Deskripsi',
			'id.brand.brand_description' => 'Deskripsi singkat brand (opsional)',
			'id.brand.industry' => 'Industri',
			'id.brand.brand_industry' => 'Industri brand (opsional)',
			'id.brand.business_type' => 'Tipe Bisnis',
			'id.brand.timezone' => 'Zona Waktu',
			'id.brand.currency' => 'Mata Uang',
			'id.brand.auto_generate_from_name' => 'Auto-generate dari nama',
			'id.brand.enable_manual_slug_input' => 'Enable manual slug input',
			'id.brand.auto_generate_from_name_tooltip' => 'Auto-generate dari nama',
			'id.brand.service' => 'Layanan',
			'id.brand.retail' => 'Ritel',
			'id.brand.manufacturing' => 'Manufaktur',
			'id.brand.other' => 'Lainnya',
			'id.brand.timezone_jakarta' => 'Asia/Jakarta (WIB)',
			'id.brand.timezone_singapore' => 'Asia/Singapore (SGT)',
			'id.brand.timezone_bangkok' => 'Asia/Bangkok (ICT)',
			'id.brand.timezone_kuala_lumpur' => 'Asia/Kuala Lumpur (MYT)',
			'id.brand.timezone_manila' => 'Asia/Manila (PHT)',
			'id.brand.timezone_utc' => 'UTC',
			'id.brand.currency_idr' => 'Rupiah Indonesia (IDR)',
			'id.brand.currency_usd' => 'US Dollar (USD)',
			'id.brand.currency_eur' => 'Euro (EUR)',
			'id.brand.currency_sgd' => 'Singapore Dollar (SGD)',
			'id.brand.currency_myr' => 'Malaysian Ringgit (MYR)',
			'id.brand.currency_thb' => 'Thai Baht (THB)',
			'id.brand.currency_php' => 'Philippine Peso (PHP)',
			'id.brand.create_brand_btn' => 'Buat Brand',
			'id.brand.update_brand_btn' => 'Perbarui Brand',
			'id.brand.send_confirmation_code' => 'Kirim Kode Konfirmasi',
			'id.brand.confirm_transfer' => 'Konfirmasi Transfer',
			'id.brand.send_invitation' => 'Kirim Undangan',
			'id.brand.invite_user' => 'Undang Pengguna',
			'id.brand.brand_created_successfully' => 'Brand berhasil dibuat',
			'id.brand.brand_updated_successfully' => 'Brand berhasil diperbarui',
			'id.brand.brand_deleted_successfully' => 'Brand berhasil dihapus',
			'id.brand.invitation_sent_successfully' => 'Undangan berhasil dikirim',
			'id.brand.confirmation_code_sent' => 'Kode konfirmasi telah dikirim ke email pemilik baru',
			'id.brand.transfer_completed_successfully' => 'Kepemilikanan brand berhasil ditransfer',
			'id.brand.brand_name_required' => 'Nama brand wajib diisi',
			'id.brand.brand_name_min_length' => 'Nama brand minimal 3 karakter',
			'id.brand.brand_name_max_length' => 'Nama brand maksimal 50 karakter',
			'id.brand.slug_required' => 'Slug wajib diisi',
			'id.brand.slug_min_length' => 'Slug minimal 3 karakter',
			'id.brand.slug_max_length' => 'Slug maksimal 50 karakter',
			'id.brand.slug_invalid_characters' => 'Slug hanya boleh mengandung huruf kecil, angka, dan strip (-)',
			'id.brand.description_max_length' => 'Deskripsi maksimal 500 karakter',
			'id.brand.industry_max_length' => 'Industri maksimal 100 karakter',
			'id.brand.email_required' => 'Email wajib diisi',
			'id.brand.email_invalid' => 'Format email tidak valid',
			'id.brand.confirmation_code_required' => 'Kode konfirmasi wajib diisi',
			'id.brand.confirmation_code_length' => 'Kode konfirmasi harus 6 digit',
			'id.brand.edit_brand_dialog_title' => 'Edit Brand',
			'id.brand.edit_brand_dialog_message' => 'Apakah Anda ingin mengedit brand ini?',
			'id.brand.delete_brand_dialog_title' => 'Hapus Brand',
			'id.brand.delete_brand_dialog_message' => 'Apakah Anda yakin ingin menghapus brand ini?',
			'id.brand.delete_brand_warning' => 'Tindakan ini tidak dapat dibatalkan.',
			'id.brand.accept_invitation_dialog_title' => 'Terima Undangan',
			'id.brand.accept_invitation_dialog_message' => 'Apakah Anda yakin ingin menerima undangan untuk bergabung dengan {brandName}?',
			'id.brand.accept_invitation_role_info' => 'Anda akan ditambahkan ke brand dengan peran {role}.',
			'id.brand.decline_invitation_dialog_title' => 'Tolak Undangan',
			'id.brand.decline_invitation_dialog_message' => 'Apakah Anda yakin ingin menolak undangan dari {brandName}?',
			'id.brand.cancel_invitation_dialog_title' => 'Batalkan Undangan',
			'id.brand.cancel_invitation_dialog_message' => 'Apakah Anda yakin ingin membatalkan undangan ke {email}?',
			'id.brand.k_new' => 'BARU',
			'id.brand.active' => 'Aktif',
			'id.brand.brand_active' => 'Brand Aktif',
			'id.brand.joined' => 'Bergabung: {date}',
			'id.brand.status' => 'Status',
			'id.brand.created' => 'Dibuat',
			'id.brand.total_users' => 'Total Pengguna',
			'id.brand.active_branches' => 'Cabang Aktif',
			'id.brand.monthly_revenue' => 'Pendapatan Bulan Ini',
			'id.brand.growth' => 'Pertumbuhan',
			'id.brand.invitations_sent' => 'Undangan Terkirim',
			'id.brand.weekly_activity' => 'Aktivitas Minggu Ini',
			'id.brand.performance_score' => 'Skor Kinerja',
			'id.brand.active_users' => 'Aktif: {count}',
			'id.brand.total_branches' => 'Total: {count}',
			'id.brand.revenue_target' => 'Target: {amount}',
			'id.brand.compare_last_month' => 'Banding bulan lalu',
			'id.brand.pending_invitations' => '{pending} tertunda, {accepted} diterima',
			'id.brand.daily_average' => 'Rata-rata: {count}/hari',
			'id.brand.very_good' => 'Sangat Baik',
			'id.brand.search_brand' => 'Cari brand...',
			'id.brand.search_results' => 'Hasil Pencarian',
			'id.brand.type' => 'Tipe',
			'id.brand.all' => 'Semua',
			'id.brand.loading_brands' => 'Memuat brands...',
			'id.brand.no_brands_available' => 'Belum ada brand',
			'id.brand.no_brands_message' => 'Buat brand pertama untuk memulai bisnis Anda',
			'id.brand.create_new_brand' => 'Buat Brand Baru',
			'id.brand.statistics' => 'Statistik',
			'id.brand.invitations' => 'Undangan',
			'id.brand.transfer' => 'Transfer',
			'id.brand.view_statistics' => 'Lihat Statistik',
			'id.brand.manage_invitations' => 'Kelola Undangan',
			'id.brand.transfer_brand' => 'Transfer Brand',
			'id.brand.received' => 'Diterima',
			'id.brand.sent' => 'Terkirim',
			'id.brand.no_received_invitations' => 'Belum ada undangan yang diterima',
			'id.brand.no_received_invitations_message' => 'Anda belum menerima undangan brand apa pun. Undangan yang diterima akan muncul di sini.',
			'id.brand.no_sent_invitations' => 'Belum ada undangan terkirim',
			'id.brand.no_sent_invitations_message' => 'Anda belum mengirim undangan brand apa pun. Undangan yang terkirim akan muncul di sini.',
			'id.brand.failed_to_load_invitations' => 'Gagal memuat undangan',
			'id.brand.failed_to_load_received_invitations' => 'Terjadi kesalahan saat memuat undangan yang diterima. Silakan coba lagi.',
			'id.brand.failed_to_load_sent_invitations' => 'Terjadi kesalahan saat memuat undangan terkirim. Silakan coba lagi.',
			'id.brand.invitation_details' => 'Detail Undangan',
			'id.brand.brand_label' => 'Brand',
			'id.brand.from_label' => 'Dari',
			'id.brand.to_label' => 'Ke',
			'id.brand.role_label' => 'Peran',
			'id.brand.sent_label' => 'Dikirim',
			'id.brand.expires_label' => 'Kadaluarsa',
			'id.brand.close_label' => 'Tutup',
			'id.brand.invite_new_user' => 'Undang Pengguna Baru',
			'id.brand.invite_new_user_tooltip' => 'Undang Pengguna Baru',
			'id.brand.accept' => 'Terima',
			'id.brand.decline' => 'Tolak',
			'id.brand.cancel' => 'Batal',
			'id.brand.resend' => 'Kirim Ulang',
			'id.brand.reject' => 'Tolak',
			'id.brand.pending' => 'Pending',
			'id.brand.accepted' => 'Diterima',
			'id.brand.declined' => 'Ditolak',
			'id.brand.expired' => 'Kadaluarsa',
			'id.brand.brand_owner' => 'Pemilik Brand',
			'id.brand.brand_admin' => 'Admin Brand',
			'id.brand.branch_manager' => 'Manajer Cabang',
			'id.brand.branch_admin' => 'Admin Cabang',
			'id.brand.branch_staff' => 'Staf Cabang',
			'id.brand.cross_branch_viewer' => 'Penonton Lintas Cabang',
			'id.brand.transfer_ownership_warning' => 'Peringatan Transfer Kepemilikanan',
			'id.brand.transfer_warning_message' => 'Tindakan ini tidak dapat dibatalkan dan akan mengubah kepemilikanan brand secara permanen. Pastikan Anda memasukkan email yang benar dan pemilik baru telah menyetujui transfer ini.',
			'id.brand.new_owner_email' => 'Email Pemilik Baru',
			'id.brand.enter_new_owner_email' => 'Masukkan email pemilik baru',
			'id.brand.example_email' => 'contoh: user@example.com',
			'id.brand.confirmation_code' => 'Kode Konfirmasi',
			'id.brand.enter_confirmation_code' => 'Masukkan kode konfirmasi',
			'id.brand.six_digit_code' => 'Kode 6 digit',
			'id.brand.message_optional' => 'Pesan (Opsional)',
			'id.brand.message_for_new_owner' => 'Pesan untuk pemilik baru',
			'id.brand.add_explanation_message' => 'Tambahkan pesan penjelasan jika diperlukan',
			'id.brand.detail_transfer' => 'Detail Transfer',
			'id.brand.brand_id_label' => 'Brand ID: {id}',
			'id.brand.no_brands_available_selector' => 'Tidak ada brand tersedia',
			'id.brand.select_brand' => 'Pilih Brand',
			'id.brand.currently' => 'Saat ini:',
			'id.brand.back' => 'Kembali',
			'id.brand.refresh' => 'Refresh',
			'id.brand.brand_not_found' => 'Brand tidak ditemukan',
			_ => null,
		};
	}
}

