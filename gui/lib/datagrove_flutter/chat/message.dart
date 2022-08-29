import 'package:universal_io/io.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'dart:math';
import 'util.dart';
import 'messagecontroller.dart' as types;
import 'link_preview.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:equatable/equatable.dart';
import 'chat_theme.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as em;

import 'package:any_link_preview/any_link_preview.dart';

/// Parses provided messages to chat messages (with headers and spacers) and
/// returns them with a gallery
/// Options that allow to open link preview when tapped on image or a title
/// of a preview. By default link preview opens only when tapped on a link itself.
@immutable
class PreviewTapOptions {
  /// Creates preview tap options config
  const PreviewTapOptions({
    this.openOnImageTap = false,
    this.openOnTitleTap = false,
  });

  /// Open link preview when tapped on preview's image
  final bool openOnImageTap;

  /// Open link preview when tapped on preview's title and description
  final bool openOnTitleTap;
}

class Layout {
  final chatMessages = <MessageGroup>[];
  final gallery = <String>[];
}

enum Position { first, middle, last, full }

// I think only one image per group, see how that works
// start another group if we identify the group as having an image
// attached image is a special case where all the images are collected in a gallery.
enum ImageType {
  none,
  linkPreview,
  attachedImage,
  attachedOther,
}

// equatable because we need to diff it.

class MessageGroup extends Equatable {
  final String dateHeader;
  final double spacer;
  final types.Message message;
  final bool first;
  final bool last; // not final, we change it.
  final ImageType imageType;
  final int firstImage;
  final String preview;
  final String link;
  final bool enlargeEmoji;
  final bool isMe;
  BorderRadius borderRadius;

  MessageGroup(
      {required this.message,
      this.spacer = 0,
      this.dateHeader = "",
      required this.first,
      this.last = false,
      this.firstImage = 0,
      this.preview = "",
      this.link = "",
      this.imageType = ImageType.none,
      this.enlargeEmoji = false,
      required this.isMe,
      required this.borderRadius});

  @override
  List<Object?> get props => [
        dateHeader,
        spacer,
        message,
        first,
        last,
        firstImage,
        preview,
        link,
        imageType
      ];
  borderRadiusLtr(BuildContext context) =>
      borderRadius.resolve(Directionality.of(context));

  // first gets the name, and it gets an outside radius
  // last gets the avatar and it gets an outside radius
  // middle doesn't have the avatar and it has muted outside radius.
  bool get topRadius => first;
  bool get bottomRadius => last;
  bool get showName => first && !isMe;
  bool get showAvatar => last && !isMe;
}

