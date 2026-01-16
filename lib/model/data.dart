class Data {
  double _amount;
  // String _note;
  String _description;
  String _category;
  DateTime _date;
  bool _isIncome;

  get amount => this._amount;

  set amount(value) => this._amount = value;

  // get note => this._note;

  // set note(value) => this._note = value;
  get description => this._description;

  set description(value) => this._description = value;

  get category => this._category;

  set category(value) => this._category = value;

  get date => this._date;

  set date(value) => this._date = value;

  get isIncome => this._isIncome;

  set isIncome(value) => this._isIncome = value;

  // Data(this._amount, this._note, this._category, this._date, this._isIncome);
  Data(this._amount, this._description, this._category, this._date, this._isIncome);

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      json['amount'],
      // json['description'],
      json['description'],
      json['category'],
      json['date'],
      json['isIncome'],
    );
  }
}
