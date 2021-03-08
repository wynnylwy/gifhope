class Sales {
  String genre;
  String totsales;
  String donate;

  Sales(
    this.genre,
    this.totsales,
    this.donate,
  );

  factory Sales.fromJson(Map<String, dynamic> map) {
    return Sales(map['genre'].toString(), map['sales'].toString(), map['donate'].toString(),);
  }
  
}
