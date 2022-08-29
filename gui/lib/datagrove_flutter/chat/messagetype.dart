import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'util.dart';
import 'dart:ui';

part 'messagetype.g.dart';

/// All possible roles user can have.
enum Role { admin, agent, moderator, user }

/// A class that represents user.
@JsonSerializable()
@immutable
class User extends Equatable {
  /// Creates a user.
  const User({
    this.createdAt,
    this.firstName,
    this.id = "",
    this.imageUrl,
    this.lastName,
    this.lastSeen,
    this.metadata,
    this.role,
    this.updatedAt,
  });

  // /// Creates user from a map (decoded JSON).
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  // /// Converts user to the map representation, encodable to JSON.
  Map<String, dynamic> toJson() => _$UserToJson(this);

  /// Creates a copy of the user with an updated data.
  /// [firstName], [imageUrl], [lastName], [lastSeen], [role] and [updatedAt]
  /// with null values will nullify existing values.
  /// [metadata] with null value will nullify existing metadata, otherwise
  /// both metadatas will be merged into one Map, where keys from a passed
  /// metadata will overwite keys from the previous one.
  User copyWith({
    String? firstName,
    String? imageUrl,
    String? lastName,
    int? lastSeen,
    Map<String, dynamic>? metadata,
    Role? role,
    int? updatedAt,
  }) {
    return User(
      firstName: firstName,
      id: id,
      imageUrl: imageUrl,
      lastName: lastName,
      lastSeen: lastSeen,
      metadata: metadata == null
          ? null
          : {
              ...this.metadata ?? {},
              ...metadata,
            },
      role: role,
      updatedAt: updatedAt,
    );
  }

  /// Equatable props
  @override
  List<Object?> get props => [
        createdAt,
        firstName,
        id,
        imageUrl,
        lastName,
        lastSeen,
        metadata,
        role,
        updatedAt
      ];

  /// Created user timestamp, in ms
  final int? createdAt;

  /// First name of the user
  final String? firstName;

  /// Unique ID of the user
  final String id;

  /// Remote image URL representing user's avatar
  final String? imageUrl;

  /// Last name of the user
  final String? lastName;

  /// Timestamp when user was last visible, in ms
  final int? lastSeen;

  /// Additional custom metadata or attributes related to the user
  final Map<String, dynamic>? metadata;

  /// User [Role]
  final Role? role;

  /// Updated user timestamp, in ms
  final int? updatedAt;
}

/// All possible message types.
enum MessageType { custom, file, image, text, unsupported }

/// All possible statuses message can have.
enum Status { delivered, error, seen, sending, sent }

@JsonSerializable()
@immutable
class MessageFile {
  String uri;
  String mime;
  bool isLoading;
  int width;
  int height;
  String name;
  int length;

  MessageFile(
      {required this.uri,
      this.name = "",
      this.width = 0,
      this.height = 0,
      this.length = 0,
      this.isLoading = false,
      this.mime = ""});

  bool get isImage {
    switch (mime) {
      case 'image/jpeg':
      case 'image/jpg':
      case 'image/png':
        return true;
      default:
        return false;
    }
  }

  /// Creates a text message from a map (decoded JSON).
  factory MessageFile.fromJson(Map<String, dynamic> json) =>
      _$MessageFileFromJson(json);

  /// Converts a text message to the map representation, encodable to JSON.
  @override
  Map<String, dynamic> toJson() => _$MessageFileToJson(this);
}

/// An abstract class that contains all variables and methods
/// every message will have.
///
@JsonSerializable()
class Message extends Equatable {
  Message(
      {this.author = const User(),
      this.createdAt,
      this.id = "",
      this.metadata,
      this.remoteId,
      this.repliedMessage,
      this.roomId,
      this.showStatus,
      this.status,
      this.type = "",
      this.updatedAt,
      this.text = "",
      this.previewData,
      this.file = const []});

  final String text;
  final List<MessageFile> file;

