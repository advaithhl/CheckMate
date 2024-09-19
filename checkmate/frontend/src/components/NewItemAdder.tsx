import {
  AlertDialog,
  Button,
  Dialog,
  Flex,
  Spinner,
  TextField,
} from "@radix-ui/themes";
import { FabButton } from "./FloatingActionButton";
import { PlusIcon } from "@radix-ui/react-icons";
import { addItem } from "../services/ActionService";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { useState } from "react";
import { AxiosError } from "axios";

export function NewItemAdder() {
  const [newItem, setNewItem] = useState("");
  const queryClient = useQueryClient();

  const addNewItemMutation = useMutation({
    mutationFn: addItem,
    onMutate: () => {
      setMutationInProgress(true);
    },
    onSuccess: () => {
      // This invalidates the query, forcing a refetch.
      queryClient.invalidateQueries({ queryKey: ["items"] });
      setMutationInProgress(false);
      setErrorTitle("");
      setErrorMessage("");
      setErrorRedirectLink("");
    },
    onError: (error: AxiosError) => {
      setMutationInProgress(false);
      if (error.status === 401) {
        setErrorTitle("Session expired");
        setErrorMessage(
          "Your session has timed out. Please logout and login again."
        );
        setErrorRedirectLink("/logout");
      } else if (error.status === 403) {
        setErrorTitle("Invalid session");
        setErrorMessage(
          "Your session seems to be corrupted. Please logout and login again."
        );
        setErrorRedirectLink("/logout");
      } else {
        console.log(error);
        setErrorTitle("Error");
        setErrorMessage(
          "An error occurred while adding your task. Please try to reload the page."
        );
        setErrorRedirectLink("/");
      }
      setShowErrorDialog(true);
    },
  });

  const [mutationInProgress, setMutationInProgress] = useState(false);
  const [showErrorDialog, setShowErrorDialog] = useState(false);
  const [errorTitle, setErrorTitle] = useState("");
  const [errorMessage, setErrorMessage] = useState("");
  const [errorRedirectLink, setErrorRedirectLink] = useState("");

  return (
    <>
      <Dialog.Root>
        <Dialog.Trigger>
          <FabButton onClick={() => setNewItem("")}>{<PlusIcon />}</FabButton>
        </Dialog.Trigger>

        <Dialog.Content maxWidth="450px">
          <Dialog.Title>Add new task</Dialog.Title>

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
            <Button
              onClick={() => addNewItemMutation.mutate({ text: newItem })}
              disabled={mutationInProgress}
            >
              {mutationInProgress && <Spinner />}
              Add
            </Button>
          </Flex>
        </Dialog.Content>
      </Dialog.Root>
      <AlertDialog.Root open={showErrorDialog}>
        <AlertDialog.Content maxWidth="450px">
          <AlertDialog.Title>{errorTitle}</AlertDialog.Title>
          <AlertDialog.Description size="2">
            {errorMessage}
          </AlertDialog.Description>

          <Flex gap="3" mt="4" justify="end">
            <AlertDialog.Action>
              <a href={errorRedirectLink}>
                <Button variant="outline">
                  {errorTitle === "Error" ? "Reload page" : "Logout"}
                </Button>
              </a>
            </AlertDialog.Action>
          </Flex>
        </AlertDialog.Content>
      </AlertDialog.Root>
    </>
  );
}

export default NewItemAdder;
