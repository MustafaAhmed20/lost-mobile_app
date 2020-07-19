class Users {
  String publicId;

  String name;

  String phone;

  Permission permission;

  Status status;

  Users({
    this.publicId,
    this.name,
    this.phone,
    this.permission,
    this.status,
  });
}

class Status {
  int id;
  String name;

  Status({this.id, this.name});
}

class Permission {
  int id;
  String name;
  Permission({this.id, this.name});
}
