// Copyright 2021 The NAMIB Project Developers. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:curie/curie.dart';
import 'package:json_schema2/json_schema2.dart';
import 'package:uri/uri.dart';

import 'credentials/credentials.dart';
import 'expected_response.dart';
import 'interaction_affordances/interaction_affordance.dart';
import 'security/security_scheme.dart';
import 'validation/validation_exception.dart';

/// Contains the information needed for performing interactions with a Thing.
class Form {
  /// The [href] pointing to the resource.
  ///
  /// Can be a relative or absolute URI.
  final Uri href;

  /// An absolute [Uri], which is either the original [href] or a resolved
  /// version using the base [Uri] of the Thing Description.
  final Uri resolvedHref;

  /// The [SecurityScheme]s used by this [Form].
  final List<SecurityScheme> securityDefinitions;

  /// Reference to the [InteractionAffordance] containing this [Form].
  final InteractionAffordance interactionAffordance;

  /// The subprotocol that is used with this [Form].
  String? subprotocol;

  /// The operation types supported by this [Form].
  List<String>? op;

  /// The [contentType] supported by this [Form].
  String contentType = "application/json";

  /// The list of [security] definitions applied to this [Form].
  List<String>? security;

  /// A list of OAuth2 scopes that are supposed to be used with this [Form].
  List<String>? scopes;

  /// The [response] a consumer can expect from interacting with this [Form].
  ExpectedResponse? response;

  /// Additional fields collected during the parsing of a JSON object.
  final Map<String, dynamic> additionalFields = <String, dynamic>{};

  static List<SecurityScheme> _filterSecurityDefinitions(
      InteractionAffordance interactionAffordance, List<String>? security) {
    final thingDescription = interactionAffordance.thingDescription;
    final securityKeys = security ?? thingDescription.security;
    final securityDefinitions =
        interactionAffordance.thingDescription.securityDefinitions;

    return securityKeys.map((securityKey) {
      final securityDefinition = securityDefinitions[securityKey];

      if (securityDefinition == null) {
        throw ValidationException("Form requires a security definition with "
            "key $securityKey, but the Thing Description does not define a "
            "security definition with such a key!");
      }

      return securityDefinition;
    }).toList();
  }

  /// The credentials associated with this [Form].
  ///
  /// Used by augmented [Form]s.
  // TODO(JKRhb): Move to an agumented Form class.
  List<Credentials> credentials = [];

  /// Creates a new [Form] object.
  ///
  /// An [href] has to be provided. A [contentType] is optional.
  Form(this.href, this.interactionAffordance,
      {this.contentType = "application/json",
      this.subprotocol,
      this.security,
      this.op,
      this.scopes,
      this.response,
      Map<String, dynamic>? additionalFields})
      : resolvedHref = _expandHref(href, interactionAffordance),
        securityDefinitions =
            _filterSecurityDefinitions(interactionAffordance, security) {
    if (additionalFields != null) {
      this.additionalFields.addAll(additionalFields);
    }
  }

  static Uri _expandHref(
      Uri href, InteractionAffordance interactionAffordance) {
    final base = interactionAffordance.thingDescription.base;
    if (href.isAbsolute) {
      return href;
    } else if (base != null) {
      return base.resolveUri(href);
    } else {
      throw ValidationException("The form's $href is not an absolute URI, "
          "but the Thing Description does not provide a base field!");
    }
  }

  static Uri _parseHref(
      Map<String, dynamic> json, List<String> parsedJsonFields) {
    final dynamic href = json["href"];
    parsedJsonFields.add("href");
    if (href is String) {
      return Uri.parse(href);
    } else {
      throw ValidationException("'href' field must be a string.");
    }
  }