  /// Creates a text message from a map (decoded JSON).
  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  /// Converts a text message to the map representation, encodable to JSON.
  @override
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  /// Creates a copy of the message with an updated data
  /// [isLoading] will be only set for the file message type.
  /// [metadata] with null value will nullify existing metadata, otherwise
  /// both metadatas will be merged into one Map, where keys from a passed
  /// metadata will overwrite keys from the previous one.
  /// [previewData] will be only set for the text message type.
  /// [remoteId], [showStatus] and [updatedAt] with null values will nullify existing value.
  /// [author], [createdAt] and [status] with null values will be overwritten by the previous values.
  /// [text] will be only set for the text message type. Null value will be
  /// overwritten by the previous text (can't be empty).
  /// [uri] will be only set for file and image message types. Null value
  /// will be overwritten by the previous value (uri can't be empty).
  Message copyWith({
    User? author,
    int? createdAt,
    bool? isLoading,
    Map<String, dynamic>? metadata,
    PreviewData? previewData,
    String? remoteId,
    bool? showStatus,
    Status? status,
    String? text,
    int? updatedAt,
    String? uri,
  }) {
    return this;
  }

  /// User who sent this message
  final User author;

  /// Created message timestamp, in ms
  final int? createdAt;

  /// Unique ID of the message
  final String id;

  /// Additional custom metadata or attributes related to the message
  final Map<String, dynamic>? metadata;

  /// Unique ID of the message received from the backend
  final String? remoteId;

  /// Message that is being replied to with the current message
  final Message? repliedMessage;

  /// ID of the room where this message is sent
  final String? roomId;

  /// Show status or not
  final bool? showStatus;

  /// Message [Status]
  final Status? status;

  /// [MessageType]
  final String type;

  /// Updated message timestamp, in ms
  final int? updatedAt;
  final PreviewData? previewData;

  /// Equatable props
  @override
  List<Object?> get props => [
        author,
        createdAt,
        id,
        metadata,
        previewData,
        remoteId,
        repliedMessage,
        roomId,
        status,
        text,
        updatedAt,
      ];
}

@JsonSerializable()
@immutable
class PreviewData extends Equatable {
  /// Creates preview data.
  const PreviewData({
    this.description,
    this.image,
    this.link,
    this.title,
  });

  /// Creates preview data from a map (decoded JSON).
  factory PreviewData.fromJson(Map<String, dynamic> json) =>
      _$PreviewDataFromJson(json);

  /// Converts preview data to the map representation, encodable to JSON.
  Map<String, dynamic> toJson() => _$PreviewDataToJson(this);

  /// Creates a copy of the preview data with an updated data.
  /// Null values will nullify existing values.
  PreviewData copyWith({
    String? description,
    PreviewDataImage? image,
    String? link,
    String? title,
  }) {
    return PreviewData(
      description: description,
      image: image,
      link: link,
      title: title,
    );
  }

  /// Equatable props
  @override
  List<Object?> get props => [description, image, link, title];

  /// Link description (usually og:description meta tag)
  final String? description;

  /// See [PreviewDataImage]
  final PreviewDataImage? image;

  /// Remote resource URL
  final String? link;

  /// Link title (usually og:title meta tag)
  final String? title;
}

// A utility class that forces image's width and height to be stored
/// alongside the url.
///
/// See https://github.com/flyerhq/flutter_link_previewer
@JsonSerializable()
@immutable
class PreviewDataImage extends Equatable {
  /// Creates preview data image.
  const PreviewDataImage({
    required this.height,
    required this.url,
    required this.width,
  });

  /// Creates preview data image from a map (decoded JSON).
  factory PreviewDataImage.fromJson(Map<String, dynamic> json) =>
      _$PreviewDataImageFromJson(json);

  /// Converts preview data image to the map representation, encodable to JSON.
  Map<String, dynamic> toJson() => _$PreviewDataImageToJson(this);

  /// Equatable props
  @override
  List<Object> get props => [height, url, width];

  /// Image height in pixels
  final double height;

  /// Remote image URL
  final String url;

  /// Image width in pixels
  final double width;
}

// we need kinds of blocks, a table block would be able to launch nested steppers
// the steppers could be reusable components.
// in storing these blocks, should they be in tables? 