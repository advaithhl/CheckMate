import axios from "axios";
import { APP_API_URL } from "../constants";
import { LoginInfo, UserInfo } from "../models";


export async function loginUser(loginInfo: LoginInfo): Promise<UserInfo> {
  const response = await axios.post<UserInfo>(
    APP_API_URL + '/login',
    loginInfo
  )
  return response.data;
}
