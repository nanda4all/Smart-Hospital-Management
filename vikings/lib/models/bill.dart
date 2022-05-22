class Bill {
  int? billId;
  late String billDate;
  double? billExamination;
  double? billSurgeries;
  double? billRays;
  double? billMedicalTest;
  double? billMedicalRoomService;
  double? billMedicalMedication;
  double? billTotal;
  late bool paid;

  Bill(
      {this.billId,
      required this.billDate,
      this.billExamination,
      this.billMedicalMedication,
      this.billMedicalRoomService,
      this.billMedicalTest,
      this.billRays,
      this.billSurgeries,
      this.billTotal,
      required this.paid});

  Bill.fromJson(Map bill) {
    billId = bill['Bill_Id'];
    billDate = bill['Bill_Date'];
    billExamination = bill['Bill_Examination'];
    billMedicalMedication = bill['Bill_Medication'];
    billMedicalRoomService = bill['Bill_Room_Service'];
    billMedicalTest = bill['Bill_Medical_Test'];
    billRays = bill['Bill_Rays'];
    billSurgeries = bill['Bill_Surgeries'];
    billTotal = bill['Bill_Id'] +
        bill['Bill_Date'] +
        bill['Bill_Examination'] +
        bill['Bill_Medication'] +
        bill['Bill_Room_Service'] +
        bill['Bill_Medical_Test'] +
        bill['Bill_Rays'] +
        bill['Bill_Surgeries'];
    paid=bill['Paid'];
  }
}
