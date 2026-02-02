// Bridge file: exports from country_code_picker and aliases
import 'package:country_code_picker/country_code_picker.dart' as _pkg;

export 'package:country_code_picker/country_code_picker.dart' hide CountryCodePicker;

// Alias: use CountryCodePicker as CodePickerWidget
typedef CodePickerWidget = _pkg.CountryCodePicker;
