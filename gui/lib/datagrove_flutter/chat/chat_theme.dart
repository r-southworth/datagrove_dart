// ignore_for_file: unnecessary_import

import 'package:universal_io/io.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//import 'chat_l10n.dart';

// For internal usage only. Use values from theme itself.

/// Base chat theme containing all required properties to make a theme.
/// Extend this class if you want to create a custom theme.
@immutable
class ChatTheme {
  const ChatTheme({
    required this.attachmentButtonIcon,
    required this.attachmentButtonMargin,
    required this.backgroundColor,
    required this.dateDividerMargin,
    required this.dateDividerTextStyle,
    required this.deliveredIcon,
    required this.documentIcon,
    required this.emptyChatPlaceholderTextStyle,
    required this.errorColor,
    required this.errorIcon,
    required this.inputBackgroundColor,
    required this.inputBorderRadius,
    this.inputContainerDecoration,
    required this.inputMargin,
    required this.inputPadding,
    required this.inputTextColor,
    this.inputTextCursorColor,
    required this.inputTextDecoration,
    required this.inputTextStyle,
    required this.messageBorderRadius,
    required this.messageInsetsHorizontal,
    required this.messageInsetsVertical,
    required this.primaryColor,
    required this.secondaryColor,
    required this.seenIcon,
    required this.sendButtonIcon,
    required this.sendButtonMargin,
    required this.sendingIcon,
    required this.statusIconPadding,
    required this.userAvatarImageBackgroundColor,
    required this.userAvatarNameColors,
    required this.userAvatarTextStyle,
    required this.userNameTextStyle,
    required this.send,
    required this.receive,
  });

  /// Icon for select attachment button
  final Widget? attachmentButtonIcon;

  /// Margin of attachment button
  final EdgeInsets? attachmentButtonMargin;

  /// Used as a background color of a chat widget
  final Color backgroundColor;

  /// Margin around date dividers
  final EdgeInsets dateDividerMargin;

  /// Text style of the date dividers
  final TextStyle dateDividerTextStyle;

  /// Icon for message's `delivered` status. For the best look use size of 16.
  final Widget? deliveredIcon;

  /// Icon inside file message
  final Widget? documentIcon;

  /// Text style of the empty chat placeholder
  final TextStyle emptyChatPlaceholderTextStyle;

  /// Color to indicate something bad happened (usually - shades of red)
  final Color errorColor;

  /// Icon for message's `error` status. For the best look use size of 16.
  final Widget? errorIcon;

  /// Color of the bottom bar where text field is
  final Color inputBackgroundColor;

  /// Top border radius of the bottom bar where text field is
  final BorderRadius inputBorderRadius;

  /// Decoration of the container wrapping the text field
  final Decoration? inputContainerDecoration;

  /// Outer insets of the bottom bar where text field is
  final EdgeInsets inputMargin;

  /// Inner insets of the bottom bar where text field is
  final EdgeInsets inputPadding;

  /// Color of the text field's text and attachment/send buttons
  final Color inputTextColor;

  /// Color of the text field's cursor
  final Color? inputTextCursorColor;

  /// Decoration of the input text field
  final BoxDecoration inputTextDecoration;

  /// Text style of the message input. To change the color use [inputTextColor].
  final TextStyle inputTextStyle;

  /// Border radius of message container
  final double messageBorderRadius;

  /// Horizontal message bubble insets
  final double messageInsetsHorizontal;

  /// Vertical message bubble insets
  final double messageInsetsVertical;

  /// Primary color of the chat used as a background of sent messages
  /// and statuses
  final Color primaryColor;

  /// Secondary color, used as a background of received messages
  final Color secondaryColor;

  /// Icon for message's `seen` status. For the best look use size of 16.
  final Widget? seenIcon;

  /// Icon for send button
  final Widget? sendButtonIcon;

  /// Margin of send button
  final EdgeInsets? sendButtonMargin;

  /// Icon for message's `sending` status. For the best look use size of 10.
  final Widget? sendingIcon;

  final ChatTextTheme send;
  final ChatTextTheme receive;

  /// Padding around status icons
  final EdgeInsets statusIconPadding;

  /// Color used as a background for user avatar if an image is provided.
  /// Visible if the image has some transparent parts.
  final Color userAvatarImageBackgroundColor;

