class MyRoutes {
  // Admin
  static const createUser ="/admin/create_user";
  static const updateUser = "/admin/update_user";

  static const createCategory = "/admin/create_category";
  static const updateCategory = "/admin/update_category";
  static const getCategories = "/user/get_categories";


  //User
  static const getUserById ="/user/get_user_by_id";
  static const getUserByEmail ="/user/get_user_by_email";

  static const getItemsByCategoryId ="/user/get_items_by_category_id";
  static const getCart ="/user/get_cart_by_id";
  static const addCartItem ="/user/add_cart_item";
  static const removeCartItem ="/user/remove_cart_item";
  static const deleteAllCartItems ="/user/delete_all_cart_items";
  static const getItemsByIds ="/user/get_items_by_ids";

}