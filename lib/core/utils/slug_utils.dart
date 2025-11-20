/// Utility class untuk operasi slug
class SlugUtils {
  /// Generate slug dari string input
  /// Contoh: "My Amazing Business!" -> "my-amazing-business"
  static String generateFromText(String text) {
    String slug = text
        .toLowerCase()
        .trim()
        // Replace spasi dan karakter special dengan dash
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        // Remove leading/trailing dashes
        .replaceAll(RegExp(r'^-+|-+$'), '');

    // Ensure max length
    if (slug.length > 100) {
      slug = slug.substring(0, 100);
    }

    return slug;
  }

  /// Validasi format slug
  static bool isValidSlug(String slug) {
    if (slug.isEmpty) return false;
    if (slug.length < 2 || slug.length > 100) return false;

    // Hanya lowercase, angka, dan dash
    final slugRegex = RegExp(r'^[a-z0-9-]+$');
    if (!slugRegex.hasMatch(slug)) return false;

    // Tidak boleh dimulai atau diakhiri dengan dash
    if (slug.startsWith('-') || slug.endsWith('-')) return false;

    return true;
  }

  /// Sanitize slug untuk memastikan format yang benar
  static String sanitize(String input) {
    String slug = generateFromText(input);

    // Remove consecutive dashes
    slug = slug.replaceAll(RegExp(r'-+'), '-');

    // Remove leading/trailing dashes
    slug = slug.replaceAll(RegExp(r'^-+|-+$'), '');

    return slug;
  }

  /// Generate slug unik dengan menambahkan suffix jika perlu
  static String generateUnique(String baseSlug, List<String> existingSlugs) {
    String slug = baseSlug;
    int counter = 1;

    while (existingSlugs.contains(slug)) {
      slug = '$baseSlug-$counter';
      counter++;

      // Safety check
      if (counter > 1000) {
        throw Exception('Unable to generate unique slug after 1000 attempts');
      }
    }

    return slug;
  }
}