  /// Colors used as backgrounds for user avatars with no image and so,
  /// corresponding user names.
  /// Calculated based on a user ID, so unique across the whole app.
  final List<Color> userAvatarNameColors;

  /// Text style used for displaying initials on user avatar if no
  /// image is provided
  final TextStyle userAvatarTextStyle;

  /// User names text style. Color will be overwritten with [userAvatarNameColors].
  final TextStyle userNameTextStyle;
}

/// See [ChatTheme.userAvatarNameColors]
const colors = [
  Color(0xffff6767),
  Color(0xff66e0da),
  Color(0xfff5a2d9),
  Color(0xfff0c722),
  Color(0xff6a85e5),
  Color(0xfffd9a6f),
  Color(0xff92db6e),
  Color(0xff73b8e5),
  Color(0xfffd7590),
  Color(0xffc78ae5),
];

const background = CupertinoColors.black;

// this is used for the time messages, text directly on the background
const backgroundText = Color(0xff9e9cab);

const primary = CupertinoColors.darkBackgroundGray; //Color(0xff6f61e8);
const primaryText = CupertinoColors.white;
const primaryTextWithOpacity = primaryText;

const secondary = CupertinoColors.inactiveGray; ////(0xfff5f5f7);
const secondaryText = CupertinoColors.white;
const secondaryTextWithOpacity = secondaryText;

const dark = Color(0xff1f1c38);
const error = Color(0xffff6767);
const inputBackgroundColor = Color(0xff1d1c21);

