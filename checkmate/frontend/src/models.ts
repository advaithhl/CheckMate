export interface LoginInfo {
  username: string;
  password: string;
}

export interface RegisterInfo {
  name: string;
  username: string;
  password: string;
}

export interface UserInfo {
  id: number;
  name: string;
  token: string;
}

export interface ItemList {
  items: Item[];
}

export interface Item {
  id: string;
  text: string;
}

export interface NewItem {
  text: string;
}

export interface ToDeleteItem {
  id: string
}
