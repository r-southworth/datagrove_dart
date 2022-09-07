import React, { Fragment, useState } from 'react'
import EditMenu from './menu'
import Editor from "./editor"
import './App.css'
import { EllipsisVerticalIcon, ChevronLeftIcon, PlusCircleIcon } from '@heroicons/react/24/solid'
import { ellipsis } from 'prosemirror-inputrules'
import { EditorView } from 'prosemirror-view'
import { makeAutoObservable } from "mobx"
import { observer } from "mobx-react"
import { store } from "./store"
import { dark } from './editor/styles/theme';
import { CodeEditor } from './editor/codemirror'
// ChevronDownIcon, ChevronUpIcon, XIcon,
enum Mode {
  Normal,
  Search,
  Replace,
}
const mainMenu = [
  {
    label: () => (<EllipsisVerticalIcon className='h-6 w-6' />),
    children: [
      { label: () => ("Chat"), do: () => store.setScreen("chat") },
      { label: () => ("Table"), do: () => store.setScreen("table") },
      { label: () => ("Download"), do: () => store.download() },
      { label: () => ("Text"), do: () => store.editText() },
      { label: () => ("Edit"), do: () => store.editRich() },
    ]
  }
]

function AppBare2() {
  const initState = (e) => store.setView(e)
  return <Editor theme={dark} className='editor dark:prose-invert prose max-w-none'
    defaultValue={store.editorValue}
    initState={initState}
    placeholder="..." autoFocus />
}


const AppBare =  observer(() => {
  const initState = (e) => store.setView(e)
  console.log("screen", store.screen)
  switch (store.screen){
    case 'text':
      return <div className='app-wrap'><EditMenu menu={mainMenu}></EditMenu><CodeEditor 

        extensions={[]}
        /></div> 

    case 'edit':
    default:
    return <div className='app-wrap'><EditMenu menu={mainMenu}></EditMenu><Editor theme={dark} className='editor dark:prose-invert prose max-w-none'
      defaultValue={store.editorValue}
      initState={initState}
      placeholder="..." autoFocus /></div> 
    

  }
})

function AppIssi() {
  //const [mode, setMode] = useState(0)
  const ex = () => (<EllipsisVerticalIcon className='h-6 w-6' />)
  const mainMenu = [
    {
      label: ex,
      children: [
        { label: () => ("Download"), do: () => store.download() }
      ]
    }
  ]
  const title = "Untitled"
  return (
    <div style={{ height: '100%' }}>
      <div className="appBar flex">
        <button onClick={store.done}><ChevronLeftIcon className='h-6 w-6 mr-2' /></button>
        <div>{title}</div>
        <div className="grow" />
        <EditMenu menu={mainMenu} />
      </div>
      <Editor className='editor dark:prose-invert prose max-w-none'
        defaultValue={store.editorValue}
        placeholder="..." autoFocus />
    </div>)
}


const editText = (mainMenu) => {
 
  const initState = (e) => store.setView(e)
  return (
    <div style={{ height: '100%' }}>

      <Editor theme={dark} className='editor dark:prose-invert prose max-w-none'
        defaultValue={store.editorValue}
        placeholder="..." autoFocus
        uploadImage={upload2}
        initState={initState}
      />

      <div className="appFooter flex">
        <Editor theme={dark} className=' chatEditor dark:prose-invert prose max-w-none'
          defaultValue={store.editorValue}
          placeholder="..." autoFocus />

        <div className="grow" />
        <EditMenu menu={mainMenu} />
      </div>
    </div>)
}

const chat = (mainMenu) => (
  <div style={{ height: '100%' }}>

    <div className="appFooter flex">
      <Editor theme={dark} className=' chatEditor dark:prose-invert prose max-w-none'
        defaultValue={store.editorValue}
        placeholder="..." autoFocus />

      <div className="grow" />
      <EditMenu menu={mainMenu} />
    </div>
  </div>)

const table = (mainMenu) => (
  <div style={{ height: '100%' }}>

    <div className="appFooter flex">
      <Editor theme={dark} className=' chatEditor dark:prose-invert prose max-w-none'
        defaultValue={store.editorValue}
        placeholder="..." autoFocus />

      <div className="grow" />
      <EditMenu menu={mainMenu} />
    </div>
  </div>)

const App = observer(() => {

  switch (store.screen) {
    case "edit":
      return editText(mainMenu)
    case "code":
      return chat(mainMenu)
    case "chat":
      return chat(mainMenu);
    case "table":
      return table(mainMenu);
  }
});

async function upload2(f: File): Promise<string> {
  console.log("image uploaded", f)
  return "https://www.datagrove.com/bright_green_circle.png";
}

//export default App

export default AppBare