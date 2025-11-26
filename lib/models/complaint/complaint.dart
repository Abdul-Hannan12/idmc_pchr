// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

enum ComplaintStatus {
  pending(
    "pending",
    "Pending",
    bgColor: Color(0xFF72777B),
    textColor: Color(0xFFFFFFFF),
  ),
  inProgress(
    "inprogress",
    "In Progress",
    bgColor: Color(0xFF72777B),
    textColor: Color(0xFFFFFFFF),
  ),
  reviewed(
    "reviewed",
    "Reviewed",
    bgColor: Color(0xFF72777B),
    textColor: Color(0xFFFFFFFF),
  ),
  resolved(
    "resolved",
    "Resolved",
    bgColor: Color(0xFFEFEFEF),
    textColor: Color(0xFF14C62F),
  ),
  cancelled(
    "cancelled",
    "Cancelled",
    bgColor: Color(0xFFF5F5F5),
    textColor: Color(0xFFC61417),
  ),
  onHold(
    "on-hold",
    "On Hold",
    bgColor: Color(0xFFE9E8E8),
    textColor: Color(0xFFFB6542),
  );

  final String name;
  final String prettyName;
  final Color bgColor;
  final Color textColor;

  static ComplaintStatus fromName(String? name) {
    switch (name) {
      case 'pending':
        return ComplaintStatus.pending;
      case 'inprogress':
        return ComplaintStatus.inProgress;
      case 'reviewed':
        return ComplaintStatus.reviewed;
      case 'resolved':
        return ComplaintStatus.resolved;
      case 'cancelled':
        return ComplaintStatus.cancelled;
      case 'on-hold':
        return ComplaintStatus.onHold;
      default:
        return ComplaintStatus.inProgress;
    }
  }

  const ComplaintStatus(
    this.name,
    this.prettyName, {
    required this.bgColor,
    required this.textColor,
  });
}

enum ComplaintCategory {
  general("general", "General"),
  physicalThreat("physical", "Physical Threat"),
  digitalThreat("digital", "Digital Threat"),
  medicalAid("medical", "Medical Aid");

  final String prettyName;
  final String key;

  static ComplaintCategory fromName(String? name) {
    switch (name) {
      case 'general':
        return ComplaintCategory.general;
      case 'physical':
        return ComplaintCategory.physicalThreat;
      case 'digital':
        return ComplaintCategory.digitalThreat;
      case 'medical':
        return ComplaintCategory.medicalAid;
      default:
        return ComplaintCategory.general;
    }
  }

  const ComplaintCategory(this.key, this.prettyName);
}

class Complaint {
  final String? id;
  final String? institution;
  final String? title;
  final String? subject;
  final String? description;
  final String? link;
  final ComplaintStatus? status;
  final String? location;
  final ComplaintCategory? category;
  final String? address;
  final DateTime? datetime;
  final String? concernedDepartment;
  final LatLng? position;

  Complaint({
    this.id,
    this.institution,
    this.title,
    this.subject,
    this.description,
    this.link,
    this.status,
    this.location,
    this.category,
    this.address,
    this.datetime,
    this.concernedDepartment,
    this.position,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'status': status?.name,
      'location': location,
      'type': category?.name,
      'datetime': datetime?.millisecondsSinceEpoch,
      'concernedDepartment': concernedDepartment,
      'position': position?.toJson(),
    };
  }

  factory Complaint.fromMap(Map<String, dynamic> map) {
    return Complaint(
      id: "${map['id']}",
      institution: map['institution'],
      address: map['address'],
      title: map['title'],
      link: map['link'],
      description: map['description'],
      subject: map['subject'],
      status: ComplaintStatus.fromName(map['status']),
      location: map['province'] != null && map['cities'] != null
          ? map['province']['name'] != null && map['cities']['name'] != null
              ? "${map['cities']['name']}, ${map['province']['name']}"
              : null
          : null,
      category: ComplaintCategory.fromName(map['category']),
      datetime: DateTime.tryParse(map['created_at']),
      concernedDepartment:
          map['department'] != null ? map['department']['name'] : null,
      position: map['latitude'] != null && map['longitude'] != null
          ? LatLng(double.tryParse(map['latitude']) ?? 0.0,
              double.tryParse(map['longitude']) ?? 0.0)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Complaint.fromJson(String source) =>
      Complaint.fromMap(json.decode(source) as Map<String, dynamic>);
}
