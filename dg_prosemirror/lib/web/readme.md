The dart way of creating value controllers is problematic for deltas? It's a bit of a waste to keep diffing when we already know the differences.

Althought we might not know the differences in all cases due to race conditions? but in dart we can't really race on the gui thread, because there is only one thread. Still differencing is super useful, even if not quite necessary across isolates.

One super power of differencing is to disentangle the garbage collection. Because the image is getting rebuilt each time, there is no need to coordinate deletions between two isolates.

width might be intrinsic; e.g. for a large map all the grid widths must be the same?
width might be extrinsic; e.g. a spreadsheet.

potentially different classes for these cases.
webgpu looks like a canvas, we can model the canvas in prosemirror.


