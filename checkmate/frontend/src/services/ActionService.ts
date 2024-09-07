import axios from "axios";
import { ItemList } from "../models";
import { APP_API_URL } from "../constants";

export async function getItems(): Promise<ItemList> {
  const response = await axios.get(APP_API_URL + "/actions/getItems");
  return response.data;
}
