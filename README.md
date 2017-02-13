# WhackARuby

This is a simple desktop game I built with ruby and the Gosu library.

The rules are rather simple:

1. Hit the rubies.
2. Don't hit the emeralds.
3. Don't miss.

When you hit a ruby, the screen will flash green and your score will increase by 5.
If you miss all the rubies, the screen will flash red and your score will decrease by 1.
If you hit an emerald, the screen will flash purple and your score will decrease by 5.

If you wish the play, clone this repo to your machine and run bundle:

`bundle install`

to download the Gosu gem in case you don't already have it.
Afterwards, it's as easy as running:

`ruby whack.rb`

in your Terminal/console.
