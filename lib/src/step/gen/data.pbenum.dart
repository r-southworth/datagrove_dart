///
//  Generated code. Do not modify.
//  source: data.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class GridStepOp extends $pb.ProtobufEnum {
  static const GridStepOp dim = GridStepOp._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'dim');
  static const GridStepOp style = GridStepOp._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'style');
  static const GridStepOp cell = GridStepOp._(-1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'cell');

  static const $core.List<GridStepOp> values = <GridStepOp> [
    dim,
    style,
    cell,
  ];

  static final $core.Map<$core.int, GridStepOp> _byValue = $pb.ProtobufEnum.initByValue(values);
  static GridStepOp? valueOf($core.int value) => _byValue[value];

  const GridStepOp._($core.int v, $core.String n) : super(v, n);
}

