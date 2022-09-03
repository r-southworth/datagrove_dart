import { Scroller, Options, ScrollerSource } from './scroller'
import { faker } from '@faker-js/faker'



function setText(div: HTMLElement, query: string, v: string) {
    let e = div.querySelector(query) as HTMLElement
    if (!e) {
        throw query
    }
    e.textContent = v;
}
function setSrc(div: HTMLElement, query: string, v: string) {
    //document.getElementById(query).style.backgroundImage=`url($v)`; 
    let e = div.querySelector(query) as HTMLImageElement
    e.src = v
}
export class Chat {
    id = 0
    text = ""
    image = ""
    time = Date()
    height = 0
    width = 0
    me = false
}

export function MakeChat(count: number) {

    let message: Chat[] = []
    for (let i = 0; i != count; i++) {
       const who = faker.datatype.number(1) == 0    
       message[i] = {
            id: i,
            text: faker.lorem.paragraph(1),
            image: who?'user-robot.svg':'user-doctor.svg',
            height: 0,
            width: 0,
            time: Date(),
            me: who
        }
    }
    return message
}
export class TestSource implements ScrollerSource<Chat>{
    tombstone
    template
    options
    message: Chat[] = []
    constructor(count: number) {
        this.options = new Options
        this.tombstone = document.querySelector("#templates > .chat-item.tombstone") as Node
        setSrc(this.tombstone as HTMLElement, '.avatar', 'user-robot.svg')
        this.template = document.querySelector("#templates > .chat-item:not(.tombstone)") as Node
        this.message = MakeChat(count)
    }


    async fetch(start: number, end: number): Promise<Chat[]> {
        if (start > this.message.length) {
            return []
        }
        start = Math.max(start, 0)
        end = Math.min(this.message.length, end)
        return this.message.slice(start, end)
    }
    createTombstone(): HTMLElement {
        return this.tombstone.cloneNode(true) as HTMLElement
    }
    render(item: Chat, div: HTMLElement | undefined): HTMLElement {
        div = div || this.template.cloneNode(true) as HTMLElement
        div.dataset.id = "asdf" + item.id;
        setSrc(div, '.avatar', item.image)
        setText(div, '.bubble p', item.text)
        setText(div, '.bubble .posted-date', item.time.toString())

        var img = div.querySelector('.bubble img') as HTMLImageElement
        if (img) {
            if (item.image !== '') {
                img.classList.remove('invisible');
                img.src = item.image
                img.width = item.width;
                img.height = item.height;
            } else {
                img.src = '';
                img.classList.add('invisible');
            }
        }

        if (item.me) {
            div.classList.add('from-me');
        } else {
            div.classList.remove('from-me');
        }
        return div;
    }
}

