import { Flex, Heading, Link, Section, Text } from "@radix-ui/themes";
import { Checklist } from "../Checklist";
import { NewItemAdder } from "../NewItemAdder";
import { getUserInfoFromLocalStorage } from "../../utils/userInfo";

export function Home() {
  const userInfo = getUserInfoFromLocalStorage();

  return (
    <>
      <Section>
        <Flex align={"center"} justify={"center"} direction={"column"}>
          <Heading align={"center"}>
            Hello {userInfo ? userInfo.name : "user"}!
          </Heading>
          <Text mt={"2"} size={"1"}>
            Not you? <Link href="/logout">Logout</Link>
          </Text>
        </Flex>
      </Section>
      <Section>
        <Checklist />
      </Section>
      <NewItemAdder />
    </>
  );
}
