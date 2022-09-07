import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import App from './App'
import './index.css'
import 'katex/dist/katex.css'
import {store} from './store'
const rootElement = document.getElementById("root");
const root = createRoot(rootElement);

root.render(
  <StrictMode>
    <App/>
  </StrictMode>
);
