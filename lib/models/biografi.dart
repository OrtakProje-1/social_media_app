import 'dart:convert';

class Biografi {
  final String? hakkimda;
  final String? numara;
  final DateTime? dogumTarihi;
  final bool? cinsiyet;
  Biografi({
    this.hakkimda,
    this.numara,
    this.dogumTarihi,
    this.cinsiyet,
  });

  Biografi copyWith({
    String? hakkimda,
    String? numara,
    DateTime? dogumTarihi,
    bool? cinsiyet,
  }) {
    return Biografi(
      hakkimda: hakkimda ?? this.hakkimda,
      numara: numara ?? this.numara,
      dogumTarihi: dogumTarihi ?? this.dogumTarihi,
      cinsiyet: cinsiyet ?? this.cinsiyet,
    );
  }

  Map<String, dynamic> toMap() {
    return {
     if(hakkimda!=null) 'hakkimda': hakkimda,
     if(numara!=null) 'numara': numara,
     if(dogumTarihi!=null) 'dogumTarihi': dogumTarihi?.millisecondsSinceEpoch,
     if(cinsiyet!=null) 'cinsiyet': cinsiyet,
    };
  }

  factory Biografi.fromMap(Map<String, dynamic> map) {
    return Biografi(
      hakkimda: map['hakkimda'],
      numara: map['numara'],
      dogumTarihi:map['dogumTarihi']!=null ? DateTime.fromMillisecondsSinceEpoch(map['dogumTarihi']) : null,
      cinsiyet: map['cinsiyet'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Biografi.fromJson(String source) => Biografi.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Biografi(hakkimda: $hakkimda, numara: $numara, dogumTarihi: $dogumTarihi, cinsiyet: $cinsiyet)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Biografi &&
      other.hakkimda == hakkimda &&
      other.numara == numara &&
      other.dogumTarihi == dogumTarihi &&
      other.cinsiyet == cinsiyet;
  }

  @override
  int get hashCode {
    return hakkimda.hashCode ^
      numara.hashCode ^
      dogumTarihi.hashCode ^
      cinsiyet.hashCode;
  }
}
