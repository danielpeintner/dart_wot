// Copyright 2021 The NAMIB Project Developers. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:curie/curie.dart';

import '../data_schema.dart';
import '../thing_description.dart';
import 'interaction_affordance.dart';

/// Class representing an [Action] Affordance in a Thing Description.
class Action extends InteractionAffordance {
  /// The schema of the [input] data this [Action] accepts.
  DataSchema? input;

  /// The schema of the [output] data this [Action] produces.
  DataSchema? output;

  /// Creates a new [Action] from a [List] of [forms].
  Action(super.forms, super.thingDescription);

  /// Creates a new [Action] from a [json] object.
  Action.fromJson(Map<String, dynamic> json, ThingDescription thingDescription,
      PrefixMapping prefixMapping)
      : super([], thingDescription) {
    parseAffordanceFields(json, prefixMapping);
  }
}
