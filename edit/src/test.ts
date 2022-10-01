// I think the css always has to be imported separately by the user?
// what does tailwind do to us here?  how do I wrap all this css up into one?
import './index.css'
import 'katex/dist/katex.css'
import './App.css'

import { mountEditor } from './api'


let v = `
# one !!

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

function prosemirror (element: HTMLElement)  {
  mountEditor(element, v, (x) => {
    console.log(x)
  })
}
globalThis.prosemirror = prosemirror;

if (document.getElementById('root')){
  prosemirror(document.getElementById('root'));
}