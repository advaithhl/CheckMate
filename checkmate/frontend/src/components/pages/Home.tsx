import { Heading, Section } from "@radix-ui/themes";
import { Checklist } from "../Checklist";
import { NewItemAdder } from "../NewItemAdder";

export function Home() {
  const user = "John Doe";

  return (
    <>
      <Section>
        <Heading>Hello {user}</Heading>
      </Section>
      <Section>
        <Checklist />
      </Section>
      <NewItemAdder />
    </>
  );
}
