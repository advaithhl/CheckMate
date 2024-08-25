import axios from "axios";
import { APP_API_URL } from "../constants";
import { LoginInfo, RegisterInfo, UserInfo } from "../models";

export async function loginUser(loginInfo: LoginInfo): Promise<UserInfo> {
  const response = await axios.post<UserInfo>(
    APP_API_URL + "/login",
    loginInfo
  );
  return response.data;
}

export async function registerUser(registerInfo: RegisterInfo) {
  const response = await axios.post(APP_API_URL + "/register", registerInfo);
  return response.data;
}
