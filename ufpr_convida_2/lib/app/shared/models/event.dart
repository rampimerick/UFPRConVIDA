import 'package:flutter/material.dart';
import 'package:ufpr_convida_2/app/shared/models/user.dart';

class Event {
  String id;
  String name;
  String target;
  String hrStart;
  String hrEnd;
  String dateStart;
  String dateEnd;
  String desc;
  String startSub;
  String endSub;
  String link;
  String type;
  String sector;
  String bloc;
  User author;
  double lat;
  double lng;

  Event(
      {this.id,
        this.name,
        this.target,
        this.hrStart,
        this.hrEnd,
        this.dateStart,
        this.dateEnd,
        this.desc,
        this.startSub,
        this.endSub,
        this.link,
        this.type,
        this.sector,
        this.bloc,
        this.author,
        this.lat,
        this.lng});

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    target = json['target'];
    hrStart = json['hrStart'];
    hrEnd = json ['hrEnd'];
    dateStart = json['dateStart'];
    dateEnd = json['dateEnd'];
    desc = json['desc'];
    startSub = json['startSub'];
    endSub = json['endSub'];
    link = json['link'];
    type = json['type'];
    sector = json['sector'];
    bloc = json['bloc'];
    author = json['author'] != null ? new User.fromJson(json['author']) : null;
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['target'] = this.target;
    data['hrStart'] = this.hrStart;
    data['hrEnd'] = this.hrEnd;
    data['dateStart'] = this.dateStart;
    data['dateEnd'] = this.dateEnd;
    data['desc'] = this.desc;
    data['startSub'] = this.startSub;
    data['endSub'] = this.endSub;
    data['link'] = this.link;
    data['type'] = this.type;
    data['sector'] = this.sector;
    data['bloc'] = this.bloc;
    if (this.author != null) {
      data['author'] = this.author.toJson();
    }
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }

  emptyEvent(){
  }

}



