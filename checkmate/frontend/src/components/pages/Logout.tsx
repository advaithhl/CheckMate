import { Flex, Heading, Link, Section, Text } from "@radix-ui/themes";
import { clearUserInfoFromLocalStorage } from "../../utils/userInfo";

export function Logout() {
  clearUserInfoFromLocalStorage();

  return (
    <Section>
      <Flex gap={"3"} align={"center"} justify={"center"} direction={"column"}>
        <Heading>You have logged out 👋🏻</Heading>
        <Text size={"2"}>
          Missed to add something? <Link href="/login">Login again.</Link>
        </Text>
      </Flex>
    </Section>
  );
}
