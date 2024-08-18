import { Theme } from "@radix-ui/themes";
import "@radix-ui/themes/styles.css";
import { Checklist } from './components/Checklist';

function App() {
  return (
    <Theme>
      <Checklist />
    </Theme>
  )
}

export default App
