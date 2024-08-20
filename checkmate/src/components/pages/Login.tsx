import {
  Button,
  Card,
  Flex,
  Heading,
  Link,
  Section,
  Text,
  TextField,
} from "@radix-ui/themes";

export function Login() {
  return (
    <>
      <Section>
        <Heading size={"8"} align={"center"}>
          Welcome back!
        </Heading>
      </Section>
      <Section>
        <Flex direction={"column"} justify={"center"} align={"center"}>
          <Card>
            <Flex direction={"column"} gap={"3"} m={"3"}>
              <label>
                <Text as={"div"} size={"2"} mb={"1"} weight={"bold"}>
                  Username
                </Text>
                <TextField.Root placeholder="Enter your username" />
              </label>
              <label>
                <Text as={"div"} size={"2"} mt={"2"} mb={"1"} weight={"bold"}>
                  Password
                </Text>
                <TextField.Root
                  type="password"
                  placeholder="Enter your password"
                />
              </label>
            </Flex>
            <Flex direction={"column"} justify={"center"} mx={"3"}>
              <Button variant={"outline"} mt={"3"}>
                Login
              </Button>
            </Flex>
          </Card>
          <Text size={"2"} mt={"5"}>
            New here? <Link href="/register">Join us today!</Link>
          </Text>
        </Flex>
      </Section>
    </>
  );
}
