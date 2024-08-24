import { UserInfo } from "../models";

export function getUserInfoFromLocalStorage(): UserInfo | null {
  const user = localStorage.getItem("checkMateUser");
  if (user) {
    return JSON.parse(user);
  }
  return null;
}

export function setUserInfoToLocalStorage(user: UserInfo | null) {
  if (user) {
    localStorage.setItem("checkMateUser", JSON.stringify(user));
  }
}

export function clearUserInfoFromLocalStorage() {
  localStorage.removeItem("checkMateUser");
}
