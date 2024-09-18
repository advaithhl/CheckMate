import React, { useState } from "react";
import {
  Button,
  Card,
  Flex,
  Heading,
  Link,
  Section,
  Text,
  TextField,
} from "@radix-ui/themes";
import { useMutation } from "@tanstack/react-query";
import { loginUser } from "../../services/AuthService";
import { setUserInfoToLocalStorage } from "../../utils/userInfo";
import { UserInfo } from "../../models";
import { useNavigate } from "react-router-dom";
import { AxiosError } from "axios";

const getNotificationColor = (notification: string) => {
  if (notification.includes("wait")) return "orange";
  else return "red";
};

export function Login() {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [errors, setErrors] = useState<{
    username?: string;
    password?: string;
  }>({});
  const navigate = useNavigate();
  const [notification, setNotification] = useState("");
  const [loginButtonDisabled, setLoginButtonDisabled] = useState(false);

  const loginMutation = useMutation({
    mutationFn: loginUser,
    onMutate: () => {
      setLoginButtonDisabled(true);
      setNotification("Validating your credentials. Please wait...");
    },
    onSuccess: (data: UserInfo) => {
      setUserInfoToLocalStorage(data);
      navigate("/");
    },
    onError: (error: AxiosError) => {
      setLoginButtonDisabled(false);
      if (error.status === 401) {
        setErrors({
          username: "Please recheck your username",
          password: "Please recheck your password",
        });
        setNotification("Bad username or password. Please try again.");
        setTimeout(() => {
          setNotification("");
        }, 3000);
      } else {
        setNotification("An error occurred! Please try again.");
        console.log(error);
        setTimeout(() => {
          setNotification("");
        }, 3000);
      }
    },
  });

  const validateForm = () => {
    const newErrors: { username?: string; password?: string } = {};

    if (!username) {
      newErrors.username = "Username is required";
    }

    if (!password) {
      newErrors.password = "Password is required";
    }

    return newErrors;
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const validationErrors = validateForm();
    if (Object.keys(validationErrors).length === 0) {
      // No errors, proceed with form submission
      loginMutation.mutate({
        username: username,
        password: password,
      });
    } else {
      // Set errors
      setErrors(validationErrors);
    }
  };

  const handleFocus = (field: string) => {
    setErrors((prevErrors) => ({ ...prevErrors, [field]: undefined }));
  };

  return (
    <>
      <Section>
        <Heading size={"8"} align={"center"}>
          Welcome back!
        </Heading>
      </Section>
      <Section>
        <Flex direction={"column"} justify={"center"} align={"center"}>
          <Card>
            <form onSubmit={handleSubmit}>
              <Flex direction={"column"} gap={"3"} m={"3"}>
                <label>
                  <Text as={"div"} size={"2"} mb={"1"} weight={"bold"}>
                    Username
                  </Text>
                  <TextField.Root
                    placeholder="Enter your username"
                    value={username}
                    onChange={(e) => setUsername(e.target.value)}
                    onFocus={() => handleFocus("username")}
                    style={{
                      borderColor: errors.username ? "red" : "initial",
                      borderWidth: errors.username ? "1px" : "initial",
                      borderStyle: errors.username ? "solid" : "initial",
                    }}
                  />
                  {errors.username && (
                    <Text as={"div"} size={"1"} mt={"1"} color={"red"}>
                      {errors.username}
                    </Text>
                  )}
                </label>
                <label>
                  <Text as={"div"} size={"2"} mt={"2"} mb={"1"} weight={"bold"}>
                    Password
                  </Text>
                  <TextField.Root
                    type="password"
                    placeholder="Enter your password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    onFocus={() => handleFocus("password")}
                    style={{
                      borderColor: errors.password ? "red" : "initial",
                      borderWidth: errors.password ? "1px" : "initial",
                      borderStyle: errors.password ? "solid" : "initial",
                    }}
                  />
                  {errors.password && (
                    <Text as={"div"} size={"1"} mt={"1"} color={"red"}>
                      {errors.password}
                    </Text>
                  )}
                </label>
              </Flex>
              <Flex direction={"column"} justify={"center"} mx={"3"}>
                <Button
                  variant={"outline"}
                  mt={"3"}
                  type="submit"
                  disabled={loginButtonDisabled}
                >
                  Login
                </Button>
              </Flex>
            </form>
          </Card>
          <Text size={"2"} mt={"5"}>
            New here? <Link href="/register">Join us today!</Link>
          </Text>
        </Flex>
      </Section>
      {notification && (
        <Card
          style={{
            position: "fixed",
            bottom: "20px",
            right: "20px",
            background: getNotificationColor(notification),
            zIndex: 9999,
            padding: "16px",
            boxShadow: "0 4px 6px rgba(0, 0, 0, 0.1)",
          }}
        >
          <Flex align="center" justify="center">
            <Text>{notification}</Text>
          </Flex>
        </Card>
      )}
    </>
  );
}
