import { Heading, Section } from "@radix-ui/themes";
import { Checklist } from "../Checklist";
import { NewItemAdder } from "../NewItemAdder";
import { getUserInfoFromLocalStorage } from "../../utils/userInfo";

export function Home() {
  const userInfo = getUserInfoFromLocalStorage();

  return (
    <>
      <Section>
        <Heading align={"center"}>
          Hello {userInfo ? userInfo.name : "user"}!
        </Heading>
      </Section>
      <Section>
        <Checklist />
      </Section>
      <NewItemAdder />
    </>
  );
}
