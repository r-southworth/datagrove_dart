import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './index.css'
import { Scroller, dom } from './scroller'
import { faker } from '@faker-js/faker'

// need to make this more general, just dom.
export class Chat {
  id = 0
  text = ""
  image = ""
  time = Date()
  height = 0
  width = 0
  me = false
}
  let message: Chat[] = []
  for (let i = 0; i != 200; i++) {
    const who = faker.datatype.number(1) == 0
    message[i] = {
      id: i,
      text: faker.lorem.paragraph(1),
      image: who ? 'user-robot.svg' : 'user-doctor.svg',
      height: 0,
      width: 0,
      time: Date(),
      me: who
    }
  }

// what about an api to 
type UpdateChat = (x: any) => void
export function testChat(root: HTMLElement) {



  const scroller = new Scroller({
    container: root,
    length: message.length,

    builder: (index: number, div: HTMLElement | undefined): HTMLElement => {
      if (div == null) {
        div = dom(<li className="chat-item" data-id="{{id}}">
          <div className="avatar"></div>
          <div className="bubble">
            <p></p>
            <img width="300" height="300" />
            <div className="meta">
              <time className="posted-date"></time>
            </div>
          </div>
        </li>);
      }
      // we should potentially use react editing instead of these querySelectors
      function setSrc(div: HTMLElement, query: string, v: string) {
        //document.getElementById(query).style.backgroundImage=`url($v)`; 
        let e = div.querySelector(query) as HTMLImageElement
        e.src = v
      }
      function setText(div: HTMLElement, query: string, v: string) {
        let e = div.querySelector(query) as HTMLElement
        if (!e) {
          throw query
        }
        e.textContent = v;
      }

      let item = message[index]
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
  },

    tombstone: dom(
      <li className="chat-item tombstone" data-id="{{id}}">
        <img className="avatar" src="user-robot.svg" />
        <div className="bubble">
          <p></p>
          <p></p>
          <p></p>
          <div className="meta">
            <time className="posted-date"></time>
          </div>
        </div>
      </li>)

  }
  )

// idea here is to return a pipe to feed updates to. 
return (x: any) => {
}
}

ReactDOM.createRoot(document.getElementById('root') as HTMLElement).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
)
