import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_cashier/app/mahas/mahas_config.dart';
import 'package:store_cashier/app/model/unit_produk_model.dart';

class FireStoreQuery {
  //single document
  static CollectionReference tableUser =
      MahasConfig.firestore.collection("user");
  static CollectionReference tableCompany =
      MahasConfig.firestore.collection("company");
  static CollectionReference tableUnitProduk =
      MahasConfig.firestore.collection("unit_produk");

  //nested document
  static DocumentReference companyByIdUser =
      tableCompany.doc(MahasConfig.profileModel.companyId);
  static CollectionReference unitProdukList = tableCompany
      .doc(MahasConfig.profileModel.companyId)
      .collection("unit_produk");

  //default queries
  static Query<UnitprodukModel> unitProdukListDefaultQuery = unitProdukList
      .where("unit", isNull: false)
      .withConverter<UnitprodukModel>(
        fromFirestore: (snapshot, _) => UnitprodukModel.fromDynamic(snapshot),
        toFirestore: (unitProduk, _) => UnitprodukModel.toJSon(unitProduk),
      );
}
