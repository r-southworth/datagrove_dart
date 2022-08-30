
import { Fragment,ReactNode } from 'react'
import { Menu, Transition } from '@headlessui/react'
import { EllipsisVerticalIcon,ChevronDownIcon } from '@heroicons/react/24/solid'
import { min } from 'lodash'
function classNames(...classes) {
  return classes.filter(Boolean).join(' ')
}

// in mobile these are just buttons, so no difference.
// and not just string, but rather widgets
export interface MenuItem {
  label: ()=>ReactNode ,   // top level doesn't use this?
  do?: ()=>void ,
  children?: MenuItem[],
}


export default function EditMenu({menu}:{menu: MenuItem[]}) {
  let key = 0;
  const item = (mx: MenuItem) => {
      return (<Menu.Item key={key++}>
            {({ active }) => (
              <a
                onClick={() => mx.do()}
                href="#"
                className={classNames(
                  active ? 'bg-gray-100 text-gray-900' : 'text-gray-700',
                  'block px-4 py-2 text-sm'
                )}
              >
                {mx.label()}
              </a>
            )}
          </Menu.Item>)
  }
  const menu1 = (m1: MenuItem) =>{
    return (<Menu as="div" key={key++} className="relative inline-block text-left">
    <div>
      <Menu.Button className="mr-2">  
        { m1.label() }
      </Menu.Button>
    </div>

    <Transition
      as={Fragment}
      enter="transition ease-out duration-100"
      enterFrom="transform opacity-0 scale-95"
      enterTo="transform opacity-100 scale-100"
      leave="transition ease-in duration-75"
      leaveFrom="transform opacity-100 scale-100"
      leaveTo="transform opacity-0 scale-95"
    >
      <Menu.Items className="origin-top-right absolute right-0 mt-2 w-56 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5 divide-y divide-gray-100 focus:outline-none">
        { m1.children.map((e)=>item(e))}
        </Menu.Items></Transition></Menu>)
  }
    return (<div className='flex'>{
      menu.map((m1)=>m1.children?menu1(m1):item(m1))
    }</div>)
}

const divider = () => (<div className="py-1"></div>)