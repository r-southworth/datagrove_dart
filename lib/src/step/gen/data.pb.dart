///
//  Generated code. Do not modify.
//  source: data.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'data.pbenum.dart';

class Grid extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Grid', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..pc<Dim>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'dim', $pb.PbFieldType.PM, subBuilder: Dim.create)
    ..pc<GridStep>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'local', $pb.PbFieldType.PM, subBuilder: GridStep.create)
    ..hasRequiredFields = false
  ;

  Grid._() : super();
  factory Grid({
    $core.Iterable<Dim>? dim,
    $core.Iterable<GridStep>? local,
  }) {
    final _result = create();
    if (dim != null) {
      _result.dim.addAll(dim);
    }
    if (local != null) {
      _result.local.addAll(local);
    }
    return _result;
  }
  factory Grid.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Grid.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Grid clone() => Grid()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Grid copyWith(void Function(Grid) updates) => super.copyWith((message) => updates(message as Grid)) as Grid; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Grid create() => Grid._();
  Grid createEmptyInstance() => create();
  static $pb.PbList<Grid> createRepeated() => $pb.PbList<Grid>();
  @$core.pragma('dart2js:noInline')
  static Grid getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Grid>(create);
  static Grid? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Dim> get dim => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<GridStep> get local => $_getList(1);
}

class Dim extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Dim', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..pc<Style>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'style', $pb.PbFieldType.PM, subBuilder: Style.create)
    ..hasRequiredFields = false
  ;

  Dim._() : super();
  factory Dim({
    $core.Iterable<Style>? style,
  }) {
    final _result = create();
    if (style != null) {
      _result.style.addAll(style);
    }
    return _result;
  }
  factory Dim.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Dim.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Dim clone() => Dim()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Dim copyWith(void Function(Dim) updates) => super.copyWith((message) => updates(message as Dim)) as Dim; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Dim create() => Dim._();
  Dim createEmptyInstance() => create();
  static $pb.PbList<Dim> createRepeated() => $pb.PbList<Dim>();
  @$core.pragma('dart2js:noInline')
  static Dim getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Dim>(create);
  static Dim? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Style> get style => $_getList(0);
}

class Style extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Style', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  Style._() : super();
  factory Style({
    $core.int? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory Style.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Style.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Style clone() => Style()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Style copyWith(void Function(Style) updates) => super.copyWith((message) => updates(message as Style)) as Style; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Style create() => Style._();
  Style createEmptyInstance() => create();
  static $pb.PbList<Style> createRepeated() => $pb.PbList<Style>();
  @$core.pragma('dart2js:noInline')
  static Style getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Style>(create);
  static Style? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class GridStep extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GridStep', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  GridStep._() : super();
  factory GridStep() => create();
  factory GridStep.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GridStep.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GridStep clone() => GridStep()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GridStep copyWith(void Function(GridStep) updates) => super.copyWith((message) => updates(message as GridStep)) as GridStep; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GridStep create() => GridStep._();
  GridStep createEmptyInstance() => create();
  static $pb.PbList<GridStep> createRepeated() => $pb.PbList<GridStep>();
  @$core.pragma('dart2js:noInline')
  static GridStep getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GridStep>(create);
  static GridStep? _defaultInstance;
}

