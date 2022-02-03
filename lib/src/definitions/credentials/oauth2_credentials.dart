// Copyright 2022 The NAMIB Project Developers. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import 'credentials.dart';

/// [Credentials] used for the `OAuth2SecurityScheme`.
class OAuth2Credentials extends Credentials {
  /// The [identifier] associated with these [OAuth2Credentials].
  String identifier;

  /// The optional secret for these [OAuth2Credentials].
  String? secret;

  /// A JSON string representation of OAuth2 credentials.
  ///
  /// Used to store obtained credentials from an authorization server.
  String? credentialsJson;

  /// Constructor.
  OAuth2Credentials(this.identifier, [this.secret]) : super("oauth2");
}
