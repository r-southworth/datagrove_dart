// https://github.com/codemirror/dev/issues/306
// import * as yamlMode from '@codemirror/legacy-modes/mode/yaml';
// import * as streamParser from '@codemirror/stream-parser';

// const yamlPlugin = new LanguageSupport(streamParser.StreamLanguage.define(yamlMode.yaml));

import {exitCode} from "prosemirror-commands"
import {undo, redo} from "prosemirror-history"
import {EditorState, Selection, TextSelection} from "prosemirror-state"
import {EditorView} from "prosemirror-view"
import {DOMParser,Node as ProsemirrorNode} from "prosemirror-model"
import {keymap} from "prosemirror-keymap"
import { getSchema } from "./server"



import { Extension as CmExtension, EditorState as CmEditorState } from "@codemirror/state";
import {EditorView as CmEditorView, keymap as cmkeymap, drawSelection} from "@codemirror/view"
import { markdown } from "@codemirror/lang-markdown"
import {basicSetup } from 'codemirror'
import { javascript } from "@codemirror/lang-javascript";
import { oneDark } from "@codemirror/theme-one-dark"
import {defaultKeymap} from "@codemirror/commands"// import {
//   EditorView as CodeMirror, keymap as cmKeymap, drawSelection
// } from "@codemirror/view"

import katex from 'katex'
import vegaEmbed from 'vega-embed'
import yaml from 'yaml'
import {Chart} from 'frappe-charts'
import React, { useCallback, useEffect, useState } from "react";

export function useCodeMirror(extensions: CmExtension[]) {
  const [element, setElement] = useState<HTMLElement>();

  const ref = useCallback((node: HTMLElement | null) => {
    if (!node) return;

    setElement(node);
  }, []);

  useEffect(() => {
    if (!element) return;

    const view = new CmEditorView({
      state: CmEditorState.create({
        extensions: [
           basicSetup,
           oneDark,
          javascript(),
          markdown(),
          drawSelection(),
          //syntaxHighlighting(defaultHighlightStyle),
          // ...extensions
        ]
      }),
      parent: element
    });

    return () => view?.destroy();
  }, [element]);

  return { ref };
}

