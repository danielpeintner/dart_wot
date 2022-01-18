// Copyright 2022 The NAMIB Project Developers. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import '../core/protocol_interfaces/protocol_client.dart';
import '../core/protocol_interfaces/protocol_client_factory.dart';
import 'http_client.dart';
import 'http_config.dart';

/// A [ProtocolClientFactory] that produces HTTP and HTTPS clients.
class HttpClientFactory extends ProtocolClientFactory {
  @override
  Set<String> get schemes => {"http", "https"};

  /// The [HttpConfig] used to configure new clients.
  final HttpConfig? httpConfig;

  /// Creates a new [HttpClientFactory] based on an optional [HttpConfig].
  HttpClientFactory([this.httpConfig]);

  @override
  bool destroy() {
    // TODO(JKRhb): Check if there is anything to destroy.
    return true;
  }

  @override
  ProtocolClient createClient() => HttpClient(httpConfig);

  @override
  bool init() {
    // TODO(JKRhb): Check if there is anything to init.
    return true;
  }
}
