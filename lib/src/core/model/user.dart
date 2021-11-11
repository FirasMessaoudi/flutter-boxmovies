
class MyUser {
  final String uid;
   String name;
  final String email;
   String photo;
   String cover;
   String character;
   String birthdate;
   String country;
   String description;
  MyUser({
     required this.uid,
     required this.name,
     required this.email,
      this.photo='',
      this.cover='',
      this.character='',
      this.birthdate='',
      this.country='',
      this.description=''
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photo':photo,
      'cover':cover,
      'character': character,
      'birthdate':birthdate,
      'country':country,
      'description':description

    };
  }

  factory MyUser.fromMap(Map<String, dynamic> map) {
    return MyUser(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      photo: map['photo'],
      cover: map['cover'],
      character: map['character'],
      birthdate: map['birthdate'],
      country: map['country'],
      description: map['description'] ?? ''
    );
  }
}