Layout calculateChatMessageGroups(types.MessageController c) {
  var r = Layout();
  var shouldShowName = false;
  final s = c.style;
  // this is processing the array from oldest (length-1 of array) to newest, is that best?
  // it allows us to push the result onto the group array so that's nice.
  isMe(types.Message m) => m.author.id == c.user.id;

  var previousCreatedAt = 0;
  var imageIndex = 0;

  bool firstInGroup(int i) {
    if (i == c.messages.length - 1 ||
        c.messages[i].createdAt == null ||
        c.messages[i + 1].createdAt == null) return true;
    final timeGap = c.messages[i].createdAt! - c.messages[i + 1].createdAt!;
    return c.messages[i].author.id != c.messages[i + 1].author.id ||
        timeGap > s.groupMessagesThreshold;
  }

  for (var i = c.messages.length - 1; i >= 0; i--) {
    String dateHeader = "";
    double spacer = 0;
    ImageType it = ImageType.none;
    String link = "";

    final message = c.messages[i];
    final messageCreated = message.createdAt ?? previousCreatedAt;
    final thisMe = isMe(message);

    final timeGap = messageCreated - previousCreatedAt;
    final isFirstInGroup = firstInGroup(i);
    final isLastInGroup = i == 0 || firstInGroup(i - 1);
    if (isFirstInGroup) {
      if (timeGap > s.dateHeaderThreshold && message.createdAt != null) {
        dateHeader = getVerboseDateTimeRepresentation(
          DateTime.fromMillisecondsSinceEpoch(message.createdAt!),
          dateFormat: s.dateFormat,
          dateLocale: s.dateLocale,
          timeFormat: s.timeFormat,
        );
      } else {
        spacer = 12;
      }
    }
    previousCreatedAt = messageCreated;

    // compute what kind of image we have.
    // if the first file is an image, then use that
    // we should potentially cache images here? or maybe send them off
    // to an isolate.
    for (final mf in message.file) {
      if (kIsWeb) {
        if (mf.uri.startsWith('http') || mf.uri.startsWith('blob')) {
          r.gallery.add(mf.uri);
        }
      } else {
        r.gallery.add(mf.uri);
      }
    }
    if (message.file.isNotEmpty) {
      var f = message.file[0];
      it = f.isImage ? ImageType.attachedImage : ImageType.attachedOther;
    } else {
      final urlRegexp = RegExp(regexLink, caseSensitive: false);
      final matches = urlRegexp.firstMatch(message.text);
      if (matches != null) {
        final s = matches.group(0);
        if (s != null) {
          link = s;
        }
        it = ImageType.linkPreview;
      }
    }

    final _enlargeEmojis = message.file.isEmpty &&
        s.emojiEnlargementBehavior != EmojiEnlargementBehavior.never &&
        isConsistsOfEmojis(s.emojiEnlargementBehavior, message);

    final round = Radius.circular(s.theme.messageBorderRadius);
    final square = Radius.zero;

    var br = BorderRadius.only(
        topLeft: (!thisMe && !isFirstInGroup) ? square : round,
        topRight: (thisMe && !isFirstInGroup) ? square : round,
        bottomLeft: (!thisMe && !isLastInGroup) ? square : round,
        bottomRight: (thisMe && !isLastInGroup) ? square : round);

    // the radius has

    r.chatMessages.insert(
        0,
        MessageGroup(
            isMe: thisMe,
            dateHeader: dateHeader,
            message: message,
            first: isFirstInGroup,
            last: isLastInGroup,
            imageType: it,
            spacer: spacer,
            firstImage: imageIndex,
            link: link,
            enlargeEmoji: _enlargeEmojis,
            borderRadius: br));

    imageIndex = r.gallery.length;
  }

  return r;
}

const String _errorImage =
    "https://i.ytimg.com/vi/z8wrRRR7_qU/maxresdefault.jpg";

/// Base widget for all message types in the chat. Renders bubbles around
/// messages and status. Sets maximum width for a message for
/// a nice look on larger screens.
class MessageBox extends StatelessWidget {
  final types.MessageController controller;
  final MessageGroup group;
  final BoxConstraints constraints;
  final Function(BuildContext context, MessageGroup g) imageTap;

  get style {
    return controller.style;
  }

  /// Creates a particular message from any message type
  const MessageBox(
    this.controller,
    this.group,
    this.constraints, {
    required this.imageTap,
    Key? key,
  }) : super(key: key);

  types.Message get message {
    return group.message;
  }

  final showStatus = true;

  Widget _bubbleBuilder(BuildContext context, int width) {
    if (group.enlargeEmoji) {
      return TextMessage(controller, group);
    }
    Widget? image;
    switch (group.imageType) {
      case ImageType.attachedImage:
        image = ImageMessage(controller, group, messageWidth: width);
        break;
      case ImageType.attachedOther:
        image = buildFile(context);
        break;
      case ImageType.linkPreview:
        final ts = group.isMe ? theme.send : theme.receive;
        image = Material(
            child: AnyLinkPreview(
          link: group.link,
          //displayDirection: uiDirection.uiDirectionHorizontal,
          cache: Duration(hours: 1),
          backgroundColor: Colors.grey[300],
          errorWidget: Container(
            color: Colors.grey[300],
            child: Text('Oops!'),
          ),
          errorImage: _errorImage,
        ));
        if (true) {
          image = LinkPreview(
            enableAnimation: true,
            metadataTextStyle: ts.linkDescriptionTextStyle,
            metadataTitleStyle: ts.linkTitleTextStyle,
            onPreviewDataFetched: (types.PreviewData d) {},
            openOnPreviewImageTap: true, //previewTapOptions.openOnImageTap,
            openOnPreviewTitleTap: true, //previewTapOptions.openOnTitleTap,
            padding: EdgeInsets.symmetric(
              horizontal: theme.messageInsetsHorizontal,
              vertical: theme.messageInsetsVertical,
            ),
            previewData: message.previewData,
            text: message.text,
            width: width.toDouble(),
            //textWidget: ,
          );
        }
        break;
      default:
        break;
    }
    //= if (message.file.isNotEmpty) ImageMessage(controller, group)
    //      else if (group.preview.isNotEmpty) _linkPreview(user, width, context)
    // one thing is if we are trying to merge bubbles we have to be careful about widths?

    return Container(
      decoration: BoxDecoration(
        borderRadius: group.borderRadius,
        color: group.isMe ? theme.secondaryColor : theme.primaryColor,
      ),
      child: ClipRRect(
        borderRadius: group.borderRadius,
        child: Column(children: [
          if (message.text.isNotEmpty) TextMessage(controller, group),
          if (image != null) image,
          //Text("(first,last,isme): ${group.first},${group.last},${group.isMe}")
          //Text("Image ${group.imageType}, ${group.link} ${group.firstImage}");
        ]),
      ),
    );
  }

