// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  User read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      firstName: fields[0] as String,
      referralCode: fields[14] as String,
      token: fields[2] as String,
      email: fields[1] as String,
      phone: fields[3] as String,
      user_mid: fields[4] as String,
      lastName: fields[5] as String,
      balance: fields[6] as dynamic,
      bankAaccountNumber: fields[12] as String,
      bankAccount: fields[11] as String,
      bankAccountName: fields[13] as String,
      country: fields[7] as String,
      currency: fields[8] as String,
      flag: fields[10] as String,
      symbol: fields[9] as String,
      userTag: fields[15] as String,
      profilepic: fields[16] as String,
      continent: fields[17] as String,
      with_bank_transfer: fields[21] as bool,
      with_card: fields[18] as bool,
      with_local_card: fields[19] as bool,
      with_mobile_money: fields[20] as bool,
      is_compliant: fields[22] as bool,
      referral_code: fields[23] as String,
      country_id: fields[24] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.firstName)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.token)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.user_mid)
      ..writeByte(5)
      ..write(obj.lastName)
      ..writeByte(6)
      ..write(obj.balance)
      ..writeByte(7)
      ..write(obj.country)
      ..writeByte(8)
      ..write(obj.currency)
      ..writeByte(9)
      ..write(obj.symbol)
      ..writeByte(10)
      ..write(obj.flag)
      ..writeByte(11)
      ..write(obj.bankAccount)
      ..writeByte(12)
      ..write(obj.bankAaccountNumber)
      ..writeByte(13)
      ..write(obj.bankAccountName)
      ..writeByte(14)
      ..write(obj.referralCode)
      ..writeByte(15)
      ..write(obj.userTag)
      ..writeByte(16)
      ..write(obj.profilepic)
      ..writeByte(17)
      ..write(obj.continent)
      ..writeByte(18)
      ..write(obj.with_card)
      ..writeByte(19)
      ..write(obj.with_local_card)
      ..writeByte(20)
      ..write(obj.with_mobile_money)
      ..writeByte(21)
      ..write(obj.with_bank_transfer)
      ..writeByte(22)
      ..write(obj.is_compliant)
      ..writeByte(23)
      ..write(obj.referral_code)
      ..writeByte(24)
      ..write(obj.country_id);
  }

  @override
  // TODO: implement typeId
  int get typeId => 0;
}