ChatTheme defaultChatTheme() {
  final codeFont =
      (Platform.isIOS | Platform.isMacOS) ? 'Courier' : 'monospace';

  EdgeInsets? attachmentButtonMargin;
  Color backgroundColor = background;
  EdgeInsets dateDividerMargin = const EdgeInsets.only(
    bottom: 32,
    top: 16,
  );
  TextStyle dateDividerTextStyle = const TextStyle(
    color: backgroundText,
    fontSize: 12,
    fontWeight: FontWeight.w800,
    height: 1.333,
  );
  TextStyle emptyChatPlaceholderTextStyle = const TextStyle(
    color: backgroundText,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );
  Color errorColor = error;
  BorderRadius inputBorderRadius = const BorderRadius.vertical(
    top: Radius.circular(20),
  );
  Decoration? inputContainerDecoration;
  EdgeInsets inputMargin = EdgeInsets.zero;
  EdgeInsets inputPadding = const EdgeInsets.fromLTRB(24, 20, 24, 20);
  Color inputTextColor = primaryText;
  Color? inputTextCursorColor;
  BoxDecoration inputTextDecoration = const BoxDecoration(
      // border: InputBorder.none,
      // contentPadding: EdgeInsets.zero,
      // isCollapsed: true,
      );
  TextStyle inputTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );
  double messageBorderRadius = 20;
  double messageInsetsHorizontal = 20;
  double messageInsetsVertical = 16;
  Color primaryColor = primary;
  TextStyle receivedEmojiMessageTextStyle = const TextStyle(fontSize: 40);
  TextStyle? receivedMessageboldTextStyle;

  TextStyle? receivedMessageBodyLinkTextStyle;
  TextStyle receivedMessageBodyTextStyle = const TextStyle(
    color: secondaryText,
    fontSize: 16,
    fontWeight: FontWeight.w300,
    height: 1.5,
  );
  final receivedMessagecodeTextStyle =
      receivedMessageBodyTextStyle.copyWith(fontFamily: codeFont);
  TextStyle receivedMessageCaptionTextStyle = const TextStyle(
    color: secondaryText,
    fontSize: 12,
    fontWeight: FontWeight.w300,
    height: 1.333,
  );
  Color receivedMessageDocumentIconColor = primary;
  TextStyle receivedMessageLinkDescriptionTextStyle = const TextStyle(
    color: secondaryText,
    fontSize: 14,
    fontWeight: FontWeight.w300,
    height: 1.428,
  );
  TextStyle receivedMessageLinkTitleTextStyle = const TextStyle(
    color: secondaryText,
    fontSize: 16,
    fontWeight: FontWeight.w800,
    height: 1.375,
  );
  Color secondaryColor = secondary;

  Widget? attachmentButtonIcon;
  Widget? deliveredIcon;
  Widget? documentIcon;
  Widget? errorIcon;
  Widget? seenIcon;
  Widget? sendButtonIcon;
  EdgeInsets? sendButtonMargin;
  Widget? sendingIcon;

  TextStyle sentEmojiMessageTextStyle = const TextStyle(fontSize: 40);
  TextStyle? sentMessageboldTextStyle;

  TextStyle? sentMessageBodyLinkTextStyle;
  // this is the primary text
  TextStyle sentMessageBodyTextStyle = const TextStyle(
    color: primaryText,
    fontSize: 16,
    fontWeight: FontWeight.w300,
    height: 1.5,
  );
  final sentMessagecodeTextStyle =
      sentMessageBodyTextStyle.copyWith(fontFamily: codeFont);
  TextStyle sentMessageCaptionTextStyle = const TextStyle(
    color: primaryTextWithOpacity,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.333,
  );
  Color sentMessageDocumentIconColor = primaryText;
  TextStyle sentMessageLinkDescriptionTextStyle = const TextStyle(
    color: primaryText,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.428,
  );
  TextStyle sentMessageLinkTitleTextStyle = const TextStyle(
    color: primaryText,
    fontSize: 16,
    fontWeight: FontWeight.w800,
    height: 1.375,
  );
  EdgeInsets statusIconPadding = const EdgeInsets.symmetric(horizontal: 4);
  // Color userAvatarImageBackgroundColor = CupertinoColors.transparent,
  List<Color> userAvatarNameColors = colors;
  TextStyle userAvatarTextStyle = const TextStyle(
    color: primaryText,
    fontSize: 12,
    fontWeight: FontWeight.w800,
    height: 1.333,
  );
  TextStyle userNameTextStyle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w800,
    height: 1.333,
  );
  ChatTextTheme rcv = ChatTextTheme(
      emojiTextStyle: receivedEmojiMessageTextStyle,
      boldTextStyle: receivedMessageboldTextStyle,
      codeTextStyle: receivedMessagecodeTextStyle,
      bodyLinkTextStyle: receivedMessageBodyLinkTextStyle,
      bodyTextStyle: receivedMessageBodyTextStyle,
      captionTextStyle: receivedMessageCaptionTextStyle,
      documentIconColor: receivedMessageDocumentIconColor,
      linkDescriptionTextStyle: receivedMessageLinkDescriptionTextStyle,
      linkTitleTextStyle: receivedMessageLinkTitleTextStyle);
  ChatTextTheme send = ChatTextTheme(
      emojiTextStyle: sentEmojiMessageTextStyle,
      boldTextStyle: sentMessageboldTextStyle,
      codeTextStyle: sentMessagecodeTextStyle,
      bodyLinkTextStyle: sentMessageBodyLinkTextStyle,
      bodyTextStyle: sentMessageBodyTextStyle,
      captionTextStyle: sentMessageCaptionTextStyle,
      documentIconColor: sentMessageDocumentIconColor,
      linkDescriptionTextStyle: sentMessageLinkDescriptionTextStyle,
      linkTitleTextStyle: sentMessageLinkTitleTextStyle);

  return ChatTheme(
      attachmentButtonIcon: attachmentButtonIcon,
      attachmentButtonMargin: attachmentButtonMargin,
      backgroundColor: backgroundColor,
      dateDividerMargin: dateDividerMargin,
      dateDividerTextStyle: dateDividerTextStyle,
      deliveredIcon: deliveredIcon,
      documentIcon: documentIcon,
      emptyChatPlaceholderTextStyle: emptyChatPlaceholderTextStyle,
      errorColor: errorColor,
      errorIcon: errorIcon,
      inputBackgroundColor: inputBackgroundColor,
      inputBorderRadius: inputBorderRadius,
      inputContainerDecoration: inputContainerDecoration,
      inputMargin: inputMargin,
      inputPadding: inputPadding,
      inputTextColor: inputTextColor,
      inputTextCursorColor: inputTextCursorColor,
      inputTextDecoration: inputTextDecoration,
      inputTextStyle: inputTextStyle,
      messageBorderRadius: messageBorderRadius,
      messageInsetsHorizontal: messageInsetsHorizontal,
      messageInsetsVertical: messageInsetsVertical,
      primaryColor: primaryColor,
      receive: rcv,
      send: send,
      secondaryColor: secondaryColor,
      seenIcon: seenIcon,
      sendButtonIcon: sendButtonIcon,
      sendButtonMargin: sendButtonMargin,
      sendingIcon: sendingIcon,
      statusIconPadding: statusIconPadding,
      userAvatarImageBackgroundColor:
          sentMessageDocumentIconColor, // userAvatarImageBackgroundColor,
      userAvatarNameColors: userAvatarNameColors,
      userAvatarTextStyle: userAvatarTextStyle,
      userNameTextStyle: userNameTextStyle);
}