  ChatTheme get theme {
    return controller.style.theme;
  }

  types.User get user {
    return controller.user;
  }

// put time in here?
  Widget _statusBuilder(BuildContext context) {
    switch (message.status) {
      case types.Status.delivered:
      case types.Status.sent:
        return Image.asset(
          'assets/icon-delivered.png',
          color: theme.primaryColor,
          // package: 'flutter_chat_ui',
        );
      case types.Status.error:
        return Image.asset(
          'assets/icon-error.png',
          color: theme.errorColor,
          // package: 'flutter_chat_ui',
        );
      case types.Status.seen:
        return Image.asset(
          'assets/icon-seen.png',
          color: theme.send.bodyTextStyle.color,
          // package: 'flutter_chat_ui',
        );
      case types.Status.sending:
        return const Center(
          child: SizedBox(
            height: 10,
            width: 10,
            child: CupertinoActivityIndicator(
                // backgroundColor: Colors.transparent,
                // strokeWidth: 1.5,
                // valueColor: AlwaysStoppedAnimation<Color>(
                //   theme.primaryColor,
                // ),
                ),
          ),
        );
      default:
        return const SizedBox();
    }
  }

  Widget buildFile(BuildContext context) {
    types.MessageFile m = message.file[0];
    //final l10n = controller.style.l10n;
    final ts = group.isMe ? theme.send : theme.receive;
    final _color = ts.documentIconColor;

    return Semantics(
      //label: l10n.fileButtonAccessibilityLabel,
      child: Container(
        padding: EdgeInsetsDirectional.fromSTEB(
          theme.messageInsetsVertical,
          theme.messageInsetsVertical,
          theme.messageInsetsHorizontal,
          theme.messageInsetsVertical,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: _color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(21),
              ),
              height: 42,
              width: 42,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (m.isLoading)
                    Positioned.fill(
                      child: CupertinoActivityIndicator(
                        color: _color,
                        // strokeWidth: 2,
                      ),
                    ),
                  CupertinoButton(
                      child: Icon(CupertinoIcons.doc), onPressed: () {}),
                ],
              ),
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsetsDirectional.only(
                  start: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m.name,
                      style: group.isMe
                          ? theme.send.bodyTextStyle
                          : theme.receive.bodyTextStyle,
                      textWidthBasis: TextWidthBasis.longestLine,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 4,
                      ),
                      child: Text(
                        formatBytes(m.length.truncate()),
                        style: ts.captionTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget reactable(BuildContext context, Widget w) {
    item(String s, void Function() fn) {
      return CupertinoContextMenuAction(child: Text(s), onPressed: fn);
    }

    return CupertinoContextMenu(actions: <Widget>[
      item("React", () async {
        String s = await pickEmoji(context);
        Navigator.pop(context);
      }),
      item("Reply", () {}),
      item("Forward", () {}),
      item("Copy", () {}),
      item("Select", () {}),
      item("Info", () {}),
      item("Delete", () {}),
    ], child: w);
  }

  // we might need to consider this in layout? does it affect the groups?

  @override
  Widget build(BuildContext context) {
    final style = controller.style;
    final messageWidth = min(constraints.maxWidth * 0.78, 440).floor();

    final _query = MediaQuery.of(context);
    final _user = user;

    return Column(children: [
      if (group.spacer > 0)
        SizedBox(
          height: group.spacer,
        ),
      if (group.dateHeader.isNotEmpty)
        Container(
          alignment: Alignment.center,
          margin: style.theme.dateDividerMargin,
          child: Text(
            group.dateHeader,
            style: style.theme.dateDividerTextStyle,
          ),
        ),
      Container(
        alignment: group.isMe
            ? AlignmentDirectional.centerEnd
            : AlignmentDirectional.centerStart,
        margin: EdgeInsetsDirectional.only(
          bottom: 4,
          end: kIsWeb ? 0 : _query.padding.right,
          start: 20 + (kIsWeb ? 0 : _query.padding.left),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            group.showAvatar
                ? UserAvatar(controller,
                    author: message.author,
                    onTap: controller.onAvatarTap(context, message))
                : const SizedBox(width: 40),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: messageWidth.toDouble(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                      onDoubleTap: () =>
                          controller.onMessageDoubleTap(context, message),
                      onLongPress: () =>
                          controller.onMessageLongpress(context, message),
                      onTap: () => controller.onMessageTap(context, message),
                      child: VisibilityDetector(
                        key: Key(message.id),
                        onVisibilityChanged: (visibilityInfo) =>
                            controller.onMessageVisibilityChanged(
                                message, visibilityInfo.visibleFraction > 0.1),
                        child: reactable(
                            context,
                            _bubbleBuilder(
                                context,
                                //.resolve(Directionality.of(context)),
                                messageWidth)),
                      )),
                ],
              ),
            ),
            if (group.isMe)
              Padding(
                padding: theme.statusIconPadding,
                child: showStatus
                    ? GestureDetector(
                        onLongPress: () => controller.onMessageStatusLongPress(
                            context, message),
                        onTap: () =>
                            controller.onMessageStatusTap(context, message),
                        child: _statusBuilder(context),
                      )
                    : null,
              ),
          ],
        ),
      )
    ]);
  }
}

