// how can we know if we are root? find our route?
import '../editor/editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../client/datagrove_flutter.dart';
import '../ui/menu.dart';

Widget HeadingSliver(String s, {bool first = false}) {
  return SliverToBoxAdapter(
      child: Padding(
    padding: EdgeInsets.only(left: 8.0, top: first ? 0 : 20, bottom: 8),
    child: Text(s, style: headerStyle),
  ));
}

class PageScaffold extends StatefulWidget {
  List<Widget> slivers;
  Widget? leading;
  Widget? title;
  String? search;
  Function()? add;
  Function()? menu;
  List<Widget>? trailing;
  PageScaffold(
      {required this.slivers,
      this.add,
      this.menu,
      // apple search starts hidden,when focused it slides up to a model with a fade in of
      // results.
      this.search,
      this.leading,
      required this.title,
      this.trailing});

  @override
  State<PageScaffold> createState() => _PageScaffoldState();
}

// search will also route
// then come back to here? is that crazy expensive though to stack these up
// in flutter? Is that what search does? or should it replace the stack
// completely? probably replace, but then it needs to build the stack of
// paths back? what if we use a path controller here and don't mess with routes?
class _PageScaffoldState extends State<PageScaffold> {
  final searchFocus = FocusNode();
  bool search_ = false;
  static const List<String> _options = <String>[
    'aardvark',
    'bobcat',
    'chameleon',
  ];
  String? _autocompleteSelection;

  @override
  void initState() {
    super.initState();
    searchFocus.addListener(() {
      setState(() {
        search_ = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (search_) {
      return Column(children: [
        Row(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoSearchTextField(
                placeholder: 'Search',
                suffixIcon: Icon(CupertinoIcons.mic),
                onSuffixTap: () {
                  final dg = Dgf.of(context);
                  //dg.speech.startListening();
                },
                suffixMode: OverlayVisibilityMode.always,
                onChanged: (e) {},
                onSubmitted: (e) {
                  final r =
                      CupertinoPageRoute(builder: (context) => Text("Picked!"));
                  Navigator.of(context).push(r);
                },
              ),
            ),
          ),
          CupertinoButton(
              child: Text("Cancel"),
              onPressed: () {
                setState(() {
                  search_ = false;
                });
              })
        ]),
        Expanded(
            child: CustomScrollView(slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  childCount: 10,
                  (BuildContext context, int index) =>
                      CupertinoListTile(title: Text("$index"))))
        ]))
      ]);
    }
    final tr = widget.trailing ??
        [
          if (widget.add != null)
            CupertinoButton(
                child: Icon(CupertinoIcons.add_circled), onPressed: widget.add),
          if (widget.menu != null)
            CupertinoButton(
                child: Icon(CupertinoIcons.ellipsis_vertical),
                onPressed: widget.menu),
        ];

    return CupertinoPageScaffold(
        child: CustomScrollView(slivers: [
      CupertinoSliverNavigationBar(
          leading: widget.leading ??
              CupertinoButton(
                  child: const Icon(CupertinoIcons.left_chevron),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
          largeTitle: widget.title,
          trailing: Row(mainAxisSize: MainAxisSize.min, children: tr)),
      if (widget.search != null)
        SliverToBoxAdapter(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CupertinoSearchTextField(
              focusNode: searchFocus, placeholder: 'Search ${widget.search}'),
        )),
      ...widget.slivers
    ]));
  }
}

class FormSliver extends StatelessWidget {
  final List<Widget> children;
  Widget? header;
  FormSliver({required this.children, this.header});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: CupertinoFormSection.insetGrouped(
            header: header, children: children));
  }
}

// takes a treecontroller with a category?
// use category to count category items
// or maybe takes a list of tree controllers, then we can wrap in other stuff
// we can break this into a pagescaffold and list sliver.

// in some cases we might want a "+"
class ListSliver2 extends StatefulWidget {
  ListSliver2({Key? key}) : super(key: key);
  @override
  State<ListSliver2> createState() => _ListSliver2State();
}

