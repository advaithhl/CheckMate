import { Theme } from "@radix-ui/themes";
import "@radix-ui/themes/styles.css";
import { createBrowserRouter, RouterProvider } from "react-router-dom";
import { Home } from "./components/pages/Home";

const router = createBrowserRouter([
  {
    path: "/",
    element: <Home />,
  },
]);

function App() {
  return (
    <Theme>
      <RouterProvider router={router} />
    </Theme>
  );
}

export default App;
