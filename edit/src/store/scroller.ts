// adapted from https://github.com/GoogleChromeLabs/ui-element-samples/tree/gh-pages/infinite-scroller

// here T is a 
export interface ScrollerSource<T> {
    options: Options,
    createTombstone(): HTMLElement
    render(item: T, div: HTMLElement | undefined | null): HTMLElement
    fetch(begin: number, count: number): Promise<T[]>
}

export class Options {
    fixedHeight = false
    RUNWAY_ITEMS = 50

    // Number of items to instantiate beyond current view in the opposite direction.
    RUNWAY_ITEMS_OPPOSITE = 10

    // The number of pixels of additional length to allow scrolling to.
    SCROLL_RUNWAY = 2000

    // The animation interval (in ms) for fading in content from tombstones.
    ANIMATION_DURATION_MS = 200
}

class Item<T> {
    constructor(public data: T | undefined) { }
    node: HTMLElement | null = null
    height = 0
    width = 0
    top = 0

}
class Anchor {
    index = 0
    offset = 0
}

// we need this to be able to maintain history
// maybe we don't need data, but rather a way to restore the data?
// should we just keep the entire scroller though?
// can we detach the runway?
export class ScrollerState<T> {
    anchorItem: Anchor = { index: 0, offset: 0 };
    data: T[] = []
    scrollRunwayEnd_ = 0
    anchorScrollTop = 0;
}
export class Scroller<T> {
    // what do we gain keeping this? we need to reset all the item nodes anyway
    // maybe this should be a window, and not 0 based.
    // would it be better to use a key directly instead of needing to use integers?
    // fetch( key, endKey, max)

    // itemStart = 0 // invariant compared to anchorItem.index? max(anchorItem.index - 100)?
    // suma's code assumes we can keep an item for everything, start is always 0
    items_: Item<T>[] = [];

    state = new ScrollerState<T>()

    tombstoneSize_ = 0;
    tombstoneWidth_ = 0;
    tombstones_: HTMLElement[] = [];

    firstAttachedItem_ = 0;
    lastAttachedItem_ = 0;


    loadedItems_ = 0;
    requestInProgress_ = false;
    // Create an element to force the scroller to allow scrolling to a certain
    // point.
    scrollRunway_ = document.createElement('div');


    constructor(
        public scroller_: HTMLElement,
        public source_: ScrollerSource<T>,
    ) {
        this.scroller_.addEventListener('scroll', () => this.onScroll_());
        window.addEventListener('resize', () => this.onResize_());
        this.scrollRunway_.textContent = ' ';
        this.scrollRunway_.style.position = 'absolute';
        this.scrollRunway_.style.height = '1px';
        this.scrollRunway_.style.width = '1px';
        this.scrollRunway_.style.transition = 'transform 0.2s';
        this.scroller_.appendChild(this.scrollRunway_);



        this.onResize_();
    }
    back() {
        // last is a tricky idea if we don't know how many there are are.
        // it's also tricky if the runway is not sized to accept all the items.
        // it would be s
        this.state.anchorItem = {
            index: this.items_.length,
            offset: 0
        }
        this.onScroll_()
    }
    updateRunway(curPos: number) {
        const o = this.source_.options;
        this.state.scrollRunwayEnd_ = Math.max(this.state.scrollRunwayEnd_, curPos + o.SCROLL_RUNWAY)
        this.scrollRunway_.style.transform = 'translate(0, ' + this.state.scrollRunwayEnd_ + 'px)';
    }
    // when replacing the state, what do we do with the existing nodes?
    // can we store them as unused, make them invisible and keep with the state?
    // or .remove them? Or =null them?
    replaceState(t: ScrollerState<T>) {
        this.state = t
        this.updateRunway(0)
    }