class _ListSliver2State extends State<ListSliver2> {
  @override
  Widget build(BuildContext context) {
    return SliverAnimatedList(
        initialItemCount: 10,
        itemBuilder: (c, i, a) => CupertinoListTile(
            onTap: () {
              Navigator.of(context).push(
                  CupertinoPageRoute(builder: (context) => EditorScreen()));
            },
            leading: CircleAvatar(
                backgroundColor: CupertinoColors.inactiveGray,
                child: Text("👍")),
            trailing: CupertinoButton(
                child: Icon(CupertinoIcons.ellipsis),
                onPressed: () async {
                  var id = await showCmd(
                      context,
                      <Cmd>[
                        Cmd(id: 'pin', label: 'Pin'),
                        Cmd(id: 'block', label: 'Block'),
                        Cmd(id: 'report', label: 'Report'),
                      ],
                      title: 'pinned $i');
                }),
            title: Text("pinned $i")));
  }
}
/*
class BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        child: Icon(CupertinoIcons.left_chevron),
        onPressed: () {
          Navigator.of(context).pop();
        });
  }
}


class MessageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      CupertinoSliverNavigationBar(
          largeTitle: Text("chatting"),
          leading: BackButton(),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            CupertinoButton(
                child: Icon(CupertinoIcons.add_circled), onPressed: () {}),
            CupertinoButton(
                child: Icon(CupertinoIcons.ellipsis_vertical),
                onPressed: () {
                  showActionSheet(
                      context, <Cmd>[Cmd(id: 'import', label: 'Import')]);
                }),
          ])),
    ]);
  }
}
*/

