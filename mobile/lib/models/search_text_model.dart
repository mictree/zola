class SearchTextModel {
  String id;
  String text;

  SearchTextModel({required this.id, required this.text});

  factory SearchTextModel.fromJson(Map<String, dynamic> json) {
    try {
      return SearchTextModel(id: json["_id"], text: json["searchText"]);
    } catch (e) {
      print(e);
      throw Exception('Failed to tranform data');
    }
  }
}
