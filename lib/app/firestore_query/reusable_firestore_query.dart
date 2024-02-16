import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_cashier/app/mahas/mahas_config.dart';
import 'package:store_cashier/app/model/kategori_produk_model.dart';
import 'package:store_cashier/app/model/produk_model.dart';
import 'package:store_cashier/app/model/supplier_model.dart';
import 'package:store_cashier/app/model/unit_produk_model.dart';

class FireStoreQuery {
  //single document
  static CollectionReference tableUser =
      MahasConfig.firestore.collection("user");
  static CollectionReference tableCompany =
      MahasConfig.firestore.collection("company");

  //nested document
  static DocumentReference companyByIdUser =
      tableCompany.doc(MahasConfig.profileModel.companyId);
  static CollectionReference unitProdukList = tableCompany
      .doc(MahasConfig.profileModel.companyId)
      .collection("unit_produk");
  static CollectionReference kategoriProdukList = tableCompany
      .doc(MahasConfig.profileModel.companyId)
      .collection("kategori_produk");
  static CollectionReference supplierList = tableCompany
      .doc(MahasConfig.profileModel.companyId)
      .collection("supplier");
  static CollectionReference produkList =
      tableCompany.doc(MahasConfig.profileModel.companyId).collection("produk");

  //default queries
  static Query<UnitprodukModel> unitProdukListDefaultQuery = unitProdukList
      .where("unit", isNull: false)
      .withConverter<UnitprodukModel>(
        fromFirestore: (snapshot, _) => UnitprodukModel.fromDynamic(snapshot),
        toFirestore: (unitProduk, _) => UnitprodukModel.toJSon(unitProduk),
      );
  static Query<KategoriprodukModel> kategoriProdukListDefaultQuery =
      kategoriProdukList
          .where("kategori", isNull: false)
          .withConverter<KategoriprodukModel>(
            fromFirestore: (snapshot, _) =>
                KategoriprodukModel.fromDynamic(snapshot),
            toFirestore: (data, _) => KategoriprodukModel.toJSon(data),
          );
  static Query<SupplierModel> supplierListDefaultQuery = supplierList
      .where("namaSupplier", isNull: false)
      .withConverter<SupplierModel>(
        fromFirestore: (snapshot, _) => SupplierModel.fromDynamic(snapshot),
        toFirestore: (data, _) => SupplierModel.toJSon(data),
      );
  static Query<ProdukModel> produkListDefaultQuery =
      produkList.where("namaProduk", isNull: false).withConverter<ProdukModel>(
            fromFirestore: (snapshot, _) => ProdukModel.fromDynamic(snapshot),
            toFirestore: (data, _) => ProdukModel.toJSon(data),
          );
}
