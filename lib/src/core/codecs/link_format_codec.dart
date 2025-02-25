// Copyright 2022 Contributors to the Eclipse Foundation. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:convert';

import 'package:coap/coap.dart';

import '../../definitions/data_schema.dart';
import 'content_codec.dart';

/// A [ContentCodec] that encodes and decodes the CoRE Link Format ([RFC 6690]).
///
/// [RFC 6690]: https://datatracker.ietf.org/doc/html/rfc6690
class LinkFormatCodec extends ContentCodec {
  @override
  List<int> valueToBytes(
    Object? value,
    DataSchema? dataSchema,
    Map<String, String>? parameters,
  ) {
    // TODO(JKRhb): The question which value types are allowed needs to be
    //              revisited.
    if (value is CoapResource) {
      return CoapLinkFormat.serialize(value).codeUnits;
    }

    throw FormatException('Error deserializing CoRE Link Format', value);
  }

  @override
  Object? bytesToValue(
    List<int> bytes,
    DataSchema? dataSchema,
    Map<String, String>? parameters,
  ) {
    final string = utf8.decode(bytes);
    return CoapLinkFormat.parse(string);
  }
}
