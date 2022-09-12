import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import './index.css'
import 'katex/dist/katex.css'
import Editor from "./editor"
import './App.css'
//import { store } from "./store"
import { dark } from './editor/styles/theme';
import { TestSource } from './store/scrollerSource'
import { Scroller } from './store/scroller'
async function upload2(f: File): Promise<string> {
  return URL.createObjectURL(f)
}


export const Chat = () => {
  return <div className='app-wrap'><Editor theme={dark} className='editor dark:prose-invert prose max-w-none'
    defaultValue={""}
    uploadImage={upload2}
    placeholder="..." autoFocus /></div>
}

export const Sheet = () => {
  return <div className='app-wrap'><Editor theme={dark} className='editor dark:prose-invert prose max-w-none'
    defaultValue={""}
    uploadImage={upload2}
    placeholder="..." autoFocus /></div>
}

class Tx {

}
type UpdateEditor = (x: Tx) => void
export function mountEditor(id: string, md: string, onchange: (x: Tx) => void): UpdateEditor {
  const rootElement = document.getElementById(id);
  const root = createRoot(rootElement);
  root.render(
    <StrictMode>
      <div className='app-wrap'><Editor theme={dark} className='editor dark:prose-invert prose max-w-none'
        defaultValue={md}
        uploadImage={upload2}
        placeholder="..." autoFocus /></div>
    </StrictMode>
  );
  return (x: Tx) => {
  }
}

type UpdateChat = (x: Tx) => void
export function mountChat(id: string, m: any, onchange: (x: Tx) => void): UpdateChat {
  const root = document.getElementById(id);
  const source = new TestSource(20)
  const scroller = new Scroller(root, source)
  return (x: Tx) => {
  }
}

export function downloadString(filename: string, text: string) {
  var element = document.createElement('a');
  element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
  element.setAttribute('download', filename);

  element.style.display = 'none';
  document.body.appendChild(element);

  element.click();

  document.body.removeChild(element);
}


let v = `
# one !

## two 

### three

\`\`\`katex
  x^2
\`\`\`

\`\`\`frappe
title: chart
type: axis-mixed
height: 250
colors:
  - #7cd6fd
  - #743ee2
data:
  labels:
    - 12am-3am
    - 3am-6pm
    - 6am-9am
    - 9am-12am
    - 12pm-3pm
    - 3pm-6pm
    - 6pm-9pm
    - 9am-12am
  datasets:
    - name: Some Data
      type: bar
      values:
        - 25
        - 40
        - 30
        - 35
        - 8
        - 52
        - 17
        - -4
    - name: Another Set
      type: line
      values:
        - 25
        - 50
        - -10
        - 15
        - 18
        - 32
        - 27
        - 14
\`\`\`

\`\`\`vega-lite
data:
  values:
    - a: C
      b: 2
    - a: C
      b: 7
    - a: C
      b: 4
    - a: D
      b: 1
    - a: D
      b: 2
    - a: D
      b: 6
    - a: E
      b: 8
    - a: E
      b: 4
    - a: E
      b: 7
mark: bar
encoding:
  y:
    field: a
    type: nominal
  x:
    aggregate: average
    field: b
    type: quantitative
    title: Mean of b
\`\`\`

- one
- two
- three
`

var mode = 1;
switch (mode) {
  case 0:
    mountEditor('root', v, (x) => {
      console.log(x)
    })
    break;
  case 1:
    mountChat('root', {}, (x) => {
      console.log(x)
    })
    break;
}