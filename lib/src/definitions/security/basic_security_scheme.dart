// Copyright 2022 The NAMIB Project Developers. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import '../credentials/basic_credentials.dart';
import 'helper_functions.dart';
import 'security_scheme.dart';

/// Basic Authentication security configuration identified by the Vocabulary
/// Term `basic`.
class BasicSecurityScheme extends SecurityScheme {
  @override
  String get scheme => "basic";

  /// Name for query, header, cookie, or uri parameters.
  String? name;

  /// Specifies the location of security authentication information.
  late String in_ = "header";

  final List<String> _parsedJsonFields = [];

  @override
  BasicCredentials? credentials;

  /// Constructor.
  BasicSecurityScheme(
      {String? description,
      String? proxy,
      this.name,
      String? in_,
      Map<String, String>? descriptions})
      : in_ = in_ ?? "header" {
    this.description = description;
    this.descriptions.addAll(descriptions ?? {});
  }

  dynamic _getJsonValue(Map<String, dynamic> json, String key) {
    _parsedJsonFields.add(key);
    return json[key];
  }

  /// Creates a [BasicSecurityScheme] from a [json] object.
  BasicSecurityScheme.fromJson(Map<String, dynamic> json) {
    _parsedJsonFields.addAll(parseSecurityJson(this, json));

    final dynamic jsonIn = _getJsonValue(json, "in");
    if (jsonIn is String) {
      in_ = jsonIn;
      _parsedJsonFields.add("in");
    }

    final dynamic jsonName = _getJsonValue(json, "name");
    if (jsonName is String) {
      name = jsonName;
      _parsedJsonFields.add("name");
    }

    parseAdditionalFields(additionalFields, json, _parsedJsonFields);
  }
}