/// A [CupertinoTextField] that mimics the look and behavior of UIKit's
/// `UISearchTextField`.
///
/// This control defaults to showing the basic parts of a `UISearchTextField`,
/// like the 'Search' placeholder, prefix-ed Search icon, and suffix-ed
/// X-Mark icon.
///
/// To control the text that is displayed in the text field, use the
/// [controller]. For example, to set the initial value of the text field, use
/// a [controller] that already contains some text such as:
///
/// {@tool snippet}
///
/// ```dart
/// class MyPrefilledSearch extends StatefulWidget {
///   const MyPrefilledSearch({Key? key}) : super(key: key);
///
///   @override
///   State<MyPrefilledSearch> createState() => _MyPrefilledSearchState();
/// }
///
/// class _MyPrefilledSearchState extends State<MyPrefilledSearch> {
///   late TextEditingController _textController;
///
///   @override
///   void initState() {
///     super.initState();
///     _textController = TextEditingController(text: 'initial text');
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return CupertinoSearchTextField(controller: _textController);
///   }
/// }
/// ```
/// {@end-tool}
///
/// It is recommended to pass a [ValueChanged<String>] to both [onChanged] and
/// [onSubmitted] parameters in order to be notified once the value of the
/// field changes or is submitted by the keyboard:
///
/// {@tool snippet}
///
/// ```dart
/// class MyPrefilledSearch extends StatefulWidget {
///   const MyPrefilledSearch({Key? key}) : super(key: key);
///
///   @override
///   State<MyPrefilledSearch> createState() => _MyPrefilledSearchState();
/// }
///
/// class _MyPrefilledSearchState extends State<MyPrefilledSearch> {
///   @override
///   Widget build(BuildContext context) {
///     return CupertinoSearchTextField(
///       onChanged: (String value) {
///         print('The text has changed to: $value');
///       },
///       onSubmitted: (String value) {
///         print('Submitted text: $value');
///       },
///     );
///   }
/// }
/// ```
/// {@end-tool}
class CupertinoSearchTextField2 extends StatefulWidget {
  /// Creates a [CupertinoTextField] that mimics the look and behavior of
  /// UIKit's `UISearchTextField`.
  ///
  /// Similar to [CupertinoTextField], to provide a prefilled text entry, pass
  /// in a [TextEditingController] with an initial value to the [controller]
  /// parameter.
  ///
  /// The [onChanged] parameter takes a [ValueChanged<String>] which is invoked
  /// upon a change in the text field's value.
  ///
  /// The [onSubmitted] parameter takes a [ValueChanged<String>] which is
  /// invoked when the keyboard submits.
  ///
  /// To provide a hint placeholder text that appears when the text entry is
  /// empty, pass a [String] to the [placeholder] parameter. This defaults to
  /// 'Search'.
  // TODO(DanielEdrisian): Localize the 'Search' placeholder.
  ///
  /// The [style] and [placeholderStyle] properties allow changing the style of
  /// the text and placeholder of the text field. [placeholderStyle] defaults
  /// to the gray [CupertinoColors.secondaryLabel] iOS color.
  ///
  /// To set the text field's background color and border radius, pass a
  /// [BoxDecoration] to the [decoration] parameter. This defaults to the
  /// default translucent tertiarySystemFill iOS color and 9 px corner radius.
  // TODO(DanielEdrisian): Must make border radius continuous, see
  // https://github.com/flutter/flutter/issues/13914.
  ///
  /// The [itemColor] and [itemSize] properties allow changing the icon color
  /// and icon size of the search icon (prefix) and X-Mark (suffix).
  /// They default to [CupertinoColors.secondaryLabel] and `20.0`.
  ///
  /// The [padding], [prefixInsets], and [suffixInsets] let you set the padding
  /// insets for text, the search icon (prefix), and the X-Mark icon (suffix).
  /// They default to values that replicate the `UISearchTextField` look. These
  /// default fields were determined using the comparison tool in
  /// https://github.com/flutter/platform_tests/.
  ///
  /// To customize the prefix icon, pass a [Widget] to [prefixIcon]. This
  /// defaults to the search icon.
  ///
  /// To customize the suffix icon, pass an [Icon] to [suffixIcon]. This
  /// defaults to the X-Mark.
  ///
  /// To dictate when the X-Mark (suffix) should be visible, a.k.a. only on when
  /// editing, not editing, on always, or on never, pass a
  /// [OverlayVisibilityMode] to [suffixMode]. This defaults to only on when
  /// editing.
  ///
  /// To customize the X-Mark (suffix) action, pass a [VoidCallback] to
  /// [onSuffixTap]. This defaults to clearing the text.
  const CupertinoSearchTextField2({
    Key? key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.style,
    this.placeholder,
    this.placeholderStyle,
    this.decoration,
    this.backgroundColor,
    this.borderRadius,
    this.padding = const EdgeInsetsDirectional.fromSTEB(3.8, 8, 5, 8),
    this.itemColor = CupertinoColors.secondaryLabel,
    this.itemSize = 20.0,
    this.prefixInsets = const EdgeInsetsDirectional.fromSTEB(6, 0, 0, 4),
    this.prefixIcon = const Icon(CupertinoIcons.search),
    this.suffixInsets = const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 2),
    this.suffixIcon = const Icon(CupertinoIcons.xmark_circle_fill),
    this.suffixMode = OverlayVisibilityMode.editing,
    this.onSuffixTap,
    this.restorationId,
    this.focusNode,
    this.autofocus = false,
    this.onTap,
    this.autocorrect = true,
    this.enabled,
  })  : assert(padding != null),
        assert(itemColor != null),
        assert(itemSize != null),
        assert(prefixInsets != null),
        assert(suffixInsets != null),
        assert(suffixIcon != null),
        assert(suffixMode != null),
        assert(
          !((decoration != null) && (backgroundColor != null)),
          'Cannot provide both a background color and a decoration\n'
          'To provide both, use "decoration: BoxDecoration(color: '
          'backgroundColor)"',
        ),
        assert(
          !((decoration != null) && (borderRadius != null)),
          'Cannot provide both a border radius and a decoration\n'
          'To provide both, use "decoration: BoxDecoration(borderRadius: '
          'borderRadius)"',
        ),
        super(key: key);

  /// Controls the text being edited.
  ///
  /// Similar to [CupertinoTextField], to provide a prefilled text entry, pass
  /// in a [TextEditingController] with an initial value to the [controller]
  /// parameter. Defaults to creating its own [TextEditingController].
  final TextEditingController? controller;

  /// Invoked upon user input.
  final ValueChanged<String>? onChanged;

  /// Invoked upon keyboard submission.
  final ValueChanged<String>? onSubmitted;

  /// Allows changing the style of the text.
  ///
  /// Defaults to the gray [CupertinoColors.secondaryLabel] iOS color.
  final TextStyle? style;

  /// A hint placeholder text that appears when the text entry is empty.
  ///
  /// Defaults to 'Search' localized in each supported language.
  final String? placeholder;

  /// Sets the style of the placeholder of the text field.
  ///
  /// Defaults to the gray [CupertinoColors.secondaryLabel] iOS color.
  final TextStyle? placeholderStyle;

  /// Sets the decoration for the text field.
  ///
  /// This property is automatically set using the [backgroundColor] and
  /// [borderRadius] properties, which both have default values. Therefore,
  /// [decoration] has a default value upon building the widget. It is designed
  /// to mimic the look of a `UISearchTextField`.
  final BoxDecoration? decoration;

  /// Set the [decoration] property's background color.
  ///
  /// Can't be set along with the [decoration]. Defaults to the translucent
  /// [CupertinoColors.tertiarySystemFill] iOS color.
  final Color? backgroundColor;

  /// Sets the [decoration] property's border radius.
  ///
  /// Can't be set along with the [decoration]. Defaults to 9 px circular
  /// corner radius.
  // TODO(DanielEdrisian): Must make border radius continuous, see
  // https://github.com/flutter/flutter/issues/13914.
  final BorderRadius? borderRadius;

  /// Sets the padding insets for the text and placeholder.
  ///
  /// Cannot be null. Defaults to padding that replicates the
  /// `UISearchTextField` look. The inset values were determined using the
  /// comparison tool in https://github.com/flutter/platform_tests/.
  final EdgeInsetsGeometry padding;

  /// Sets the color for the suffix and prefix icons.
  ///
  /// Cannot be null. Defaults to [CupertinoColors.secondaryLabel].
  final Color itemColor;

  /// Sets the base icon size for the suffix and prefix icons.
  ///
  /// Cannot be null. The size of the icon is scaled using the accessibility
  /// font scale settings. Defaults to `20.0`.
  final double itemSize;

  /// Sets the padding insets for the suffix.
  ///
  /// Cannot be null. Defaults to padding that replicates the
  /// `UISearchTextField` suffix look. The inset values were determined using
  /// the comparison tool in https://github.com/flutter/platform_tests/.
  final EdgeInsetsGeometry prefixInsets;

  /// Sets a prefix widget.
  ///
  /// Cannot be null. Defaults to an [Icon] widget with the [CupertinoIcons.search] icon.
  final Widget prefixIcon;

  /// Sets the padding insets for the prefix.
  ///
  /// Cannot be null. Defaults to padding that replicates the
  /// `UISearchTextField` prefix look. The inset values were determined using
  /// the comparison tool in https://github.com/flutter/platform_tests/.
  final EdgeInsetsGeometry suffixInsets;

  /// Sets the suffix widget's icon.
  ///
  /// Cannot be null. Defaults to the X-Mark [CupertinoIcons.xmark_circle_fill].
  /// "To change the functionality of the suffix icon, provide a custom
  /// onSuffixTap callback and specify an intuitive suffixIcon.
  final Icon suffixIcon;

  /// Dictates when the X-Mark (suffix) should be visible.
  ///
  /// Cannot be null. Defaults to only on when editing.
  final OverlayVisibilityMode suffixMode;

  /// Sets the X-Mark (suffix) action.
  ///
  /// Defaults to clearing the text. The suffix action is customizable
  /// so that users can override it with other functionality, that isn't
  /// necessarily clearing text.
  final VoidCallback? onSuffixTap;

  /// {@macro flutter.material.textfield.restorationId}
  final String? restorationId;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  /// {@macro flutter.material.textfield.onTap}
  final VoidCallback? onTap;

  /// {@macro flutter.widgets.editableText.autocorrect}
  final bool autocorrect;

  /// Disables the text field when false.
  ///
  /// Text fields in disabled states have a light grey background and don't
  /// respond to touch events including the [prefixIcon] and [suffixIcon] button.
  final bool? enabled;

  @override
  State<StatefulWidget> createState() => _CupertinoSearchTextFieldState2();
}

