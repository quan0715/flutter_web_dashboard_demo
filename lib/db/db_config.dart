import 'package:intl/intl.dart';

class DBConfig{
  // The configuration file for the database
  // This file contains the base URI, the API key, the maximum number of records to return in a search, and the index names
  // The index names are the names of the repositories in the database
  // The index names are used in the search function in the elastic_search.dart file
  // if the index names are changed in the database, they must be changed here as well

  static String baseURI = "https://es.lab.nick983.app";
  static String apiKey = "ApiKey YWdxZGpZa0JJUV90ZlhMR3AwMlc6Z1RGdW1DR1dTLTZGMWN1dDZkWEJsdw==";
  static int searchMaxSize = 10000;
  static String meterRepoIndex = "metermsd";
  static String errorReportRepoIndex = "event_202307";
  static String deviceConsumptionRepoIndex = "consumption_202308"; // FIX: correct spelling
  static String deviceConsumptionSumRepoIndex = "sumconsumption_202308";

  static String lineTypeId= "linetype";
  static String assetTypeId= "assettype";
  static String buildingId= "building";
  static String departmentId= "department";
  static String tagIdId= "tagid";
  static String locId= "loc";
  static String descriptionId= "desc";
  static String changeById= "changeby";
  static String changeDateId= "changetime";
  static String lowerBoundId= "lb";
  static String upperBoundId= "ub";
  static String warningUpperBoundId= "wub";
  static String warningLowerBoundId= "wlb";
  static String dateTimeId= "datetime";
  static String dayConsumptionId = "d_con";
  static String monthConsumptionId = "m_con";
  static String yearConsumptionId = "y_con";
  static String quarterConsumption = "q_con";
  static String averageMonthConsumptionPerMonth = "avg_m_h_con";
  static String errorTypeId = "e_type";
  static String voltageId = "voltage";
  static String powerId = "kw"; // kw
  static String powerConsumptionId = "kwh";
  static String sumOfEnergyConsumedId = "sum_kwh";
  static String ampereId = "ampere";

  static DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ssZ");
  static String jsonSerializerMessage(String modelName, String errorMessage) => "Error Log($modelName): json serializer error -> $errorMessage";
}