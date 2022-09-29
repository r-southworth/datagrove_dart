///
//  Generated code. Do not modify.
//  source: data.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use gridStepOpDescriptor instead')
const GridStepOp$json = const {
  '1': 'GridStepOp',
  '2': const [
    const {'1': 'dim', '2': 0},
    const {'1': 'style', '2': 1},
    const {'1': 'cell', '2': -1},
  ],
};

/// Descriptor for `GridStepOp`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List gridStepOpDescriptor = $convert.base64Decode('CgpHcmlkU3RlcE9wEgcKA2RpbRAAEgkKBXN0eWxlEAESEQoEY2VsbBD///////////8B');
@$core.Deprecated('Use gridDescriptor instead')
const Grid$json = const {
  '1': 'Grid',
  '2': const [
    const {'1': 'dim', '3': 1, '4': 3, '5': 11, '6': '.tutorial.Dim', '10': 'dim'},
    const {'1': 'local', '3': 2, '4': 3, '5': 11, '6': '.tutorial.GridStep', '10': 'local'},
  ],
};

/// Descriptor for `Grid`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gridDescriptor = $convert.base64Decode('CgRHcmlkEh8KA2RpbRgBIAMoCzINLnR1dG9yaWFsLkRpbVIDZGltEigKBWxvY2FsGAIgAygLMhIudHV0b3JpYWwuR3JpZFN0ZXBSBWxvY2Fs');
@$core.Deprecated('Use dimDescriptor instead')
const Dim$json = const {
  '1': 'Dim',
  '2': const [
    const {'1': 'style', '3': 1, '4': 3, '5': 11, '6': '.tutorial.Style', '10': 'style'},
  ],
};

/// Descriptor for `Dim`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dimDescriptor = $convert.base64Decode('CgNEaW0SJQoFc3R5bGUYASADKAsyDy50dXRvcmlhbC5TdHlsZVIFc3R5bGU=');
@$core.Deprecated('Use styleDescriptor instead')
const Style$json = const {
  '1': 'Style',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
  ],
};

/// Descriptor for `Style`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List styleDescriptor = $convert.base64Decode('CgVTdHlsZRIOCgJpZBgBIAEoBVICaWQ=');
@$core.Deprecated('Use gridStepDescriptor instead')
const GridStep$json = const {
  '1': 'GridStep',
};

/// Descriptor for `GridStep`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gridStepDescriptor = $convert.base64Decode('CghHcmlkU3RlcA==');
