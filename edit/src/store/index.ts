
import { EditorView } from 'prosemirror-view'
import { makeAutoObservable } from "mobx"
import { observer } from "mobx-react"
import { MarkdownSerializer, MarkdownParser } from '../editor/lib/markdown/serializer'
import { TestSource } from '../store/scrollerSource'
import { Scroller } from './scroller'
import { test } from './canvas'
//import { startCodeMirror, content } from './codemirror'
import { parser, serializer } from '../editor/server'

export const webview = null //(window as any)?.chrome?.webview
const tablePane = document.getElementById('tablePane')
const scrollPane = document.getElementById('scrollPane')
const codePane = document.getElementById('codePane')
const rootPane = document.getElementById('root')
const source = new TestSource(20)
const scroller = new Scroller(scrollPane, source)
let v = `
# one

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
class AppState {
  view: EditorView | undefined
  label = "Untitled"
  editorValue = v
  screen = "edit"

  constructor() {
    makeAutoObservable(this)

    if (webview) {
      webview.addEventListener('message', (x: MessageEvent) => {
        let [a, b] = x.data.split("\n")
        this.label = a ? a : "Untitled"
        this.editorValue = b
        console.log(x, a, b)
      })
      webview.postMessage("!~~!")
    }
    this.setScreen(this.screen)
  }

  setScreen = (s: string) => {
    console.log(`screen ${s}`)
    this.screen = s
    // rootPane.style.display = s == "edit" ? "block" : "none";
    // scrollPane.style.display = s == "chat" ? "block" : "none";
    // tablePane.style.display = s == "table" ? "block" : "none";
    //codePane.style.display = s == "code" ? "block" : "none";
    // if (s == "table") {
    //   test()
    // }
  }
  setView = (v: EditorView) => {
    this.view = v
  }
  asMarkdown = (): string => {
    if (!this.view || !serializer) return "";

    const content = this.view.state.doc;
    console.log(content.toJSON())
    var txt = serializer.serialize(content)
    console.log(txt)
    return txt
  }
  download = () => {
    downloadString(store.label + ".md", this.asMarkdown())
  }
  editText = () => {
    //startCodeMirror(codePane, this.asMarkdown())
    this.setScreen('text')
  }
  editRich = () => {
    // var s = content()
    // this.view.state.doc = parser.parse(s)
    this.setScreen('edit')
  }
  done = () => {
    if (webview)
      webview.postMessage(this.asMarkdown());
    console.log("done", this)
  }
}
export const store = new AppState();

// this is feeding markdown directly as a download, so from flutter all we need to do is trigger it. separately we might want a way to extract it.
function downloadString(filename: string, text: string) {
  var element = document.createElement('a');
  element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
  element.setAttribute('download', filename);

  element.style.display = 'none';
  document.body.appendChild(element);

  element.click();

  document.body.removeChild(element);
}