/// A class that represents image message widget. Supports different
/// aspect ratios, renders blurred image as a background which is visible
/// if the image is narrow, renders image in form of a file if aspect
/// ratio is very small or very big.
class ImageMessage extends StatefulWidget {
  /// Creates an image message widget based on [types.ImageMessage]
  const ImageMessage(
    this.controller,
    this.group, {
    Key? key,
    required this.messageWidth,
  }) : super(key: key);

  /// [types.ImageMessage]
  final MessageGroup group;
  final types.MessageController controller;

  /// Maximum message width
  final int messageWidth;

  @override
  _ImageMessageState createState() => _ImageMessageState();
}

/// [ImageMessage] widget state
class _ImageMessageState extends State<ImageMessage> {
  ImageProvider? _image;
  ImageStream? _stream;
  Size _size = const Size(0, 0);

  types.Message get message => widget.group.message;
  types.MessageFile get file => widget.group.message.file[0];
  MessageGroup get group => widget.group;

  @override
  void initState() {
    super.initState();
    _image = NetworkImage(file.uri);
    _size = Size(file.width.toDouble(), file.height.toDouble());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_size.isEmpty) {
      _getImage();
    }
  }

  void _getImage() {
    final oldImageStream = _stream;
    _stream = _image?.resolve(createLocalImageConfiguration(context));
    if (_stream?.key == oldImageStream?.key) {
      return;
    }
    final listener = ImageStreamListener(_updateImage);
    oldImageStream?.removeListener(listener);
    _stream?.addListener(listener);
  }

  void _updateImage(ImageInfo info, bool _) {
    setState(() {
      _size = Size(
        info.image.width.toDouble(),
        info.image.height.toDouble(),
      );
    });
  }

  @override
  void dispose() {
    _stream?.removeListener(ImageStreamListener(_updateImage));
    super.dispose();
  }

  get user {
    return widget.controller.user;
  }

  get theme {
    return widget.controller.style.theme;
  }

  @override
  Widget build(BuildContext context) {
    final _user = user;

    if (_size.aspectRatio == 0) {
      return Container(
        color: theme.secondaryColor,
        height: _size.height,
        width: _size.width,
      );
    } else if (_size.aspectRatio < 0.1 || _size.aspectRatio > 10) {
      return Container(
        color: group.isMe ? theme.primaryColor : theme.secondaryColor,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 64,
              margin: EdgeInsetsDirectional.fromSTEB(
                theme.messageInsetsVertical,
                theme.messageInsetsVertical,
                16,
                theme.messageInsetsVertical,
              ),
              width: 64,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image(
                  fit: BoxFit.cover,
                  image: _image!,
                ),
              ),
            ),
            Flexible(
              child: Container(
                margin: EdgeInsetsDirectional.fromSTEB(
                  0,
                  theme.messageInsetsVertical,
                  theme.messageInsetsHorizontal,
                  theme.messageInsetsVertical,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.name,
                      style: group.isMe
                          ? theme.sentMessageBodyTextStyle
                          : theme.receivedMessageBodyTextStyle,
                      textWidthBasis: TextWidthBasis.longestLine,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 4,
                      ),
                      child: Text(
                        formatBytes(file.length.truncate()),
                        style: group.isMe
                            ? theme.sentMessageCaptionTextStyle
                            : theme.receivedMessageCaptionTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        constraints: BoxConstraints(
          maxHeight: widget.messageWidth.toDouble(),
          minWidth: 170,
        ),
        child: AspectRatio(
          aspectRatio: _size.aspectRatio > 0 ? _size.aspectRatio : 1,
          child: Image(
            fit: BoxFit.contain,
            image: _image!,
          ),
        ),
      );
    }
  }
}

