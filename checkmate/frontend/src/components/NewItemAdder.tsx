import { Button, Dialog, Flex, TextField } from "@radix-ui/themes";
import { FabButton } from "./FloatingActionButton";
import { PlusIcon } from "@radix-ui/react-icons";
import { addItem } from "../services/ActionService";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { useState } from "react";

export function NewItemAdder() {
  const [newItem, setNewItem] = useState("");
  const queryClient = useQueryClient();

  const addNewItemMutation = useMutation({
    mutationFn: addItem,
    onSuccess: () => {
      // This invalidates the query, forcing a refetch.
      queryClient.invalidateQueries({ queryKey: ["items"] });
    },
  });

  return (
    <Dialog.Root>
      <Dialog.Trigger>
        <FabButton onClick={() => setNewItem("")}>{<PlusIcon />}</FabButton>
      </Dialog.Trigger>

      <Dialog.Content maxWidth="450px">
        <Dialog.Title>Add new item</Dialog.Title>

        <label>
          <TextField.Root
            value={newItem}
            onChange={(e) => setNewItem(e.target.value)}
            placeholder="Enter your item here"
          />
        </label>

        <Flex gap="3" mt="4" justify="end">
          <Dialog.Close>
            <Button variant="soft" color="gray">
              Cancel
            </Button>
          </Dialog.Close>
          <Dialog.Close>
            <Button
              onClick={() => addNewItemMutation.mutate({ text: newItem })}
            >
              Add
            </Button>
          </Dialog.Close>
        </Flex>
      </Dialog.Content>
    </Dialog.Root>
  );
}

export default NewItemAdder;
