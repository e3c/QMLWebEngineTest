.pragma library

function CacheEntry() {
    this.inUse = false;
    this.item = null;
}

var cache = [];

function init(size, factory, root) {
    for (var i = 0; i < size; i++) {
        var ce = new CacheEntry();
        ce.item = factory.createObject(root);
        cache.push(ce);
    }
}

function fetch() {
    for (var i = 0; i < cache.length; i++) {
        var ce = cache[i];
        if (ce.inUse === false) {
            ce.inUse = true;
            console.log("Found unused cache item", i, ce.item);
            return ce.item;
        }
    }
    console.log("No free cache item found");
    return null;
}

function release(item) {
    for (var i = 0; i < cache.length; i++) {
        var ce = cache[i];
        if (ce.item === item) {
            ce.inUse = false;
            console.log("Released cache item", i, ce.item);
            return;
        }
    }
    console.log("Unknown cache item", item);
}
