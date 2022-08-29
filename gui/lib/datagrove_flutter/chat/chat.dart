import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:diffutil_dart/diffutil.dart' as diffutil;
import 'package:photo_view/photo_view_gallery.dart';

import 'messagecontroller.dart';
import 'message.dart';

// chat combines the image gallery with the underlying stream
// ChatList is the core scroller.
class Chat extends StatefulWidget {
  Chat(this.controller);
  MessageController controller;

  @override
  _ChatState createState() => _ChatState();
}

/// [Chat] widget state
class _ChatState extends State<Chat> {
  List<MessageGroup> _chatGroup = [];
  List<String> _gallery = [];
  int _imageViewIndex = 0;
  bool _isImageViewVisible = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() => setState(() {}));
    didUpdateWidget(widget);
  }

  @override
  void didUpdateWidget(covariant Chat oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller.messages.isNotEmpty) {
      final result = calculateChatMessageGroups(widget.controller);
      _chatGroup = result.chatMessages;
      _gallery = result.gallery;
    }
  }

  Widget _imageGalleryBuilder() {
    void _onCloseGalleryPressed() {
      setState(() {
        _isImageViewVisible = false;
      });
    }

    Widget _imageGalleryLoadingBuilder(
      BuildContext context,
      ImageChunkEvent? event,
    ) {
      return const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CupertinoActivityIndicator(
              // value: event == null || event.expectedTotalBytes == null
              //     ? 0
              //     : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
              ),
        ),
      );
    }

    return Dismissible(
      key: const Key('photo_view_gallery'),
      direction: DismissDirection.down,
      onDismissed: (direction) => _onCloseGalleryPressed(),
      child: Stack(
        children: [
          PhotoViewGallery.builder(
            builder: (BuildContext context, int index) =>
                PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(_gallery[index]),
            ),
            itemCount: _gallery.length,
            loadingBuilder: (context, event) =>
                _imageGalleryLoadingBuilder(context, event),
            onPageChanged: (int index) {
              setState(() {
                _imageViewIndex = index;
              });
            },
            pageController: PageController(initialPage: _imageViewIndex),
            scrollPhysics: const ClampingScrollPhysics(),
          ),
          Positioned.directional(
            end: 16,
            textDirection: Directionality.of(context),
            top: 56,
            child: CupertinoButton.filled(
              child: const Text("Close"),
              onPressed: _onCloseGalleryPressed,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.controller.style;

    Widget emptyState() {
      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Text(
          "",
          //style.l10n.emptyChatPlaceholder,
          style: style.theme.emptyChatPlaceholderTextStyle,
          textAlign: TextAlign.center,
        ),
      );
    }

    // isLastPage: widget.isLastPage,
    // onEndReached: widget.onEndReached,
    // onEndReachedThreshold: widget.onEndReachedThreshold,
    // scrollController: widget.scrollController,
    // scrollPhysics: widget.scrollPhysics,

    Widget mb1(MessageGroup g) {
      return Text(g.message.id);
    }

    Widget mb2(MessageGroup g, BoxConstraints constraints) {
      return MessageBox(
        widget.controller,
        g,
        constraints,
        imageTap: (BuildContext context, MessageGroup group) {
          setState(() {
            _imageViewIndex = group.firstImage;
            _isImageViewVisible = true;
          });
        },
      );
    }

    Widget layout() {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => ChatList(
          widget.controller,
          itemBuilder: (item, index) => mb2(item as MessageGroup, constraints),
          items: _chatGroup,
        ),
      );
    }

    return Stack(
      children: [
        Container(
          color: style.theme.backgroundColor,
          child: Column(
            children: [
              Flexible(
                child: widget.controller.messages.isEmpty
                    ? SizedBox.expand(
                        child: emptyState(),
                      )
                    : GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          widget.controller.onBackgroundTap();
                        },
                        child: layout()),
              ),
            ],
          ),
        ),
        if (_isImageViewVisible) _imageGalleryBuilder(),
      ],
    );
  }
}

/// Animated list which handles automatic animations and pagination
/// will this work with replacing message groups?
class ChatList extends StatefulWidget {
  /// Creates a chat list widget
  ChatList(
    this.controller, {
    Key? key,
    this.isLastPage,
    required this.itemBuilder,
    required this.items,
    this.onEndReached,
    this.onEndReachedThreshold,
    this.scrollController,
    this.scrollPhysics,
  }) : super(key: key);
  MessageController controller;

  /// Used for pagination (infinite scroll) together with [onEndReached].
  /// When true, indicates that there are no more pages to load and
  /// pagination will not be triggered.
  final bool? isLastPage;

  /// Items to build
  final List<Object> items;

  /// Item builder
  final Widget Function(Object, int? index) itemBuilder;

  /// Used for pagination (infinite scroll). Called when user scrolls
  /// to the very end of the list (minus [onEndReachedThreshold]).
  final Future<void> Function()? onEndReached;

  /// Used for pagination (infinite scroll) together with [onEndReached].
  /// Can be anything from 0 to 1, where 0 is immediate load of the next page
  /// as soon as scroll starts, and 1 is load of the next page only if scrolled
  /// to the very end of the list. Default value is 0.75, e.g. start loading
  /// next page when scrolled through about 3/4 of the available content.
  final double? onEndReachedThreshold;

