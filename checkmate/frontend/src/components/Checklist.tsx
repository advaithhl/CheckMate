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
import { useState } from "react";

export function Checklist() {
  const {
    data: checkList,
    isLoading: isGetItemsLoading,
    isError: isGetItemsError,
    error: getItemsError,
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
    onError: () => {
      setDisabledButtonItemId("");
    },
  });

  const [disabledButtonItemId, setDisabledButtonItemId] = useState("");

  return (
    <Container>
      {isGetItemsLoading && (
        <Flex justify={"center"}>
          <Spinner />
        </Flex>
      )}
      {((isGetItemsError && !getItemsError.message.includes("40")) ||
        (deleteItemMutation.isError &&
          !deleteItemMutation.error.message.includes("40"))) && (
        <Flex justify={"center"}>
          <Text>
            An error occurred while fetching the checklist. Please try to{" "}
            <Link href="/">refresh</Link> the page.
          </Text>
        </Flex>
      )}
      {((isGetItemsError && getItemsError.message.includes("401")) ||
        (deleteItemMutation.isError &&
          deleteItemMutation.error.message.includes("401"))) && (
        <Flex justify={"center"}>
          <Text>
            Your session has timed out. Please{" "}
            <Link href="/logout">logout</Link> and login again.
          </Text>
        </Flex>
      )}
      {((isGetItemsError && getItemsError.message.includes("403")) ||
        (deleteItemMutation.isError &&
          deleteItemMutation.error.message.includes("403"))) && (
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
                  onClick={() => {
                    setDisabledButtonItemId(item.id);
                    deleteItemMutation.mutate({ id: item.id });
                  }}
                >
                  <Text className="hidden-on-mobile">Mark as done</Text>
                  {disabledButtonItemId !== item.id && (
                    <CheckIcon width="18" height="18" />
                  )}
                  {disabledButtonItemId === item.id && <Spinner />}
                </Button>
              </Flex>
            </Flex>
          </Card>
        ))}
    </Container>
  );
}
