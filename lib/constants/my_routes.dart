class MyRoutes {
  // Admin
  static const createUser ="/admin/create_user";
  static const updateUser = "/admin/update_user";

  static const createCategory = "/admin/create_category";
  static const updateCategory = "/admin/update_category";
  static const getCategories = "/user/get_categories";

  // Admin API Routes (need backend implementation)
  static const adminGetAllOrders = "/admin/get_all_orders";
  static const adminUpdateOrderStatus = "/admin/update_order_status";
  static const adminGetAllCategories = "/admin/get_all_categories";
  static const adminDeleteCategory = "/admin/delete_category";
  static const adminGetAllItems = "/admin/get_all_items";
  static const adminCreateItem = "/admin/create_item";
  static const adminUpdateItem = "/admin/update_item";
  static const adminDeleteItem = "/admin/delete_item";
  static const adminGetAllUsers = "/admin/get_all_users";
  static const adminDeleteUser = "/admin/delete_user";


  //User
  static const getUserById ="/user/get_user_by_id";
  static const getUserByEmail ="/user/get_user_by_email";

  static const getItemsByCategoryId ="/user/get_items_by_category_id";
  static const getCart ="/user/get_cart_by_id";
  static const addCartItem ="/user/add_cart_item";
  static const removeCartItem ="/user/remove_cart_item";
  static const deleteAllCartItems ="/user/delete_all_cart_items";
  static const getItemsByIds ="/user/get_items_by_ids";

  // Orders
  static const placeOrder = "/user/place_order";
  static const getOrders = "/user/get_orders";
  static const getOrderById = "/user/get_order_by_id";

  // Crowd
  static const getCrowdLevel = "/crowd/get";
  static const updateCrowdLevel = "/crowd/update";

  static const cloudUrl = "https://smart-canteen-ordering-system-backend.onrender.com";
  static const localUrl = "http://10.128.98.168:3000";

  static const isTesting =false;

}
