import { FC } from "react";
import { Navigate, useLocation } from "react-router-dom";
import { getUserInfoFromLocalStorage } from "../utils/userInfo";

export const ProtectedRoute: FC<{
  children: React.JSX.Element;
}> = ({ children }) => {
  const userInfo = getUserInfoFromLocalStorage();
  const location = useLocation();

  if (userInfo) {
    return children;
  } else {
    return <Navigate to="/login" state={{ from: location }} replace />;
  }
};
