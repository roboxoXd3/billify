class BusinessDetails {
  String? businessName;
  String? userName;
  String? phoneNumber;
  String? selectedTemplate;
  String? selectedTemplateType;

  BusinessDetails({
     this.businessName,
     this.userName,
     this.phoneNumber,
     this.selectedTemplate,
     this.selectedTemplateType,
  });

  factory BusinessDetails.fromJson(Map<String, dynamic> json) {
    return BusinessDetails(
      businessName: json['businessName'],
      userName: json['userName'],
      phoneNumber: json['phoneNumber'],
      selectedTemplate: json['selectedTemplate'],
      selectedTemplateType: json['selectedTemplateType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businessName': businessName,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'selectedTemplate': selectedTemplate,
      'selectedTemplateType': selectedTemplateType,
    };
  }
}
