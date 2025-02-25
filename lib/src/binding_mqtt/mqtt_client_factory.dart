// Copyright 2022 Contributors to the Eclipse Foundation. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import '../core/protocol_interfaces/protocol_client.dart';
import '../core/protocol_interfaces/protocol_client_factory.dart';

import '../core/security_provider.dart';
import 'constants.dart';
import 'mqtt_client.dart';
import 'mqtt_config.dart';

/// [ProtocolClientFactory] for creating [MqttClient]s.
final class MqttClientFactory implements ProtocolClientFactory {
  @override
  ProtocolClient createClient([
    ClientSecurityProvider? clientSecurityProvider,
    MqttConfig? mqttConfig,
  ]) =>
      MqttClient(clientSecurityProvider, mqttConfig);

  @override
  bool destroy() {
    return true;
  }

  @override
  bool init() {
    return true;
  }

  @override
  Set<String> get schemes => {mqttUriScheme, mqttSecureUriScheme};
}