class _CupertinoSearchTextFieldState2 extends State<CupertinoSearchTextField2>
    with RestorationMixin {
  /// Default value for the border radius. Radius value was determined using the
  /// comparison tool in https://github.com/flutter/platform_tests/.
  final BorderRadius _kDefaultBorderRadius =
      const BorderRadius.all(Radius.circular(9.0));

  RestorableTextEditingController? _controller;

  TextEditingController get _effectiveController =>
      widget.controller ?? _controller!.value;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _createLocalController();
    }
  }

  @override
  void didUpdateWidget(CupertinoSearchTextField2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && oldWidget.controller != null) {
      _createLocalController(oldWidget.controller!.value);
    } else if (widget.controller != null && oldWidget.controller == null) {
      unregisterFromRestoration(_controller!);
      _controller!.dispose();
      _controller = null;
    }
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    if (_controller != null) {
      _registerController();
    }
  }

  void _registerController() {
    assert(_controller != null);
    registerForRestoration(_controller!, 'controller');
  }

  void _createLocalController([TextEditingValue? value]) {
    assert(_controller == null);
    _controller = value == null
        ? RestorableTextEditingController()
        : RestorableTextEditingController.fromValue(value);
    if (!restorePending) {
      _registerController();
    }
  }

  @override
  String? get restorationId => widget.restorationId;

  void _defaultOnSuffixTap() {
    final bool textChanged = _effectiveController.text.isNotEmpty;
    _effectiveController.clear();
    if (widget.onChanged != null && textChanged)
      widget.onChanged!(_effectiveController.text);
  }

  @override
  Widget build(BuildContext context) {
    final String placeholder = widget.placeholder ??
        CupertinoLocalizations.of(context).searchTextFieldPlaceholderLabel;

    final TextStyle placeholderStyle = widget.placeholderStyle ??
        const TextStyle(color: CupertinoColors.systemGrey);

    // The icon size will be scaled by a factor of the accessibility text scale,
    // to follow the behavior of `UISearchTextField`.
    final double scaledIconSize =
        MediaQuery.textScaleFactorOf(context) * widget.itemSize;

    // If decoration was not provided, create a decoration with the provided
    // background color and border radius.
    final BoxDecoration decoration = widget.decoration ??
        BoxDecoration(
          color: widget.backgroundColor ?? CupertinoColors.tertiarySystemFill,
          borderRadius: widget.borderRadius ?? _kDefaultBorderRadius,
        );

    final IconThemeData iconThemeData = IconThemeData(
      color: CupertinoDynamicColor.resolve(widget.itemColor, context),
      size: scaledIconSize,
    );

    final Widget prefix = Padding(
      padding: widget.prefixInsets,
      child: IconTheme(
        data: iconThemeData,
        child: widget.prefixIcon,
      ),
    );

    final Widget suffix = Padding(
      padding: widget.suffixInsets,
      child: CupertinoButton(
        onPressed: widget.onSuffixTap ?? _defaultOnSuffixTap,
        minSize: 0,
        padding: EdgeInsets.zero,
        child: IconTheme(
          data: iconThemeData,
          child: widget.suffixIcon,
        ),
      ),
    );

    return CupertinoTextField(
      controller: _effectiveController,
      decoration: decoration,
      style: widget.style,
      prefix: prefix,
      suffix: suffix,
      onTap: widget.onTap,
      enabled: widget.enabled,
      suffixMode: widget.suffixMode,
      placeholder: placeholder,
      placeholderStyle: placeholderStyle,
      padding: widget.padding,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      autocorrect: widget.autocorrect,
      textInputAction: TextInputAction.search,
    );
  }
}
