// adapted from https://github.com/GoogleChromeLabs/ui-element-samples/tree/gh-pages/infinite-scroller

// simplified by making the call responsible for replacing data asynchronously?
// 

import { createRoot } from 'react-dom/client'
type Builder = (index: number, div?: HTMLElement | undefined) => HTMLElement;

interface Options {
    fixedHeight?: boolean
    container: HTMLElement,
    builder: Builder,
    tombstone: HTMLElement,
    length: number
}

// index is given to builder to build the dom. inf indicates nto as
const inf = Number.NEGATIVE_INFINITY
class Item {
    constructor(public node?: HTMLElement | null) { }
    index = inf
    height = 0
    width = 0
    top = 0

    get active(): boolean { return this.index != inf };
}

// index is the top visible item, offset is how far scroll off the top it is (0 is flush to top)
class Anchor {
    index = 0
    offset = 0
}

export class Scroller {
    RUNWAY_ITEMS = 50

    // Number of items to instantiate beyond current view in the opposite direction.
    RUNWAY_ITEMS_OPPOSITE = 10

    // The number of pixels of additional length to allow scrolling to.
    SCROLL_RUNWAY = 2000

    // The animation interval (in ms) for fading in content from tombstones.
    ANIMATION_DURATION_MS = 200

    constructor(public options: Options) {
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
    get scroller_() { return this.options.container }

    items_: Item[] = [];

    addItem_() {
        // this should call the builder
        this.items_.push(new Item(this.options.builder(this.items_.length)))
        // this.items_.push(new Item(x))
    }

    anchorItem: Anchor = { index: 0, offset: 0 };
    scrollRunwayEnd_ = 0
    anchorScrollTop = 0;

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


    back() {
        this.anchorItem = {
            index: this.options.length - 1,
            offset: 0
        }
        this.onScroll_()
    }
    updateRunway(curPos: number) {
        const o = this.options;
        this.scrollRunwayEnd_ = Math.max(this.scrollRunwayEnd_, curPos + this.SCROLL_RUNWAY)
        this.scrollRunway_.style.transform = 'translate(0, ' + this.scrollRunwayEnd_ + 'px)';
    }

    onScroll_() {
        var delta = this.scroller_.scrollTop - this.anchorScrollTop;

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
            this.anchorItem = { index: 0, offset: 0 };
        } else {
            this.anchorItem = calculateAnchoredItem(this.anchorItem, delta);
        }

        // how do I change this state when replacing the state?
        // maybe this has to be in the state?
        this.anchorScrollTop = this.scroller_.scrollTop;
        var lastScreenItem = calculateAnchoredItem(this.anchorItem, this.scroller_.offsetHeight);

        const o = this.options

        // fill sets the range of items which should be attached and attaches those items.
        const fill = (start: number, end: number) => {
            this.firstAttachedItem_ = Math.max(0, start);
            this.lastAttachedItem_ = end;
            this.attachContent();
        }
        if (delta < 0)
            fill(this.anchorItem.index - this.RUNWAY_ITEMS, lastScreenItem.index + this.RUNWAY_ITEMS_OPPOSITE);
        else
            fill(this.anchorItem.index - this.RUNWAY_ITEMS_OPPOSITE, lastScreenItem.index + this.RUNWAY_ITEMS);
    }

    createTombstone() {
        return this.options.tombstone.cloneNode() as HTMLElement;
    }
    onResize_() {
        // this just measures the size of a tombstone, then it discards what it knows about item layout; todo!! reuse an existing tombstone instead creating
        var tombstone = this.createTombstone()
        tombstone.style.position = 'absolute'
        this.scroller_.appendChild(tombstone)
        tombstone.classList.remove('invisible')
        this.tombstoneSize_ = tombstone.offsetHeight
        this.tombstoneWidth_ = tombstone.offsetWidth
        this.scroller_.removeChild(tombstone)

        // Reset the cached size of items in the scroller as they may no longer be
        // correct after the item content undergoes layout.
        for (var i = 0; i < this.items_.length; i++) {
            this.items_[i].height = this.items_[i].width = 0
        }
        this.onScroll_()
    }

