import { EditorView, basicSetup } from "codemirror"
import { EditorState } from "@codemirror/state"
import { javascript } from "@codemirror/lang-javascript"
import { markdown } from "@codemirror/lang-markdown"
import { oneDark } from "@codemirror/theme-one-dark"
import { keymap } from "@codemirror/view"
import { defaultKeymap } from "@codemirror/commands"

var view: EditorView
export function startCodeMirror(el: HTMLElement, text: string) {
    view = new EditorView({
        state: EditorState.create({
            doc: text,
            extensions: [basicSetup, markdown(), oneDark],
        }),
        parent: el
    })
}
export function content(): string {
    return view.state.doc.toString()
}
/*
editText = () => {
    startCodeMirror(codePane, this.asMarkdown())
    this.setScreen('code')
  }
  editRich = () => {
    var s = content()
    this.view.state.doc = parser.parse(s)
    this.setScreen('edit')
  }*/