import { CheckIcon } from "@radix-ui/react-icons";
import {
  Button,
  Card,
  Container,
  Flex,
  Link,
  Spinner,
  Text,
} from "@radix-ui/themes";
import "./styles.css";
import { useQuery } from "@tanstack/react-query";
import { getItems } from "../services/ActionService";

export function Checklist() {
  const {
    data: checkList,
    isLoading,
    isError,
  } = useQuery({
    queryFn: getItems,
    queryKey: ["items"],
  });

  return (
    <Container>
      {isLoading && (
        <Flex justify={"center"}>
          <Spinner />
        </Flex>
      )}
      {isError && (
        <Flex justify={"center"}>
          <Text>
            An error occurred while fetching the checklist. Please try to{" "}
            <Link href="/">refresh</Link> the page.
          </Text>
        </Flex>
      )}
      {checkList &&
        checkList?.items &&
        checkList?.items.map((item) => (
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
              </Flex>
            </Flex>
          </Card>
        ))}
    </Container>
  );
}