    onScroll_() {
        var delta = this.scroller_.scrollTop - this.state.anchorScrollTop;

        //Calculates the item that should be anchored after scrolling by delta 
        const calculateAnchoredItem = (initialAnchor: Anchor, delta: number): Anchor => {
            if (delta == 0)
                return initialAnchor;
            delta += initialAnchor.offset;
            var i = initialAnchor.index;
            var tombstones = 0;
            if (delta < 0) {
                while (delta < 0 && i > 0 && this.items_[i - 1].height) {
                    delta += this.items_[i - 1].height;
                    i--;
                }
                tombstones = Math.max(-i, Math.ceil(Math.min(delta, 0) / this.tombstoneSize_));
            } else {
                while (delta > 0 && i < this.items_.length && this.items_[i].height && this.items_[i].height < delta) {
                    delta -= this.items_[i].height;
                    i++;
                }
                if (i >= this.items_.length || !this.items_[i].height)
                    tombstones = Math.floor(Math.max(delta, 0) / this.tombstoneSize_);
            }
            i += tombstones;
            delta -= tombstones * this.tombstoneSize_;
            return {
                index: i,
                offset: delta,
            };
        }

        if (this.scroller_.scrollTop == 0) {
            // Special case, if we get to very top, always scroll to top.
            // this should probably trigger a pullToRefresh? but pull should be on the
            // bottom for chat.
            this.state.anchorItem = { index: 0, offset: 0 };
        } else {
            this.state.anchorItem = calculateAnchoredItem(this.state.anchorItem, delta);
        }

        // how do I change this state when replacing the state?
        // maybe this has to be in the state?
        this.state.anchorScrollTop = this.scroller_.scrollTop;
        var lastScreenItem = calculateAnchoredItem(this.state.anchorItem, this.scroller_.offsetHeight);

        const o = this.source_.options

        // fill sets the range of items which should be attached and attaches those items.
        const fill = (start: number, end: number) => {
            this.firstAttachedItem_ = Math.max(0, start);
            this.lastAttachedItem_ = end;
            this.attachContent();
        }
        if (delta < 0)
            fill(this.state.anchorItem.index - o.RUNWAY_ITEMS, lastScreenItem.index + o.RUNWAY_ITEMS_OPPOSITE);
        else
            fill(this.state.anchorItem.index - o.RUNWAY_ITEMS_OPPOSITE, lastScreenItem.index + o.RUNWAY_ITEMS);
    }

    onResize_() {
        // this just measures the size of a tombstone, then it discards what it knows about item layout; todo!! reuse an existing tombstone instead creating
        var tombstone = this.source_.createTombstone();
        tombstone.style.position = 'absolute';
        this.scroller_.appendChild(tombstone);
        tombstone.classList.remove('invisible');
        this.tombstoneSize_ = tombstone.offsetHeight;
        this.tombstoneWidth_ = tombstone.offsetWidth;
        this.scroller_.removeChild(tombstone);

        // Reset the cached size of items in the scroller as they may no longer be
        // correct after the item content undergoes layout.
        for (var i = 0; i < this.items_.length; i++) {
            this.items_[i].height = this.items_[i].width = 0;
        }
        this.onScroll_();
    }
    // what is the implication of changing the height?
    // if alice "likes" something, we won't scroll every's screen because of anchors.
    // this should be like resize? just set everything to unrendered?
    // 
    invalidate(begin: number, end: number, data: T[]) {
        // if this index is on screen then we need to render. otherwise 
        // there's nothing to do.
        //this.items_[i].data = data
        // we should only rerender this if its 
        // this.source_.render(data, this.items_[i].node)
        for (var i = 0; i < this.items_.length; i++) {
            this.items_[i].height = this.items_[i].width = 0;
        }
        this.onScroll_();
    }

    /**
     * Attaches content to the scroller and updates the scroll position if
     * necessary.
     */

