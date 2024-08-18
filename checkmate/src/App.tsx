import { Theme } from "@radix-ui/themes";
import "@radix-ui/themes/styles.css";
import { Home } from "./components/pages/Home";

function App() {
  return (
    <Theme>
      <Home />
    </Theme>
  );
}

export default App;
