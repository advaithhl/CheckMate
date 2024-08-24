import { CheckIcon, TrashIcon } from "@radix-ui/react-icons";
import { Button, Card, Container, Flex, Text } from "@radix-ui/themes";
import "./styles.css";

export function Checklist() {
  const data = [
    {
      id: "1",
      text: "Hello world",
    },
    {
      id: "3",
      text: "Buy milk",
    },
  ];

  return (
    <Container>
      {data.map((item) => (
        <Card key={item.id} mx={"2"} my={"3"}>
          <Flex justify={"between"} align={"center"}>
            <Text ml={"3"} size={"3"}>
              {item.text}
            </Text>
            <Flex gap={"2"} justify={"end"}>
              <Button variant={"soft"} color={"grass"}>
                <Text className="hidden-on-mobile">Mark as done</Text>
                <CheckIcon width="18" height="18" />
              </Button>
              <Button variant={"soft"} color={"red"}>
                <Text className="hidden-on-mobile">Delete</Text>
                <TrashIcon width="18" height="18" />
              </Button>
            </Flex>
          </Flex>
        </Card>
      ))}
    </Container>
  );
}
