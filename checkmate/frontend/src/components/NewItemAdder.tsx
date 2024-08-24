import { Button, Dialog, Flex, TextField } from "@radix-ui/themes";
import { FabButton } from "./FloatingActionButton";
import { PlusIcon } from "@radix-ui/react-icons";

export function NewItemAdder() {
  return (
    <Dialog.Root>
      <Dialog.Trigger>
        <FabButton>{<PlusIcon />}</FabButton>
      </Dialog.Trigger>

      <Dialog.Content maxWidth="450px">
        <Dialog.Title>Add new item</Dialog.Title>

        <label>
          <TextField.Root
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
            <Button>Add</Button>
          </Dialog.Close>
        </Flex>
      </Dialog.Content>
    </Dialog.Root>
  );
}

export default NewItemAdder;
