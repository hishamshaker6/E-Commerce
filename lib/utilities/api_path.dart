class ApiPath {
  static String products() => 'products/';
  static String product(String id) => 'products/$id';
  static String newClothesPath(String id) => 'newClothes/$id';
  static String clothesPath(String id) => 'clothes/$id';
  static String shoesPath(String id) => 'shoes/$id';
  static String accessoriesPath(String id) => 'accessories/$id';


  static String newClothes() => 'newClothes/';
  static String clothes() => 'clothes/';
  static String shoes() => 'shoes/';
  static String accessories() => 'accessories/';
  static String userProfilePath(String uid) => 'users/$uid/profile';
  static String newProfilePath(String uid) => 'users/$uid/profile';
  static String addToFavorites(String uid ,String favoritesId )=>'users/$uid/favorites/$favoritesId';
  static String removeFromFavorites(String uid ,String productId)=>'users/$uid/favorites/$productId';
  static String myFavoriteProducts(String uid)=>'users/$uid/favorites/';
  static String deliveryMethods() => 'deliveryMethods/';
  static String user(String uid) => 'users/$uid';
  static String userShippingAddress(String uid) => 'users/$uid/shippingAddresses/';
  static String newAddress(String uid, String addressId) => 'users/$uid/shippingAddresses/$addressId';
  static String addToCart(String uid, String addToCartId) => 'users/$uid/cart/$addToCartId';
  static String myProductsCart(String uid) => 'users/$uid/cart/';

  static String addCard(String uid, String cardId) => 'users/$uid/cards/$cardId';
  static String cards(String uid) => 'users/$uid/cards/';
}