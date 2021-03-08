class CDonate {
  String genre;
  String donate;

  CDonate(
    this.genre,
    this.donate,
  );

  factory CDonate.fromJson(Map<String, dynamic> map) {
    return CDonate(map['genre'].toString(), map['donate'].toString(),);
  }
  
}
