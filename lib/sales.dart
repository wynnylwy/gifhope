class Sales {
  String genre;
  String totsales;

  Sales(
    this.genre,
    this.totsales,
  );

  factory Sales.fromJson(Map<String, dynamic> map) {
    return Sales(map['genre'].toString(), map['sales'].toString());
  }
}
