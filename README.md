# haxetris
Tetris in haxe

Written with help from OpenFL.

I know there are other Tetris clones out there, and they are much smoother and possibly more stable.
But I wanted to reimagine what the code would look like for this game.

I mostly wrote this game because I wanted to write one of these for a long time, and OpenFL is awesome for
basic games like this.

A few things are missing or not handled well - 

~Rotating a block while it's at the right of the screen causes the rotation to fail since the block can't
be rotated and fit into the same space - This would be better handled by displacing the block instead of blocking the rotation.~
Made some slight improvements to this, but it's still not perfect.

Frame skipping is used to get a playable experience - This would be better handled by interpolating motion over frames.

~Currently a block is only moved during a frame update - this is jarring, it should be moved continuously.~
Fixed - key input is pushed to a queue, using the down arrow will try to move the block down faster.

Better handling of a 'Game Over' scenario would be beneficial, especially for edge cases.

~Maybe adding some music would be nice.~
Got some music in there now, so it's a bit less boring to play.

Adding fancy graphics can be left as an exercise to the user - there are distinct screens, so it should be straightforward
for anyone wanting to fork the code to add in their own pretty images.

Mostly OOP - some procedural stuff thrown in, strives to use MVC where beneficial.

Has unit tests, using Munit (Massive Unit) - these can be run with the following command:
haxelib run munit test

The unit depend on the hamcrest and munit libraries, so use haxelib to add those:
haxelib install munit
haxelib install hamcrest

I had some ideas about publish/subscribe for moving the blocks - but having a controller leads to simpler code and easier
debugging for all involved - as much as I would have liked to add in my newfangled notifier class, there's just no need for it.

<a href="http://www.shaheedabdol.co.za/haxetris/">Can be viewed live here.</a>
