// Copyright 2021 The NAMIB Project Developers. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:curie/curie.dart';

import '../data_schema.dart';
import '../thing_description.dart';
import 'interaction_affordance.dart';

/// Class representing a [Property] Affordance in a Thing Description.
class Property extends InteractionAffordance implements DataSchema {
  @override
  List<String>? atType;

  @override
  Object? constant;

  @override
  Object? defaultValue;

  @override
  List<Object>? enumeration;

  @override
  String? format;

  @override
  List<DataSchema>? oneOf;

  @override
  bool? readOnly = false;

  @override
  String? type;

  @override
  String? unit;

  @override
  bool? writeOnly = false;


  @override
  Map<String, dynamic>? rawJson;

  /// Default constructor that creates a [Property] from a [List] of [forms].
  Property(super.forms, super.thingDescription);

  /// Creates a new [Property] from a [json] object.
  Property.fromJson(Map<String, dynamic> json,
      ThingDescription thingDescription, PrefixMapping prefixMapping)
      : super([], thingDescription) {
    parseAffordanceFields(json, prefixMapping);
    parseDataSchemaJson(this, json);
    rawJson = json;
  }
}