class ChatTextTheme {
  const ChatTextTheme({
    required this.emojiTextStyle,
    this.boldTextStyle,
    this.codeTextStyle,
    this.bodyLinkTextStyle,
    required this.bodyTextStyle,
    required this.captionTextStyle,
    required this.documentIconColor,
    required this.linkDescriptionTextStyle,
    required this.linkTitleTextStyle,
  });

  /// Text style used for displaying emojis on text messages
  final TextStyle emojiTextStyle;

  /// Body text style used for displaying bold text on received text messages.
  /// Default to a bold version of [ messageBodyTextStyle].
  final TextStyle? boldTextStyle;

  /// Body text style used for displaying code text on received text messages.
  /// Defaults to a mono version of [ messageBodyTextStyle].
  final TextStyle? codeTextStyle;

  /// Text style used for displaying link text on received text messages.
  /// Defaults to [ messageBodyTextStyle]
  final TextStyle? bodyLinkTextStyle;

  /// Body text style used for displaying text on different types
  /// of received messages
  final TextStyle bodyTextStyle;

  /// Caption text style used for displaying secondary info (e.g. file size)
  /// on different types of received messages
  final TextStyle captionTextStyle;

  /// Color of the document icon on received messages. Has no effect when
  /// [documentIcon] is used.
  final Color documentIconColor;

  /// Text style used for displaying link description on received messages
  final TextStyle linkDescriptionTextStyle;

  /// Text style used for displaying link title on received messages
  final TextStyle linkTitleTextStyle;
}

/* I need something like this 
void _handleMessageTap(BuildContext context, types.Message message) async {
  if (message is types.FileMessage) {
    await OpenFile.open(message.uri);
  }
}
*/
// this should be an interface
// how does the chat list use this to get its list of messages?
// it needs to be a notifier
enum EmojiEnlargementBehavior {
  /// The emojis will be enlarged only if the [types.TextMessage] consists of
  /// one or more emojis.
  multi,

  /// Never enlarge emojis.
  never,

  /// The emoji will be enlarged only if the [types.TextMessage] consists of
  /// a single emoji.
  single,
}

class ChatStyle {
  ChatStyle({
    //this.l10n = const ChatL10nEn(),
    this.groupMessagesThreshold = 60000,
    this.dateFormat,
    this.dateHeaderThreshold = 900000,
    this.dateLocale,
    this.timeFormat,
  });

  ChatTheme theme = defaultChatTheme();
  final DateFormat? timeFormat;

  /// Time (in ms) between two messages when we will visually group them.
  /// Default value is 1 minute, 60000 ms. When time between two messages
  /// is lower than this threshold, they will be visually grouped.
  // final ChatL10n l10n;

  /// Allows you to customize the date format. IMPORTANT: only for the date,
  /// do not return time here. See [timeFormat] to customize the time format.
  /// [dateLocale] will be ignored if you use this, so if you want a localized date
  /// make sure you initialize your [DateFormat] with a locale. See [customDateHeaderText]
  /// for more customization.
  final DateFormat? dateFormat;

  /// Time (in ms) between two messages when we will render a date header.
  /// Default value is 15 minutes, 900000 ms. When time between two messages
  /// is higher than this threshold, date header will be rendered. Also,
  /// not related to this value, date header will be rendered on every new day.
  final int groupMessagesThreshold;
  final int dateHeaderThreshold;

  /// Locale will be passed to the `Intl` package. Make sure you initialized
  /// date formatting in your app before passing any locale here, otherwise
  /// an error will be thrown. Also see [customDateHeaderText], [dateFormat], [timeFormat].
  final String? dateLocale;

  final emojiEnlargementBehavior = EmojiEnlargementBehavior.multi;
}