// uses flutter_parsed_text to inline some markdown commands.

/// A class that represents text message widget with optional link preview
class TextMessage extends StatelessWidget {
  /// Creates a text message widget from a [types.TextMessage] class
  const TextMessage(
    this.controller,
    this.group, {
    Key? key,
  }) : super(key: key);

  final types.MessageController controller;
  final MessageGroup group;
  get user {
    return controller.user;
  }

  get style {
    return controller.style;
  }

  get message => group.message;

  ChatTheme get theme {
    return controller.style.theme;
  }

  Widget _textWidgetBuilder(
    types.User user,
    BuildContext context,
    bool enlargeEmojis,
  ) {
    //CupertinoTheme.of(context).platform == TargetPlatform.iOS;
    final ts = group.isMe ? theme.send : theme.receive;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (group.showName) UserName(controller, message.author),
        if (enlargeEmojis)
          Text(message.text, style: ts.emojiTextStyle)
        else
          Md1(message.text, ts)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _enlargeEmojis =
        isConsistsOfEmojis(style.emojiEnlargementBehavior, message);
    final _theme = theme;
    final _user = user;
    final _width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: _theme.messageInsetsHorizontal,
        vertical: _theme.messageInsetsVertical,
      ),
      child: _textWidgetBuilder(_user, context, _enlargeEmojis),
    );
  }
}

class Md1 extends StatelessWidget {
  Md1(this.text, this.ts);
  String text;
  ChatTextTheme ts;

  @override
  Widget build(BuildContext context) {
    return ParsedText(
      parse: [
        MatchText(
          onTap: (mail) async {
            final url = 'mailto:$mail';
            if (await canLaunch(url)) {
              await launch(url);
            }
          },
          pattern: regexEmail,
          style: ts.bodyLinkTextStyle ??
              ts.bodyTextStyle.copyWith(
                decoration: TextDecoration.underline,
              ),
        ),
        MatchText(
          onTap: (url) async {
            if (await canLaunch(url)) {
              await launch(url);
            }
          },
          pattern: regexLink,
          style: ts.bodyLinkTextStyle ??
              ts.bodyTextStyle.copyWith(
                decoration: TextDecoration.underline,
              ),
        ),
        MatchText(
          pattern: '(\\*\\*|\\*)(.*?)(\\*\\*|\\*)',
          style: ts.boldTextStyle ??
              ts.bodyTextStyle.copyWith(fontWeight: FontWeight.bold),
          renderText: ({required String str, required String pattern}) {
            return {'display': str.replaceAll(RegExp('(\\*\\*|\\*)'), '')};
          },
        ),
        MatchText(
          pattern: '_(.*?)_',
          style: ts.bodyTextStyle.copyWith(fontStyle: FontStyle.italic),
          renderText: ({required String str, required String pattern}) {
            return {'display': str.replaceAll('_', '')};
          },
        ),
        MatchText(
          pattern: '~(.*?)~',
          style: ts.bodyTextStyle.copyWith(
            decoration: TextDecoration.lineThrough,
          ),
          renderText: ({required String str, required String pattern}) {
            return {'display': str.replaceAll('~', '')};
          },
        ),
        MatchText(
          pattern: '`(.*?)`',
          style: ts.codeTextStyle,
          renderText: ({required String str, required String pattern}) {
            return {'display': str.replaceAll('`', '')};
          },
        ),
      ],
      regexOptions: const RegexOptions(multiLine: true, dotAll: true),
      selectable: true,
      style: ts.bodyTextStyle,
      text: text,
      textWidthBasis: TextWidthBasis.longestLine,
    );
  }
}