    async attachContent() {
        const o = this.source_.options
        // Collect nodes which will no longer be rendered for reuse.
        // TODO: Limit this based on the change in visible items rather than looping
        // over all items.
        var i;
        var unusedNodes: HTMLElement[] = [];
        const unused = function (): HTMLElement | undefined {
            return unusedNodes.pop()
        }
        for (i = 0; i < this.items_.length; i++) {
            // Skip the items which should be visible.
            if (i == this.firstAttachedItem_) {
                i = this.lastAttachedItem_ - 1;
                continue;
            }
            let n = this.items_[i].node
            if (n) {
                if (n.classList.contains('tombstone')) {
                    this.tombstones_.push(n);
                    this.tombstones_[this.tombstones_.length - 1].classList.add('invisible');
                } else {
                    unusedNodes.push(n);
                }
            }
            this.items_[i].node = null;
        }

        var tombstoneAnimations = new Map<number, [HTMLElement, number]>()
        // Create DOM nodes.
        for (i = this.firstAttachedItem_; i < this.lastAttachedItem_; i++) {
            while (this.items_.length <= i)
                this.addItem_(undefined);
            let n = this.items_[i].node
            if (n) {
                // if it's a tombstone but we have data, replace it.
                if (n.classList.contains('tombstone') &&
                    this.items_[i].data) {
                    // TODO: Probably best to move items on top of tombstones and fade them in instead.
                    if (o.ANIMATION_DURATION_MS) {
                        n.style.zIndex = "1";
                        tombstoneAnimations.set(i, [n, this.items_[i].top - this.state.anchorScrollTop])
                    } else {
                        n.classList.add('invisible');
                        this.tombstones_.push(n);
                    }
                    this.items_[i].node = null;
                } else {
                    continue;
                }
            }
            let d = this.items_[i].data
            const getTombstone = () => {
                var tombstone = this.tombstones_.pop();
                if (tombstone) {
                    tombstone.classList.remove('invisible');
                    tombstone.style.opacity = "1";
                    tombstone.style.transform = '';
                    tombstone.style.transition = '';
                    return tombstone;
                }
                return this.source_.createTombstone();
            }
            var node = d ? this.source_.render(d, unused()) : getTombstone();
            // Maybe don't do this if it's already attached?
            node.style.position = 'absolute';
            this.items_[i].top = -1;
            this.scroller_.appendChild(node);
            this.items_[i].node = node;
        }

        // Remove all unused nodes
        while (unusedNodes.length) {
            let u = unusedNodes.pop()
            if (u)
                this.scroller_.removeChild(u);
        }

        // Get the height of all nodes which haven't been measured yet.
        for (i = this.firstAttachedItem_; i < this.lastAttachedItem_; i++) {
            // Only cache the height if we have the real contents, not a placeholder.
            let n = this.items_[i].node
            if (!n) continue;
            if (this.items_[i].data && !this.items_[i].height) {
                this.items_[i].height = n.offsetHeight;
                this.items_[i].width = n.offsetWidth;
            }
        }

        // Fix scroll position in case we have realized the heights of elements
        // that we didn't used to know.
        // TODO: We should only need to do this when a height of an item becomes
        // known above.
        this.state.anchorScrollTop = 0
        for (i = 0; i < this.state.anchorItem.index; i++) {
            this.state.anchorScrollTop += this.items_[i].height || this.tombstoneSize_
        }
        this.state.anchorScrollTop += this.state.anchorItem.offset

        // Position all nodes.
        var curPos = this.state.anchorScrollTop - this.state.anchorItem.offset
        i = this.state.anchorItem.index
        while (i > this.firstAttachedItem_) {
            curPos -= this.items_[i - 1].height || this.tombstoneSize_
            i--
        }
        while (i < this.firstAttachedItem_) {
            curPos += this.items_[i].height || this.tombstoneSize_;
            i++
        }
        // Set up initial positions for animations.
        for (let [i, anim] of tombstoneAnimations) {
            let n = this.items_[i].node
            if (!n) continue
            n.style.transform = 'translateY(' + (this.state.anchorScrollTop + anim[1]) + 'px) scale(' + (this.tombstoneWidth_ / this.items_[i].width) + ', ' + (this.tombstoneSize_ / this.items_[i].height) + ')';
            // Call offsetTop on the nodes to be animated to force them to apply current transforms.
            n.offsetTop
            anim[0].offsetTop
            n.style.transition = 'transform ' + o.ANIMATION_DURATION_MS + 'ms';
        }
        for (i = this.firstAttachedItem_; i < this.lastAttachedItem_; i++) {
            const anim: undefined | [HTMLElement, number] = tombstoneAnimations.get(i)
            if (anim) {
                anim[0].style.transition = 'transform ' + o.ANIMATION_DURATION_MS + 'ms, opacity ' + o.ANIMATION_DURATION_MS + 'ms'
                anim[0].style.transform = 'translateY(' + curPos + 'px) scale(' + (this.items_[i].width / this.tombstoneWidth_) + ', ' + (this.items_[i].height / this.tombstoneSize_) + ')'
                anim[0].style.opacity = "0"
            }
            let n = this.items_[i].node
            if (n && curPos != this.items_[i].top) {

                if (!anim)
                    n.style.transition = ''
                n.style.transform = 'translateY(' + curPos + 'px)'
            }
            this.items_[i].top = curPos
            curPos += this.items_[i].height || this.tombstoneSize_
        }

        // this monotonically increases the runway.
        this.updateRunway(curPos)
        this.scroller_.scrollTop = this.state.anchorScrollTop;

        const fn = () => {
            for (let [i, v] of tombstoneAnimations) {
                var anim = tombstoneAnimations.get(i)
                if (!anim) continue
                anim[0].classList.add('invisible')
                this.tombstones_.push(anim[0])
                // Tombstone can be recycled now.
            }
        }
        if (o.ANIMATION_DURATION_MS) {
            // TODO: Should probably use transition end, but there are a lot of animations we could be listening to.
            setTimeout(fn, o.ANIMATION_DURATION_MS)
        }

        //this.maybeRequestContent()
        // Don't issue another request if one is already in progress as we don't
        // know where to start the next request yet.
        let itemsNeeded = this.lastAttachedItem_ - this.loadedItems_;
        if (!this.requestInProgress_ && itemsNeeded > 0) {
            this.requestInProgress_ = true;
            const addContent = (items: T[]) => {
                for (var i = 0; i < items.length; i++) {
                    if (this.items_.length <= this.loadedItems_)
                        this.addItem_(items[i]);
                    this.items_[this.loadedItems_++].data = items[i];
                }
                this.attachContent();
            }
            let mc = await this.source_.fetch(this.loadedItems_, this.loadedItems_ + itemsNeeded)
            addContent(mc)
            this.requestInProgress_ = false;
        }
    }


    addItem_(x: T | undefined) {
        this.items_.push(new Item(x))
    }

}

