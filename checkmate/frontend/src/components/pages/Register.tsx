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
import { registerUser } from "../../services/AuthService";
import { useNavigate } from "react-router-dom";
import { AxiosError } from "axios";

const getNotificationColor = (notification: string) => {
  if (notification.includes("successful")) return "green";
  else if (notification.includes("wait")) return "orange";
  else return "red";
};

export function Register() {
  const [name, setName] = useState("");
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [errors, setErrors] = useState<{
    name?: string;
    username?: string;
    password?: string;
  }>({});
  const navigate = useNavigate();
  const [notification, setNotification] = useState("");
  const [registerButtonDisabled, setRegisterButtonDisabled] = useState(false);

  const registerMutation = useMutation({
    mutationFn: registerUser,
    onMutate: () => {
      setRegisterButtonDisabled(true);
      setNotification("Processing registration. Please wait...");
    },
    onSuccess: () => {
      setNotification("Registration successful! Redirecting...");
      setTimeout(() => {
        setNotification("");
        navigate("/login");
      }, 3000);
    },
    onError: (error: AxiosError) => {
      setRegisterButtonDisabled(false);
      if (error.status === 409) {
        setErrors({
          username: "Username is already taken",
        });
        setNotification("");
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
    const newErrors: { name?: string; username?: string; password?: string } =
      {};

    if (!name) {
      newErrors.name = "Name is required";
    }

    if (!username) {
      newErrors.username = "Username is required";
    }

    if (!password) {
      newErrors.password = "Password is required";
    } else if (password.length < 6) {
      newErrors.password = "Password must be at least 6 characters long";
    }

    return newErrors;
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const validationErrors = validateForm();
    if (Object.keys(validationErrors).length === 0) {
      // No errors, proceed with form submission
      registerMutation.mutate({
        name: name,
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
          Create new account
        </Heading>
      </Section>
      <Section>
        <Flex direction={"column"} justify={"center"} align={"center"}>
          <Card>
            <form onSubmit={handleSubmit}>
              <Flex direction={"column"} gap={"3"} m={"3"}>
                <label>
                  <Text as={"div"} size={"2"} mb={"1"} weight={"bold"}>
                    Name
                  </Text>
                  <TextField.Root
                    placeholder="Enter your name"
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    onFocus={() => handleFocus("name")}
                    style={{
                      borderColor: errors.name ? "red" : "initial",
                      borderWidth: errors.name ? "1px" : "initial",
                      borderStyle: errors.name ? "solid" : "initial",
                    }}
                  />
                  {errors.name && (
                    <Text as={"div"} size={"1"} mt={"1"} color={"red"}>
                      {errors.name}
                    </Text>
                  )}
                </label>
                <label>
                  <Text as={"div"} size={"2"} mt={"2"} mb={"1"} weight={"bold"}>
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
                    <Text
                      as={"div"}
                      wrap={"balance"}
                      size={"1"}
                      mt={"1"}
                      color={"red"}
                    >
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
                  disabled={registerButtonDisabled}
                >
                  Register
                </Button>
              </Flex>
            </form>
          </Card>
          <Text size={"2"} mt={"5"}>
            Already have an account? <Link href="/login">Login instead.</Link>
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
