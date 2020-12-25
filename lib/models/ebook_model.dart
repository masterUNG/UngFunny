import 'dart:convert';

class EbookModel {
  final String cover;
  final String pdf;
  final String name;
  EbookModel({
    this.cover,
    this.pdf,
    this.name,
  });

  EbookModel copyWith({
    String cover,
    String pdf,
    String name,
  }) {
    return EbookModel(
      cover: cover ?? this.cover,
      pdf: pdf ?? this.pdf,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cover': cover,
      'pdf': pdf,
      'name': name,
    };
  }

  factory EbookModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return EbookModel(
      cover: map['cover'],
      pdf: map['pdf'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EbookModel.fromJson(String source) => EbookModel.fromMap(json.decode(source));

  @override
  String toString() => 'EbookModel(cover: $cover, pdf: $pdf, name: $name)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is EbookModel &&
      o.cover == cover &&
      o.pdf == pdf &&
      o.name == name;
  }

  @override
  int get hashCode => cover.hashCode ^ pdf.hashCode ^ name.hashCode;
}
