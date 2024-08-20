import { Heading, Section } from "@radix-ui/themes";
import { Checklist } from "../Checklist";
import { PlusIcon } from "@radix-ui/react-icons";
import FloatingActionButton from "../FloatingActionButton";

export function Home() {
  const user = "John Doe";
  const handleFabClick = () => {
    console.log("FAB clicked!");
  };

  return (
    <>
      <Section>
        <Heading>Hello {user}</Heading>
      </Section>
      <Section>
        <Checklist />
      </Section>
      <FloatingActionButton onClick={handleFabClick} icon={<PlusIcon />} />
    </>
  );
}
