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
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { deleteItem, getItems } from "../services/ActionService";

export function Checklist() {
  const {
    data: checkList,
    isLoading,
    isError,
    error,
  } = useQuery({
    queryFn: getItems,
    queryKey: ["items"],
  });

  const queryClient = useQueryClient();

  const deleteItemMutation = useMutation({
    mutationFn: deleteItem,
    onSuccess: () => {
      // This invalidates the query, forcing a refetch.
      queryClient.invalidateQueries({ queryKey: ["items"] });
    },
  });

  return (
    <Container>
      {isLoading && (
        <Flex justify={"center"}>
          <Spinner />
        </Flex>
      )}
      {isError && !error.message.includes("40") && (
        <Flex justify={"center"}>
          <Text>
            An error occurred while fetching the checklist. Please try to{" "}
            <Link href="/">refresh</Link> the page.
          </Text>
        </Flex>
      )}
      {isError && error.message.includes("401") && (
        <Flex justify={"center"}>
          <Text>
            Your session has timed out. Please{" "}
            <Link href="/logout">logout</Link> and login again.
          </Text>
        </Flex>
      )}
      {isError && error.message.includes("403") && (
        <Flex justify={"center"}>
          <Text>
            Your session seems to be corrupted. Please{" "}
            <Link href="/logout">logout</Link> and login again.
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
                <Button
                  variant={"soft"}
                  color={"grass"}
                  onClick={() => deleteItemMutation.mutate({ id: item.id })}
                >
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
