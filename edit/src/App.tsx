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
// ChevronDownIcon, ChevronUpIcon, XIcon,
enum Mode {
  Normal,
  Search,
  Replace,
}

function AppBare() {
  return <Editor theme={dark} className='editor dark:prose-invert prose max-w-none'
    defaultValue={store.editorValue}
    placeholder="..." autoFocus />
}

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

  // unlike original we are not hiding the prosemirror; built it here, pass it to
  // the

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

// how do we imitate placeholder?
function ChatEditor() {
  return (<div>

  </div>)
}


function App() {
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

      <Editor theme={dark} className='editor dark:prose-invert prose max-w-none'
        defaultValue={store.editorValue}
        placeholder="..." autoFocus />

      <div className="appFooter flex">
          <Editor theme={dark} className=' chatEditor dark:prose-invert prose max-w-none'
        defaultValue={store.editorValue}
        placeholder="..." autoFocus />
        
        <div className="grow" />
        <EditMenu menu={mainMenu} />
      </div>
    </div>)
}

export default App

/*
 <button onClick={store.done}><PlusCircleIcon className='h-6 w-6 mr-2' /></button>
 */