  /// Creates a new [Form] from a [json] object.
  factory Form.fromJson(
      Map<String, dynamic> json, InteractionAffordance interactionAffordance) {
    final List<String> parsedJsonFields = [];
    final href = _parseHref(json, parsedJsonFields);

    String? subprotocol;
    if (json["subprotocol"] is String) {
      parsedJsonFields.add("subprotocol");
      subprotocol = json["subprotocol"] as String;
    }

    List<String>? op;
    if (json["op"] != null) {
      final dynamic jsonOp = _getJsonValue(json, "op", parsedJsonFields);
      if (jsonOp is String) {
        op = [jsonOp];
      } else if (jsonOp is List<dynamic>) {
        op = jsonOp.whereType<String>().toList(growable: false);
      }
    }

    String contentType = "application/json";
    if (json["contentType"] != null) {
      final dynamic jsonContentType =
          _getJsonValue(json, "contentType", parsedJsonFields);
      if (jsonContentType is String) {
        contentType = jsonContentType;
      }
    }

    List<String>? security;
    if (json["security"] != null) {
      final dynamic jsonSecurity =
          _getJsonValue(json, "security", parsedJsonFields);
      if (jsonSecurity is String) {
        security = [jsonSecurity];
      } else if (jsonSecurity is List<dynamic>) {
        security = jsonSecurity.whereType<String>().toList(growable: false);
      }
    }

    List<String>? scopes;
    if (json["scopes"] != null) {
      final dynamic jsonScopes =
          _getJsonValue(json, "scopes", parsedJsonFields);
      if (jsonScopes is String) {
        scopes = [jsonScopes];
      } else if (jsonScopes is List<dynamic>) {
        scopes = jsonScopes.whereType<String>().toList(growable: false);
      }
    }

    ExpectedResponse? response;
    if (json["response"] != null) {
      final dynamic jsonResponse =
          _getJsonValue(json, "response", parsedJsonFields);
      if (jsonResponse is Map<String, dynamic>) {
        response = ExpectedResponse.fromJson(jsonResponse);
      }
    }

    final additionalFields = _parseAdditionalFields(json, parsedJsonFields,
        interactionAffordance.thingDescription.prefixMapping);

    return Form(href, interactionAffordance,
        contentType: contentType,
        subprotocol: subprotocol,
        op: op,
        scopes: scopes,
        security: security,
        response: response,
        additionalFields: additionalFields);
  }

  static dynamic _getJsonValue(Map<String, dynamic> formJson, String key,
      List<String> parsedJsonFields) {
    parsedJsonFields.add(key);
    return formJson[key];
  }

  static String _expandCurieKey(String key, PrefixMapping prefixMapping) {
    if (key.contains(":")) {
      final prefix = key.split(":")[0];
      if (prefixMapping.getPrefixValue(prefix) != null) {
        key = prefixMapping.expandCurieString(key);
      }
    }
    return key;
  }

  static dynamic _expandCurieValue(dynamic value, PrefixMapping prefixMapping) {
    if (value is String && value.contains(":")) {
      final prefix = value.split(":")[0];
      if (prefixMapping.getPrefixValue(prefix) != null) {
        value = prefixMapping.expandCurieString(value);
      }
    } else if (value is Map<String, dynamic>) {
      return value.map<String, dynamic>((key, dynamic oldValue) {
        final newKey = _expandCurieKey(key, prefixMapping);
        final dynamic newValue = _expandCurieValue(oldValue, prefixMapping);
        return MapEntry<String, dynamic>(newKey, newValue);
      });
    }

    return value;
  }

  static Map<String, dynamic> _parseAdditionalFields(
      Map<String, dynamic> formJson,
      List<String> parsedJsonFields,
      PrefixMapping prefixMapping) {
    final additionalFields = <String, dynamic>{};
    for (final entry in formJson.entries) {
      if (!parsedJsonFields.contains(entry.key)) {
        final String key = _expandCurieKey(entry.key, prefixMapping);
        final dynamic value = _expandCurieValue(entry.value, prefixMapping);

        additionalFields[key] = value;
      }
    }
    return additionalFields;
  }

