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

export function Login() {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [errors, setErrors] = useState<{
    username?: string;
    password?: string;
  }>({});
  const navigate = useNavigate();

  const loginMutation = useMutation({
    mutationFn: loginUser,
    onSuccess: (data: UserInfo) => {
      setUserInfoToLocalStorage(data);
      console.log(data.id);
      console.log(data.name);
      navigate("/");
    },
    onError: (error) => {
      console.log(error);
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
      console.log("Form submitted:", { username, password });
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
                <Button variant={"outline"} mt={"3"} type="submit">
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
    </>
  );
}