  /// Used to control the chat list scroll view
  final ScrollController? scrollController;

  /// Determines the physics of the scroll view
  final ScrollPhysics? scrollPhysics;

  @override
  _ChatListState createState() => _ChatListState();
}

/// [ChatList] widget state
class _ChatListState extends State<ChatList>
    with SingleTickerProviderStateMixin {
  bool _isNextPageLoading = false;
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();
  late List<Object> _oldData = List.from(widget.items);
  late ScrollController _scrollController;

  late final AnimationController _controller = AnimationController(vsync: this);

  late final Animation<double> _animation = CurvedAnimation(
    curve: Curves.easeOutQuad,
    parent: _controller,
  );

  @override
  void initState() {
    super.initState();

    _scrollController = widget.scrollController ?? ScrollController();
    didUpdateWidget(widget);
  }

  @override
  void didUpdateWidget(covariant ChatList oldWidget) {
    super.didUpdateWidget(oldWidget);

    _calculateDiffs(oldWidget.items);
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
    _scrollController.dispose();
  }

  // this assumes that we have the dictionary for each message
  // is this a
  void _calculateDiffs(List<Object> oldList) async {
    final diffResult = diffutil.calculateListDiff<Object>(
      oldList,
      widget.items,
      equalityChecker: (item1, item2) {
        if (item1 is Map<String, Object> && item2 is Map<String, Object>) {
          final message1 = item1['message']! as Message;
          final message2 = item2['message']! as Message;

          return message1.id == message2.id;
        } else {
          return item1 == item2;
        }
      },
    );

    for (final update in diffResult.getUpdates(batch: false)) {
      update.when(
        insert: (pos, count) {
          _listKey.currentState?.insertItem(pos);
        },
        remove: (pos, count) {
          final item = oldList[pos];
          _listKey.currentState?.removeItem(
            pos,
            (_, animation) => _removedMessageBuilder(item, animation),
          );
        },
        change: (pos, payload) {},
        move: (from, to) {},
      );
    }

    _scrollToBottomIfNeeded(oldList);

    _oldData = List.from(widget.items);
  }

  Widget _newMessageBuilder(int index, Animation<double> animation) {
    try {
      final item = _oldData[index];

      return SizeTransition(
        axisAlignment: -1,
        sizeFactor: animation.drive(CurveTween(curve: Curves.easeOutQuad)),
        child: widget.itemBuilder(item, index),
      );
    } catch (e) {
      return const SizedBox();
    }
  }

  Widget _removedMessageBuilder(Object item, Animation<double> animation) {
    return SizeTransition(
      axisAlignment: -1,
      sizeFactor: animation.drive(CurveTween(curve: Curves.easeInQuad)),
      child: FadeTransition(
        opacity: animation.drive(CurveTween(curve: Curves.easeInQuad)),
        child: widget.itemBuilder(item, null),
      ),
    );
  }

  // Hacky solution to reconsider
  void _scrollToBottomIfNeeded(List<Object> oldList) {
    try {
      // Take index 1 because there is always a spacer on index 0
      final oldItem = oldList[1];
      final item = widget.items[1];

      if (oldItem is Map<String, Object> && item is Map<String, Object>) {
        final oldMessage = oldItem['message']! as Message;
        final message = item['message']! as Message;

        // Compare items to fire only on newly added messages
        if (oldMessage != message) {
          // Run only for sent message
          if (message.author.id == widget.controller.user.id) {
            // Delay to give some time for Flutter to calculate new
            // size after new message was added
            Future.delayed(const Duration(milliseconds: 100), () {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInQuad,
                );
              }
            });
          }
        }
      }
    } catch (e) {
      // Do nothing if there are no items
    }
  }

  @override
  Widget build(BuildContext context) {
    final _query = MediaQuery.of(context);

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (widget.onEndReached == null || widget.isLastPage == true) {
          return false;
        }

        if (notification.metrics.pixels >=
            (notification.metrics.maxScrollExtent *
                (widget.onEndReachedThreshold ?? 0.75))) {
          if (widget.items.isEmpty || _isNextPageLoading) return false;

          _controller.duration = const Duration();
          _controller.forward();

          setState(() {
            _isNextPageLoading = true;
          });

          widget.onEndReached!().whenComplete(() {
            _controller.duration = const Duration(milliseconds: 300);
            _controller.reverse();

            setState(() {
              _isNextPageLoading = false;
            });
          });
        }

        return false;
      },
      child: CustomScrollView(
        controller: _scrollController,
        physics: widget.scrollPhysics,
        reverse: true,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 4),
            sliver: SliverAnimatedList(
              initialItemCount: widget.items.length,
              key: _listKey,
              itemBuilder: (_, index, animation) =>
                  _newMessageBuilder(index, animation),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              top: 16 + (kIsWeb ? 0 : _query.padding.top),
            ),
            sliver: SliverToBoxAdapter(
              child: SizeTransition(
                axisAlignment: 1,
                sizeFactor: _animation,
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 32,
                    width: 32,
                    child: SizedBox(
                      height: 16,
                      width: 16,
                      child: _isNextPageLoading
                          ? CupertinoActivityIndicator()
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
