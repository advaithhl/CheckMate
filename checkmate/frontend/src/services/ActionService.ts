import axios from "axios";
import { ItemList, NewItem, ToDeleteItem } from "../models";
import { APP_API_URL } from "../constants";
import { getUserInfoFromLocalStorage } from "../utils/userInfo";

export async function getItems(): Promise<ItemList> {
  const userInfo = getUserInfoFromLocalStorage();
  const token = userInfo ? userInfo.token : "";
  const response = await axios.get(APP_API_URL + "/actions/getItems", {
    headers: { Authorization: `Bearer ${token}` },
  });
  return response.data;
}

export async function addItem(item: NewItem) {
  const userInfo = getUserInfoFromLocalStorage();
  const token = userInfo ? userInfo.token : "";
  const response = await axios.post(APP_API_URL + "/actions/addItem", item, {
    headers: { Authorization: `Bearer ${token}` },
  });
  return response.data;
}

export async function deleteItem(item: ToDeleteItem) {
  const userInfo = getUserInfoFromLocalStorage();
  const token = userInfo ? userInfo.token : "";
  const response = await axios.delete(
    APP_API_URL + `/actions/deleteItem/${item.id}`,
    {
      headers: { Authorization: `Bearer ${token}` },
    }
  );
  return response.data;
}
