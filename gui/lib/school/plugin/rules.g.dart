// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rules.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferenceLink _$ReferenceLinkFromJson(Map<String, dynamic> json) =>
    ReferenceLink(
      taxonomy: json['taxonomy'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$ReferenceLinkToJson(ReferenceLink instance) =>
    <String, dynamic>{
      'taxonomy': instance.taxonomy,
      'description': instance.description,
      'url': instance.url,
    };

SubjectSet _$SubjectSetFromJson(Map<String, dynamic> json) => SubjectSet(
      subject: (json['subject'] as List<dynamic>?)
          ?.map((e) => Subject.fromJson(e as Map<String, dynamic>))
          .toList(),
      reference: (json['reference'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k,
            (e as List<dynamic>)
                .map((e) => ReferenceLink.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
    );

Map<String, dynamic> _$SubjectSetToJson(SubjectSet instance) =>
    <String, dynamic>{
      'subject': instance.subject.map((e) => e.toJson()).toList(),
      'reference': instance.reference
          .map((k, e) => MapEntry(k, e.map((e) => e.toJson()).toList())),
    };

Student _$StudentFromJson(Map<String, dynamic> json) => Student(
      id: json['id'] as String? ?? "",
      firstName: json['firstName'] as String? ?? "",
      lastName: json['lastName'] as String? ?? "",
      birth: _fromJson(json['birth'] as String),
      testScore: json['testScore'] as String? ?? "",
      testType: json['testType'] as String? ?? "",
      grade: json['grade'] as int? ?? -1,
      district: json['district'] as String? ?? "",
      slotScore: (json['slotScore'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      subject: (json['subject'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, Subject.fromJson(e as Map<String, dynamic>)),
      ),
      hours: (json['hours'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'birth': _toJson(instance.birth),
      'testScore': instance.testScore,
      'testType': instance.testType,
      'district': instance.district,
      'grade': instance.grade,
      'hours': instance.hours,
      'slotScore': instance.slotScore,
      'subject': instance.subject.map((k, e) => MapEntry(k, e.toJson())),
    };

Teacher _$SupervisorFromJson(Map<String, dynamic> json) => Teacher(
      id: json['id'] as String? ?? "",
      address: json['address'] as String? ?? "",
      city: json['city'] as String? ?? "",
      state: json['state'] as String? ?? "",
      address2: json['address2'] as String? ?? "",
      zip: json['zip'] as String? ?? "",
      lastName: json['lastName'] as String? ?? "",
      firstName: json['firstName'] as String? ?? "",
      phone: json['phone'] as String? ?? "",
      phone2: json['phone2'] as String? ?? "",
      email: json['email'] as String? ?? "",
      country: json['country'] as String? ?? "",
    );

Map<String, dynamic> _$SupervisorToJson(Teacher instance) => <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'address2': instance.address2,
      'city': instance.city,
      'state': instance.state,
      'zip': instance.zip,
      'lastName': instance.lastName,
      'firstName': instance.firstName,
      'phone': instance.phone,
      'phone2': instance.phone2,
      'email': instance.email,
      'country': instance.country,
    };

JurisdictionSet _$JurisdictionSetFromJson(Map<String, dynamic> json) =>
    JurisdictionSet(
      (json['country'] as List<dynamic>).map((e) => e as String).toList(),
      (json['byCountry'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k,
            (e as List<dynamic>)
                .map((e) => Jurisdiction.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
    );

Map<String, dynamic> _$JurisdictionSetToJson(JurisdictionSet instance) =>
    <String, dynamic>{
      'country': instance.country,
      'byCountry': instance.byCountry
          ?.map((k, e) => MapEntry(k, e.map((e) => e.toJson()).toList())),
    };

Jurisdiction _$JurisdictionFromJson(Map<String, dynamic> json) => Jurisdiction(
      json['code'] as String,
      json['description'] as String,
    );

Map<String, dynamic> _$JurisdictionToJson(Jurisdiction instance) =>
    <String, dynamic>{
      'code': instance.code,
      'description': instance.description,
    };

DistrictSet _$DistrictSetFromJson(Map<String, dynamic> json) => DistrictSet(
      (json['district'] as List<dynamic>)
          .map((e) => District.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['admin'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            int.parse(k), Administrator.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$DistrictSetToJson(DistrictSet instance) =>
    <String, dynamic>{
      'district': instance.district.map((e) => e.toJson()).toList(),
      'admin': instance.admin.map((k, e) => MapEntry(k.toString(), e.toJson())),
    };

Administrator _$AdministratorFromJson(Map<String, dynamic> json) =>
    Administrator(
      name: json['name'] as String? ?? "",
      firstName: json['firstName'] as String? ?? "",
      lastName: json['lastName'] as String? ?? "",
      address1: json['address1'] as String? ?? "",
      address2: json['address2'] as String? ?? "",
      city: json['city'] as String? ?? "",
      state: json['state'] as String? ?? "",
      zip: json['zip'] as String? ?? "",
      email: json['email'] as String? ?? "",
      phone: json['phone'] as String? ?? "",
      phone2: json['phone2'] as String? ?? "",
      country: json['country'] as String? ?? "",
    )..number = json['number'] as int;

Map<String, dynamic> _$AdministratorToJson(Administrator instance) =>
    <String, dynamic>{
      'number': instance.number,
      'name': instance.name,
      'address1': instance.address1,
      'address2': instance.address2,
      'city': instance.city,
      'state': instance.state,
      'zip': instance.zip,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'phone2': instance.phone2,
      'country': instance.country,
    };

District _$DistrictFromJson(Map<String, dynamic> json) => District(
      id: json['id'] as String? ?? "",
      name: json['name'] as String? ?? "",
      adminNumber: json['adminNumber'] as int? ?? 0,
      admin: json['admin'] == null
          ? null
          : Administrator.fromJson(json['admin'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DistrictToJson(District instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'adminNumber': instance.adminNumber,
      'admin': instance.admin?.toJson(),
    };

DgMenu _$DgMenuFromJson(Map<String, dynamic> json) => DgMenu(
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => DgMenuItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DgMenuToJson(DgMenu instance) => <String, dynamic>{
      'children': instance.children.map((e) => e.toJson()).toList(),
    };

DgMenuItem _$DgMenuItemFromJson(Map<String, dynamic> json) => DgMenuItem(
      method: json['method'] as String? ?? "",
      title: json['title'] as String? ?? "",
      assets:
          (json['assets'] as List<dynamic>?)?.map((e) => e as String).toList(),
      params: json['params'] as Map<String, dynamic>?,
    )
      ..prereq = json['prereq'] as String
      ..due = json['due'] as String
      ..lastSentKey = json['lastSentKey'] as String
      ..alert = json['alert'] as String
      ..information = json['information'] as String
      ..svg = json['svg'] as String;

Map<String, dynamic> _$DgMenuItemToJson(DgMenuItem instance) =>
    <String, dynamic>{
      'assets': instance.assets,
      'title': instance.title,
      'method': instance.method,
      'params': instance.params,
      'prereq': instance.prereq,
      'due': instance.due,
      'lastSentKey': instance.lastSentKey,
      'alert': instance.alert,
      'information': instance.information,
      'svg': instance.svg,
    };

Filing _$FilingFromJson(Map<String, dynamic> json) => Filing(
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => FilingItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..family = json['family'] == null
        ? null
        : Teacher.fromJson(json['family'] as Map<String, dynamic>);

Map<String, dynamic> _$FilingToJson(Filing instance) => <String, dynamic>{
      'children': instance.children.map((e) => e.toJson()).toList(),
      'family': instance.family?.toJson(),
    };

FilingItem _$FilingItemFromJson(Map<String, dynamic> json) => FilingItem(
      to: (json['to'] as List<dynamic>).map((e) => e as String).toList(),
      attach: (json['attach'] as List<dynamic>)
          .map((e) => Attach.fromJson(e as Map<String, dynamic>))
          .toList(),
      signed: json['signed'] as bool? ?? false,
    );

Map<String, dynamic> _$FilingItemToJson(FilingItem instance) =>
    <String, dynamic>{
      'to': instance.to,
      'signed': instance.signed,
      'attach': instance.attach.map((e) => e.toJson()).toList(),
    };

Attach _$AttachFromJson(Map<String, dynamic> json) => Attach(
      path: json['path'] as String,
      content: json['content'],
    );

Map<String, dynamic> _$AttachToJson(Attach instance) => <String, dynamic>{
      'path': instance.path,
      'content': instance.content,
    };

GradeSlot _$GradeSlotFromJson(Map<String, dynamic> json) => GradeSlot(
      id: json['id'] as String? ?? "",
      description: json['description'] as String? ?? "",
      title: json['title'] as String? ?? "",
      require: json['require'] as bool? ?? true,
      subject: json['subject'] == null
          ? null
          : Subject.fromJson(json['subject'] as Map<String, dynamic>),
      hash: (json['hash'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$GradeSlotToJson(GradeSlot instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'subject': instance.subject.toJson(),
      'hash': instance.hash,
      'require': instance.require,
    };

GradeSet _$GradeSetFromJson(Map<String, dynamic> json) => GradeSet(
      slot: (json['slot'] as List<dynamic>?)
          ?.map((e) => GradeSlot.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GradeSetToJson(GradeSet instance) => <String, dynamic>{
      'slot': instance.slot.map((e) => e.toJson()).toList(),
    };

Subject _$SubjectFromJson(Map<String, dynamic> json) => Subject(
      id: json['id'] as String? ?? "",
      topic: (json['topic'] as List<dynamic>?)
          ?.map((e) => Topic.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..start = (json['start'] as List<dynamic>).map((e) => e as int).toList()
      ..steps = (json['steps'] as List<dynamic>)
          .map((e) => PlanStep.fromJson(e as Map<String, dynamic>))
          .toList()
      ..minGrade = json['minGrade'] as int
      ..maxGrade = json['maxGrade'] as int;

Map<String, dynamic> _$SubjectToJson(Subject instance) => <String, dynamic>{
      'id': instance.id,
      'topic': instance.topic.map((e) => e.toJson()).toList(),
      'start': instance.start,
      'steps': instance.steps.map((e) => e.toJson()).toList(),
      'minGrade': instance.minGrade,
      'maxGrade': instance.maxGrade,
    };

PlanStep _$PlanStepFromJson(Map<String, dynamic> json) => PlanStep(
      objectiveId: json['objectiveId'] as String? ?? "",
      description: json['description'] as String? ?? "",
    )..link = (json['link'] as List<dynamic>)
        .map((e) => Link.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$PlanStepToJson(PlanStep instance) => <String, dynamic>{
      'objectiveId': instance.objectiveId,
      'description': instance.description,
      'link': instance.link.map((e) => e.toJson()).toList(),
    };

Topic _$TopicFromJson(Map<String, dynamic> json) => Topic(
      id: json['id'] as String? ?? "",
      title: json['title'] as String,
      description: json['description'] as String? ?? "",
    )
      ..tag = (json['tag'] as List<dynamic>)
          .map((e) => SearchTag.fromJson(e as Map<String, dynamic>))
          .toList()
      ..link = (json['link'] as List<dynamic>).map((e) => e as String).toList();

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'tag': instance.tag.map((e) => e.toJson()).toList(),
      'link': instance.link,
    };

SearchTag _$SearchTagFromJson(Map<String, dynamic> json) => SearchTag(
      json['key'] as String,
      json['value'] as String,
    );

Map<String, dynamic> _$SearchTagToJson(SearchTag instance) => <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
    };

Link _$LinkFromJson(Map<String, dynamic> json) => Link(
      json['description'] as String,
      json['url'] as String,
    );

Map<String, dynamic> _$LinkToJson(Link instance) => <String, dynamic>{
      'description': instance.description,
      'url': instance.url,
    };
