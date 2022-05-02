class DatabaseStruct {
  final String table;
  final Map<String, dynamic> struct;

  const DatabaseStruct(this.table, this.struct);

  String _toDBfield(String name, dynamic type) {
    String typeName = "";

    switch (type.runtimeType) {
      case int:
        typeName = "integer";
        break;
      case String:
        typeName = "text";
        break;
    }

    return "$name ${typeName.toUpperCase()} ${name == 'id' ? 'NOT NULL' : ''}";
  }

  @override
  String toString() {
    List<String> columns = [];
    struct.forEach((key, value) {
      columns.add(_toDBfield(key, value));
    });
    return columns.join(",");
  }
}
