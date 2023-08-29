import 'package:flutter/material.dart';
import 'package:web_dashboard/db/db_config.dart';

class BoundDataClass{
  final int? lowerBound;  // lower bound
  final int? upperBound;  // upper bound
  final int? warningUpperBound; // warning upper bound
  final int? warningLowerBound; // warning lower bound
  // constructor
  BoundDataClass({
    this.lowerBound,
    this.upperBound,
    this.warningUpperBound,
    this.warningLowerBound,
  });

  @override
  String toString() {
    return "| lb: $lowerBound | ub: $upperBound | wub: $warningUpperBound | wlb: $warningLowerBound |";
  }

  static fromJson(Map<String, dynamic> json){
    try{
      return BoundDataClass(
        lowerBound: json[DBConfig.lowerBoundId],
        upperBound: json[DBConfig.upperBoundId],
        warningUpperBound: json[DBConfig.warningUpperBoundId],
        warningLowerBound: json[DBConfig.warningLowerBoundId],
      );
    } catch (e){
      debugPrint(DBConfig.jsonSerializerMessage("BoundDataClass", e.toString()));
      rethrow ;
    }
  }

  toJson() => {
    DBConfig.lowerBoundId: lowerBound,
    DBConfig.upperBoundId: upperBound,
    DBConfig.warningUpperBoundId: warningUpperBound,
    DBConfig.warningLowerBoundId: warningLowerBound,
  };
}