import '../di/injector.dart' show Injector;
import 'dom_sanitization_service.dart';
import 'html_sanitizer.dart';
import 'style_sanitizer.dart';
import 'url_sanitizer.dart';

@Injector()
class DomSanitizationServiceImpl implements DomSanitizationService {
  static const _instance = DomSanitizationServiceImpl._();

  // Force a global static singleton across DDC instances for this service. In
  // angular currently it is already a single instance across all instances for
  // performance reasons. This allows a check to occur that this is really the
  // same sanitizer is used.
  factory DomSanitizationServiceImpl() => _instance;

  // Const to enforce statelessness.
  const DomSanitizationServiceImpl._();

  @override
  String? sanitizeHtml(Object? stringOrSafeOrBypass) {
    if (stringOrSafeOrBypass == null) {
      return null;
    }
    final unsafeString = stringOrSafeOrBypass.toString();
    return sanitizeHtmlInternal(unsafeString);
  }

  @override
  String? sanitizeStyle(Object? stringOrSafeOrBypass) {
    if (stringOrSafeOrBypass == null) {
      return null;
    }
    final unsafeString = stringOrSafeOrBypass.toString();
    return internalSanitizeStyle(unsafeString);
  }

  @override
  String? sanitizeUrl(Object? stringOrSafeOrBypass) {
    if (stringOrSafeOrBypass == null) {
      return null;
    }
    final unsafeString = stringOrSafeOrBypass.toString();
    return internalSanitizeUrl(unsafeString);
  }

  @override
  String? sanitizeResourceUrl(Object? stringOrSafeOrBypass) {
    if (stringOrSafeOrBypass == null) {
      return null;
    }
    return stringOrSafeOrBypass.toString();
  }

  @override
  SafeHtml bypassSecurityTrustHtml(String value) => SafeHtmlImpl(value);

  @override
  SafeStyle bypassSecurityTrustStyle(String value) =>
      SafeStyleImpl(value);

  @override
  SafeUrl bypassSecurityTrustUrl(String value) => SafeUrlImpl(value);

  @override
  SafeResourceUrl bypassSecurityTrustResourceUrl(String value) =>
      SafeResourceUrlImpl(value);
}

abstract class SafeValueImpl implements SafeValue {
  /// Named this way to allow security teams to
  /// to search for BypassSecurityTrust across code base.
  final String changingThisWillBypassSecurityTrust;
  SafeValueImpl(this.changingThisWillBypassSecurityTrust);

  @override
  String toString() => changingThisWillBypassSecurityTrust;
}

class SafeHtmlImpl extends SafeValueImpl implements SafeHtml {
  SafeHtmlImpl(String value) : super(value);
}

class SafeStyleImpl extends SafeValueImpl implements SafeStyle {
  SafeStyleImpl(String value) : super(value);
}

class SafeUrlImpl extends SafeValueImpl implements SafeUrl {
  SafeUrlImpl(String value) : super(value);
}

class SafeResourceUrlImpl extends SafeValueImpl implements SafeResourceUrl {
  SafeResourceUrlImpl(String value) : super(value);
}
