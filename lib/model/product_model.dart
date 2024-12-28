class CustomerDetails {
  String? billNumber;
  String? name;
  String? age;
  String? phoneNumber;
  String? location;
  String? createdAt;
  String? productType;
  String? grandTotal;

  // Optical fields
  String? rightSph;
  String? rightCyl;
  String? rightAxis;
  String? leftSph;
  String? leftCyl;
  String? leftAxis;
  String? leftPower;
  String? rightPower;
  String? leftVisual;
  String? rightVisual;
  String? otherMedical;

  // Constructor
  CustomerDetails({
    this.billNumber,
    this.name,
    this.age,
    this.phoneNumber,
    this.location,
    this.createdAt,
    this.productType,
    this.grandTotal,
    this.rightSph,
    this.rightCyl,
    this.rightAxis,
    this.leftSph,
    this.leftCyl,
    this.leftAxis,
    this.leftPower,
    this.rightPower,
    this.leftVisual,
    this.rightVisual,
    this.otherMedical,
  });

  // Factory method to create an instance from JSON
  factory CustomerDetails.fromJson(Map<String, dynamic> json) {
    return CustomerDetails(
      billNumber: json['billNumber'],
      name: json['name'],
      age: json['age'],
      phoneNumber: json['phoneNumber'],
      location: json['location'],
      createdAt: json['created_at'],
      productType: json['productType'],
      grandTotal: json['grandTotal'],
      rightSph: json['rightSph'],
      rightCyl: json['rightCyl'],
      rightAxis: json['rightAxis'],
      leftSph: json['leftSph'],
      leftCyl: json['leftCyl'],
      leftAxis: json['leftAxis'],
      leftPower: json['leftPower'],
      rightPower: json['rightPower'],
      leftVisual: json['leftVisual'],
      rightVisual: json['rightVisual'],
      otherMedical: json['otherMedical'],
    );
  }

  // Convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'billNumber': billNumber,
      'name': name,
      'age': age,
      'phoneNumber': phoneNumber,
      'location': location,
      'created_at': createdAt,
      'productType': productType,
      'grandTotal': grandTotal,
      'rightSph': rightSph,
      'rightCyl': rightCyl,
      'rightAxis': rightAxis,
      'leftSph': leftSph,
      'leftCyl': leftCyl,
      'leftAxis': leftAxis,
      'leftPower': leftPower,
      'rightPower': rightPower,
      'leftVisual': leftVisual,
      'rightVisual': rightVisual,
      'otherMedical': otherMedical,
    };
  }
}

class ProductData {
  String? productName;
  String? qty;
  String? amount;
  String? discount;
  String? totalAmount;
  String? framePrice;
  String? lensName;
  String? lensPrice;
  String? coating;
  String? coatingPrice;

  ProductData({
    this.productName,
    this.qty,
    this.amount,
    this.discount,
    this.totalAmount,
    this.framePrice,
    this.lensName,
    this.lensPrice,
    this.coating,
    this.coatingPrice,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      productName: json['productName'],
      qty: json['qty'],
      amount: json['amount'],
      discount: json['discount'],
      totalAmount: json['totalAmount'],
      framePrice: json['framePrice'],
      lensName: json['lensName'],
      lensPrice: json['lensPrice'],
      coating: json['coating'],
      coatingPrice: json['coatingPrice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'qty': qty,
      'amount': amount,
      'discount': discount,
      'totalAmount': totalAmount,
      'framePrice': framePrice,
      'lensName': lensName,
      'lensPrice': lensPrice,
      'coating': coating,
      'coatingPrice': coatingPrice,
    };
  }
}

class ProductResponse {
  CustomerDetails? customerDetails;
  List<ProductData>? productData;

  ProductResponse({
    this.customerDetails,
    this.productData,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      customerDetails: json['customerDetails'] != null
          ? CustomerDetails.fromJson(json['customerDetails'])
          : null,
      productData: json['productData'] != null
          ? (json['productData'] as List)
              .map((item) => ProductData.fromJson(item))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerDetails': customerDetails?.toJson(),
      'productData': productData?.map((item) => item.toJson()).toList(),
    };
  }
}
