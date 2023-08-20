class CompanyInfo {
  double price = 0;
  double? buyPrice = 0;
  double get profit {
    if (buyPrice == null || buyPrice == 0) return 0;
    return this.price - this.buyPrice!;
  }

  CompanyInfo({this.price = 0, this.buyPrice = 0}) {}
}
