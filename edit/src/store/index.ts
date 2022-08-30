
import { EditorView } from 'prosemirror-view'
import { makeAutoObservable } from "mobx"
import { observer } from "mobx-react"
import { MarkdownSerializer } from '../editor/lib/markdown/serializer'

export const webview = (window as any)?.chrome?.webview

class AppState {
  view: EditorView | undefined
  serializer: MarkdownSerializer | undefined
  label = "Untitled"
  editorValue = ""

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
  }

  setView = (v: EditorView, s: MarkdownSerializer) =>{
    this.view = v
    this.serializer = s
  }
  asMarkdown = (): string => {
    if (!this.view || !this.serializer) return "";

    const content = this.view.state.doc;
    return store.serializer.serialize(content)
  }
  download = () =>{
    downloadString(store.label + ".md", this.asMarkdown())
  }
  done = ()=> {
    if (webview)
      webview.postMessage(this.asMarkdown());
    console.log("done",this)
  }
}
export const store = new AppState();


function downloadString(filename: string, text: string) {
  var element = document.createElement('a');
  element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
  element.setAttribute('download', filename);

  element.style.display = 'none';
  document.body.appendChild(element);

  element.click();

  document.body.removeChild(element);
}