  /// Creates a deep copy of this [Form].
  Form _copy(Uri newHref) {
    // TODO(JKRhb): Make deep copies of security, scopes, and response.
    final copiedForm = Form(newHref, interactionAffordance)
      ..contentType = contentType
      ..op = op
      ..subprotocol = subprotocol
      ..security = security
      ..scopes = scopes
      ..response = response
      ..additionalFields.addAll(additionalFields);
    return copiedForm;
  }

  void _validateUriVariables(
      List<String> hrefUriVariables,
      Map<String, Object?> affordanceUriVariables,
      Map<String, Object?> uriVariables) {
    final missingTdDefinitions =
        hrefUriVariables.where((element) => !uriVariables.containsKey(element));

    if (missingTdDefinitions.isNotEmpty) {
      throw UriVariableException("$missingTdDefinitions do not have defined "
          "uriVariables in the TD");
    }

    final missingUserInput = hrefUriVariables
        .where((element) => !affordanceUriVariables.containsKey(element));

    if (missingUserInput.isNotEmpty) {
      throw UriVariableException("$missingUserInput did not have defined "
          "Values in the provided InteractionOptions.");
    }

    // We now assert that all user provided values comply to the Schema
    // definition in the TD.
    for (final affordanceUriVariable in affordanceUriVariables.entries) {
      final key = affordanceUriVariable.key;
      final value = affordanceUriVariable.value;

      // TODO(JKRhb): Replace with a Draft 7 validator once it is available
      //              (the original json_schema library which supports Draft 7
      //              does not support sound null safety, yet, and can therefore
      //              not be used. json_schema2, on the other hand, only
      //              supports Draft 6.)
      final schema = JsonSchema.createSchema(value);
      final valid = schema.validate(uriVariables[key]);

      if (!valid) {
        throw ArgumentError("Invalid type for URI variable $key");
      }
    }
  }

  List<String> _filterUriVariables(Uri href) {
    final regex = RegExp(r"{[?+#./;&]?([^}]*)}");
    final decodedUri = Uri.decodeFull(href.toString());
    return regex
        .allMatches(decodedUri)
        .map((e) => e.group(1))
        .whereType<String>()
        .toList(growable: false);
  }

  /// Resolves all [uriVariables] in this [Form] and creates a copy with an
  /// updated [resolvedHref].
  Form resolveUriVariables(Map<String, Object>? uriVariables) {
    final hrefUriVariables = _filterUriVariables(resolvedHref);
    final thingDescription = interactionAffordance.thingDescription;

    // Use global URI variables by default and override them with
    // affordance-level variables, if any
    final Map<String, Object?> affordanceUriVariables = {}
      ..addAll(thingDescription.uriVariables ?? {})
      ..addAll(interactionAffordance.uriVariables ?? {});

    if (hrefUriVariables.isEmpty) {
      // The href uses no uriVariables, therefore we can abort all further
      // checks.
      return this;
    }

    if (affordanceUriVariables.isEmpty) {
      throw UriVariableException("The Form href $href contains URI "
          "variables but the TD does not provide a uriVariables definition.");
    }

    if (uriVariables == null) {
      throw ArgumentError("The Form href $href contains URI variables "
          "but no values were provided as InteractionOptions.");
    }

    // Perform additional validation
    _validateUriVariables(
        hrefUriVariables, affordanceUriVariables, uriVariables);

    // As "{" and "}" are "percent encoded" due to Uri.parse(), we need to
    // revert the encoding first before we can insert the values.
    final decodedHref = Uri.decodeFull(href.toString());

    // Everything should be okay at this point, we can simply insert the values
    // and return the result.
    final newHref = Uri.parse(UriTemplate(decodedHref).expand(uriVariables));
    return _copy(newHref);
  }
}

/// This [Exception] is thrown when [URI variables] are being used in the [Form]
/// of a TD but no (valid) values were provided.
///
/// [URI variables]: https://www.w3.org/TR/wot-thing-description11/#form-uriVariables
class UriVariableException implements Exception {
  /// The error [message].
  final String message;

  /// Constructor.
  UriVariableException(this.message);
}