/// Renders user's avatar or initials next to a message
class UserAvatar extends StatelessWidget {
  /// Creates user avatar
  const UserAvatar(
    this.controller, {
    Key? key,
    required this.author,
    this.onTap,
  }) : super(key: key);
  final types.MessageController controller;

  /// Author to show image and name initials from
  final types.User author;

  /// Called when user taps on an avatar
  final void Function(types.User)? onTap;

  @override
  Widget build(BuildContext context) {
    final style = controller.style.theme;
    final color = getUserAvatarNameColor(
      author,
      style.userAvatarNameColors,
    );
    final hasImage = author.imageUrl != null;
    final initials = getUserInitials(author);

    return Container(
      margin: const EdgeInsetsDirectional.only(end: 8),
      child: GestureDetector(
        onTap: () => onTap?.call(author),
        child: CircleAvatar(
          backgroundColor:
              hasImage ? style.userAvatarImageBackgroundColor : color,
          backgroundImage: hasImage ? NetworkImage(author.imageUrl!) : null,
          radius: 16,
          child: !hasImage
              ? Text(
                  initials,
                  style: style.userAvatarTextStyle,
                )
              : null,
        ),
      ),
    );
  }
}

/// Renders user's name as a message heading according to the theme
class UserName extends StatelessWidget {
  /// Creates user name
  const UserName(
    this.controller,
    this.author, {
    Key? key,
  }) : super(key: key);
  final types.MessageController controller;

  /// Author to show name from
  final types.User author;

  @override
  Widget build(BuildContext context) {
    final theme = controller.style.theme;
    final color = getUserAvatarNameColor(author, theme.userAvatarNameColors);
    final name = getUserName(author);

    return name.isEmpty
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.userNameTextStyle.copyWith(color: color),
            ),
          );
  }
}

Future<String> pickEmoji(BuildContext context) async {
  return await Navigator.of(context).push(CupertinoPageRoute(
    builder: (context) => EmojiDialog(),
  ));
}

class EmojiDialog extends StatefulWidget {
  @override
  State<EmojiDialog> createState() => _EmojiDialogState();

  // probably not a cupertino route because no tabs here.

}

class _EmojiDialogState extends State<EmojiDialog> {
  @override
  Widget emojiPicker(BuildContext context) {
    done(String s) {
      Navigator.pop(context, s);
    }

    nav() {
      return CupertinoNavigationBar(
          leading: CupertinoButton(
              onPressed: () => done(""),
              child: Icon(CupertinoIcons.xmark_circle)),
          middle: Text("Choose Reaction"));
    }

    var topPick = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          for (final o in ["👍", "👎", "‼️", "😭", "😂", "❤️", "🙏"])
            CupertinoButton(
              onPressed: () {
                done(o);
              },
              child: Text(o, style: TextStyle(fontSize: 28)),
            )
        ]));

    var pick = Expanded(
        child: em.EmojiPicker(
      onEmojiSelected: (category, emoji) {
        done(emoji.emoji);
      },
      config: em.Config(
          columns: 7,
          emojiSizeMax: 32 *
              (Platform.isIOS
                  ? 1.30
                  : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
          verticalSpacing: 0,
          horizontalSpacing: 0,
          initCategory: em.Category.SMILEYS,
          bgColor: CupertinoColors.black,
          indicatorColor: Colors.blue,
          iconColor: Colors.grey,
          iconColorSelected: Colors.blue,
          progressIndicatorColor: Colors.blue,
          backspaceColor: Colors.blue,
          skinToneDialogBgColor: Colors.white,
          skinToneIndicatorColor: Colors.grey,
          enableSkinTones: true,
          showRecentsTab: true,
          recentsLimit: 28,
          // noRecentsText: "No Recents",
          // noRecentsStyle: const TextStyle(fontSize: 20, color: Colors.black26),
          tabIndicatorAnimDuration: kTabScrollDuration,
          categoryIcons: const em.CategoryIcons(),
          buttonMode: em.ButtonMode.CUPERTINO),
    ));
    // show action sheet from the bottom - like pressable
    return CupertinoPageScaffold(
        navigationBar: nav(),
        child: SafeArea(
            child: Material(
                color: Colors.transparent,
                child: Column(children: [topPick, pick]))));
  }

  Widget build(BuildContext context) {
    return emojiPicker(context);
  }
}
