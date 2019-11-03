import 'package:flutter/material.dart';

class Event {
  String id;
  String name;
  String target;
  String date_event;
  String desc;
  String init;
  String end;
  String link;
  String type;
  String sector;
  String bloc;
  double lat;
  double lng;

  Event(this.id,
    this.name,
    this.target,
    this.date_event,
    this.desc,
    this.init,
    this.end,
    this.link,
    this.type,
    this.sector,
    this.bloc,
    this.lat,
    this.lng);

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    target = json['target'];
    date_event = json['date_event'];
    desc = json['desc'];
    init = json['init'];
    end = json['end'];
    link = json['link'];
    type = json['type'];
    sector = json['sector'];
    bloc = json['bloc'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['target'] = this.target;
    data['date_event'] = this.date_event;
    data['desc'] = this.desc;
    data['init'] = this.init;
    data['end'] = this.end;
    data['link'] = this.link;
    data['type'] = this.type;
    data['sector'] = this.sector;
    data['bloc'] = this.bloc;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}
