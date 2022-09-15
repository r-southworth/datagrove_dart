import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import Editor from "./editor"

//import { store } from "./store"
import { dark } from './editor/styles/theme';
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



export function downloadString(filename: string, text: string) {
  var element = document.createElement('a');
  element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
  element.setAttribute('download', filename);

  element.style.display = 'none';
  document.body.appendChild(element);

  element.click();

  document.body.removeChild(element);
}



