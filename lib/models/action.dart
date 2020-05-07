import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smores_app/models/player.dart';
import 'package:smores_app/models/properties.dart';

import 'actionkey.dart';

class Actionn {
  ActionKey actionKey;
  ActionKey element;
  Player player;
  String type;
  var created;
  Properties properties;

  Actionn(
      {this.actionKey,
      this.element,
      this.player,
      this.type,
      this.created,
      this.properties});

  Actionn.fromJson(Map<String, dynamic> json) {
    actionKey = json['actionKey'] != null
        ? new ActionKey.fromJson(json['actionKey'])
        : null;
    element = json['element'] != null
        ? new ActionKey.fromJson(json['element'])
        : null;
    player =
        json['player'] != null ? new Player.fromJson(json['player']) : null;
    type = json['type'];
    created = json['created'];
    created = created.toString().split(".")[0];
    created = created.replaceAll('T', ' ');
    properties = json['properties'] != null
        ? new Properties.fromJson(json['properties'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.actionKey != null) {
      data['actionKey'] = this.actionKey.toJson();
    }
    if (this.element != null) {
      data['element'] = this.element.toJson();
    }
    if (this.player != null) {
      data['player'] = this.player.toJson();
    }
    data['type'] = this.type;
    data['created'] = this.created;
    if (this.properties != null) {
      data['properties'] = this.properties.toJson();
    }
    return data;
  }

  Actionn.empty();
}

// class Actionn{
//   String actionID;
//   String elementID;
//   String email;
//   String type;
//   String date;
//   String smartspace;
//   Map<String, Object> moreAttributes;

//  Actionn({
//   @required this.actionID,
//   @required this.elementID,
//   @required this.email,
//   @required this.type,
//   @required this.date,
//   @required this.smartspace,
//   @required this.moreAttributes,
//   });

// Actionn.empty();

// }
