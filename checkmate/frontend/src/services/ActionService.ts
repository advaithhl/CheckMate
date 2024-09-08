import axios from "axios";
import { ItemList, NewItem, ToDeleteItem } from "../models";
import { APP_API_URL } from "../constants";

export async function getItems(): Promise<ItemList> {
  const response = await axios.get(APP_API_URL + "/actions/getItems");
  return response.data;
}

export async function addItem(item: NewItem) {
  const response = await axios.post(APP_API_URL + "/actions/addItem", item);
  return response.data;
}

export async function deleteItem(item: ToDeleteItem) {
  const response = await axios.delete(
    APP_API_URL + `/actions/deleteItem/${item.id}`
  );
  return response.data;
}
