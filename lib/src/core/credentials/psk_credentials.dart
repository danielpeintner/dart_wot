// Copyright 2022 Contributors to the Eclipse Foundation. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:typed_data';

import '../../definitions/security/psk_security_scheme.dart';
import 'credentials.dart';

/// [Credentials] used for the [PskSecurityScheme].
final class PskCredentials extends Credentials {
  /// Constructor.
  PskCredentials({required this.preSharedKey, required this.identity});

  /// The [identity] associated with these [PskCredentials].
  ///
  /// May be omitted if the corresponding Security Definition in the TD already
  /// specifies an identity.
  final Uint8List identity;

  /// The [preSharedKey] associated with these [PskCredentials].
  final Uint8List preSharedKey;
}
