import { EditorState, Transaction } from "prosemirror-state"
import { createRoot, Root } from "react-dom/client"
import Editor from "../editor"
import { dark } from '../editor/styles/theme';


  
// create a canvas of divs that we can transform, style, set prosemirror into.
interface Controller {

}
class SocketController implements Controller {
    constructor(public ws: WebSocket|undefined) {

    }


    static connect() {
        var cn = new WebSocket("http://localhost/8033");
        var controller = new SocketController(undefined);

        var x = new Canvas(document.getElementById('tablePane'), controller);

        // every call is a div, but the host doesn't know how large to make it.
        // after we resize we might need to report back.

        cn.onmessage = (ev: MessageEvent) => {

        }

    }
}

class Style {
    key = ""
    value = ""
}
class Cell {
    index = 0
    x = 0;
    y = 0;
    width = 0;

    className = ""
    style: Style[] = []
    // keep both so we don't need to translate every cell.
    innerHtml = ""
    pmdoc = ""

}


class Canvas {
    // use row so we can handle height 
    // we have update a row at a time, then measure.
    // the downside is that we need to 
    el: HTMLElement[] = []
    cell: Cell[] = []
    emptyCell: HTMLElement

    // are supposed to call createRoot once, so keep an editor around
    editor : HTMLElement | undefined
    root: Root

    constructor(public ref: HTMLElement, public controller: Controller) {
        
        this.emptyCell = document.getElementById('cell0');
        this.increaseSize(1);
        this.editor = document.getElementById('cellEditor')
        this.root = createRoot(this.editor)

        let handle = (x: string) => (event: PointerEvent ) => {
            if (event.target instanceof Element){
                //console.log(`${x} ${event.target.id}`)
            }
        }
    
        let el = this.ref
        el.click = ( ) => { }
        el.onpointerover = handle('over');
        el.onpointerenter = handle('enter');
        el.onpointerdown = handle('down');
        el.onpointermove = handle('move');
        el.onpointerup = handle('up');
        el.onpointercancel = handle('cancel');
        el.onpointerout = handle('out');
        el.onpointerleave = handle('leave');
        el.ongotpointercapture = handle('capture');
        el.onlostpointercapture = handle('lost');
        el.ondblclick = (event: PointerEvent)=>{
            this.startEditor(0)
        }
    }

    startEditor(index: number) {
        var div = this.cell[index];
        console.log(index, div)
        // we need to 
        this.editor.style.transform = `translate(${div.x}px, ${div.y}px)`
        this.editor.style.width = `${div.width}px`

        this.root.render(<Editor theme={dark} className=' chatEditor dark:prose-invert prose max-w-none'
        defaultValue={div.innerHtml}
        placeholder="..." autoFocus />)
    }
    increaseSize(n: number) {
        for (let i = 0; i < n; i++) {
            var d = this.emptyCell.cloneNode(true) as HTMLElement;
            d.id = `${this.el.length}`
            this.el.push(d);
            this.ref.appendChild(d);
           
        }
        this.cell.length = this.el.length
    }

    edit(cell: number) {
        // mount a prosemirror editor over the
    }

    // when ever we 
    // how do we animate moving cells?
    update(cell: Cell[]) : number[] {
        var height : number[] = []
        height.length = cell.length
        for (let div of cell) {
            if (div.index >= this.el.length) {
                this.increaseSize(100)
            }
            let d = this.el[div.index]
            this.cell[div.index] = div
            console.log(div, d)
            d.style.transform = `translate(${div.x}px, ${div.y}px)`
            d.style.width = `${div.width}px`
            d.style.display = div.width==0?'none':'block'
            if (div.className) {
                d.className = div.className
            }
            if (div.innerHtml) {
                d.innerHTML = div.innerHtml
            }
            for (let i in div.style){
                d.style[div[div.style[i].key]] = div.style[i].value;
            }
        }

        // we want to measure  once because this will block the layout.
        // we should use containers to let this layout in parallel
        for (let i in cell) {
            height[i] = this.el[cell[i].index].clientHeight;
        }
        return height
    }
}

class TestController {

}
export function test() {
    let x = new TestController()
    let ref = document.getElementById('tablePane')
    let table = new Canvas(ref,x)

    var h = table.update([
         { 
            index: 0,
            x: 100,
            y: 0,
            width: 100,
            innerHtml: "cell 0"
         } ,
         { 
            index: 1,
            x: 200,
            y: 0,
            width: 100,
            innerHtml: "cell 1"
         } ,
         { 
            index: 2,
            x: 100,
            y: 100,
            width: 100,
            innerHtml: "cell 2"
         } ,
    ] as Cell[]

    )
    console.log(h)


}
