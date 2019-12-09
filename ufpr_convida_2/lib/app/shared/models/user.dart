class User {
  String name;
  String lastName;
  String grr;
  String email;
  //falta data de nascimento
  String password;

  User({this.name, this.lastName, this.grr, this.email, this.password});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    lastName = json['lastName'];
    grr = json['grr'];
    email = json['email'];
    //data nasc
    password = json['password'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['lastName'] = this.lastName;
    data['grr'] = this.grr;
    data['email'] = this.email;
    //data nasc
    data['password'] = this.password;
    return data;
  }
}