type CodeMirrorProps = {
    extensions: CmExtension[];
  };
  
  export const CodeEditor = ({ extensions }: CodeMirrorProps) => {
    const { ref } = useCodeMirror(extensions);
  
    return <div ref={ref} />;
  };
  
  export class CodeBlockView { 
    cm: CmEditorView
    updating: boolean
    dom: HTMLElement
    nodepm: ProsemirrorNode
    view: EditorView
 
    getPos: ()=>number
    // constructor(component,
    //     opt: { editor, extension, node, view, getPos, decorations }){
    constructor(node: ProsemirrorNode,  view: EditorView,  getPos: ()=>number) {
      //super(component,opt)
      // Store for later
      
      this.nodepm = node
      this.view = view
      this.getPos = getPos
      // Create a CodeMirror instance
      this.cm = new CmEditorView({
        doc: this.nodepm.textContent,
        extensions: [
          basicSetup,
          markdown(),
          oneDark,
          cmkeymap.of([
            ...this.codeMirrorKeymap(),
            ...defaultKeymap
          ]),
           drawSelection(),
          // syntaxHighlighting(defaultHighlightStyle),
          // javascript(),
          // CmEditorView.updateListener.of(update => this.forwardUpdate(update))
        ]
      })
  
      var lang = node.attrs['language']
      // The editor's outer node is our DOM representation
      this.dom = document.createElement("div")
      this.dom.className = "cm-wrapper"

      var show = document.createElement("div")
      show.classList.add("cm-show") 
      

      var vjs : string
      const render = ()=>{
        const v = this.cm.state.doc.toString()
        switch(lang) {
            case 'katex':
                katex.render(v, show)
                break;
            case 'frappe':
                 vjs = yaml.parse(v)
                console.log("frappe", vjs)
                new Chart(show,vjs)
                break;
            case 'vega-lite':
                vjs = yaml.parse(v)
                vegaEmbed(show, vjs)
                
                break;
        }
    }
    render()
      this.cm.contentDOM.addEventListener("blur", render)
      this.dom.appendChild(show)
      var caption = document.createElement("div");
      caption.className = 'cm-lang'
      caption.innerText = lang
      this.dom.appendChild(caption)
      this.dom.appendChild(this.cm.dom)
      /*
      I'm not sure I see the advantage of this approach; why would you change?
         select: HTMLSelectElement
      this.select = document.createElement("select");
      this.select.addEventListener("change", this.handleLanguageChange);
      this.select.style.color = 'black';    
      ["katex","mermaid","graphjs","vega-lite"].forEach((label) => {
        const option = document.createElement("option");
        option.value = label;
        option.innerText = label;
        option.selected = node.attrs.language === label;
        this.select.appendChild(option);
      });  
      this.dom.appendChild(this.select)
         this.select.value
             handleLanguageChange(ev: Event){
     

    }
      */
  
      // This flag is used to avoid an update loop between the outer and
      // inner editor
      this.updating = false
      console.log(this)
    }

  // }
  // nodeview_forwardUpdate{
    forwardUpdate(update) {
      if (this.updating || !this.cm.hasFocus) return
      let offset = this.getPos() + 1, {main} = update.state.selection
      let selection = TextSelection.create(this.view.state.doc,
                                           offset + main.from, offset + main.to)
      if (update.docChanged || !this.view.state.selection.eq(selection)) {
        let tr = this.view.state.tr.setSelection(selection)
        update.changes.iterChanges((fromA, toA, fromB, toB, text) => {
          if (text.length)
            tr.replaceWith(offset + fromA, offset + toA,
                           getSchema().text(text.toString()))
          else
            tr.delete(offset + fromA, offset + toA)
          offset += (toB - fromB) - (toA - fromA)
        })
        this.view.dispatch(tr)
      }
    }
  // }
  // nodeview_setSelection{
    setSelection(anchor, head) {
      this.cm.focus()
      this.updating = true
      this.cm.dispatch({selection: {anchor, head}})
      this.updating = false
    }
  // }
  // nodeview_keymap{
    codeMirrorKeymap() {
      let view = this.view
      return [
        {key: "ArrowUp", run: () => this.maybeEscape("line", -1)},
        {key: "ArrowLeft", run: () => this.maybeEscape("char", -1)},
        {key: "ArrowDown", run: () => this.maybeEscape("line", 1)},
        {key: "ArrowRight", run: () => this.maybeEscape("char", 1)},
        {key: "Ctrl-Enter", run: () => {
          if (!exitCode(view.state, view.dispatch)) return false
          view.focus()
          return true
        }},
        {key: "Ctrl-z", mac: "Cmd-z",
         run: () => undo(view.state, view.dispatch)},
        {key: "Shift-Ctrl-z", mac: "Shift-Cmd-z",
         run: () => redo(view.state, view.dispatch)},
        {key: "Ctrl-y", mac: "Cmd-y",
         run: () => redo(view.state, view.dispatch)}
      ]
    }
  
    maybeEscape(unit, dir) {
      let {state} = this.cm
      let {main} = state.selection
      if (!main.empty) return false
      if (unit == "line") {
        //main = state.doc.lineAt(main.head)
      }
      if (dir < 0 ? main.from > 0 : main.to < state.doc.length) return false
      let targetPos = this.getPos() + (dir < 0 ? 0 : this.nodepm.nodeSize)
      let selection = Selection.near(this.view.state.doc.resolve(targetPos), dir)
      let tr = this.view.state.tr.setSelection(selection).scrollIntoView()
      this.view.dispatch(tr)
      this.view.focus()
    }
  // }
  // nodeview_update{
    update(node: ProsemirrorNode) {
      if (node.type != this.nodepm.type) return false
      this.nodepm = node
      if (this.updating) return true
      let newText = node.textContent, curText = this.cm.state.doc.toString()
      if (newText != curText) {
        let start = 0, curEnd = curText.length, newEnd = newText.length
        while (start < curEnd &&
               curText.charCodeAt(start) == newText.charCodeAt(start)) {
          ++start
        }
        while (curEnd > start && newEnd > start &&
               curText.charCodeAt(curEnd - 1) == newText.charCodeAt(newEnd - 1)) {
          curEnd--
          newEnd--
        }
        this.updating = true
        this.cm.dispatch({
          changes: {
            from: start, to: curEnd,
            insert: newText.slice(start, newEnd)
          }
        })
        this.updating = false
      }
      return true
    }
  // }
  // nodeview_end{
  
    selectNode() { this.cm.focus() }
    stopEvent() { return true }
  }
  // }
  // arrowHandlers{
  
  
  function arrowHandler(dir) {
    return (state, dispatch, view) => {
      if (state.selection.empty && view.endOfTextblock(dir)) {
        let side = dir == "left" || dir == "up" ? -1 : 1
        let $head = state.selection.$head
        let nextPos = Selection.near(
          state.doc.resolve(side > 0 ? $head.after() : $head.before()), side)
        if (nextPos.$head && nextPos.$head.parent.type.name == "math_block") {
          dispatch(state.tr.setSelection(nextPos))
          return true
        }
      }
      return false
    }
  }
  
  const arrowHandlers = keymap({
    ArrowLeft: arrowHandler("left"),
    ArrowRight: arrowHandler("right"),
    ArrowUp: arrowHandler("up"),
    ArrowDown: arrowHandler("down")
  })
  
  /*
  import {EditorState, Selection, TextSelection} from "prosemirror-state"
  import {EditorView} from "prosemirror-view"
  import {DOMParser} from "prosemirror-model"
  import {exampleSetup} from "prosemirror-example-setup"
  
  window.view = new EditorView(document.querySelector("#editor"), {
    state: EditorState.create({
      doc: DOMParser.fromSchema(schema).parse(document.querySelector("#content")),
      plugins: exampleSetup({schema}).concat(arrowHandlers)
    }),
    nodeViews: {code_block: (node, view, getPos) => new CodeBlockView(node, view, getPos)}
  })
  */