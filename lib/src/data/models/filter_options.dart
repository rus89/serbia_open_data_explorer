// ABOUTME: DTOs for filter dropdown options from data.gov.rs licenses, frequencies, organizations APIs.
// ABOUTME: Used by dataset_providers and catalog UI.

/// License option from GET /api/1/datasets/licenses/.
class LicenseOption {
  const LicenseOption({required this.id, required this.title});

  final String id;
  final String title;

  static LicenseOption fromJson(Map<String, dynamic> json) {
    return LicenseOption(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
    );
  }
}

/// Frequency option from GET /api/1/datasets/frequencies/.
class FrequencyOption {
  const FrequencyOption({required this.id, required this.label});

  final String id;
  final String label;

  static FrequencyOption fromJson(Map<String, dynamic> json) {
    return FrequencyOption(
      id: json['id'] as String? ?? '',
      label: json['label'] as String? ?? '',
    );
  }
}

/// Organization option from GET /api/1/organizations/ (data array item).
class OrganizationOption {
  const OrganizationOption({required this.id, required this.name});

  final String id;
  final String name;

  static OrganizationOption fromJson(Map<String, dynamic> json) {
    return OrganizationOption(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }
}
