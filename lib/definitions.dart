// Copyright 2021 Contributors to the Eclipse Foundation. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

/// Provides Thing Description and Thing Model Definitions that follow the
/// [WoT Thing Description Specification][spec link].
///
/// [spec link]: https://www.w3.org/TR/wot-thing-description11/
library definitions;

export 'src/definitions/form.dart';
export 'src/definitions/thing_description.dart';
export 'src/definitions/thing_model.dart';
export 'src/definitions/validation/thing_description_schema.dart'
    show thingDescriptionSchema;
