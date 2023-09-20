enum RateSectionType{
  twoStep('兩階段', 'two_section'), threeStep('三階段', 'three_section'), non('non', 'non');
  final String label;
  final String value;
  const RateSectionType(this.label, this.value);
  factory RateSectionType.fromValue(String value){
    switch(value){
      case 'two_section':
        return RateSectionType.twoStep;
      case 'three_section':
        return RateSectionType.threeStep;
      default:
        return RateSectionType.non;
    }
  }
}

enum RateType{
  fixed('fix 固定時段', 'fix'), dynamic('Dynamic 動態時段', 'dynamic'), non('non', 'non');
  final String label;
  final String value;
  const RateType(this.label, this.value);
  factory RateType.fromValue(String value){
    switch(value){
      case 'fix':
        return RateType.fixed;
      case 'dynamic':
        return RateType.dynamic;
      default:
        return RateType.non;
    }
  }
}

enum RateVoltageType{
  hv('高壓電 HV', 'hv'), uhv('超高壓電 UHV', 'uhv'), non('non', 'non');
  final String label;
  final String value;
  const RateVoltageType(this.label, this.value);
  factory RateVoltageType.fromValue(String value){
    switch(value){
      case 'hv':
        return RateVoltageType.hv;
      case 'uhv':
        return RateVoltageType.uhv;
      default:
        return RateVoltageType.non;
    }
  }
}