    // what is the implication of changing the height?
    // if alice "likes" something, we won't scroll every's screen because of anchors.
    // this should be like resize? just set everything to unrendered?
    // 
    invalidate(begin: number, end: number, data: Item[]) {
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
        const o = this.options
        // Collect nodes which will no longer be rendered for reuse.
        // TODO: Limit this based on the change in visible items rather than looping
        // over all items.
        var i
        var unusedNodes: HTMLElement[] = [];
        const unused = function (): HTMLElement | undefined {
            return unusedNodes.pop()
        }
        for (i = 0; i < this.items_.length; i++) {
            // Skip the items which should be visible.
            if (i == this.firstAttachedItem_) {
                i = this.lastAttachedItem_ - 1;
                continue
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
                this.addItem_()
            let n = this.items_[i].node
            if (n) {
                // if it's a tombstone but we have data, replace it.
                if (n.classList.contains('tombstone') &&
                    this.items_[i].active) {
                    // TODO: Probably best to move items on top of tombstones and fade them in instead.
                    if (this.ANIMATION_DURATION_MS) {
                        n.style.zIndex = "1"
                        tombstoneAnimations.set(i, [n, this.items_[i].top - this.anchorScrollTop])
                    } else {
                        n.classList.add('invisible')
                        this.tombstones_.push(n)
                    }
                    this.items_[i].node = null
                } else {
                    continue;
                }
            }
            const getTombstone = () => {
                var tombstone = this.tombstones_.pop()
                if (tombstone) {
                    tombstone.classList.remove('invisible')
                    tombstone.style.opacity = "1"
                    tombstone.style.transform = ''
                    tombstone.style.transition = ''
                    return tombstone;
                }
                return this.createTombstone();
            }
            let d = this.items_[i].index
            var node = d ? this.options.builder(d, unused()) : getTombstone();
            // Maybe don't do this if it's already attached?
            node.style.position = 'absolute'
            this.items_[i].top = -1
            this.scroller_.appendChild(node)
            this.items_[i].node = node
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
            if (this.items_[i].active && !this.items_[i].height) {
                this.items_[i].height = n.offsetHeight;
                this.items_[i].width = n.offsetWidth;
            }
        }

        // Fix scroll position in case we have realized the heights of elements
        // that we didn't used to know.
        // TODO: We should only need to do this when a height of an item becomes
        // known above.
        this.anchorScrollTop = 0
        for (i = 0; i < this.anchorItem.index; i++) {
            this.anchorScrollTop += this.items_[i].height || this.tombstoneSize_
        }
        this.anchorScrollTop += this.anchorItem.offset

        // Position all nodes.
        var curPos = this.anchorScrollTop - this.anchorItem.offset
        i = this.anchorItem.index
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
            n.style.transform = 'translateY(' + (this.anchorScrollTop + anim[1]) + 'px) scale(' + (this.tombstoneWidth_ / this.items_[i].width) + ', ' + (this.tombstoneSize_ / this.items_[i].height) + ')';
            // Call offsetTop on the nodes to be animated to force them to apply current transforms.
            n.offsetTop
            anim[0].offsetTop
            n.style.transition = 'transform ' + this.ANIMATION_DURATION_MS + 'ms';
        }
        for (i = this.firstAttachedItem_; i < this.lastAttachedItem_; i++) {
            const anim: undefined | [HTMLElement, number] = tombstoneAnimations.get(i)
            if (anim) {
                anim[0].style.transition = 'transform ' + this.ANIMATION_DURATION_MS + 'ms, opacity ' + this.ANIMATION_DURATION_MS + 'ms'
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
        this.scroller_.scrollTop = this.anchorScrollTop;

        const fn = () => {
            for (let [i, v] of tombstoneAnimations) {
                var anim = tombstoneAnimations.get(i)
                if (!anim) continue
                anim[0].classList.add('invisible')
                this.tombstones_.push(anim[0])
                // Tombstone can be recycled now.
            }
        }
        if (this.ANIMATION_DURATION_MS) {
            // TODO: Should probably use transition end, but there are a lot of animations we could be listening to.
            setTimeout(fn, this.ANIMATION_DURATION_MS)
        }

        //this.maybeRequestContent()
        // Don't issue another request if one is already in progress as we don't
        // know where to start the next request yet.
        let itemsNeeded = this.lastAttachedItem_ - this.loadedItems_;
        if (!this.requestInProgress_ && itemsNeeded > 0) {
            this.requestInProgress_ = true;
            const addContent = (items: Item[]) => {
                for (var i = 0; i < items.length; i++) {
                    if (this.items_.length <= this.loadedItems_) { }//this.addItem_(items[i]);
                    //this.items_[this.loadedItems_++].data = items[i];
                }
                this.attachContent();
            }
            // let mc = await this.source_.fetch(this.loadedItems_, this.loadedItems_ + itemsNeeded)
            //addContent(mc)
            this.requestInProgress_ = false;
        }
    }
}



//renderToStaticMarkup?
export function dom(o: JSX.Element) {
    let d = document.createElement("div")
    createRoot(d).render(o)
    return d
}


/*
    //Attaches content to the scroller and updates the scroll position if necessary.
    render() {
        const x: RenderInfo<T> = this.source_.data
        let unused = this.collectTombstones(x.unused)
        const o = this.source_.options
        const anchor = x.anchor - x.begin

        // maybe this returns items, unused. 
        // then we could loop through creating new elements as necessary
        // let [fdata, height, items, unused] = this.source_.data.data
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

        // render all the nodes. create an animation for each tombstone being replaced by data.
        var tombstoneAnimations = new Map<number, [HTMLElement, number]>()
        for (let i = 0; i < x.data.length; i++) {
            let nd = x.item[i].node
            let data = x.data[i]
            if (nd) {
                // if it's a tombstone but we have data, delete the tombstone.
                // if the data has changed, replace it.
                let replace = data && this.isTombstone(nd)
                if (replace) {
                    // TODO: Probably best to move items on top of tombstones and fade them in instead.
                    if (o.ANIMATION_DURATION_MS) {
                        nd.style.zIndex = "1";
                        tombstoneAnimations.set(i, [nd, x.item[i].top]) // - this.anchorScrollTo
                    } else {
                        nd.classList.add('invisible');
                        this.tombstones_.push(nd);
                    }
                    x.item[i].node = null;
                } else {
                    // here there was a node, but there is no data, so keep the tombstone.
                    continue;
                }
            }

            // if the data is valid, then render it. Otherwise render a tombstone.
            let d = x.data[i]
            if (d !== x.item[i].data) {
                var node = d ? this.source_.render(d, unused.pop()) : getTombstone();
                node.style.position = 'absolute';
                x.item[i].top = -1; // note that we don't need to set this prior to calling attach.
                this.scroller_.appendChild(node);
                x.item[i].node = node;
                x.item[i].data = d
                x.item[i].height = 0
            }
        }

        // Remove all unused nodes; why not make them invisible.
        while (unused.length) {
            let u = unused.pop()
            if (u)
                this.scroller_.removeChild(u);
        }

        // Get the height of all nodes which haven't been measured yet at once (no thrashing)
        let countMeasured = false
        for (let i = 0; i < x.data.length; i++) {
            let n = x.item[i].node
            // this checks that there is data, a node, and the height is currently 0
            // this will keep tombstones at 0 height, so we must check for that.
            if (n && x.item[i].data && !x.item[i].height) {
                x.item[i].height = n.offsetHeight;
                x.item[i].width = n.offsetWidth;
                countMeasured = true
            }
        }

        // so there is odd thing where subtracts the anchorScrollTop from top to create
        // tombstone animation, but then he recalculates anchorScrollTop and adds that back
        // to the animation top.
        // Fix scroll position in case we have realized the heights of elements
        // that we didn't used to know.
        // anchorScrollTop = sum(height of item) where item < anchor  + anchor.offset
        // note that this is all items - ugh!
        // what if they lose their size? what if we don't know their size?
        // what does this do on a resize? Maybe it doesn't matter because we 
        // are only measuring attachedContent?
        // we are setting anchorScrollTop to 0 here?

        // anchorScrollTop moves here because of the invisble things rendered above the anchor
        let anchorScrollTop = x.anchorTop + x.anchorOffset
        for (let i = 0; i < x.anchor; i++) {
            anchorScrollTop += x.item[i].height || x.tombstoneHeight
        }
        let deltaTop = anchorScrollTop - this.scroller_.scrollTop;

        // Set up initial positions for animations.
        for (let [i, anim] of tombstoneAnimations) {
            let n = x.item[i].node
            if (!n) continue

            // this need to subtract out the old anchorScollTop 
            const scale = (x.tombstoneWidth / x.item[i].width) + ', ' + (x.tombstoneHeight / x.item[i].height)
            const translateY = (deltaTop + anim[1])
            n.style.transform = 'translateY(' + translateY + 'px) scale(' + scale + ')';
            n.offsetTop  // Call offsetTop on the nodes to be animated to force them to apply current transforms.
            anim[0].offsetTop
            n.style.transition = 'transform ' + o.ANIMATION_DURATION_MS + 'ms';
        }

        // this animates all the items into position
        // Position all nodes. curPos with the position of the anchor item.
        // curPos should be
        let curPos = x.anchorTop
        // we need to subtract out the invisible items over the anchor.
        let i = x.anchor
        while (i > x.begin) {
            curPos -= x.item[i - 1].height || x.tombstoneHeight
            i--
        }

        for (let i = 0; i < x.data.length; i++) {
            const anim: undefined | [HTMLElement, number] = tombstoneAnimations.get(i)
            if (anim) {
                anim[0].style.transition = 'transform ' + o.ANIMATION_DURATION_MS + 'ms, opacity ' + o.ANIMATION_DURATION_MS + 'ms'
                anim[0].style.transform = 'translateY(' + curPos + 'px) scale(' + (x.item[i].width / x.tombstoneWidth) + ', ' + (x.item[i].height / x.tombstoneHeight) + ')'
                anim[0].style.opacity = "0"
            }
            let n = x.item[i].node
            if (n && curPos != x.item[i].top) {

                if (!anim)
                    n.style.transition = ''
                n.style.transform = 'translateY(' + curPos + 'px)'
            }
            x.item[i].top = curPos
            curPos += x.item[i].height || x.tombstoneHeight
        }

        if (o.ANIMATION_DURATION_MS) {
            // TODO: Should probably use transition end, but there are a lot of animations we could be listening to.
            setTimeout(() => {
                for (let [i, v] of tombstoneAnimations) {
                    var anim = tombstoneAnimations.get(i)
                    if (!anim) continue
                    anim[0].classList.add('invisible')
                    this.tombstones_.push(anim[0])
                    // Tombstone can be recycled now.
                }
            }, o.ANIMATION_DURATION_MS)
        }

        this.scrollRunway_.style.transform = 'translate(0, ' + x.runwayLength(curPos) + 'px)';
        this.scroller_.scrollTop = anchorScrollTop;
        x.anchorTop = anchorScrollTop
    }*/